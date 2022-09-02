
runInfo.samplingRate = 25;
%load('L:\RGECO\190627\190627-R5M2286-fc2_processed.mat','xform_jrgeco1aCorr','xform_datahb')
calcium = xform_jrgeco1aCorr(79,38,:);
HbT = squeeze(xform_datahb(79,38,1,:)+xform_datahb(79,38,1,:));
calcium = squeeze(calcium)*100;
HbT = squeeze(HbT)*10^6;
calcium = calcium';
HbT = HbT';
figure
plot((1:14999)/25,calcium,'m')
hold on
plot((1:14999)/25,HbT,'k')
xlabel('Time(s)')
legend('Calcium','HbT')
title('Original')
ylabel('\DeltaF/F% or \muM')

calcium = filterData(double(calcium),0.02,2,runInfo.samplingRate);
HbT = filterData(double(HbT),0.02,2,runInfo.samplingRate);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
figure
plot((1:14999)/25,calcium,'m')
hold on
plot((1:14999)/25,HbT,'k')
xlabel('Time(s)')
legend('Calcium','HbT')
title('Filtered 0.02-2Hz')
ylabel('\DeltaF/F% or \muM')
%%downsample
calcium_downsample=resample(calcium',5,runInfo.samplingRate)';
HbT_downsample=resample(HbT',5,runInfo.samplingRate)';

figure
plot((1:14999)/25,calcium,'r-')
hold on
plot((1:3000)/5,calcium_downsample,'b--')
xlabel('Time(s)')
legend('NoDownsample','Downsample')
title('Calcium')
ylabel('\DeltaF/F%')

figure
plot((1:14999)/25,HbT,'r')
hold on
plot((1:3000)/5,HbT_downsample,'b--')
xlabel('Time(s)')
legend('NoDownsample','Downsample')
title('HbT')
ylabel('\Delta\muM')


%% downsample
time_epoch=30;
t_downsample=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(5/runInfo.samplingRate));%% force it to be 5 hz
disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_downsample,calcium_downsample,HbT_downsample);
fcn = @(param)he.fcn(param);
[x,pixHrfParam_downsample,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
pixelHrf_downsample = hrfGamma(t_downsample,pixHrfParam_downsample(1),pixHrfParam_downsample(2),pixHrfParam_downsample(3)); % %T, W, A
 pixHemoPred_downsample = conv(calcium_downsample,pixelHrf_downsample);
 pixHemoPred_downsample = pixHemoPred_downsample(1:numel(calcium_downsample));

%% no downsmaple
time_epoch=30;
t=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(runInfo.samplingRate/runInfo.samplingRate));%% force it to be 5 hz
disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t,calcium,HbT);
fcn = @(param)he.fcn(param);
[x,pixHrfParam,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3)); % %T, W, A
pixHemoPred = conv(calcium,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(calcium));

figure
plot((1:14999)/25,HbT,'k')
hold on
plot((1:14999)/25,pixHemoPred,'r')
hold on
plot((1:3000)/5,pixHemoPred_downsample,'b--')
legend('Actual Filtered HbT','Pred HbT NoDownsample','Pred HbT Downsample')
ylabel('\Delta\muM')
xlabel('Time(s)')

figure
plot(t,pixelHrf,'r');
hold on
plot(t_downsample,pixelHrf_downsample,'b--')
legend('No Downsample','Downsample')
title('Gamma Fitting')
xlabel('Time(s)')

figure
plot(calcium(1:5:end)-calcium_downsample)
title('Calcium-Calcium_{Downsample}')

figure
plot(HbT(1:5:end)-HbT_downsample)
title('HbT-HbT_{Downsample}')
ylabel('\Delta\muM')

%% cut first few frames
calcium_cut = calcium_downsample(11:end);
HbT_cut = HbT_downsample(11:end);

time_epoch=30;
t_cut=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(5/runInfo.samplingRate));%% force it to be 5 hz
disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_cut,calcium_cut,HbT_cut);
fcn = @(param)he.fcn(param);
[x,pixHrfParam_cut,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
pixelHrf_cut= hrfGamma(t_cut,pixHrfParam_cut(1),pixHrfParam_cut(2),pixHrfParam_cut(3)); % %T, W, A
pixHemoPred_cut = conv(calcium_cut,pixelHrf_cut);
pixHemoPred_cut = pixHemoPred_cut(1:numel(calcium_cut));

figure
plot(t,pixelHrf,'r');
hold on
plot(t_downsample,pixelHrf_downsample,'b--')
hold on
plot(t_cut,pixelHrf_cut,'g--')
legend('No Downsample','Downsample','Cut 10 frames')
title('Gamma Fitting')
xlabel('Time(s)')

%% dummy time trace
A = zeros(1,1000);
A(300:400) = 1;
A(700:800) = 1;
B = conv(A,pixelHrf);
B = B(1:1000);

A_filter = filterData(double(A),0.02,2,runInfo.samplingRate);
B_filter = filterData(double(B),0.02,2,runInfo.samplingRate);

figure
plot((1:1000)/25,A_filter,'m')
hold on
plot((1:1000)/25,B_filter,'k')
title('Filtered')
legend('Input','Output')
xlabel('Time(s)')

time_epoch=30;
t_dummy=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(runInfo.samplingRate/runInfo.samplingRate));%% force it to be 5 hz
disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_dummy,A_filter,B_filter);
fcn = @(param)he.fcn(param);
[x,pixHrfParam_dummy,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.81,1.3,0.14],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
pixelHrf_dummy = hrfGamma(t,pixHrfParam_dummy(1),pixHrfParam_dummy(2),pixHrfParam_dummy(3)); % %T, W, A
pixHemoPred_dummy = conv(A_filter,pixelHrf_dummy);
pixHemoPred_dummy = pixHemoPred_dummy(1:numel(A_filter));

%% sampled dummy time trace
A_downsample = resample(A_filter',5,runInfo.samplingRate)';
B_downsample = resample(B_filter',5,runInfo.samplingRate)';
hold on
plot((1:200)/5,A_downsample,'r--')
hold on
plot((1:200)/5,B_downsample,'b--')
title('Filtered')
legend('Input Fitlered','Output Filtered','Input Downsampled','Output Downsampled')
xlabel('Time(s)')


time_epoch=30;
t_downsample_dummy=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(5/runInfo.samplingRate));%% force it to be 5 hz


disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_downsample_dummy,A_downsample,B_downsample);
he = HemodynamicsError(t_dummy,A_filter,B_filter);

fcn = @(param)he.fcn(param);
[x,pixHrfParam_downsample_dummy,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.81,1.3,0.14],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
pixelHrf_downsample_dummy = hrfGamma(t_downsample_dummy,pixHrfParam_downsample_dummy(1),pixHrfParam_downsample_dummy(2),pixHrfParam_downsample_dummy(3)); % %T, W, A
pixHemoPred_downsample_dummy = conv(A_downsample,pixelHrf_downsample_dummy);
pixHemoPred_downsample_dummy = pixHemoPred_downsample_dummy(1:numel(A_downsample));

figure
plot(A_filter(1:5:end)-A_downsample)
title('Input-Input_{Downsample}')

figure
plot(B_filter(1:5:end)-B_downsample)
title('Output-Output_{Downsample}')


%% Downsample ori
A_downsample_ori = resampledata_ori(A_filter,runInfo.samplingRate,5)';
B_downsample_ori = resampledata_ori(B_filter,runInfo.samplingRate,5)';
figure
hold on
plot((1:200)/5,A_downsample_ori,'r--')
hold on
plot((1:200)/5,B_downsample_ori,'b--')
legend('Input Fitlered','Output Filtered','Input Downsampled','Output Downsampled')
xlabel('Time(s)')


time_epoch=30;
t_downsample_dummy=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(5/runInfo.samplingRate));%% force it to be 5 hz


disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_downsample_dummy,A_downsample_ori,B_downsample_ori);
fcn = @(param)he.fcn(param);

[x,pixHrfParam_downsample_dummy_ori,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.81,1.3,0.14],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound

pixelHrf_downsample_dummy_ori = hrfGamma(t_downsample_dummy,pixHrfParam_downsample_dummy_ori(1),pixHrfParam_downsample_dummy_ori(2),pixHrfParam_downsample_dummy_ori(3)); % %T, W, A
pixHemoPred_downsample_dummy_ori = conv(A_downsample_ori,pixelHrf_downsample_dummy_ori);
pixHemoPred_downsample_dummy_ori = pixHemoPred_downsample_dummy_ori(1:numel(A_downsample_ori));

figure
plot(A_filter(1:5:end)-A_downsample_ori')
title('Input-Input_{Downsample}')

figure
plot(B_filter(1:5:end)-B_downsample_ori')
title('Output-Output_{Downsample}')
%% compare downsample
figure
plot(A_filter(1:5:end)-A_downsample,'r')
hold on
plot(B_filter(1:5:end)-B_downsample,'b')
hold on
plot(A_filter(1:5:end)-A_downsample_ori','k')
hold on
plot(B_filter(1:5:end)-B_downsample_ori','m')
xlabel('Frames')
legend('Input New Downsample','Output New Downsample','Input old downsmaple','Output old downsample')
xlim([0 20])

hold on
plot(A_filter(1:5:end))
legend('Input New Downsample','Output New Downsample','Input old downsmaple','Output old downsample','location','southeast')
%%
figure
plot(t_dummy, pixelHrf_dummy,'m')
hold on
plot(t_downsample_dummy,pixelHrf_downsample_dummy,'k')
hold on
plot(t_downsample_dummy,pixelHrf_downsample_dummy_ori,'b--')
xlim([0,10])
legend('No Downsample','New Downsample','Old Downsample')
xlabel('Time(s)')


xlim([20 180])
%% 
figure
plot(A_filter(1:5:end)-A_downsample_ori','k')
hold on
plot(B_filter(1:5:end)-B_downsample_ori','m')
%% every 5
disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_downsample_dummy,A_filter(1:5:end),B_filter(1:5:end));
fcn = @(param)he.fcn(param);

[x,pixHrfParam_downsample_dummy_sample,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.81,1.3,0.14],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound

pixelHrf_dummy_sample = hrfGamma(t_downsample_dummy,pixHrfParam_downsample_dummy_sample(1),pixHrfParam_downsample_dummy_sample(2),pixHrfParam_downsample_dummy_sample(3)); % %T, W, A
pixHemoPred_dummy_sample = conv(A_filter(1:5:end),pixelHrf_dummy_sample);
pixHemoPred_dummy_sample = pixHemoPred_dummy_sample(1:numel(A_filter(1:5:end)));
%% 10

time_epoch=30;
t_downsample_dummy_10=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(2.5/runInfo.samplingRate));%% force it to be 5 hz

disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_downsample_dummy_10,A_filter(1:10:end),B_filter(1:10:end));
fcn = @(param)he.fcn(param);

[x,pixHrfParam_dummy_sample_10,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.81,1.3,1],[0.2,0.3,0.05],[2,3,2],options)'); %T, W, A -- guess, lower bound, upper bound

pixelHrf_dummy_sample_10 = hrfGamma(t_downsample_dummy_10,pixHrfParam_dummy_sample_10(1),pixHrfParam_dummy_sample_10(2),pixHrfParam_dummy_sample_10(3)); % %T, W, A
pixHemoPred_dummy_sample_10 = conv(A_filter(1:10:end),pixelHrf_dummy_sample_10);
pixHemoPred_dummy_sample_10 = pixHemoPred_dummy_sample_10(1:numel(A_filter(1:10:end)));

%% 8
time_epoch=30;
t_downsample_dummy_8=linspace(0,time_epoch,time_epoch*runInfo.samplingRate *(3.125/runInfo.samplingRate));%% force it to be 5 hz

disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

he = HemodynamicsError(t_downsample_dummy_8,A_filter(1:8:end),B_filter(1:8:end));
fcn = @(param)he.fcn(param);

[x,pixHrfParam_dummy_sample_8,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.81,1.3,1],[0.2,0.3,0.05],[2,3,2],options)'); %T, W, A -- guess, lower bound, upper bound

pixelHrf_dummy_sample_8 = hrfGamma(t_downsample_dummy_8,pixHrfParam_dummy_sample_8(1),pixHrfParam_dummy_sample_8(2),pixHrfParam_dummy_sample_8(3)); % %T, W, A
pixHemoPred_dummy_sample_8 = conv(A_filter(1:8:end),pixelHrf_dummy_sample_8);
pixHemoPred_dummy_sample_8 = pixHemoPred_dummy_sample_8(1:numel(A_filter(1:8:end)));

%% 
figure
plot(t_dummy, pixelHrf_dummy,'m--')
hold on
plot(t_downsample_dummy,pixelHrf_downsample_dummy,'k--')
hold on
plot(t_downsample_dummy,pixelHrf_downsample_dummy_ori,'b--')
hold on
plot(t_downsample_dummy,pixelHrf_dummy_sample,'g--')
hold on
plot(t_downsample_dummy_8,pixelHrf_dummy_sample_8,'c--')
hold on
plot(t_downsample_dummy_10,pixelHrf_dummy_sample_10,'r--')
xlim([0,10])
legend('No Downsample','New Downsample','Old Downsample','Sample 5Hz','Sample 3.125Hz','Sample 2.5Hz')
xlabel('Time(s)')

figure
scatter(25,1/0.14,300,'filled','m')
hold on
scatter(5,1/0.68,300,'filled','k')
hold on
scatter(3.125,1/1.09,300,'filled','c')
hold on
scatter(2.5,1/1.39,300,'filled','r')


%%
disp('Gamma-ing')
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);

pixHemoPred_dummy_sample = conv(A_filter(1:5:end),pixelHrf_dummy_sample);
pixHemoPred_dummy_sample = pixHemoPred_dummy_sample(1:numel(A_filter(1:5:end)));

%%

figure
pixHemoPred_dummy_sample_orihrf = conv(A_filter(1:5:end),pixelHrf_dummy(1:5:end));
pixHemoPred_dummy_sample_orihrf = pixHemoPred_dummy_sample_orihrf(1:numel(A_filter(1:5:end)));
pixHemoPred_dummy_sample= conv(A_filter(1:5:end),pixelHrf_dummy_sample);
pixHemoPred_dummy_sample = pixHemoPred_dummy_sample(1:numel(A_filter(1:5:end)));
plot((1:200)/5,pixHemoPred_dummy_sample,'g')
hold on
plot((1:200)/5,pixHemoPred_dummy_sample_orihrf)
hold on
plot((1:1000)/25,B_filter)
