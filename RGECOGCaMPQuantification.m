load('X:\Paper1\GCaMP\cat\GCaMP_correction11_quantification.mat')
load('X:\Paper1\RGECO\cat\RGECO_quantification.mat')
% Signal
figure
plot(sort(peak_rgeco_cat*100),'m-')
hold on
plot(sort(peak_gcamp_cat*100),'-','Color',[107,142,35]/255)
title('GECI Signal')
legend('Thy1-jRGECO1a','Thy1-GCaMP6f','location','northwest')
ylim([1,12])
ylabel('\DeltaF/F%')
xlabel('Block Number')

% Baseline STD
figure
plot(sort(std_rgeco_cat*100),'m-')
hold on
plot(sort(std_gcamp_cat*100),'-','Color',[107,142,35]/255)
title('GECI Baseline Standard Deviation')
legend('Thy1-jRGECO1a','Thy1-GCaMP6f','location','northwest')
ylim([0,4])
ylabel('\DeltaF/F%')
xlabel('Block Number')

% Scaled Stim STD
figure
plot(sort(std_rgeco_stim_cat*100),'m-')
hold on
plot(sort(std_gcamp_stim_cat*100),'-','Color',[107,142,35]/255)
title('GECI Scaled Stim Standard Deviation')
legend('Thy1-jRGECO1a','Thy1-GCaMP6f','location','northwest')
ylabel('\DeltaF/F%')
xlabel('Block Number')

% SNR
figure
plot(sort(peak_rgeco_cat./std_rgeco_cat),'m-')
hold on
plot(sort(peak_gcamp_cat./std_gcamp_cat),'-','Color',[107,142,35]/255)
title('GECI SNR')
legend('Thy1-jRGECO1a','Thy1-GCaMP6f','location','northwest')
ylabel('SNR')
xlabel('Block Number')
