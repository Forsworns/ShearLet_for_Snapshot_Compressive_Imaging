function A2_l = vec_circ(vec)
% ���������ɶ�Ӧ��ѭ������
% input: k*1
% output: k*k
    k = size(vec,1); 
    A2_l = zeros(k,k);
    for i = 1:k
        A2_l(i,1:i-1)=vec(k-i+2:k);     %���ʱmatlab������и�ֵ
        A2_l(i,i:k) = vec(1:k-i+1);
    end
end