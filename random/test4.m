clear all;
load("kobe32_cacti.mat")

%% ����һ
mask = normrnd(0,1,size(mask));      
% ����
orig = orig(:,:,1:8);
meas = sum(orig.*mask,3);

%% ȡ��һС���ʼ��
f = 1;
n = 16;
x = orig(1:n,1:n,1:f);              
M = mask(1:n,1:n,1:f);
captured = meas(1:n,1:n,1);
x = x(:);
M = M(:);
captured = captured(:);

N = n*n;
NN = N*f;
w = exp(-2*pi*(1i)/NN);
cal_num=NN; % ����ǰ����ϵ��
dft = ones(NN,cal_num);
for ite=1:NN
    for j=1:cal_num
        dft(ite,j) = w^((ite-1)*(j-1));
    end
end

%(dft*x-fft(x)) %��֤dft������

L2 = 30; 

%% �������ͶӰ�����ͶӰ
% estimated_thetaz��һ��ϵ����ƽ��ֵ����׼ȷҲ���ԣ��ָ�����ͼ��ֻ����һ�����������
estimated_theta = zeros(1,cal_num);
for ite =1:L2
    L1 = 1e4;
    Phi = zeros(L1,NN);
    
    for j=1:L1
        order = randperm(N); 
        % ����ȡ�����ǿ��ǵ���mask�е�Ԫ��ȷ����������ȷ����
        ps = order(1:N/2);
        ns = order(1+N/2:N);
        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
    end
    
    means = mean(Phi(:)) % ��ֵ
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % ����
    
    u = Phi*x;
    v = Phi*dft; % �Գƣ�����һ��
    
    estimated_theta = estimated_theta + (u'*v)/L1; 
end
estimated_theta = estimated_theta/L2;

%% �����۲�
real_theta = fft(x);
estimated_theta = estimated_theta.';
error = norm(estimated_theta-real_theta);

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)

%% ��ȡmask�еĶ�Ӧλ��
function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end