%%
clear ;
close all;
home;

bGPU = false;
bReal = true;
%% DATASET
load("6fan14_cacti.mat") % meas,mask % 1/2e5/0.03
codedNum = 14;
test_data = 1;

for k = test_data
%% DATA PROCESS
    if exist('orig','var')
        bOrig   = true;
        x       = orig(:,:,(k-1)*codedNum+1:(k-1)*codedNum+codedNum);
        if max(x(:))<=1
            x       = x * 255;
        end
    else
        bOrig   = false;
        x       = zeros(size(mask));
    end
    N       = 256;
    M = mask; 
    if bGPU 
        M = gpuArray(single(M));
    end
    
    bShear = true;
    bFig = true;
    sigma = @(ite) 0.03;
    LAMBDA  = @(ite) 0.5;  
    L       = 2e5;
    niter   = 400; 
    A       = @(x) sample(M,x,codedNum);
    AT      = @(y) sampleH(M,y,codedNum,bGPU);

    %% INITIALIZATION
    if bOrig
        y       = sample(M,x,codedNum);
    else
        y       = meas(:,:,1);
    end
    x0      = zeros(size(x));
    if bGPU 
        y = gpuArray(single(y));
        x0 = gpuArray(single(x0));
    end
    L1              = @(x) norm(x, 1);
    L2              = @(x) power(norm(x, 'fro'), 2);
    COST.equation   = '1/2 * || A(X) - Y ||_2^2 + lambda * || X ||_1';
    COST.function	= @(X,ite) 1/2 * L2(A(X) - y) + LAMBDA(ite) * L1(X(:));
    COST.equation   = '1/2 * || A(X) - Y ||_2^2';
    COST.function	= @(X,ite) 1/2 * L2(A(X) - y);

%% RUN
    tic
    x_ista	= SeSCI(A, AT, x0, y, LAMBDA, L, sigma, niter, COST, bFig, bGPU,bShear,bReal);
    time = toc;
    x_ista = real(ifft2(x_ista));
    if bGPU
        x_ista = gather(x_ista);
    end
    x_ista = TV_denoising(x_ista/255,0.05,10)*255;
    nor         = max(x(:));
    psnr_x_ista = zeros(codedNum,1);
    ssim_x_ista = zeros(codedNum,1);
%% DISPLAY
    figure(1); 
    for i=1:codedNum
        if bOrig
            colormap gray;
            subplot(121);   
            imagesc(x(:,:,i));
            set(gca,'xtick',[],'ytick',[]);
            title('orig');

            subplot(122);   
            imagesc(x_ista(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 

            psnr_x_ista(i) = psnr(x_ista(:,:,i)./nor, x(:,:,i)./nor, max(max(max(double(x(:,:,i)./nor))))); 
            ssim_x_ista(i) = ssim(x_ista(:,:,i)./nor, x(:,:,i)./nor);
            title({['frame : ' num2str(i, '%d')], ['PSNR : ' num2str(psnr_x_ista(i), '%.4f')], ['SSIM : ' num2str(ssim_x_ista(i), '%.4f')]});
        else 
            colormap gray;
            imagesc(x_ista(:,:,i));  	
            set(gca,'xtick',[],'ytick',[]); 
            title(['frame : ' num2str(i, '%d')]);
        end
        pause(1);
    end
    psnr_ista = mean(psnr_x_ista);
    ssim_ista = mean(ssim_x_ista);

    save(sprintf("results/ours_fan_%d.mat",k))
end