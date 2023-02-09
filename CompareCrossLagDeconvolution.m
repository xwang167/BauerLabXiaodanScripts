load('X:\RGECO\deconvolution_regions.mat', 'HRF_awake', 'MRF_awake', 'HRF_anes', 'MRF_anes')
load('X:\RGECO\crossLag_allRegions.mat', 'crossLagY_NVC_awake_mice', 'crossLagY_NMC_awake_mice', 'crossLagY_NVC_anes_mice', 'crossLagY_NMC_anes_mice')
load('Gamma_regions.mat', 'T_NVC_awake_median', 'W_NVC_awake_median', 'A_NVC_awake_median', 'T_NMC_awake_median', 'W_NMC_awake_median', 'A_NMC_awake_median',...
    'T_NVC_anes_median', 'W_NVC_anes_median', 'A_NVC_anes_median', 'T_NMC_anes', 'W_NMC_anes', 'A_NMC_anes')
freq_new = 250;
t_kernel = 30;

t_deconvolution = (-3*freq_new :(t_kernel-3)*freq_new-1)/freq_new;
t_crossLag = crossLagX_NVC(1,:,1);
t_gamma = (0 :(t_kernel-3)*freq_new-1)/freq_new;

% gamma function for NVC awake
alpha_NVC_awake = (T_NVC_awake/W_NVC_awake)^2*8*log(2);
beta_NVC_awake = W_NVC_awake^2/(T_NVC_awake*8*log(2));
y_NVC_awake = A_NVC_awake*(t_gamma/T_NVC_awake).^alpha_NVC_awake.*exp((t_gamma-T_NVC_awake)/(-beta_NVC_awake));
y_NVC_awake(isnan(y_NVC_awake)) = 0;

% gamma function for NMC awake
alpha_NMC_awake = (T_NMC_awake/W_NMC_awake)^2*8*log(2);
beta_NMC_awake = W_NMC_awake^2/(T_NMC_awake*8*log(2));
y_NMC_awake = A_NMC_awake*(t_gamma/T_NMC_awake).^alpha_NMC_awake.*exp((t_gamma-T_NMC_awake)/(-beta_NMC_awake));
y_NMC_awake(isnan(y_NMC_awake)) = 0;

% gamma function for NVC anesthetized
alpha_NVC_anes = (T_NVC_anes/W_NVC_anes)^2*8*log(2);
beta_NVC_anes = W_NVC_anes^2/(T_NVC_anes*8*log(2));
y_NVC_anes = A_NVC_anes*(t_gamma/T_NVC_anes).^alpha_NVC_anes.*exp((t_gamma-T_NVC_anes)/(-beta_NVC_anes));
y_NVC_anes(isnan(y_NVC_anes)) = 0; 

% gamma function for NMC anesthetized
alpha_NMC_anes = (T_NMC_anes/W_NMC_anes)^2*8*log(2);
beta_NMC_anes = W_NMC_anes^2/(T_NMC_anes*8*log(2));
y_NMC_anes = A_NMC_anes*(t_gamma/T_NMC_anes).^alpha_NMC_anes.*exp((t_gamma-T_NMC_anes)/(-beta_NMC_anes));
y_NMC_anes(isnan(y_NMC_anes)) = 0; 


figure
subplot(2,2,1)
plot_distribution_prctile(t_crossLag,crossLagY_NVC_awake,'Color',[1,0,0]);
hold on
ylim([-0.15 0.6])
ylabel('r')
yyaxis right
set(gca,{'ycolor'},{'b'})
plot_distribution_prctile(t_deconvolution,HRF_awake,'Color',[0,0,1])
hold on

ylim([-0.001 0.004])
xlabel('Time(t)')
grid on
title('Awake NVC')
xlim([-1 4])

subplot(2,2,2)
plot_distribution_prctile(t_crossLag,crossLagY_NMC_awake,'Color',[1,0,0])
hold on
ylim([-0.2 0.8])
ylabel('r')
yyaxis right
set(gca,{'ycolor'},{'b'})
plot_distribution_prctile(t_deconvolution,MRF_awake,'Color',[0,0,1])
ylim([-0.0004 0.0016])
xlabel('Time(t)')
grid on
title('Awake NMC')
xlim([-1 4])

subplot(2,2,3)
plot_distribution_prctile(t_crossLag,crossLagY_NVC_anes,'Color',[1,0,0])
hold on
ylim([-0.1 0.25])
ylabel('r')
yyaxis right
set(gca,{'ycolor'},{'b'})
plot_distribution_prctile(t_deconvolution,HRF_anes,'Color',[0,0,1])
ylim([-0.0004 0.001])
xlabel('Time(t)')
grid on
title('Anesthetized NVC')
xlim([-1 4])

subplot(2,2,4)
plot_distribution_prctile(t_crossLag,crossLagY_NMC_anes,'Color',[1,0,0])
hold on
ylim([-0.5 1])
ylabel('r')
yyaxis right
set(gca,{'ycolor'},{'b'})
plot_distribution_prctile(t_deconvolution,MRF_anes,'Color',[0,0,1])
ylim([-0.0008 0.0016])
xlabel('Time(t)')
grid on
title('Anesthetized NMC')
xlim([-1 4])
sgtitle('Red is Cross Lag, Blue is Deconvolution')

[~,I_HRF_awake] = max(HRF_awake_median);
t_deconvolution(I_HRF_awake)

[~,I_HRF_anes] = max(HRF_anes_median);
t_deconvolution(I_HRF_anes)

[~,I_MRF_awake] = max(MRF_awake_median);
t_deconvolution(I_MRF_awake)

[~,I_MRF_anes] = max(MRF_anes_median);
t_deconvolution(I_MRF_anes)