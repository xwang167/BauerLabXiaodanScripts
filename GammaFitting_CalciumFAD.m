
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181,183,185,228,232,236,202,195,204,230,234,240]; % excelRows_awake = [181 183 185 228  232  236 ]; excelRows_anes = [ 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
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

    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

        FAD_filter = mouse.freq.filterData(double(xform_FADCorr),0.02,2,25);
        clear xform_FADCorr
        Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        clear xform_jrgeco1aCorr
        t = (0:750)./25;
       %[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,FAD_filter*10^6,t);
       %[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,FAD_filter,t);
       Calcium_filter = reshape(Calcium_filter,128*128,[]);
       FAD_filter = reshape(FAD_filter,128*128,[]);
       Calcium_filter = normRow(Calcium_filter);
       FAD_filter = normRow(FAD_filter);
       Calcium_filter = reshape(Calcium_filter,128,128,[]);
       FAD_filter = reshape(FAD_filter,128,128,[]);
       tic
       [T_CalciumFAD,W_CalciumFAD,A_CalciumFAD,r_CalciumFAD,r2_CalciumFAD,FADPred_CalciumFAD] = interSpeciesGammaFit_CalciumFAD(Calcium_filter,FAD_filter,t);
       toc
        save(fullfile(saveDir,processedName),'T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD','r2_CalciumFAD','FADPred_CalciumFAD','-append')
        figure
        subplot(2,3,1)
        imagesc(T_CalciumFAD,[0,0.2])
        colorbar
        axis image off
        colormap jet
        title('T(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,2)
        imagesc(W_CalciumFAD,[0 0.06])
        colorbar
        axis image off
        colormap jet
        title('W(s)')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,3)
        imagesc(A_CalciumFAD,[0 1.2])
        colorbar
        axis image off
        colormap jet
        title('A')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,4)
        imagesc(r_CalciumFAD,[-1 1])
        colorbar
        axis image off
        colormap jet
        title('r')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        subplot(2,3,5)
        imagesc(r2_CalciumFAD,[0 1])
        colorbar
        axis image off
        colormap jet
        title('R^2')
        hold on;
        imagesc(xform_WL,'AlphaData',1-mask);
        set(gca,'FontSize',14,'FontWeight','Bold')

        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit.fig')));
        close all
    end
end

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
    
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    T_CalciumFAD_mouse = [];
    W_CalciumFAD_mouse = [];
    A_CalciumFAD_mouse = [];
    r_CalciumFAD_mouse = [];
    r2_CalciumFAD_mouse = [];
    FADPred_mouse = [];
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        disp(visName)
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD','r2_CalciumFAD','FADPred_CalciumFAD')
        mask_nan = zeros(128,128);
        mask_nan(T_CalciumFAD<0.002) = 1;
        mask_nan(W_CalciumFAD<0.005) = 1;
        mask_nan(A_CalciumFAD<0.2) = 1;
        mask_nan(r_CalciumFAD<0.006) = 1;
        mask_nan = logical(mask_nan);
        figure
        imagesc(mask_nan)
        axis image off
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_NaNMask.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_NaNMask.fig')));
        T_CalciumFAD(mask_nan) = NaN;
        W_CalciumFAD(mask_nan) = NaN;
        A_CalciumFAD(mask_nan) = NaN;
        r_CalciumFAD(mask_nan) = NaN;
        r2_CalciumFAD(mask_nan) = NaN;
        FADPred_CalciumFAD(mask_nan,:) = NaN;
        
        T_CalciumFAD_mouse = cat(3,T_CalciumFAD_mouse,T_CalciumFAD);
        W_CalciumFAD_mouse = cat(3,W_CalciumFAD_mouse,W_CalciumFAD);
        A_CalciumFAD_mouse = cat(3,A_CalciumFAD_mouse,A_CalciumFAD);
        r_CalciumFAD_mouse = cat(3,r_CalciumFAD_mouse,r_CalciumFAD);
        r2_CalciumFAD_mouse = cat(3,r2_CalciumFAD_mouse,r2_CalciumFAD);
        FADPred_mouse = cat(4,FADPred_mouse,FADPred_CalciumFAD);
    end
    T_CalciumFAD_mouse = nanmean(T_CalciumFAD_mouse,3);
    W_CalciumFAD_mouse = nanmean(W_CalciumFAD_mouse,3);
    A_CalciumFAD_mouse = nanmean(A_CalciumFAD_mouse,3);
    r_CalciumFAD_mouse = nanmean(r_CalciumFAD_mouse,3);
    r2_CalciumFAD_mouse = nanmean(r2_CalciumFAD_mouse,3);
    FADPred_mouse = nanmean(FADPred_mouse,4);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    save(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_mouse','-append')
    
    figure
    subplot(2,3,1)
    imagesc(T_CalciumFAD_mouse,[0,0.2])
    colorbar
    axis image off
    colormap jet
    title('T(s)')
    hold on;
    %imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W_CalciumFAD_mouse,[0 0.06])
    colorbar
    axis image off
    colormap jet
    title('W(s)')
    hold on;
    %imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,3)
    imagesc(A_CalciumFAD_mouse,[0 1.2])
    colorbar
    axis image off
    colormap jet
    title('A')
    hold on;
    %imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4)
    imagesc(r_CalciumFAD_mouse,[-1 1])
    colorbar
    axis image off
    colormap jet
    title('r')
    hold on;
    %imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,5)
    imagesc(r2_CalciumFAD_mouse,[0 1])
    colorbar
    axis image off
    colormap jet
    title('R^2')
    hold on;
    %imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumFAD_GammaFit.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumFAD_GammaFit.fig')));
    close all
    
end

%Awake
excelRows = [181,183,185,228,232,236];
T_CalciumFAD_mice = [];
W_CalciumFAD_mice = [];
A_CalciumFAD_mice = [];
r_CalciumFAD_mice = [];
r2_CalciumFAD_mice = [];
FADPred_mice = [];
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
    
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_mouse')
    T_CalciumFAD_mice = cat(3,T_CalciumFAD_mice,T_CalciumFAD_mouse);
    W_CalciumFAD_mice = cat(3,W_CalciumFAD_mice,W_CalciumFAD_mouse);
    A_CalciumFAD_mice = cat(3,A_CalciumFAD_mice,A_CalciumFAD_mouse);
    r_CalciumFAD_mice = cat(3,r_CalciumFAD_mice,r_CalciumFAD_mouse);
    r2_CalciumFAD_mice = cat(3,r2_CalciumFAD_mice,r2_CalciumFAD_mouse);
    FADPred_mice = cat(4,FADPred_mice,FADPred_mouse);
end
T_CalciumFAD_mice = nanmean(T_CalciumFAD_mice,3);
W_CalciumFAD_mice = nanmean(W_CalciumFAD_mice,3);
A_CalciumFAD_mice = nanmean(A_CalciumFAD_mice,3);
r_CalciumFAD_mice = nanmean(r_CalciumFAD_mice,3);
r2_CalciumFAD_mice = nanmean(r2_CalciumFAD_mice,3);
FADPred_mice = nanmean(FADPred_mice,4);
%
processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat';
save(fullfile('L:\RGECO\cat',processedName_mice),'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice','r_CalciumFAD_mice','r2_CalciumFAD_mice','FADPred_mice','-append')
figure
subplot(2,3,1)
imagesc(T_CalciumFAD_mice,[0,0.2])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumFAD_mice,[0 0.06])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumFAD_mice,[0 1.2])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r_CalciumFAD_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumFAD_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
suptitle('Awake Calcium FAD Gamma Fitting')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumFAD_GammaFit.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumFAD_GammaFit.fig')));



mask_new = logical(mask_new);
T_CalciumFAD = mean(T_CalciumFAD_mice(mask_new))
W_CalciumFAD = mean(W_CalciumFAD_mice(mask_new))
A_CalciumFAD = mean(A_CalciumFAD_mice(mask_new))
r_CalciumFAD = mean(r_CalciumFAD_mice(mask_new))
r2_CalciumFAD = mean(r2_CalciumFAD_mice(mask_new))

%Anes
excelRows = [202,195,204,230,234,240];
T_CalciumFAD_mice = [];
W_CalciumFAD_mice = [];
A_CalciumFAD_mice = [];
r_CalciumFAD_mice = [];
r2_CalciumFAD_mice = [];
FADPred_mice = [];
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
    
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    load(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_mouse')
    T_CalciumFAD_mice = cat(3,T_CalciumFAD_mice,T_CalciumFAD_mouse);
    W_CalciumFAD_mice = cat(3,W_CalciumFAD_mice,W_CalciumFAD_mouse);
    A_CalciumFAD_mice = cat(3,A_CalciumFAD_mice,A_CalciumFAD_mouse);
    r_CalciumFAD_mice = cat(3,r_CalciumFAD_mice,r_CalciumFAD_mouse);
    r2_CalciumFAD_mice = cat(3,r2_CalciumFAD_mice,r2_CalciumFAD_mouse);
    FADPred_mice = cat(4,FADPred_mice,FADPred_mouse);
end
T_CalciumFAD_mice = nanmean(T_CalciumFAD_mice,3);
W_CalciumFAD_mice = nanmean(W_CalciumFAD_mice,3);
A_CalciumFAD_mice = nanmean(A_CalciumFAD_mice,3);
r_CalciumFAD_mice = nanmean(r_CalciumFAD_mice,3);
r2_CalciumFAD_mice = nanmean(r2_CalciumFAD_mice,3);
FADPred_mice = nanmean(FADPred_mice,4);

processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat';
save(fullfile('L:\RGECO\cat',processedName_mice),'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice','r_CalciumFAD_mice','r2_CalciumFAD_mice','FADPred_mice','-append')
figure
subplot(2,3,1)
imagesc(T_CalciumFAD_mice,[0,0.2])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumFAD_mice,[0 0.06])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumFAD_mice,[0 1.2])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r_CalciumFAD_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumFAD_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
suptitle('Anes Calcium FAD Gamma Fitting')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumFAD_GammaFit.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumFAD_GammaFit.fig')));
mask_new = logical(mask_new)
T_CalciumFAD = mean(T_CalciumFAD_mice(mask_new));
W_CalciumFAD = mean(W_CalciumFAD_mice(mask_new))
A_CalciumFAD = mean(A_CalciumFAD_mice(mask_new))
r_CalciumFAD = mean(r_CalciumFAD_mice(mask_new))
r2_CalciumFAD = mean(r2_CalciumFAD_mice(mask_new))
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     T_CalciumFAD_mouse = [];
%     W_CalciumFAD_mouse = [];
%     A_CalciumFAD_mouse = [];
%     r_CalciumFAD_mouse = [];
%     r2_CalciumFAD_mouse = [];
%     FADPred_mouse = [];
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred')
%         T_CalciumFAD_mouse = cat(3,T_CalciumFAD_mouse,T);
%         W_CalciumFAD_mouse = cat(3,W_CalciumFAD_mouse,W);
%         A_CalciumFAD_mouse = cat(3,A_CalciumFAD_mouse,A);
%         r_CalciumFAD_mouse = cat(3,r_CalciumFAD_mouse,r);
%         r2_CalciumFAD_mouse = cat(3,r2_CalciumFAD_mouse,r2);
%         FADPred_mouse = cat(4,FADPred_mouse,hemoPred);
%     end
%     T_CalciumFAD_mouse = median(T_CalciumFAD_mouse,3);
%     W_CalciumFAD_mouse = median(W_CalciumFAD_mouse,3);
%     A_CalciumFAD_mouse = median(A_CalciumFAD_mouse,3);
%     r_CalciumFAD_mouse = median(r_CalciumFAD_mouse,3);
%     r2_CalciumFAD_mouse = median(r2_CalciumFAD_mouse,3);
%     FADPred_mouse = median(FADPred_mouse,4);
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     save(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_mouse','-append')
%
%
%     figure
%     subplot(2,3,1)
%     imagesc(T_CalciumFAD_mouse,[0,2])
%     colorbar
%     axis image off
%     colormap jet
%     title('T(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,2)
%     imagesc(W_CalciumFAD_mouse,[0 3])
%     colorbar
%     axis image off
%     colormap jet
%     title('W(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,3)
%     imagesc(A_CalciumFAD_mouse,[0 5])
%     colorbar
%     axis image off
%     colormap jet
%     title('A')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,4)
%     imagesc(r_CalciumFAD_mouse,[-1 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('r')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,5)
%     imagesc(r2_CalciumFAD_mouse,[0 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('R^2')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit.png')));
%     saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit.fig')));
%
% end
% %
% % %Awake
% excelRows = [181,183,185,228,232,236];
% T_mice = [];
% W_mice = [];
% A_mice = [];
% r_mice = [];
% r2_mice = [];
% hemoPred_mice = [];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%
%
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     load(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_mouse')
%     T_mice = cat(3,T_mice,T_CalciumFAD_mouse);
%     W_mice = cat(3,W_mice,W_CalciumFAD_mouse);
%     A_mice = cat(3,A_mice,A_CalciumFAD_mouse);
%     r_mice = cat(3,r_mice,r_CalciumFAD_mouse);
%     r2_mice = cat(3,r2_mice,r2_CalciumFAD_mouse);
%     hemoPred_mice = cat(4,hemoPred_mice,FADPred_mouse);
% end
% T_mice = median(T_mice,3);
% W_mice = median(W_mice,3);
% A_mice = median(A_mice,3);
% r_mice = median(r_mice,3);
% r2_mice = median(r2_mice,3);
% hemoPred_mice = median(hemoPred_mice,4);
%
% processedName_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_processed.mat';
% save(fullfile('L:\RGECO\cat',processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice','hemoPred_mice','-append')
%
% figure
% subplot(2,3,1)
% imagesc(T_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,2)
% imagesc(W_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,3)
% imagesc(A_mice,[0 5])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,4)
% imagesc(r_mice,[-1 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,5)
% imagesc(r2_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('R^2')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit.png')));
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit.fig')));
%
%
%
%
% %Anes
% excelRows = [202,195,204,230,234,240];
% T_mice = [];
% W_mice = [];
% A_mice = [];
% r_mice = [];
% r2_mice = [];
% hemoPred_mice = [];
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     rawdataloc = excelRaw{3};
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionInfo.mouseType = excelRaw{17};
%     sessionInfo.darkFrameNum = excelRaw{15};
%     systemType = excelRaw{5};
%     sessionInfo.framerate = excelRaw{7};
%
%     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
%
%     if ~exist(fullfile(saveDir_new,maskName),'file')
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%
%
%     processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     load(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_mouse')
%     T_mice = cat(3,T_mice,T_CalciumFAD_mouse);
%     W_mice = cat(3,W_mice,W_CalciumFAD_mouse);
%     A_mice = cat(3,A_mice,A_CalciumFAD_mouse);
%     r_mice = cat(3,r_mice,r_CalciumFAD_mouse);
%     r2_mice = cat(3,r2_mice,r2_CalciumFAD_mouse);
%     hemoPred_mice = cat(4,hemoPred_mice,FADPred_mouse);
% end
% T_mice = median(T_mice,3);
% W_mice = median(W_mice,3);
% A_mice = median(A_mice,3);
% r_mice = median(r_mice,3);
% r2_mice = median(r2_mice,3);
% hemoPred_mice = median(hemoPred_mice,4);
%
% processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat';
% save(fullfile('L:\RGECO\cat',processedName_mice),'T_mice','W_mice','A_mice','r_mice','r2_mice','hemoPred_mice','-append')
%
% figure
% subplot(2,3,1)
% imagesc(T_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,2)
% imagesc(W_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,3)
% imagesc(A_mice,[0 5])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,4)
% imagesc(r_mice,[-1 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,5)
% imagesc(r2_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('R^2')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit.png')));
% saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit.fig')));
%
%
%
%
%
%
%
%
%
% % FAD_filter = reshape(FAD_filter,128,128,[]);
% % Calcium_filter = reshape(Calcium_filter,128,128,[]);
% %
% % for ii = 1:14999%925
% %     subplot(1,3,1)
% %     imagesc(FAD_filter(:,:,ii)*10^6,[-4 4])
% %     title('HbT')
% %     axis image off
% %     colorbar
% %
% %     subplot(1,3,2)
% %     imagesc(hemoPred(:,:,ii),[-4 4])
% %     axis image off
% %     title('Predicted HbT')
% %     colorbar
% %     subplot(1,3,3)
% %     imagesc(FAD_filter(:,:,ii)*10^6 - hemoPred(:,:,ii),[-4 4])
% %     title('HbT-Predicted HbT')
% %     axis image off
% %     colorbar
% %     colormap jet
% %     pause(0.1)
% % end
% %
% % figure
% % peakMap = FAD_filter(:,:,925)*10^6;
% % imagesc(peakMap,[-5 5])
% % colormap jet
% % axis image off
% % [X,Y] = meshgrid(1:128,1:128);
% % [x1,y1] = ginput(1);
% % [x2,y2] = ginput(1);
% % radius = sqrt((x1-x2)^2+(y1-y2)^2);
% % ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% % max_ROI = prctile(peakMap(ROI),99);
% % temp = double(peakMap).*double(ROI);
% % ROI = temp>max_ROI*0.75;
% % hold on
% % ROI_contour = bwperim(ROI);
% % [~,c] = contour( ROI_contour,'r');
% % c.LineWidth = 0.001;
% %
% % FAD_filter = reshape(FAD_filter,128*128,[]);
% % hemoPred = reshape(hemoPred,128*128,[]);
% % iRi = reshape(ROI,128*128,1);
% %
% % HbT = squeeze(mean(FAD_filter(iRi,:),1));
% % hemoPred = reshape(hemoPred,128*128,[]);
% % hemoPred_ROI = squeeze(mean(hemoPred(iRi,:),1));
% %
% % figure
% % plot((1:14999)/25,HbT*10^6,'r')
% % hold on
% % plot((1:14999)/25,hemoPred,'k')
% %
% % legend('HbT','Predicted HbT')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'A_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'T_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'W_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'r2_mice')
load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_processed.mat', 'r_mice')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
mask = logical(mask);
A_avg = mean(A_CalciumFAD_mice(mask),'All');
r2_avg = mean(r2_CalciumFAD_mice(mask),'All');
r_avg = mean(r_CalciumFAD_mice(mask), 'All');
T_avg = mean(T_CalciumFAD_mice(mask), 'All');
W_avg = mean(W_CalciumFAD_mice(mask), 'All');
