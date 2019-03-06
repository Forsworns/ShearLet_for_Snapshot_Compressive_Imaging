%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% �ȶ�ͼ��ľֲ����в���
function rec  = random_projection(L,s,n,iteration,mask,captured,orig)
    [width, height, frames] = size(orig);
    N = n*n;
    
    % Ԥ������mask�е�0ת��Ϊ1��������Ϊmask��0��1����������ͬ�������ȶ�0/1������������
    captured = captured(:);
    captured = 2*(captured-mean(captured));
    mask(mask==0) = -1;
    
    % ��λ��
    w = exp(-2*pi*(1i)/n);
    % ��ÿ��ite��k��psi��һ��������fft2�ľ���
    dft = ones(n,n);
    for i=2:n
        for j=2:n
            dft(i,j) = w^((i-1)*(j-1));
        end
    end
    psi = kron(dft,dft);
    theta = zeros(N*frames,1);
    y = zeros(L,1);
    x = zeros(L,N,frames);
    % ��iteration�Σ���ȡ����
    for ite = 1:iteration
        disp(ite)
        % �𿪶�k����άͼƬ�ֱ����
        for j = 1:L
            [phi,y(j)] = generate(N,frames,s,mask,captured);
            for i =1:N
                for k = 1:frames
                    x(j,i,k) = phi(:,:,k)*(psi(i,:)).';
                end
            end
        end
        for i = 1:N
            for k = 1:frames
                theta((k-1)*N+i) = theta((k-1)*N+i) + y'*x(:,i,k)/sqrt(L);
            end
        end
    end
    real_s = N/(ceil(N/s));
    theta = sqrt(real_s)*theta/iteration;
    rec = reshape(theta,[width, height, frames]);
    rec = real(ifft2(rec));
end
