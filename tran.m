%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: Carla Dee Martin (carlam@math.jmu.edu)
% DATE: June 2, 2010
%
% PROGRAM: tran.m
% PURPOSE: Input a tensor, and output the tensor transpose. 
%
% VARIABLES:
% A = Input tensor
% T = Tensor transpose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tensorת��
function T = tran(A)

n=size(A);                                  %tensor����ά�ȴ�С
k=length(n);                                %ά������,order
a=reshape(A,prod(n),1);                     %ת��Ϊ������,prod��������Ԫ��֮��

t = tensortransposerecur(a,n);              %ת��

T = reshape(t,[n(2),n(1),n(3:end)]);        %���λָ���tensor��������һ��Ҫ�����ǵ���a�е�˳��ʹ�˲�ֱ�ӽ�������������ȷ��

end

%%%%%%%%%%%%%%%%%%%%%%
function t = tensortransposerecur(a,n)
  
k=length(n);

if k<=2                                     %��άֱ��ת�ã��ݹ���ֹ����
  A=reshape(a,n(1),n(2))'; 
  a=reshape(A,prod(n),1);
  t=a;
 

elseif k>=3
  
  % flips order
  Acell=cell(n(k),1);
  Bcell=cell(n(k),1);

  % puts into cell array
  for j = 1:n(k)
     Acell{j} = a([(j-1)*prod(n(1:k-1))+1:j*prod(n(1:k-1))]);       %���ά�̶����Ȱ�ǰ��ĸ�ά����ɵķŵ�һ��cell��
  end

  %flip order of cells
  y = size(Acell);
  Bcell{1} = Acell{1};%A�ı��̶���ά���˵�һ�㣬ʣ�µķ���������B����3-order-tensor����def 3.14
  
  z = 2;
  for i = y(1):-1:2
    Bcell{z} = Acell{i};
    z = z+1;
  end

  % put back into long vector
  c=[];
  for m = 1:n(k)
     c = [c;Bcell{m}];
  end
  a=c;
  % end flip order
  
  for i=1:n(k)                                              %�ݹ����һά�ȸ�����������ת�ô���
    v=a((i-1)*prod(n(1:k-1))+1:i*prod(n(1:k-1)));
    a((i-1)*prod(n(1:k-1))+1:i*prod(n(1:k-1))) = tensortransposerecur(v,n(1:k-1));
  end
  
end

t=a;

end




