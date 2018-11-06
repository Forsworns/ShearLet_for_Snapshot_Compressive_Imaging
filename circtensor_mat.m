function A3 = circtensor_mat(A2)
% ȡÿ��tube����Ϊ�ԽǾ����̳ɾ���
% input: k*k*m
% output: mk*mk
    [k,~,m] = size(A2);
    A3 = zeros(k*m,k*m);
    for i=1:k
        for j = 1:k
            A3((i-1)*m+1:i*m,(j-1)*m+1:j*m) = diag(A2(i,j,:));
        end
    end
end