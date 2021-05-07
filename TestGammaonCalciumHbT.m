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

n = 3;
visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1aCorr')

xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
Hb_filter = mouse.freq.filterData(double(xform_datahb),0.02,2,25);
Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
HbT_filter = squeeze(HbT_filter);
clear xform_datahb xform_jrgeco1aCorr

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

t = (0:750)/25;
[T,W,A,r,r2,hemoPred] = interSpeciesGammaFit_xw(Calcium_filter,HbT_filter,t);

figure
subplot(2,3,1)
imagesc(T,[0 0.6])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
%imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W,[0 2])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
%imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A,[0 4])
colorbar
axis image off
colormap jet
title('A')
hold on;
%imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
%imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
%imagesc(xform_WL,'AlphaData',1-mask_new);
set(gca,'FontSize',14,'FontWeight','Bold')
suptitle('Awake 1 run: Calcium FAD Gamma Fit with [2,3,0.0001]')

% Difference between different start position big - small



%Calculate mean and median for high value
mask_new = logical(mask_new);
mean(T(mask_new))
median(T(mask_new))

figure
histogram(T(mask_new))
title('T')
median(W(mask_new))
mean(W(mask_new))
figure
histogram(W(mask_new))
title('W')
mean(A(mask_new))
median(A(mask_new))

nanmean(r(mask_new))
nanmedian(r(mask_new))

nanmean(r2(mask_new))
nanmedian(r2(mask_new))

%Calculate mean and median for small value

