close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 297:311;
runs = 1:6;
nVy = 128;
nVx = 128;


% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     rawdataloc = excelRaw{3};
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     maskDir_new = fullfile(rawdataloc,recDate);
%     maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     if strcmp(sessionType,'stim')
%         sessionInfo.stimblocksize = excelRaw{11};
%         sessionInfo.stimbaseline=excelRaw{12};
%         sessionInfo.framerate = excelRaw{7};
%         stimStartTime = sessionInfo.stimbaseline/sessionInfo.framerate;
%         info.freqout = 1;
%         disp(mouseName)
%         for n = runs
%             disp(strcat('downsampling #',num2str(n)))
%             processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%             load(fullfile(saveDir,processedName),'xform_datahb')
%             numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
%             numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
%             factor = round(numDesample/numBlock);
%             numDesample = factor*numBlock;
%
%             xform_datahb_GSR = mouse.process.gsr(xform_datahb,xform_isbrain);
%             clear xform_datahb
%             oxy_downsampled_GSR  = processAndDownsample(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,xform_isbrain,numBlock,numDesample,stimStartTime);
%             deoxy_downsampled_GSR  = processAndDownsample(squeeze(xform_datahb_GSR(:,:,2,:))*10^6,xform_isbrain,numBlock,numDesample,stimStartTime);
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'oxy_downsampled_GSR','deoxy_downsampled_GSR','xform_datahb_GSR','-append')
%             clear oxy_downsampled_GSR deoxy_downsampled_GSR xform_datahb_GSR
%
%             load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a')
%             xform_jrgeco1a_GSR = mouse.process.gsr(xform_jrgeco1a,xform_isbrain);
%             clear xform_jrgeco1a
%             jrgeco1a_downsampled_GSR  = processAndDownsample(xform_jrgeco1a_GSR*100,xform_isbrain,numBlock,numDesample,stimStartTime);
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'jrgeco1a_downsampled_GSR','xform_jrgeco1a_GSR','-append')
%             clear jrgeco1a_downsampled_GSR xform_jrgeco1a_GSR
%
%             load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1aCorr')
%             xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
%             clear xform_jrgeco1aCorr
%             jrgeco1aCorr_downsampled_GSR  = processAndDownsample(xform_jrgeco1aCorr_GSR*100,xform_isbrain,numBlock,numDesample,stimStartTime);
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'jrgeco1aCorr_downsampled_GSR','xform_jrgeco1aCorr_GSR','-append')
%             clear jrgeco1aCorr_downsampled_GSR xform_jrgeco1aCorr_GSR
%
%             load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_red')
%             xform_red_GSR = mouse.process.gsr(xform_red,xform_isbrain);
%             clear xform_red
%             red_downsampled_GSR  = processAndDownsample(xform_red_GSR*100,xform_isbrain,numBlock,numDesample,stimStartTime);
%             save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'red_downsampled_GSR','xform_red_GSR','-append')
%             clear red_downsampled_GSR xform_red_GSR
%         end
%     end
% end

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
%         load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim1','.mat')))
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
%             load(fullfile(maskDir_new,maskName_new), 'affineMarkers')
%             numBlock = size(rawdata,4)/sessionInfo.stimblocksize;
%             rawdata = reshape(rawdata,nVx,nVy,[],sessionInfo.stimblocksize,numBlock);
%             rawdata_blocks = mean(rawdata,5);
%             peakMap_ROI= process.affineTransform(rawdata(:,:,laserChan,sessionInfo.stimbaseline+1),affineMarkers) ;
%         else
%             peakMap_ROI = rawdata(:,:,laserChan,sessionInfo.stimbaseline+1);
%         end
%         clear rawdata
%         
%         imagesc(peakMap_ROI)
%         axis image off
%         colormap jet
%         if excelRow ==306|| excelRow ==308
%             [x1,y1] = ginput(1);
%         else
%             x1 = 22.8275;
%             y1 = 85.2960;
%         end
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
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         disp(strcat('#',num2str(n)))
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         disp('loading processed data')
%         load(fullfile(saveDir,processedName),'xform_datahb')
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
%             disp('loading Non GRS data')
%             if strcmp(sessionInfo.mouseType,'gcamp6f')||strcmp(sessionInfo.mouseType,'Gopto3')
%                 load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                     'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
%             elseif strcmp(sessionInfo.mouseType,'Gopto3')
%                 load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                     'xform_gcamp','xform_gcampCorr','xform_green','xform_datahb')
%             elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
%                 load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                     'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','xform_datahb')
%             elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
%                 load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
%                     'xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_datahb_GSR','oxy_downsampled_GSR','deoxy_downsampled_GSR','jrgeco1a_downsampled_GSR','jrgeco1aCorr_downsampled_GSR','red_downsampled_GSR')
%             end
%             
%             numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
%             
%             if strcmp(sessionInfo.mouseType,'PV')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')||strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')||strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')
%                 
%                 
%                 
%                 disp('loading GRS data')
%                 
%                 texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
%                 output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
%                 %   load(fullfile(saveDir,'ROI.mat'))
%                 
%                 
%                 if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
%                     [goodBlocks_GSR,ROI_GSR] = QC_stim(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,oxy_downsampled_GSR,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,deoxy_downsampled_GSR,...
%                         [],[],[],xform_jrgeco1a_GSR*100,jrgeco1a_downsampled_GSR,xform_jrgeco1aCorr_GSR*100,jrgeco1aCorr_downsampled_GSR,xform_red_GSR*100,red_downsampled_GSR,...
%                         xform_isbrain,numBlock,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI);
%                 end
%                 close all
%                 save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','ROI_GSR','peakMap_ROI','-append')
%                 
%                 
%             end
%             
%         end
%     end
%     
%     
%     
%     
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
    load(fullfile(maskDir,recDate,maskName),'xform_isbrain','isbrain');
    
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_datahb_mouse_GSR_ = [];
    xform_jrgeco1a_mouse_GSR = [];
    xform_jrgeco1aCorr_mouse_GSR = [];
    xform_red_mouse_GSR = [];
    
    
    oxy_downsampled_mouse_GSR = [];
    deoxy_downsampled_mouse_GSR = [];
    jrgeco1a_downsampled_mouse_GSR = [];
    jrgeco1aCorr_downsampled_mouse_GSR = [];
    red_downsampled_mouse_GSR = [];
    
    disp('loading GRS data')
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','xform_jrgeco1aCorr_GSR')
        numBlocks = size(xform_jrgeco1aCorr_GSR,3)/sessionInfo.stimblocksize;
        xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
        xform_jrgeco1aCorr_mouse_GSR = cat(4,xform_jrgeco1aCorr_mouse_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
        clear xform_jrgeco1a_GSR
    end
    xform_jrgeco1aCorr_mouse_GSR = mean(xform_jrgeco1aCorr_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_jrgeco1a_GSR')
        xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
        xform_jrgeco1a_mouse_GSR = cat(4,xform_jrgeco1a_mouse_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
        clear xform_jrgeco1a_GSR
    end
    xform_jrgeco1a_mouse_GSR = mean(xform_jrgeco1a_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_red_GSR')
        xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
        xform_red_mouse_GSR = cat(4,xform_red_mouse_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
        clear xform_red_GSR
    end
    xform_red_mouse_GSR = mean(xform_red_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'oxy_downsampled_GSR')
        oxy_downsampled_GSR = reshape(oxy_downsampled_GSR,info.nVx,info.nVy,[],numBlocks);
        oxy_downsampled_mouse_GSR = cat(4,oxy_downsampled_mouse_GSR,oxy_downsampled_GSR(:,:,:,goodBlocks_GSR));
        clear oxy_downsampled_GSR
    end
    oxy_downsampled_mouse_GSR = mean(oxy_downsampled_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'deoxy_downsampled_GSR')
        deoxy_downsampled_GSR = reshape(deoxy_downsampled_GSR,info.nVx,info.nVy,[],numBlocks);
        deoxy_downsampled_mouse_GSR = cat(4,deoxy_downsampled_mouse_GSR,deoxy_downsampled_GSR(:,:,:,goodBlocks_GSR));
        clear deoxy_downsampled_GSR
    end
    deoxy_downsampled_mouse_GSR = mean(deoxy_downsampled_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'jrgeco1a_downsampled_GSR')
        jrgeco1a_downsampled_GSR = reshape(jrgeco1a_downsampled_GSR,info.nVx,info.nVy,[],numBlocks);
        jrgeco1a_downsampled_mouse_GSR = cat(4,jrgeco1a_downsampled_mouse_GSR,jrgeco1a_downsampled_GSR(:,:,:,goodBlocks_GSR));
        clear jrgeco1a_downsampled_GSR
    end
    jrgeco1a_downsampled_mouse_GSR = mean(jrgeco1a_downsampled_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'jrgeco1aCorr_downsampled_GSR')
        jrgeco1aCorr_downsampled_GSR = reshape(jrgeco1aCorr_downsampled_GSR,info.nVx,info.nVy,[],numBlocks);
        jrgeco1aCorr_downsampled_mouse_GSR = cat(4,jrgeco1aCorr_downsampled_mouse_GSR,jrgeco1aCorr_downsampled_GSR(:,:,:,goodBlocks_GSR));
        clear jrgeco1aCorr_downsampled_GSR
    end
    jrgeco1aCorr_downsampled_mouse_GSR = mean(jrgeco1aCorr_downsampled_mouse_GSR,4);
    
    for n = runs
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'red_downsampled_GSR')
        red_downsampled_GSR = reshape(red_downsampled_GSR,info.nVx,info.nVy,[],numBlocks);
        red_downsampled_mouse_GSR = cat(4,red_downsampled_mouse_GSR,red_downsampled_GSR(:,:,:,goodBlocks_GSR));
        clear red_downsampled_GSR
    end
    red_downsampled_mouse_GSR = mean(red_downsampled_mouse_GSR,4);
    texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR, HbO to 1hz');
    output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','-GSR'));
    load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'ROI_GSR','peakMap_ROI')
    
    if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
       QC_stim(oxy_downsampled_mouse_GSR,oxy_downsampled_mouse_GSR,deoxy_downsampled_mouse_GSR,deoxy_downsampled_mouse_GSR,...
            [],[],[],xform_jrgeco1a_mouse_GSR*100,jrgeco1a_downsampled_mouse_GSR,xform_jrgeco1aCorr_mouse_GSR*100,jrgeco1aCorr_downsampled_mouse_GSR,xform_red_mouse_GSR*100,red_downsampled_mouse_GSR,...
            xform_isbrain,1,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_GSR);
    end
    close all
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim.mat')),'ROI_GSR','peakMap_ROI','xform_jrgeco1aCorr_mouse_GSR','xform_jrgeco1a_mouse_GSR','xform_red_mouse_GSR',...
        'oxy_downsampled_mouse_GSR','deoxy_downsampled_mouse_GSR','jrgeco1a_downsampled_mouse_GSR','jrgeco1aCorr_downsampled_mouse_GSR','red_downsampled_mouse_GSR')
    
end
