


clear all;close all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
excelRows = [182 184 186 229 233 237];
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

   figure('units','normalized','outerposition',[0 0 1 1])
   xform_oxy_GSR_mouse_goodBlocks_downsample = resampledata(squeeze(xform_datahb_GSR_mouse_goodBlocks(:,:,1,:)),size(xform_datahb_GSR_mouse_goodBlocks,4),30,10^-5);
   baseline = squeeze(mean(xform_oxy_GSR_mouse_goodBlocks_downsample(:,:,1:5),3));
   for ii = 1:30
       h=subplot(5,6,ii);imagesc(xform_oxy_GSR_mouse_goodBlocks_downsample(:,:,ii)-baseline,[-5*10^-6,5*10^-6]);
       axis image off
       title(num2str(ii))
   end
   colormap jet
   oriSize = get(h,'position');
   
   suptitle([mouseName,'-Oxy'])
   
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

    load(fullfile(saveDir, processedName_mouse),'xform_jrgeco1aCorr_GSR_mouse_goodBlocks');

   figure('units','normalized','outerposition',[0 0 1 1])
   xform_jrgeco1aCorr_GSR_mouse_goodBlocks_downsample = resampledata(xform_jrgeco1aCorr_GSR_mouse_goodBlocks,size(xform_jrgeco1aCorr_GSR_mouse_goodBlocks,3),30,10^-5);
   for ii = 1:30
       h=subplot(5,6,ii);imagesc(xform_jrgeco1aCorr_GSR_mouse_goodBlocks_downsample(:,:,ii),[-0.03 0.03]);
       axis image off
       title(num2str(ii))
   end
   colormap jet
   oriSize = get(h,'position');
   
   suptitle([mouseName,'-RGECOCorr'])
   
end








