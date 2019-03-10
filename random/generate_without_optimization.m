% ����SCI��mask����ͶӰ����Ͷ�Ӧ��y
function [Phi,y] = generate_without_optimization(L,N,frames,s,mask,captured,orig)
    % mask n��n��8 (�Խǻ���Ϊ8N��8N)
    % captured n��n
    % Phi L��8N
    % captured_out L��1
    
    % Ԥ������mask�е�0ת��Ϊ1��������Ϊmask��0��1����������ͬ�������ȶ�0/1������������
    captured = captured(:);
    captured = 2*(captured-mean(captured));
    mask(mask==0) = -1;
    
    nonzero_num = ceil(N/s);
    % ����Phi�����Ӧ��y
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
    
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
    expectation = mean(Phi(:)) % ���� 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % ���� 1
end