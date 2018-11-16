function A2 = lateral_circ(P,j)
% ������ĳ��slice�������ѭ���ľ���
% input: m*1*k
% output: k*k*m
    [m,~,k] = size(P(:,j,:));
    A2 = zeros(k,k,m);
    for i=1:m
        A2(:,:,i) = vec_circ(squeeze(P(i,j,:)));    %squeeze֮��ȷ����Ϊ������
    end
end