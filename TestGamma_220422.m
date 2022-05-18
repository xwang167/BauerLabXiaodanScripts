calcium = squeeze(Calcium_filter(67,15,:))*100;
HbT = squeeze(HbT_filter(67,15,:))*10^6;
plot((1:3000)/5,calcium,'m')
hold on
plot((1:3000)/5,HbT,'k')
xlim([0 600])


pixHemo = HbT_2501_3000;
pixNeural = calcium_2501_3000;
%t = (0:25)./25;
%t = (0:750)./25;
%he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
he = HemodynamicsError(t,pixNeural,pixHemo);
%             worstErr = sum(pixHemo.^2);
%             options.TolFun = worstErr*0.01;
%fcn = @(param)he.fcn(param);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

HbT_2001_2500 = HbT(2001:2500);
calcium_2001_2500 = calcium(2001:2500);

HbT_1501_2000 = HbT(1501:2000);
calcium_1501_2000 = calcium(1501:2000);

HbT_1001_1500 = HbT(1001:1500);
calcium_1001_1500 = calcium(1001:1500);

HbT_501_1000 = HbT(501:1000);
calcium_501_1000 = calcium(501:1000);
HbT_1_500 = HbT(1:500);
calcium_1_500 = calcium(1:500);

edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = - edgeLen: round(tZone*fs);
tLim = [-2 2];
rLim = [-1 1];
% %
[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    reshape(HbT_pos,1,1,[]),reshape(calcim_pos,1,1,[]),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;





figure
plot((1:3000)/5,pixHemo,'m')
hold on
plot((1:3000)/5,pixNeural,'k')
xlim([0 100])
xlabel('Time(s)')
ylabel('\DeltaF/F% or \Delta\muM')



pixHemo = HbT;
pixNeural = calcium;
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.79,1.8,0.12],[0.7,0.3,0.05],[2,3,1],options)');





calcim_zero = calcium-mean(calcium);
HbT_zero = HbT-mean(HbT);
pixHemo = HbT_zero;
pixNeural = calcim_zero;
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');

calcim_pos= calcium-min(calcium);
HbT_pos = HbT-min(HbT);
pixHemo = HbT_pos;
pixNeural = calcim_pos;
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');


% evoked
calcium_evoke = reshape(xform_jrgeco1aCorr_mice_NoGSR,128*128,[])*100;
ROI_GSR = reshape(ROI_GSR,128*128,1);
calcium_evoke =calcium_evoke(logical(ROI_GSR),:);
calcium_evoke =mean(calcium_evoke,1);
calcium_evoke = calcium_evoke-mean(calcium_evoke(1:75));
figure
plot((1:750)/25,calcium_evoke,'m')

HbT_evoke = squeeze(xform_datahb_mice_NoGSR(:,:,1,:)+xform_datahb_mice_NoGSR(:,:,2,:))*10^6;
HbT_evoke = reshape(HbT_evoke,128*128,[]);
ROI_GSR = reshape(ROI_GSR,128*128,1);
HbT_evoke = HbT_evoke(ROI_GSR,:);
HbT_evoke = mean(HbT_evoke,1);
HbT_evoke = HbT_evoke-mean(HbT_evoke(1:75));
hold on
plot((1:750)/25,HbT_evoke,'k')
xlabel('Time(s)')
ylabel('\DeltaF/F% or \Delta\muM')




edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = - edgeLen: round(tZone*fs);
tLim = [-2 2];
rLim = [-1 1];
% %
[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    reshape(HbT_evoke(126:end),1,1,[]),reshape(calcium_evoke(126:end),1,1,[]),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./25;



t_evoke = linspace(0,time_epoch,25*time_epoch);
pixHemo = HbT_evoke(126:end);
pixNeural = calcium_evoke(126:end);
he = HemodynamicsError(t_evoke,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');




figure
plot((1:750)/25,FAD_evoke*100,'g')
hold on
plot((1:749)/25,diff(FAD_evoke)*100,'k')
xlim([5 7])
legend('FAD Trace','Derivative')

%% different optimization


pixHemo = HbT;
pixNeural = calcium;
%t = (0:25)./25;
%t = (0:750)./25;
%he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
he = HemodynamicsError(t,pixNeural,pixHemo);
%             worstErr = sum(pixHemo.^2);
%             options.TolFun = worstErr*0.01;
%fcn = @(param)he.fcn(param);
fcn = @(param)he.fcn(param);
X = evalc('lsqnonlin(fcn,[0.62,1.8,0.12])');

