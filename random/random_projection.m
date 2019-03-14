%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% �ڴ��Ż��İ汾
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
    theta = zeros(N*frames,1);
    y = zeros(L,1);
    x = zeros(L,N,frames);
    % ��iteration�Σ���ȡ����
    for ite = 1:iteration
        disp(ite)
        % �𿪶�k����άͼƬ�ֱ����
        for i = 1:L
            [phi,y(i)] = generate(N,frames,s,mask,captured); % ����ͶӰ�����������
            for j =1:N
                for k = 1:frames
                    p = ceil(j/n);
                    q = mod(j-1,n)+1;
                    psi = kronv(dft(p,:),dft(q,:)); % ��Kronecker�����н����������
                    x(i,j,k) = phi(:,:,k)*psi;
                end
            end
            y(i) = phi(:).'*orig(:); % ֱ����ͶӰ�����ڲ��ԡ�Ӧ��������generate�������y(i)
        end
        
        for k = 1:frames
            theta((k-1)*N+1:k*N) = theta((k-1)*N+1:k*N) + (y'*x(:,:,k)).'/sqrt(L);
        end
    end
    real_s = N/(ceil(N/s));
    theta = sqrt(real_s)*theta/iteration;
    rec = reshape(theta,[width, height, frames]);
    rec = real(ifft2(rec));
end
