clear all;
load("kobe32_cacti.mat")

%% �ֿ鹹��mask�������񶯷����ϵ������       
% mask_ = zeros(512,256);
% order = randperm(512*256); 
% mask_(order(1:256*256)) = 1;
% frames = 8;
% mask = zeros(256,256,frames);
% for ite =1:frames
%     mask(:,:,ite) = mask_((ite-1)*32+1:ite*32+224,:); % �趨32�����ص�
% end

bDebias = true; % �Ƿ�����֡����ش��������

%% ����
orig = orig(:,:,1:8);
meas = sum(orig.*mask,3);

%% ȡ��һС���ʼ��
f = 2; % ֻ����֡�����ԣ���֡��ƫ������
n = 16; % �²�����ͼƬ�Ĵ�С
step = 256/n;
x = orig(1:step:end,1:step:end,1:f);              
M = mask(1:n,1:n,1:f);
x = x(:);
M = M(:);
M(M==0)=-1; % �Բ������������ȥֱ������

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
L2 = 10; 

if bDebias && f==2
    f1 = M(1:N); 
    f2 = M(N+1:NN);
    f12 = f1.*f2; % ���ݵ�һ֡�͵ڶ�֡��mask�������ϵ��
end

%% �������ͶӰ�����ͶӰ
% estimated_thetaz��һ��ϵ����ƽ��ֵ����׼ȷҲ���ԣ��ָ�����ͼ��ֻ����һ�����������
estimated_theta = zeros(1,NN);
for ite =1:L2
    L1 = 1e4;
    Phi = zeros(L1,NN);
    
% ֱ����mask����ͶӰ����
    for j=1:L1
        order = randperm(N); 
        % ����ȡ�����ǿ��ǵ���mask�е�Ԫ��ȷ����������ȷ���ģ�����L����ĳ����ֻҪ����Ͷ���ͬ
        ps = order(1:N/2/s);
        ns = order(1+N/2/s:N/s);
        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
    end
    Phi = Phi*sqrt(s);
    % Phi(i,N+1:2*N) = Phi(i,1:N).*f12';ʵ�����������ϵ
    means = mean(Phi(:)) % ��ֵ
    var = sum((Phi(:)-means).*(Phi(:)-means))/(L1*N*f) % ����
    
    u = Phi*x;
    v = Phi*dft; % �Գƣ�����һ��
    
    estimated_theta = estimated_theta + (u'*v)/L1; 
    
    if bDebias && f==2
        bias = 0;
        for j=1:N
            bias = bias + f12(j)*x(j)*dft(j+N,:)+f12(j)*x(j+N)*dft(j,:);   % ���������ɵ����
        end
        estimated_theta = estimated_theta - bias;
    end
    
end
estimated_theta = estimated_theta/L2;

%% �����۲�
real_theta = fft(x);
estimated_theta = estimated_theta.';

estimated_x = real(ifft(estimated_theta));
my_display(reshape(x,[n,n,f]),reshape(estimated_x,[n,n,f]),f,true)

%% ��ȡmask�еĶ�Ӧλ��
function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for ite =1:f
        vec(N*(ite-1)+idx) = M(N*(ite-1)+idx);
    end
end