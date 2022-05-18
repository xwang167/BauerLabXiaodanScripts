import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRow = [181];
runs = 1;%
[~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
recDate = excelRaw{1}; recDate = string(recDate);
mouseName = excelRaw{2}; mouseName = string(mouseName);
rawdataloc = excelRaw{3};
saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
if ~exist(saveDir)
    mkdir(saveDir)
end
sessionInfo.mouseType = excelRaw{17};
sessionInfo.darkFrameNum = excelRaw{15};
systemType = excelRaw{5};
sessionInfo.framerate = excelRaw{7};
if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
    maskDir = fullfile(rawdataloc,recDate);
else
    maskDir = saveDir;
end

saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

if ~exist(fullfile(saveDir_new,maskName),'file')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
else
    load(fullfile(saveDir_new,maskName),'xform_isbrain')
end

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(mask_new.*xform_isbrain);

visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1));
processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'_processed','.mat');

load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);

Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);

HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
clear Hb_filter
HbT_filter = squeeze(HbT_filter);

Calcium_filter = reshape(Calcium_filter,128*128,[]);
HbT_filter = reshape(HbT_filter,128*128,[]);
%downsample
Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';

% reshape

Calcium_filter = reshape(Calcium_filter,128,128,[]);
HbT_filter = reshape(HbT_filter,128,128,[]);
time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz
%% iter 3000
hrfParam3 = nan(128,128,3);
T3 = nan(128,128);
W3 = nan(128,128);
A3 = nan(128,128);
objValues3 = nan(128,128);
r3 = nan(128,128);
r23 = nan(128,128);
mask = reshape(mask,128,128);

options=optimset('Display','iter','MaxFunEvals',12000,'MaxIter',3000,'Tolx',1e-8,'TolF',1e-8);

for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            %t = (0:25)./25;
            %t = (0:750)./25;
            %he = mouse.math.HemodynamicsError(t,pixNeural,pixHemo);
            he = HemodynamicsError(t,pixNeural,pixHemo);
            %             worstErr = sum(pixHemo.^2);
            %             options.TolFun = worstErr*0.01;
            %fcn = @(param)he.fcn(param);
            fcn = @(param)he.fcn(param);
            [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
            
            
            %             tMin = 0.0625; tMax = 4; tNum = 64;
            %             wMin = 0.125; wMax = 6; wNum = 48;
            %             aMin = 0.25E-4; aMax = 2E-4; aNum = 8;
            %             [X1, X2, X3] = ndgrid( linspace(tMin, tMax, tNum), linspace(wMin, wMax, wNum), linspace(aMin, aMax, aNum));
            %             y = zeros(size(X1));
            %             for i = 1:numel(X1)
            %                 y(i) = fcn([X1(i),X2(i),X3(i)]);
            %             end
            %             [~,I] = min(y(:));
            %             pixHrfParam2 = [X1(I) X2(I) X3(I)];
            
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
            
            pixHemoPred = conv(pixNeural,pixelHrf);
            pixHemoPred = pixHemoPred(1:numel(pixNeural));
            
            hrfParam3(yInd,xInd,:) = pixHrfParam;
            objValues3(yInd,xInd) = obj_val;
            
            r3(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
            r23(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
            
            %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
        end
    end
end
T3(:,:) = hrfParam3(:,:,1);
W3(:,:) = hrfParam3(:,:,2);
A3(:,:) = hrfParam3(:,:,3);


figure
subplot(2,3,1)
imagesc(T3,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W3,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A3,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r3,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r23,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(objValues3,[0 3500])
axis image off
colormap jet
title('Objective Value')
colorbar
%% T = 0.2s, 0.6<T<1.1
bad_calcium = [];
good_calcium = [];
bad_HbT = [];
good_HbT = [];
for ii = 1:128
    for jj = 1:128
        if T3(ii,jj) == 0.2
            bad_calcium = cat(1,bad_calcium,transpose(squeeze(Calcium_filter(ii,jj,:)))*100);
            bad_HbT = cat(1,bad_HbT,transpose(squeeze(HbT_filter(ii,jj,:)))*10^6);
        elseif T3(ii,jj)>0.6 && T3(ii,jj)<1.1
            good_calcium = cat(1,good_calcium,transpose(squeeze(Calcium_filter(ii,jj,:)))*100);
            good_HbT = cat(1,good_HbT,transpose(squeeze(HbT_filter(ii,jj,:)))*10^6);
        end
    end
end



figure
imagesc(bad_calcium)
colormap jet
title('Bad Calcium, T = 0.2')
figure
imagesc(bad_HbT)
colormap jet
title('Bad HbT, T = 0.2')

figure
imagesc(good_calcium)
colormap jet
title('Good Calcium, 0.6<T<1.1')
figure
imagesc(good_HbT)
colormap jet
title('Good HbT, 0.6<T<1.1')

%%
good_HbT_peakNum = nan(1,3135);
for ii = 1:3135
    pks =   findpeaks(good_HbT(ii,:),'MinPeakProminence',8);
    good_HbT_peakNum(ii) = length(pks);
end


bad_HbT_peakNum = nan(1,184);
for ii = 1:184
    pks =   findpeaks(bad_HbT(ii,:),'MinPeakProminence',8);
    bad_HbT_peakNum(ii) = length(pks);
end

C = [good_HbT_peakNum bad_HbT_peakNum];
grp = [zeros(1,3135), ones(1,184)];
boxplot(C,grp)


range_peaks_bad =[];

for ii = 1:6
    range_peaks_bad = [range_peaks_bad,locs(ii)-30: locs(ii)+30];
end

for ii = 1:6
    hold on
    xline(locs(ii)-30)
    hold on
    xline(locs(ii)+30)
end

bad_HbT_peaks = bad_HbT_2(range_peaks_bad);
bad_HbT_nopeak = bad_HbT_2;
bad_HbT_nopeak(range_peaks_bad) = [];

bad_calcium_peaks = bad_calcium_2(range_peaks_bad);
bad_calcium_nopeak = bad_calcium_2;
bad_calcium_nopeak(range_peaks_bad) = [];

pixHemo = bad_HbT_peaks;
pixNeural = bad_calcium_peaks;
he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');

figure
subplot(211)
plot(bad_calcium_peaks)
title('Calcium')
subplot(212)
plot(bad_HbT_peaks)
title('HbT')

pixHemo = bad_HbT_nopeak;
pixNeural = bad_calcium_nopeak;
he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');

figure
subplot(211)
plot(bad_calcium_nopeak)
title('Calcium')
subplot(212)
plot(bad_HbT_nopeak)
title('HbT')

subplot(211)
ylabel('\DeltaF/F%')
subplot(212)
xlabel('Frame Number')
ylabel('\Delta\muM')


edgeLen =1;
tZone = 4;
corrThr = 0;
validRange = - edgeLen: round(tZone*fs);
tLim = [-2 2];
rLim = [-1 1];

[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    reshape(bad_HbT_2,1,1,[]),reshape(bad_calcium_2,1,1,[]),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
%%
[peaks,locs] = findpeaks(good_HbT_2,'MinPeakProminence',9);

range_peaks_good =[];

for ii = 1:length(locs)
    range_peaks_good = [range_peaks_good,locs(ii)-30: locs(ii)+30];
end

figure
subplot(211)
plot(good_calcium_2)
for ii = 1:length(locs)
    hold on
    xline(locs(ii)-30)
    hold on
    xline(locs(ii)+30)
end
title('Calcium')

subplot(212)
plot(good_HbT_2)
for ii = 1:length(locs)
    hold on
    xline(locs(ii)-30)
    hold on
    xline(locs(ii)+30)
end
title('HbT')


[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    reshape(good_HbT_2,1,1,[]),reshape(good_calcium_2,1,1,[]),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;
%%


sgtitle ('[T, W, A] =  0.81 1.47 0.07')



good_HbT_peaks = good_HbT_2(range_peaks_good);
good_HbT_nopeak = good_HbT_2;
good_HbT_nopeak(range_peaks_good) = [];

good_calcium_peaks = good_calcium_2(range_peaks_good);
good_calcium_nopeak = good_calcium_2;
good_calcium_nopeak(range_peaks_good) = [];

figure
subplot(211)
plot(good_calcium_peaks)
xlim([0 610])
title('Caclium')
xlabel('Frame Number')
subplot(212)
plot(good_HbT_peaks)
title('HbT')
xlabel('Frame Number')
ylabel('\Delta\muM')
ylabel('\DeltaF/F%')
xlim([0 610])


pixHemo = good_HbT_peaks;
pixNeural = good_calcium_peaks;
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');


[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    reshape(good_HbT_peaks,1,1,[]),reshape(good_calcium_peaks,1,1,[]),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;


figure
subplot(211)
plot(good_calcium_nopeak)
title('Caclium')
xlabel('Frame Number')
subplot(212)
plot(good_HbT_nopeak)
title('HbT')
xlabel('Frame Number')
ylabel('\Delta\muM')
ylabel('\DeltaF/F%')



pixHemo = good_HbT_nopeak;
pixNeural = good_calcium_nopeak;
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');


[lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
    reshape(good_HbT_nopeak,1,1,[]),reshape(good_calcium_nopeak,1,1,[]),edgeLen,validRange,corrThr, true,true);
lagTimeTrial_HbTCalcium = lagTimeTrial_HbTCalcium./fs;

good_HbT_nopeak(446-50:446+5) = [];
good_calcium_nopeak(446-50:446+5) = [];

xline(446+50)
%% test if r indicate bad gamma
good_r = zeros(1,3135);
for ii = 1:3135
    [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
        reshape(good_HbT(ii,:),1,1,[]),reshape(good_calcium(ii,:),1,1,[]),edgeLen,validRange,corrThr, true,true);
    good_r(ii) = lagAmpTrial_HbTCalcium;
end

bad_r = zeros(1,184);
for ii = 1:184
    [lagTimeTrial_HbTCalcium, lagAmpTrial_HbTCalcium,covResult_HbTCalcium] = mouse.conn.dotLag(...
        reshape(bad_HbT(ii,:),1,1,[]),reshape(bad_calcium(ii,:),1,1,[]),edgeLen,validRange,corrThr, true,true);
    bad_r(ii) = lagAmpTrial_HbTCalcium;
end

figure
histogram(good_r)
hold on
histogram(bad_r)

figure
C = [good_r bad_r];
grp = [zeros(1,3135), ones(1,184)];
boxplot(C,grp)
%% square error
square_error_good = zeros(3135,3000);
for ii = 1:3135
pixHemo = good_HbT(ii,:);
pixNeural = good_calcium(ii,:);
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));
square_error_good(ii,:) =(pixHemoPred - he.ActualHemodynamics).^2;
end

square_error_bad = zeros(184,3000);
for ii = 1:184
pixHemo = bad_HbT(ii,:);
pixNeural = bad_calcium(ii,:);
he = HemodynamicsError(t,pixNeural,pixHemo);
fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)');
pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));
square_error_bad(ii,:) =(pixHemoPred - he.ActualHemodynamics).^2;
end


figure
imagesc(square_error_bad,[0 3])
title('bad')
colormap jet
figure
imagesc(square_error_good,[0 3])
title('Good')
colormap jet
