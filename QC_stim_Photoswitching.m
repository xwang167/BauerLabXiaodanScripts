close all;clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [465,467];%:450;
%runs = 1:6;
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     rawdataloc = excelRaw{3};
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
%     maskDir = saveDir;
%     load(fullfile(maskDir,maskName), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         disp(visName)
%         if exist(fullfile(saveDir,processedName),'file')
%             disp('loading processed data')
%             load(fullfile(saveDir,processedName),'xform_datahb')
%             for ii = 1:size(xform_datahb,4)
%                 xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
%                 xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
%             end
%             %             xform_datahb(isinf(xform_datahb)) = 0;
%             %             xform_datahb(isnan(xform_datahb)) = 0;
%             %             load('D:\OIS_Process\noVasculatureMask.mat')
%             %
%             %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
%             sessionInfo.stimblocksize = excelRaw{11};
%             sessionInfo.stimbaseline=excelRaw{12};
%             sessionInfo.stimduration = excelRaw{13};
%             sessionInfo.stimFrequency = excelRaw{16};
%             stimStartTime = 5;
%             info.freqout=1;
%             disp('loading Non GRS data')
%             
%             load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                 'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_Laser','xform_datahb')
%             frameInd = sessionInfo.stimbaseline+1:1/sessionInfo.stimFrequency*sessionInfo.framerate:sessionInfo.stimbaseline+sessionInfo.stimduration*sessionInfo.framerate;
%             peakMap_ROI = mean(xform_Laser(:,:,frameInd),3);
%             
%             imagesc(peakMap_ROI)
%             axis image off
%             colormap jet
%             hold on
%             load('D:\OIS_Process\atlas.mat','AtlasSeeds')
%             barrel = AtlasSeeds == 9;
%             ROI_barrel =  bwperim(barrel);
%             
%             contour(ROI_barrel,'k')
%             [X,Y] = meshgrid(1:128,1:128);
%             [~,I] = max(peakMap_ROI,[],'all','linear');
%             [y1,x1] = ind2sub([128 128],I);
%             radius = 5;
%             
%             ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%             max_ROI = prctile(peakMap_ROI(ROI),99);
%             temp = double(peakMap_ROI).*double(ROI);
%             ROI = temp>max_ROI*0.30;
%             hold on
%             ROI_contour = bwperim(ROI);
%             [~,c] = contour( ROI_contour,'r');
%             c.LineWidth = 0.001;
%             
%             saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.fig')))
%             saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'ROI.png')))
%         end
%         
%         numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
%         
%         numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
%         factor = round(numDesample/numBlock);
%         numDesample = factor*numBlock;
%         %
%         
%         disp('loading GRS data')
%         
%         texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
%         output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
%         
%         xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
%         
%         xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
%         
%         xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
%         
%         xform_red_GSR = mouse.process.gsr(xform_red,xform_isbrain);
%         
%         
%         save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%             'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','-append')
%         %                        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%         %                         'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','ROI_NoGSR')
%         
%         disp('QC on GSR stim')
%         [goodBlocks_GSR] = QC_stim_range(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,...
%             [],[],[],xform_jrgeco1a_GSR*100,xform_jrgeco1aCorr_GSR*100,xform_red_GSR*100,...
%             3,2,1,[],[],[],2,2,0.2,...
%             xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,...
%             texttitle_GSR,output_GSR,ROI,1:10);
%         texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
%         output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
%         disp('QC on non GSR stim')
%         
%         QC_stim_range(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
%             [],[],[],xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
%             6,4,5,[],[],[],4,4,0.5,...
%             xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,...
%             texttitle_NoGSR,output_NoGSR,ROI,goodBlocks_GSR);
%         
%         close all
%         save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','ROI','-append')
%         
%         
%     end
%     close all
%     
% end


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
    stimStartTime = 5;
    runs = str2num(excelRaw{18});
    info.freqout=1;
    maskDir = saveDir;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    mouseName = char(mouseName);
    load(fullfile(maskDir,maskName),'xform_isbrain','isbrain');
    
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
    
    xform_Laser_mouse_NoGSR = [];
    
    %if ~exist(fullfile(saveDir,processedName_mouse),'file')
    for n = runs
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir, processedName),'file')
            sessionInfo.stimblocksize = excelRaw{11};
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_datahb','goodBlocks_GSR')
            numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
            
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
            
            clear xform_datahb
            
            xform_datahb_baseline = mean(xform_datahb_NoGSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
            xform_datahb_baseline = repmat(xform_datahb_baseline,1,1,1,size(xform_datahb_NoGSR,4),1);
            
            xform_datahb_NoGSR = xform_datahb_NoGSR - xform_datahb_baseline;
            xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_GSR));
            
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','goodBlocks_GSR')
            
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_datahb_GSR_baseline = mean(xform_datahb_GSR(:,:,:,1:sessionInfo.stimbaseline,:),4);
            xform_datahb_GSR_baseline = repmat(xform_datahb_GSR_baseline,1,1,1,size(xform_datahb_GSR,4),1);
            xform_datahb_GSR = xform_datahb_GSR - xform_datahb_GSR_baseline;
            
            xform_datahb_mouse_GSR = cat(5,xform_datahb_mouse_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            clear xform_datahb_GSR
            
            load(fullfile(saveDir, processedName),'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_Laser')
            
            
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
            
            xform_jrgeco1a_mouse_NoGSR = cat(4,xform_jrgeco1a_mouse_NoGSR,xform_jrgeco1a(:,:,:,goodBlocks_GSR));
            clear xform_jrgeco1a
            xform_jrgeco1aCorr_mouse_NoGSR = cat(4,xform_jrgeco1aCorr_mouse_NoGSR,xform_jrgeco1aCorr(:,:,:,goodBlocks_GSR));
            clear xform_jrgeco1aCorr
            xform_red_mouse_NoGSR = cat(4,xform_red_mouse_NoGSR,xform_red(:,:,:,goodBlocks_GSR));
            clear xform_red
            xform_Laser_mouse_NoGSR = cat(4,xform_Laser_mouse_NoGSR,xform_Laser(:,:,:,goodBlocks_GSR));
            
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
            xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
            xform_jrgeco1aCorr_GSR_baseline = mean(xform_jrgeco1aCorr_GSR(:,:,1:5*sessionInfo.framerate,:),3);
            xform_jrgeco1aCorr_GSR_baseline = repmat(xform_jrgeco1aCorr_GSR_baseline,1,1,size(xform_jrgeco1aCorr_GSR,3),1);
            
            xform_jrgeco1aCorr_GSR= xform_jrgeco1aCorr_GSR-xform_jrgeco1aCorr_GSR_baseline;
            
            xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
            
            disp('loading gsr data')
            xform_jrgeco1a_mouse_GSR = cat(4,xform_jrgeco1a_mouse_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
            clear xform_jrgeco1a_GSR
            
            xform_jrgeco1aCorr_mouse_GSR = cat(4,xform_jrgeco1aCorr_mouse_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
            clear xform_jrgeco1aCorr_GSR
            xform_red_mouse_GSR = cat(4,xform_red_mouse_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
            clear xform_red_GSR
        end
    end
    xform_datahb_mouse_GSR = mean(xform_datahb_mouse_GSR,5);
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_mouse_GSR','xform_datahb_mouse_NoGSR','-v7.3');
    
    numDesample = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.framerate*info.freqout;
    factor = round(numDesample/1);
    numDesample = factor*1;
    
    xform_jrgeco1a_mouse_NoGSR = mean(xform_jrgeco1a_mouse_NoGSR,4);
    xform_jrgeco1aCorr_mouse_NoGSR = mean(xform_jrgeco1aCorr_mouse_NoGSR,4);
    xform_red_mouse_NoGSR = mean(xform_red_mouse_NoGSR,4);
    xform_Laser_mouse_NoGSR = mean(xform_Laser_mouse_NoGSR,4);
    
    
    save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_Laser_mouse_NoGSR','-append')
  
    
    numBlock = size(xform_datahb_mouse_NoGSR,4)/sessionInfo.stimblocksize;
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
    
    xform_jrgeco1a_mouse_GSR = mean(xform_jrgeco1a_mouse_GSR,4);
    xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
    xform_red_mouse_GSR = mean(xform_red_mouse_GSR,4);
    save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1aCorr_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_red_mouse_GSR','-append')
    
    %
    texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
    
    
    disp('QC on GSR stim')
    
    [goodBlocks_GSR] = QC_stim_range(squeeze(xform_datahb_mouse_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_GSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mouse_GSR*100,xform_jrgeco1aCorr_mouse_GSR*100,xform_red_mouse_GSR*100,...
        3,2,1,[],[],[],2,2,0.2,...
        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,...
        texttitle_GSR,output_GSR,ROI,1);
    texttitle_NoGSR = strcat(mouseName,'-stim'," ",'without GSR nor filtering');
    output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','-NoGSR'));
    
    disp('QC on non GSR stim')
    
    QC_stim_range(squeeze(xform_datahb_mouse_NoGSR(:,:,1,:))*10^6,squeeze(xform_datahb_mouse_NoGSR(:,:,2,:))*10^6,...
        [],[],[],xform_jrgeco1a_mouse_NoGSR*100,xform_jrgeco1aCorr_mouse_NoGSR*100,xform_red_mouse_NoGSR*100,...
        6,4,5,[],[],[],4,4,0.5,...
        xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,...
        texttitle_NoGSR,output_NoGSR,ROI,goodBlocks_GSR);
    clear xform_datahb_mouse_GSR xform_jrgeco1a_mouse_GSR xform_jrgeco1aCorr_mouse_GSR xform_red_mouse_GSR
    close all
    
end


