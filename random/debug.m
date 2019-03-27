%% ���ļ�
clear ;
close all;
home;

bFig = true;
%% Initialize
load("kobe32_cacti.mat") % orig,meas,mask��ԭʼͼ��ѹ��ͼ��ѹ��ʱ�õ�mask
test_data = 1; % meas֡��

% ͼ��ĳ���λ�ã�nΪ��Ĵ�С
x_1 = 1;
x_2 = 128;
y_1 = 1;
y_2 = 128;
n = 128;

x_1 = 65;
x_2 = 128;
y_1 = 65;
y_2 = 128;
n = 64;

x_1 = 65;
x_2 = 96;
y_1 = 97;
y_2 = 128;
n = 32;

x_1 = 81;
x_2 = 96;
y_1 = 97;
y_2 = 112;
n = 16;

from_which = 0;
codedNum = 1; % ����֡ѹ����һ֡����kobe������8
% ����ʹ�õ�ͶӰ���y������ͶӰ����ֱ�Ӷ�ԭʼͼ�����ͶӰ�õ���
for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(x_1:x_2,y_1:y_2,(k-1)*codedNum+1+from_which:(k-1)*codedNum+codedNum+from_which);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    if ~bOrig
        bTest = false;
    end
    M = mask(x_1:x_2,y_1:y_2,1:codedNum);
    captured = meas(x_1:x_2,y_1:y_2,k);
    L       = 30000; % ͶӰ��Խ�󣬻ָ�Ч��Խ��
    s       = 2; % sԽС��ͶӰ�����еķ���Ԫ��Խ��
    niter   = 1; % ͶӰ������֮��ȡ����
    bTest = false;
%% Debug
    % estimate
    N = n*n;
    psi = fourier_full(n);
    estimated_theta = zeros(N*codedNum,1);
    % ��iteration�Σ���ȡ����
    for ite = 1:niter
        disp(ite)
        % �����ʼ��Phi��Ӧ��������֪��mask���ɣ������Ȳ��������һ��
        if bTest % ʹ����ȫ������ɵĲ���ͶӰ����
            [Phi,y] = generate_test(L,N,codedNum,s,x,true);
        else % ʹ������SCI�����ͶӰ����
            [Phi,y] = generate_without_optimization(L,N,codedNum,s,M,captured,x);
        end
        estimated_theta = estimate_product(L,N,codedNum,Phi,psi,estimated_theta,y); % ���ڻ���ȡ�����ۼ���ȥ
    end
    % real
    real_theta = fft2(x);
    real_x = ifft2(real_theta); % x
    % estimated
    estimated_theta = estimated_theta/niter; 
    estimated_theta = reshape(estimated_theta,size(x)); % ��һ��λ��(1,1)������ƫ�룬�����ӽ���������ʱ���Ͻӽ���
    % estimated_theta(1,1,:) = real_theta(1,1,:); % ��random����Ҫ�������ƫ��
    estimated_x = real(ifft2(estimated_theta));
    % apply fft2 using psi
    x_ = reshape(x,n*n,codedNum);
    psi_theta = psi*x_;
    psi_theta = reshape(psi_theta,size(x)); % the same as real_theta��
    psi_x = real(ifft2(psi_theta)); % the same as real_x��
    
    my_display(x,estimated_x,codedNum,bOrig);
end