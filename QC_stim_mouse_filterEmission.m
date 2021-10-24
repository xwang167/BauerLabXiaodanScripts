
close all;clearvars;clc
excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 12:16;%[13 15 12];
runs = 1:3;
stimStartTime = 5;

nVx = 128;
nVy = 128;
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
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    info.freqout=1;
    saveDir_corrected = fullfile('X:\XW\FilteredSpectra\FilteredEmission\WT',recDate);
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    
    load(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','xform_datahb_mouse_NoGSR',...
        'xform_jrgeco1a_mouse_GSR','xform_jrgeco1a_mouse_NoGSR',...
        'xform_red_mouse_GSR','xform_red_mouse_NoGSR',...
        'xform_FAD_mouse_GSR','xform_FAD_mouse_NoGSR',...
        'xform_green_mouse_GSR','xform_green_mouse_NoGSR')
    
    xform_jrgeco1aCorr_mouse_GSR = [];
    xform_jrgeco1aCorr_mouse_NoGSR = [];
    
    xform_FADCorr_mouse_GSR = [];
    xform_FADCorr_mouse_NoGSR = [];
    
    
    for n = runs
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir, processedName),'file')
            sessionInfo.stimblocksize = excelRaw{11};
            disp('loading processed data')
            %goodBlocks_GSR = 1:10;
            %goodBlocks_NoGSR = 1:10;
            load(fullfile(saveDir_corrected, processedName),'xform_jrgeco1aCorr_GSR','xform_FADCorr_GSR',...
                'xform_jrgeco1aCorr','xform_FADCorr')
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR')
            
            numBlocks = size(xform_jrgeco1aCorr_GSR,3)/sessionInfo.stimblocksize;
            
            
            disp('loading  Non GRS data')
            sessionInfo.stimblocksize = excelRaw{11};
            
            %             xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','-append')% optional
            
            if ~isempty(goodBlocks_NoGSR)
                xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
                xform_FADCorr = reshape(xform_FADCorr,128,128,[],numBlocks);
                xform_jrgeco1aCorr_mouse_NoGSR = cat(4,xform_jrgeco1aCorr_mouse_NoGSR,xform_jrgeco1aCorr(:,:,:,goodBlocks_NoGSR));
                clear xform_jrgeco1aCorr
                xform_FADCorr_mouse_NoGSR = cat(4,xform_FADCorr_mouse_NoGSR,xform_FADCorr(:,:,:,goodBlocks_NoGSR));
                clear xform_FADCorr
            end
            
            
            if ~isempty(goodBlocks_GSR)
                xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
                xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,[],numBlocks);
                strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                xform_jrgeco1aCorr_mouse_GSR = cat(4,xform_jrgeco1aCorr_mouse_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
                clear xform_jrgeco1aCorr_GSR
                xform_FADCorr_mouse_GSR = cat(4,xform_FADCorr_mouse_GSR,xform_FADCorr_GSR(:,:,:,goodBlocks_GSR));
                clear xform_FADCorr_GSR
                
            end
        end
    end
    
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','-append');
    %save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR','ROI_NoGSR','-v7.3');
    numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
    xform_FADCorr_mouse_NoGSR = mean(xform_FADCorr_mouse_NoGSR,4);
    
    save(fullfile(saveDir_corrected,processedName_mouse),'xform_jrgeco1aCorr_mouse_NoGSR','xform_FADCorr_mouse_NoGSR')
    
    texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
    
    output_NoGSR= fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
    numDesample = size(xform_green_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    disp('QC on non GSR stim')
    
    QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
        xform_FAD_mouse_NoGSR*100,xform_FADCorr_mouse_NoGSR*100,xform_green_mouse_NoGSR*100,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
        xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
    
    clear xform_jrgeco1aCorr_mouse_NoGSR xform_FADCorr_mouse_NoGSR
    
    
    xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
    xform_FADCorr_mouse_GSR = mean(xform_FADCorr_mouse_GSR,4);
    
    save(fullfile(saveDir_corrected,processedName_mouse),'xform_jrgeco1aCorr_mouse_GSR','xform_FADCorr_mouse_GSR','-append')
    texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-stim','_GSR'));
    
    
    disp('QC on GSR stim')
    QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:)),squeeze(xform_datahb_mouse_GSR(:,:,2,:)),...
        xform_FAD_mouse_GSR,xform_FADCorr_mouse_GSR,xform_green_mouse_GSR,xform_jrgeco1a_mouse_GSR,xform_jrgeco1aCorr_mouse_GSR,xform_red_mouse_GSR,...
        xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
    
    clear xofrm_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR  xform_FAD_mouse_GSR xform_FADCorr_mouse_GSR xform_green_mouse_GSR
    %
    
    close all
    
    
end

