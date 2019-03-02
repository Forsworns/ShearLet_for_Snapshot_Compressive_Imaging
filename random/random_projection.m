%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% Phi N*8N ��L*8N�� (��Ĭ��LΪN���в���
% n����Ϊ64���ȶ�ͼ��ľֲ����в���
function rec  = random_projection(s,n,iteration,orig)
[width, height, frames] = size(orig);
N = n*n;
L = N; % ��ʱ���

% ��λ��
w = exp(2*pi/n);
% ����basis vector psi_first����ÿ��ite��k��psi��һ��������fft2�ľ���
psi_first = zeros(N,1);
psi_first(1) = 1;
for t = 2:N
    psi_first(t) = w*psi_first(t-1);
end

theta = zeros(N*frames,1);
% ��iteration�Σ���ȡ����
for ite = 1:iteration
    % �����ʼ��Phi��Ӧ��������֪��mask���ɣ������Ȳ��������һ��
    Phi = zeros(width,height,frames);
    for k = 1:frames
        for i =1:n
            order = randperm(n);
            nonzero_num = n/s;
            positive = order(1:nonzero_num/2);
            negtive = order(nonzero_num/2+1:nonzero_num);
            Phi(i,positive,k) = 1;
            Phi(i,negtive,k) = -1;
        end
    end
    
    % ����y=Phi*orig��������Ϊ�õõ�origΪ�������ôд��ʵ������ʱӦ���Ǹ���Phi�����ɷ�ʽ����meas����Phi����y
    y = sample(Phi,orig,8);
    y = y(:);
    
    % �𿪶�k����άͼƬ�ֱ����
    for k = 1:frames
        for i =1:N
            temp = Phi(:,:,k);
            x = temp(:).*((w^(i-1))*psi_first);
            theta((k-1)*N+i) = theta((k-1)*N+i) + y'*x;
        end
    end
    
end
    theta = theta/iteration;
    rec = reshape(theta,[width, height, frames]);
    rec = real(ifft2(rec));
end
