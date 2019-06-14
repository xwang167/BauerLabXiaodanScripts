% run for each excel row
close all;clearvars;clc
isGsr = true;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
%Xiaodan

if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end
for excelRow = 16
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    frameRate = excelRaw{7};
    
    systemInfo = mouse.expSpecific.sysInfo(systemType);
    sessionInfo = mouse.expSpecific.session2procInfo(sessionType);
    
    
    % manually change sessionInfo since Xiaodan uses some different
    % parameters for fc and stim sessions

        sessionInfo.framerate = frameRate;
        sessionInfo.freqout = frameRate;
        sessionInfo.stimblocksize = excelRaw{8};
        sessionInfo.stimbaseline = excelRaw{9};
        sessionInfo.stimduration = excelRaw{10};
        sessionInfo.stimFrequency = excelRaw{12};
        sessionInfo.darkFrames = excelRaw{11};
    maskFileName = strcat(recDate,"-",mouseName,"-mask.mat");
    maskFileName = fullfile(saveDir,maskFileName);
    
    for runInd = 2:3 % for each run
        
        tiffFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(runInd),".tif");
        tiffFileName = fullfile(tiffFileDir,tiffFileName);
        saveDataFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(runInd),isGsrname ,"-Detrend.mat");
        saveDataFileName = fullfile(saveDir,saveDataFileName);
        
        if isfile(maskFileName)
            
            load(maskFileName);
            
            % mask file exists
            [raw, time, xform_hb, xform_gcamp, xform_gcampCorr, isbrain, xform_isbrain, markers] = gcamp.gcampImaging(tiffFileName, systemInfo, sessionInfo, isbrain, markers,'darkFrames',sessionInfo.darkFrames);
        else
            % mask file does not exist, so it has to be created
            [raw, time, xform_hb, xform_gcamp, xform_gcampCorr,isbrain, xform_isbrain, markers] = gcamp.gcampImaging(tiffFileName, systemInfo,sessionInfo,'darkFrames',sessionInfo.darkFrames);
            
            % save mask
            save(maskFileName,'isbrain','xform_isbrain','markers');
        end
           %% get green data %Xiaodan
             greenData = raw(:,:,2,:);
             greenData = mouse.expSpecific.procFluor(greenData);
             xform_green = mouse.expSpecific.transformHb(greenData, markers);   
      if strcmp(char(sessionType),'fc')

        sessionInfo.bandtype_ISA = {"ISA",0.01,0.5};
        sessionInfo.bandtype_Delta = {"Delta",0.5,4};

        xform_hb_ISA =highpass(xform_hb,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
        xform_hb_ISA =lowpass(xform_hb_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
        xform_hb_Delta =highpass(xform_hb,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
        xform_hb_Delta =lowpass(xform_hb_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
        
        xform_gcamp_ISA = highpass(xform_gcamp,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
        xform_gcamp_ISA = lowpass(xform_gcamp_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
        xform_gcamp_Delta = highpass(xform_gcamp,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
        xform_gcamp_Delta = lowpass(xform_gcamp_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
        
        xform_gcampCorr_ISA =highpass(xform_gcampCorr,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
        xform_gcampCorr_ISA =lowpass(xform_gcampCorr_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
        xform_gcampCorr_Delta = highpass(xform_gcampCorr,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
        xform_gcampCorr_Delta = lowpass(xform_gcampCorr_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
        
        xform_green_ISA =highpass(xform_green,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
        xform_green_ISA =lowpass(xform_green_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
        xform_green_Delta =highpass(xform_green,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
        xform_green_Delta =lowpass(xform_green_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
        
        xform_hb_ISA = mouse.preprocess.gsr(xform_hb_ISA,xform_isbrain);
        if isnan(xform_hb_ISA)~=0
            disp(strcat(tiffFileName,' has NAN'));
        end
        xform_hb_ISA(isnan(xform_hb_ISA))=0;
        xform_gcamp_ISA = mouse.preprocess.gsr(xform_gcamp_ISA,xform_isbrain);
        xform_gcampCorr_ISA = mouse.preprocess.gsr(xform_gcampCorr_ISA,xform_isbrain);
        xform_green_ISA = mouse.preprocess.gsr(xform_green_ISA,xform_isbrain);
        xform_total_ISA = xform_hb_ISA(:,:,1,:) + xform_hb_ISA(:,:,2,:);
        
        xform_hb_Delta = mouse.preprocess.gsr(xform_hb_Delta,xform_isbrain);
        xform_gcamp_Delta = mouse.preprocess.gsr(xform_gcamp_Delta,xform_isbrain);
        xform_gcampCorr_Delta = mouse.preprocess.gsr(xform_gcampCorr_Delta,xform_isbrain);
        xform_green_Delta = mouse.preprocess.gsr(xform_green_Delta,xform_isbrain);
        xform_total_Delta = xform_hb_Delta(:,:,1,:) + xform_hb_Delta(:,:,2,:);
        
    save(saveDataFileName,'time','xform_hb_ISA','xform_total_ISA','xform_gcamp_ISA','xform_gcampCorr_ISA','xform_green_ISA','xform_hb_Delta','xform_total_Delta','xform_gcamp_Delta','xform_gcampCorr_Delta','xform_green_Delta',...
            'isbrain','xform_isbrain','markers','sessionInfo','systemInfo','-v7.3');
    elseif strcmp(char(sessionType),'stim')
        sessionInfo.framerate = frameRate;
        sessionInfo.freqout = frameRate;
        sessionInfo.bandtype = {"0.01Hz-8Hz",0.01,8};

        xform_hb =highpass(xform_hb,sessionInfo.bandtype{2},sessionInfo.framerate);
        xform_hb=lowpass(xform_hb ,sessionInfo.bandtype{3},sessionInfo.framerate);
        xform_gcamp =highpass(xform_gcamp,sessionInfo.bandtype{2},sessionInfo.framerate);
        xform_gcamp =lowpass(xform_gcamp ,sessionInfo.bandtype{3},sessionInfo.framerate);
        xform_gcampCorr =highpass(xform_gcampCorr,sessionInfo.bandtype{2},sessionInfo.framerate);
        xform_gcampCorr=lowpass(xform_gcampCorr ,sessionInfo.bandtype{3},sessionInfo.framerate);
        xform_green =highpass(xform_green,sessionInfo.bandtype{2},sessionInfo.framerate);
        xform_green =lowpass(xform_green ,sessionInfo.bandtype{3},sessionInfo.framerate);  
        
        
        xform_hb = mouse.preprocess.gsr(xform_hb,xform_isbrain);
        xform_gcamp = mouse.preprocess.gsr(xform_gcamp,xform_isbrain);
        xform_gcampCorr = mouse.preprocess.gsr(xform_gcampCorr,xform_isbrain);
        xform_green = mouse.preprocess.gsr(xform_green,xform_isbrain);
        xform_total = xform_hb(:,:,1,:) + xform_hb(:,:,2,:);
                save(saveDataFileName,'raw','time','xform_hb','xform_total','xform_gcamp','xform_gcampCorr','xform_green',...
            'isbrain','xform_isbrain','markers','sessionInfo','systemInfo','-v7.3');
        
      end
    end
end