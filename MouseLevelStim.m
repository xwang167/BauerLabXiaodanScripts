

excelFile = 'X:\jonah_gamma\Stim\XiaodanData.xlsx';
excelRows = 10;
runs = 1:3;
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
    %goodRuns = str2num(excelRaw{18});
    
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
        load(fullfile(saveDir, processedName),'xform_datahb')
        numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
        
        xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
        
        clear xform_datahb
        
        xform_datahb_baseline = mean(xform_datahb_NoGSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
        xform_datahb_baseline = repmat(xform_datahb_baseline,1,1,1,size(xform_datahb_NoGSR,4),1);
        
        xform_datahb_NoGSR = xform_datahb_NoGSR - xform_datahb_baseline;
        xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb_NoGSR);
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
        
        
        xform_jrgeco1a_mouse_NoGSR = cat(4,xform_jrgeco1a_mouse_NoGSR,xform_jrgeco1a);
        clear xform_jrgeco1a
        xform_jrgeco1aCorr_mouse_NoGSR = cat(4,xform_jrgeco1aCorr_mouse_NoGSR,xform_jrgeco1aCorr);
        clear xform_jrgeco1aCorr
        xform_red_mouse_NoGSR = cat(4,xform_red_mouse_NoGSR,xform_red);
        clear xform_red
        
        xform_FAD_mouse_NoGSR = cat(4,xform_FAD_mouse_NoGSR,xform_FAD);
        clear xform_FAD
        xform_FADCorr_mouse_NoGSR = cat(4,xform_FADCorr_mouse_NoGSR,xform_FADCorr);
        clear xform_FADCorr
        xform_green_mouse_NoGSR = cat(4,xform_green_mouse_NoGSR,xform_green);
        clear xform_green
        
        
    end
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
    xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
    xform_red_mouse_NoGSR = mean(xform_red_mouse_NoGSR,4);
    
    xform_FAD_mouse_NoGSR = mean(xform_FAD_mouse_NoGSR,4);
    xform_FADCorr_mouse_NoGSR = mean(xform_FADCorr_mouse_NoGSR,4);
    xform_green_mouse_NoGSR = mean(xform_green_mouse_NoGSR,4);
    
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR',...
        'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR',...
        'xform_FAD_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','xform_green_mouse_NoGSR','-append')
    
end