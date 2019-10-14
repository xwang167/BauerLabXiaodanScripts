
close all;clearvars;clc
excelRows = 220:226;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
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
    
    
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'xform_isbrain');
    
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_datahb_mouse_GSR = [];
    xform_datahb_mouse_NoGSR = [];
    
    xform_jrgeco1a_mouse_GSR = [];
    xform_jrgeco1a_mouse_NoGSR = [];
    
    xform_jrgeco1aCorr_mouse_GSR = [];
    xform_jrgeco1aCorr_mouse_NoGSR = [];
    
    xform_red_mouse_GSR = [];
    xform_red_mouse_NoGSR = [];
    
    xform_FAD_mouse_GSR = [];
    xform_FAD_mouse_NoGSR = [];
    
    xform_FADCorr_mouse_GSR = [];
    xform_FADCorr_mouse_NoGSR = [];
    
    
    xform_gcamp_mouse_GSR = [];
    xform_gcamp_mouse_NoGSR = [];
    
    xform_gcampCorr_mouse_GSR = [];
    xform_gcampCorr_mouse_NoGSR = [];
    
    xform_green_mouse_GSR = [];
    xform_green_mouse_NoGSR = [];
    
    %if ~exist(fullfile(saveDir,processedName_mouse),'file')
    for n = 1:3
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            
               disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','xform_green','goodBlocks_NoGSR')
                     xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','-append')% optional
          
            sessionInfo.stimblocksize = excelRaw{11};
            numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
            clear xform_datahb
            xform_gcamp_NoGSR = reshape(xform_gcamp,128,128,[],numBlocks);
            clear xform_gcamp
            xform_gcampCorr_NoGSR = reshape(xform_gcampCorr,128,128,[],numBlocks);
            clear xform_gcampCorr
            xform_green_NoGSR = reshape(xform_green,128,128,[],numBlocks);
            clear xform_green
            
            xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
            xform_gcamp_mouse_NoGSR = cat(4,xform_gcamp_mouse_NoGSR,xform_gcamp_NoGSR(:,:,:,goodBlocks_NoGSR));
            xform_gcampCorr_mouse_NoGSR = cat(4,xform_gcampCorr_mouse_NoGSR,xform_gcampCorr_NoGSR(:,:,:,goodBlocks_NoGSR));
            xform_green_mouse_NoGSR = cat(4,xform_green_mouse_NoGSR,xform_green_NoGSR(:,:,:,goodBlocks_NoGSR));

            
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','goodBlocks_GSR')
  xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            

            xform_gcamp_GSR = reshape(xform_gcamp_GSR,128,128,[],numBlocks);
           
            xform_gcampCorr_GSR = reshape(xform_gcampCorr_GSR,128,128,[],numBlocks);
           
            xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
            
            
            
            xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
           clear xform_datahb_GSR
            xform_gcamp_mouse_GSR = cat(4,xform_gcamp_mouse_GSR,xform_gcamp_GSR(:,:,:,goodBlocks_GSR));
             clear xform_gcamp_GSR
            xform_gcampCorr_mouse_GSR = cat(4,xform_gcampCorr_mouse_GSR,xform_gcampCorr_GSR(:,:,:,goodBlocks_GSR));
             clear xform_gcampCorr_GSR
            xform_green_mouse_GSR = cat(4,xform_green_mouse_GSR,xform_green_GSR(:,:,:,goodBlocks_GSR));
            clear xform_green_GSR
            
                 elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            disp('loading  Non GRS data')
            sessionInfo.stimblocksize = excelRaw{11};
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                'xform_datahb','xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','goodBlocks_NoGSR')
            numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','-append')% optional
            xform_datahb = reshape(xform_datahb,128,128,2,[],numBlocks);
            xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,[],numBlocks);
            xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
            xform_red= reshape(xform_red,128,128,[],numBlocks);
            xform_FAD = reshape(xform_FAD,128,128,[],numBlocks);
            xform_FADCorr = reshape(xform_FADCorr,128,128,[],numBlocks);
            xform_green= reshape(xform_green,128,128,[],numBlocks);
            
            
            xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb(:,:,:,:,goodBlocks_NoGSR));
            clear xform_datahb
            xform_jrgeco1a_mouse_NoGSR = cat(4,xform_jrgeco1a_mouse_NoGSR,xform_jrgeco1a(:,:,:,goodBlocks_NoGSR));
            clear xform_jrgeco1a
            xform_jrgeco1aCorr_mouse_NoGSR = cat(4,xform_jrgeco1aCorr_mouse_NoGSR,xform_jrgeco1aCorr(:,:,:,goodBlocks_NoGSR));
            clear xform_jrgeco1aCorr
            xform_red_mouse_NoGSR = cat(4,xform_red_mouse_NoGSR,xform_red(:,:,:,goodBlocks_NoGSR));
            clear xform_red
            
            xform_FAD_mouse_NoGSR = cat(4,xform_FAD_mouse_NoGSR,xform_FAD(:,:,:,goodBlocks_NoGSR));
            clear xform_FAD
            xform_FADCorr_mouse_NoGSR = cat(4,xform_FADCorr_mouse_NoGSR,xform_FADCorr(:,:,:,goodBlocks_NoGSR));
            clear xform_FADCorr
            xform_green_mouse_NoGSR = cat(4,xform_green_mouse_NoGSR,xform_green(:,:,:,goodBlocks_NoGSR));
            clear xform_green
            
            
            
            load(fullfile(saveDir, processedName),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','goodBlocks_GSR')
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
            xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
            
            xform_FAD_GSR = reshape(xform_FAD_GSR,128,128,[],numBlocks);
            xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,[],numBlocks);
            xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
            
            
            xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            clear xform_datahb_GSR
            xform_jrgeco1a_mouse_GSR = cat(4,xform_jrgeco1a_mouse_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
            clear xform_jrgeco1a_GSR
            xform_jrgeco1aCorr_mouse_GSR = cat(4,xform_jrgeco1aCorr_mouse_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
            clear xform_jrgeco1aCorr_GSR
            xform_red_mouse_GSR = cat(4,xform_red_mouse_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
            clear xform_red_GSR
            xform_FAD_mouse_GSR = cat(4,xform_FAD_mouse_GSR,xform_FAD_GSR(:,:,:,goodBlocks_GSR));
            clear xform_FAD_GSR
            xform_FADCorr_mouse_GSR = cat(4,xform_FADCorr_mouse_GSR,xform_FADCorr_GSR(:,:,:,goodBlocks_GSR));
            clear xform_FADCorr_GSR
            xform_green_mouse_GSR = cat(4,xform_green_mouse_GSR,xform_green_GSR(:,:,:,goodBlocks_GSR));
            
            
            clear xform_green_GSR
            
            
            
            
        elseif strcmp(char(sessionInfo.mouseType),'WT')
            load(fullfile(saveDir, processedName),'xform_datahb_GSR','goodBlocks_GSR')
            if ~isempty(goodBlocks_GSR)
                temp = reshape(xform_datahb_GSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                temp_goodBlocks_GSR = temp(:,:,:,:,goodBlocks_GSR);
                xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,temp_goodBlocks_GSR);
                load(fullfile(saveDir, processedName),'xform_datahb_NoGSR','goodBlocks_NoGSR')
                if ~isempty(goodBlocks_NoGSR)
                    temp = reshape(xform_datahb_NoGSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                    temp_goodBlocks = temp(:,:,:,:,goodBlocks_NoGSR);
                    xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,temp_goodBLocks);
                end
                
            end
        end
    end
    xform_datahb_mouse_GSR = mean(xform_datahb_mouse_GSR,5);
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR');
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR','-append');
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        numDesample = size(xform_green_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/1);
        numDesample = factor*1;
        
        xform_gcamp_mouse_NoGSR = mean(xform_gcamp_mouse_NoGSR,4);
        xform_gcampCorr_mouse_NoGSR = mean(xform_gcampCorr_mouse_NoGSR,4);
        xform_green_mouse_NoGSR = mean(xform_green_mouse_NoGSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_gcamp_mouse_NoGSR','xform_gcampCorr_mouse_NoGSR','xform_green_mouse_NoGSR','-append');
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        disp('QC on non GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:)),squeeze(xform_datahb_mouse_NoGSR(:,:,2,:)),...
            xform_gcamp_mouse_NoGSR,xform_gcampCorr_mouse_NoGSR,xform_green_mouse_NoGSR,[],[],[],...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR);
        clear xofrm_datahb_mouse_NoGSR xform_gcamp_mouse_NoGSR xform_gcampCorr_mouse_NoGSR xform_green_mouse_NoGSR
        
        
        
        xform_gcamp_mouse_GSR = mean(xform_gcamp_mouse_GSR,4);
        xform_gcampCorr_mouse_GSR = mean(xform_gcampCorr_mouse_GSR,4);
        xform_green_mouse_GSR = mean(xform_green_mouse_GSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_gcamp_mouse_GSR','xform_gcampCorr_mouse_GSR','xform_green_mouse_GSR','-append');
        texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
        output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
        disp('QC on GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:)),squeeze(xform_datahb_mouse_GSR(:,:,2,:)),...
            xform_gcamp_mouse_GSR,xform_gcampCorr_mouse_GSR,xform_green_mouse_GSR,[],[],[],...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR);
        clear xofrm_datahb_mouse_GSR  xform_gcamp_mouse_GSR xform_gcampCorr_mouse_GSR xform_green_mouse_GSR
        
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
        xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
        xform_red_mouse_NoGSR = mean(xform_red_mouse_NoGSR,4);
        
        xform_FAD_mouse_NoGSR = mean(xform_FAD_mouse_GSR,4);
        xform_FADCorr_mouse_NoGSR = mean(xform_FADCorr_mouse_NoGSR,4);
        xform_green_mouse_NoGSR = mean(xform_green_mouse_NoGSR,4);
        
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_FAD_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','xform_green_mouse_NoGSR','-append')
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
        
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        numDesample = size(xform_green_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/1);
        numDesample = factor*1;
        
        disp('QC on non GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:)),squeeze(xform_datahb_mouse_NoGSR(:,:,2,:)),...
            xform_FAD_mouse_NoGSR,xform_FADCorr_mouse_NoGSR,xform_green_mouse_NoGSR,xform_jrgeco1a_mouse_NoGSR,xform_jrgeco1aCorr_mouse_NoGSR,xform_red_mouse_NoGSR,...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR);
        clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR
        
        
        
        
        xform_jrgeco1a_mouse_GSR = mean(xform_jrgeco1a_mouse_GSR,4);
        xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
        xform_red_mouse_GSR = mean(xform_red_mouse_GSR,4);
        
        xform_FAD_mouse_GSR = mean(xform_FAD_mouse_GSR,4);
        xform_FADCorr_mouse_GSR = mean(xform_FADCorr_mouse_GSR,4);
        xform_green_mouse_GSR = mean(xform_green_mouse_GSR,4);
        
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_red_mouse_GSR','xform_FAD_mouse_GSR','xform_FADCorr_mouse_GSR','xform_green_mouse_GSR','-append')
        
        texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
        output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
        
        
        disp('QC on GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:)),squeeze(xform_datahb_mouse_GSR(:,:,2,:)),...
            xform_FAD_mouse_GSR,xform_FADCorr_mouse_GSR,xform_green_mouse_GSR,xform_jrgeco1a_mouse_GSR,xform_jrgeco1aCorr_mouse_GSR,xform_red_mouse_GSR,...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR);
        
        clear xofrm_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR  xform_FAD_mouse_GSR xform_FADCorr_mouse_GSR xform_green_mouse_GSR
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% No GSR
    
    
end


