% load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat',...
%     'R_FADCorr_Delta_mice', 'R_FADCorr_ISA_mice', ...
%     'R_jrgeco1aCorr_Delta_mice', 'R_jrgeco1aCorr_ISA_mice',...
%     'R_total_Delta_mice', 'R_total_ISA_mice','xform_isbrain_mice')


load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat',...
    'R_FADCorr_Delta_mice', 'R_FADCorr_ISA_mice', ...
    'R_jrgeco1aCorr_Delta_mice', 'R_jrgeco1aCorr_ISA_mice',...
    'R_total_Delta_mice', 'R_total_ISA_mice','xform_isbrain_mice')




 save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat','xform_isbrain_mice')
 

xform_isbrain_mice_matrix = logical(repmat(xform_isbrain_mice,1,1,16));
figure
R_jrgeco1aCorr_Delta_mice_his = histogram(R_jrgeco1aCorr_Delta_mice(xform_isbrain_mice_matrix),'FaceColor','r');
hold on
R_jrgeco1aCorr_ISA_mice_his = histogram(R_jrgeco1aCorr_ISA_mice(xform_isbrain_mice_matrix),'FaceColor','b');
legend('Delta','ISA')
title('RGECO')

figure
R_FADCorr_Delta_mice_his = histogram(R_FADCorr_Delta_mice(xform_isbrain_mice_matrix),'FaceColor','r');
hold on
R_FADCorr_ISA_mice_his = histogram(R_FADCorr_ISA_mice(xform_isbrain_mice_matrix),'FaceColor','b');
legend('Delta','ISA')
title('FAD')

figure
R_total_Delta_mice_his = histogram(R_total_Delta_mice(xform_isbrain_mice_matrix),'FaceColor','r');
hold on
R_total_ISA_mice_his = histogram(R_total_ISA_mice(xform_isbrain_mice_matrix),'FaceColor','b');
legend('Delta','ISA')
title('HbT')


figure
R_jrgeco1aCorr_Delta_mice_his_awake = histogram(R_jrgeco1aCorr_Delta_mice_awake(xform_isbrain_mice_matrix),'FaceColor','m');
hold on
R_jrgeco1aCorr_Delta_mice_his = histogram(R_jrgeco1aCorr_Delta_mice(xform_isbrain_mice_matrix),'FaceColor','g');
legend('Awake', 'Anes')
title('RGECO Delta')

figure
R_jrgeco1aCorr_ISA_mice_his_awake = histogram(R_jrgeco1aCorr_ISA_mice_awake(xform_isbrain_mice_matrix),'FaceColor','m');
hold on
R_jrgeco1aCorr_ISA_mice_his = histogram(R_jrgeco1aCorr_ISA_mice(xform_isbrain_mice_matrix),'FaceColor','g');
legend('Awake', 'Anes')
title('RGECO ISA')

figure
R_FADCorr_Delta_mice_his_awake = histogram(R_FADCorr_Delta_mice_awake(xform_isbrain_mice_matrix),'FaceColor','m');
hold on
R_FADCorr_Delta_mice_his = histogram(R_FADCorr_Delta_mice(xform_isbrain_mice_matrix),'FaceColor','g');
legend('Awake', 'Anes')
title('FAD Delta')

figure
R_FADCorr_ISA_mice_his_awake = histogram(R_FADCorr_ISA_mice_awake(xform_isbrain_mice_matrix),'FaceColor','m');
hold on
R_FADCorr_ISA_mice_his = histogram(R_FADCorr_ISA_mice(xform_isbrain_mice_matrix),'FaceColor','g');
legend('Awake', 'Anes')
title('FAD ISA')

figure
R_total_Delta_mice_his_awake = histogram(R_total_Delta_mice_awake(xform_isbrain_mice_matrix),'FaceColor','m');
hold on
R_total_Delta_mice_his = histogram(R_total_Delta_mice(xform_isbrain_mice_matrix),'FaceColor','g');
legend('Awake', 'Anes')
title('HbT Delta')

figure
R_total_ISA_mice_his_awake = histogram(R_total_ISA_mice_awake(xform_isbrain_mice_matrix),'FaceColor','m');
hold on
R_total_ISA_mice_his = histogram(R_total_ISA_mice(xform_isbrain_mice_matrix),'FaceColor','g');
legend('Awake', 'Anes')
title('HbT ISA')