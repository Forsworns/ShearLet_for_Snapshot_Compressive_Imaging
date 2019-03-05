function [Phi,y] = generate(L,N,frames,s,mask,captured)
    % mask n��n��8 (�Խǻ���Ϊ8N��8N)
    % captured n��n
    % Phi L��8N
    % captured_out L��1
    
    % Ԥ������mask�е�0ת��Ϊ1��������Ϊmask��0��1����������ͬ�������ȶ�0/1������������
    captured = captured(:);
    captured = 2*(captured-mean(captured));
    mask(mask==0) = -1;
    diag_mask = zeros(N,N,frames);
    for k =1:frames
        temp_mask = mask(:,:,k);
        diag_mask(:,:,k) = diag(temp_mask(:)); 
    end
    n = sqrt(N);
    
    nonzero_num = frames*N/s;
    % ����Phi�����Ӧ��y
    Phi = zeros(L,N,frames);
    y = zeros(L,1);
    real_s = 0;
    for i=1:L
        s_i = 0;
        selecteds = [];
        while s_i<nonzero_num
            selected = unidrnd(N);
            if ismember(selected,selecteds)
                continue;
            else
                selecteds = [selecteds,selected];
            end
            % mask(mod(selected-1,n)+1,ceil(selected/n),:)
            Phi(i,:,:) = Phi(i,:,:) + diag_mask(selected,:,:);
            y(i) = y(i) + captured(selected);
            real_s = real_s + 8;
            s_i = s_i + 8;
        end
        real_s = real_s - 8;
    end
    real_s = L*frames*N/(real_s);
    
    Phi = sqrt(real_s)*Phi;
    
    % est = mean(Phi(:)) % ���� 0
    % var = sum(Phi(:).*Phi(:))/(L*N*frames) % ���� 1
end