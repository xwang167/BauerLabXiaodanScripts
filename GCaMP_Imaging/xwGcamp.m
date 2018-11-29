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
for excelRow = 7:11
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    tiffFileDir = excelRaw{3}; tiffFileDir = strcat(tiffFileDir,recDate);
    saveDir = excelRaw{4}; saveDir = string(saveDir);
    systemType = excelRaw{5};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    frameRate = excelRaw{7};
    
    systemInfo = mouse.expSpecific.sysInfo(systemType);
    sessionInfo = mouse.expSpecific.session2procInfo(sessionType);
    
    % manually change sessionInfo since Xiaodan uses some different
    % parameters for fc and stim sessions
    if strcmp(char(sessionType),'fc')
        sessionInfo.framerate = frameRate;
        sessionInfo.freqout = frameRate;
%         sessionInfo.highpass = 0.01;
%         sessionInfo.lowpass = 0.5;
%         "-",sessionInfo.bandtype = "-ISA";
        sessionInfo.highpass = 0.5;
        sessionInfo.lowpass = 4;
        sessionInfo.bandtype = "Delta";
       
    elseif strcmp(char(sessionType),'stim')
        sessionInfo.framerate = frameRate;
        sessionInfo.freqout = frameRate;
        sessionInfo.highpass = 0.01;
        sessionInfo.lowpass = 8;
        sessionInfo.bandtype = "0.01Hz-8Hz";
        sessionInfo.stimblocksize = excelRaw{8};
        sessionInfo.stimbaseline = excelRaw{9};
        sessionInfo.stimblocksize = excelRaw{10};
    end
    
    maskFileName = strcat(recDate,"-",mouseName,"-mask.mat");
    maskFileName = fullfile(saveDir,maskFileName);
    
    for runInd = 1:3 % for each run
        
        tiffFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(runInd),".tif");
        tiffFileName = fullfile(tiffFileDir,tiffFileName);
        saveDataFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(runInd),"-",sessionInfo.bandtype,isGsrname ,"-NewDetrend.mat");
        saveDataFileName = fullfile(saveDir,saveDataFileName);
        
        if isfile(maskFileName)
            
            load(maskFileName);
            
            % mask file exists
            [raw, time, xform_hb, xform_gcamp, xform_gcampCorr, isbrain, xform_isbrain, markers] = gcamp.gcampImaging(tiffFileName, systemInfo, sessionInfo, isbrain, markers,'darkTime',5);
        else
            % mask file does not exist, so it has to be created
            [raw, time, xform_hb, xform_gcamp, xform_gcampCorr,isbrain, xform_isbrain, markers] = gcamp.gcampImaging(tiffFileName, systemInfo,sessionInfo,'darkTime',5);
            
            % save mask
            save(maskFileName,'isbrain','xform_isbrain','markers');
        end
        

        %% get green data %Xiaodan
        highpassFreq = sessionInfo.highpass;
        lowpassFreq = sessionInfo.lowpass;
        bandpassFreq = [highpassFreq lowpassFreq];

        bandpassFluor = true ;
        greenData = raw(:,:,2,:);
        greenData = mouse.expSpecific.procFluor(greenData,sessionInfo.freqout,bandpassFreq,bandpassFluor);
        xform_green = mouse.expSpecific.transformHb(greenData, markers);
     
        % gsr
        xform_hb = mouse.preprocess.gsr(xform_hb,xform_isbrain);
        xform_gcamp = mouse.preprocess.gsr(xform_gcamp,xform_isbrain);
        xform_gcampCorr = mouse.preprocess.gsr(xform_gcampCorr,xform_isbrain);
        xform_green = mouse.preprocess.gsr(xform_green,xform_isbrain);
        xform_total = xform_hb(:,:,1,:) + xform_hb(:,:,2,:);
        
        % save data
        save(saveDataFileName,'raw','time','xform_hb','xform_total','xform_gcamp','xform_gcampCorr','xform_green',...
            'isbrain','xform_isbrain','markers','sessionInfo','systemInfo','-v7.3');
    end
end