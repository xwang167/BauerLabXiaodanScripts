close all;clear all;clc
import mouse.*
miceName = 'ChR2-RGECO-Anes';
saveDir_cat = 'K:\OptoRGECO\Cat';
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 336:343;
runs =1:6;%6;
nVy = 128;
nVx = 128;
info.nVx = 128;
info.nVy = 128;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    maskDir_new = fullfile(rawdataloc,recDate);
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if strcmp(sessionType,'stim')
        sessionInfo.stimblocksize = excelRaw{11};
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.framerate = excelRaw{7};
        stimStartTime = sessionInfo.stimbaseline/sessionInfo.framerate;
        info.freqout = 1;
        disp(mouseName)
        for n = runs
            disp(strcat('downsampling #',num2str(n)))
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            load(fullfile(saveDir,processedName),'xform_datahb')
            numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
            numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
            factor = round(numDesample/numBlock);
            numDesample = factor*numBlock;
            for ii = 1:size(xform_datahb,4)
                xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
                xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
                
            end
            oxy_downsampled  = processAndDownsample(squeeze(xform_datahb(:,:,1,:))*10^6,xform_isbrain,numBlock,numDesample,stimStartTime);
            deoxy_downsampled = processAndDownsample(squeeze(xform_datahb(:,:,2,:))*10^6,xform_isbrain,numBlock,numDesample,stimStartTime);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'oxy_downsampled','deoxy_downsampled','-append')
            clear oxy_downsampled deoxy_downsampled
            
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a')
            jrgeco1a_downsampled  = processAndDownsample(xform_jrgeco1a*100,xform_isbrain,numBlock,numDesample,stimStartTime);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'jrgeco1a_downsampled','-append')
            clear jrgeco1a_downsampled
            
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1aCorr')
              jrgeco1aCorr_downsampled  = processAndDownsample(xform_jrgeco1aCorr*100,xform_isbrain,numBlock,numDesample,stimStartTime);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'jrgeco1aCorr_downsampled','-append')
            clear jrgeco1aCorr_downsampled
            
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_red')
            red_downsampled  = processAndDownsample(xform_red*100,xform_isbrain,numBlock,numDesample,stimStartTime);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'red_downsampled','-append')
            clear red_downsampled
        end
    end
end
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     rawdataloc = excelRaw{3};
%     maskDir_new = fullfile(rawdataloc,recDate);
%     %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%     
%     
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     %load(fullfile(maskDir,maskName), 'xform_isbrain')
%     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
%     load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
%     xform_isbrain = double(xform_isbrain);
%     if ~isempty(find(isnan(xform_isbrain), 1))
%         xform_isbrain(isnan(xform_isbrain))=0;
%     end
%     if strcmp(sessionType,'stim')
%         sessionInfo.stimblocksize = excelRaw{11};
%         sessionInfo.stimbaseline=excelRaw{12};
%         sessionInfo.stimduration = excelRaw{13};
%         sessionInfo.stimFrequency = excelRaw{16};
%         stimStartTime = sessionInfo.stimbaseline/sessionInfo.framerate;
%         info.freqout=1;
%         
%         
%         switch sessionInfo.mouseType
%             case 'PV'
%                 laserChan = 3;
%             case 'jrgeco1a-opto2'
%                 laserChan = 3;
%             case 'jrgeco1a-opto3'
%                 laserChan = 4;
%             case 'Gopto3'
%                 laserChan = 1;
%             case 'Wopto3'
%                 laserChan = 1;
%         end
%         if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
%             load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim1','.mat')))
%             load(fullfile(maskDir_new,maskName_new), 'affineMarkers')
%             numBlock = size(rawdata,4)/sessionInfo.stimblocksize;
%             rawdata = reshape(rawdata,nVx,nVy,[],sessionInfo.stimblocksize,numBlock);
%             rawdata_blocks = mean(rawdata,5);
%             peakMap_ROI= process.affineTransform(rawdata(:,:,laserChan,sessionInfo.stimbaseline+1),affineMarkers) ;
%             clear rawdata
%         else
%             processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%             
%             load(fullfile(saveDir,processedName),'xform_Laser')
%             
%             numBlocks = size(xform_Laser,3)/sessionInfo.stimblocksize;
%             xform_Laser = reshape(xform_Laser,128,128,[],numBlocks);
%             xform_Laser = mean(xform_Laser,4);
%             peakMap_ROI = xform_Laser(:,:,sessionInfo.stimbaseline+1);
%         end
%         
%         
%         imagesc(peakMap_ROI)
%         axis image off
%         colormap jet
%         maximum = max(max(peakMap_ROI));
%         [y1,x1]=find(peakMap_ROI==maximum);
%         [X,Y] = meshgrid(1:128,1:128);
%         radius = 5;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         max_ROI = prctile(peakMap_ROI(ROI),70);
%         temp = double(peakMap_ROI).*double(ROI);
%         ROI = temp>=max_ROI;
%         hold on
%         ROI_contour = bwperim(ROI);
%         contour( ROI_contour,'k');
%         %                 pause;
%         %                 nonROI = roipoly();
%         %                 ROI(nonROI) = 0;
%         %                 figure;
%         %                 imagesc(peakMap_ROI)
%         %                 axis image off
%         %                 colormap jet
%         %                 hold on
%         %                 ROI_contour = bwperim(ROI);
%         %                 contour( ROI_contour,'k');
%         
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stimROI.fig')))
%         saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-stimROI.png')))
%     end
%     
%     
%     
%     disp(mouseName)
%     
%     
%     
%     for n = runs
%         rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%         load(fullfile(saveDir,rawName),'InstMvMt_detrend','LTMvMt_detrend')
%         
%         
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         disp(strcat('#',num2str(n)))
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         disp('loading processed data')
%         load(fullfile(saveDir,processedName),'xform_datahb')
%         
%         for ii = 1:size(xform_datahb,4)
%             xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
%             xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
%         end
%         
%         if strcmp(sessionType,'stim')
%             xform_datahb(isinf(xform_datahb)) = 0;
%             xform_datahb(isnan(xform_datahb)) = 0;
%             %             load('D:\OIS_Process\noVasculatureMask.mat')
%             %
%             %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
%             
%             disp('loading Non GSR data')
%            if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
%                 load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                     'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_datahb','oxy_downsampled','deoxy_downsampled','jrgeco1a_downsampled','jrgeco1aCorr_downsampled','red_downsampled')
%             end
%             
%             numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
%             
%             if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')||strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')
%                                                      
%                 texttitle = strcat(mouseName,'-stim',num2str(n)," ",'without GSR without filtering');
%                 output= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
%                 %   load(fullfile(saveDir,'ROI.mat'))
%                 
%                 goodBlocks = 1;
% %                 if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
% %                     [goodBlocks] = QC_stim(squeeze(xform_datahb(:,:,1,:))*10^6,oxy_downsampled,squeeze(xform_datahb(:,:,2,:))*10^6,deoxy_downsampled,...
% %                         [],[],[],xform_jrgeco1a*100,jrgeco1a_downsampled,xform_jrgeco1aCorr*100,jrgeco1aCorr_downsampled,xform_red*100,red_downsampled,...
% %                         xform_isbrain,numBlock,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle,output,ROI,...
% %                         InstMvMt_detrend,LTMvMt_detrend);
% %                 end
%                 close all
%                 save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','ROI','peakMap_ROI','-append')
%                 
%                 
%             end
%             
%         end
%     end    
% end


for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    disp(mouseName)
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    stimStartTime = sessionInfo.stimbaseline/sessionInfo.framerate;
    info.freqout=1;
    
    
    maskDir = rawdataloc;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain','isbrain');
    
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_datahb_mouse = [];
        xform_jrgeco1a_mouse = [];
        xform_jrgeco1aCorr_mouse = [];
        xform_red_mouse = [];
    
    
        oxy_downsampled_mouse = [];
        deoxy_downsampled_mouse = [];
        jrgeco1a_downsampled_mouse = [];
        jrgeco1aCorr_downsampled_mouse = [];
        red_downsampled_mouse = [];
    
    disp('loading non GRS hb data')
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','xform_datahb')

        
        numBlocks = size(xform_datahb,4)/sessionInfo.stimblocksize;
        goodBlocks = 1:numBlocks;
        xform_datahb = reshape(xform_datahb,128,128,2,[],numBlocks);
        xform_datahb_mouse = cat(5,xform_datahb_mouse,xform_datahb(:,:,:,:,goodBlocks));
        
    end
    xform_datahb_mouse = mean( xform_datahb_mouse,5);
    
    disp('loading Non GRS jrgeco data')
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','xform_jrgeco1aCorr')
             numBlocks = size(xform_jrgeco1aCorr,3)/sessionInfo.stimblocksize;
             goodBlocks = 1:numBlocks;
            xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
            xform_jrgeco1aCorr_mouse = cat(4,xform_jrgeco1aCorr_mouse,xform_jrgeco1aCorr(:,:,:,goodBlocks));
            clear xform_jrgeco1a
        end
        xform_jrgeco1aCorr_mouse = mean(xform_jrgeco1aCorr_mouse,4);
    disp('loading Non GRS jrgecoorr data')
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','xform_jrgeco1a')
             numBlocks = size(xform_jrgeco1a,3)/sessionInfo.stimblocksize;
             goodBlocks = 1:numBlocks;
            xform_jrgeco1a = reshape(xform_jrgeco1a,128,128,[],numBlocks);
            xform_jrgeco1a_mouse = cat(4,xform_jrgeco1a_mouse,xform_jrgeco1a(:,:,:,goodBlocks));
            clear xform_jrgeco1a
        end
        xform_jrgeco1a_mouse = mean(xform_jrgeco1a_mouse,4);
    disp('loading Non GRS red data')
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','xform_red')
             numBlocks = size(xform_red,3)/sessionInfo.stimblocksize;
             goodBlocks = 1:numBlocks;
            xform_red = reshape(xform_red,128,128,[],numBlocks);
            xform_red_mouse = cat(4,xform_red_mouse,xform_red(:,:,:,goodBlocks));
            clear xform_red
        end
        xform_red_mouse = mean(xform_red_mouse,4);
    
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','oxy_downsampled')
            goodBlocks = 1:size(oxy_downsampled,4);
            oxy_downsampled_mouse = cat(4,oxy_downsampled_mouse,oxy_downsampled(:,:,:,goodBlocks));
            clear oxy_downsampled
        end
        oxy_downsampled_mouse = mean(oxy_downsampled_mouse,4);
    
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','deoxy_downsampled')
            goodBlocks = 1:size(deoxy_downsampled,4);  
            deoxy_downsampled_mouse = cat(4,deoxy_downsampled_mouse,deoxy_downsampled(:,:,:,goodBlocks));
            clear deoxy_downsampled
        end
        deoxy_downsampled_mouse = mean(deoxy_downsampled_mouse,4);
    
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','jrgeco1a_downsampled')
            goodBlocks = 1:size(jrgeco1a_downsampled,4);         
            jrgeco1a_downsampled_mouse = cat(4,jrgeco1a_downsampled_mouse,jrgeco1a_downsampled(:,:,:,goodBlocks));
            clear jrgeco1a_downsampled
        end
        jrgeco1a_downsampled_mouse = mean(jrgeco1a_downsampled_mouse,4);
    
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','jrgeco1aCorr_downsampled')
             goodBlocks = 1:size(jrgeco1aCorr_downsampled,4);         
        
            jrgeco1aCorr_downsampled_mouse = cat(4,jrgeco1aCorr_downsampled_mouse,jrgeco1aCorr_downsampled(:,:,:,goodBlocks));
            clear jrgeco1aCorr_downsampled
        end
        jrgeco1aCorr_downsampled_mouse = mean(jrgeco1aCorr_downsampled_mouse,4);
    
        for n = runs
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks','red_downsampled')
             goodBlocks = 1:size(red_downsampled,4);         
            red_downsampled_mouse = cat(4,red_downsampled_mouse,red_downsampled(:,:,:,goodBlocks));
            clear red_downsampled
        end
        red_downsampled_mouse = mean(red_downsampled_mouse,4);
    texttitle = strcat(mouseName,'-stim-allBlocks'," ",'without GSR nor filtering');
    output= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','-NoGSR-allBlocks'));
           load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim2','_processed')),'ROI_GSR')

    if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
        QC_stim(squeeze(xform_datahb_mouse(:,:,1,:))*10^6,oxy_downsampled_mouse,squeeze(xform_datahb_mouse(:,:,2,:))*10^6,deoxy_downsampled_mouse,...
            [],[],[],xform_jrgeco1a_mouse*100,jrgeco1a_downsampled_mouse,xform_jrgeco1aCorr_mouse*100,jrgeco1aCorr_downsampled_mouse,xform_red_mouse*100,red_downsampled_mouse,...
            xform_isbrain,1,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle,output,ROI_GSR,[],[]);
    end
    close all
        save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'ROI_GSR','xform_datahb_mouse','xform_jrgeco1aCorr_mouse','xform_jrgeco1a_mouse','xform_red_mouse',...
            'oxy_downsampled_mouse','deoxy_downsampled_mouse','jrgeco1a_downsampled_mouse','jrgeco1aCorr_downsampled_mouse','red_downsampled_mouse','-append')

    clear xform_datahb_mouse
    
    
end

xform_datahb_mice = [];
xform_jrgeco1a_mice = [];
xform_jrgeco1aCorr_mice = [];
xform_red_mice = [];


oxy_downsampled_mice = [];
deoxy_downsampled_mice = [];
jrgeco1a_downsampled_mice = [];
jrgeco1aCorr_downsampled_mice = [];
red_downsampled_mice = [];

xform_isbrain_mice = ones(info.nVy,info.nVx);

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    disp(mouseName)
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
    sessionInfo.framerate = excelRaw{7};
    stimStartTime = sessionInfo.stimbaseline/sessionInfo.framerate;
    info.freqout=1;
    maskDir = rawdataloc;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain');
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
        disp('loading non GRS data')
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'xform_jrgeco1aCorr_mouse')
        numBlocks = size(xform_jrgeco1aCorr_mouse,3)/sessionInfo.stimblocksize;
        xform_jrgeco1aCorr_mouse = reshape(xform_jrgeco1aCorr_mouse,128,128,[],numBlocks);
        xform_jrgeco1aCorr_mice = cat(4,xform_jrgeco1aCorr_mice,xform_jrgeco1aCorr_mouse);
        clear xform_jrgeco1a_mouse
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'xform_jrgeco1aCorr_mouse')
        xform_jrgeco1aCorr_mouse = reshape(xform_jrgeco1aCorr_mouse,128,128,[],numBlocks);
        xform_jrgeco1aCorr_mice = cat(4,xform_jrgeco1aCorr_mice,xform_jrgeco1aCorr_mouse);
        clear xform_jrgeco1a_mouse
    
    
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'xform_jrgeco1a_mouse')
        xform_jrgeco1a_mouse = reshape(xform_jrgeco1a_mouse,128,128,[],numBlocks);
        xform_jrgeco1a_mice = cat(4,xform_jrgeco1a_mice,xform_jrgeco1a_mouse);
        clear xform_jrgeco1a_mouse
    
    
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'xform_red_mouse')
        xform_red_mouse = reshape(xform_red_mouse,128,128,[],numBlocks);
        xform_red_mice = cat(4,xform_red_mice,xform_red_mouse);
        clear xform_red_mouse
    
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'xform_datahb_mouse')
    xform_datahb_mouse = reshape(xform_datahb_mouse,128,128,2,[],numBlocks);
    xform_datahb_mice = cat(5,xform_datahb_mice,xform_datahb_mouse);
    clear xform_datahb_mouse
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'oxy_downsampled_mouse')
        oxy_downsampled_mouse = reshape(oxy_downsampled_mouse,info.nVx,info.nVy,[],numBlocks);
        oxy_downsampled_mice = cat(4,oxy_downsampled_mice,oxy_downsampled_mouse);
        clear oxy_downsampled_mouse
    
    
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'deoxy_downsampled_mouse')
        deoxy_downsampled_mouse = reshape(deoxy_downsampled_mouse,info.nVx,info.nVy,[],numBlocks);
        deoxy_downsampled_mice = cat(4,deoxy_downsampled_mice,deoxy_downsampled_mouse);
        clear deoxy_downsampled_mouse
    
    
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'jrgeco1a_downsampled_mouse')
        jrgeco1a_downsampled_mouse = reshape(jrgeco1a_downsampled_mouse,info.nVx,info.nVy,[],numBlocks);
        jrgeco1a_downsampled_mice = cat(4,jrgeco1a_downsampled_mice,jrgeco1a_downsampled_mouse);
        clear jrgeco1a_downsampled_mouse
    
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'jrgeco1aCorr_downsampled_mouse')
        jrgeco1aCorr_downsampled_mouse = reshape(jrgeco1aCorr_downsampled_mouse,info.nVx,info.nVy,[],numBlocks);
        jrgeco1aCorr_downsampled_mice = cat(4,jrgeco1aCorr_downsampled_mice,jrgeco1aCorr_downsampled_mouse);
        clear jrgeco1aCorr_downsampled_mouse
    
    
    
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim-allBlocks.mat')),'red_downsampled_mouse')
        red_downsampled_mouse = reshape(red_downsampled_mouse,info.nVx,info.nVy,[],numBlocks);
        red_downsampled_mice = cat(4,red_downsampled_mice,red_downsampled_mouse);
        clear red_downsampled_mouse
    
end
load(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim-allBlocks.mat')),'ROI','peakMap_ROI_mice')
xform_jrgeco1aCorr_mice = mean(xform_jrgeco1aCorr_mice,4);
xform_jrgeco1a_mice = mean(xform_jrgeco1a_mice,4);
xform_red_mice = mean(xform_red_mice,4);
xform_datahb_mice = mean(xform_datahb_mice,5);
%
oxy_downsampled_mice = mean(oxy_downsampled_mice,4);
deoxy_downsampled_mice = mean(deoxy_downsampled_mice,4);
jrgeco1a_downsampled_mice = mean(jrgeco1a_downsampled_mice,4);
jrgeco1aCorr_downsampled_mice = mean(jrgeco1aCorr_downsampled_mice,4);
red_downsampled_mice = mean(red_downsampled_mice,4);
save(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim-allBlocks.mat')),'peakMap_ROI_mice','xform_datahb_mice','xform_jrgeco1aCorr_mice','xform_jrgeco1a_mice','xform_red_mice',...
    'oxy_downsampled_mice','deoxy_downsampled_mice','jrgeco1a_downsampled_mice','jrgeco1aCorr_downsampled_mice','red_downsampled_mice','-append')

if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
    texttitle = strcat(miceName,'-stim-allBlocks'," ",'without GSR nor filtering');
    output= fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim-allBlocks','-NoGSR'));
   QC_stim(squeeze(xform_datahb_mice(:,:,1,:))*10^6,oxy_downsampled_mice,squeeze(xform_datahb_mice(:,:,2,:))*10^6,deoxy_downsampled_mice,...
            [],[],[],xform_jrgeco1a_mice*100,jrgeco1a_downsampled_mice,xform_jrgeco1aCorr_mice*100,jrgeco1aCorr_downsampled_mice,xform_red_mice*100,red_downsampled_mice,...
            xform_isbrain_mice,1,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle,output,ROI,[],[]);    
end
close all



miceName = 'ChR2-RGECO-Awake';
saveDir_cat = 'K:\OptoRGECO\Cat';
recDate = "200217";
load(fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim-allBlocks.mat')),'peakMap_ROI_mice','xform_datahb_mice','xform_jrgeco1aCorr_mice','xform_jrgeco1a_mice','xform_red_mice',...
    'oxy_downsampled_mice','deoxy_downsampled_mice','jrgeco1a_downsampled_mice','jrgeco1aCorr_downsampled_mice','red_downsampled_mice')
   texttitle = strcat(miceName,'-stim-allBlocks'," ",'without GSR nor filtering');
    output= fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-stim-allBlocks','-NoGSR'));
   QC_stim(squeeze(xform_datahb_mice(:,:,1,:))*10^6,oxy_downsampled_mice,squeeze(xform_datahb_mice(:,:,2,:))*10^6,deoxy_downsampled_mice,...
            [],[],[],xform_jrgeco1a_mice*100,jrgeco1a_downsampled_mice,xform_jrgeco1aCorr_mice*100,jrgeco1aCorr_downsampled_mice,xform_red_mice*100,red_downsampled_mice,...
            xform_isbrain_mice,1,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle,output,ROI,[],[]);    

        
 QC_stim(squeeze(xform_datahb_mice(:,:,1,:))*10^6,oxy_downsampled_mice,squeeze(xform_datahb_mice(:,:,2,:))*10^6,deoxy_downsampled_mice,...
            [],[],[],xform_jrgeco1a_mice*100,jrgeco1a_downsampled_mice,xform_jrgeco1aCorr_mice*100,jrgeco1aCorr_downsampled_mice,xform_red_mice*100,red_downsampled_mice,...
            xform_isbrain_mice,1,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle,output,ROI_flip_NonChR2_Awake,[],[]);    
