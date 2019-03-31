%% ���ļ�
clear ;
close all;
home;

bFig = true;
bTest = false;
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

x_1 = 81;
x_2 = 96;
y_1 = 97;
y_2 = 112;
n = 16;

% x_1 = 65;
% x_2 = 96;
% y_1 = 97;
% y_2 = 128;
% n = 32;

from_which = 0;
codedNum = 2; % ����֡ѹ����һ֡����kobe������8
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
    L       = 1e3; % ͶӰ��Խ�󣬻ָ�Ч��Խ��
    s       = 2; % sԽС��ͶӰ�����еķ���Ԫ��Խ��
    niter   = 3; % ͶӰ������֮��ȡ����
%% RUN
    tic
    % x_rp	= random_projection(L,s,n,niter,M,captured,x); % �Ż����ڴ����⣬���Ǽ������
    x_rp	= random_projection_without_optimization(L,s,n,niter,M,captured,x,bTest);
    time = toc;
    % x_rp = TV_denoising(x_rp/255,0.05,10)*255;
%% Display
    my_display(x,x_rp,codedNum,bOrig);
end

% ֱ�ӹ۲�ͶӰ���ľ���֮��Ĳ��
% [Phi,y] = generate_without_optimization(100,256,8,2,mask,captured,x);
% Phi = reshape(Phi,[100,256*8]);
% y_ = Phi*x(:)/sqrt(100); % y��y_��ͬ
% Phi = reshape(Phi,[100,256,8]);
% [Phi,y__] = generate_test(100,256,8,2,x,false);