load('F:\XiaodanPaperData\190627\190627-R5M2285-fc1_processed.mat', 'xform_isbrain')
load('F:\XiaodanPaperData\190627\190627-R5M2285-fc_1min_smooth_Rolling_interp_CalciumFAD.mat', ...
    'A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse', 'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse',...
    'W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse')
load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
sessionInfo.framerate_new =250;
time_epoch= 60;
t=0:1/sessionInfo.framerate_new:time_epoch-1/sessionInfo.framerate_new;


mask = mask_new.*xform_isbrain;
mask = logical(reshape(mask,128*128,[]));

T_awake = reshape(T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,128*128,[]);
T_awake = nanmedian(T_awake(mask));

W_awake = reshape(W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,128*128,[]);
W_awake = nanmedian(W_awake(mask));

A_awake = reshape(A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,128*128,[]);
A_awake = nanmedian(A_awake(mask));


alpha_awake = (T_awake/W_awake)^2*8*log(2);
beta_awake = W_awake^2/(T_awake*8*log(2));
y_awake = A_awake*(t/T_awake).^alpha_awake.*exp((t-T_awake)/(-beta_awake));
y_awake(isnan(y_awake)) = 0 ;

load('F:\XiaodanPaperData\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_isbrain')
load('F:\XiaodanPaperData\190710\190710-R5M2285-anes-fc_1min_smooth_Rolling_interp_CalciumFAD.mat', ...
'A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse', 'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse',...
    'W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse')
load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')
mask = mask_new.*xform_isbrain;
mask = logical(reshape(mask,128*128,[]));

T_anes = reshape(T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,128*128,[]);
T_anes = nanmedian(T_anes(mask));

W_anes = reshape(W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,128*128,[]);
W_anes = nanmedian(W_anes(mask));

A_anes = reshape(A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,128*128,[]);
A_anes = nanmedian(A_anes(mask));

alpha_anes = (T_anes/W_anes)^2*8*log(2);
beta_anes = W_anes^2/(T_anes*8*log(2));
y_anes = A_anes*(t/T_anes).^alpha_anes.*exp((t-T_anes)/(-beta_anes));
y_anes(isnan(y_anes)) = 0 ;
figure
plot(t,y_awake,'g-')
hold on
plot(t,y_anes,'g--')
xlim([0 2])
legend('Awake','Anesthetized')
xlabel('Time(s)')
title('Gamma Variate Fitting for NMC for Mouse 2285')