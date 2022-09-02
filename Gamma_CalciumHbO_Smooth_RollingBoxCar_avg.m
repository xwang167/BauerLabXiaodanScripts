
%load('L:\RGECO\190627\190627-R5M2286-fc3_1min_smooth_Rolling.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
%load('L:\RGECO\190707\190707-R5M2286-anes-fc1_1min_smooth_Rolling.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');
clear all;close all;clc
import mouse.*
% excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% excelRows = 321:327; % excelRows_awake = [181 183 185 228  232  236 ]; excelRows_anes = [ 202 195 204 230 234 240];
% runs = 1:9;%
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232 236 202 195 204 230 234 240];
runs = 1:3;%

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')
mask = mask_new;
%
%
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
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    T_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    W_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    A_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    r_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    r2_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    hemoPred_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    obj_CalciumHbO_1min_smooth_Rolling_median_mouse = [];
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        disp(visName)
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
            'T_CalciumHbO_1min_smooth_Rolling_median','W_CalciumHbO_1min_smooth_Rolling_median','A_CalciumHbO_1min_smooth_Rolling_median',...
            'r_CalciumHbO_1min_smooth_Rolling_median','r2_CalciumHbO_1min_smooth_Rolling_median','obj_CalciumHbO_1min_smooth_Rolling_median')
        
        
        T_CalciumHbO_1min_smooth_Rolling_median_mouse = cat(3,T_CalciumHbO_1min_smooth_Rolling_median_mouse,T_CalciumHbO_1min_smooth_Rolling_median);
        W_CalciumHbO_1min_smooth_Rolling_median_mouse = cat(3,W_CalciumHbO_1min_smooth_Rolling_median_mouse,W_CalciumHbO_1min_smooth_Rolling_median);
        A_CalciumHbO_1min_smooth_Rolling_median_mouse = cat(3,A_CalciumHbO_1min_smooth_Rolling_median_mouse,A_CalciumHbO_1min_smooth_Rolling_median);
        r_CalciumHbO_1min_smooth_Rolling_median_mouse = cat(3,r_CalciumHbO_1min_smooth_Rolling_median_mouse,r_CalciumHbO_1min_smooth_Rolling_median);
        r2_CalciumHbO_1min_smooth_Rolling_median_mouse = cat(3,r2_CalciumHbO_1min_smooth_Rolling_median_mouse,r2_CalciumHbO_1min_smooth_Rolling_median);
        obj_CalciumHbO_1min_smooth_Rolling_median_mouse = cat(3,obj_CalciumHbO_1min_smooth_Rolling_median_mouse,obj_CalciumHbO_1min_smooth_Rolling_median);
        
    end
    T_CalciumHbO_1min_smooth_Rolling_median_mouse = nanmedian(T_CalciumHbO_1min_smooth_Rolling_median_mouse,3);
    W_CalciumHbO_1min_smooth_Rolling_median_mouse = nanmedian(W_CalciumHbO_1min_smooth_Rolling_median_mouse,3);
    A_CalciumHbO_1min_smooth_Rolling_median_mouse = nanmedian(A_CalciumHbO_1min_smooth_Rolling_median_mouse,3);
    r_CalciumHbO_1min_smooth_Rolling_median_mouse = nanmedian(r_CalciumHbO_1min_smooth_Rolling_median_mouse,3);
    r2_CalciumHbO_1min_smooth_Rolling_median_mouse = nanmedian(r2_CalciumHbO_1min_smooth_Rolling_median_mouse,3);
    obj_CalciumHbO_1min_smooth_Rolling_median_mouse = nanmedian(obj_CalciumHbO_1min_smooth_Rolling_median_mouse,3);
    processedName_CalciumHbO_1min_smooth_Rolling_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling.mat'));
    
    if exist(processedName_CalciumHbO_1min_smooth_Rolling_median_mouse,'file')
        save(processedName_CalciumHbO_1min_smooth_Rolling_median_mouse,...
            'T_CalciumHbO_1min_smooth_Rolling_median_mouse','W_CalciumHbO_1min_smooth_Rolling_median_mouse','A_CalciumHbO_1min_smooth_Rolling_median_mouse',...
            'r_CalciumHbO_1min_smooth_Rolling_median_mouse','r2_CalciumHbO_1min_smooth_Rolling_median_mouse','obj_CalciumHbO_1min_smooth_Rolling_median_mouse','-append')
    else
        save(processedName_CalciumHbO_1min_smooth_Rolling_median_mouse,...
            'T_CalciumHbO_1min_smooth_Rolling_median_mouse','W_CalciumHbO_1min_smooth_Rolling_median_mouse','A_CalciumHbO_1min_smooth_Rolling_median_mouse',...
            'r_CalciumHbO_1min_smooth_Rolling_median_mouse','r2_CalciumHbO_1min_smooth_Rolling_median_mouse','obj_CalciumHbO_1min_smooth_Rolling_median_mouse','-v7.3')
    end
    
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,4)
    imagesc(r_CalciumHbO_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([-1 1])
    axis image off
    colormap jet
    title('r')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,5)
    imagesc(r2_CalciumHbO_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 1])
    axis image off
    colormap jet
    title('R^2')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,6)
    imagesc(obj_CalciumHbO_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    colorbar
    axis image off
    colormap jet
    title('Objective Function')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,1)
    imagesc(T_CalciumHbO_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 2])
    axis image off
    cmocean('ice')
    title('T(s)')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W_CalciumHbO_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 3])
    axis image off
    cmocean('ice')
    title('W(s)')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,3)
    imagesc(A_CalciumHbO_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 0.2])
    axis image off
    cmocean('ice')
    title('A')
    set(gca,'FontSize',14,'FontWeight','Bold')
    sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,'-CalciumHbO-GammaFit-1min-smooth-Rolling'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbO_GammaFit_1min_smooth_Rolling.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbO_GammaFit_1min_smooth_Rolling.fig')));
    
    
    close all
    
end

%% Awake
excelRows = [181,183,185,228,232,236];
T_CalciumHbO_1min_smooth_Rolling_median_mice = [];
W_CalciumHbO_1min_smooth_Rolling_median_mice = [];
A_CalciumHbO_1min_smooth_Rolling_median_mice = [];
r_CalciumHbO_1min_smooth_Rolling_median_mice = [];
r2_CalciumHbO_1min_smooth_Rolling_median_mice = [];
obj_CalciumHbO_1min_smooth_Rolling_median_mice = [];
xform_isbrain_mice = 1;
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
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    processedName_CalciumHbO_1min_smooth_Rolling_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling.mat'));
    load(fullfile(processedName_CalciumHbO_1min_smooth_Rolling_median_mouse),'T_CalciumHbO_1min_smooth_Rolling_median_mouse','W_CalciumHbO_1min_smooth_Rolling_median_mouse',...
        'A_CalciumHbO_1min_smooth_Rolling_median_mouse','r_CalciumHbO_1min_smooth_Rolling_median_mouse','r2_CalciumHbO_1min_smooth_Rolling_median_mouse','obj_CalciumHbO_1min_smooth_Rolling_median_mouse')
    T_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,T_CalciumHbO_1min_smooth_Rolling_median_mice,T_CalciumHbO_1min_smooth_Rolling_median_mouse);
    W_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,W_CalciumHbO_1min_smooth_Rolling_median_mice,W_CalciumHbO_1min_smooth_Rolling_median_mouse);
    A_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,A_CalciumHbO_1min_smooth_Rolling_median_mice,A_CalciumHbO_1min_smooth_Rolling_median_mouse);
    r_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,r_CalciumHbO_1min_smooth_Rolling_median_mice,r_CalciumHbO_1min_smooth_Rolling_median_mouse);
    r2_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,r2_CalciumHbO_1min_smooth_Rolling_median_mice,r2_CalciumHbO_1min_smooth_Rolling_median_mouse);
    obj_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,obj_CalciumHbO_1min_smooth_Rolling_median_mice,obj_CalciumHbO_1min_smooth_Rolling_median_mouse);
end
T_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(T_CalciumHbO_1min_smooth_Rolling_median_mice,3);
W_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(W_CalciumHbO_1min_smooth_Rolling_median_mice,3);
A_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(A_CalciumHbO_1min_smooth_Rolling_median_mice,3);
r_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(r_CalciumHbO_1min_smooth_Rolling_median_mice,3);
r2_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(r2_CalciumHbO_1min_smooth_Rolling_median_mice,3);
obj_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(obj_CalciumHbO_1min_smooth_Rolling_median_mice,3);
%
processedName_CalciumHbO_1min_smooth_Rolling_median_mice = '191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling.mat';
if exist(fullfile('L:\RGECO\cat',processedName_CalciumHbO_1min_smooth_Rolling_median_mice),'file')
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbO_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbO_1min_smooth_Rolling_median_mice','W_CalciumHbO_1min_smooth_Rolling_median_mice','A_CalciumHbO_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbO_1min_smooth_Rolling_median_mice','r2_CalciumHbO_1min_smooth_Rolling_median_mice','obj_CalciumHbO_1min_smooth_Rolling_median_mice','-append')
else
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbO_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbO_1min_smooth_Rolling_median_mice','W_CalciumHbO_1min_smooth_Rolling_median_mice','A_CalciumHbO_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbO_1min_smooth_Rolling_median_mice','r2_CalciumHbO_1min_smooth_Rolling_median_mice','obj_CalciumHbO_1min_smooth_Rolling_median_mice','-v7.3')
end
mask = xform_isbrain_mice.*mask_new;
figure

subplot(2,3,4)
imagesc(r_CalciumHbO_1min_smooth_Rolling_median_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbO_1min_smooth_Rolling_median_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,6)
imagesc(obj_CalciumHbO_1min_smooth_Rolling_median_mice,'AlphaData',mask)
colorbar
axis image off
colormap jet
title('Obj')
set(gca,'FontSize',14,'FontWeight','Bold')


subplot(2,3,1)
imagesc(T_CalciumHbO_1min_smooth_Rolling_median_mice,[0,2])
colorbar
axis image off
cmocean('ice')
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbO_1min_smooth_Rolling_median_mice,[0 3])
colorbar
axis image off
cmocean('ice')
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbO_1min_smooth_Rolling_median_mice,[0 0.07])
cb = colorbar;
set(cb,'YTick',[0 0.035 0.07]);
axis image off
cmocean('ice')
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Awake Calcium HbO Gamma Fitting smooth 1min Rolling')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbO_GammaFit_1min_smooth_Rolling.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbO_GammaFit_1min_smooth_Rolling.fig')));



% mask_new = logical(mask_new);
% T = median(T_CalciumHbO_1min_smooth_Rolling_median_mice(mask_new))
% W = median(W_CalciumHbO_1min_smooth_Rolling_median_mice(mask_new))
% A = median(A_CalciumHbO_1min_smooth_Rolling_median_mice(mask_new))
% r = median(r_CalciumHbO_1min_smooth_Rolling_median_mice(mask_new))
% r2 = median(r2_CalciumHbO_1min_smooth_Rolling_median_mice(mask_new))
%
%% Anes
excelRows = [202,195,204,230,234,240];
T_CalciumHbO_1min_smooth_Rolling_median_mice = [];
W_CalciumHbO_1min_smooth_Rolling_median_mice = [];
A_CalciumHbO_1min_smooth_Rolling_median_mice = [];
r_CalciumHbO_1min_smooth_Rolling_median_mice = [];
r2_CalciumHbO_1min_smooth_Rolling_median_mice = [];
obj_CalciumHbO_1min_smooth_Rolling_median_mice = [];
xform_isbrain_mice = 1;
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
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    processedName_CalciumHbO_1min_smooth_Rolling_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling.mat'));
    load(fullfile(processedName_CalciumHbO_1min_smooth_Rolling_median_mouse),'T_CalciumHbO_1min_smooth_Rolling_median_mouse','W_CalciumHbO_1min_smooth_Rolling_median_mouse',...
        'A_CalciumHbO_1min_smooth_Rolling_median_mouse','r_CalciumHbO_1min_smooth_Rolling_median_mouse','r2_CalciumHbO_1min_smooth_Rolling_median_mouse','obj_CalciumHbO_1min_smooth_Rolling_median_mouse')
    T_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,T_CalciumHbO_1min_smooth_Rolling_median_mice,T_CalciumHbO_1min_smooth_Rolling_median_mouse);
    W_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,W_CalciumHbO_1min_smooth_Rolling_median_mice,W_CalciumHbO_1min_smooth_Rolling_median_mouse);
    A_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,A_CalciumHbO_1min_smooth_Rolling_median_mice,A_CalciumHbO_1min_smooth_Rolling_median_mouse);
    r_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,r_CalciumHbO_1min_smooth_Rolling_median_mice,r_CalciumHbO_1min_smooth_Rolling_median_mouse);
    r2_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,r2_CalciumHbO_1min_smooth_Rolling_median_mice,r2_CalciumHbO_1min_smooth_Rolling_median_mouse);
    obj_CalciumHbO_1min_smooth_Rolling_median_mice = cat(3,obj_CalciumHbO_1min_smooth_Rolling_median_mice,obj_CalciumHbO_1min_smooth_Rolling_median_mouse);
end
T_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(T_CalciumHbO_1min_smooth_Rolling_median_mice,3);
W_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(W_CalciumHbO_1min_smooth_Rolling_median_mice,3);
A_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(A_CalciumHbO_1min_smooth_Rolling_median_mice,3);
r_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(r_CalciumHbO_1min_smooth_Rolling_median_mice,3);
r2_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(r2_CalciumHbO_1min_smooth_Rolling_median_mice,3);
obj_CalciumHbO_1min_smooth_Rolling_median_mice = nanmedian(obj_CalciumHbO_1min_smooth_Rolling_median_mice,3);
%
processedName_CalciumHbO_1min_smooth_Rolling_median_mice = '191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling.mat';
if exist(fullfile('L:\RGECO\cat',processedName_CalciumHbO_1min_smooth_Rolling_median_mice),'file')
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbO_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbO_1min_smooth_Rolling_median_mice','W_CalciumHbO_1min_smooth_Rolling_median_mice','A_CalciumHbO_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbO_1min_smooth_Rolling_median_mice','r2_CalciumHbO_1min_smooth_Rolling_median_mice','obj_CalciumHbO_1min_smooth_Rolling_median_mice','-append')
else
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbO_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbO_1min_smooth_Rolling_median_mice','W_CalciumHbO_1min_smooth_Rolling_median_mice','A_CalciumHbO_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbO_1min_smooth_Rolling_median_mice','r2_CalciumHbO_1min_smooth_Rolling_median_mice','obj_CalciumHbO_1min_smooth_Rolling_median_mice','-v7.3')
end
mask = xform_isbrain_mice.*mask_new;
figure

subplot(2,3,4)
imagesc(r_CalciumHbO_1min_smooth_Rolling_median_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbO_1min_smooth_Rolling_median_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,6)
imagesc(obj_CalciumHbO_1min_smooth_Rolling_median_mice,'AlphaData',mask)
colorbar
axis image off
colormap jet
title('Obj')
set(gca,'FontSize',14,'FontWeight','Bold')


subplot(2,3,1)
imagesc(T_CalciumHbO_1min_smooth_Rolling_median_mice,[0,2])
colorbar
axis image off
cmocean('ice')
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbO_1min_smooth_Rolling_median_mice,[0 3])
colorbar
axis image off
cmocean('ice')
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbO_1min_smooth_Rolling_median_mice,[0 0.07])
cb = colorbar;
set(cb,'YTick',[0 0.035 0.07]);
axis image off
cmocean('ice')
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Anes Calcium HbO Gamma Fitting smooth 1min Rolling')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbO_GammaFit_2min.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbO_GammaFit_2min.fig')));% W = median(W_CalciumHbO_1min_smooth_Rolling_median_mice(mask_new))


%  cbh = colorbar ; %Create Colorbar
%  cbh.Ticks = [0 1 2 3] ; %Create 8 ticks from zero to 1
%  cbh.TickLabels = num2cell(0:3) ;  


%

