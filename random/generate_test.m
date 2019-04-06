% ��ȫ�������ͶӰ����
function [Phi,y] = generate_test(L,N,frames,s,orig,bRow,otherFrames)
    Phi = zeros(L,N,frames);  
    if bRow % �������ɣ�ÿ�е�1��-1��Ŀ��ͬ
        for k = 1:frames
            for i =1:L
                order = randperm(N);
                nonzero_num = N/s;
                positive = order(1:nonzero_num/2);
                negtive = order(nonzero_num/2+1:nonzero_num);
                Phi(i,positive,k) = 1;
                Phi(i,negtive,k) = -1;
            end
        end
    else % ֱ������һ���������
        order = randperm(N*frames*L);
        nonzero_num = N*frames*L/s;
        positive = order(1:nonzero_num/2);
        negtive = order(nonzero_num/2+1:nonzero_num);
        Phi(positive) = 1;
        Phi(negtive) = -1; 
    end
    
    % ����SCI
    otherFrames(otherFrames<0.5) = -1;
    otherFrames(otherFrames>0.5) = 1;
    for i=1:L
        for k=2:frames
            Phi(i,:,k) = Phi(i,:,1).*otherFrames(:,:,k);
        end
    end
    
    Phi = sqrt(s)*Phi; % �������Ĺ�һ��ϵ��
    % ����y=Phi*orig
    Phi = reshape(Phi,[L,N*frames]);
    y = Phi*orig(:)/sqrt(L);
    Phi = reshape(Phi,[L,N,frames]);
    
%     Phi(:,:,1) = [1,2,3;4,5,6] % reshape�õ�û����
%     Phi(:,:,2) = [7,8,9;10,11,12]
%     Phi_ = reshape(Phi,[2,6])
%     Phi__ = reshape(Phi_,[2,3,2])
    
    expectation = mean(Phi(:)) % ���� 0 
    variance = sum(Phi(:).*Phi(:))/(L*N*frames) % ���� 1

    % ����һ�����⣬�ڼ���ͶӰ����ڻ�theta��ʱ��
    % ��Ϊfft�任��psi�����һ��/��ȫ��1���������ͶӰ����ÿһ�е�������Ϊ0
    % �ᵼ��theta�ĵ�һ��㶨Ϊ0����ô��任��ָ�����ͼƬ����ϵ�����⡣����ͨ������һ�е�����Ϊ0
    % SCI�в�����������⣬��Ϊ��һ����ͶӰ���������������ȫΪ0
end
