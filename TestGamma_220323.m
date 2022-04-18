
%load('L:\RGECO\190627\190627-R5M2286-fc3_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
%clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
T_CalciumHbT_2min_NoNorm_zscore = nan(128,128,5);
W_CalciumHbT_2min_NoNorm_zscore = nan(128,128,5);
A_CalciumHbT_2min_NoNorm_zscore = nan(128,128,5);
r_CalciumHbT_2min_NoNorm_zscore = nan(128,128,5);
r2_CalciumHbT_2min_NoNorm_zscore = nan(128,128,5);
hemoPred_CalciumHbT_2min_NoNorm_zscore = nan(128,128,600,5);
for excelRow = excelRows
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
    mask = logical(mask_new.*xform_isbrain);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        tic
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

        
        
        for ii = 1:5
            tic
            [T_CalciumHbT_2min_NoNorm_zscore(:,:,ii),W_CalciumHbT_2min_NoNorm_zscore(:,:,ii),A_CalciumHbT_2min_NoNorm_zscore(:,:,ii),...
                r_CalciumHbT_2min_NoNorm_zscore(:,:,ii),r2_CalciumHbT_2min_NoNorm_zscore(:,:,ii),hemoPred_CalciumHbT_2min_NoNorm_zscore(:,:,:,ii)] ...
                = interSpeciesGammaFit_CalciumHbT_Mask_NoNorm_zscore(Calcium_filter(:,:,(ii-1)*120*5+1:ii*120*5)*100,...
                HbT_filter(:,:,(ii-1)*120*5+1:ii*120*5)*10^6,t,mask);
            toc
        end
        T_CalciumHbT_2min_NoNorm_zscore_median = nanmedian(T_CalciumHbT_2min_NoNorm_zscore,3);
        W_CalciumHbT_2min_NoNorm_zscore_median = nanmedian(W_CalciumHbT_2min_NoNorm_zscore,3);
        A_CalciumHbT_2min_NoNorm_zscore_median = nanmedian(A_CalciumHbT_2min_NoNorm_zscore,3);
        r_CalciumHbT_2min_NoNorm_zscore_median = nanmedian(r_CalciumHbT_2min_NoNorm_zscore,3);
        r2_CalciumHbT_2min_NoNorm_zscore_median = nanmedian(r2_CalciumHbT_2min_NoNorm_zscore,3);
        
        figure
        subplot(2,3,4)
        imagesc(r_CalciumHbT_2min_NoNorm_zscore_median,'AlphaData',mask)
        cb=colorbar;
        caxis([-1 1])
        axis image off
        colormap jet
        title('r')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,5)
        imagesc(r2_CalciumHbT_2min_NoNorm_zscore_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 1])
        axis image off
        colormap jet
        title('R^2')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,1)
        imagesc(T_CalciumHbT_2min_NoNorm_zscore_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 2])
        axis image off
        cmocean('ice')
        title('T(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,2)
        imagesc(W_CalciumHbT_2min_NoNorm_zscore_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 3])
        axis image off
        cmocean('ice')
        title('W(s)')
        set(gca,'FontSize',14,'FontWeight','Bold')
        
        subplot(2,3,3)
        imagesc(A_CalciumHbT_2min_NoNorm_zscore_median,'AlphaData',mask)
        cb=colorbar;
        caxis([0 0.2])
        axis image off
        cmocean('ice')
        title('A')
        set(gca,'FontSize',14,'FontWeight','Bold')
        suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumHbT-GammaFit-2min-NoNorm_Zscore'))
        
    end
end


%% freqz

T = 0.01;
W = 0.3;
A = 0.05;
y = hrfGamma(t,T,W,A);
figure
h = y; % impulse response
fs = 5;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
% semilogx(F,mag2db(abs(H)),'b'); grid on;
% xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');


T = 2;
W = 3;
A = 1;
y = hrfGamma(t,T,W,A);
hold on
h = y; % impulse response
fs = 5;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
semilogx(F,mag2db(abs(H)),'r');


T = 1;W = 1.5; A = 0.25;
y = hrfGamma(t,T,W,A);
h = y; % impulse response
fs = 5;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
semilogx(F,mag2db(abs(H)),'g');

legend('Low Bound','Upper Bound','Initial Guess')



%%plot Gamma function
T = 0.01;
W = 0.3;
A = 0.05;
y = hrfGamma(t,T,W,A);
figure
plot(t,y,'b')
hold on
T = 2;
W = 3;
A = 1;
y = hrfGamma(t,T,W,A);
hold on;plot(t,y,'r')
T = 1;W = 1.5; A = 0.25;
y = hrfGamma(t,T,W,A);
hold on
plot(t,y,'g')
legend('Low Bound','Upper Bound','Start')




T = 0.01;W = 0.3;A = 0.05;
y = hrfGamma(t,T,W,A);
figure
h = y; % impulse response
fs = 5;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
semilogx(F,mag2db(abs(H)),'b'); grid on;
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');


T = 2;W = 3;A = 1;
y = hrfGamma(t,T,W,A);
h = y; % impulse response
fs = 5;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
semilogx(F,mag2db(abs(H)),'r');


T = 1;W = 1.5; A = 0.25;
y = hrfGamma(t,T,W,A);
h = y; % impulse response
fs = 5;
Nfft = 128;
[H,F] = freqz(h,1,Nfft,fs);
semilogx(F,mag2db(abs(H)),'g');

legend('Low Bound','Upper Bound','Initial Guess')


%%
sessionInfo.framerate = 25;
time_epoch=30;
t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

load(fullfile('L:\RGECO\190627','190627-R5M2285-fc1_processed.mat'),'xform_datahb','xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190627\190627-R5M2285-fc1-dataFluor.mat','xform_isbrain')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(mask_new.*xform_isbrain);
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
sessionInfo.framerate = 25;
Hb_filter =  filterData(double(xform_datahb),0.02,2,sessionInfo.framerate);
clear xform_datahb
Calcium_filter = filterData(double(xform_jrgeco1aCorr),0.02,2,sessionInfo.framerate);
clear xform_jrgeco1aCorr
HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
clear Hb_filter
HbT_filter = squeeze(HbT_filter);

Calcium_filter = reshape(Calcium_filter,128*128,[]);
HbT_filter = reshape(HbT_filter,128*128,[]);
%downsample
Calcium_filter=resample(Calcium_filter',5,sessionInfo.framerate)';
HbT_filter=resample(HbT_filter',5,sessionInfo.framerate)';

% reshape
%bad location
Calcium_filter = reshape(Calcium_filter,128,128,[]);
HbT_filter = reshape(HbT_filter,128,128,[]);

badLoc = [69,113];
goodLoc = [80,94];

options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',5000,'Tolx',1e-8,'TolF',1e-8);

pixHemo = squeeze(HbT_filter(badLoc(1),badLoc(2),:))'*10^6;
pixNeural = squeeze(Calcium_filter(badLoc(1),badLoc(2),:))'*100;

time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');

pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

r= corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
r2= 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));

figure
plot((1:3000)/5,pixHemo,'k')
hold on
plot((1:3000)/5,pixHemoPred,'g')
hold on
plot((1:3000)/5,pixNeural,'m')
xlim([0 100])
legend('Actual Hemo','PredHemo','calcium')

xlabel('Time(s)')

title('bad')
% good location
pixHemo = squeeze(HbT_filter(goodLoc(1),goodLoc(2),:))'*10^6;
pixNeural = squeeze(Calcium_filter(goodLoc(1),goodLoc(2),:))'*100;

time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn(param);
[~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');

pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

r= corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
r2= 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));


figure
plot((1:3000)/5,pixHemo,'k')
hold on
plot((1:3000)/5,pixHemoPred,'g')
hold on
plot((1:3000)/5,pixNeural,'m')
xlim([0 100])
legend('Actual Hemo','PredHemo','calcium')

xlabel('Time(s)')

title('good')


%% bad para vs iteration

hrfParam = nan(3,5000);
T = nan(1,5000);
W = nan(1,5000);
A = nan(1,5000);
objValues = nan(1,5000);
r = nan(1,5000);
r2 = nan(1,5000);

for ii = 1:5000
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
    pixHemo = squeeze(HbT_filter(badLoc(1),badLoc(2),:))'*10^6;
    pixNeural = squeeze(Calcium_filter(badLoc(1),badLoc(2),:))'*100;
    he = HemodynamicsError(t,pixNeural,pixHemo);
    fcn = @(param)he.fcn(param);
    [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');

    
    pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
    
    pixHemoPred = conv(pixNeural,pixelHrf);
    pixHemoPred = pixHemoPred(1:numel(pixNeural));
    
    hrfParam(:,ii) = pixHrfParam;
    objValues(ii) = obj_val;
    
    r(ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
    r2(ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
    
    
    T(ii) = hrfParam(1,ii);
    W(ii) = hrfParam(2,ii);
    A(ii) = hrfParam(3,ii);
end


figure
plot(1:5000,T,'r')
hold on
plot(1:5000,W,'g')
hold on
plot(1:5000,A,'b')
hold on
plot(1:5000,r,'k')
hold on
plot(1:5000,r2,'m')
xlim([0 120])
legend('T','W','A','r','R^2')
xlabel('Iteration')
title(bad)

figure
title('Objective Value')
plot(1:5000,objValues,'c')
xlim([0 60])
xlabel('Iteration')




%% good para vs iteration
hrfParam = nan(3,5000);
T = nan(1,5000);
W = nan(1,5000);
A = nan(1,5000);
objValues = nan(1,5000);
r = nan(1,5000);
r2 = nan(1,5000);

for ii = 1:5000
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
    pixHemo = squeeze(HbT_filter(goodLoc(1),goodLoc(2),:))'*10^6;
    pixNeural = squeeze(Calcium_filter(goodLoc(1),goodLoc(2),:))'*100;
    he = HemodynamicsError(t,pixNeural,pixHemo);
    fcn = @(param)he.fcn(param);
    [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');

    
    pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
    
    pixHemoPred = conv(pixNeural,pixelHrf);
    pixHemoPred = pixHemoPred(1:numel(pixNeural));
    
    hrfParam(:,ii) = pixHrfParam;
    objValues(ii) = obj_val;
    
    r(ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
    r2(ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
    
    
    T(ii) = hrfParam(1,ii);
    W(ii) = hrfParam(2,ii);
    A(ii) = hrfParam(3,ii);
end


figure
plot(1:5000,T,'r')
hold on
plot(1:5000,W,'g')
hold on
plot(1:5000,A,'b')
hold on
plot(1:5000,r,'k')
hold on
plot(1:5000,r2,'m')
xlim([0 120])
legend('T','W','A','r','R^2')
xlabel('Iteration')
title('Good')

figure
title('Objective Value')
plot(1:5000,objValues,'c')
xlim([0 60])
xlabel('Iteration')




%% zscore bad vs iteration
hrfParam = nan(3,5000);
T = nan(1,5000);
W = nan(1,5000);
A = nan(1,5000);
objValues = nan(1,5000);
r = nan(1,5000);
r2 = nan(1,5000);

for ii = 1:5000
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
    pixHemo = zscore(squeeze(HbT_filter(badLoc(1),badLoc(2),:))');
    pixNeural = zscore(squeeze(Calcium_filter(badLoc(1),badLoc(2),:))');
    he = HemodynamicsError(t,pixNeural,pixHemo);
    fcn = @(param)he.fcn(param);
    [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,1],[0.01,0.3,1],[2,3,1],options)');

    
    pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
    
    pixHemoPred = conv(pixNeural,pixelHrf);
    pixHemoPred = pixHemoPred(1:numel(pixNeural));
    
    hrfParam(:,ii) = pixHrfParam;
    objValues(ii) = obj_val;
    
    r(ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
    r2(ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
    
    
    T(ii) = hrfParam(1,ii);
    W(ii) = hrfParam(2,ii);
    A(ii) = hrfParam(3,ii);
end


figure
plot(1:5000,T,'r')
hold on
plot(1:5000,W,'g')
hold on
plot(1:5000,A,'b')
hold on
plot(1:5000,r,'k')
hold on
plot(1:5000,r2,'m')
xlim([0 120])
legend('T','W','A','r','R^2')
xlabel('Iteration')
title('bad')

figure
title('Objective Value')
plot(1:5000,objValues,'c')
xlim([0 60])
xlabel('Iteration')



%% change A bad

hrfParam = nan(3,5000);
T = nan(1,5000);
W = nan(1,5000);
A = nan(1,5000);
objValues = nan(1,5000);
r = nan(1,5000);
r2 = nan(1,5000);

for ii = 1:5000
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
    pixHemo = squeeze(HbT_filter(badLoc(1),badLoc(2),:))'*10^6;
    pixNeural = squeeze(Calcium_filter(badLoc(1),badLoc(2),:))'*100;
    he = HemodynamicsError(t,pixNeural,pixHemo);
    fcn = @(param)he.fcn(param);
    [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[0.6033,0.7068,0.25],[0.6033,0.7068,0.05],[0.6033,0.7068,1],options)');

    
    pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
    
    pixHemoPred = conv(pixNeural,pixelHrf);
    pixHemoPred = pixHemoPred(1:numel(pixNeural));
    
    hrfParam(:,ii) = pixHrfParam;
    objValues(ii) = obj_val;
    
    r(ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
    r2(ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
    
    
    T(ii) = hrfParam(1,ii);
    W(ii) = hrfParam(2,ii);
    A(ii) = hrfParam(3,ii);
end


figure
plot(1:5000,T,'r')
hold on
plot(1:5000,W,'g')
hold on
plot(1:5000,A,'b')
hold on
plot(1:5000,r,'k')
hold on
plot(1:5000,r2,'m')

xlim([0 120])
legend('T','W','A','r','R^2')
xlabel('Iteration')
title('bad')

figure

plot(1:5000,objValues,'c')
title('Objective Value')

xlim([0 60])
xlabel('Iteration')

%% fix A zscore the whole thing
hrfParam = nan(128,128,3);
T = nan(128,128);
W = nan(128,128);
A = nan(128,128);
objValues = nan(128,128);
r = nan(128,128);
r2 = nan(128,128);

options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',5000,'Tolx',1e-8,'TolF',1e-8);

time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

    for xInd = 1:size(HbT_filter,2)
        for yInd = 1:size(HbT_filter,1)
            if mask(yInd,xInd)
                pixHemo = zscore(squeeze(HbT_filter(yInd,xInd,:))');
                pixNeural = zscore(squeeze(Calcium_filter(yInd,xInd,:))');            
                he = HemodynamicsError(t,pixNeural,pixHemo);
                fcn = @(param)he.fcn(param);
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.21],[0.01,0.3,0.21],[2,3,0.21],options)');        
                
                pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                
                pixHemoPred = conv(pixNeural,pixelHrf);
                pixHemoPred = pixHemoPred(1:numel(pixNeural));
                
                hrfParam(yInd,xInd,:) = pixHrfParam;
                objValues(yInd,xInd) = obj_val;
               
                r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:) = hrfParam(:,:,1);
    W(:,:) = hrfParam(:,:,2);
    A(:,:) = hrfParam(:,:,3);
 %% fix T and W, then A
    A = nan(128,128);
    for xInd = 1:size(HbT_filter,2)
        for yInd = 1:size(HbT_filter,1)
            if mask(yInd,xInd)
                pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
                pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;            
                he = HemodynamicsError(t,pixNeural,pixHemo);
                fcn = @(param)he.fcn(param);
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[T(yInd,xInd),W(yInd,xInd),0.25],[T(yInd,xInd),W(yInd,xInd),0.05],[T(yInd,xInd),W(yInd,xInd),1],options)');        
                
                pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                
                pixHemoPred = conv(pixNeural,pixelHrf);
                pixHemoPred = pixHemoPred(1:numel(pixNeural));
                
                hrfParam(yInd,xInd,:) = pixHrfParam;
                objValues(yInd,xInd) = obj_val;
               
                r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end

A(:,:) = hrfParam(:,:,3);


%% 3 para vary
hrfParam = nan(128,128,3);
T = nan(128,128);
W = nan(128,128);
A = nan(128,128);
objValues = nan(128,128);
r = nan(128,128);
r2 = nan(128,128);

options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',5000,'Tolx',1e-8,'TolF',1e-8);

time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

    for xInd = 1:size(HbT_filter,2)
        for yInd = 1:size(HbT_filter,1)
            if mask(yInd,xInd)
                pixHemo = zscore(squeeze(HbT_filter(yInd,xInd,:))');
                pixNeural = zscore(squeeze(Calcium_filter(yInd,xInd,:))');            
                he = HemodynamicsError(t,pixNeural,pixHemo);
                fcn = @(param)he.fcn(param);
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');        
                
                pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3));
                
                pixHemoPred = conv(pixNeural,pixelHrf);
                pixHemoPred = pixHemoPred(1:numel(pixNeural));
                
                hrfParam(yInd,xInd,:) = pixHrfParam;
                objValues(yInd,xInd) = obj_val;
               
                r(yInd,xInd) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:) = hrfParam(:,:,1);
    W(:,:) = hrfParam(:,:,2);
    A(:,:) = hrfParam(:,:,3);





%% brain vs iteration, T, W, A change together

hrfParam = nan(128,128,3,300);
T = nan(128,128,300);
W = nan(128,128,300);
A = nan(128,128,300);
objValues = nan(128,128,300);
r = nan(128,128,300);
r2 = nan(128,128,300);
mask = reshape(mask,128,128);
for ii = 1:300
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
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
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
                
                
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
                
                hrfParam(yInd,xInd,:,ii) = pixHrfParam;
                objValues(yInd,xInd,ii) = obj_val;
                
                r(yInd,xInd,ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd,ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:,ii) = hrfParam(:,:,1,ii);
    W(:,:,ii) = hrfParam(:,:,2,ii);
    A(:,:,ii) = hrfParam(:,:,3,ii);
end

mask = mask(:);
tempT = reshape(T,128*128,[]);
tempT = tempT(mask,:);

tempW = reshape(W,128*128,[]);
tempW = tempW(mask,:);

tempA = reshape(A,128*128,[]);
tempA = tempA(mask,:);

tempObj = reshape(objValues,128*128,[]);
tempObj = tempObj(mask,:);

tempr = reshape(r,128*128,[]);
tempr = tempr(mask,:);

tempr2 = reshape(r2,128*128,[]);
tempr2 = tempr2(mask,:);


figure
plot_distribution_prctile(1:300,tempT,'Color',[255 0 0]./255)
plot_distribution_prctile(1:300,tempW,'Color',[0 255 0]./255)
plot_distribution_prctile(1:300,tempA,'Color',[0 0 255]./255)
plot_distribution_prctile(1:300,tempr,'Color',[0 255 255]./255)
plot_distribution_prctile(1:300,tempr2,'Color',[0 0 0]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

figure
plot_distribution_prctile(1:300,tempObj,'Color',[255 0 255]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Objective value')

T1 = nan(128*128,1);
W1 = nan(128*128,1);
A1 = nan(128*128,1);
r1 = nan(128*128,1);
r21 = nan(128*128,1);
Obj1 = nan(128*128,1);

T1(mask) = tempT(:,300);
W1(mask) = tempW(:,300);
A1(mask) = tempA(:,300);
r1(mask) = tempr(:,300);
r21(mask) = tempr2(:,300);
Obj1(mask) = tempObj(:,300);

T1 = reshape(T1,128,128);
W1 = reshape(W1,128,128);
A1 = reshape(A1,128,128);
r1 = reshape(r1,128,128);
r21 = reshape(r21,128,128);
Obj1 = reshape(Obj1,128,128);


figure
subplot(2,3,1)
imagesc(T1,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W1,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A1,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%)')
colorbar


subplot(2,3,4)
imagesc(r1,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r21,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(Obj1)
axis image off
colormap jet
title('Objective Value')
colorbar


save('X:\GammaFit\190627-R5M2285-fc1-VaryTWA','tempT','tempW','tempA','tempr',...
    'tempr2','tempObj')

load('X:\GammaFit\190627-R5M2285-fc1-VaryTWA','tempT','tempW','tempA','tempr',...
    'tempr2','tempObj')



%% A fix, vary T and W

hrfParam = nan(128,128,3,300);
T = nan(128,128,300);
W = nan(128,128,300);
A = nan(128,128,300);
objValues = nan(128,128,300);
r = nan(128,128,300);
r2 = nan(128,128,300);
mask = reshape(mask,128,128);
for ii = 1:300
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
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
                fcn = @(param)he.fcn_norm(param);
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.12],[0.01,0.3,0.12],[2,3,0.12],options)');
                
                
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
                
                hrfParam(yInd,xInd,:,ii) = pixHrfParam;
                objValues(yInd,xInd,ii) = obj_val;
                
                r(yInd,xInd,ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd,ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:,ii) = hrfParam(:,:,1,ii);
    W(:,:,ii) = hrfParam(:,:,2,ii);
    A(:,:,ii) = hrfParam(:,:,3,ii);
end

mask = mask(:);
tempT = reshape(T,128*128,[]);
tempT = tempT(mask,:);

tempW = reshape(W,128*128,[]);
tempW = tempW(mask,:);

tempA = reshape(A,128*128,[]);
tempA = tempA(mask,:);

tempObj = reshape(objValues,128*128,[]);
tempObj = tempObj(mask,:);

tempr = reshape(r,128*128,[]);
tempr = tempr(mask,:);

tempr2 = reshape(r2,128*128,[]);
tempr2 = tempr2(mask,:);


figure
plot_distribution_prctile(1:300,tempT,'Color',[255 0 0]./255)
plot_distribution_prctile(1:300,tempW,'Color',[0 255 0]./255)
plot_distribution_prctile(1:300,tempA,'Color',[0 0 255]./255)
plot_distribution_prctile(1:300,tempr,'Color',[0 255 255]./255)
plot_distribution_prctile(1:300,tempr2,'Color',[0 0 0]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlim([0 300])
figure
plot_distribution_prctile(1:300,tempObj,'Color',[255 0 255]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Objective value')
xlim([0 300])
T1 = nan(128*128,1);
W1 = nan(128*128,1);
A1 = nan(128*128,1);
r1 = nan(128*128,1);
r21 = nan(128*128,1);
Obj1 = nan(128*128,1);

T1(mask) = tempT(:,300);
W1(mask) = tempW(:,300);
A1(mask) = tempA(:,300);
r1(mask) = tempr(:,300);
r21(mask) = tempr2(:,300);
Obj1(mask) = tempObj(:,300);

T1 = reshape(T1,128,128);
W1 = reshape(W1,128,128);
A1 = reshape(A1,128,128);
r1 = reshape(r1,128,128);
r21 = reshape(r21,128,128);
Obj1 = reshape(Obj1,128,128);


figure
subplot(2,3,1)
imagesc(T1,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W1,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A1,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r1,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r21,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(Obj1)
axis image off
colormap jet
title('Objective Value')
colorbar
save('X:\GammaFit\190627-R5M2285-fc1-VaryTW','tempT','tempW','tempA','tempr',...
    'tempr2','tempObj')


%% A fix, vary T and W, only two para

hrfParam = nan(128,128,2,300);
T = nan(128,128,300);
W = nan(128,128,300);
objValues = nan(128,128,300);
r = nan(128,128,300);
r2 = nan(128,128,300);
mask = reshape(mask,128,128);
for ii = 1:300
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
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
                fcn = @(param)he.fcn_TW(param);
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5],[0.01,0.3],[2,3],options)');
                
                
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
                
                pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),0.21);
                
                pixHemoPred = conv(pixNeural,pixelHrf);
                pixHemoPred = pixHemoPred(1:numel(pixNeural));
                
                hrfParam(yInd,xInd,:,ii) = pixHrfParam;
                objValues(yInd,xInd,ii) = obj_val;
                
                r(yInd,xInd,ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd,ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:,ii) = hrfParam(:,:,1,ii);
    W(:,:,ii) = hrfParam(:,:,2,ii);
end


mask = mask(:);
tempT = reshape(T,128*128,[]);
tempT = tempT(mask,:);

tempW = reshape(W,128*128,[]);
tempW = tempW(mask,:);

A = repmat(0.21,128*128,300);
tempA = A(mask,:);
tempW = tempW(mask,:);

tempObj = reshape(objValues,128*128,[]);
tempObj = tempObj(mask,:);

tempr = reshape(r,128*128,[]);
tempr = tempr(mask,:);

tempr2 = reshape(r2,128*128,[]);
tempr2 = tempr2(mask,:);


figure
plot_distribution_prctile(1:300,tempT,'Color',[255 0 0]./255)
plot_distribution_prctile(1:300,tempW,'Color',[0 255 0]./255)
plot_distribution_prctile(1:300,tempA,'Color',[0 0 255]./255)
plot_distribution_prctile(1:300,tempr,'Color',[0 255 255]./255)
plot_distribution_prctile(1:300,tempr2,'Color',[0 0 0]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlim([0 300])
figure
plot_distribution_prctile(1:300,tempObj,'Color',[255 0 255]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Objective value')
xlim([0 300])
T1 = nan(128*128,1);
W1 = nan(128*128,1);
r1 = nan(128*128,1);
r21 = nan(128*128,1);
Obj1 = nan(128*128,1);

T1(mask) = tempT(:,300);
W1(mask) = tempW(:,300);
A1(mask) = tempA(:,300);
r1(mask) = tempr(:,300);
r21(mask) = tempr2(:,300);
Obj1(mask) = tempObj(:,300);

T1 = reshape(T1,128,128);
W1 = reshape(W1,128,128);
A1 = reshape(W1,128,128);
r1 = reshape(r1,128,128);
r21 = reshape(r21,128,128);
Obj1 = reshape(Obj1,128,128);


figure
subplot(2,3,1)
imagesc(T1,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W1,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(ones(128)*0.21,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%))')
colorbar


subplot(2,3,4)
imagesc(r1,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r21,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(Obj1)
axis image off
colormap jet
title('Objective Value')
colorbar


save('X:\GammaFit\190627-R5M2285-fc1-ParaTW','tempT','tempW','tempA','tempr',...
    'tempr2','tempObj')



%% brain vs iteration, T, W, A change together, zscore mse

hrfParam = nan(128,128,3,300);
T = nan(128,128,300);
W = nan(128,128,300);
A = nan(128,128,300);
objValues = nan(128,128,300);
r = nan(128,128,300);
r2 = nan(128,128,300);
mask = reshape(mask,128,128);
for ii = 1:300
    options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',ii,'Tolx',1e-8,'TolF',1e-8);
    
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
                fcn = @(param)he.fcn_norm(param);
                [~,pixHrfParam,obj_val,~,~] = evalc('fminsearchbnd(fcn,[1,1.5,0.25],[0.01,0.3,0.05],[2,3,1],options)');
                
                
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
                
                hrfParam(yInd,xInd,:,ii) = pixHrfParam;
                objValues(yInd,xInd,ii) = obj_val;
                
                r(yInd,xInd,ii) = corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
                r2(yInd,xInd,ii) = 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
                
                %1 - var(pixHemoPred - pixHemo)/var(pixHemo);
            end
        end
    end
    T(:,:,ii) = hrfParam(:,:,1,ii);
    W(:,:,ii) = hrfParam(:,:,2,ii);
    A(:,:,ii) = hrfParam(:,:,3,ii);
end

mask = mask(:);
tempT = reshape(T,128*128,[]);
tempT = tempT(mask,:);

tempW = reshape(W,128*128,[]);
tempW = tempW(mask,:);

tempA = reshape(A,128*128,[]);
tempA = tempA(mask,:);

tempObj = reshape(objValues,128*128,[]);
tempObj = tempObj(mask,:);

tempr = reshape(r,128*128,[]);
tempr = tempr(mask,:);

tempr2 = reshape(r2,128*128,[]);
tempr2 = tempr2(mask,:);


figure
plot_distribution_prctile(1:300,tempT,'Color',[255 0 0]./255)
plot_distribution_prctile(1:300,tempW,'Color',[0 255 0]./255)
plot_distribution_prctile(1:300,tempA,'Color',[0 0 255]./255)
plot_distribution_prctile(1:300,tempr,'Color',[0 255 255]./255)
plot_distribution_prctile(1:300,tempr2,'Color',[0 0 0]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

figure
plot_distribution_prctile(1:300,tempObj,'Color',[255 0 255]./255)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Objective value')

T1 = nan(128*128,1);
W1 = nan(128*128,1);
A1 = nan(128*128,1);
r1 = nan(128*128,1);
r21 = nan(128*128,1);
Obj1 = nan(128*128,1);

T1(mask) = tempT(:,300);
W1(mask) = tempW(:,300);
A1(mask) = tempA(:,300);
r1(mask) = tempr(:,300);
r21(mask) = tempr2(:,300);
Obj1(mask) = tempObj(:,300);

T1 = reshape(T1,128,128);
W1 = reshape(W1,128,128);
A1 = reshape(A1,128,128);
r1 = reshape(r1,128,128);
r21 = reshape(r21,128,128);
Obj1 = reshape(Obj1,128,128);


figure
subplot(2,3,1)
imagesc(T1,[0 2])
axis image off
colorbar
colormap jet
title('T(s)')

subplot(2,3,2)
imagesc(W1,[0 3])
axis image off
colormap jet
title('W(s)')
colorbar


subplot(2,3,3)
imagesc(A1,[0 0.3])
axis image off
colormap jet
title('A((\Delta\muM)/(\DeltaF/F%)')
colorbar


subplot(2,3,4)
imagesc(r1,[-1 1])
axis image off
colormap jet
title('r')
colorbar

subplot(2,3,5)
imagesc(r21,[0 1])
axis image off
colormap jet
title('R^2')
colorbar

subplot(2,3,6)
imagesc(Obj1)
axis image off
colormap jet
title('Objective Value')
colorbar


save('X:\GammaFit\190627-R5M2285-fc1-VaryTWAzscoreovj','tempT','tempW','tempA','tempr',...
    'tempr2','tempObj')
%% Vary A only, does convulution work?
timetrace = rand(1,300);
T=0.6; W = 1.8; A1 = 0.21; A2 = 1;
pixelHrf1 = hrfGamma(t,T,W,A1);
pixelHrf2= hrfGamma(t,T,W,A2);

pixPred1 = conv(timetrace,pixelHrf1);
pixPred2 = conv(timetrace,pixelHrf2);

pixPred1 = pixPred1(1:300);
pixPred2 = pixPred2(1:300);
figure
plot(pixPred1)
hold on
plot(pixPred2)
hold on 
plot(pixPred2./pixPred1)
legend('A1 = 0.21','A2 = 1','pixPred2/pixPred1')


%% Plot gamma function
T_5 = median(tempT(:,5));
T_11 = median(tempT(:,11));
T_100 = median(tempT(:,100));
T_300 = median(tempT(:,300));
W_5 = median(tempW(:,5));
W_11 = median(tempW(:,11));
W_100 = median(tempW(:,100));
W_300 = median(tempW(:,300));
A_5 = median(tempA(:,5));
A_11 = median(tempA(:,11));
A_100 = median(tempA(:,100));
A_300 = median(tempA(:,300));


pixelHrf_5 = hrfGamma(t,T_5,W_5,A_5);
pixelHrf_11 = hrfGamma(t,T_11,W_11,A_11);
pixelHrf_100 = hrfGamma(t,T_100,W_100,A_100);
pixelHrf_300 = hrfGamma(t,T_300,W_300,A_300);

figure
plot(t,pixelHrf_5,'r')
hold on;plot(t,pixelHrf_11,'g')
hold on;p1 = plot(t,pixelHrf_100,'c','LineWidth',3);
hold on;plot(t,pixelHrf_300,'b')
xlim([0 5])
xlabel('Time(s)')
ylabel('A((\Delta\muM)/(\DeltaF/F%))')
legend('Iter 5','Iter 11','Iter 100','Iter 300')

%% bad,vary A with one pixel, no norm
badLoc = [69,113];
goodLoc = [80,94];
options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',5000,'Tolx',1e-8,'TolF',1e-8);
time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

pixHemo = squeeze(HbT_filter(badLoc(1),badLoc(2),:))'*10^6;
pixNeural = squeeze(Calcium_filter(badLoc(1),badLoc(2),:))'*100;
he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn(param);
pixHrfParam = nan(3,20);
obj_val = nan(1,20);
r = nan(1,20);
r2 = nan(1,20);

ii = 1;
for A = 0.05:0.05:1
[~,pixHrfParam(:,ii),obj_val(ii),~,~] = evalc('fminsearchbnd(fcn,[1,1.5,A],[0.01,0.3,A],[2,3,A],options)');

pixelHrf = hrfGamma(t,pixHrfParam(1,ii),pixHrfParam(2,ii),pixHrfParam(3,ii));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

r(ii)= corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
r2(ii)= 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
ii = ii+1;
% figure
% plot((1:3000)/5,pixHemo,'k')
% hold on
% plot((1:3000)/5,pixHemoPred,'g')
% hold on
% plot((1:3000)/5,pixNeural,'m')
% xlim([0 100])
% legend('Actual Hemo','PredHemo','calcium')
% xlabel('Time(s)')
% title(['A =' num2str(A)])
end
figure
A = 0.05:0.05:1;
plot(A,pixHrfParam(1,:),'r')
hold on
plot(A,pixHrfParam(2,:),'g')
hold on
plot(A,r,'c')
hold on
plot(A,r2,'k')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('Time(s) or no unit')
legend('T','W','r','R^2','location','northeast')
figure
plot(A,obj_val,'m')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('(\muM)^2')
%% good location vary, A with one pixel, no norm
pixHemo = squeeze(HbT_filter(goodLoc(1),goodLoc(2),:))'*10^6;
pixNeural = squeeze(Calcium_filter(goodLoc(1),goodLoc(2),:))'*100;

time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn(param);
pixHrfParam = nan(3,20);
obj_val = nan(1,20);
r = nan(1,20);
r2 = nan(1,20);

ii = 1;
for A = 0.05:0.05:1
[~,pixHrfParam(:,ii),obj_val(ii),~,~] = evalc('fminsearchbnd(fcn,[1,1.5,A],[0.01,0.3,A],[2,3,A],options)');

pixelHrf = hrfGamma(t,pixHrfParam(1,ii),pixHrfParam(2,ii),pixHrfParam(3,ii));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

r(ii)= corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
r2(ii)= 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
ii = ii+1;
figure
plot((1:3000)/5,pixHemo,'k')
hold on
plot((1:3000)/5,pixHemoPred,'g')
hold on
plot((1:3000)/5,pixNeural,'m')
xlim([0 100])
legend('Actual Hemo','PredHemo','calcium')
xlabel('Time(s)')
title(['A =' num2str(A)])
end
figure
A = 0.05:0.05:1;
plot(A,pixHrfParam(1,:),'r')
hold on
plot(A,pixHrfParam(2,:),'g')
hold on
plot(A,r,'c')
hold on
plot(A,r2,'k')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
figure
plot(A,obj_val,'m')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('(\muM)^2')
%% bad vary A with one pixel, norm
badLoc = [69,113];
goodLoc = [80,94];
options=optimset('Display','iter','MaxFunEvals',20000,'MaxIter',5000,'Tolx',1e-8,'TolF',1e-8);
time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

pixHemo = squeeze(HbT_filter(badLoc(1),badLoc(2),:))'*10^6;
pixNeural = squeeze(Calcium_filter(badLoc(1),badLoc(2),:))'*100;
he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn_norm(param);
pixHrfParam = nan(3,20);
obj_val = nan(1,20);
r = nan(1,20);
r2 = nan(1,20);

ii = 1;
for A = 0.05:0.05:1
[~,pixHrfParam(:,ii),obj_val(ii),~,~] = evalc('fminsearchbnd(fcn,[1,1.5,A],[0.01,0.3,A],[2,3,A],options)');

pixelHrf = hrfGamma(t,pixHrfParam(1,ii),pixHrfParam(2,ii),pixHrfParam(3,ii));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

r(ii)= corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
r2(ii)= 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
ii = ii+1;
% figure
% plot((1:3000)/5,pixHemo,'k')
% hold on
% plot((1:3000)/5,pixHemoPred,'g')
% hold on
% plot((1:3000)/5,pixNeural,'m')
% xlim([0 100])
% legend('Actual Hemo','PredHemo','calcium')
% xlabel('Time(s)')
% title(['A =' num2str(A)])
end
figure
A = 0.05:0.05:1;
plot(A,pixHrfParam(1,:),'r')
hold on
plot(A,pixHrfParam(2,:),'g')
hold on
plot(A,r,'c')
hold on
plot(A,r2,'k')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('Time(s) or no unit')
legend('T','W','r','R^2','location','southwest')
figure
plot(A,obj_val,'m')
title('Objective Function')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('(\muM)^2')
%% good, vary A with one pixel, norm
pixHemo = squeeze(HbT_filter(goodLoc(1),goodLoc(2),:))'*10^6;
pixNeural = squeeze(Calcium_filter(goodLoc(1),goodLoc(2),:))'*100;

time_epoch=15;
t = linspace(0,time_epoch,time_epoch*sessionInfo.framerate *(5/sessionInfo.framerate));%% force it to be 5 hz

he = HemodynamicsError(t,pixNeural,pixHemo);

fcn = @(param)he.fcn_norm(param);
pixHrfParam = nan(3,20);
obj_val = nan(1,20);
r = nan(1,20);
r2 = nan(1,20);

ii = 1;
for A = 0.05:0.05:1
[~,pixHrfParam(:,ii),obj_val(ii),~,~] = evalc('fminsearchbnd(fcn,[1,1.5,A],[0.01,0.3,A],[2,3,A],options)');

pixelHrf = hrfGamma(t,pixHrfParam(1,ii),pixHrfParam(2,ii),pixHrfParam(3,ii));

pixHemoPred = conv(pixNeural,pixelHrf);
pixHemoPred = pixHemoPred(1:numel(pixNeural));

r(ii)= corr(pixHemoPred',pixHemo');%real(atanh(corr(pixHemoPred',pixHemo')));
r2(ii)= 1-sumsqr(pixHemo-pixHemoPred)/sumsqr(pixHemo-mean(pixHemo));
ii = ii+1;
% figure
% plot((1:3000)/5,pixHemo,'k')
% hold on
% plot((1:3000)/5,pixHemoPred,'g')
% hold on
% plot((1:3000)/5,pixNeural,'m')
% xlim([0 100])
% legend('Actual Hemo','PredHemo','calcium')
% xlabel('Time(s)')
% title(['A =' num2str(A)])
end
figure
A = 0.05:0.05:1;
plot(A,pixHrfParam(1,:),'r')
hold on
plot(A,pixHrfParam(2,:),'g')
hold on
plot(A,r,'c')
hold on
plot(A,r2,'k')
legend('T','W','r','R^2','location','northeast')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('Time(s) or no unit')
figure
plot(A,obj_val,'m')
xlabel('A((\Delta\muM)/(\DeltaF/F%))')
ylabel('(\muM)^2')