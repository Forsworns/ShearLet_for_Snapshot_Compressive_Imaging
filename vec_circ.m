function A2_l = vec_circ(vec)
% ���������ɶ�Ӧ��ѭ������
    k = size(vec); 
    A2_l = zeros(k,k);
    for i = 1:k
        A2_l(i,1:i-1)=vec(k-i+2:k);     %���ʱ�����и�ֵ
        A2_l(i,i:k) = vec(1:k-i+1);
    end
end