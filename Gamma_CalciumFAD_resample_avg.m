
clear all;close all;clc

sessionInfo.framerate_new =250;
time_epoch= 60;
t=0:1/sessionInfo.framerate_new:time_epoch-1/sessionInfo.framerate_new;
excelFile = "A:\XW\RGECO\DataBase_Xiaodan_2.xlsx";
excelRows = [181 202];%181
runs = 1:3;%

load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat','xform_WL')
load('C:\Users\threadripper\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat')

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionInfo.framerate = excelRaw{7};
    T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
    W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
    A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
    r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
    r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
    obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        disp(visName)
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_isbrain')
        mask = logical(mask_new.*xform_isbrain);
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_1min_smooth_Rolling_interp_CalciumFAD','.mat')),...
            'T_CalciumFAD_1min_smooth_Rolling_interp_median','W_CalciumFAD_1min_smooth_Rolling_interp_median','A_CalciumFAD_1min_smooth_Rolling_interp_median',...
            'r_CalciumFAD_1min_smooth_Rolling_interp_median','r2_CalciumFAD_1min_smooth_Rolling_interp_median','obj_CalciumFAD_1min_smooth_Rolling_interp_median')
        T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,T_CalciumFAD_1min_smooth_Rolling_interp_median);
        W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,W_CalciumFAD_1min_smooth_Rolling_interp_median);
        A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,A_CalciumFAD_1min_smooth_Rolling_interp_median);
        r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,r_CalciumFAD_1min_smooth_Rolling_interp_median);
        r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,r2_CalciumFAD_1min_smooth_Rolling_interp_median);
        obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,obj_CalciumFAD_1min_smooth_Rolling_interp_median);
    end
    T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = nanmedian(T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
    W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = nanmedian(W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
    A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = nanmedian(A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
    r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = nanmedian(r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
    r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = nanmedian(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
    obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = nanmedian(obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
    processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_interp_CalciumFAD.mat'));

    if exist(processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,'file')
        save(processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,...
            'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse',...
            'r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','-append')
    else
        save(processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,...
            'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse',...
            'r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','-v7.3')
    end

    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,3,4)
    imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[-1 1])
    colorbar
    axis image off
    colormap jet
    title('r')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,5)
    imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 1])
    colorbar
    axis image off
    colormap jet
    title('R^2')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,6)
    imagesc(obj_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,'AlphaData',mask)
    colorbar
    axis image off
    colormap jet
    title('Objective Function')
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,1)
    imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0,0.2])
    colorbar
    axis image off
    cmocean('ice')
    title('T(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 0.1])
    colorbar
    axis image off
    cmocean('ice')
    title('W(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')

    subplot(2,3,3)
    imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 0.01])
    colorbar
    axis image off
    cmocean('ice')
    title('A')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')



    sgtitle(strcat(recDate,'-',mouseName,'-CalciumFAD-GammaFit-1min-smooth-Rolling-interp'))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_interp_CalciumFAD.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_1min_smooth_Rolling_interp_CalciumFAD.fig')));
    %close all

end

%Awake
excelRows = [181,183,185,228,232,236];
T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
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
    processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_2min.mat'));
    load(fullfile(processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse',...
        'A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse')
    T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);

end
T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
%
processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice = '191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_2min.mat';
if exist(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),'file')
    save(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),...
        'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice','W_CalciumFAD_1min_smooth_Rolling_interp_median_mice','A_CalciumFAD_1min_smooth_Rolling_interp_median_mice',...
        'r_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice','-append')
else
    save(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),...
        'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice','W_CalciumFAD_1min_smooth_Rolling_interp_median_mice','A_CalciumFAD_1min_smooth_Rolling_interp_median_mice',...
        'r_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice','-v7.3')
end
mask = xform_isbrain_mice.*mask_new;
figure

subplot(2,3,4)
imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')


subplot(2,3,1)
imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0,2])
colorbar
axis image off
cmocean('ice')
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 3])
colorbar
axis image off
cmocean('ice')
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 0.07])
cb = colorbar;
set(cb,'YTick',[0 0.035 0.07]);
axis image off
cmocean('ice')
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
suptitle('Awake Calcium Total Gamma Fitting 2mins')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit_2min.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030-R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc','_CalciumHbT_GammaFit_2min.fig')));



% mask_new = logical(mask_new);
% T = median(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% W = median(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% A = median(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% r = median(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% r2 = median(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
%
%Anes
excelRows = [202,195,204,230,234,240];
T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
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

    processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min','.mat');
    load(fullfile(saveDir,processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse')
    T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
    r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);

end
T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = nanmedian(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);


processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice = '191030-R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2mins.mat';
if exist(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),'file')
    save(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),...
        'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice','W_CalciumFAD_1min_smooth_Rolling_interp_median_mice','A_CalciumFAD_1min_smooth_Rolling_interp_median_mice',...
        'r_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice','-append')
else
    save(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),...
        'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice','W_CalciumFAD_1min_smooth_Rolling_interp_median_mice','A_CalciumFAD_1min_smooth_Rolling_interp_median_mice',...
        'r_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice','-v7.3')
end

mask = xform_isbrain_mice.*mask_new;
figure

subplot(2,3,4)
imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')


subplot(2,3,1)
imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0,2])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 3])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 0.07])
cb = colorbar;
set(cb,'YTick',[0 0.035 0.07]);
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
suptitle('Anes Calcium Total Gamma Fitting 2min')
set(gca,'FontSize',14,'FontWeight','Bold')
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit_2min.png')));
saveas(gcf,fullfile('L:\RGECO\cat',strcat('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc','_CalciumHbT_GammaFit_2min.fig')));
% mask_new = logical(mask_new)
% T = median(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new));
% W = median(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% A = median(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% r = median(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
% r2 = median(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new))
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
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask_new','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%     T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
%     W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
%     A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
%     r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
%     r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
%     hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = [];
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_2min','.mat');
%         load(fullfile(saveDir,processedName),'T','W','A','r','r2','hemoPred')
%         T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,T);
%         W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,W);
%         A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,A);
%         r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,r);
%         r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(3,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,r2);
%         hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = cat(4,hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,hemoPred);
%     end
%     T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = median(T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
%     W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = median(W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
%     A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = median(A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
%     r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = median(r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
%     r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = median(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,3);
%     hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = median(hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,4);
%     processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min','.mat');
%     save(fullfile(saveDir,processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','-append')
%
%
%     figure
%     subplot(2,3,1)
%     imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0,2])
%     colorbar
%     axis image off
%     colormap jet
%     title('T(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,2)
%     imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 3])
%     colorbar
%     axis image off
%     colormap jet
%     title('W(s)')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,3)
%     imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 0.07])
%     colorbar
%     axis image off
%     colormap jet
%     title('A')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,4)
%     imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 1])
%     colorbar
%     axis image off
%     colormap jet
%     title('r')
%     hold on;
%     imagesc(xform_WL,'AlphaData',1-mask);
%     set(gca,'FontSize',14,'FontWeight','Bold')
%
%     subplot(2,3,5)
%     imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse,[0 1])
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
% T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
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
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask_new','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%
%
%     processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min','.mat');
%     load(fullfile(saveDir,processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse')
%     T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(4,hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice,hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
% end
% T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice,4);
%
% processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_2min.mat';
% save(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice','W_CalciumFAD_1min_smooth_Rolling_interp_median_mice','A_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice','hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice','-append')
%
% figure
% subplot(2,3,1)
% imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,2)
% imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,3)
% imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 0.07])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,4)
% imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,5)
% imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 1])
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
% T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
% hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice = [];
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
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask_new','.mat');
%         load(fullfile(saveDir,maskName),'xform_isbrain')
%     else
%         load(fullfile(saveDir_new,maskName),'xform_isbrain')
%     end
%
%
%     processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_2min','.mat');
%     load(fullfile(saveDir,processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mouse),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse','hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse')
%     T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,T_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,W_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,A_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(3,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,r2_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
%     hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice = cat(4,hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice,hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mouse);
% end
% T_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% W_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% A_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% r_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,3);
% hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice = median(hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice,4);
%
% processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2min.mat';
% save(fullfile('L:\RGECO\cat',processedName_CalciumFAD_1min_smooth_Rolling_interp_median_mice),'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice','W_CalciumFAD_1min_smooth_Rolling_interp_median_mice','A_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r_CalciumFAD_1min_smooth_Rolling_interp_median_mice','r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice','hemoPred_CalciumFAD_1min_smooth_Rolling_interp_median_mice','-append')
%
% figure
% subplot(2,3,1)
% imagesc(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0,2])
% colorbar
% axis image off
% colormap jet
% title('T(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,2)
% imagesc(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 3])
% colorbar
% axis image off
% colormap jet
% title('W(s)')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,3)
% imagesc(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 0.07])
% colorbar
% axis image off
% colormap jet
% title('A')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,4)
% imagesc(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 1])
% colorbar
% axis image off
% colormap jet
% title('r')
% hold on;
% imagesc(xform_WL,'AlphaData',1-mask);
% set(gca,'FontSize',14,'FontWeight','Bold')
%
% subplot(2,3,5)
% imagesc(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice,[0 1])
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
% % HbT_filter = reshape(HbT_filter,128,128,[]);
% % Calcium_filter = reshape(Calcium_filter,128,128,[]);
% %
% % for ii = 1:14999%925
% %     subplot(1,3,1)
% %     imagesc(HbT_filter(:,:,ii)*10^6,[-4 4])
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
% %     imagesc(HbT_filter(:,:,ii)*10^6 - hemoPred(:,:,ii),[-4 4])
% %     title('HbT-Predicted HbT')
% %     axis image off
% %     colorbar
% %     colormap jet
% %     pause(0.1)
% % end
% %
% % figure
% % peakMap = HbT_filter(:,:,925)*10^6;
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
% % HbT_filter = reshape(HbT_filter,128*128,[]);
% % hemoPred = reshape(hemoPred,128*128,[]);
% % iRi = reshape(ROI,128*128,1);
% %
% % HbT = squeeze(median(HbT_filter(iRi,:),1));
% % hemoPred = reshape(hemoPred,128*128,[]);
% % hemoPred_ROI = squeeze(median(hemoPred(iRi,:),1));
% %
% % figure
% % plot((1:14999)/25,HbT*10^6,'r')
% % hold on
% % plot((1:14999)/25,hemoPred,'k')
% %
% % legend('HbT','Predicted HbT')
% load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2min.mat', 'A_CalciumFAD_1min_smooth_Rolling_interp_median_mice')
% load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2min.mat', 'T_CalciumFAD_1min_smooth_Rolling_interp_median_mice')
% load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2min.mat', 'W_CalciumFAD_1min_smooth_Rolling_interp_median_mice')
% load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2min.mat', 'r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice')
% load('L:\RGECO\cat\191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_2min.mat', 'r_CalciumFAD_1min_smooth_Rolling_interp_median_mice')
% load('D:\OIS_Process\noVasculaturemask.mat')
% mask_new = leftmask+rightmask;
% mask_new = logical(mask_new);
% A_avg = median(A_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new),'All');
% r2_avg = median(r2_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new),'All');
% r_avg = median(r_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new), 'All');
% T_avg = median(T_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new), 'All');
% W_avg = median(W_CalciumFAD_1min_smooth_Rolling_interp_median_mice(mask_new), 'All');
