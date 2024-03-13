close all;clear all;clc
import mouse.*
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
excelRows = [ 181 183 185 228 232 236 202 195 204 230 234 240];
runs =1:3;
%% percentage noise for each run
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if ~exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        maskDir = saveDir;
    end
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'affineMarkers')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        saveName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        disp('loading raw data')
        load(fullfile(saveDir,saveName),'rawdata')
        % darkframe subtract
        if length(rawdata)>15000
            darkFrameInd = 2:sessionInfo.darkFrameNum/size(rawdata,3);
            darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
            raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
            clear rawdata
            raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/size(raw_baselineMinus,3))=[];
            rawdata = raw_baselineMinus;
            save(fullfile(saveDir,saveName),'rawdata','-append')
        end
        rawdata(:,:,:,1) = [];
        % Detrend
        raw_detrend = temporalDetrendAdam(rawdata);
        % Average
        raw_mean = mean(raw_detrend,4);
        % Convert to e-
        eCounts = raw_mean*0.45;
        eNoise = sqrt(eCounts);
        eNoise_percent = eNoise./eCounts;
        xform_eNoise_percent = process.affineTransform(eNoise_percent,affineMarkers);
        save(fullfile(saveDir, saveName),'xform_eNoise_percent','-append')
    end
    close all
end

%% mouse,mice average for noise
miceName = [];
xform_eNoise_percent_mice = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir = strcat('E:\RGECO\Kenny\', recDate, '\');
    if ~exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        maskDir = saveDir;
    end
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'affineMarkers')

    xform_eNoise_percent_mouse = [];
    visName = strcat(recDate,'-',mouseName,'-',sessionType);
    for n = runs
        saveName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir, saveName),'xform_eNoise_percent')
        xform_eNoise_percent_mouse = cat(4,xform_eNoise_percent_mouse,xform_eNoise_percent);
    end
    xform_eNoise_percent_mouse = mean(xform_eNoise_percent_mouse,4);
    save(fullfile(saveDir,strcat(visName,'.mat')),'xform_eNoise_percent_mouse')

    xform_eNoise_percent_mice = cat(4,xform_eNoise_percent_mice,xform_eNoise_percent_mouse);

    figure
    subplot(221)
    imagesc(xform_eNoise_percent_mouse(:,:,1)*100,[0.4,1])
    b = colorbar;
    ylabel(b,'%')
    axis image off
    title('FAF')

    subplot(222)
    imagesc(xform_eNoise_percent_mouse(:,:,2)*100,[0.4,1])
    b = colorbar;
    ylabel(b,'%')
    axis image off
    title('jRGECO1a')

    subplot(223)
    imagesc(xform_eNoise_percent_mouse(:,:,3)*100,[0.15,0.35])
    b = colorbar;
    ylabel(b,'%')
    axis image off
    title('Green Reflectance')

    subplot(224)
    imagesc(xform_eNoise_percent_mouse(:,:,4)*100,[0.15,0.35])
    b = colorbar;
    ylabel(b,'%')
    axis image off
    title('Red Reflectance')

    colormap(brewermap(256, '-Spectral'))
    sgtitle(strcat(visName,', Noise Percentage'))
    saveas(gcf,strcat(visName,'.png'))
    saveas(gcf,strcat(visName,'.fig'))
end
xform_eNoise_percent_mice = mean(xform_eNoise_percent_mice,4);
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
save(fullfile(saveDir,processedName_mice),'xform_eNoise_percent_mice')

%% Signal for each run (std)
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    for n = runs
        saveName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat');
        disp('loading data')
        % Calcium
        load(fullfile(saveDir,saveName),'xform_jrgeco1a')
        xform_jrgeco1a = squeeze(xform_jrgeco1a);
        std_Calcium_Uncorr  = std(xform_jrgeco1a,0,3);
        clear xform_jrgeco1a
        % FAD
        load(fullfile(saveDir,saveName),'xform_FAD')
        xform_FAD= squeeze(xform_FAD);
        std_FAD_Uncorr = std(xform_FAD,0,3);
        clear xform_FAD
        % assume HbT concentration at 76 uM: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5102543/
        load(fullfile(saveDir,saveName),'xform_datahb')
        HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))/(76*10^(-6));
        std_HbT = std(HbT,0,3);
        clear xform_datahb
        snrName = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_SNR.mat'));
        if exist(snrName,'file')
            save(snrName,'std_Calcium_Uncorr','std_FAD_Uncorr','std_HbT','-append')
        else
            save(snrName,'std_Calcium_Uncorr','std_FAD_Uncorr','std_HbT')
        end
    end
end

%% mouse average for signal (std)
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    std_Calcium_Uncorr_mouse = [];
    std_FAD_Uncorr_mouse = [];
    std_HbT_mouse = [];

    for n = runs
        snrName = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_SNR.mat'));
        load(snrName,'std_Calcium_Uncorr','std_FAD_Uncorr','std_HbT')
        std_Calcium_Uncorr_mouse = cat(3,std_Calcium_Uncorr_mouse,std_Calcium_Uncorr);
        std_FAD_Uncorr_mouse     = cat(3,std_FAD_Uncorr_mouse,std_FAD_Uncorr);
        std_HbT_mouse            = cat(3,std_HbT_mouse,std_HbT);
    end

    std_Calcium_Uncorr_mouse = mean(std_Calcium_Uncorr_mouse,3);
    std_FAD_Uncorr_mouse     = mean(std_FAD_Uncorr_mouse,3);
    std_HbT_mouse            = mean(std_HbT_mouse,3);
    snrName_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_SNR.mat'));
    if exist(snrName_mouse,'file')
        save(snrName_mouse,'std_Calcium_Uncorr_mouse','std_FAD_Uncorr_mouse','std_HbT_mouse','-append')
    else
        save(snrName_mouse,'std_Calcium_Uncorr_mouse','std_FAD_Uncorr_mouse','std_HbT_mouse')
    end
    figure
    subplot(221)
    imagesc(std_Calcium_Uncorr_mouse)
    colorbar
    axis image off
    title('Uncorrected Calcium')
    subplot(222)
    imagesc(std_FAD_Uncorr_mouse)
    colorbar
    axis image off
    title('Uncorrected FAF')
    subplot(223)
    imagesc(std_HbT_mouse)
    colorbar
    axis image off
    title('HbT')
    sgtitle(strcat(recDate,'-',mouseName,', std'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_SNR_percent.png')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_SNR_percent.fig')))
    close all
end
%% mice average for signal (std)
catDir = 'E:\RGECO\cat\';

excelRows_awake = [181 183 185 228 232 236];
miceName = [];
std_Calcium_Uncorr_mice = [];
std_FAD_Uncorr_mice     = [];
std_HbT_mice            = [];
for excelRow = excelRows_awake
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    snrName_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_SNR.mat'));
    load(snrName_mouse,'std_Calcium_Uncorr_mouse','std_FAD_Uncorr_mouse','std_HbT_mouse')
    std_Calcium_Uncorr_mice = cat(3,std_Calcium_Uncorr_mice,std_Calcium_Uncorr_mouse);
    std_FAD_Uncorr_mice     = cat(3,std_FAD_Uncorr_mice,std_FAD_Uncorr_mouse);
    std_HbT_mice            = cat(3,std_HbT_mice,std_HbT_mouse);
end
std_Calcium_Uncorr_mice = mean(std_Calcium_Uncorr_mice,3);
std_FAD_Uncorr_mice     = mean(std_FAD_Uncorr_mice,3);
std_HbT_mice            = mean(std_HbT_mice,3);
snrName_mice = fullfile(catDir,strcat(recDate,'-',miceName,'-',sessionType,'_SNR.mat'));

if exist(snrName_mice,'file')
    save(snrName_mice,'std_Calcium_Uncorr_mice','std_FAD_Uncorr_mice','std_HbT_mice','-append')
else
    save(snrName_mice,'std_Calcium_Uncorr_mice','std_FAD_Uncorr_mice','std_HbT_mice')
end

excelRows_anes = [ 202 195 204 230 234 240];
miceName = [];
std_Calcium_Uncorr_mice = [];
std_FAD_Uncorr_mice     = [];
std_HbT_mice            = [];
for excelRow = excelRows_anes
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = char(strcat(miceName, '-', mouseName));
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    snrName_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_SNR.mat'));
    load(snrName_mouse,'std_Calcium_Uncorr_mouse','std_FAD_Uncorr_mouse','std_HbT_mouse')
    std_Calcium_Uncorr_mice = cat(3,std_Calcium_Uncorr_mice,std_Calcium_Uncorr_mouse);
    std_FAD_Uncorr_mice     = cat(3,std_FAD_Uncorr_mice,std_FAD_Uncorr_mouse);
    std_HbT_mice            = cat(3,std_HbT_mice,std_HbT_mouse);
end
std_Calcium_Uncorr_mice = mean(std_Calcium_Uncorr_mice,3);
std_FAD_Uncorr_mice     = mean(std_FAD_Uncorr_mice,3);
std_HbT_mice            = mean(std_HbT_mice,3);
snrName_mice = fullfile(catDir,strcat(recDate,'-',miceName,'-',sessionType,'_SNR.mat'));

if exist(snrName_mice,'file')
    save(snrName_mice,'std_Calcium_Uncorr_mice','std_FAD_Uncorr_mice','std_HbT_mice','-append')
else
    save(snrName_mice,'std_Calcium_Uncorr_mice','std_FAD_Uncorr_mice','std_HbT_mice')
end

%% Visualization
load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat',...
    'xform_isbrain_mice')
xform_isbrain_mice_awake = xform_isbrain_mice;
load('E:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat',...
    'xform_isbrain_mice')
xform_isbrain_mice_anes = xform_isbrain_mice;
xform_isbrain_mice = xform_isbrain_mice_awake.*xform_isbrain_mice_anes;

load('noVasculatureMask.mat')
mask = (leftMask+rightMask).*xform_isbrain_mice;

load("E:\RGECO\191030\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat",...
    'xform_eNoise_percent_mice')
xform_eNoise_percent_mice_awake = xform_eNoise_percent_mice;
load("E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_SNR.mat",...
    'std_Calcium_Uncorr_mice','std_FAD_Uncorr_mice','std_HbT_mice')
std_Calcium_Uncorr_mice_awake = std_Calcium_Uncorr_mice;
std_FAD_Uncorr_mice_awake = std_FAD_Uncorr_mice;
std_HbT_mice_awake = std_HbT_mice;

load("E:\RGECO\191030\191030--R5M2285-anes-R5M2286-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat",...
    'xform_eNoise_percent_mice')
xform_eNoise_percent_mice_anes = xform_eNoise_percent_mice;
load("E:\RGECO\cat\191030--R5M2285-anes-R5M2286-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_SNR.mat",...
    'std_Calcium_Uncorr_mice','std_FAD_Uncorr_mice','std_HbT_mice')
std_Calcium_Uncorr_mice_anes = std_Calcium_Uncorr_mice;
std_FAD_Uncorr_mice_anes = std_FAD_Uncorr_mice;
std_HbT_mice_anes = std_HbT_mice;

%% noise
figure
subplot(221)
imagesc(xform_eNoise_percent_mice_awake(:,:,2)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 1])
title('jRGECO1a')

subplot(222)
imagesc(xform_eNoise_percent_mice_awake(:,:,1)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 1])
title('FAF')

subplot(223)
imagesc(xform_eNoise_percent_mice_awake(:,:,3)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 0.3])
title('Green')

subplot(224)
imagesc(xform_eNoise_percent_mice_awake(:,:,4)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 0.3])
title('Red')
sgtitle('Awake noise')

colormap(brewermap(256, '-Spectral'))

figure
subplot(221)
imagesc(xform_eNoise_percent_mice_anes(:,:,2)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 1])
title('jRGECO1a')

subplot(222)
imagesc(xform_eNoise_percent_mice_anes(:,:,1)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 1])
title('FAF')

subplot(223)
imagesc(xform_eNoise_percent_mice_anes(:,:,3)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 0.3])
title('Green')

subplot(224)
imagesc(xform_eNoise_percent_mice_anes(:,:,4)*100,'AlphaData',mask)
axis image off
b = colorbar;
ylabel(b,'%')
clim([0 0.3])
title('Red')
sgtitle('Anesthetized noise')

colormap(brewermap(256, '-Spectral'))

%% std
figure
subplot(221)
imagesc(std_Calcium_Uncorr_mice_awake*100,'AlphaData',mask)
axis image off
clim([0 2.5])
b = colorbar;
ylabel(b,'%')
title('jRGECO1a')

subplot(222)
imagesc(std_FAD_Uncorr_mice_awake*100,'AlphaData',mask)
axis image off
clim([0 1.5])
b = colorbar;
ylabel(b,'%')
title('FAF')

subplot(223)
imagesc(std_HbT_mice_awake*100,'AlphaData',mask)
axis image off
clim([0 4])
b = colorbar;
ylabel(b,'%')
title('HbT')
colormap(brewermap(256, '-Spectral'))
sgtitle('Awake STD')

figure
subplot(221)
imagesc(std_Calcium_Uncorr_mice_anes*100,'AlphaData',mask)
axis image off
clim([0 6])
b = colorbar;
ylabel(b,'%')
title('jRGECO1a')

subplot(222)
imagesc(std_FAD_Uncorr_mice_anes*100,'AlphaData',mask)
axis image off
clim([0 1.5])
b = colorbar;
ylabel(b,'%')
title('FAF')

subplot(223)
imagesc(std_HbT_mice_anes*100,'AlphaData',mask)
axis image off
clim([0 1.5])
b = colorbar;
ylabel(b,'%')
title('HbT')

colormap(brewermap(256, '-Spectral'))
sgtitle('Anesthetized STD')

%% SNR
figure
subplot(221)
imagesc(2*std_Calcium_Uncorr_mice_awake./xform_eNoise_percent_mice_awake(:,:,2),'AlphaData',mask)
axis image off
clim([0 6])
colorbar
title('jRGECO1a')

subplot(222)
imagesc(2*std_FAD_Uncorr_mice_awake./xform_eNoise_percent_mice_awake(:,:,1),'AlphaData',mask)
axis image off
clim([0 5])
colorbar
title('FAF')

subplot(223)
imagesc(2*std_HbT_mice_awake./xform_eNoise_percent_mice_awake(:,:,3),'AlphaData',mask)
axis image off
clim([0 40])
colorbar
title('HbT')
colormap(brewermap(256, '-Spectral'))
sgtitle('Awake SNR')

figure
subplot(221)
imagesc(2*std_Calcium_Uncorr_mice_anes./xform_eNoise_percent_mice_anes(:,:,2),'AlphaData',mask)
axis image off
clim([0 20])
colorbar
title('jRGECO1a')

subplot(222)
imagesc(2*std_FAD_Uncorr_mice_anes./xform_eNoise_percent_mice_anes(:,:,1),'AlphaData',mask)
axis image off
clim([0 5])
colorbar
title('FAF')

subplot(223)
imagesc(2*std_HbT_mice_anes./xform_eNoise_percent_mice_anes(:,:,3),'AlphaData',mask)
axis image off
clim([0 15])
colorbar
title('HbT')
colormap(brewermap(256, '-Spectral'))
sgtitle('Anesthetized SNR')




