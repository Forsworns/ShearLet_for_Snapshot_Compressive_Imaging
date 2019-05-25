clear all;
load("kobe32_cacti.mat")

%% ����
orig = orig(:,:,1:8);

%% ȡ��һС���ʼ��
f = 8; % ֻ����֡�����ԣ���֡��ƫ������
n = 16; % �²�����ͼƬ�Ĵ�С
x = orig(1:n,1:n,1:f);              
x = x(:);

N = n*n;
NN = N*f;
w = exp(-2*pi*(1i)/NN);
dft = ones(NN,NN);
for ite=1:NN
    for j=1:NN
        dft(ite,j) = w^((ite-1)*(j-1));
    end
end

%(dft*x-fft(x)) %��֤dft������
s = 1;
L2 = 1e5; 

%% �������ͶӰ�����ͶӰ
% estimated_thetaz��һ��ϵ����ƽ��ֵ����׼ȷҲ���ԣ��ָ�����ͼ��ֻ����һ�����������
estimated_theta = zeros(1,NN);
tic;
for ite =1:L2
    Phi = zeros(NN);
    order = randperm(NN);
    ps = order(1:NN/2/s);
    ns = order(1+NN/2/s:NN/s);
    Phi(ps) = 1;
    Phi(ns) = -1;
    Phi = Phi*sqrt(s);
    % means = mean(Phi(:)) % ��ֵ
    % var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % ����
    
    u = Phi*x;
    v = Phi*dft; % �Գƣ�����һ��
    
    estimated_theta = estimated_theta + (u'*v); 
end
estimated_theta = estimated_theta/L2;
time = toc;
%% �����۲�
real_theta = fft(x);
estimated_theta = estimated_theta.';

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)
