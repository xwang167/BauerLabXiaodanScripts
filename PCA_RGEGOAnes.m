close all
clear all
clc
load('L:\RGECO\190710\190710-R5M2285-anes-stim1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\190710\190710-R5M2285-anes-stim1_processed.mat', 'xform_jrgeco1aCorr_GSR')
 load('D:\OIS_Process\noVasculatureMask.mat')
 
 mask = logical(leftMask+rightMask);
 xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,[],7500);
 xform_jrgeco1aCorr = xform_jrgeco1aCorr(logical(mask),:);
 [coeff,score,latent,tsquared,explained,mu] = pca(xform_jrgeco1aCorr);
 
 deltaWave = score(:,2)*coeff(:,2)';
 
 xform_jrgeco1aCorr_PCA = xform_jrgeco1aCorr - deltaWave;
 

data2 = nan(128*128,size(xform_jrgeco1aCorr_PCA,2));
data2(mask,:) = xform_jrgeco1aCorr_PCA;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr_PCA = data2;

data2 = nan(128*128,size(xform_jrgeco1aCorr,2));
data2(mask,:) = xform_jrgeco1aCorr;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr = data2;
 

xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,10);
xform_jrgeco1aCorr_PCA = reshape(xform_jrgeco1aCorr_PCA,128,128,750,10);
xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,750,10);
xform_jrgeco1aCorr = mean(xform_jrgeco1aCorr,4);
xform_jrgeco1aCorr_PCA = mean(xform_jrgeco1aCorr_PCA,4);
xform_jrgeco1aCorr_GSR = mean(xform_jrgeco1aCorr_GSR,4);

peakMap = mean(xform_jrgeco1aCorr_GSR(:,:, 126:250),3);
imagesc(peakMap,[-0.03 0.03]);

  [x1,y1] = ginput(1);
    
    [x2,y2] = ginput(1);
    
    [X,Y] = meshgrid(1:128,1:128);
    
    radius = sqrt((x1-x2)^2+(y1-y2)^2);
    
    ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
    
    max_ROI = prctile(peakMap(ROI),99);
    
    temp = peakMap.*ROI;
    
    ROI = temp>0.75*max_ROI;
    
    time = (1:750)/25;
  ROI = logical(ROI);
  xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,[],750);
  xform_jrgeco1aCorr_PCA = reshape(xform_jrgeco1aCorr_PCA,[],750);
  xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,[],750);
 
ORI = nanmean(xform_jrgeco1aCorr(ROI,:),1);
PCA = nanmean(xform_jrgeco1aCorr_PCA(ROI,:),1);
GSR = nanmean(xform_jrgeco1aCorr_GSR(ROI,:),1);
figure
  plot(time, ORI,'r' )
    hold on
    plot(time,PCA,'g')
    hold on
    plot(time,GSR,'b')
    
    legend('Original','1st PC','GSR')
    