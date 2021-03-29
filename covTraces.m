clear all
close all
clc

load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','FAD_ROI_NoGSR', 'calcium_ROI_NoGSR', 'total_ROI_NoGSR', 'FAD_ROI_GSR', 'calcium_ROI_GSR', 'total_ROI_GSR')

calcium_ROI_NoGSR_awake = normRow(calcium_ROI_NoGSR);
FAD_ROI_NoGSR_awake = normRow(FAD_ROI_NoGSR);
total_ROI_NoGSR_awake = normRow(total_ROI_NoGSR);

calcium_ROI_GSR_awake = normRow(calcium_ROI_GSR);
FAD_ROI_GSR_awake = normRow(FAD_ROI_GSR);
total_ROI_GSR_awake = normRow(total_ROI_GSR);

mld = fitlm(calcium_ROI_NoGSR_awake,FAD_ROI_NoGSR_awake);
figure
scatter(calcium_ROI_NoGSR_awake,FAD_ROI_NoGSR_awake)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('Corrected FAD(\DeltaF/F%)')
hold on
plot(calcium_ROI_NoGSR_awake,0.012531 +0.78612*calcium_ROI_NoGSR_awake)
gtext('0.012531 + 0.78612*x')
gtext('R^2 = 0.36 ')
gtext('p = 5.17e-19')
title('Awake NoGSR')

C_NoGSR_Awake_CalciumFAD = cov(calcium_ROI_NoGSR_awake,FAD_ROI_NoGSR_awake);

mld = fitlm(calcium_ROI_GSR_awake,FAD_ROI_GSR_awake);
figure
scatter(calcium_ROI_GSR_awake,FAD_ROI_GSR_awake)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('Corrected FAD(\DeltaF/F%)')
hold on
plot(calcium_ROI_GSR_awake,0.058401+0.15957*calcium_ROI_GSR_awake)
gtext('0.058401+0.15957*x')
gtext('R^2 = 0.0244 ')
gtext('p = 0.0364')
title('Awake GSR')

C_GSR_Awake_CalciumFAD = cov(calcium_ROI_GSR_awake,FAD_ROI_GSR_awake);



mld = fitlm(calcium_ROI_NoGSR_awake,total_ROI_NoGSR_awake);
figure
scatter(calcium_ROI_NoGSR_awake,total_ROI_NoGSR_awake)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(calcium_ROI_NoGSR_awake,0.021143+0.68352 *calcium_ROI_NoGSR_awake)
gtext('0.021143+0.68352 *x')
gtext('R^2 = 0.344 ')
gtext('p = 5.35e-18')
title('Awake NoGSR')

C_NoGSR_Awake_CalciumTotal = cov(calcium_ROI_NoGSR_awake,total_ROI_NoGSR_awake);

mld = fitlm(calcium_ROI_GSR_awake,total_ROI_GSR_awake);
figure
scatter(calcium_ROI_GSR_awake,total_ROI_GSR_awake)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(calcium_ROI_GSR_awake,0.018622+0.58426*calcium_ROI_GSR_awake)
gtext('0.018622 + 0.58426*x')
gtext('R^2 = 0.116 ')
gtext('p = 2.9e-06')
title('Awake GSR')

C_GSR_Awake_Calciumtotal = cov(calcium_ROI_GSR_awake,total_ROI_GSR_awake);





mld = fitlm(FAD_ROI_NoGSR_awake,total_ROI_NoGSR_awake);
figure
scatter(FAD_ROI_NoGSR_awake,total_ROI_NoGSR_awake)
xlabel('Corrected FAD(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(FAD_ROI_NoGSR_awake,0.022071+0.64414*FAD_ROI_NoGSR_awake)
gtext('0.022071+0.64414 *x')
gtext('R^2 = 0.612')
gtext('p = 2.11e-38')
title('Awake NoGSR')

C_NoGSR_Awake_FADTotal = cov(FAD_ROI_NoGSR_awake,total_ROI_NoGSR_awake);

mld = fitlm(FAD_ROI_GSR_awake,total_ROI_GSR_awake);
figure
scatter(FAD_ROI_GSR_awake,total_ROI_GSR_awake)
xlabel('Corrected FAD(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(FAD_ROI_GSR_awake, 0.042887 + 0.23718*FAD_ROI_GSR_awake)
gtext(' 0.042887+ 0.23718*x')
gtext('R^2 = 0.02 ')
gtext('p = 0.0584')
title('Awake GSR')

C_GSR_Awake_FADtotal = cov(FAD_ROI_GSR_awake,total_ROI_GSR_awake);



load('191030--R5M2285-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-stim_processed_mice.mat', 'FAD_ROI_NoGSR', 'calcium_ROI_NoGSR', 'total_ROI_NoGSR', 'FAD_ROI_GSR', 'calcium_ROI_GSR', 'total_ROI_GSR')
calcium_ROI_NoGSR_anes = normRow(calcium_ROI_NoGSR);
FAD_ROI_NoGSR_anes = normRow(FAD_ROI_NoGSR);
total_ROI_NoGSR_anes = normRow(total_ROI_NoGSR);

calcium_ROI_GSR_anes = normRow(calcium_ROI_GSR);
FAD_ROI_GSR_anes = normRow(FAD_ROI_GSR);
total_ROI_GSR_anes = normRow(total_ROI_GSR);



mld = fitlm(calcium_ROI_NoGSR_anes,FAD_ROI_NoGSR_anes);%
figure
scatter(calcium_ROI_NoGSR_anes,FAD_ROI_NoGSR_anes)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('Corrected FAD(\DeltaF/F%)')
hold on
plot(calcium_ROI_NoGSR_anes,0.0019532+0.91945*calcium_ROI_NoGSR_anes)
gtext('0.0019532+0.91945*x')
gtext('R^2 =  0.813 ')
gtext('p = 8.05e-45')
title('anes NoGSR')

C_NoGSR_anes_CalciumFAD = cov(calcium_ROI_NoGSR_anes,FAD_ROI_NoGSR_anes);

mld = fitlm(calcium_ROI_GSR_anes,FAD_ROI_GSR_anes);
figure
scatter(calcium_ROI_GSR_anes,FAD_ROI_GSR_anes)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('Corrected FAD(\DeltaF/F%)')
hold on
plot(calcium_ROI_GSR_anes, 0.019498+ 0.64088*calcium_ROI_GSR_anes)
gtext(' 0.019498+ 0.64088*x')
gtext('R^2 = 0.249 ')
gtext('p = 6.36e-09')
title('anes GSR')

C_GSR_anes_CalciumFAD = cov(calcium_ROI_GSR_anes,FAD_ROI_GSR_anes);



mld = fitlm(calcium_ROI_NoGSR_anes,total_ROI_NoGSR_anes);
figure
scatter(calcium_ROI_NoGSR_anes,total_ROI_NoGSR_anes)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(calcium_ROI_NoGSR_anes,-0.019163+0.88691*calcium_ROI_NoGSR_anes)
gtext('-0.019163+0.88691*x')
gtext('R^2 = 0.584 ')
gtext('p = 2.99e-24')
title('anes NoGSR')

C_NoGSR_anes_CalciumTotal = cov(calcium_ROI_NoGSR_anes,total_ROI_NoGSR_anes);

mld = fitlm(calcium_ROI_GSR_anes,total_ROI_GSR_anes);
figure
scatter(calcium_ROI_GSR_anes,total_ROI_GSR_anes)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(calcium_ROI_GSR_anes,-0.084563 +1.0704*calcium_ROI_GSR_anes)
gtext('-0.084563 +1.0704*x')
gtext('R^2 = 0.284 ')
gtext('p = 3.75e-10')
title('anes GSR')

C_GSR_anes_Calciumtotal = cov(calcium_ROI_GSR_anes,total_ROI_GSR_anes);


mld = fitlm(calcium_ROI_NoGSR_anes,total_ROI_NoGSR_anes);
figure
scatter(calcium_ROI_NoGSR_anes,total_ROI_NoGSR_anes)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('Corrected total(\DeltaF/F%)')
hold on
plot(calcium_ROI_NoGSR_anes,-0.0034954+0.62567*calcium_ROI_NoGSR_anes)
gtext('-0.0034954 + 0.62567*x')
gtext('R^2 = 0.195 ')
gtext('p = 4.55e-07')
title('anes NoGSR')

C_NoGSR_anes_CalciumTotal = cov(calcium_ROI_NoGSR_anes,total_ROI_NoGSR_anes);

mld = fitlm(calcium_ROI_GSR_anes,total_ROI_GSR_anes);
figure
scatter(calcium_ROI_GSR_anes,total_ROI_GSR_anes)
xlabel('Corrected Calcium(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(calcium_ROI_GSR_anes,-0.0016891+0.44553*calcium_ROI_GSR_anes)
gtext('-0.0016891 + 0.44553*x')
gtext('R^2 = 0.0284 ')
gtext('p = 0.066')
title('anes GSR')

C_GSR_anes_Calciumtotal = cov(calcium_ROI_GSR_anes,total_ROI_GSR_anes);




mld = fitlm(FAD_ROI_NoGSR_anes,total_ROI_NoGSR_anes);
figure
scatter(FAD_ROI_NoGSR_anes,total_ROI_NoGSR_anes)
xlabel('Corrected FAD(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(FAD_ROI_NoGSR_anes,-0.013758 + 0.81723*FAD_ROI_NoGSR_anes)
gtext('-0.013758+ 0.81723*x')
gtext('R^2 = 0.516 ')
gtext('p = 2.63e-20')
title('anes NoGSR')

C_NoGSR_anes_FADTotal = cov(FAD_ROI_NoGSR_anes,total_ROI_NoGSR_anes);

mld = fitlm(FAD_ROI_GSR_anes,total_ROI_GSR_anes);
figure
scatter(FAD_ROI_GSR_anes,total_ROI_GSR_anes)
xlabel('Corrected FAD(\DeltaF/F%)')
ylabel('total(\muM)')
hold on
plot(FAD_ROI_GSR_anes,-0.036707+ 0.5252*FAD_ROI_GSR_anes)
gtext('-0.036707 + 0.5252*x')
gtext('R^2 = 0.113 ')
gtext('p = 0.00018')
title('anes GSR')

C_GSR_anes_FADtotal = cov(FAD_ROI_GSR_anes,total_ROI_GSR_anes);


