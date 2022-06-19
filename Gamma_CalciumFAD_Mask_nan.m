%
clear all;close all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [202 195 204 230 234 240]; %excelRows_anes = [ 202 195 204 230 234 240];[181 183 185 228 232 236 

runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')

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
    mask = mask_new.*xform_isbrain;
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_FADCorr','xform_jrgeco1aCorr')
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        FAD_filter = filterData(double(xform_FADCorr),0.02,2,25);
        clear xform_FADCorr
        Calcium_filter = filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
        clear xform_jrgeco1aCorr
        t = (0:75)./25;
        [T_CalciumFAD,W_CalciumFAD,A_CalciumFAD,r_CalciumFAD,r2_CalciumFAD,FADPred_CalciumFAD] = interSpeciesGammaFit_CalciumFAD_Mask_nan(Calcium_filter,FAD_filter,t,mask);
        saveName =  strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_nan.mat');
        save(fullfile(saveDir,saveName),'T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD','r2_CalciumFAD','FADPred_CalciumFAD','-append')
        
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
        imagesc(A_CalciumFAD,[0 1])
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
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_nan.png')));
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_CalciumFAD_GammaFit_nan.fig')));
        close all
    end
end


%% mouse average
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%


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
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_nan','.mat');
        load(fullfile(saveDir,processedName),'T_CalciumFAD','W_CalciumFAD','A_CalciumFAD','r_CalciumFAD','r2_CalciumFAD','FADPred_CalciumFAD')

        T_CalciumFAD_mouse = cat(3,T_CalciumFAD_mouse,T_CalciumFAD);
        W_CalciumFAD_mouse = cat(3,W_CalciumFAD_mouse,W_CalciumFAD);
        A_CalciumFAD_mouse = cat(3,A_CalciumFAD_mouse,A_CalciumFAD);
        r_CalciumFAD_mouse = cat(3,r_CalciumFAD_mouse,r_CalciumFAD);
        r2_CalciumFAD_mouse = cat(3,r2_CalciumFAD_mouse,r2_CalciumFAD);

    end
    T_CalciumFAD_mouse = nanmean(T_CalciumFAD_mouse,3);
    W_CalciumFAD_mouse = nanmean(W_CalciumFAD_mouse,3);
    A_CalciumFAD_mouse = nanmean(A_CalciumFAD_mouse,3);
    r_CalciumFAD_mouse = nanmean(r_CalciumFAD_mouse,3);
    r2_CalciumFAD_mouse = nanmean(r2_CalciumFAD_mouse,3);

    save_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'GammaFAD_nan','.mat');
    save(fullfile(saveDir,save_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse','FADPred_CalciumFAD')

    figure
    subplot(2,3,1)
    imagesc(T_CalciumFAD_mouse,[0,0.2])
    colorbar
    axis image off
    colormap jet
    title('T(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,2)
    imagesc(W_CalciumFAD_mouse,[0 0.06])
    colorbar
    axis image off
    colormap jet
    title('W(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,3)
    imagesc(A_CalciumFAD_mouse,[0 1])
    colorbar
    axis image off
    colormap jet
    title('A')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,4)
    imagesc(r_CalciumFAD_mouse,[-1 1])
    colorbar
    axis image off
    colormap jet
    title('r')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,5)
    imagesc(r2_CalciumFAD_mouse,[0 1])
    colorbar
    axis image off
    colormap jet
    title('R^2')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask_new);
    set(gca,'FontSize',14,'FontWeight','Bold')

    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumFAD_GammaFit_nan.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumFAD_GammaFit_nan.fig')));
    close all

end

%% Awake
excelRows = [181 183 185 228  232  236 ];

T_CalciumFAD_mice = [];
W_CalciumFAD_mice = [];
A_CalciumFAD_mice = [];
r_CalciumFAD_mice = [];
r2_CalciumFAD_mice = [];

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
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'GammaFAD_nan','.mat');
    load(fullfile(saveDir,processedName_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse')
    T_CalciumFAD_mice = cat(3,T_CalciumFAD_mice,T_CalciumFAD_mouse);
    W_CalciumFAD_mice = cat(3,W_CalciumFAD_mice,W_CalciumFAD_mouse);
    A_CalciumFAD_mice = cat(3,A_CalciumFAD_mice,A_CalciumFAD_mouse);
    r_CalciumFAD_mice = cat(3,r_CalciumFAD_mice,r_CalciumFAD_mouse);
    r2_CalciumFAD_mice = cat(3,r2_CalciumFAD_mice,r2_CalciumFAD_mouse);
    
end
T_CalciumFAD_mice = nanmean(T_CalciumFAD_mice,3);
W_CalciumFAD_mice = nanmean(W_CalciumFAD_mice,3);
A_CalciumFAD_mice = nanmean(A_CalciumFAD_mice,3);
r_CalciumFAD_mice = nanmean(r_CalciumFAD_mice,3);
r2_CalciumFAD_mice = nanmean(r2_CalciumFAD_mice,3);

%
save_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_nan.mat';
save(fullfile('L:\RGECO\cat',save_mice),'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice','r_CalciumFAD_mice','r2_CalciumFAD_mice','-append')
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
imagesc(A_CalciumFAD_mice,[0 1])
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


%Anes
excelRows = [ 202 195 204 230 234 240];
T_CalciumFAD_mice = [];
W_CalciumFAD_mice = [];
A_CalciumFAD_mice = [];
r_CalciumFAD_mice = [];
r2_CalciumFAD_mice = [];

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
    
    
    save_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'GammaFAD_nan','.mat');
    load(fullfile(saveDir,save_mouse),'T_CalciumFAD_mouse','W_CalciumFAD_mouse','A_CalciumFAD_mouse','r_CalciumFAD_mouse','r2_CalciumFAD_mouse')
    T_CalciumFAD_mice = cat(3,T_CalciumFAD_mice,T_CalciumFAD_mouse);
    W_CalciumFAD_mice = cat(3,W_CalciumFAD_mice,W_CalciumFAD_mouse);
    A_CalciumFAD_mice = cat(3,A_CalciumFAD_mice,A_CalciumFAD_mouse);
    r_CalciumFAD_mice = cat(3,r_CalciumFAD_mice,r_CalciumFAD_mouse);
    r2_CalciumFAD_mice = cat(3,r2_CalciumFAD_mice,r2_CalciumFAD_mouse);
    
end
T_CalciumFAD_mice = nanmean(T_CalciumFAD_mice,3);
W_CalciumFAD_mice = nanmean(W_CalciumFAD_mice,3);
A_CalciumFAD_mice = nanmean(A_CalciumFAD_mice,3);
r_CalciumFAD_mice = nanmean(r_CalciumFAD_mice,3);
r2_CalciumFAD_mice = nanmean(r2_CalciumFAD_mice,3);


save_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_nan.mat';
save(fullfile('L:\RGECO\cat',save_mice),'T_CalciumFAD_mice','W_CalciumFAD_mice','A_CalciumFAD_mice','r_CalciumFAD_mice','r2_CalciumFAD_mice','-append')
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
imagesc(A_CalciumFAD_mice,[0 1])
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
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumFAD_GammaFit_nan.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumFAD_GammaFit_nan.fig')));

