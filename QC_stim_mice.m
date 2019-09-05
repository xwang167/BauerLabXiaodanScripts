









close all;clearvars;clc


excelRows = [182 184 186 ];
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
numMice = length(excelRows);

miceName = [];
catDir = 'J:\RGECO\cat' ;






stimStartTime = 5;

nVx = 128;
nVy = 128;

xform_datahb_mice_GSR = [];
xform_datahb_mice_NoGSR = [];

xform_jrgeco1a_mice_GSR = [];
xform_jrgeco1a_mice_NoGSR = [];

xform_jrgeco1aCorr_mice_GSR = [];
xform_jrgeco1aCorr_mice_NoGSR = [];

xform_red_mice_GSR = [];
xform_red_mice_NoGSR = [];

xform_FAD_mice_GSR = [];
xform_FAD_mice_NoGSR = [];

xform_FADCorr_mice_GSR = [];
xform_FADCorr_mice_NoGSR = [];


xform_gcamp_mice_GSR = [];
xform_gcamp_mice_NoGSR = [];

xform_gcampCorr_mice_GSR = [];
xform_gcampCorr_mice_NoGSR = [];

xform_green_mice_GSR = [];
xform_green_mice_NoGSR = [];


xform_isbrain_mice = ones(nVx ,nVy);

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
    
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
     
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    
    
    
    
    
    if strcmp(char(sessionInfo.miceType),'gcamp6f')
        sessionInfo.stimblocksize = excelRaw{11};
        numBlocks = size(xform_datahb_GSR,4)/sessionInfo.stimblocksize;
        
        
        disp('loading processed data')
        load(fullfile(saveDir, processedName_mouse),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','goodBlocks_GSR')
        xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
        xform_gcamp_GSR = reshape(xform_gcamp_GSR,128,128,[],numBlocks);
        xform_gcampCorr_GSR = reshape(xform_gcampCorr_GSR,128,128,[],numBlocks);
        xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
        
        xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
        xform_gcamp_mice_GSR = cat(4,xform_gcamp_mice_GSR,xform_gcamp_GSR(:,:,:,goodBlocks_GSR));
        xform_gcampCorr_mice_GSR = cat(4,xform_gcampCorr_mice_GSR,xform_gcampCorr_GSR(:,:,:,goodBlocks_GSR));
        xform_green_mice_GSR = cat(4,xform_green_mice_GSR,xform_green_GSR(:,:,:,goodBlocks_GSR));
        
        disp('loading processed data')
        load(fullfile(saveDir, processedName_mouse),'xform_datahb_mouse_GSR','xform_gcamp_mouse_GSR','xform_gcampCorr_mouse_GSR','xform_green_mouse_GSR')
        
        xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
        xform_gcamp_NoGSR = reshape(xform_gcamp,128,128,[],numBlocks);
        xform_gcampCorr_NoGSR = reshape(xform_gcampCorr,128,128,[],numBlocks);
        xform_green_NoGSR = reshape(xform_green,128,128,[],numBlocks);
        
        xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
        xform_gcamp_mice_NoGSR = cat(4,xform_gcamp_mice_NoGSR,xform_gcamp_NoGSR(:,:,:,goodBlocks_NoGSR));
        xform_gcampCorr_mice_NoGSR = cat(4,xform_gcampCorr_mice_NoGSR,xform_gcampCorr_NoGSR(:,:,:,goodBlocks_NoGSR));
        xform_green_mice_NoGSR = cat(4,xform_green_mice_NoGSR,xform_green_NoGSR(:,:,:,goodBlocks_NoGSR));
    elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
        disp('loading  GRS data')
        sessionInfo.stimblocksize = excelRaw{11};
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_red_mouse_GSR','xform_FAD_mouse_GSR','xform_FADCorr_mouse_GSR','xform_green_mouse_GSR')
             xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_mouse_GSR);
        clear xform_datahb_mouse_GSR
        xform_jrgeco1a_mice_GSR = cat(4,xform_jrgeco1a_mice_GSR,xform_jrgeco1a_mouse_GSR);
        clear xform_jrgeco1a_mouse_GSR
        xform_jrgeco1aCorr_mice_GSR = cat(4,xform_jrgeco1aCorr_mice_GSR,xform_jrgeco1aCorr_mouse_GSR);
        clear xform_jrgeco1aCorr_mouse_GSR
        xform_red_mice_GSR = cat(4,xform_red_mice_GSR,xform_red_mouse_GSR);
        clear xform_red_mouse_GSR
        
        xform_FAD_mice_GSR = cat(4,xform_FAD_mice_GSR,xform_FAD_mouse_GSR);
        clear xform_FAD_mouse_GSR
        xform_FADCorr_mice_GSR = cat(4,xform_FADCorr_mice_GSR,xform_FADCorr_mouse_GSR);
        clear xform_FADCorr_mouse_GSR
        xform_green_mice_GSR = cat(4,xform_green_mice_GSR,xform_green_mouse_GSR);
        clear xform_green_mouse_GSR
        

        
          disp('loading  Non GRS data')
        
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_FAD_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','xform_green_mouse_NoGSR')
 
               xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
        clear xform_datahb_mouse_NoGSR
        xform_jrgeco1a_mice_NoGSR = cat(4,xform_jrgeco1a_mice_NoGSR,xform_jrgeco1a_mouse_NoGSR);
        clear xform_jrgeco1a_mouse_NoGSR
        xform_jrgeco1aCorr_mice_NoGSR = cat(4,xform_jrgeco1aCorr_mice_NoGSR,xform_jrgeco1aCorr_mouse_NoGSR);
        clear xform_jrgeco1aCorr_mouse_NoGSR
        xform_red_mice_NoGSR = cat(4,xform_red_mice_NoGSR,xform_red_mouse_NoGSR);
        clear xform_red_mouse_NoGSR
        
        xform_FAD_mice_NoGSR = cat(4,xform_FAD_mice_NoGSR,xform_FAD_mouse_NoGSR);
        clear xform_FAD_mouse_NoGSR
        xform_FADCorr_mice_NoGSR = cat(4,xform_FADCorr_mice_NoGSR,xform_FADCorr_mouse_NoGSR);
        clear xform_FADCorr_mouse_NoGSR
        xform_green_mice_NoGSR = cat(4,xform_green_mice_NoGSR,xform_green_mouse_NoGSR);
        clear xform_green_mouse_NoGSR    
      
        
           
        
        
    elseif strcmp(char(sessionInfo.miceType),'WT')
        load(fullfile(saveDir, processedName),'xform_datahb_GSR','goodBlocks_GSR')
        if ~isempty(goodBlocks_GSR)
            temp = reshape(xform_datahb_GSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
            temp_goodBlocks_GSR = temp(:,:,:,:,goodBlocks_GSR);
            xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,temp_goodBlocks_GSR);
            load(fullfile(saveDir, processedName),'xform_datahb_NoGSR','goodBlocks_NoGSR')
            if ~isempty(goodBlocks_NoGSR)
                temp = reshape(xform_datahb_NoGSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                temp_goodBlocks = temp(:,:,:,:,goodBlocks_NoGSR);
                xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,temp_goodBLocks);
            end
            
        end
    end
end
xform_datahb_mice_GSR = mean(xform_datahb_mice_GSR,5);
xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'_processed_mice','.mat');
  
save(fullfile(saveDir,processedName_mice),'xform_datahb_mice_GSR');
save(fullfile(saveDir,processedName_mice),'xform_datahb_mice_NoGSR','-append');
if strcmp(char(sessionInfo.miceType),'gcamp6f')
    xform_gcamp_mice_NoGSR = mean(xform_gcamp_mice_GSR,4);
    xform_gcampCorr_mice_NoGSR = mean(xform_gcampCorr_mice_NoGSR,4);
    xform_green_mice_NoGSR = mean(xform_green_mice_NoGSR,4);
    save(fullfile(saveDir,processedName_mice),'xform_gcamp_mice_NoGSR','xform_gcampCorr_mice_NoGSR','xform_green_mice_NoGSR','-append');
    
    xform_gcamp_mice_GSR = mean(xform_gcamp_mice_GSR,4);
    xform_gcampCorr_mice_GSR = mean(xform_gcampCorr_mice_GSR,4);
    xform_green_mice_GSR = mean(xform_green_mice_GSR,4);
    save(fullfile(saveDir,processedName_mice),'xform_gcamp_mice_GSR','xform_gcampCorr_mice_GSR','xform_green_mice_GSR','-append');
elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
%     xform_jrgeco1a_mice_NoGSR = mean(xform_jrgeco1a_mice_NoGSR,4);
%     xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,4);
%     xform_red_mice_NoGSR = mean(xform_red_mice_NoGSR,4);
%     
%     xform_FAD_mice_NoGSR = mean(xform_FAD_mice_GSR,4);
%     xform_FADCorr_mice_NoGSR = mean(xform_FADCorr_mice_NoGSR,4);
%     xform_green_mice_NoGSR = mean(xform_green_mice_NoGSR,4);
%     
%     save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_NoGSR','xform_jrgeco1aCorr_mice_NoGSR','xform_red_mice_NoGSR','xform_FAD_mice_NoGSR','xform_FADCorr_mice_NoGSR','xform_green_mice_NoGSR')
%     texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR nor filtering');
%     output_NoGSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
    numDesample = size(xform_green_mice_NoGSR,3)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
% %     
%     disp('QC on non GSR stim')
%     QC_stim(squeeze(xform_datahb_mice_NoGSR(:,:,1,:)),squeeze(xform_datahb_mice_NoGSR(:,:,2,:)),...
%         xform_FAD_mice_NoGSR,xform_FADCorr_mice_NoGSR,xform_green_mice_NoGSR,xform_jrgeco1a_mice_NoGSR,xform_jrgeco1aCorr_mice_NoGSR,xform_red_mice_NoGSR,...
%         xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR);
    clear xofrm_datahb_mice_NoGSR xform_jrgeco1a_mice_NoGSR xform_jrgeco1aCorr_mice_NoGSR xform_red_mice_NoGSR  xform_FAD_mice_NoGSR xform_FADCorr_mice_NoGSR xform_green_mice_NoGSR
    
    
    
    
    xform_jrgeco1a_mice_GSR = mean(xform_jrgeco1a_mice_GSR,4);
    xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,4);
    xform_red_mice_GSR = mean(xform_red_mice_GSR,4);
    
    xform_FAD_mice_GSR = mean(xform_FAD_mice_GSR,4);
    xform_FADCorr_mice_GSR = mean(xform_FADCorr_mice_GSR,4);
    xform_green_mice_GSR = mean(xform_green_mice_GSR,4);
    
    save(fullfile(catDir,processedName_mice),'xform_jrgeco1a_mice_GSR','xform_jrgeco1aCorr_mice_GSR','xform_red_mice_GSR','xform_FAD_mice_GSR','xform_FADCorr_mice_GSR','xform_green_mice_GSR','-append')
    
    texttitle_GSR = strcat(miceName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(catDir,strcat(recDate,'-',miceName,'-stim','_GSR'));
    
    
    disp('QC on GSR stim')
    QC_stim(squeeze(xform_datahb_mice_GSR(:,:,1,:)),squeeze(xform_datahb_mice_GSR(:,:,2,:)),...
        xform_FAD_mice_GSR,xform_FADCorr_mice_GSR,xform_green_mice_GSR,xform_jrgeco1a_mice_GSR,xform_jrgeco1aCorr_mice_GSR,xform_red_mice_GSR,...
        xform_isbrain_mice,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR);
    
    clear xofrm_datahb_mice_GSR xform_jrgeco1a_mice_GSR xform_jrgeco1aCorr_mice_GSR xform_red_mice_GSR  xform_FAD_mice_GSR xform_FADCorr_mice_GSR xform_green_mice_GSR
end
















%% No GSR




