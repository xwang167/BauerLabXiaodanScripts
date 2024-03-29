
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
    T_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    W_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    A_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    r_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    r2_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    hemoPred_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    obj_CalciumHbT_1min_smooth_Rolling_median_mouse = [];
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        disp(visName)
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling','.mat')),...
            'T_CalciumHbT_1min_smooth_Rolling_median','W_CalciumHbT_1min_smooth_Rolling_median','A_CalciumHbT_1min_smooth_Rolling_median',...
            'r_CalciumHbT_1min_smooth_Rolling_median','r2_CalciumHbT_1min_smooth_Rolling_median','obj_CalciumHbT_1min_smooth_Rolling_median')
        
        
        T_CalciumHbT_1min_smooth_Rolling_median_mouse = cat(3,T_CalciumHbT_1min_smooth_Rolling_median_mouse,T_CalciumHbT_1min_smooth_Rolling_median);
        W_CalciumHbT_1min_smooth_Rolling_median_mouse = cat(3,W_CalciumHbT_1min_smooth_Rolling_median_mouse,W_CalciumHbT_1min_smooth_Rolling_median);
        A_CalciumHbT_1min_smooth_Rolling_median_mouse = cat(3,A_CalciumHbT_1min_smooth_Rolling_median_mouse,A_CalciumHbT_1min_smooth_Rolling_median);
        r_CalciumHbT_1min_smooth_Rolling_median_mouse = cat(3,r_CalciumHbT_1min_smooth_Rolling_median_mouse,r_CalciumHbT_1min_smooth_Rolling_median);
        r2_CalciumHbT_1min_smooth_Rolling_median_mouse = cat(3,r2_CalciumHbT_1min_smooth_Rolling_median_mouse,r2_CalciumHbT_1min_smooth_Rolling_median);
        obj_CalciumHbT_1min_smooth_Rolling_median_mouse = cat(3,obj_CalciumHbT_1min_smooth_Rolling_median_mouse,obj_CalciumHbT_1min_smooth_Rolling_median);
        
    end
    T_CalciumHbT_1min_smooth_Rolling_median_mouse = nanmedian(T_CalciumHbT_1min_smooth_Rolling_median_mouse,3);
    W_CalciumHbT_1min_smooth_Rolling_median_mouse = nanmedian(W_CalciumHbT_1min_smooth_Rolling_median_mouse,3);
    A_CalciumHbT_1min_smooth_Rolling_median_mouse = nanmedian(A_CalciumHbT_1min_smooth_Rolling_median_mouse,3);
    r_CalciumHbT_1min_smooth_Rolling_median_mouse = nanmedian(r_CalciumHbT_1min_smooth_Rolling_median_mouse,3);
    r2_CalciumHbT_1min_smooth_Rolling_median_mouse = nanmedian(r2_CalciumHbT_1min_smooth_Rolling_median_mouse,3);
    obj_CalciumHbT_1min_smooth_Rolling_median_mouse = nanmedian(obj_CalciumHbT_1min_smooth_Rolling_median_mouse,3);
    processedName_CalciumHbT_1min_smooth_Rolling_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling.mat'));
    
    if exist(processedName_CalciumHbT_1min_smooth_Rolling_median_mouse,'file')
        save(processedName_CalciumHbT_1min_smooth_Rolling_median_mouse,...
            'T_CalciumHbT_1min_smooth_Rolling_median_mouse','W_CalciumHbT_1min_smooth_Rolling_median_mouse','A_CalciumHbT_1min_smooth_Rolling_median_mouse',...
            'r_CalciumHbT_1min_smooth_Rolling_median_mouse','r2_CalciumHbT_1min_smooth_Rolling_median_mouse','obj_CalciumHbT_1min_smooth_Rolling_median_mouse','-append')
    else
        save(processedName_CalciumHbT_1min_smooth_Rolling_median_mouse,...
            'T_CalciumHbT_1min_smooth_Rolling_median_mouse','W_CalciumHbT_1min_smooth_Rolling_median_mouse','A_CalciumHbT_1min_smooth_Rolling_median_mouse',...
            'r_CalciumHbT_1min_smooth_Rolling_median_mouse','r2_CalciumHbT_1min_smooth_Rolling_median_mouse','obj_CalciumHbT_1min_smooth_Rolling_median_mouse','-v7.3')
    end
    
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,4)
    imagesc(r_CalciumHbT_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([-1 1])
    axis image off
    colormap jet
    title('r')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,5)
    imagesc(r2_CalciumHbT_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 1])
    axis image off
    colormap jet
    title('R^2')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,6)
    imagesc(obj_CalciumHbT_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    colorbar
    axis image off
    colormap jet
    title('Objective Function')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,1)
    imagesc(T_CalciumHbT_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 2])
    axis image off
    cmocean('ice')
    title('T(s)')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W_CalciumHbT_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 3])
    axis image off
    cmocean('ice')
    title('W(s)')
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,3)
    imagesc(A_CalciumHbT_1min_smooth_Rolling_median_mouse,'AlphaData',mask)
    cb=colorbar;
    caxis([0 0.2])
    axis image off
    cmocean('ice')
    title('A')
    set(gca,'FontSize',14,'FontWeight','Bold')
    sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,'-CalciumHbT-GammaFit-1min-smooth-Rolling'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit_1min_smooth_Rolling.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_CalciumHbT_GammaFit_1min_smooth_Rolling.fig')));
    
    
    close all
    
end

%% Awake
excelRows = [181,183,185,228,232,236];
T_CalciumHbT_1min_smooth_Rolling_median_mice = [];
W_CalciumHbT_1min_smooth_Rolling_median_mice = [];
A_CalciumHbT_1min_smooth_Rolling_median_mice = [];
r_CalciumHbT_1min_smooth_Rolling_median_mice = [];
r2_CalciumHbT_1min_smooth_Rolling_median_mice = [];
obj_CalciumHbT_1min_smooth_Rolling_median_mice = [];
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
    processedName_CalciumHbT_1min_smooth_Rolling_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling.mat'));
    load(fullfile(processedName_CalciumHbT_1min_smooth_Rolling_median_mouse),'T_CalciumHbT_1min_smooth_Rolling_median_mouse','W_CalciumHbT_1min_smooth_Rolling_median_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_median_mouse','r_CalciumHbT_1min_smooth_Rolling_median_mouse','r2_CalciumHbT_1min_smooth_Rolling_median_mouse','obj_CalciumHbT_1min_smooth_Rolling_median_mouse')
    T_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,T_CalciumHbT_1min_smooth_Rolling_median_mice,T_CalciumHbT_1min_smooth_Rolling_median_mouse);
    W_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,W_CalciumHbT_1min_smooth_Rolling_median_mice,W_CalciumHbT_1min_smooth_Rolling_median_mouse);
    A_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,A_CalciumHbT_1min_smooth_Rolling_median_mice,A_CalciumHbT_1min_smooth_Rolling_median_mouse);
    r_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,r_CalciumHbT_1min_smooth_Rolling_median_mice,r_CalciumHbT_1min_smooth_Rolling_median_mouse);
    r2_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,r2_CalciumHbT_1min_smooth_Rolling_median_mice,r2_CalciumHbT_1min_smooth_Rolling_median_mouse);
    obj_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,obj_CalciumHbT_1min_smooth_Rolling_median_mice,obj_CalciumHbT_1min_smooth_Rolling_median_mouse);
end
T_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(T_CalciumHbT_1min_smooth_Rolling_median_mice,3);
W_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(W_CalciumHbT_1min_smooth_Rolling_median_mice,3);
A_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(A_CalciumHbT_1min_smooth_Rolling_median_mice,3);
r_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(r_CalciumHbT_1min_smooth_Rolling_median_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(r2_CalciumHbT_1min_smooth_Rolling_median_mice,3);
obj_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(obj_CalciumHbT_1min_smooth_Rolling_median_mice,3);
%
processedName_CalciumHbT_1min_smooth_Rolling_median_mice = '191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling.mat';
if exist(fullfile('L:\RGECO\cat',processedName_CalciumHbT_1min_smooth_Rolling_median_mice),'file')
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbT_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbT_1min_smooth_Rolling_median_mice','W_CalciumHbT_1min_smooth_Rolling_median_mice','A_CalciumHbT_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbT_1min_smooth_Rolling_median_mice','r2_CalciumHbT_1min_smooth_Rolling_median_mice','obj_CalciumHbT_1min_smooth_Rolling_median_mice','-append')
else
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbT_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbT_1min_smooth_Rolling_median_mice','W_CalciumHbT_1min_smooth_Rolling_median_mice','A_CalciumHbT_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbT_1min_smooth_Rolling_median_mice','r2_CalciumHbT_1min_smooth_Rolling_median_mice','obj_CalciumHbT_1min_smooth_Rolling_median_mice','-v7.3')
end
mask = xform_isbrain_mice.*mask_new;
figure

subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_median_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_median_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,6)
imagesc(obj_CalciumHbT_1min_smooth_Rolling_median_mice,'AlphaData',mask)
colorbar
axis image off
colormap jet
title('Obj')
set(gca,'FontSize',14,'FontWeight','Bold')


subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_median_mice,[0,2])
colorbar
axis image off
cmocean('ice')
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_median_mice,[0 3])
colorbar
axis image off
cmocean('ice')
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_median_mice,[0 0.3])
cb = colorbar;
set(cb,'YTick',[0 0.15 0.3]);
axis image off
cmocean('ice')
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Awake Calcium Total Gamma Fitting smooth 1min Rolling')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit_1min_smooth_Rolling.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit_1min_smooth_Rolling.fig')));


time_epoch=30;
t=linspace(0,time_epoch,time_epoch*sessionInfo.framerate);%% force it to be 5 hz
mask_new = logical(mask_new);
T_awake = median(T_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new));
W_awake = median(W_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new));
A_awake = median(A_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new));

alpha_awake = (T_awake/W_awake)^2*8*log(2);
beta_awake = W_awake^2/(T_awake*8*log(2));
y_awake = A_awake*(t/T_awake).^alpha_awake.*exp((t-T_awake)/(-beta_awake));

% r = median(r_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new))
% r2 = median(r2_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new))
%
%% Anes
excelRows = [202,195,204,230,234,240];
T_CalciumHbT_1min_smooth_Rolling_median_mice = [];
W_CalciumHbT_1min_smooth_Rolling_median_mice = [];
A_CalciumHbT_1min_smooth_Rolling_median_mice = [];
r_CalciumHbT_1min_smooth_Rolling_median_mice = [];
r2_CalciumHbT_1min_smooth_Rolling_median_mice = [];
obj_CalciumHbT_1min_smooth_Rolling_median_mice = [];
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
    processedName_CalciumHbT_1min_smooth_Rolling_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling.mat'));
    load(fullfile(processedName_CalciumHbT_1min_smooth_Rolling_median_mouse),'T_CalciumHbT_1min_smooth_Rolling_median_mouse','W_CalciumHbT_1min_smooth_Rolling_median_mouse',...
        'A_CalciumHbT_1min_smooth_Rolling_median_mouse','r_CalciumHbT_1min_smooth_Rolling_median_mouse','r2_CalciumHbT_1min_smooth_Rolling_median_mouse','obj_CalciumHbT_1min_smooth_Rolling_median_mouse')
    T_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,T_CalciumHbT_1min_smooth_Rolling_median_mice,T_CalciumHbT_1min_smooth_Rolling_median_mouse);
    W_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,W_CalciumHbT_1min_smooth_Rolling_median_mice,W_CalciumHbT_1min_smooth_Rolling_median_mouse);
    A_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,A_CalciumHbT_1min_smooth_Rolling_median_mice,A_CalciumHbT_1min_smooth_Rolling_median_mouse);
    r_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,r_CalciumHbT_1min_smooth_Rolling_median_mice,r_CalciumHbT_1min_smooth_Rolling_median_mouse);
    r2_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,r2_CalciumHbT_1min_smooth_Rolling_median_mice,r2_CalciumHbT_1min_smooth_Rolling_median_mouse);
    obj_CalciumHbT_1min_smooth_Rolling_median_mice = cat(3,obj_CalciumHbT_1min_smooth_Rolling_median_mice,obj_CalciumHbT_1min_smooth_Rolling_median_mouse);
end
T_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(T_CalciumHbT_1min_smooth_Rolling_median_mice,3);
W_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(W_CalciumHbT_1min_smooth_Rolling_median_mice,3);
A_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(A_CalciumHbT_1min_smooth_Rolling_median_mice,3);
r_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(r_CalciumHbT_1min_smooth_Rolling_median_mice,3);
r2_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(r2_CalciumHbT_1min_smooth_Rolling_median_mice,3);
obj_CalciumHbT_1min_smooth_Rolling_median_mice = nanmedian(obj_CalciumHbT_1min_smooth_Rolling_median_mice,3);
%
processedName_CalciumHbT_1min_smooth_Rolling_median_mice = '191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_1min_smooth_Rolling.mat';
if exist(fullfile('L:\RGECO\cat',processedName_CalciumHbT_1min_smooth_Rolling_median_mice),'file')
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbT_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbT_1min_smooth_Rolling_median_mice','W_CalciumHbT_1min_smooth_Rolling_median_mice','A_CalciumHbT_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbT_1min_smooth_Rolling_median_mice','r2_CalciumHbT_1min_smooth_Rolling_median_mice','obj_CalciumHbT_1min_smooth_Rolling_median_mice','-append')
else
    save(fullfile('L:\RGECO\cat',processedName_CalciumHbT_1min_smooth_Rolling_median_mice),...
        'T_CalciumHbT_1min_smooth_Rolling_median_mice','W_CalciumHbT_1min_smooth_Rolling_median_mice','A_CalciumHbT_1min_smooth_Rolling_median_mice',...
        'r_CalciumHbT_1min_smooth_Rolling_median_mice','r2_CalciumHbT_1min_smooth_Rolling_median_mice','obj_CalciumHbT_1min_smooth_Rolling_median_mice','-v7.3')
end
mask = xform_isbrain_mice.*mask_new;
figure

subplot(2,3,4)
imagesc(r_CalciumHbT_1min_smooth_Rolling_median_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumHbT_1min_smooth_Rolling_median_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,6)
imagesc(obj_CalciumHbT_1min_smooth_Rolling_median_mice,'AlphaData',mask)
colorbar
axis image off
colormap jet
title('Obj')
set(gca,'FontSize',14,'FontWeight','Bold')


subplot(2,3,1)
imagesc(T_CalciumHbT_1min_smooth_Rolling_median_mice,[0,2])
colorbar
axis image off
cmocean('ice')
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumHbT_1min_smooth_Rolling_median_mice,[0 3])
colorbar
axis image off
cmocean('ice')
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumHbT_1min_smooth_Rolling_median_mice,[0 0.3])
cb = colorbar;
set(cb,'YTick',[0 0.15 0.3]);
axis image off
cmocean('ice')
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('Anes Calcium Total Gamma Fitting smooth 1min Rolling')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit_2min.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit_2min.fig')));% W = median(W_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new))


%  cbh = colorbar ; %Create Colorbar
%  cbh.Ticks = [0 1 2 3] ; %Create 8 ticks from zero to 1
%  cbh.TickLabels = num2cell(0:3) ;
mask_new = logical(mask_new);
T_anes = median(T_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new));
W_anes = median(W_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new));
A_anes = median(A_CalciumHbT_1min_smooth_Rolling_median_mice(mask_new));

alpha_anes = (T_anes/W_anes)^2*8*log(2);
beta_anes = W_anes^2/(T_anes*8*log(2));
y_anes = A_anes*(t/T_anes).^alpha_anes.*exp((t-T_anes)/(-beta_anes));

figure
plot(t,y_awake,'k-')
hold on
plot(t,y_anes,'k--')
xlim([0 10])
xlabel('Time(s)')
ylabel('Amplitude a.u.')
legend('Awake','Anesthetized')
title('Gamma Variate Fitting Function between Calcium and HbT')