

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
%         naming = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_GSR_BlockPeakMap','.fig');
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
         load(fullfile(saveDir,processedName), 'xform_datahb_GSR','xform_FADCorr_GSR','xform_jrgeco1aCorr_GSR','xform_FAD_GSR','xform_jrgeco1a_GSR')
       
        xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],10);
        xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,[],10);
        xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],10);
                xform_FAD_GSR = reshape(xform_FAD_GSR,128,128,[],10);
        xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],10);
        peakFrames = sessionInfo.stimbaseline:sessionInfo.stimbaseline + sessionInfo.stimduration*sessionInfo.framerate;
        peakMap_HbO = squeeze(mean(xform_datahb_GSR(:,:,1,:,goodBlocks),5));
        peakMap_HbR = squeeze(mean(xform_datahb_GSR(:,:,2,:,goodBlocks),5));
        clear xform_datahb_GSR
        peakMap_HbT = peakMap_HbO + peakMap_HbR;
        peakMap_FAD = mean(xform_FADCorr_GSR(:,:,:,goodBlocks),4);
        clear xform_FADCorr_GSR
        peakMap_RawFAD = mean(xform_FAD_GSR(:,:,:,goodBlocks),4);
        clear xform_FAD_GSR
        peakMap_calcium = mean(xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks),4);
        clear xform_jrgeco1aCorr_GSR
          peakMap_Rawcalcium = mean(xform_jrgeco1a_GSR(:,:,:,goodBlocks),4);
        clear xform_jrgeco1a_GSR
        peakMap_HbO = mean(peakMap_HbO(:,:,peakFrames),3);
        peakMap_HbR = mean(peakMap_HbR(:,:,peakFrames),3); 
        peakMap_HbT = peakMap_HbO + peakMap_HbR;
                peakMap_RawFAD = mean(peakMap_RawFAD(:,:,peakFrames),3);
        peakMap_Rawcalcium = mean(peakMap_Rawcalcium(:,:,peakFrames),3);
        peakMap_FAD = mean(peakMap_FAD(:,:,peakFrames),3);
        peakMap_calcium = mean(peakMap_calcium(:,:,peakFrames),3);
        
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
figure    
imagesc(peakMap_HbO_mice,[-1.5,1.5])
colormap jet
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1.5,0,1.5];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('Oxy')

figure
imagesc(peakMap_HbR_mice,[-0.5 0.5])
colormap jet
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-0.5,0,0.5];
ylabel(h,'\Delta\muM','FontSize',15,'fontweight','bold');
hold on;imagesc(xform_WL,'AlphaData',1-mask);
title('HbR')

figure
imagesc(peakMap_HbT_mice,[-1 1])
colormap jet
axis image off
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1,0,1];
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
imagesc(peakMap_calcium_mice,[-1.5 1.5])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1.5,0,1.5];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
colormap magma
axis image off
hold on;imagesc(xform_WL,'AlphaData',1-mask); 
title('jRGECO1a')

figure
imagesc(peakMap_Rawcalcium_mice,[-1.5 1.5])
h = colorbar('FontSize',15,'fontweight','bold');
h.Ticks =  [-1.5 0 1.5];
ylabel(h,'\DeltaF/F%','FontSize',15,'fontweight','bold');
axis image off
colormap magma
axis image off
hold on;imagesc(xform_WL,'AlphaData',1-mask);    
title(['Raw' char(10) 'jRGECO1a'])





% 
  ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                    max_ROI = prctile(peakMap(ROI),99);
                    temp = double(peakMap).*double(ROI);
                    ROI = temp>max_ROI*0.75;
                    hold on
                    ROI_contour = bwperim(ROI);
                    [~,c] = contour( ROI_contour,'r');
                    c.LineWidth = 0.001;
              
