
load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_jrgeco1aCorr','xform_datahb')
xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
calcium = squeeze(xform_jrgeco1aCorr(76,91,:));
calcium = reshape(calcium,1,1,[]);
calcium = mouse.freq.filterData(calcium,0.02,2,25);
% calcium = normRow(reshape(calcium,1,[]));
% calcium = reshape(calcium,1,1,[]);

HbO = squeeze(xform_datahb(76,91,1,:));
HbR = squeeze(xform_datahb(76,91,2,:));
HbO = reshape(HbO,1,1,[]);
HbR = reshape(HbR,1,1,[]);
HbO = mouse.freq.filterData(HbO,0.02,2,25);
HbR = mouse.freq.filterData(HbR,0.02,2,25);
HbT = HbO + HbR;
% HbT = normRow(reshape(HbT,1,[]));
% HbT = reshape(HbT,1,1,[]);
figure
plot((1:2500)/25,transpose(squeeze(HbT(1,1,1:2500))*10^6),'k')
hold on
plot((1:2500)/25,transpose(squeeze(calcium(1,1,1:2500))),'m')


t = (1:750)/25;
[T_test,W_test,A_test,r_test,r2_test,hemoPred_test] = interSpeciesGammaFit_xw(calcium,HbT*10*6,t);



t = (1:750)/25;
[T_NoNorm_1_750,W_NoNorm_1_750,A_NoNorm_1_750,r_NoNorm_1_750,r2_NoNorm_1_750,hemoPred_NoNorm_1_750] = interSpeciesGammaFit_xw(calcium,HbT,t);


t = (0:750)/25;
[T_NoNorm_0_750,W_NoNorm_0_750,A_NoNorm_0_750,r_NoNorm_0_750,r2_NoNorm_0_750,hemoPred_NoNorm_0_750] = interSpeciesGammaFit_xw(calcium,HbT,t);

t = (1:750)/25;
[T_Norm_1_750,W_Norm_1_750,A_Norm_1_750,r_Norm_1_750,r2_Norm_1_750,hemoPred_Norm_1_750] = interSpeciesGammaFit_xw(calcium,HbT,t);

t = (0:750)/25;
[T_Norm_0_750,W_Norm_0_750,A_Norm_0_750,r_Norm_0_750,r2_Norm_0_750,hemoPred_Norm_0_750] = interSpeciesGammaFit_xw(calcium,HbT,t);





t = (1:750)/25;
[T_NoNorm_1_750_CalciumHbT,W_NoNorm_1_750_CalciumHbT,A_NoNorm_1_750_CalciumHbT,r_NoNorm_1_750_CalciumHbT,r2_NoNorm_1_750_CalciumHbT,hemoPred_NoNorm_1_750_CalciumHbT] = interSpeciesGammaFit_CalciumHbT(calcium,HbT,t);


t = (0:750)/25;
[T_NoNorm_0_750_CalciumHbT,W_NoNorm_0_750_CalciumHbT,A_NoNorm_0_750_CalciumHbT,r_NoNorm_0_750_CalciumHbT,r2_NoNorm_0_750_CalciumHbT,hemoPred_NoNorm_0_750_CalciumHbT] = interSpeciesGammaFit_CalciumHbT(calcium,HbT,t);

t = (1:750)/25;
[T_Norm_1_750_CalciumHbT,W_Norm_1_750_CalciumHbT,A_Norm_1_750_CalciumHbT,r_Norm_1_750_CalciumHbT,r2_Norm_1_750_CalciumHbT,hemoPred_Norm_1_750_CalciumHbT] = interSpeciesGammaFit_CalciumHbT(calcium,HbT,t);

t = (0:750)/25;
[T_Norm_0_750_CalciumHbT,W_Norm_0_750_CalciumHbT,A_Norm_0_750_CalciumHbT,r_Norm_0_750_CalciumHbT,r2_Norm_0_750_CalciumHbT,hemoPred_Norm_0_750_CalciumHbT] = interSpeciesGammaFit_CalciumHbT(calcium,HbT,t);






calcium = squeeze(xform_jrgeco1aCorr);
calcium = mouse.freq.filterData(calcium,0.02,2,25);
calcium = normRow(reshape(calcium,1,[]));
calcium = reshape(calcium,1,1,[]);

HbO = squeeze(xform_datahb(71,10,1,:));
HbR = squeeze(xform_datahb(71,10,2,:));
HbO = reshape(HbO,1,1,[]);
HbR = reshape(HbR,1,1,[]);
HbO = mouse.freq.filterData(HbO,0.02,2,25);
HbR = mouse.freq.filterData(HbR,0.02,2,25);
HbT = HbO + HbR;
HbT = normRow(reshape(HbT,1,[]));
HbT = reshape(HbT,1,1,[]);


[T3,W3,A3,r3,r23,hemoPred3] = interSpeciesGammaFit_xw(calcium,HbT,t);
[T_test,W_test,A_test,r_test,r2_test,hemoPred] = interSpeciesGammaFit_xw(calcium,HbT,t);