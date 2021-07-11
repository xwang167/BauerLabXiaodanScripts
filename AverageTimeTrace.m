

close all;clearvars;clc

import mouse.*

excelRows =  [243 244 251 459 460 461 ];%[462 464 466];%[367,371,375,397,401,409];%,229,233,237%,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'K:\RGECO\cat' ;
calcium_timetrace_NoGSR_mice = zeros(6,600);
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
    info.freqout=1;
    miceName = strcat(miceName,'-',mouseName);
    
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    
    
    
    
    load(fullfile(maskDir,maskName),'xform_isbrain');
    %     xform_isbrain = ones(128,128);
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'1_processed.mat');
    disp('loading  Non GRS data')
    sessionInfo.stimblocksize = excelRaw{11};
    
    if excelRow == 243 || excelRow == 244 || excelRow == 251
        load(fullfile(saveDir,processedName),'ROI_NoGSR')
        iROI = reshape(ROI_NoGSR,1,[]);
    else
        load(fullfile(saveDir,processedName),'ROI')
        iROI = reshape(ROI,1,[]);
    end
    
    load(fullfile(saveDir,processedName_mouse),'xform_jrgeco1aCorr_mouse_NoGSR')
    baseline = mean(xform_jrgeco1aCorr_mouse_NoGSR(:,:,1:100),3);
    xform_jrgeco1aCorr_mouse_NoGSR = xform_jrgeco1aCorr_mouse_NoGSR-repmat(baseline,1,1,600);
    xform_jrgeco1aCorr_mouse_NoGSR = reshape(xform_jrgeco1aCorr_mouse_NoGSR,128*128,[]);
    calcium_timetrace_NoGSR_mouse = mean(xform_jrgeco1aCorr_mouse_NoGSR(iROI,:),1);
    calcium_timetrace_NoGSR_mice(ll,:) = calcium_timetrace_NoGSR_mouse;
    ll = ll + 1;
end

calcium_timetrace_NoGSR_mice = mean(calcium_timetrace_NoGSR_mice,1);
