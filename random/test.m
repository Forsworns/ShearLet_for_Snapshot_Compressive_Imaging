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


L2 = 100; 
cal_num=3; % ����ǰ����ϵ��
estimated_theta = zeros(cal_num,1);
for i =1:L2
    L1 = 100;
    Phi = zeros(L1,NN);
    for j=1:L1
        order = randperm(N); 
        % ����ȡ�����ǿ��ǵ���mask�е�Ԫ��ȷ����������ȷ���ģ�����L����ĳ����ֻҪ����Ͷ���ͬ
        ps = order(1:N/4);
        ns = order(1+N/4:N/2);

        Phi(j,:) = Phi(j,:) + to_vec(ps,N,M,f);
        Phi(j,:) = Phi(j,:) - to_vec(ns,N,M,f);
    end

    u = Phi*x;
    v = Phi*dft(:,1:cal_num); % �Գƣ�����һ��
    
    % ֮����λ��
    estimated_theta = estimated_theta + (u.'*v).';
end

estimated_theta = estimated_theta/L2;
real_theta = fft(x);

function vec = to_vec(idx,N,M,f)
    vec = zeros(1,N*f);
    for i =1:f
        vec(N*(i-1)+idx) = M(N*(i-1)+idx);
    end
end