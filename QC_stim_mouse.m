
close all;clearvars;clc
% excelRows = 397:400; %[182,184,186,237];%182,184,186,203,
% excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% runs = 1:6;

excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = [29:31];%[13 15 12];
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
    goodRuns = str2num(excelRaw{18});
    
    %     maskDir = saveDir;
    %     % maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    %     maskDir = fullfile(rawdataloc,recDate);
    %     maskName = strcat(recDate,'-N8M861-opto3-LandmarksAndMask','.mat');
    %
    %     %maskName = strcat(recDate,'-',mouseName(1:11),mouseName((end-4):end),'-LandmarksAndMask','.mat');
    %     load(fullfile(maskDir,maskName),'xform_isbrain','isbrain');
    
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
    xform_datahb_mouse_GSR = [];
    xform_datahb_mouse_NoGSR = [];
    
    xform_jrgeco1a_mouse_GSR = [];
    xform_jrgeco1a_mouse_NoGSR = [];
    
    xform_jrgeco1aCorr_mouse_GSR = [];
    xform_jrgeco1aCorr_mouse_NoGSR = [];
    
    xform_red_mouse_GSR = [];
    xform_red_mouse_NoGSR = [];
    
    %xform_Laser_mouse_NoGSR = [];
    %     %
    xform_FAD_mouse_GSR = [];
    xform_FAD_mouse_NoGSR = [];
    %
    xform_FADCorr_mouse_GSR = [];
    xform_FADCorr_mouse_NoGSR = [];
    %     %
    %
    %  xform_gcamp_mouse_GSR = [];
    %     xform_gcamp_mouse_NoGSR = [];
    %
    % xform_gcampCorr_mouse_GSR = [];
    %     xform_gcampCorr_mouse_NoGSR = [];
    %
    xform_green_mouse_GSR = [];
    xform_green_mouse_NoGSR = [];
    
    %if ~exist(fullfile(saveDir,processedName_mouse),'file')
    for n = runs        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir, processedName),'file')
            sessionInfo.stimblocksize = excelRaw{11};
            disp('loading processed data')
            %goodBlocks_GSR = 1:10;
            %goodBlocks_NoGSR = 1:10;
            load(fullfile(saveDir, processedName),'xform_datahb','goodBlocks_NoGSR')
            numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
            
            clear xform_datahb
            
            xform_datahb_baseline = mean(xform_datahb_NoGSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
            xform_datahb_baseline = repmat(xform_datahb_baseline,1,1,1,size(xform_datahb_NoGSR,4),1);
            
            xform_datahb_NoGSR = xform_datahb_NoGSR - xform_datahb_baseline;
            
            
            xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
            
            
            
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','goodBlocks_GSR')
            
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            
            
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_datahb_GSR_baseline = mean(xform_datahb_GSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
            xform_datahb_GSR_baseline = repmat(xform_datahb_GSR_baseline,1,1,1,size(xform_datahb_GSR,4),1);
            
            xform_datahb_GSR = xform_datahb_GSR - xform_datahb_GSR_baseline;
            
            xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            clear xform_datahb_GSR
            
            
            
            if strcmp(char(sessionInfo.mouseType),'PV')
                load(fullfile(saveDir, processedName), 'goodBlocks_GSR')
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                
                load(fullfile(saveDir, processedName),'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','goodBlocks_GSR')
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                load(fullfile(saveDir, processedName),'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_Laser','ROI_NoGSR')
                
                
            end
            
            %
            %
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                
                
                load(fullfile(saveDir, processedName),'xform_gcamp','xform_gcampCorr','xform_green')
                
                
                xform_gcamp_NoGSR = reshape(xform_gcamp,128,128,[],numBlocks);
                clear xform_gcamp
                xform_gcampCorr_NoGSR = reshape(xform_gcampCorr,128,128,[],numBlocks);
                clear xform_gcampCorr
                xform_green_NoGSR = reshape(xform_green,128,128,[],numBlocks);
                clear xform_green
                
                
                
                xform_gcamp_mouse_NoGSR = cat(4,xform_gcamp_mouse_NoGSR,xform_gcamp_NoGSR(:,:,:,goodBlocks_NoGSR));
                xform_gcampCorr_mouse_NoGSR = cat(4,xform_gcampCorr_mouse_NoGSR,xform_gcampCorr_NoGSR(:,:,:,goodBlocks_NoGSR));
                xform_green_mouse_NoGSR = cat(4,xform_green_mouse_NoGSR,xform_green_NoGSR(:,:,:,goodBlocks_NoGSR));
                
                
                disp('loading processed data')
                load(fullfile(saveDir, processedName),'xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR')
                
                
                xform_gcamp_GSR = reshape(xform_gcamp_GSR,128,128,[],numBlocks);
                
                xform_gcampCorr_GSR = reshape(xform_gcampCorr_GSR,128,128,[],numBlocks);
                
                xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
                
                
                
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
                    'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green')
                
                %             xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','-append')% optional
                xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,[],numBlocks);
                xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
                xform_red= reshape(xform_red,128,128,[],numBlocks);
                xform_FAD = reshape(xform_FAD,128,128,[],numBlocks);
                xform_FADCorr = reshape(xform_FADCorr,128,128,[],numBlocks);
                
                
                xform_jrgeco1aCorr_baseline = mean(xform_jrgeco1aCorr(:,:,1:5*sessionInfo.framerate,:),3);
                xform_jrgeco1aCorr_baseline = repmat(xform_jrgeco1aCorr_baseline,1,1,size(xform_jrgeco1aCorr,3),1);
                
                xform_jrgeco1aCorr= xform_jrgeco1aCorr-xform_jrgeco1aCorr_baseline;
                xform_FADCorr_baseline = mean(xform_FADCorr(:,:,1:5*sessionInfo.framerate,:),3);
                
                xform_FADCorr_baseline = repmat(xform_FADCorr_baseline,1,1,size(xform_FADCorr,3),1);
                
                xform_FADCorr= xform_FADCorr-xform_FADCorr_baseline;
                
                xform_green= reshape(xform_green,128,128,[],numBlocks);
                
                
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
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
                disp('loading  Non GRS data')
                sessionInfo.stimblocksize = excelRaw{11};
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red')
                
                xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,[],numBlocks);
                xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
                xform_red= reshape(xform_red,128,128,[],numBlocks);
                xform_Laser = reshape(xform_Laser,128,128,[],numBlocks);
                xform_jrgeco1aCorr_baseline = mean(xform_jrgeco1aCorr(:,:,1:5*sessionInfo.framerate,:),3);
                xform_jrgeco1aCorr_baseline = repmat(xform_jrgeco1aCorr_baseline,1,1,size(xform_jrgeco1aCorr,3),1);
                
                xform_jrgeco1aCorr= xform_jrgeco1aCorr-xform_jrgeco1aCorr_baseline;
                
                xform_jrgeco1a_mouse_NoGSR = cat(4,xform_jrgeco1a_mouse_NoGSR,xform_jrgeco1a(:,:,:,goodBlocks_NoGSR));
                clear xform_jrgeco1a
                xform_jrgeco1aCorr_mouse_NoGSR = cat(4,xform_jrgeco1aCorr_mouse_NoGSR,xform_jrgeco1aCorr(:,:,:,goodBlocks_NoGSR));
                clear xform_jrgeco1aCorr
                xform_red_mouse_NoGSR = cat(4,xform_red_mouse_NoGSR,xform_red(:,:,:,goodBlocks_NoGSR));
                clear xform_red
                xform_Laser_mouse_NoGSR = cat(4,xform_Laser_mouse_NoGSR,xform_Laser(:,:,:,goodBlocks_NoGSR));
                
            end
            
            
            
            
            if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
                xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
                xform_jrgeco1aCorr_GSR_baseline = mean(xform_jrgeco1aCorr_GSR(:,:,1:5*sessionInfo.framerate,:),3);
                xform_jrgeco1aCorr_GSR_baseline = repmat(xform_jrgeco1aCorr_GSR_baseline,1,1,size(xform_jrgeco1aCorr_GSR,3),1);
                
                xform_jrgeco1aCorr_GSR= xform_jrgeco1aCorr_GSR-xform_jrgeco1aCorr_GSR_baseline;
                
                xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
                %
                xform_FAD_GSR = reshape(xform_FAD_GSR,128,128,[],numBlocks);
                xform_FADCorr_GSR = reshape(xform_FADCorr_GSR,128,128,[],numBlocks);
                xform_FADCorr_GSR_baseline = mean(xform_FADCorr_GSR(:,:,1:5*sessionInfo.framerate,:),3);
                
                xform_FADCorr_GSR_baseline = repmat(xform_FADCorr_GSR_baseline,1,1,size(xform_FADCorr_GSR,3),1);
                
                xform_FADCorr_GSR= xform_FADCorr_GSR-xform_FADCorr_GSR_baseline;
                
                
                xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
                xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
                xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
                xform_jrgeco1aCorr_GSR_baseline = mean(xform_jrgeco1aCorr_GSR(:,:,1:5*sessionInfo.framerate,:),3);
                xform_jrgeco1aCorr_GSR_baseline = repmat(xform_jrgeco1aCorr_GSR_baseline,1,1,size(xform_jrgeco1aCorr_GSR,3),1);
                
                xform_jrgeco1aCorr_GSR= xform_jrgeco1aCorr_GSR-xform_jrgeco1aCorr_GSR_baseline;
                
                xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
                
                
            end
            if ~isempty(goodBlocks_GSR)
                if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
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
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
                    disp('loading gsr data')
                    xform_jrgeco1a_mouse_GSR = cat(4,xform_jrgeco1a_mouse_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
                    clear xform_jrgeco1a_GSR
                    
                    xform_jrgeco1aCorr_mouse_GSR = cat(4,xform_jrgeco1aCorr_mouse_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
                    clear xform_jrgeco1aCorr_GSR
                    xform_red_mouse_GSR = cat(4,xform_red_mouse_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
                    clear xform_red_GSR
                    
                end
            end
        end
    end
    xform_datahb_mouse_GSR = mean(xform_datahb_mouse_GSR,5);
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','xform_datahb_mouse_NoGSR','-v7.3');
    
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','-append');
    %save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR','ROI_NoGSR','-v7.3');
    numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        
        
        xform_gcamp_mouse_NoGSR = mean(xform_gcamp_mouse_NoGSR,4);
        xform_gcampCorr_mouse_NoGSR = mean(xform_gcampCorr_mouse_NoGSR,4);
        xform_green_mouse_NoGSR = mean(xform_green_mouse_NoGSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_gcamp_mouse_NoGSR','xform_gcampCorr_mouse_NoGSR','xform_green_mouse_NoGSR','-append');
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        disp('QC on non GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:)),squeeze(xform_datahb_mouse_NoGSR(:,:,2,:)),...
            xform_gcamp_mouse_NoGSR,xform_gcampCorr_mouse_NoGSR,xform_green_mouse_NoGSR,[],[],[],...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
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
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
        clear xofrm_datahb_mouse_GSR  xform_gcamp_mouse_GSR xform_gcampCorr_mouse_GSR xform_green_mouse_GSR
        
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
        xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
        xform_red_mouse_NoGSR = mean(xform_red_mouse_NoGSR,4);
        
        xform_FAD_mouse_NoGSR = mean(xform_FAD_mouse_NoGSR,4);
        xform_FADCorr_mouse_NoGSR = mean(xform_FADCorr_mouse_NoGSR,4);
        xform_green_mouse_NoGSR = mean(xform_green_mouse_NoGSR,4);
        
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1aCorr_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','-append')
        
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_FAD_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','xform_green_mouse_NoGSR','-append')
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
        
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        numDesample = size(xform_green_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/1);
        numDesample = factor*1;
        
        disp('QC on non GSR stim')
        
        %load(fullfile(saveDir,'ROI.mat'))
        %             if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
            xform_FAD_mouse_NoGSR*100,xform_FADCorr_mouse_NoGSR*100,xform_green_mouse_NoGSR*100,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,[]);
        %             else
        %                 QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
        %                     xform_FAD_mouse_NoGSR/3,xform_FADCorr_mouse_NoGSR/3,xform_green_mouse_NoGSR/3,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
        %                     isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
        %             end
        %             clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR
        
        
        clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR
        
        %
        xform_jrgeco1a_mouse_GSR = mean(xform_jrgeco1a_mouse_GSR,4);
        xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
        xform_red_mouse_GSR = mean(xform_red_mouse_GSR,4);
        %
        xform_FAD_mouse_GSR = mean(xform_FAD_mouse_GSR,4);
        xform_FADCorr_mouse_GSR = mean(xform_FADCorr_mouse_GSR,4);
        xform_green_mouse_GSR = mean(xform_green_mouse_GSR,4);
        %
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1aCorr_mouse_GSR','xform_FADCorr_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_FAD_mouse_GSR','xform_FADCorr_mouse_GSR','-append')
        
        save(fullfile(saveDir,processedName_mouse),'xform_red_mouse_GSR','xform_green_mouse_GSR','-append')
        %
        texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
        output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
        
        
        disp('QC on GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:)),squeeze(xform_datahb_mouse_GSR(:,:,2,:)),...
            xform_FAD_mouse_GSR,xform_FADCorr_mouse_GSR,xform_green_mouse_GSR,xform_jrgeco1a_mouse_GSR,xform_jrgeco1aCorr_mouse_GSR,xform_red_mouse_GSR,...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
        
        clear xofrm_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR  xform_FAD_mouse_GSR xform_FADCorr_mouse_GSR xform_green_mouse_GSR
        %
    elseif strcmp(char(sessionInfo.mouseType),'PV')|| strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto2')
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR');
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        disp('QC on non GSR stim')
        load(fullfile(saveDir, processedName),'ROI_NoGSR')
        %load(fullfile(saveDir,'ROI.mat'))
        if strcmp(char(sessionInfo.mouseType),'PV')
            %             QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
            %                 [],[],[],[],[],[],...
            %                 xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_NoGSR);
        else
            QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
                [],[],[],[],[],[],...
                isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
        end
        clear xofrm_datahb_mouse_NoGSR
        %         texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR with 0.5Hz low pass');
        %         output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
        %         disp('QC on GSR stim')
        %         QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:)),squeeze(xform_datahb_mouse_GSR(:,:,2,:)),...
        %             xform_gcamp_mouse_GSR,xform_gcampCorr_mouse_GSR,xform_green_mouse_GSR,[],[],[],...
        %             xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
        %         clear xofrm_datahb_mouse_GSR
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
        xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
        xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
        xform_red_mouse_NoGSR = mean(xform_red_mouse_NoGSR,4);
        xform_Laser_mouse_NoGSR = mean(xform_Laser_mouse_NoGSR,4);
        
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_Laser_mouse_NoGSR','ROI_NoGSR','-append')
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
        
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        numDesample = size(xform_red_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/1);
        numDesample = factor*1;
        
        disp('QC on non GSR stim')
        peakMap_ROI = mean(xform_Laser_mouse_NoGSR(:,:, sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);
        figure
        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        [X,Y] = meshgrid(1:128,1:128);
        
        %         [x1,y1] = ginput(1);
        %         [x2,y2] = ginput(1);
        %
        %         radius = sqrt((x1-x2)^2+(y1-y2)^2);
        %
        %         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        %         min_ROI = prctile(peakMap_ROI(ROI),1);
        %         temp = double(peakMap_ROI).*double(ROI);
        %         ROI = temp<min_ROI*0.75;
        [~,I] = max(peakMap_ROI,[],'all','linear');
        [y1,x1] = ind2sub([128 128],I);
        radius = 5;
        hold on
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap_ROI(ROI),99);
        temp = double(peakMap_ROI).*double(ROI);
        ROI = temp>max_ROI*0.30;
        ROI_contour = bwperim(ROI);
        [~,c] = contour( ROI_contour,'k');
        c.LineWidth = 0.001;
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
    end
    close all
    
    
end

%   if strcmp(char(sessionInfo.mouseType),'PV')
%         texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR without filtering');
%
%         output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
%         numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
%         factor = round(numDesample/1);
%         numDesample = factor*1;
%         imagesc(peakMap_ROI)
%         axis image off
%         colormap jet
%         %                     hold on
%         %                     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
%         %                     barrel = AtlasSeeds == 9;
%         %                     ROI_barrel =  bwperim(barrel);
%
%
%         %                     contour(ROI_barrel,'k')
%         [X,Y] = meshgrid(1:128,1:128);
%         if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
%             [~,I] = max(peakMap_ROI,[],'all','linear');
%             [y1,x1] = ind2sub([128 128],I);
%             radius = 5;
%         else
%
%             [x1,y1] = ginput(1);
%             [x2,y2] = ginput(1);
%
%             radius = sqrt((x1-x2)^2+(y1-y2)^2);
%
%         end
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         max_ROI = prctile(peakMap_ROI(ROI),99);
%         temp = double(peakMap_ROI).*double(ROI);
%         ROI = temp>max_ROI*0.30;
%         hold on
%         ROI_contour = bwperim(ROI);
%         [~,c] = contour( ROI_contour,'r');
%         c.LineWidth = 0.001;
%
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
%     end