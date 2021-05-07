clear all;close all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','ROI_NoGSR')
totalBlocksNum = 0;
excelRows = [182 184 186 229 233];%
ll = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    %     maskName_new = strcat(recDate,'-N8M864-1hz-opto3-LandmarksAndMask','.mat');
    %     %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %     %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %     load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    %     xform_isbrain = double(xform_isbrain);
    %     if ~isempty(find(isnan(xform_isbrain), 1))
    %         xform_isbrain(isnan(xform_isbrain))=0;
    %     end
%     xform_datahb_GSR_mouse_goodBlocks = [];
%     xform_FAD_GSR_mouse_goodBlocks = [];
%     xform_FADCorr_GSR_mouse_goodBlocks = [];
%     xform_jrgeco1a_GSR_mouse_goodBlocks = [];
%     xform_jrgeco1aCorr_GSR_mouse_goodBlocks = [];
%     for n = runs
%         goodBlocks = ones(1,10);
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         try
%             load(fullfile(saveDir,processedName), 'xform_FADCorr_GSR','goodBlocks')
%             
%             %             sessionInfo.stimblocksize = excelRaw{11};
%             sessionInfo.stimbaseline=excelRaw{12};
%             sessionInfo.stimduration = excelRaw{13};
%             sessionInfo.stimFrequency = excelRaw{16};
%             stimStartTime = 5;
%             
%             totalBlocksNum = totalBlocksNum + sum(goodBlocks);
%             goodBlocks = logical(goodBlocks);
%             xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,750,10);
%             xform_FADCorr_GSR_mouse_goodBlocks = cat(4,xform_FADCorr_GSR_mouse_goodBlocks,xform_FADCorr_GSR(:,:,:,goodBlocks));
%             
%         catch
%             disp(['Did not load file',processedName]);
%         end
%     end
%     
%     xform_FADCorr_GSR_mouse_goodBlocks = nanmean(xform_FADCorr_GSR_mouse_goodBlocks,4);
%     
   processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
%     
%     save(fullfile(saveDir, processedName_mouse),'xform_FADCorr_GSR_mouse_goodBlocks','-append')
    load(fullfile(saveDir, processedName_mouse),'xform_FAD_GSR_mouse_goodBlocks','xform_FADCorr_GSR_mouse_goodBlocks','xform_jrgeco1a_GSR_mouse_goodBlocks','xform_jrgeco1aCorr_GSR_mouse_goodBlocks','xform_datahb_GSR_mouse_goodBlocks')
    
    
    if ~isnan(xform_FADCorr_GSR_mouse_goodBlocks(64,64,1,1))
        xform_datahb_GSR_mice_goodBlocks(:,:,:,:,ll) = xform_datahb_GSR_mouse_goodBlocks;
        xform_FAD_GSR_mice_goodBlocks(:,:,:,ll) = xform_FAD_GSR_mouse_goodBlocks;
        xform_jrgeco1a_GSR_mice_goodBlocks(:,:,:,ll) = xform_jrgeco1a_GSR_mouse_goodBlocks;
        xform_FADCorr_GSR_mice_goodBlocks(:,:,:,ll) = xform_FADCorr_GSR_mouse_goodBlocks;
        xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,:,ll) = xform_jrgeco1aCorr_GSR_mouse_goodBlocks;
    end
    ll = ll+1;
end



xform_datahb_GSR_mice_goodBlocks = mean(xform_datahb_GSR_mice_goodBlocks,5);
xform_FAD_GSR_mice_goodBlocks = mean(xform_FAD_GSR_mice_goodBlocks,4);
xform_jrgeco1a_GSR_mice_goodBlocks = mean(xform_jrgeco1a_GSR_mice_goodBlocks,4);
xform_FADCorr_GSR_mice_goodBlocks = mean(xform_FADCorr_GSR_mice_goodBlocks,4);
xform_jrgeco1aCorr_GSR_mice_goodBlocks = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks,4);
% save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
%     'xform_FADCorr_GSR_mice_goodBlocks','-append')
% load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
%     'xform_datahb_GSR_mice_goodBlocks','xform_FADCorr_GSR_mice_goodBlocks',...
%     'xform_FAD_GSR_mice_goodBlocks','xform_jrgeco1a_GSR_mice_goodBlocks',...
%     'xform_jrgeco1aCorr_GSR_mice_goodBlocks','xform_isbrain_mice')
%jrgeco1aCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_GSR)/0.01,sessionInfo.framerate,[1,4]);
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_isbrain_mice')
mask = double(leftMask)+double(rightMask);
xform_jrgeco1aCorr_GSR_mice_goodBlocks = reshape(xform_jrgeco1aCorr_GSR_mice_goodBlocks,[],750);
timetrace = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(ROI_NoGSR,:),1);
baseline = mean(timetrace(1:125));
timetrace = timetrace-baseline;
TF = islocalmax(timetrace);
TF(1:125) = 0;
TF(251:end) = 0;
figure
time = (1:750)/25;
plot(time, timetrace)
hold on
plot(time,TF/30)

xform_jrgeco1aCorr_GSR_mice_goodBlocks = reshape(xform_jrgeco1aCorr_GSR_mice_goodBlocks,128,128,[]);
peakMap_localMax = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,TF),3);
baseline =  mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,1:125),3);
peakMap_localMax = peakMap_localMax - baseline;
figure
imagesc(peakMap_localMax.*xform_isbrain_mice*100,[-2 2])

hold on
imagesc(xform_WL,'AlphaData', 1-xform_isbrain_mice.*mask)

h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1.5 0 1.5];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
axis image off
colormap magma
title(['jRGECO1a'])

% peakMap = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(:,:,126:250),3);
% figure
% imagesc(peakMap.*xform_isbrain_mice*100,[-2,2])
% hold on
% load('D:\OIS_Process\atlas.mat','AtlasSeeds')
% barrel = AtlasSeeds == 9;
% ROI_barrel =  bwperim(barrel);
% contour(ROI_barrel,'k')
% hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)
% h = colorbar;
% ylabel(h,'\DeltaF/F%','FontSize',12);
% colormap jet
% axis image off
% title('RGECOCorr from 5s to 10s')

xform_jrgeco1a_GSR_mice_goodBlocks = reshape(xform_jrgeco1a_GSR_mice_goodBlocks,128,128,[]);
peakMap_localMax = mean(xform_jrgeco1a_GSR_mice_goodBlocks(:,:,TF),3);
baseline = mean(xform_jrgeco1a_GSR_mice_goodBlocks(:,:,1:125),3);
peakMap_localMax = peakMap_localMax - baseline;
figure
imagesc(peakMap_localMax.*xform_isbrain_mice*100,[-1 1])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1.5,0,1.5];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');

% hold on
% load('D:\OIS_Process\atlas.mat','AtlasSeeds')
% barrel = AtlasSeeds == 9;
% ROI_barrel =  bwperim(barrel);
% contour(ROI_barrel,'k')
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)


axis image off
title(['Raw' char(10) 'jRGECO1a'])
colormap magma


% peakMap = mean(xform_jrgeco1a_GSR_mice_goodBlocks(:,:,126:250),3);
% figure
% imagesc(peakMap.*xform_isbrain_mice*100,[-1.2,1.2])
% % hold on
% % load('D:\OIS_Process\atlas.mat','AtlasSeeds')
% % barrel = AtlasSeeds == 9;
% % ROI_barrel =  bwperim(barrel);
% % contour(ROI_barrel,'k')
% hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)
%
% h = colorbar;
% ylabel(h,'\DeltaF/F%','FontSize',12);
% colormap jet
% axis image off
% title('RGECO from 5s to 10s')

peakMap = mean(xform_FADCorr_GSR_mice_goodBlocks(:,:,126:250),3);
baseline = mean(xform_FADCorr_GSR_mice_goodBlocks(:,:,1:125),3);
peakMap = peakMap - baseline;
figure
imagesc(peakMap.*xform_isbrain_mice*100,[-0.7,0.7])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-0.6,0,0.6];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
hold on
imagesc(xform_WL,'AlphaData', 1-xform_isbrain_mice.*mask)
colormap viridis
axis image off
title('FAD')

peakMap = mean(xform_FAD_GSR_mice_goodBlocks(:,:,126:250),3);
baseline = mean(xform_FAD_GSR_mice_goodBlocks(:,:,1:125),3);
peakMap = peakMap-baseline;
figure
imagesc(peakMap.*xform_isbrain_mice*100,[-0.7,0.7])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-0.6,0,0.6];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
% hold on
% load('D:\OIS_Process\atlas.mat','AtlasSeeds')
% barrel = AtlasSeeds == 9;
% ROI_barrel =  bwperim(barrel);
% contour(ROI_barrel,'k')
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)

colormap viridis
axis image off
title(['Raw' char(10) 'FAD'])
%
peakMap = mean(xform_datahb_GSR_mice_goodBlocks(:,:,1,126:250)*10^6,4);
baseline = mean(xform_datahb_GSR_mice_goodBlocks(:,:,1,1:125)*10^6,4);
peakMap = peakMap - baseline;
figure
imagesc(peakMap.*xform_isbrain_mice,[-3,3])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-2.5,0,2.5];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)

colormap jet
axis image off
title('Oxy from 5s to 10s')

peakMap = mean(xform_datahb_GSR_mice_goodBlocks(:,:,2,126:250)*10^6,4);
baseline = mean(xform_datahb_GSR_mice_goodBlocks(:,:,2,1:125)*10^6,4);
peakMap = peakMap-baseline;
figure
imagesc(peakMap.*xform_isbrain_mice,[-1,1])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1,0,1];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)

colormap jet
axis image off
title('DeOxy from 5s to 10s')

peakMap = mean(xform_datahb_GSR_mice_goodBlocks(:,:,1,126:250)*10^6+xform_datahb_GSR_mice_goodBlocks(:,:,2,126:250)*10^6,4);
baseline = mean(xform_datahb_GSR_mice_goodBlocks(:,:,1,1:125)*10^6+xform_datahb_GSR_mice_goodBlocks(:,:,2,1:125)*10^6,4);
peakMap = peakMap-baseline;
figure
imagesc(peakMap.*xform_isbrain_mice,[-2,2])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-2,0,2];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
% hold on
% barrel = AtlasSeeds == 9;
% ROI_barrel =  bwperim(barrel);
% contour(ROI_barrel,'k')

hold on
imagesc(xform_WL,'AlphaData', 1-xform_isbrain_mice.*mask)


colormap jet
axis image off
title([' ' char(10) 'HbT'])

