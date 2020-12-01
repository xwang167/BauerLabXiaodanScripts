load('L:\RGECO\190710\190710-R5M2285-anes-stim1_processed.mat','xform_jrgeco1aCorr')
calcium = reshape(xform_jrgeco1aCorr,[], size(xform_jrgeco1aCorr,3));
clear xform_jrgeco1aCorr
