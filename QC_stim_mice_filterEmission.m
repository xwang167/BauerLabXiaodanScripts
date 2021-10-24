close all;clearvars;clc

import mouse.*

excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 12:16;
numMice = length(excelRows);

miceName = [];
catDir_corrected = 'X:\XW\FilteredSpectra\FilteredEmission\WT\cat';
stimStartTime = 5;

nVx = 128;
nVy = 128;
load('X:\XW\Paper\WT\RGECO Emission\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-stim_processed_mice.mat',...
    'xform_datahb_mice_GSR','xform_datahb_mice_NoGSR','xform_jrgeco1a_mice_GSR','xform_jrgeco1a_mice_NoGSR',...
    'xform_red_mice_GSR','xform_red_mice_NoGSR','xform_FAD_mice_GSR','xform_FAD_mice_NoGSR',...
    'xform_green_mice_GSR','xform_green_mice_NoGSR')
xform_jrgeco1aCorr_mice_GSR = [];
xform_jrgeco1aCorr_mice_NoGSR = [];

xform_FADCorr_mice_GSR = [];
xform_FADCorr_mice_NoGSR = [];

xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    maskDir = saveDir;
    saveDir_corrected = fullfile('X:\XW\FilteredSpectra\FilteredEmission\WT',recDate);
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'xform_isbrain');
    %     xform_isbrain = ones(128,128);
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    %    isbrain_mice = isbrain_mice.*isbrain;
    
    disp('loading  GSR data')
    sessionInfo.stimblocksize = excelRaw{11};
    load(fullfile(saveDir_corrected,processedName_mouse),...
        'xform_jrgeco1aCorr_mouse_GSR','xform_FADCorr_mouse_GSR')
    
    xform_jrgeco1aCorr_mice_GSR = cat(4,xform_jrgeco1aCorr_mice_GSR,xform_jrgeco1aCorr_mouse_GSR);
    clear xform_jrgeco1aCorr_mouse_GSR
    

    xform_FADCorr_mice_GSR = cat(4,xform_FADCorr_mice_GSR,xform_FADCorr_mouse_GSR);
    clear xform_FADCorr_mouse_GSR
    
    disp('loading  Non GRS data')
        load(fullfile(saveDir_corrected,processedName_mouse),...
        'xform_jrgeco1aCorr_mouse_NoGSR','xform_FADCorr_mouse_NoGSR')
    
    xform_jrgeco1aCorr_mice_NoGSR = cat(4,xform_jrgeco1aCorr_mice_NoGSR,xform_jrgeco1aCorr_mouse_NoGSR);
    clear xform_jrgeco1aCorr_mouse_NoGSR
    xform_FADCorr_mice_NoGSR = cat(4,xform_FADCorr_mice_NoGSR,xform_FADCorr_mouse_NoGSR);
    clear xform_FADCorr_mouse_NoGSR
    
end

xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,4);
xform_FADCorr_mice_NoGSR = mean(xform_FADCorr_mice_NoGSR,4);

xform_jrgeco1aCorr_mice_NoGSR(isinf(xform_jrgeco1aCorr_mice_NoGSR)) = 0;
xform_jrgeco1aCorr_mice_NoGSR(isnan(xform_jrgeco1aCorr_mice_NoGSR)) = 0;

xform_FAD_mice_NoGSR(isinf(xform_FAD_mice_NoGSR)) = 0;
xform_FAD_mice_NoGSR(isnan(xform_FAD_mice_NoGSR)) = 0;
processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');
save(fullfile(catDir_corrected,processedName_mice),'xform_jrgeco1aCorr_mice_NoGSR','xform_FADCorr_mice_NoGSR')
texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
output_NoGSR= fullfile(catDir_corrected,strcat(recDate,'-',miceName,'-stim','_NoGSR'));

numDesample = size(xform_green_mice_NoGSR,3)/sessionInfo.framerate*info.freqout;
factor = round(numDesample/1);
numDesample = factor*1;
numBlock = 1;

disp('QC on non GSR stim')
[~,ROI_NoGSR] =  QC_stim_WT_FAD_camera2(squeeze(xform_datahb_mice_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_NoGSR(:,:,2,:))*10^6,...
    xform_FAD_mice_NoGSR*100,xform_FADCorr_mice_NoGSR*100,xform_green_mice_NoGSR*100,xform_jrgeco1a_mice_NoGSR*100,xform_jrgeco1aCorr_mice_NoGSR*100,xform_red_mice_NoGSR*100,...
    xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);

xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,4);
xform_FADCorr_mice_GSR = mean(xform_FADCorr_mice_GSR,4);

save(fullfile(catDir_corrected,processedName_mice),'xform_jrgeco1aCorr_mice_GSR','xform_FADCorr_mice_GSR','-append')
texttitle_GSR = strcat(miceName,'-stim'," ",'with GSR without filtering');
output_GSR= fullfile(catDir_corrected,strcat(recDate,'-',miceName,'-stim','_GSR'));

%
disp('QC on GSR stim')
QC_stim_WT_FAD_camera2(squeeze(xform_datahb_mice_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_mice_GSR(:,:,2,:))*10^6,...
    xform_FAD_mice_GSR*100,xform_FADCorr_mice_GSR*100,xform_green_mice_GSR*100,xform_jrgeco1a_mice_GSR*100,xform_jrgeco1aCorr_mice_GSR*100,xform_red_mice_GSR*100,...
    xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);

clear xform_datahb_mice_GSR xform_jrgeco1a_mice_GSR xform_jrgeco1aCorr_mice_GSR xform_red_mice_GSR  xform_FAD_mice_GSR xform_FADCorr_mice_GSR xform_green_mice_GSR















