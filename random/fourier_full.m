% ���ɶ�ά����Ҷ�任����Ļ�
function dft = fourier_full(n)    
    % ��λ��
    n = n*n;
    w = exp(-2*pi*(1i)/n);
    % ��ÿ��ite��k��psi��һ��������fft2�ľ�������Ԥ�����
    dft = ones(n,n);
    for j=2:n
        for k=2:n
            dft(j,k) = w^((j-1)*(k-1));
        end
    end
end