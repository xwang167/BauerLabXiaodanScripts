close all
clear all
clc
load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
 load('D:\OIS_Process\noVasculatureMask.mat')
 mask = leftMask+rightMask;
  [hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr))/0.01,25,mask);
  [xform_jrgeco1aCorr_GSR,gs,~] = mouse.process.gsr(xform_jrgeco1aCorr,mask);
  [hz,powerdata_jrgeco1aCorr_GSR] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_GSR))/0.01,25,mask);
                    
 mask = logical(leftMask+rightMask);
 xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,[],14999);
 xform_jrgeco1aCorr = xform_jrgeco1aCorr(logical(mask),:);
 [coeff,score,latent,tsquared,explained,mu] = pca(xform_jrgeco1aCorr,'NumComponents',20);
  [coeff_def,score_def,latent_def,tsquared_def,explained_def,mu_def] = pca(xform_jrgeco1aCorr);
  
 deltaWave = score(:,1)*coeff(:,1)' + score(:,2)*coeff(:,2)' + score(:,3)*coeff(:,3)';
 
 xform_jrgeco1aCorr_PCA = xform_jrgeco1aCorr - deltaWave;
 
data2 = zeros(128*128,size(xform_jrgeco1aCorr_PCA,2));
data2(mask,:) = xform_jrgeco1aCorr_PCA;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr_PCA = data2;

data2 = zeros(128*128,size(xform_jrgeco1aCorr,2));
data2(mask,:) = xform_jrgeco1aCorr;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr = data2;

data2 = zeros(128*128,size(deltaWave,2));
data2(mask,:) = deltaWave;
data2 = reshape(data2,128,128,[]);
deltaWave = data2;



[hz,powerdata_jrgeco1aCorr_PCA] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_PCA))/0.01,25,mask);



 
 deltaWave_def = score_def(:,1)*coeff_def(:,1)' + score_def(:,2)*coeff_def(:,2)' + score_def(:,3)*coeff_def(:,3)';
 data2 = zeros(128*128,size(deltaWave_def,2));
data2(mask,:) = deltaWave_def;
data2 = reshape(data2,128,128,[]);
deltaWave_def = data2;

 xform_jrgeco1aCorr_PCA_def = xform_jrgeco1aCorr - deltaWave_def;
 
data2 = zeros(128*128,size(xform_jrgeco1aCorr_PCA_def,2));
data2(mask,:) = xform_jrgeco1aCorr_PCA_def;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr_PCA_def = data2;





data2 = zeros(128*128,size(deltaWave_def,2));
data2(mask,:) = deltaWave_def;
data2 = reshape(data2,128,128,[]);
deltaWave_def = data2;

data2 = zeros(128*128,size(xform_jrgeco1aCorr,2));
data2(mask,:) = xform_jrgeco1aCorr;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr = data2;

for ii = 1:14999;
subplot(2,3,1)
imagesc(xform_jrgeco1aCorr(:,:,ii)*100,[-9 9])
axis image 
set(gca,'ytick',[])
set(gca,'xtick',[])
ylabel('5 component','Fontsize',14,'Fontweight','bold')
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('Original')
subplot(2,3,2)
imagesc(xform_jrgeco1aCorr_PCA(:,:,ii)*100,[-9 9])
axis image off
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('Minus 3PC')
subplot(2,3,3)
imagesc(deltaWave(:,:,ii)*100,[-9 9])
axis image off
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('3PC')
suptitle(strcat('time = ',num2str(ii/25)))

subplot(2,3,4)
imagesc(xform_jrgeco1aCorr(:,:,ii)*100,[-9 9])
axis image 
set(gca,'ytick',[])
set(gca,'xtick',[])
ylabel('8919 component','Fontsize',14,'Fontweight','bold')
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('Original')
subplot(2,3,5)
imagesc(xform_jrgeco1aCorr_PCA_def(:,:,ii)*100,[-9 9])
axis image off
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('Minus 3PC')
subplot(2,3,6)
imagesc(deltaWave_def(:,:,ii)*100,[-9 9])
axis image off
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('3PC')
suptitle(strcat('time = ',num2str(ii/25)))
pause(0.1)
end

for ii = 1:14999;
subplot(1,3,1)
imagesc(xform_jrgeco1aCorr(:,:,ii)*100,[-9 9])
axis image 
set(gca,'ytick',[])
set(gca,'xtick',[])
ylabel('5 component','Fontsize',14,'Fontweight','bold')
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('Original')
subplot(1,3,2)
imagesc(xform_jrgeco1aCorr_PCA(:,:,ii)*100,[-9 9])
axis image off
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('Minus 3PC')
subplot(1,3,3)
imagesc(deltaWave(:,:,ii)*100,[-9 9])
axis image off
colormap jet
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
title('3PC')
suptitle(strcat('time = ',num2str(ii/25)))
pause;
end
 
 figure
loglog(hz,powerdata_jrgeco1aCorr/interp1(hz',powerdata_jrgeco1aCorr,0.01),'r')
hold on
loglog(hz,powerdata_jrgeco1aCorr_PCA/interp1(hz',powerdata_jrgeco1aCorr_PCA,0.01),'g')
hold on
loglog(hz,powerdata_jrgeco1aCorr_GSR/interp1(hz',powerdata_jrgeco1aCorr_GSR,0.01),'b')
xlim([0.01,12.5])
legend('Original','PCA','GSR')


sum = 0;
for ii = 1:8919
    sum = sum + score_def(:,ii)*coeff_def(:,ii)';
    disp(num2str(ii));
end

data2 = zeros(128*128,size(sum,2));
data2(mask,:) = sum;
data2 = reshape(data2,128,128,[]);
sum = data2;

for ii = 1:14999
    subplot(1,3,1)
    imagesc(xform_jrgeco1aCorr(:,:,ii),[-0.1 0.1]);
    axis image off
    title('Original')
    colormap jet
    subplot(1,3,2)
    imagesc(sum(:,:,ii),[-0.1 0.1]);
    axis image off
    title('Sum of PC')
    subplot(1,3,3)
    imagesc(sum(:,:,ii)-xform_jrgeco1aCorr(:,:,ii),[-0.1 0.1])
    title('Difference')
    axis image off
    pause
end