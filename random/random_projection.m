%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% Phi N*8N ��L*8N�� (��Ĭ��LΪN���в���
% �ȶ�ͼ��ľֲ����в���
function rec  = random_projection(L,s,n,iteration,orig,bParfor)
    [width, height, frames] = size(orig);
    N = n*n;

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
    
    if bParfor
        theta = cell(frames,1);
    else
        theta = zeros(N*frames,1);
    end
    % ��iteration�Σ���ȡ����
    for ite = 1:iteration
        disp(ite)
        % �����ʼ��Phi��Ӧ��������֪��mask���ɣ������Ȳ��������һ��
        Phi = zeros(L,width*height,frames);
        for k = 1:frames
            for i =1:L
                order = randperm(N);
                nonzero_num = N/s;
                positive = order(1:nonzero_num/2);
                negtive = order(nonzero_num/2+1:nonzero_num);
                Phi(i,positive,k) = 1;
                Phi(i,negtive,k) = -1;
            end
        end
        Phi = sqrt(s)*Phi;
        
        % ����y=Phi*orig��������Ϊ�õõ�origΪ�������ôд��ʵ������ʱӦ���Ǹ���Phi�����ɷ�ʽ����meas����Phi����y
        Phi = reshape(Phi,[L,width*height*frames]);
        y = Phi*orig(:);
        Phi = reshape(Phi,[L,width*height,frames]);

        % �𿪶�k����άͼƬ�ֱ����
        if bParfor
            parfor k = 1:frames
                theta_k = zeros(N,1);
                for i =1:N
                    x = Phi(:,:,k)*(psi(i,:)).';
                    theta_k =  y'*x/L;
                end
                theta(k) = {theta{k}+theta_k};
            end
        else
            for k = 1:frames
                 for i =1:N
                    x = Phi(:,:,k)*(psi(i,:)).';
                    theta((k-1)*N+i) = theta((k-1)*N+i) + y'*x/L;
                end
            end
        end
    end
    
    if bParfor
        theta = cell2mat(theta);
    end
    theta = theta/iteration;
    rec = reshape(theta,[width, height, frames]);
    rec = real(ifft2(rec));
end
