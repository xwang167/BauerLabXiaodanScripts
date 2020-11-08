
close all;clearvars;clc
excelRows = 380:388; %[182,184,186,237];%182,184,186,203,
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:4;
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
    
    
    %maskDir = saveDir;
    %maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    mouseName = char(mouseName);
    maskDir = rawdataloc;
%     maskName = strcat(recDate,'-',mouseName(1:16),mouseName((end-4):end),'-LandmarksAndMask','.mat');
%     load(fullfile(maskDir,recDate,maskName),'xform_isbrain','isbrain');
    xform_isbrain = ones(128,128);
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    

   load(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR');
    
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','-append');
    %     save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_NoGSR','-append');
    numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    if strcmp(char(sessionInfo.mouseType),'PV')
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR without filtering');
        
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/1);
        numDesample = factor*1;
        imagesc(peakMap_ROI)
        axis image off
        colormap jet
        %                     hold on
        %                     load('D:\OIS_Process\atlas.mat','AtlasSeeds')
        %                     barrel = AtlasSeeds == 9;
        %                     ROI_barrel =  bwperim(barrel);
        
        
        %                     contour(ROI_barrel,'k')
        [X,Y] = meshgrid(1:128,1:128);
        if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
            [~,I] = max(peakMap_ROI,[],'all','linear');
            [y1,x1] = ind2sub([128 128],I);
            radius = 5;
        else
            
            [x1,y1] = ginput(1);
            [x2,y2] = ginput(1);
            
            radius = sqrt((x1-x2)^2+(y1-y2)^2);
            
        end
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap_ROI(ROI),99);
        temp = double(peakMap_ROI).*double(ROI);
        ROI = temp>max_ROI*0.30;
        hold on
        ROI_contour = bwperim(ROI);
        [~,c] = contour( ROI_contour,'r');
        c.LineWidth = 0.001;
        
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
        saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
    end
       
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
        
        load(fullfile(saveDir,'ROI.mat'))
        %             if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
            xform_FAD_mouse_NoGSR*100,xform_FADCorr_mouse_NoGSR*100,xform_green_mouse_NoGSR*100,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
        %             else
        %                 QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
        %                     xform_FAD_mouse_NoGSR/3,xform_FADCorr_mouse_NoGSR/3,xform_green_mouse_NoGSR/3,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
        %                     isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
        %             end
        %             clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR
        
        
        
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
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR with 0.5 low pass');
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        disp('QC on non GSR stim')
        load(fullfile(saveDir, processedName),'ROI_NoGSR')
        %load(fullfile(saveDir,'ROI.mat'))
        if strcmp(char(sessionInfo.mouseType),'PV')
            QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
                [],[],[],[],[],[],...
                xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_NoGSR);
        else
            QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
                [],[],[],[],[],[],...
                isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
        end
        clear xofrm_datahb_mouse_NoGSR
        texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR with 0.5Hz low pass');
        output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
        disp('QC on GSR stim')
        QC_stim(squeeze(xform_datahb_mouse_GSR(:,:,1,:)),squeeze(xform_datahb_mouse_GSR(:,:,2,:)),...
            xform_gcamp_mouse_GSR,xform_gcampCorr_mouse_GSR,xform_green_mouse_GSR,[],[],[],...
            xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,[]);
        clear xofrm_datahb_mouse_GSR
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
       
        
        load(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','ROI_NoGSR')
        texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
        
        output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_NoGSR'));
        numDesample = size(xform_red_mouse_NoGSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/1);
        numDesample = factor*1;
        
%         disp('QC on non GSR stim')
%         peakMap_ROI = mean(xform_jrgeco1aCorr_mouse_NoGSR(:,:, sessionInfo.stimbaseline+1:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate),3);
%         figure
%         imagesc(peakMap_ROI)
%         axis image off
%         colormap jet
%         [X,Y] = meshgrid(1:128,1:128);
%         
%         [x1,y1] = ginput(1);
%         [x2,y2] = ginput(1);
%         
%         radius = sqrt((x1-x2)^2+(y1-y2)^2);
%         
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         min_ROI = prctile(peakMap_ROI(ROI),1);
%         temp = double(peakMap_ROI).*double(ROI);
%         ROI = temp<min_ROI*0.75;
%         hold on
%         ROI_contour = bwperim(ROI);
%         [~,c] = contour( ROI_contour,'k');
%         c.LineWidth = 0.001;
%         
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
    end
    %             if strcmp(char(sessionInfo.mouseType),'jrgeco1a')
    QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
        xform_isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_NoGSR);
    %             else
    %                 QC_stim(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
    %                     xform_FAD_mouse_NoGSR/3,xform_FADCorr_mouse_NoGSR/3,xform_green_mouse_NoGSR/3,xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
    %                     isbrain,1,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI);
    %             end
    %             clear xform_datahb_mouse_NoGSR xform_jrgeco1a_mouse_NoGSR xform_jrgeco1aCorr_mouse_NoGSR xform_red_mouse_NoGSR  xform_FAD_mouse_NoGSR xform_FADCorr_mouse_NoGSR xform_green_mouse_NoGSR
    
    
    
    %
       clear xform_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR
    close all
    
end

