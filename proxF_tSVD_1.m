function [X, objV] = proxF_tSVD_1(Y,rho,opts)
% proximal function of tensor nuclear norm
% %����˷���objV������ֵ֮�ͣ�������ΪL0������͹���ƣ����о�����t-svd�ֽ�
% Authors: G. Ely, S. Aeron, Z. Zhang, ECE, Tufts Univ. 03/16/2015
% opts - boolean, runs algorithm in parallel.
%% Input checking
parOP = false;
if ~exist('opts','var') && ~isempty(opts)               %�ڹ������ڼ��opts�����Ƿ���ڣ�'var'��ʾ�����ֵ
    nARG = length(opts);
    if nARG > 0
        parOP=opts{1};
    end    
end

%%
sa = size(Y);                                           %����ά�ȵĴ�С
la = length(sa);                                        %���м���ά��
[n1,n2,n3] = size(Y);                                   %ȡ��ǰ����ά�ȵĴ�С����ά�ȴ�������n3Ϊ����ά��֮��

% this returned this STILL FFT'd version
[U,S,V]=ntsvd(Y,1,parOP);                               %������Ҷ�任������ֵ�ֽ⣬��t-svd        

sTrueV =zeros(min(n1,n2),n3);
for i = 1:n3
    s = S(:,:,i);  
    s = diag(s);
    sTrueV(:,i) = s;
end                                                      %������ֵ�ֽ��еĸ�frontal��ĶԽ�S��ȡ����������У�Ϊ����һ�������Ĺ���
%%
[sTrueV] = proxF_l1(sTrueV,rho);                            %��S�������������˴�ʹ����L1���������������ĵ���ҳmethod one�������������ֵ
%[sTrueV,objV] = proxF_l1(sTrueV,rho);
%%ʵ��������̭��һЩ��С������ֵ������PCA���ƣ����Ե�һЩ��Ҫ��������ɽ���
objV = sum(sTrueV(:));                                      %����ֵ֮��
%%
for i = 1:min(n1,n2)                                     %��ԭS
    for j = 1:n3
        S(i,i,j) = sTrueV(i,j);
    end
end
    
for i = la:-1:3                                             %Ϊɶ�����㷨���n3��3����ʵ��U/S/V��frontalҲ����n3ά��
    U = ifft(U,[],i);                                       %ifft(U(i)) ���ظþ���U(i)ÿһ�еĿ��ٸ���Ҷ��任
    S = ifft(S,[],i);
    V = ifft(V,[],i);
end

% X = tprod( tprod(U,S), ttrans_HO(V));

X = tprod( tprod(U,S), tran(V));                            %�ٽ��ֽ���USV'�˻�ȥ
