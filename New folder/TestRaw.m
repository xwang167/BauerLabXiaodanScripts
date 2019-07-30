close all;clear all;clc
excelRows = 50:65;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

import mouse.*
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    sessionInfo.mouseType = excelRaw{13};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain','I');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.blocksize = excelRaw{8};
    sessionInfo.darkFrameNum = excelRaw{11};
    if strcmp(systemType, 'EastOIS2')
        numChannels =3;
    end
    for n = 1
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'combinedRaw')
        combinedRaw(:,:,:,1:sessionInfo.darkFrameNum/4) =[];
        runName = strcat(recDate,'-',mouseName,sessionType,num2str(n));
        if strcmp(sessionType,'stim')
            sessionInfo.stimbaseline=excelRaw{9};
            numBlocks = 10;
            blockDuration = 30;
            output= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n)));
            load(strcat(output,'_vis.mat'),'mask_oxy')
            visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_testRaw.jpg');
            detrendRaw = mouse.preprocess.detrend(combinedRaw,true,false);
            clear combinedRaw
            plotROIRaw_BlockAverage(detrendRaw,info.nVy,info.nVx,numChannels,numBlocks,sessionInfo.blocksize,blockDuration,sessionInfo.mouseType,systemType,mask_oxy,sessionInfo.stimbaseline,I,runName,isbrain,saveDir,visName)
        end
    end
end