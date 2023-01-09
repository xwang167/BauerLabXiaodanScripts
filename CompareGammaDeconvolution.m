t_gamma = (0:t_kernel*freq_new-1)/freq_new ;
t_deconvolution = (-3*freq_new:(t_kernel-3)*freq_new-1)/freq_new ;

figure('units','normalized','outerposition',[0 0 1 1])
plot(t_gamma,y_NVC_awake,'r-')
hold on
plot(t_gamma,y_NVC_anes,'r--')
hold on
ylim([-0.000305 0.0046])
yyaxis right
plot(t_deconvolution,HRF_awake_median,'b-')
hold on
plot(t_deconvolution,HRF_anes_median,'b--')
title('NVC')
ylim([-0.0053 0.08])
legend('Gamma Awake','Gamma Anesthetized','Deconvolution Awake','Deconvolution Anesthetized')
xlim([-3 10])

figure('units','normalized','outerposition',[0 0 1 1])
plot(t_gamma,y_NMC_awake,'r-')
hold on
plot(t_gamma,y_NMC_anes,'r--')
hold on
ylim([-0.00077,0.0035])
yyaxis right
plot(t_deconvolution,MRF_awake_median,'b-')
hold on
plot(t_deconvolution,MRF_anes_median,'b--')
ylim([-0.0046,0.021])
title('NMC')
legend('Gamma Awake','Gamma Anesthetized','Deconvolution Awake','Deconvolution Anesthetized')
xlim([-3 10])

[A_awake,T_awake,W_awake] = findpeaks(MRF_awake_median,t_deconvolution,'MinPeakProminence',0.004);
[A_anes,T_anes,W_anes] = findpeaks(MRF_anes_median,t_deconvolution,'MinPeakProminence',0.003);