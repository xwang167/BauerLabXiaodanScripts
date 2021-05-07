import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRow = 183;%202
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

n = 1;
visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
load(fullfile(saveDir,processedName),'xform_FADCorr','xform_datahb')

xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;

FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
clear xform_FADCorr
Hb_filter = mouse.freq.filterData(double(xform_datahb),0.02,2,25);
clear xform_datahb
HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
HbT_filter = squeeze(HbT_filter);

       HbT_filter = reshape(HbT_filter,128*128,[]);
       FAD_filter = reshape(FAD_filter,128*128,[]);
       HbT_filter = normRow(HbT_filter);
       FAD_fitler = normRow(FAD_filter);
       HbT_filter = reshape(HbT_filter,128,128,[]);
       FAD_filter = reshape(FAD_filter,128,128,[]);

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

t = (1:750)/25;
%[T_big,W_big,A_big,r_big,r2_big,hemoPred_big] = interSpeciesGammaFit_xw(HbT_filter,FAD_filter,t);
%[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_HbTFAD(HbT_filter,FAD_filter,t);
[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(FAD_filter,HbT_filter,t);
figure
subplot(2,3,1)
imagesc(T,[0 5*10^-4])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W,[0 0.05])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A,[0 0.04])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')
suptitle('Awake 1 run: HbT FAD Gamma Fit with [3*10^-4,0.02,0.03]]')


figure
subplot(2,3,1)
imagesc(T_big,[0 5*10^-4])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_big,[0 0.05])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_big,[0 0.04])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r_big,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_big,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')
suptitle('Awake 1 run: HbT FAD Gamma Fit with [2,3,0.0001]')

% Difference between different start position big - small

figure
subplot(2,3,1)
imagesc(T_big-T,[0 5*10^-4])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_big-W,[0 0.05])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_big-A,[0 0.04])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r_big-r,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_big-r2,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')
suptitle('Difference in the location to find the minimum around')

%Calculate mean and median for high value
mask_new = logical(mask_new);
mean(T_big(mask_new))
median(T_big(mask_new))

figure
histogram(T_big(mask_new))
title('T_big')
title('T_b_i_g')
median(W_big(mask_new))
mean(W_big(mask_new))
figure
histogram(W_big(mask_new))
title('W_b_i_g')
mean(A_big(mask_new))
median(A_big(mask_new))

nanmean(r_big(mask_new))
nanmedian(r_big(mask_new))

nanmean(r2_big(mask_new))
nanmedian(r2_big(mask_new))

%Calculate mean and median for small value
mean(T(mask_new))
median(T(mask_new))

figure
histogram(T(mask_new))
title('T_s_m_a_l_l')
median(W(mask_new))
mean(W(mask_new))
figure
histogram(W(mask_new))
title('W_s_m_a_l_l')
mean(A(mask_new))
median(A(mask_new))

nanmean(r(mask_new))
nanmedian(r(mask_new))

nanmean(r2(mask_new))
nanmedian(r2(mask_new))
