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
sampled = zeros(width*height,frames/maskFrames);
unavailableSampled = zeros(width*height,frames);

for i=1:frames
    mask_i = mask(:,:,mod(i,maskFrames)+1);
    mask_i = diag(sparse(mask_i(:)));
    orig_i = orig(:,:,i);
    unavailableSampled(:,i) = mask_i * orig_i(:);
    sampled(:,ceil(i/maskFrames)) = sampled(:,ceil(i/maskFrames)) + mask_i * orig_i(:);
end
unavailableSampled = unavailableSampled(:); % ���ܻ�ȡ���ģ�����ͼ��sample
% sampledҲ����meas(:)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maskSum = mask(:,:,1);
for i=2:maskFrames
    maskSum = maskSum + mask(:,:,i);
end

maskRadio = zeros(size(mask));                                % ռ��
for i=1:maskFrames
    maskRadio(:,:,i) = mask(:,:,i)./maskSum(:,:);
end
maskRadio(isnan(maskRadio)) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sampledUnfold = zeros(size(sampled,1),frames);
% for i=1:frames
%     temp = maskRadio(:,:,mod(i,maskFrames)+1);
%     sampledUnfold(:,i) = diag(sparse(temp(:)))*sampled(:,ceil(i/maskFrames));
% end
% sampledUnfold = sampledUnfold(:);
% % ����Բ�����Ԥ����ܺ����ǳ��ӽ���ʵ�Ĳ���ֵ��Ҳ����˵���Լ򵥵شӸ��ϵĲ����лָ�����ÿһ֡�Ĳ���
% %(sampledUnfold-unavailableSampled)/sum(unavailableSampled)=6.5442e-17��������
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
matOrig = zeros(wide*maskFrames,height,frames/maskFrames); % ��Ҫ��reshape�ƻ�������
[~,~,~,r] = tsvd(matOrig);
matSampled = zeros(wide*maskFrames,height,frames/maskFrames);
[X,Y] = tam(matSampled,r);
Recovered = tprod(X,Y);
sum(Recovered - matOrig)/sum(matOrig)
