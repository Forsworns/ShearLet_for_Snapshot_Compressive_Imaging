function nnorm = nuclear(X)
    nnorm = 0;
    for i = 1:size(X,3) % ���谴��tnn�Ķ���ȥ����ֿ�Խǣ�ֱ����ô�����ͬ
        s = svd(X(:,:,i));
        nnorm = nnorm + sum(s);
    end
end