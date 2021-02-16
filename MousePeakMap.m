clear all;close all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
excelRows = [182 184 186 229 233 237];

load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice','ROI_NoGSR','xform_jrgeco1aCorr_GSR_mice_goodBlocks')

xform_jrgeco1aCorr_GSR_mice_goodBlocks = reshape(xform_jrgeco1aCorr_GSR_mice_goodBlocks,[],750);
timetrace = mean(xform_jrgeco1aCorr_GSR_mice_goodBlocks(ROI_NoGSR,:),1);
baseline = mean(timetrace(1:125));
timetrace = timetrace-baseline;
TF = islocalmax(timetrace);
TF(1:125) = 0;
TF(251:end) = 0;
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
ROI_barrel = AtlasSeeds==9;

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
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');

    load(fullfile(saveDir, processedName_mouse),'xform_jrgeco1aCorr_GSR_mouse_goodBlocks');

   figure
   peakMap = mean(xform_jrgeco1aCorr_GSR_mouse_goodBlocks(:,:,TF)*100,3);
   imagesc(peakMap,[-4 4]);
   hold on
   contour(ROI_barrel,'k')
   axis image off
   colormap jet
   colorbar
   title([mouseName,'-RGECOCorr'])
   
end




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
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');

    load(fullfile(saveDir, processedName_mouse),'xform_datahb_GSR_mouse_goodBlocks');
    oxy = squeeze(xform_datahb_GSR_mouse_goodBlocks(:,:,1,:));
    deoxy = squeeze(xform_datahb_GSR_mouse_goodBlocks(:,:,2,:));
    clear xform_datahb_GSR_mouse_goodBlocks
    total = oxy+deoxy;
    
   figure
   peakMap = mean(oxy(:,:,126:250)*10^6,3);
   imagesc(peakMap,[-1 1]);
   axis image off
   colormap jet
   colorbar
   title([mouseName,'-Oxy'])
   
   figure
   peakMap = mean(deoxy(:,:,126:250)*10^6,3);
   imagesc(peakMap,[-0.4 0.4]);
   axis image off
   colormap jet
   colorbar
   title([mouseName,'-deoxy'])
   
      figure
   peakMap = mean(total(:,:,126:250)*10^6,3);
   imagesc(peakMap,[-0.8 0.8]);
   axis image off
   colormap jet
   colorbar
   title([mouseName,'-Total'])
   
   
end

