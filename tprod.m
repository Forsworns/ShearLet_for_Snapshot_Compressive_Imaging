function C=tprod(A,B)
%tensor�˻����õ���t-product��
% Computes the tensor-product of two P dimensional tensors (A & B)
% All dimensions of the inputed tensor except for the 2nd must be the same.
% The algorithm follows from paper by ...
%
% INPUTS:
%
% A - n1 x n2 x n3 .... nP tensor
% B - n2 x n4 x n3 .... nP tensor
%
% OUTPUTS: 
%
% C - n1 x n4 x n3 .... nP tensor
%
% Original author :  Misha Kilmer, Ning Hao
% Edited by       :  G. Ely, S. Aeron, Z. Zhang, ECE, Tufts Univ. 03/16/2015


sa = size(A);
sb = size(B);

faces = length(sa);

nfaces = prod(sb(3:end));

for i = 3:faces                                                 %�ȴ�3��orderά�ȳ�ȡtube������н���(#order-2)�θ���Ҷ�任
    A = fft(A,[],i);
    B = fft(B,[],i);
end
sc = sa;
sc(2) = sb(2);
C = zeros(sc);
for i = 1:nfaces                                                %�������ˣ�������ԵĶ���һ��ǰ��ά��С�ľ���
    C(:,:,i) = A(:,:,i)*B(:,:,i);                               %��Ҳ�Ǻ���ģ���Ϊ���m�ļ�������������ֵ�ֽ��Ļָ���
end
for i = 3:faces                                                 %%(#order-2)�θ���Ҷ��任��ȡt-tensor��
    C = ifft(C,[],i);
end



