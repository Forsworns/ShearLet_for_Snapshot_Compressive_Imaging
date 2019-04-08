clear all;
load("kobe32_cacti.mat")

%% ��mask       
mask_ = zeros(512,256);
order = randperm(512*256); 
mask_(order(1:256*256)) = 1;
frames = 8;
mask = zeros(256,256,frames);
for ite =1:frames
    mask(:,:,ite) = mask_((ite-1)*32+1:ite*32+224,:); % �趨32�����ص�
end
% ����
orig = orig(:,:,1:8);
meas = sum(orig.*mask,3);

%% ȡ��һС���ʼ��
f = 2;
n = 16;
x = orig(1:n,1:n,1:f);              % ����ȡ32��256��
M = mask(1:n,1:n,1:f);
captured = meas(1:n,1:n,1);
x = x(:);
M = M(:);
captured = captured(:);
M(M==0)=-1;

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

if f==2
    f1 = M(1:256); 
    f2 = M(257:512);
    f12 = f1.*f2; % ���ݵ�һ֡�͵ڶ�֡��mask�������ϵ��
end
% estimated_thetaz��һ��ϵ����ƽ��ֵ����׼ȷҲ���ԣ��ָ�����ͼ��ֻ����һ�����������
estimated_theta = zeros(1,cal_num);
for ite =1:L2
    L1 = 1e4;
    Phi = zeros(L1,NN);
    
%     for j=1:L1
%         order = randperm(N); 
%         % ����ȡ�����ǿ��ǵ���mask�е�Ԫ��ȷ����������ȷ���ģ�����L����ĳ����ֻҪ����Ͷ���ͬ
%         ps = order(1:N/2);
%         ns = order(1+N/2:N);
%         Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
%         Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
%     end
       
    % ��һ��д��
    order = randperm(NN*L1);
    positive = order(1:NN*L1/40*21);
    negtive = order(NN*L1/40*21+1:NN*L1);
    Phi(positive) = 1;
    Phi(negtive) = -1;
    for i=1:L1
        Phi(i,N+1:2*N) = Phi(i,1:N).*f12';
    end
    
    means = mean(Phi(:)) % ��ֵ
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % ����
    
    u = Phi*x;
    v = Phi*dft; % �Գƣ�����һ��
    
    estimated_theta = estimated_theta + (u'*v)/L1;
    
    if f==2
        bias = 0;
        for j=1:256
            bias = bias + f12(j)*x(j)*dft(j+256,:)+f12(j)*x(j+256)*dft(j,:);   % ���������ɵ����
        end
        estimated_theta = estimated_theta - bias;
    end
    
end
estimated_theta = estimated_theta/L2;

real_theta = fft(x);
estimated_theta = estimated_theta.';
error = norm(estimated_theta-real_theta);

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)

function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end