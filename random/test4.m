clear all;
load("kobe32_cacti.mat")

%% 定理一
[n1,n2,n3] = size(mask);
mask = zeros(size(mask));
for i = 1:n1
    for j = 1:n2
        k = ceil(rand()*n3);
        mask(i,j,k) = 1; 
    end
end
% 采样
orig = orig(:,:,1:8);
meas = sum(orig.*mask,3);

%% 取出一小块初始化
n = 16;
x = orig(1:n,1:n,1:n3);              
M = mask(1:n,1:n,1:n3);
captured = meas(1:n,1:n,1);
x = x(:);
M = M(:);
captured = captured(:);

N = n*n;
NN = N*n3;
w = exp(-2*pi*(1i)/NN);
cal_num=NN; % 估计前几个系数
dft = ones(NN,cal_num);
for ite=1:NN
    for j=1:cal_num
        dft(ite,j) = w^((ite-1)*(j-1));
    end
end

%(dft*x-fft(x)) %验证dft做对了

L2 = 10; 

%% 计算随机投影矩阵和投影
% estimated_thetaz第一个系数是平均值，不准确也可以，恢复出的图像只是有一个比例的误差
estimated_theta = zeros(1,cal_num);
for ite =1:L2
    L1 = 1e3;
    Phi = zeros(L1,NN);
    
    for j=1:L1
        order = randperm(N); 
        % 这里取正负是考虑到由mask中的元素确定的正负是确定的
        ps = order(1:N/2);
        ns = order(1+N/2:N);
        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,n3);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,n3);
    end
    Phi = Phi*sqrt(8);
    means = mean(Phi(:)) % 均值
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*n3) % 方差
    
    u = Phi*x;
    v = Phi*dft; % 对称，行列一样
    
    estimated_theta = estimated_theta + (u'*v)/L1; 
end
estimated_theta = estimated_theta/L2;

%% 后续观察
real_theta = fft(x);
estimated_theta = estimated_theta.';
error = norm(estimated_theta-real_theta);

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,n3]),reshape(estimated_x,[n,n,n3]),n3,true)

%% 提取mask中的对应位置
function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end