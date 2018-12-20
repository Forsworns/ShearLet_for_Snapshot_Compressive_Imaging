% this is to verify that we can seperate the frame we wanted
addpath('dataset');
load("kobe32_cacti.mat")

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
maskSum = 0;
for i=1:maskFrames
    maskSum = maskSum + mask(:,:,i);
end

maskRadio = zeros(size(mask));                                % ռ��
for i=1:maskFrames
    maskRadio(:,:,i) = mask(:,:,i)./maskSum(:,:);
end
maskRadio(isnan(maskRadio)) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sampledUnfold = zeros(size(sampled,1),frames);
for i=1:frames
    temp = maskRadio(:,:,mod(i,maskFrames)+1);
    sampledUnfold(:,i) = diag(sparse(temp(:)))*sampled(:,ceil(i/maskFrames));
end
sampledUnfold = sampledUnfold(:);
% ����Բ�����Ԥ����ܺ����ǳ��ӽ���ʵ�Ĳ���ֵ��Ҳ����˵���Լ򵥵شӸ��ϵĲ����лָ�����ÿһ֡�Ĳ���
(sampledUnfold-unavailableSampled)/sum(unavailableSampled) % =6.5442e-17��������