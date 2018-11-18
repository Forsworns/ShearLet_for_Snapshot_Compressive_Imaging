clear;
clc;

addpath('dataset');
datasetdir = 'dataset'; % dataset

% [1] load dataset
para.type   = 'cacti'; % type of dataset, cassi or cacti
para.name   = 'kobe'; % name of dataset
para.number = 32; % number of frames in the dataset

datapath = sprintf('%s/%s%d_%s.mat',datasetdir,para.name,...
    para.number,para.type);

load(datapath); % mask, meas, orig (and para)

% for i = 1:size(orig,3)
%     imagesc(orig(:,:,i))
%     colormap(gray)
%     pause(0.5)
% end

% ��һ�µ���ͼ�Ļָ�Ч��
rho = 0.1;
alpha = 1;
maxItr = 100;
normalize = max(orig(:));
orig = orig/normalize;
[width, height, frames] = size(orig);
maskFrames = size(mask,3);
% sampled = zeros(width*height,frames/maskFrames);
% unavailableSampled = zeros(width*height,frames);
% 
% for i=1:frames
%     mask_i = mask(:,:,mod(i,maskFrames)+1);
%     mask_i = diag(sparse(mask_i(:)));
%     orig_i = orig(:,:,i);
%     unavailableSampled(:,i) = mask_i * orig_i(:);
%     sampled(:,ceil(i/maskFrames)) = sampled(:,ceil(i/maskFrames)) + mask_i * orig_i(:);
% end
% unavailableSampled = unavailableSampled(:); % ���ܻ�ȡ���ģ�����ͼ��sample
% % sampledҲ����meas(:)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maskSum = 0;
% for i=1:maskFrames
%     maskSum = maskSum + mask(:,:,i);
% end
% 
% maskRadio = zeros(size(mask));                                % ռ��
% for i=1:maskFrames
%     maskRadio(:,:,i) = mask(:,:,i)./maskSum(:,:);
% end
% maskRadio(isnan(maskRadio)) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sampledUnfold = zeros(size(sampled,1),frames);
% for i=1:frames
%     temp = maskRadio(:,:,mod(i,maskFrames)+1);
%     sampledUnfold(:,i) = diag(sparse(temp(:)))*sampled(:,ceil(i/maskFrames));
% end
% sampledUnfold = sampledUnfold(:);
% % ����Բ�����Ԥ����ܺ����ǳ��ӽ���ʵ�Ĳ���ֵ��Ҳ����˵���Լ򵥵شӸ��ϵĲ����лָ�����ÿһ֡�Ĳ���
% %(sampledUnfold-unavailableSampled)/sum(unavailableSampled) % =6.5442e-17��������
% orig = orig*normalize;



% [X,~]   =    tensor_cpl_admm( mask , unavailableSampled , rho , alpha , ...     %unavailableSampled sampledUnfold
%                      [width, height] , maskFrames, maxItr , 0 );
% X                      =        reshape(X,[width, height, maskFrames])         ; 
%             
% X_dif                  =        orig(:,:,1:maskFrames)-X;
% origPart = orig(:,:,1:maskFrames);
% RSE                    =        norm(X_dif(:))/origPart(:)                      ;
% 
% figure;
% for i = 1:maskFrames
%     subplot(221);imagesc(orig(:,:,i));axis off;%original
%     colormap(gray);title('Original Video');
%     subplot(222);imagesc(X(:,:,i)) ;axis off;%recovered
%     colormap(gray);title('Recovered Video');
%     pause(0.5);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% use AM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ѱ�֡ƴ������Ϊԭ����һ֡����k=4��m=8m��n=n
iterate_times = 1;
rho = 0.01;                                                 %ռ���ֵ�Ķ�����Ϊ��0��rhoԽС���������Խ��
matOrig = zeros(width*maskFrames,height,frames/maskFrames); % ��Ҫ��reshape�ƻ�������
for i = 1:frames/maskFrames
    for j = 1:maskFrames
        matOrig((j-1)*width+1:j*width,:,i) = orig(:,:,j+(i-1)*maskFrames); 
    end
end
[~,~,~,r] = tsvd(matOrig,rho)                                 % �̶�һ��������ѡ��δ�������ʱ�����
% [U,S,V,~] = tsvd(matOrig,rho);
% svdRecovered = tprod(tprod(U(:,1:r,:),S(1:r,1:r,:)),tran(V(:,1:r,:)));
% norm(svdRecovered(:) - matOrig(:))/norm(matOrig(:)) %rhoȡ��0.01���Ҳ�ܵͣ�RSE���Ҳ�ǳ�1:1���ȵġ�ȷʵ��һ����������

% matMask = zeros(width*maskFrames,height);
% for i = 1:maskFrames
%     matMask((i-1)*width+1:i*width,:) = mask(:,:,i);
% end
% matMask = repmat(matMask,[1 1 frames/maskFrames]);
% matSampled = matOrig.*matMask;

% [X,Y] = tam(matSampled,matMask,iterate_times,r);
% Recovered = tprod(X,Y);
% norm(Recovered(:) - matOrig(:))/norm(matOrig(:))


X = randn(10,2,4);
Y = randn(2,10,4);
matOrigT = tprod(X,Y);
[~,~,~,r] = tsvd(matOrigT,rho)          
matMask = rand([10,10,4])>0.50;
matSampled = matOrigT.*matMask;

iterate_times = 100;
[X,Y] = tam(matOrigT,matSampled,matMask,iterate_times,r);
recovered = tprod(X,Y);
norm(recovered(:) - matOrigT(:))/norm(matOrigT(:))