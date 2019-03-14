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
    
    % ����Phi�����Ӧ��y
    [Phi,y] = buildSCI(L,N,s,frames,mask,captured);
    
    % ���ڲ��ԣ�ʵ�ʻ�ɾ��
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
    expectation = mean(Phi(:)) % ���� 0
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % ���� 1
end