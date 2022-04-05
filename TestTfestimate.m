load('190627-R5M2286-fc3_processed.mat', 'xform_jrgeco1aCorr')
load('190627-R5M2286-fc3_processed.mat', 'xform_datahb')
load('L:\RGECO\Kenny\190627\190627-R5M2286-fc2-dataFluor')
xform_
total = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));

xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
total(isnan(total)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
total(isinf(total)) = 0;

xform_jrgeco1aCorr_filtered = filterData_isbrain(xform_jrgeco1aCorr,0.02,2,25,xform_isbrain);
total_filtered = filterData_isbrain(total,0.02,2,25,xform_isbrain);

txy = nan(128,128,2409);
for ii = 1:128
    for jj = 1:128
        if xform_isbrain(ii,jj)
        txy = tfestimate(squeeze(xform_jrgeco1aCorr(ii,jj,:)),squeeze(total(ii,jj,:)));
        end
    end
end