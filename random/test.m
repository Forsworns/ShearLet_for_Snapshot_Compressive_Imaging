load("kobe32_cacti.mat")

f = 8;
n = 8;
x = orig(1:8,1:8,1:f);
M = mask(1:8,1:8,1:f);
x = x(:);
M = M(:);
M(M==0)=-1;

N = n*n;
NN = N*f;
w = exp(-2*pi*(1i)/NN);
dft = ones(NN,NN);
for i=2:NN
    for j=2:NN
        dft(i,j) = w^((i-1)*(j-1));
    end
end

s = 2;
L2 = 100; 
cal_num=3; % ����ǰ����ϵ��
estimated_theta = zeros(cal_num,1);
for i =1:L2
    L1 = 100;
    Phi = zeros(L1,NN);
    for j=1:L1
        order = randperm(N); 
        % ����ȡ�����ǿ��ǵ���mask�е�Ԫ��ȷ����������ȷ���ģ�����L����ĳ����ֻҪ����Ͷ���ͬ
        ps = order(1:N/2/s);
        ns = order(1+N/2/s:N/s);

        Phi(j,:) = Phi(j,:) + extract_M(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - extract_M(ns,N,M,f);
    end
    
%     Phi = zeros(L1,NN);
%     order = randperm(N*f*L1);
%     nonzero_num = N*f*L1/s;
%     positive = order(1:nonzero_num/2);
%     negtive = order(nonzero_num/2+1:nonzero_num);
%     Phi(positive) = 1;
%     Phi(negtive) = -1; 
    
    Phi = sqrt(s)*Phi;
    
    mean(Phi(:)) % ��ֵ
    sum(Phi(:).*Phi(:))/(L1*N*f) % ����
    
    u = Phi*x;
    v = Phi*dft(:,1:cal_num); % �Գƣ�����һ��
    
    % ֮����λ��
    estimated_theta = estimated_theta + (u.'*v).'/L1;
end

estimated_theta = estimated_theta/L2;
real_theta = fft(x);

function vec = extract_M(idx,N,M,f)
    vec = zeros(1,N*f);
    for i =1:f
        vec(N*(i-1)+idx) = M(N*(i-1)+idx);
    end
end