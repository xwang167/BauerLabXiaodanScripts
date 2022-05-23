
close all;clearvars;clc
% excelRows = 397:400; %[182,184,186,237];%182,184,186,203,
% excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
% runs = 1:6;

excelFile = "X:\Paper\PaperExperiment.xlsx";
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
    %
    xform_red_mouse_GSR = [];
    xform_red_mouse_NoGSR = [];
    
    xform_FAD_mouse_GSR = [];
    xform_FAD_mouse_NoGSR = [];
    
    xform_FADCorr_mouse_GSR = [];
    xform_FADCorr_mouse_NoGSR = [];
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
            load(fullfile(saveDir, processedName),'xform_datahb')
            numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
            
            clear xform_datahb
%             
%             xform_datahb_baseline = mean(xform_datahb_NoGSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
%             xform_datahb_baseline = repmat(xform_datahb_baseline,1,1,1,size(xform_datahb_NoGSR,4),1);
%             
%             xform_datahb_NoGSR = xform_datahb_NoGSR - xform_datahb_baseline;
%             
%             
            xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb_NoGSR);
            
            
            
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR')
            
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            
            
%             xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
%             xform_datahb_GSR_baseline = mean(xform_datahb_GSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
%             xform_datahb_GSR_baseline = repmat(xform_datahb_GSR_baseline,1,1,1,size(xform_datahb_GSR,4),1);
%             
%             xform_datahb_GSR = xform_datahb_GSR - xform_datahb_GSR_baseline;
            
            xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            clear xform_datahb_GSR
            
            load(fullfile(saveDir, processedName),'xform_jrgeco1a',...
                'xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr',...
                'xform_green')
            
            
            xform_jrgeco1a_NoGSR = reshape(xform_jrgeco1a,128,128,[],numBlocks);
            clear xform_jrgeco1a
            xform_jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
            clear xform_jrgeco1aCorr
            xform_red_NoGSR = reshape(xform_red,128,128,[],numBlocks);
            clear xform_red
            
            xform_FAD_mouse_NoGSR = cat(4,xform_FAD_mouse_NoGSR,xform_FAD);
            clear xform_FAD
            xform_FADCorr_mouse_NoGSR = cat(4,xform_FADCorr_mouse_NoGSR,xform_FADCorr);
            clear xform_FADCorr
            xform_green_mouse_NoGSR = cat(4,xform_green_mouse_NoGSR,xform_green);
            clear xform_green
            
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_jrgeco1a_GSR',...
                'xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR',...
                'xform_FADCorr', 'xform_green')
            xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
            
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
            
            xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
            
            xform_FAD_mouse_GSR = cat(4,xform_FAD_mouse_GSR,xform_FAD_GSR);
            clear xform_FAD_GSR
            xform_FADCorr_mouse_GSR = cat(4,xform_FADCorr_mouse_GSR,xform_FADCorr_GSR);
            clear xform_FADCorr_GSR
            xform_green_mouse_GSR = cat(4,xform_green_mouse_GSR,xform_green_GSR);
            clear xform_green_GSR
            
        end
    end
    xform_datahb_mouse_GSR = mean(xform_datahb_mouse_GSR,5);
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','xform_datahb_mouse_NoGSR','-append');
    clear xofrm_datahb_mouse_NoGSR xform_datahb_mouse_GSR
    
    xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
    xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
    xform_green_mouse_NoGSR = mean(xform_green_mouse_NoGSR,4);
    save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_green_mouse_NoGSR','-append');
    
     xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_green_mouse_NoGSR
    
    
    xform_jrgeco1a_mouse_GSR = mean(xform_jrgeco1a_mouse_GSR,4);
    xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
    xform_green_mouse_GSR = mean(xform_green_mouse_GSR,4);
    save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_GSR','xform_jrgeco1aCorr_mouse_GSR','xform_green_mouse_GSR','-append');
    texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
    disp('QC on GSR stim')
    
    clear xofrm_datahb_mouse_GSR  xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_green_mouse_GSR
    
end

