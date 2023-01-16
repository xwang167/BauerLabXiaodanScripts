load('deconvolution_regions.mat', 'HRF_awake', 'MRF_awake', 'HRF_anes', 'MRF_anes')
load('CrossLag_regions_upsample.mat', 'crossLagY_NVC_awake', 'crossLagY_NMC_awake', 'crossLagY_NVC_anes', 'crossLagY_NMC_anes')
freq_new = 250;
t_kernel = 30;

t_deconvolution = (-3*freq_new :(t_kernel-3)*freq_new-1)/freq_new;
t_crossLag = -1/250:1/250:4;
figure
subplot(2,2,1)
plot_distribution_prctile(t_crossLag,crossLagY_NVC_awake,'Color',[1,0,0]);
hold on
ylim([-0.15 0.6])
ylabel('r')
yyaxis right
set(gca,{'ycolor'},{'b'})
plot_distribution_prctile(t_deconvolution,HRF_awake,'Color',[0,0,1])
ylim([-0.02 0.08])
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
ylim([-0.006 0.024])
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
ylim([-0.01 0.025])
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
ylim([-0.01 0.02])
xlabel('Time(t)')
grid on
title('Anesthetized NMC')
xlim([-1 4])
sgtitle('Red is Cross Lag, Blue is Deconvolution')