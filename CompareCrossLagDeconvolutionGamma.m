load('D:\XiaodanPaperData\cat\deconvolution_allRegions.mat', 'HRF_mice_awake', 'MRF_mice_awake', 'HRF_mice_anes', 'MRF_mice_anes')
load('E:\RGECO\cat\crossLag_allRegions.mat')
load('E:\RGECO\cat\Gamma_allRegions.mat', 'y_NVC_mice_awake','y_NVC_mice_anes','y_NMC_mice_awake','y_NMC_mice_anes')
freq_new = 250;
t_kernel = 30;

t_deconvolution = (-3*freq_new :(t_kernel-3)*freq_new-1)/freq_new;
t_crossLag = crossLagX_NVC(1,:,1);
t_gamma = (0 :t_kernel*freq_new-1)/freq_new;

% gamma function for NVC awake
% alpha_NVC_awake = (T_NVC_awake_median/W_NVC_awake_median)^2*8*log(2);
% beta_NVC_awake = W_NVC_awake_median^2/(T_NVC_awake_median*8*log(2));
% y_NVC_awake = A_NVC_awake_median*(t_gamma/T_NVC_awake_median).^alpha_NVC_awake.*exp((t_gamma-T_NVC_awake_median)/(-beta_NVC_awake));
% y_NVC_awake(isnan(y_NVC_awake)) = 0;
% 
% % gamma function for NMC awake
% alpha_NMC_awake = (T_NMC_awake_median/W_NMC_awake_median)^2*8*log(2);
% beta_NMC_awake = W_NMC_awake_median^2/(T_NMC_awake_median*8*log(2));
% y_NMC_awake = A_NMC_awake_median*(t_gamma/T_NMC_awake_median).^alpha_NMC_awake.*exp((t_gamma-T_NMC_awake_median)/(-beta_NMC_awake));
% y_NMC_awake(isnan(y_NMC_awake)) = 0;
% 
% % gamma function for NVC anesthetized
% alpha_NVC_anes = (T_NVC_anes_median/W_NVC_anes_median)^2*8*log(2);
% beta_NVC_anes = W_NVC_anes_median^2/(T_NVC_anes_median*8*log(2));
% y_NVC_anes = A_NVC_anes_median*(t_gamma/T_NVC_anes_median).^alpha_NVC_anes.*exp((t_gamma-T_NVC_anes_median)/(-beta_NVC_anes));
% y_NVC_anes(isnan(y_NVC_anes)) = 0; 
% 
% % gamma function for NMC anesthetized
% alpha_NMC_anes = (T_NMC_anes_median/W_NMC_anes_median)^2*8*log(2);
% beta_NMC_anes = W_NMC_anes_median^2/(T_NMC_anes_median*8*log(2));
% y_NMC_anes = A_NMC_anes_median*(t_gamma/T_NMC_anes_median).^alpha_NMC_anes.*exp((t_gamma-T_NMC_anes_median)/(-beta_NMC_anes));
% y_NMC_anes(isnan(y_NMC_anes)) = 0; 
% 


%% Visualization
figure
subplot(2,3,1)
plot_distribution_prctile(t_deconvolution,HRF_mice_awake,'Color',[1,0,1])
hold on
plot_distribution_prctile(t_deconvolution,HRF_mice_anes,'Color',[0,0.5,0])
title('Deconvolution, NVC')
xlim([-1 4])
title('Time(s)')
xlabel('Time(s)')
ylabel('Amplitude')
subplot(2,3,4)
plot_distribution_prctile(t_deconvolution,MRF_mice_awake,'Color',[1,0,1])
hold on
plot_distribution_prctile(t_deconvolution,MRF_mice_anes,'Color',[0,0.5,0])
title('Deconvolution, NMC')
xlim([-1 4])
title('Time(s)')
xlabel('Time(s)')
ylabel('Amplitude')
subplot(2,3,2)
plot_distribution_prctile(t_gamma,        y_NVC_mice_awake,'Color',[1,0,1])
hold on
plot_distribution_prctile(t_gamma,        y_NVC_mice_anes,'Color',[0,0.5,0])
title('Gamma Variate Function, NVC')
xlim([-1 4])
xlabel('Time(s)')
ylabel('Amplitude')
subplot(2,3,5)
plot_distribution_prctile(t_gamma,        y_NMC_mice_awake,'Color',[1,0,1])
hold on
plot_distribution_prctile(t_gamma,        y_NMC_mice_anes,'Color',[0,0.5,0])
title('Gamma Variate Function, NMC')
xlim([-1 4])
xlabel('Time(s)')
ylabel('Amplitude')
subplot(2,3,3)
plot_distribution_prctile(t_crossLag,     crossLagY_NVC_mice_awake,'Color',[1,0,1]);
hold on
plot_distribution_prctile(t_crossLag,     crossLagY_NVC_mice_anes,'Color',[0,0.5,0]);
title('Cross Correlation, NVC')
xlim([-1 4])
xlabel('Time(s)')
ylabel('Correlation Coefficient')
subplot(2,3,6)
plot_distribution_prctile(t_crossLag,     crossLagY_NMC_mice_awake,'Color',[1,0,1]);
hold on
plot_distribution_prctile(t_crossLag,     crossLagY_NMC_mice_anes,'Color',[0,0.5,0]);
title('Cross Correlation, NMC')
xlim([-1 4])
xlabel('Time(s)')
ylabel('Correlation Coefficient')
saveas(gcf,'X:\Paper1\Figure_2023\LagPlotsAwakevsAnes.fig')

figure
subplot(2,2,1)
plot_distribution_prctile(t_crossLag,     crossLagY_NVC_mice_awake/max(median(crossLagY_NVC_mice_awake)),'Color',[1,0,0]);
hold on
plot_distribution_prctile(t_deconvolution,HRF_mice_awake/max(median(HRF_mice_awake)),'Color',[0,0,1])
hold on
plot_distribution_prctile(t_gamma,        y_NVC_mice_awake/max(median(y_NVC_mice_awake)),'Color',[0,0,0])
xlabel('Time(s)')

title('Awake NVC')
xlim([-1 4])

subplot(2,2,2)
plot_distribution_prctile(t_crossLag,crossLagY_NMC_mice_awake/max(median(crossLagY_NMC_mice_awake)),'Color',[1,0,0])
hold on
plot_distribution_prctile(t_deconvolution,MRF_mice_awake/max(median(MRF_mice_awake)),'Color',[0,0,1])
hold on
plot_distribution_prctile(t_gamma,y_NMC_mice_awake/max(median(y_NMC_mice_awake)),'Color',[0,0,0])
xlabel('Time(s)')

title('Awake NMC')
xlim([-1 4])

subplot(2,2,3)
plot_distribution_prctile(t_crossLag,crossLagY_NVC_mice_anes/max(median(crossLagY_NVC_mice_anes)),'Color',[1,0,0])
hold on
plot_distribution_prctile(t_deconvolution,HRF_mice_anes/max(median(HRF_mice_anes)),'Color',[0,0,1])
hold on
plot_distribution_prctile(t_gamma,y_NVC_mice_anes/max(median(y_NVC_mice_anes)),'Color',[0,0,0])
xlabel('Time(s)')

title('Anesthetized NVC')
xlim([-1 4])

subplot(2,2,4)
plot_distribution_prctile(t_crossLag,crossLagY_NMC_mice_anes/max(median(crossLagY_NMC_mice_anes)),'Color',[1,0,0])
hold on
plot_distribution_prctile(t_deconvolution,MRF_mice_anes/max(median(MRF_mice_anes)),'Color',[0,0,1])
hold on
plot_distribution_prctile(t_gamma,y_NMC_mice_anes/max(median(y_NMC_mice_anes)),'Color',[0,0,0])
xlabel('Time(s)')

title('Anesthetized NMC')
xlim([-1 4])
sgtitle('Red is Cross Lag, Blue is Deconvolution, Black is Gamma')
saveas(gcf,'X:\Paper1\Figure_2023\LagPlotsComparison.fig')
% 
% [~,I_HRF_awake] = max(HRF_awake_median);
% t_deconvolution(I_HRF_awake)
% 
% [~,I_HRF_anes] = max(HRF_anes_median);
% t_deconvolution(I_HRF_anes)
% 
% [~,I_MRF_awake] = max(MRF_awake_median);
% t_deconvolution(I_MRF_awake)
% 
% [~,I_MRF_anes] = max(MRF_anes_median);
% t_deconvolution(I_MRF_anes)