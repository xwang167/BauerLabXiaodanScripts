close all;clc
import mouse.*
excelRows =  [243 244 251 459 460 461 ];%[462 464 466];%[367,371,375,397,401,409];%,229,233,237%,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
calcium_timetraceMatrix_GSR_mice = [];
ll = 1;
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
    disp('loading  GRS data')
    sessionInfo.stimblocksize = excelRaw{11};
        maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
     load(fullfile(maskDir,maskName),'xform_isbrain');
    if excelRow == 243 || excelRow == 244 || excelRow == 251
        runs = 1:3;
    else
        runs = 1:6;
    end
    for n = runs
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'1_processed.mat');
    load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
    if excelRow == 243 || excelRow == 244 || excelRow == 251
        load(fullfile(saveDir,processedName),'ROI_NoGSR')
        iROI = reshape(ROI_NoGSR,1,[]);
    else
        load(fullfile(saveDir,processedName),'ROI')
        iROI = reshape(ROI,1,[]);
    end
    xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
    xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,600,10);
    baseline = mean(xform_jrgeco1aCorr_GSR(:,:,1:100,:),3);
    baseline = repmat(baseline,1,1,600,1);
    xform_jrgeco1aCorr_GSR = xform_jrgeco1aCorr_GSR-baseline;
    xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128*128,600,10);
    calcium_timetrace = squeeze(mean(xform_jrgeco1aCorr_GSR(iROI,:,:),1));
    calcium_timetraceMatrix_GSR_mice = cat(2,calcium_timetraceMatrix_GSR_mice,calcium_timetrace);
    
    
    end
end