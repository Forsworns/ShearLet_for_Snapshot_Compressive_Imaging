function vec = map2vec(N,frames,selected,mask)
    % ��ѡȡ�Ĳ��������е�ĳһ��ȡ��������ӳ�䵽Phiĳһ�еĶ�Ӧλ����
    n = sqrt(N);
    mask_i = mod(selected-1,n)+1;
    mask_j = ceil(selected/n);
    vec = zeros(1,N,frames);
    vec(1,selected,:) = mask(mask_i,mask_j,:);
end