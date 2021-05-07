

clear all
close all
clc
excelRows = [182,184,186,229,233,237];%[203,205,231,235,241];%182,184,186,203,   excelRows =[203 231 235 241];%,203, 231, 235, 241
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;

% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     rawdataloc = excelRaw{3};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     sessionInfo.stimblocksize = excelRaw{11};
%     sessionInfo.stimbaseline=excelRaw{12};
%     sessionInfo.stimduration = excelRaw{13};
%     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
%     maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
%     if ~exist(fullfile(maskDir,maskName))
%         maskDir = saveDir;
%         maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%
%     end
%     load(fullfile(maskDir,maskName), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     for n = runs
%         naming = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_BlockPeakMap','.fig');
%         openfig(fullfile(saveDir,naming))
%         processedName=strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%     prompt = {'Good Blocks are:'};
%     title1 = 'Good Blocks';
%     dims = [1 35];
%     definput = {'1'};
%     answer = inputdlg(prompt,title1,dims,definput);
%     goodBlocks = str2num(answer{1});
%     save(fullfile(saveDir,processedName), 'goodBlocks','-append')
%
%
%     end
% end

peakMap_HbO_mice = [];
peakMap_HbR_mice = [];
peakMap_HbT_mice = [];
peakMap_FAD_mice = [];
peakMap_RawFAD_mice = [];
peakMap_calcium_mice = [];
peakMap_Rawcalcium_mice = [];

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
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
    if ~exist(fullfile(maskDir,maskName))
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        
    end
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        processedName=strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName), 'goodBlocks')
        if ~isempty(goodBlocks)
            load(fullfile(saveDir,processedName), 'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr','xform_FAD','xform_jrgeco1a')            
            xform_datahb = reshape(xform_datahb,128,128,2,[],10);
            xform_FADCorr = reshape(xform_FADCorr,128,128,[],10);
            xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],10);
            xform_FAD = reshape(xform_FAD,128,128,[],10);
            xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,[],10);
            peakFrames = sessionInfo.stimbaseline:sessionInfo.stimbaseline + sessionInfo.stimduration*sessionInfo.framerate;
            HbO = squeeze(mean(xform_datahb(:,:,1,:,goodBlocks),5));
            HbR = squeeze(mean(xform_datahb(:,:,2,:,goodBlocks),5));
            clear xform_datahb
            FAD = mean(xform_FADCorr(:,:,:,goodBlocks),4);
            clear xform_FADCorr
            RawFAD = mean(xform_FAD(:,:,:,goodBlocks),4);
            clear xform_FAD
            calcium = mean(xform_jrgeco1aCorr(:,:,:,goodBlocks),4);
            clear xform_jrgeco1aCorr
            Rawcalcium = mean(xform_jrgeco1a(:,:,:,goodBlocks),4);
            clear xform_jrgeco1a
            
            peakMap_HbO = mean(HbO(:,:,peakFrames),3);
            baseline_HbO = mean(HbO(:,:,sessionInfo.stimbaseline),3);
            peakMap_HbO = peakMap_HbO - baseline_HbO;
            
            peakMap_HbR = mean(HbR(:,:,peakFrames),3);
            baseline_HbR = mean(HbR(:,:,sessionInfo.stimbaseline),3);
            peakMap_HbR = peakMap_HbR - baseline_HbR;
            
            peakMap_HbT = peakMap_HbO + peakMap_HbR;
            baseline_HbT = baseline_HbO + baseline_HbR;
            peakMap_HbT = peakMap_HbT - baseline_HbT; 
            
            peakMap_RawFAD = mean(RawFAD(:,:,peakFrames),3);
            baseline_RawFAD = mean(RawFAD(:,:,sessionInfo.stimbaseline),3);
            peakMap_RawFAD = peakMap_RawFAD - baseline_RawFAD;
            
            peakMap_Rawcalcium = mean(Rawcalcium(:,:,peakFrames),3);
            baseline_Rawcalcium = mean(Rawcalcium(:,:,sessionInfo.stimbaseline),3);
            peakMap_Rawcalcium = peakMap_Rawcalcium - baseline_Rawcalcium;
            
            peakMap_FAD = mean(FAD(:,:,peakFrames),3);
            baseline_FAD = mean(FAD(:,:,sessionInfo.stimbaseline),3);
            peakMap_FAD = peakMap_FAD - baseline_FAD;
            
            peakMap_calcium = mean(calcium(:,:,peakFrames),3);
            baseline_calcium = mean(calcium(:,:,sessionInfo.stimbaseline),3);
            peakMap_calcium = peakMap_calcium - baseline_calcium;
            
            peakMap_HbO_mice = cat(3,peakMap_HbO_mice,peakMap_HbO);
            peakMap_HbR_mice = cat(3,peakMap_HbR_mice,peakMap_HbR);
            peakMap_HbT_mice = cat(3,peakMap_HbT_mice,peakMap_HbT);
            peakMap_FAD_mice = cat(3,peakMap_FAD_mice,peakMap_FAD);
            peakMap_calcium_mice = cat(3,peakMap_calcium_mice,peakMap_calcium);
            peakMap_RawFAD_mice = cat(3,peakMap_RawFAD_mice,peakMap_RawFAD);
            peakMap_Rawcalcium_mice = cat(3,peakMap_Rawcalcium_mice,peakMap_Rawcalcium);
            
        end
        
    end
end
peakMap_HbO_mice = mean(peakMap_HbO_mice,3)*10^6;
peakMap_HbR_mice = mean(peakMap_HbR_mice,3)*10^6;
peakMap_HbT_mice = mean(peakMap_HbT_mice,3)*10^6;
peakMap_FAD_mice = mean(peakMap_FAD_mice,3)*100;
peakMap_calcium_mice = mean(peakMap_calcium_mice,3)*100;
peakMap_RawFAD_mice = mean(peakMap_RawFAD_mice,3)*100;
peakMap_Rawcalcium_mice = mean(peakMap_Rawcalcium_mice,3)*100;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')

mask = leftMask+rightMask;
% figure
% imagesc(peakMap_HbO_mice,[-1.5,1.5])
% colormap jet
% axis image off
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-1.5,0,1.5];
% ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title('Oxy')
% 
% figure
% imagesc(peakMap_HbR_mice,[-0.5 0.5])
% colormap jet
% axis image off
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-0.5,0,0.5];
% ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title('HbR')
% 
% figure
% imagesc(peakMap_HbT_mice,[-1 1])
% colormap jet
% axis image off
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-1,0,1];
% ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title('HbT')
% 
% figure
% imagesc(peakMap_FAD_mice,[-0.6 0.6])
% colormap viridis
% axis image off
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-0.6,0,0.6];
% ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title('FAD')
% 
% 
% figure
% imagesc(peakMap_RawFAD_mice,[-0.6 0.6])
% colormap viridis
% axis image off
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-0.6,0,0.6];
% ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title(['Raw' char(10) 'FAD'])
% 
% 
% figure
% imagesc(peakMap_calcium_mice,[-1.5 1.5])
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-1.5,0,1.5];
% ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
% colormap magma
% axis image off
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title('jRGECO1a')
% 
% figure
% imagesc(peakMap_Rawcalcium_mice,[-1.5 1.5])
% h = colorbar('FontSize',15,'fontweight','bold');
% h.Ticks =  [-1.5 0 1.5];
% ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
% axis image off
% colormap magma
% axis image off
% hold on;imagesc(xform_WL,'AlphaData',1-mask);
% title(['Raw' char(10) 'jRGECO1a'])
% 
% 
% 


%
%   ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%                     max_ROI = prctile(peakMap(ROI),99);
%                     temp = double(peakMap).*double(ROI);
%                     ROI = temp>max_ROI*0.75;
%                     hold on
%                     ROI_contour = bwperim(ROI);
%                     [~,c] = contour( ROI_contour,'r');
%                     c.LineWidth = 0.001;


figure
imagesc(peakMap_HbO_mice,[-10,10])
colormap jet
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-10,0,10];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('Oxy')

figure
imagesc(peakMap_HbR_mice,[-5 5])
colormap jet
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-5,0,5];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('HbR')

figure
imagesc(peakMap_HbT_mice,[-5 5])
colormap jet
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-5,0,5];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('HbT')

figure
imagesc(peakMap_FAD_mice,[-0.6 0.6])
colormap viridis
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-0.6,0,0.6];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('FAD')


figure
imagesc(peakMap_RawFAD_mice,[-0.6 0.6])
colormap viridis
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-0.6,0,0.6];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title(['Raw' char(10) 'FAD'])


figure
imagesc(peakMap_calcium_mice,[-2 2])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-2,0,2];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
colormap magma
axis image off
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('jRGECO1a')

figure
imagesc(peakMap_Rawcalcium_mice,[-2 2])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-2 0 2];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
axis image off
colormap magma
axis image off
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title(['Raw' char(10) 'jRGECO1a'])



