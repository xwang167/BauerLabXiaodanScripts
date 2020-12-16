clear all;close all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','ROI_NoGSR')
totalBlocksNum = 0;
excelRows = [182 184 186 229 233 237];
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
    xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks = [];
    xform_FADCorr_mouse_goodBlocks = [];
    xform_FADCorr_0p7_0p8_mouse_goodBlocks = [];
    xform_FAD_mouse_goodBlocks = [];
    xform_jrgeco1aCorr_mouse_goodBlocks = [];
    xform_jrgeco1a_mouse_goodBlocks = [];
    xform_datahb_mouse_goodBlocks = [];
    
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        load(fullfile(saveDir,processedName),'goodBlocks', 'xform_FADCorr_0p7_0p8_GSR', 'xform_FADCorr_0p7_0p8',...
            'xform_FADCorr','xform_FAD','xform_jrgeco1a','xform_jrgeco1aCorr','xform_datahb')
        
        sessionInfo.stimblocksize = excelRaw{11};
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.stimduration = excelRaw{13};
        sessionInfo.stimFrequency = excelRaw{16};
        stimStartTime = 5;
        %         xform_FADCorr_0p7_0p8_GSR = mouse.process.gsr(xform_FADCorr_0p7_0p8,xform_isbrain);
        %         save(fullfile(saveDir,processedName),'xform_FADCorr_0p7_0p8_GSR','-append')
        totalBlocksNum = totalBlocksNum + sum(goodBlocks);
        goodBlocks = logical(goodBlocks);
        xform_FADCorr_0p7_0p8_GSR = reshape(xform_FADCorr_0p7_0p8_GSR,128,128,750,10);
        xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks = cat(4,xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks,xform_FADCorr_0p7_0p8_GSR(:,:,:,goodBlocks));
        clear  xform_FADCorr_0p7_0p8_GSR
        xform_FADCorr = reshape(xform_FADCorr,128,128,750,10);
        xform_FADCorr_mouse_goodBlocks = cat(4,xform_FADCorr_mouse_goodBlocks,xform_FADCorr(:,:,:,goodBlocks));
        clear xform_FADCorr
        xform_FADCorr_0p7_0p8 = reshape(xform_FADCorr_0p7_0p8,128,128,750,10);
        xform_FADCorr_0p7_0p8_mouse_goodBlocks = cat(4,xform_FADCorr_0p7_0p8_mouse_goodBlocks,xform_FADCorr_0p7_0p8(:,:,:,goodBlocks));
        clear xform_FADCorr_0p7_0p8
        xform_FAD = reshape(xform_FAD,128,128,750,10);
        xform_FAD_mouse_goodBlocks = cat(4,xform_FAD_mouse_goodBlocks,xform_FAD(:,:,:,goodBlocks));
        clear xform_FAD
        xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,750,10);
        xform_jrgeco1aCorr_mouse_goodBlocks = cat(4,xform_jrgeco1aCorr_mouse_goodBlocks,xform_jrgeco1aCorr(:,:,:,goodBlocks));
        clear xform_jrgeco1aCorr
        xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,750,10);
        xform_jrgeco1a_mouse_goodBlocks = cat(4,xform_jrgeco1a_mouse_goodBlocks,xform_jrgeco1a(:,:,:,goodBlocks));
        clear xform_jrgeco1a
        xform_datahb = reshape(xform_datahb,128,128,2,750,10);
        xform_datahb_mouse_goodBlocks = cat(5,xform_datahb_mouse_goodBlocks,xform_datahb(:,:,:,:,goodBlocks));
        
        clear xform_datahb
    end
    
    xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks = nanmean(xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks,4);
    xform_FADCorr_0p7_0p8_mouse_goodBlocks = nanmean(xform_FADCorr_0p7_0p8_mouse_goodBlocks,4);
    xform_FADCorr_mouse_goodBlocks = nanmean(xform_FADCorr_mouse_goodBlocks,4);
    xform_FAD_mouse_goodBlocks = nanmean(xform_FAD_mouse_goodBlocks,4);
    xform_jrgeco1aCorr_mouse_goodBlocks = nanmean(xform_jrgeco1aCorr_mouse_goodBlocks,4);
    xform_jrgeco1a_mouse_goodBlocks = nanmean(xform_jrgeco1a_mouse_goodBlocks,4);
    xform_datahb_mouse_goodBlocks = nanmean(xform_datahb_mouse_goodBlocks,5);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    
    save(fullfile(saveDir, processedName_mouse),'xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks',...
        'xform_FADCorr_0p7_0p8_mouse_goodBlocks','xform_FADCorr_mouse_goodBlocks',...
        'xform_FAD_mouse_goodBlocks','xform_jrgeco1aCorr_mouse_goodBlocks',...
        'xform_jrgeco1a_mouse_goodBlocks','xform_datahb_mouse_goodBlocks','-append')
    % load(fullfile(saveDir, processedName_mouse),'xform_FAD_GSR_mouse_goodBlocks','xform_jrgeco1a_GSR_mouse_goodBlocks','xform_jrgeco1aCorr_GSR_mouse_goodBlocks','xform_datahb_GSR_mouse_goodBlocks')
    
    
    if ~isnan(xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks(64,64,1))
        xform_datahb_mice_goodBlocks(:,:,:,:,ll) = xform_datahb_mouse_goodBlocks;
        xform_FAD_mice_goodBlocks(:,:,:,ll) = xform_FAD_mouse_goodBlocks;
        xform_jrgeco1a_mice_goodBlocks(:,:,:,ll) = xform_jrgeco1a_mouse_goodBlocks;
        xform_FADCorr_mice_goodBlocks(:,:,:,ll) = xform_FADCorr_mouse_goodBlocks;
        xform_jrgeco1aCorr_mice_goodBlocks(:,:,:,ll) = xform_jrgeco1aCorr_mouse_goodBlocks;
        xform_FADCorr_0p7_0p8_mice_goodBlocks(:,:,:,ll) = xform_FADCorr_0p7_0p8_mouse_goodBlocks;
        xform_FADCorr_0p7_0p8_GSR_mice_goodBlocks(:,:,:,ll) = xform_FADCorr_0p7_0p8_GSR_mouse_goodBlocks;
    end
    ll = ll+1;
end

xform_datahb_mice_goodBlocks = mean(xform_datahb_mice_goodBlocks,5);
xform_FAD_mice_goodBlocks = mean(xform_FAD_mice_goodBlocks,4);
xform_jrgeco1a_mice_goodBlocks = mean(xform_jrgeco1a_mice_goodBlocks,4);
xform_FADCorr_mice_goodBlocks = mean(xform_FADCorr_mice_goodBlocks,4);
xform_jrgeco1aCorr_mice_goodBlocks = mean(xform_jrgeco1aCorr_mice_goodBlocks,4);
xform_FADCorr_0p7_0p8_mice_goodBlocks = mean(xform_FADCorr_0p7_0p8_mice_goodBlocks,4);
xform_FADCorr_0p7_0p8_GSR_mice_goodBlocks = mean(xform_FADCorr_0p7_0p8_GSR_mice_goodBlocks,4);


save('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_datahb_mice_goodBlocks','xform_FAD_mice_goodBlocks','xform_jrgeco1a_mice_goodBlocks',...
    'xform_FADCorr_mice_goodBlocks','xform_jrgeco1aCorr_mice_goodBlocks',...
    'xform_FADCorr_0p7_0p8_mice_goodBlocks','xform_FADCorr_0p7_0p8_GSR_mice_goodBlocks','-append')

load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_datahb_GSR_mice_goodBlocks','xform_FAD_GSR_mice_goodBlocks','xform_jrgeco1a_GSR_mice_goodBlocks',...
    'xform_FADCorr_GSR_mice_goodBlocks','xform_jrgeco1aCorr_GSR_mice_goodBlocks',...
    'xform_FADCorr_GSR_mice_goodBlocks','xform_FADCorr_0p7_0p8_GSR_mice_goodBlocks')
load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'xform_jrgeco1aCorr_GSR_mice_goodBlocks','xform_isbrain_mice')
%jrgeco1aCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_GSR)/0.01,sessionInfo.framerate,[1,4]);
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')

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
figure
imagesc(peakMap_localMax.*xform_isbrain_mice*100,[-3 3])
hold on
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
barrel = AtlasSeeds == 9;
ROI_barrel =  bwperim(barrel);
contour(ROI_barrel,'k')
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)
h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);axis image off
title('RGECOCorr only peaks')
colormap jet

[x1,y1] = ginput(1);

[x2,y2] = ginput(1);

[X,Y] = meshgrid(1:128,1:128);

radius = sqrt((x1-x2)^2+(y1-y2)^2);

ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;

max_ROI = prctile(peakMap_localMax(ROI),99);

temp = peakMap_localMax.*ROI;

ROI = temp>0.75*max_ROI;


hold on
contour(ROI)


peakMap = mean(xform_FADCorr_GSR_mice_goodBlocks(:,:,126:250),3);
figure
imagesc(peakMap.*xform_isbrain_mice*100,[-0.9,0.9])
hold on
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
barrel = AtlasSeeds == 9;
ROI_barrel =  bwperim(barrel);
contour(ROI_barrel,'k')
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)

h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
colormap jet
axis image off
title('FADCorr  from 5s to 10s')

peakMap = mean(xform_FADCorr_0p7_0p8_GSR_mice_goodBlocks(:,:,126:250),3);
figure
imagesc(peakMap.*xform_isbrain_mice*100,[-0.5,0.5])
hold on
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
barrel = AtlasSeeds == 9;
ROI_barrel =  bwperim(barrel);
contour(ROI_barrel,'k')
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)

h = colorbar;
ylabel(h,'\DeltaF/F%','FontSize',12);
colormap jet
axis image off
title('FADCorr alpha = 0.7 beta = 0.8 from 5s to 10s')



% peakMap = mean(xform_datahb_GSR_mice_goodBlocks(:,:,1,126:250)*10^6,4);
% figure
% imagesc(peakMap.*xform_isbrain_mice,[-1,1])
% hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)
% h = colorbar;
% ylabel(h,'\muM','FontSize',12);
% colormap jet
% axis image off
% title('Oxy from 5s to 10s')
%
% peakMap = mean(xform_datahb_GSR_mice_goodBlocks(:,:,2,126:250)*10^6,4);
% figure
% imagesc(peakMap.*xform_isbrain_mice,[-0.4,0.4])
% hold on
%     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)
% h = colorbar;
% ylabel(h,'\muM','FontSize',12);
% colormap jet
% axis image off
% title('DeOxy from 5s to 10s')

peakMap = mean(xform_datahb_GSR_mice_goodBlocks(:,:,1,126:250)*10^6+xform_datahb_GSR_mice_goodBlocks(:,:,2,126:250)*10^6,4);
figure
imagesc(peakMap.*xform_isbrain_mice,[-0.8,0.8])
hold on
barrel = AtlasSeeds == 9;
ROI_barrel =  bwperim(barrel);
contour(ROI_barrel,'k')

hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice.*mask)


h = colorbar;
ylabel(h,'\muM','FontSize',12);
colormap jet
axis image off
title('HbT from 5s to 10s')

mouseName = excelRaw{2}; mouseName = string(mouseName);
saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
sessionInfo.darkFrameNum = excelRaw{15};
sessionInfo.mouseType = excelRaw{17};
systemType =excelRaw{5};
maskDir_new = saveDir;
rawdataloc = excelRaw{3};
maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
sessionInfo.stimblocksize = excelRaw{11};
sessionInfo.stimbaseline=excelRaw{12};
sessionInfo.stimduration = excelRaw{13};
sessionInfo.stimFrequency = excelRaw{16};
stimStartTime = 5;
info.freqout=1;

      
                    numBlock = size(xform_datahb_mice_goodBlocks,4)/sessionInfo.stimblocksize;
                    numDesample = size(xform_datahb_mice_goodBlocks,4)/sessionInfo.framerate*info.freqout;
                    factor = round(numDesample/numBlock);
                    numDesample = factor*numBlock;

disp('loading Non GRS data')
texttitle_NoGSR = strcat('Awake-RGECO-stim without GSR nor filtering, FAD 0.7 0.8');
output_NoGSR= fullfile(saveDir,strcat(recDate,'-Awake RGECO','-stim-NoGSR_FAD_0p7_0p8'));

QC_stim(squeeze(xform_datahb_mice_goodBlocks(:,:,1,:))*10^6,squeeze(xform_datahb_mice_goodBlocks(:,:,2,:))*10^6,...
    xform_FAD_mice_goodBlocks*100,xform_FADCorr_0p7_0p8_mice_goodBlocks*100,ones(128,128,750),xform_jrgeco1a_mice_goodBlocks*100,xform_jrgeco1aCorr_mice_goodBlocks*100,ones(128,128,750),...
    xform_isbrain_mice,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI,1);

title('Awake-RGECO-stim without GSR nor filtering')