function [Phi,y] = generate(L,N,frames,s,mask,captured)
    % ������sֻ��һ���ο�ֵ��ʵ���Ͽ����޷����㣬�����丽����һ��ƫ��
    % mask n��n��8 (�Խǻ���Ϊ8N��8N)
    % captured n��n
    % Phi L��8N
    % captured_out L��1
    mask_sum = sum(mask,3); % mask չ���ɶԽ�8N��8N��ÿ�е�1�ĸ�������Ϊ֮����Phi���Ƕ�һ�в����ģ�����Ҫ��Ϳ���
    mask_sum = mask_sum(:);
    captured = captured(:);
    diag_mask = zeros(N,N,frames);
    for k =1:frames
        temp_mask = mask(:,:,k);
        diag_mask(:,:,k) = diag(temp_mask(:)); 
    end
    
    nonzero_num = frames*N/s;
    % �������������1����
    type_pos = cell(frames,1);
    type_num = zeros(frames,1);
    type_weight = zeros(frames,1);
    type_id = 1:frames;
    % ÿ��1����Ŀ�����frames����С��1
    for i=type_id
        type_pos{i} = find(mask_sum==i);
        type_num(i) = length(type_pos{i});
        type_weight(i) = type_num(i)*i;
    end
    ratio = type_weight/sum(type_weight);
    
    num_each_type = ceil(nonzero_num*ratio./type_id.'/2);
    real_s = frames*N/sum(num_each_type.*type_id.'*2);
    
    % ����Phi�����Ӧ��y
    Phi = zeros(L,N,frames);
    y = zeros(L,1);
    for i = 1:L
        for k = 1:frames
            if type_num(k)~=0
                order = randperm(type_num(k));
                positive = order(1:num_each_type(k));
                negtive = order(num_each_type(k)+1:2*num_each_type(k));
                type_k = type_pos{k};
                positive = type_k(positive);
                negtive = type_k(negtive);
                temp1 = sum(diag_mask(positive,:,:));
                temp2 = sum(diag_mask(negtive,:,:));
                Phi(i,:,:) = Phi(i,:,:) + temp1 - temp2;
                y(i) = y(i)+sum(captured(positive))-sum(captured(negtive));
            end
        end
    end
    Phi = sqrt(real_s)*Phi;
end