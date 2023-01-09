figure
plot(t,y_NVC_awake,'r-')
hold on
plot(t,y_NVC_anes,'r--')
hold on
yyaxis right
plot(t,HRF_awake_median,'b-')
hold on
plot(t,HRF_anes_median,'b--')
title('NVC')
legend('Gamma Awake','Gamma Anesthetized','Deconvolution Awake','Deconvolution Anesthetized')

figure
plot(t,y_NMC_awake,'r-')
hold on
plot(t,y_NMC_anes,'r--')
hold on
yyaxis right
plot(t,MRF_awake_median,'b-')
hold on
plot(t,MRF_anes_median,'b--')
title('NMC')
legend('Gamma Awake','Gamma Anesthetized','Deconvolution Awake','Deconvolution Anesthetized')