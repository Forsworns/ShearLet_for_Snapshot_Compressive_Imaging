%       1,  1/2s
% Phi = 0,  1-1/s
%       -1, 1/2s

% �ڴ�ռ�øߵİ汾�����нϿ�
% �ȶ�ͼ��ľֲ����в���
function rec  = random_projection_without_optimization(L,s,n,iteration,mask,captured,orig,bTest)
    [width, height, frames] = size(orig);
    N = n*n;
    psi = fourier_full(n);
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
        theta = estimate_product(L,N,frames,Phi,psi,theta,y); % ���ڻ���ȡ�����ۼ���ȥ
    end
    theta = theta/iteration; 
    rec = reshape(theta,[width, height, frames]); % Ƶ��ϵ��
    rec = real(ifft2(rec));
end
