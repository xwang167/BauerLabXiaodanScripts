pixHemo = squeeze(good_HbT(1029,:))';
pixNeural = squeeze(good_calcium(1029,:))';
%t = (0:25)./25;
%t = (0:750)./25;
%he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
he = HemodynamicsError(t,pixNeural,pixHemo);
%             worstErr = sum(pixHemo.^2);
%             options.TolFun = worstErr*0.01;
%fcn = @(param)he.fcn(param);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');



figure
subplot(211)
plot((1:3000)/5,good_calcium(1029,:))
title('Calcium')
ylabel('\DeltaF/F%')
subplot(212)
plot((1:3000)/5,good_HbT(1029,:))
title('HbT')
ylabel('\Delta\muM')
xlabel('Time(s)')
sgtitle ('[T, W, A] =  0.81 1.47 0.07')




figure
subplot(211)
plot(good_calcium(1029,:))
title('Calcium')
ylabel('\DeltaF/F%')
subplot(212)
plot(good_HbT(1029,:))
title('HbT')
ylabel('\Delta\muM')
sgtitle ('[T, W, A] =  0.81 1.47 0.07')

HbT_cut = [94:124 473:1218 1433:1496 1808:1857 2723:300];
calcium_cut = HbT_cut - 5;

good_calcium_1 = good_calcium(1029,:);
good_HbT_1 = good_HbT(1029,:);
good_calcium_1(HbT_cut) = [];
good_HbT_1(HbT_cut) = [];




figure
subplot(211)
plot((1:1750)/5,good_calcium_1(1:1750))
title('Calcium')
ylabel('\DeltaF/F%')
subplot(212)
plot((1:1750)/5,good_HbT_1(1:1750))
title('HbT')
ylabel('\Delta\muM')
xlabel('Time(s)')



pixHemo = squeeze(good_HbT_1(1:1750))';
pixNeural = squeeze(good_calcium_1(1:1750))';
%t = (0:25)./25;
%t = (0:750)./25;
%he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
he = HemodynamicsError(t,pixNeural,pixHemo);
%             worstErr = sum(pixHemo.^2);
%             options.TolFun = worstErr*0.01;
%fcn = @(param)he.fcn(param);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');

%% wrong:shifted
good_calcium_2 = good_calcium(1029,:);
good_HbT_2 = good_HbT(1029,:);
good_calcium_peaks = good_calcium_2(calcium_cut);
good_HbT_peaks  = good_HbT_2(HbT_cut);
good_calcium_peaks((41.2*5-5):(94.2*5-5)) = [];
good_HbT_peaks(41.2*5:94.2*5)= [];
good_calcium_peaks((72.6*5-5):(89.4*5-5)) = [];
good_HbT_peaks(72.6*5:89.4*5)= [];

figure
subplot(211)
plot((1:540)/5,good_calcium_peaks)
title('Calcium')
ylabel('\DeltaF/F%')
subplot(212)
plot((1:540)/5,good_HbT_peaks)
title('HbT')
ylabel('\Delta\muM')
xlabel('Time(s)')


pixHemo = squeeze(good_HbT_peaks)';
pixNeural = squeeze(good_calcium_peaks)';
%t = (0:25)./25;
%t = (0:750)./25;
%he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
he = HemodynamicsError(t,pixNeural,pixHemo);
%             worstErr = sum(pixHemo.^2);
%             options.TolFun = worstErr*0.01;
%fcn = @(param)he.fcn(param);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');

%%No shift
good_calcium_2 = good_calcium(1029,:);
good_HbT_2 = good_HbT(1029,:);
good_calcium_peaks = good_calcium_2(HbT_cut);
good_HbT_peaks  = good_HbT_2(HbT_cut);

good_calcium_peaks(72.6*5:89.4*5) = [];
good_HbT_peaks(72.6*5:89.4*5)= [];

good_calcium_peaks(40.6*5:80.2*5) = [];
good_HbT_peaks(40.6*5:80.2*5)= [];

good_calcium_peaks(68.8*5:86.2*5) = [];
good_HbT_peaks(68.8*5:86.2*5)= [];

figure
subplot(211)
plot((1:519)/5,good_calcium_peaks)
title('Calcium')
ylabel('\DeltaF/F%')
subplot(212)
plot((1:519)/5,good_HbT_peaks)
title('HbT')
ylabel('\Delta\muM')
xlabel('Time(s)')


%% bad
pixHemo = squeeze(bad_HbT(91,:))';
pixNeural = squeeze(bad_calcium(91,:))';
%t = (0:25)./25;
%t = (0:750)./25;
%he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
he = HemodynamicsError(t,pixNeural,pixHemo);
%             worstErr = sum(pixHemo.^2);
%             options.TolFun = worstErr*0.01;
%fcn = @(param)he.fcn(param);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');



figure
subplot(211)
plot((1:3000)/5,pixNeural)
title('Calcium')
ylabel('\DeltaF/F%')
subplot(212)
plot((1:3000)/5,pixHemo)
title('HbT')
ylabel('\Delta\muM')
xlabel('Time(s)')
