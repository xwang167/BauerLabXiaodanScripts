
close all;clearvars;clc
excelRows = [182 184 186 203 205];%[124 126 127 128 130 132 134 136];
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


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
    
    
    if strcmp(systemType,'EastOIS2')
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 4;
        end
        
    elseif strcmp(systemType,'EastOIS1_Fluor')
        
        sessionInfo.hbSpecies = 2:4;
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.fluorSpecies = 1;
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 4;
        end
    end
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    
    xform_datahb_runs_GSR = [];
    xform_gcamp_runs_GSR = [];
    xform_gcampCorr_runs_GSR = [];
    xform_jrgeco1a_runs_GSR = [];
    xform_jrgeco1aCorr_runs_GSR = [];
    xform_red_runs_GSR = [];
    xform_green_runs_GSR = [];
    xform_datahb_runs_NoGSR = [];
    xform_gcamp_runs_NoGSR = [];
    xform_gcampCorr_runs_NoGSR = [];
    xform_jrgeco1a_runs_NoGSR = [];
    xform_jrgeco1aCorr_runs_NoGSR = [];
    xform_red_runs_NoGSR = [];
    xform_green_runs_NoGSR = [];
    %if ~exist(fullfile(saveDir,processedName_mouse),'file')
    for n = 1:3
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.stimblocksize = excelRaw{11};
            numBlocks = size(xform_datahb_GSR,4)/sessionInfo.stimblocksize;
            
            
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','goodBlocks_GSR')
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_gcamp_GSR = reshape(xform_gcamp_GSR,128,128,[],numBlocks);
            xform_gcampCorr_GSR = reshape(xform_gcampCorr_GSR,128,128,[],numBlocks);
            xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
            
            xform_datahb_runs_GSR = cat(5,xform_datahb_runs_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            xform_gcamp_runs_GSR = cat(4,xform_gcamp_runs_GSR,xform_gcamp_GSR(:,:,:,goodBlocks_GSR));
            xform_gcampCorr_runs_GSR = cat(4,xform_gcampCorr_runs_GSR,xform_gcampCorr_GSR(:,:,:,goodBlocks_GSR));
            xform_green_runs_GSR = cat(4,xform_green_runs_GSR,xform_green_GSR(:,:,:,goodBlocks_GSR));
            
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','xform_green','goodBlocks_NoGSR')
            
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
            xform_gcamp_NoGSR = reshape(xform_gcamp,128,128,[],numBlocks);
            xform_gcampCorr_NoGSR = reshape(xform_gcampCorr,128,128,[],numBlocks);
            xform_green_NoGSR = reshape(xform_green,128,128,[],numBlocks);
            
            xform_datahb_runs_NoGSR = cat(5,xform_datahb_runs_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
            xform_gcamp_runs_NoGSR = cat(4,xform_gcamp_runs_NoGSR,xform_gcamp_NoGSR(:,:,:,goodBlocks_NoGSR));
            xform_gcampCorr_runs_NoGSR = cat(4,xform_gcampCorr_runs_NoGSR,xform_gcampCorr_NoGSR(:,:,:,goodBlocks_NoGSR));
            xform_green_runs_NoGSR = cat(4,xform_green_runs_NoGSR,xform_green_NoGSR(:,:,:,goodBlocks_NoGSR));
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','goodBlocks_GSR')
            sessionInfo.stimblocksize = excelRaw{11};
            numBlocks = size(xform_datahb_GSR,4)/sessionInfo.stimblocksize;
            xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
            xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
            xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
            xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
            
            xform_datahb_runs_GSR = cat(5,xform_datahb_runs_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
            xform_jrgeco1a_runs_GSR = cat(4,xform_jrgeco1a_runs_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
            xform_jrgeco1aCorr_runs_GSR = cat(4,xform_jrgeco1aCorr_runs_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
            xform_red_runs_GSR = cat(4,xform_red_runs_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
            
            clear xform_datahb_GSR xform_jrgeco1a_GSR xform_jrgeco1aCorr_GSR
            disp('loading processed data')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','goodBlocks_NoGSR')

            
            xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
            xform_jrgeco1a_NoGSR = reshape(xform_jrgeco1a,128,128,[],numBlocks);
            xform_jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
            xform_red_NoGSR = reshape(xform_red,128,128,[],numBlocks);
            
            xform_datahb_runs_NoGSR = cat(5,xform_datahb_runs_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
            xform_jrgeco1a_runs_NoGSR = cat(4,xform_jrgeco1a_runs_NoGSR,xform_jrgeco1a_NoGSR(:,:,:,goodBlocks_NoGSR));
            xform_jrgeco1aCorr_runs_NoGSR = cat(4,xform_jrgeco1aCorr_runs_NoGSR,xform_jrgeco1aCorr_NoGSR(:,:,:,goodBlocks_NoGSR));
            xform_red_runs_NoGSR = cat(4,xform_red_runs_NoGSR,xform_red_NoGSR(:,:,:,goodBlocks_NoGSR));
            
            
        elseif strcmp(char(sessionInfo.mouseType),'WT')
            load(fullfile(saveDir, processedName),'xform_datahb_GSR','goodBlocks_GSR')
            if ~isempty(goodBlocks_GSR)
                temp = reshape(xform_datahb_GSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                temp_goodBlocks_GSR = temp(:,:,:,:,goodBlocks_GSR);
                xform_datahb_runs_GSR = cat(5,xform_datahb_runs_GSR,temp_goodBlocks_GSR);
                load(fullfile(saveDir, processedName),'xform_datahb_NoGSR','goodBlocks_NoGSR')
                if ~isempty(goodBlocks_NoGSR)
                    temp = reshape(xform_datahb_NoGSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                    temp_goodBlocks = temp(:,:,:,:,goodBlocks_NoGSR);
                    xform_datahb_runs_NoGSR = cat(5,xform_datahb_runs_NoGSR,temp_goodBLocks);
                end
                
            end
        end
    end
    xform_datahb_runs_GSR = mean(xform_datahb_runs_GSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_runs_GSR');
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        xform_gcamp_runs_GSR = mean(xform_gcamp_runs_GSR,4);
        xform_gcampCorr_runs_GSR = mean(xform_gcampCorr_runs_GSR,4);
        xform_green_runs_GSR = mean(xform_green_runs_GSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_gcamp_runs_GSR','xform_gcampCorr_runs_GSR','xform_green_runs_GSR','-append');
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1a_runs_GSR = mean(xform_jrgeco1a_runs_GSR,4);
        xform_jrgeco1aCorr_runs_GSR = mean(xform_jrgeco1aCorr_runs_GSR,4);
        xform_red_runs_GSR = mean(xform_red_runs_GSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_runs_GSR','xform_jrgeco1aCorr_runs_GSR','xform_red_runs_GSR','-append')
        
        %        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_runs','xform_jrgeco1aCorr_runs','xform_red_runs','-append')
    end
    
    xform_datahb_runs_NoGSR = mean(xform_datahb_runs_NoGSR,5);
    save(fullfile(saveDir,processedName_mouse),'xform_datahb_runs_NoGSR','-append');
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        xform_gcamp_runs_NoGSR = mean(xform_gcamp_runs_GSR,4);
        xform_gcampCorr_runs_NoGSR = mean(xform_gcampCorr_runs_NoGSR,4);
        xform_green_runs_NoGSR = mean(xform_green_runs_NoGSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_gcamp_runs_NoGSR','xform_gcampCorr_runs_NoGSR','xform_green_runs_NoGSR','-append');
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1a_runs_NoGSR = mean(xform_jrgeco1a_runs_NoGSR,4);
        xform_jrgeco1aCorr_runs_NoGSR = mean(xform_jrgeco1aCorr_runs_NoGSR,4);
        xform_red_runs_NoGSR = mean(xform_red_runs_NoGSR,4);
        save(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_runs_NoGSR','xform_jrgeco1aCorr_runs_NoGSR','xform_red_runs_NoGSR','-append')
    end
    %     else
    %         load(fullfile(saveDir,processedName_mouse))
    %     end
    %
    %
    
    
    
    
    
    oxy_GSR = double(squeeze(xform_datahb_runs_GSR(:,:,1,:)));
    deoxy_GSR = double(squeeze(xform_datahb_runs_GSR(:,:,2,:)));
    total_GSR = double(oxy_GSR+deoxy_GSR);
    
    clear xform_datahb_runs
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp_GSR = double(xform_gcamp_runs_GSR);
        gcampCorr_GSR = double(xform_gcampCorr_runs_GSR);
        green_GSR = double(xform_green_runs_GSR);
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        jrgeco1a_GSR = double(xform_jrgeco1a_runs_GSR);
        jrgeco1aCorr_GSR = double(xform_jrgeco1aCorr_runs_GSR);
        red_GSR = double(xform_red_runs_GSR);
    end
    
    
    xform_isbrain = double(xform_isbrain);
    xform_isbrain(xform_isbrain==2)=1;
    oxy_GSR = oxy_GSR.*xform_isbrain;
    deoxy_GSR = deoxy_GSR.*xform_isbrain;
    total_GSR = total_GSR .*xform_isbrain;
    
    oxy_GSR(isnan(oxy_GSR)) = 0;
    deoxy_GSR(isnan(deoxy_GSR)) = 0;
    total_GSR(isnan(total_GSR)) = 0;
    
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp_GSR= gcamp_GSR.*xform_isbrain;
        gcampCorr_GSR = gcampCorr_GSR.*xform_isbrain;
        green_GSR = green_GSR.*xform_isbrain;
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        jrgeco1a_GSR = jrgeco1a_GSR.*xform_isbrain;
        jrgeco1aCorr_GSR = jrgeco1aCorr_GSR.*xform_isbrain;
        red_GSR = red_GSR.*xform_isbrain;
        
            jrgeco1a_GSR(isnan(jrgeco1a_GSR)) = 0;
    jrgeco1aCorr_GSR(isnan(jrgeco1aCorr_GSR)) = 0;
    red_GSR(isnan(red_GSR)) = 0;
    end
    
    
    
    
    
    
    
    
    % Block Average
    texttitle_GSR = strcat(mouseName,'-stim'," ",'with GSR without filtering');
    output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim','_GSR'));
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        [oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,~,~,~, gcampCorr_downsampled_GSR,gcamp_downsampled_GSR, temp_gcampCorr_max_GSR] = fluor.pickGoodBlocks(double(oxy_GSR),double(deoxy_GSR),double(total_GSR),info.freqout,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr',double(gcampCorr_GSR),'gcamp',double(gcamp_GSR));
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        [oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,jrgeco1aCorr_downsampled_GSR,jrgeco1a_downsampled_GSR, temp_jrgeco1aCorr_max_GSR,~,~,~] = fluor.pickGoodBlocks(double(oxy_GSR),double(deoxy_GSR),double(total_GSR),info.freqout,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr',double(jrgeco1aCorr_GSR),'jrgeco1a',double(jrgeco1a_GSR));
        numBlock = size(red_GSR,3)/sessionInfo.stimblocksize;
        
        
        numDesample = size(red_GSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/numBlock);
        numDesample = factor*numBlock;
        red_downsampled_GSR = resampledata(red_GSR,size(red_GSR,3),numDesample,10^-5);


    elseif strcmp(char(sessionInfo.mouseType),'WT')
        [oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime] = fluor.pickGoodBlocks(oxy_GSR,deoxy_GSR,total_GSR,info.freqout,sessionInfo,output_GSR,texttitle_GSR);
    end
    if ~isempty(goodBlocks_GSR)
        
        %block average
          
        
        
        
        
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcampCorr_blocks_downsampled = mean(gcampCorr_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
            gcamp_downsampled_GSR = mean(gcamp_downsampled_GSR(:,:,:,goodBlocks_GSR),4);
            
            [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,~,ROI_gcampCorr,AvggcampCorr_stim] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR);
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')

            
            [~,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,ROI_jrgeco1aCorr_GSR,Avgjrgeco1aCorr_stim,~,~] = fluor.generatePeakMapandROI(oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_GSR,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_GSR);
            
        elseif strcmp(char(sessionInfo.mouseType),'WT')
            [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,stimStartTime,stimEndTime);
        end
        
        
        
         
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcampCorr_GSR = reshape(gcampCorr_GSR,size(oxy_GSR,1),size(oxy_GSR,2),[],numBlock);
            gcamp_GSR = reshape(gcamp_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
            green_GSR = reshape(green_GSR,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
            gcampCorr_blocks_GSR = mean(gcampCorr_GSR(:,:,:,goodBlocks_GSR),4);
            gcamp_blocks_GSR = mean(gcamp_GSR(:,:,:,goodBlocks_GSR),4);
            green_blocks_GSR = mean(green_GSR(:,:,:,goodBlocks_GSR),4);
            %                                         if isnan(excelRaw(20))
            fluor.traceImagePlot(oxy_GSR,deoxy_GSR,total_GSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_blocks_GSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_downsampled_NoGSR,'gcamp_blocks',gcamp_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain)
            %                     else
            %                         fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_blocks_GSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_GSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_blocks_downsampled,'gcamp_blocks',gcamp_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
            %                     end
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')

            %                     if isnan(excelRaw(20))
            fluor.traceImagePlot(oxy_GSR,deoxy_GSR,total_GSR,oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_GSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_GSR,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_GSR,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr_GSR,'jrgeco1a_blocks_downsampled',jrgeco1a_downsampled_GSR,'red_blocks_downsampled',red_downsampled_GSR,'jrgeco1a_blocks',jrgeco1a_GSR,'red_blocks',red_GSR,'xform_isbrain',xform_isbrain)
            %                     else
            %                         fluor.traceImagePlot(oxy_blocks_GSR,deoxy_blocks_GSR,total_blocks_GSR,oxy_blocks_downsampled,deoxy_blocks_downsampled,total_blocks_downsampled,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_blocks_GSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_blocks_downsampled,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_GSR,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr,'jrgeco1a_blocks_downsampled',jrgeco1a_blocks_downsampled,'jrgeco1a_blocks',jrgeco1a_blocks_GSR,'green_blocks',green_blocks_GSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
            %                     end
            
        elseif strcmp(char(sessionInfo.mouseType),'WT')
            fluor.traceImagePlot(oxy_GSR,deoxy_GSR,total_GSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_GSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_GSR,temp_deoxy_max_GSR,temp_total_max_GSR,sessionInfo,output_GSR,texttitle_GSR,'ROI_total',ROI_total)
        end
    end
    
    %% No GSR
    oxy_NoGSR = double(squeeze(xform_datahb_runs_NoGSR(:,:,1,:)));
    deoxy_NoGSR = double(squeeze(xform_datahb_runs_NoGSR(:,:,2,:)));
    total_NoGSR = double(oxy_NoGSR+deoxy_NoGSR);
    
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        
        gcamp_NoGSR = double(xform_gcamp_runs_NoGSR);
        clear xform_gcamp
        gcampCorr_NoGSR = double(xform_gcampCorr_runs_NoGSR);
        clear xform_gcampCorr
        green_NoGSR = double(xform_green_runs_NoGSR);
        clear xform_green
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        
        jrgeco1a_NoGSR = double(xform_jrgeco1a_runs_NoGSR);
        clear xform_jrgeco1a
        jrgeco1aCorr_NoGSR = double(xform_jrgeco1aCorr_runs_NoGSR);
        clear xform_jrgeco1aCorr
        red_NoGSR = double(xform_red_runs_NoGSR);
        clear xform_red
    end
    
    xform_isbrain = double(xform_isbrain);
    
    oxy_NoGSR = oxy_NoGSR.*xform_isbrain;
    deoxy_NoGSR = deoxy_NoGSR.*xform_isbrain;
    total_NoGSR = total_NoGSR .*xform_isbrain;
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp_NoGSR = gcamp_NoGSR.*xform_isbrain;
        gcampCorr_NoGSR = gcampCorr_NoGSR.*xform_isbrain;
        green_NoGSR = green_NoGSR.*xform_isbrain;
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        jrgeco1a_NoGSR = jrgeco1a_NoGSR.*xform_isbrain;
        jrgeco1aCorr_NoGSR = jrgeco1aCorr_NoGSR.*xform_isbrain;
        red_NoGSR = red_NoGSR.*xform_isbrain;
    end
    
    oxy_NoGSR(isnan(oxy_NoGSR)) = 0;
    deoxy_NoGSR(isnan(deoxy_NoGSR)) = 0;
    total_NoGSR(isnan(total_NoGSR)) = 0;
    
    
    
    R=mod(size(oxy_NoGSR,3),sessionInfo.stimblocksize);
    if R~=0
        pad=sessionInfo.stimblocksize-R;
        disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
        oxy_NoGSR(:,:,end:end+pad)=0;
        deoxy_NoGSR(:,:,end:end+pad)=0;
        total_NoGSR(:,:,end:end+pad)=0;
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcamp_NoGSR(:,:,end:end+pad)=0;
            gcampCorr_NoGSR(:,:,end:end+pad)=0;
            
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            jrgeco1a_NoGSR(:,:,end:end+pad)=0;
            jrgeco1aCorr_NoGSR(:,:,end:end+pad)=0;
            
        end
    end
    
    
    %             oxy_NoGSR = reshape(oxy_NoGSR,128,128,[],10);
    %             deoxy_NoGSR = reshape(deoxy_NoGSR,128,128,[],10);
    %             total_NoGSR = reshape(total_NoGSR,128,128,[],10);
    
    
    % Block Average
    texttitle_NoGSR = strcat(miceName,'-stim'," ",'without GSR');
    output_NoGSR= fullfile(saveDir,strcat(recDate,'-',miceName,'-stim','_NoGSR'));
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        [oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,~,~,~, gcampCorr_downsampled_NoGSR,gcamp_downsampled_NoGSR, temp_gcampCorr_max_NoGSR] = fluor.pickGoodBlocks(double(oxy_NoGSR),double(deoxy_NoGSR),double(total_NoGSR),info.freqout,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr',double(gcampCorr_NoGSR),'gcamp',double(gcamp_NoGSR));
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        [oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime, jrgeco1aCorr_downsampled_NoGSR,jrgeco1a_downsampled_NoGSR, temp_jrgeco1aCorr_max_NoGSR,~,~,~] = fluor.pickGoodBlocks(double(oxy_NoGSR),double(deoxy_NoGSR),double(total_NoGSR),info.freqout,sessionInfo,output_NoGSR,texttitle_NoGSR,'jrgeco1aCorr',double(jrgeco1aCorr_NoGSR),'jrgeco1a',double(jrgeco1a_NoGSR));
        numBlock = size(red_NoGSR,3)/sessionInfo.stimblocksize;
        
        
        numDesample = size(red_NoGSR,3)/sessionInfo.framerate*info.freqout;
        factor = round(numDesample/numBlock);
        numDesample = factor*numBlock;
        red_downsampled_NoGSR = resampledata(red_NoGSR,size(red_NoGSR,3),numDesample,10^-5);
     elseif strcmp(char(sessionInfo.mouseType),'WT')
        [oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime] = fluor.pickGoodBlocks(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,info.freqout,sessionInfo,output_NoGSR,texttitle_NoGSR);
    end
    save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_NoGSR','-append')
    
    if ~isempty(goodBlocks_NoGSR)
        
        %block average
        
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,~,ROI_gcampCorr,AvggcampCorr_stim] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_downsampled_NoGSR,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR);
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                   [~,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim,~,Avgjrgeco1aCorr_stim,~,~] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_NoGSR,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_NoGSR);
            
        elseif strcmp(char(sessionInfo.mouseType),'WT')
            [ROI_total,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,stimStartTime,stimEndTime);
        end
        
        
        

        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            
            if isempty(excelRaw{20})
                fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,totals_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr_blocks',gcampCorr_NoGSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_downsampled_NoGSR,'gcamp_blocks',gcamp_NoGSR,'green_blocks',green_NoGSR,'xform_isbrain',xform_isbrain)
            else
                fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,totals_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr_blocks',gcampCorr_NoGSR,'gcampCorr_blocks_downsampled',gcampCorr_blocks_downsampled,'temp_gcampCorr_max',temp_gcampCorr_max_NoGSR,'AvggcampCorr_stim',AvggcampCorr_stim,'ROI_gcampCorr',ROI_gcampCorr,'gcamp_blocks_downsampled',gcamp_downsampled_NoGSR,'gcamp_blocks',gcamp_NoGSR,'green_blocks',green_NoGSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
            end
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')

            
            
            fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,sessionInfo,output_NoGSR,texttitle_NoGSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_NoGSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_NoGSR,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max_NoGSR,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr_GSR,'jrgeco1a_blocks_downsampled',jrgeco1a_downsampled_NoGSR,'red_blocks_downsampled',red_downsampled_NoGSR,'jrgeco1a_blocks',jrgeco1a_NoGSR,'red_blocks',red_NoGSR,'xform_isbrain',xform_isbrain)
            
            
        elseif strcmp(char(sessionInfo.mouseType),'WT')
            fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,totals_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,goodBlocks_NoGSR,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, temp_oxy_max_NoGSR,temp_deoxy_max_NoGSR,temp_total_max_NoGSR,ROI_total,sessionInfo,output_NoGSR,texttitle_NoGSR)
        end
    end
    
    
end


