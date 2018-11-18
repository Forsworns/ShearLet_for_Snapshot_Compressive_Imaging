function [U,S,V,r]=tsvd(X,rho)
% ����3ά������tsvd
% input: m*n*k
% output: U-m*m*k S-m*n*k V-n*n*k 
    [m,n,k]=size(X);
    U = zeros(m,m,k);
    S = zeros(m,n,k);
    V = zeros(n,n,k);
    X = fft(X,[],3);
    r = 0;
    for i=1:k
        [U(:,:,i),S(:,:,i),V(:,:,i)] = svd(X(:,:,i));
        maxEigen = max(max(S(:,:,i)));
        maxEigenNorm=maxEigen.*conj(maxEigen);
        enginMatrixNorm = S(:,:,i).*conj(S(:,:,i));
        r = max(r,nnz(enginMatrixNorm>rho*maxEigenNorm));   %�趨һ����ֵ��С�ڸ�ֵ�Ķ�����0����Ϊ�����о�������
    end
    U = ifft(U,[],3);
    S = ifft(S,[],3);
    V = ifft(V,[],3);
end