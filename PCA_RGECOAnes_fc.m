close all
clear all
clc
load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
 load('D:\OIS_Process\noVasculatureMask.mat')
 mask = leftMask+rightMask;
  [hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr))/0.01,25,mask);
 xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,mask);
  [hz,powerdata_jrgeco1aCorr_GSR] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_GSR))/0.01,25,mask);
                    
 mask = logical(leftMask+rightMask);
 xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,[],14999);
 xform_jrgeco1aCorr = xform_jrgeco1aCorr(logical(mask),:);
 [coeff,score,latent,tsquared,explained,mu] = pca(xform_jrgeco1aCorr,'NumComponents',5);
 
 deltaWave = score(:,2)*coeff(:,2)';
 
 xform_jrgeco1aCorr_PCA = xform_jrgeco1aCorr - deltaWave;
 
data2 = zeros(128*128,size(xform_jrgeco1aCorr_PCA,2));
data2(mask,:) = xform_jrgeco1aCorr_PCA;
data2 = reshape(data2,128,128,[]);
xform_jrgeco1aCorr_PCA = data2;

[hz,powerdata_jrgeco1aCorr_PCA] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_PCA))/0.01,25,mask);


 
    figure
loglog(hz,powerdata_jrgeco1aCorr/interp1(hz',powerdata_jrgeco1aCorr,0.01),'r')
hold on
loglog(hz,powerdata_jrgeco1aCorr_PCA/interp1(hz',powerdata_jrgeco1aCorr_PCA,0.01),'g')
hold on
loglog(hz,powerdata_jrgeco1aCorr_GSR/interp1(hz',powerdata_jrgeco1aCorr_GSR,0.01),'b')
xlim([0.01,12.5])
