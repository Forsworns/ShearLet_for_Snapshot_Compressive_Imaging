function [phi,y] = generate(N,frames,s,mask,captured)
    % mask n��n��8 (�Խǻ���Ϊ8N��8N)
    % captured n��n
    % Phi L��8N
    % captured_out L��1
    % ����Phi�����Ӧ��y
    phi = zeros(1,N,frames);
    y = 0;
    nonzero_num = ceil(N/s);
    selecteds = [];
    i = 0;
    while i < nonzero_num
        selected = unidrnd(N);
        if ismember(selected,selecteds)
            continue;
        else
            selecteds = [selecteds,selected];
        end
        phi = phi + map2vec(N,frames,selected,mask);
        y = y + captured(selected);
        i = i + 1;
    end
end