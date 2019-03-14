% ���ɶ�ά����Ҷ�任����Ļ�
function psi = fourier_full(n)    
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
end