load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')
saveDir = 'L:\RGECO\190710\';
refseeds=GetReferenceSeeds_xw;
[R_jrgeco1aCorr_Delta,Rs_jrgeco1aCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr),25,xform_isbrain,[0.4,4],false);
ibi = reshape(xform_isbrain,128*128,1);
R_jrgeco1aCorr_Delta_minusMean = nan(size(R_jrgeco1aCorr_Delta));
Rs_jrgeco1aCorr_Delta_minusMean = nan(size(Rs_jrgeco1aCorr_Delta));
for ii =  1:16
    
    R_reshape = reshape(R_jrgeco1aCorr_Delta(:,:,ii),128*128,1);
    avg = mean(R_reshape(ibi),1);
    R_jrgeco1aCorr_Delta_minusMean(:,:,ii) =  R_jrgeco1aCorr_Delta(:,:,ii) -avg;
    Rs_jrgeco1aCorr_Delta_minusMean(ii,:) = Rs_jrgeco1aCorr_Delta(ii,:)-avg;
      Rs_jrgeco1aCorr_Delta_minusMean(:,ii) = Rs_jrgeco1aCorr_Delta(:,ii)-avg;
end

visName = '190710-R5M2285-anes-fc1-minusAvg-DeltaFC';
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_minusMean, Rs_jrgeco1aCorr_Delta_minusMean,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
visName = '190710-R5M2285-anes-fc1-NoGSR-DeltaFC';
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
