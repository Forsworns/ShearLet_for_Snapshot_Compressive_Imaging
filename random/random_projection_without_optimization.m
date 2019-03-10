%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% �ڴ�ռ�øߵİ汾�����нϿ�
% �ȶ�ͼ��ľֲ����в���
function rec  = random_projection_without_optimization(L,s,n,iteration,mask,captured,orig,bTest)
    [width, height, frames] = size(orig);
    N = n*n;

    % ��λ��
    w = exp(-2*pi*(1i)/n);
    % ��ÿ��ite��k��psi��һ��������fft2�ľ�������Ԥ�����
    dft = ones(n,n);
    for i=2:n
        for j=2:n
            dft(i,j) = w^((i-1)*(j-1));
        end
    end
    psi = kron(dft,dft); % 2d-fft basis matrix
    
    theta = zeros(N*frames,1);
    % ��iteration�Σ���ȡ����
    for ite = 1:iteration
        disp(ite)
        % �����ʼ��Phi��Ӧ��������֪��mask���ɣ������Ȳ��������һ��
        if bTest % ʹ����ȫ������ɵĲ���ͶӰ����
            [Phi,y] = generate_test(L,N,frames,s,orig,true);
        else % ʹ������SCI�����ͶӰ����
            [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured,orig);
        end
        % �𿪶�k����άͼƬ�ֱ����
        % ͶӰ����������ڻ������������
        for k = 1:frames
            x = Phi(:,:,k)*(psi).';
            theta((k-1)*N+1:k*N) = theta((k-1)*N+1:k*N) + (y'*x).'/sqrt(L);
        end
    end
    theta = theta/iteration; 
    rec = reshape(theta,[width, height, frames]); % Ƶ��ϵ��
    rec = real(ifft2(rec));
end
