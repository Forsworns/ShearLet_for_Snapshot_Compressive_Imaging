% ͨ��SCI��mask����ͶӰ���󣬶�Ӧ����captured���y
function [Phi,y] = buildSCI(L,N,s,frames,mask,captured)
    nonzero_num = ceil(N/s);
    Phi = zeros(L,N,frames);
    y = zeros(L,1);
 
    for i=1:L
        order = randperm(N); 
        % ����ȡ�����ǿ��ǵ���mask�е�Ԫ��ȷ����������ȷ���ģ�����L����ĳ����ֻҪ����Ͷ���ͬ
        positive = order(1:ceil(nonzero_num/2));
        negative = order(1+ceil(nonzero_num/2):nonzero_num);
        Phi(i,:,:) = Phi(i,:,:) + map2vec(N,frames,positive,mask); 
        y(i) = y(i) + sum(captured(positive));
        Phi(i,:,:) = Phi(i,:,:) - map2vec(N,frames,negative,mask);
        y(i) = y(i) - sum(captured(negative));
    end
    
    real_s = N/nonzero_num; % ��Ϊÿ�ж�����ͬ�ķ�����Ŀ����nonzero_num = ceil(N/s)��Ӧ
    Phi = sqrt(real_s)*Phi;
end