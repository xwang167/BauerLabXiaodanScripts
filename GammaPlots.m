
load('D:\OIS_Process\noVasculaturemask.mat')
mask_new = logical(mask_new);
load('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_2min.mat',...
    'A_CalciumFAD_2min_median_mice', 'A_CalciumHbT_2min_median_mice',...
    'T_CalciumFAD_2min_median_mice', 'T_CalciumHbT_2min_median_mice',...
    'W_CalciumFAD_2min_median_mice', 'W_CalciumHbT_2min_median_mice',...
    'r_CalciumFAD_2min_median_mice', 'r_CalciumHbT_2min_median_mice')
A_CalciumFAD_2min_median_mice_awake = A_CalciumFAD_2min_median_mice;
A_CalciumHbT_2min_median_mice_awake = A_CalciumHbT_2min_median_mice;

T_CalciumFAD_2min_median_mice_awake = T_CalciumFAD_2min_median_mice;
T_CalciumHbT_2min_median_mice_awake = T_CalciumHbT_2min_median_mice;

W_CalciumFAD_2min_median_mice_awake = W_CalciumFAD_2min_median_mice;
W_CalciumHbT_2min_median_mice_awake = W_CalciumHbT_2min_median_mice;

r_CalciumFAD_2min_median_mice_awake = r_CalciumFAD_2min_median_mice;
r_CalciumHbT_2min_median_mice_awake = r_CalciumHbT_2min_median_mice;

load('191030-R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2mins.mat',...
    'A_CalciumFAD_2min_median_mice', 'A_CalciumHbT_2min_median_mice',...
    'T_CalciumFAD_2min_median_mice', 'T_CalciumHbT_2min_median_mice',...
    'W_CalciumFAD_2min_median_mice', 'W_CalciumHbT_2min_median_mice',...
    'r_CalciumFAD_2min_median_mice', 'r_CalciumHbT_2min_median_mice')

t_CalciumFAD = 0:0.001:0.3;
A_CalciumFAD_awake= mean(A_CalciumFAD_2min_median_mice_awake(mask_new));
T_CalciumFAD_awake= mean(T_CalciumFAD_2min_median_mice_awake(mask_new));
W_CalciumFAD_awake= mean(W_CalciumFAD_2min_median_mice_awake(mask_new));
r_CalciumFAD_awake= mean(r_CalciumFAD_2min_median_mice_awake(mask_new));

alpha_CalciumFAD_awake = (T_CalciumFAD_awake/W_CalciumFAD_awake)^2*8*log(2);
beta_CalciumFAD_awake = W_CalciumFAD_awake^2/(T_CalciumFAD_awake*8*log(2));
y_CalciumFAD_awake = A_CalciumFAD_awake*(t_CalciumFAD/T_CalciumFAD_awake).^alpha_CalciumFAD_awake.*exp((t_CalciumFAD-T_CalciumFAD_awake)/(-beta_CalciumFAD_awake));

t_CalciumHbT = 0:0.01:10;
A_CalciumHbT_awake= mean(A_CalciumHbT_2min_median_mice_awake(mask_new));
T_CalciumHbT_awake= mean(T_CalciumHbT_2min_median_mice_awake(mask_new));
W_CalciumHbT_awake= mean(W_CalciumHbT_2min_median_mice_awake(mask_new));
r_CalciumHbT_awake= mean(r_CalciumHbT_2min_median_mice_awake(mask_new));

alpha_CalciumHbT_awake = (T_CalciumHbT_awake/W_CalciumHbT_awake)^2*8*log(2);
beta_CalciumHbT_awake = W_CalciumHbT_awake^2/(T_CalciumHbT_awake*8*log(2));
y_CalciumHbT_awake = A_CalciumHbT_awake*(t_CalciumHbT/T_CalciumHbT_awake).^alpha_CalciumHbT_awake.*exp((t_CalciumHbT-T_CalciumHbT_awake)/(-beta_CalciumHbT_awake));

t_CalciumFAD = 0:0.001:0.3;
A_CalciumFAD= mean(A_CalciumFAD_2min_median_mice(mask_new));
T_CalciumFAD= mean(T_CalciumFAD_2min_median_mice(mask_new));
W_CalciumFAD= mean(W_CalciumFAD_2min_median_mice(mask_new));
r_CalciumFAD= mean(r_CalciumFAD_2min_median_mice(mask_new));

alpha_CalciumFAD = (T_CalciumFAD/W_CalciumFAD)^2*8*log(2);
beta_CalciumFAD = W_CalciumFAD^2/(T_CalciumFAD*8*log(2));
y_CalciumFAD = A_CalciumFAD*(t_CalciumFAD/T_CalciumFAD).^alpha_CalciumFAD.*exp((t_CalciumFAD-T_CalciumFAD)/(-beta_CalciumFAD));

t_CalciumHbT = 0:0.01:10;
A_CalciumHbT= mean(A_CalciumHbT_2min_median_mice(mask_new));
T_CalciumHbT= mean(T_CalciumHbT_2min_median_mice(mask_new));
W_CalciumHbT= mean(W_CalciumHbT_2min_median_mice(mask_new));
r_CalciumHbT= mean(r_CalciumHbT_2min_median_mice(mask_new));

alpha_CalciumHbT = (T_CalciumHbT/W_CalciumHbT)^2*8*log(2);
beta_CalciumHbT = W_CalciumHbT^2/(T_CalciumHbT*8*log(2));
y_CalciumHbT = A_CalciumHbT*(t_CalciumHbT/T_CalciumHbT).^alpha_CalciumHbT.*exp((t_CalciumHbT-T_CalciumHbT)/(-beta_CalciumHbT));

figure
plot(t_CalciumHbT,normr(y_CalciumHbT_awake),'k-')
hold on
plot(t_CalciumHbT,normr(y_CalciumHbT),'k--')
xlabel('Time(s)')
ylabel('n.a.')
title('NVC')

figure
plot(t_CalciumFAD,normr(y_CalciumFAD_awake),'g-')
hold on
plot(t_CalciumFAD,normr(y_CalciumFAD),'g--')
xlabel('Time(s)')
ylabel('n.a.')
title('NMC')



%%frequency content
t= 1:0.01:10;
h = y_CalciumHbT_awake; % impulse response
fs = 20;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
semilogx(F,mag2db(abs(H))); grid on;
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');