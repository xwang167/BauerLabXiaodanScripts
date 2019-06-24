
close all;clearvars;clc
excelRows = 163;%[124 126 127 128 130 132 134 136];
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


nVx = 128;
nVy = 128;
for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':T',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{8};
    
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
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
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
    if ~exist(fullfile(saveDir,processedName_mouse),'file')
        for n = 1:3
            
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                disp('loading processed data')
                load(fullfile(saveDir, processedName),'xform_datahb_GSR','xform_gcamp_GSR','xform_gcampCorr_GSR','xform_green_GSR','goodBlocks_GSR')
                sessionInfo.stimblocksize = excelRaw{8};
                numBlocks = size(xform_datahb_GSR,4)/sessionInfo.stimblocksize;
                xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
                xform_gcamp_GSR = reshape(xform_gcamp_GSR,128,128,[],numBlocks);
                xform_gcampCorr_GSR = reshape(xform_gcampCorr_GSR,128,128,[],numBlocks);
                xform_green_GSR = reshape(xform_green_GSR,128,128,[],numBlocks);
                
                xform_datahb_runs_GSR = cat(5,xform_datahb_runs_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
                xform_gcamp_runs_GSR = cat(4,xform_gcamp_runs_GSR,xform_gcamp_GSR(:,:,:,goodBlocks_GSR));
                xform_gcampCorr_runs_GSR = cat(4,xform_gcampCorr_runs_GSR,xform_gcampCorr_GSR(:,:,:,goodBlocks_GSR));
                xform_green_runs_GSR = cat(4,xform_green_runs_GSR,xform_green_GSR(:,:,:,goodBlocks_GSR));
                
                disp('loading processed data')
                load(fullfile(saveDir, processedName),'xform_datahb','xform_gcamp','xform_gcampCorr','xform_green','sessionInfo','goodBlocks_NoGSR')
                
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
                sessionInfo.stimblocksize = excelRaw{8};
                numBlocks = size(xform_datahb_GSR,4)/sessionInfo.stimblocksize;
                xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,[],numBlocks);
                xform_jrgeco1a_GSR = reshape(xform_jrgeco1a_GSR,128,128,[],numBlocks);
                xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128,128,[],numBlocks);
                xform_red_GSR = reshape(xform_red_GSR,128,128,[],numBlocks);
                
                xform_datahb_runs_GSR = cat(5,xform_datahb_runs_GSR,xform_datahb_GSR(:,:,:,:,goodBlocks_GSR));
                xform_jrgeco1a_runs_GSR = cat(4,xform_jrgeco1a_runs_GSR,xform_jrgeco1a_GSR(:,:,:,goodBlocks_GSR));
                xform_jrgeco1aCorr_runs_GSR = cat(4,xform_jrgeco1aCorr_runs_GSR,xform_jrgeco1aCorr_GSR(:,:,:,goodBlocks_GSR));
                xform_red_runs_GSR = cat(4,xform_red_runs_GSR,xform_red_GSR(:,:,:,goodBlocks_GSR));
                
                disp('loading processed data')
                load(fullfile(saveDir, processedName),'xform_datahb','xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','sessionInfo','goodBlocks_NoGSR')
                
                xform_datahb_NoGSR = reshape(xform_datahb,128,128,2,[],numBlocks);
                xform_jrgeco1a_NoGSR = reshape(xform_jrgeco1a,128,128,[],numBlocks);
                xform_jrgeco1aCorr_NoGSR = reshape(xform_jrgeco1aCorr,128,128,[],numBlocks);
                xform_red_NoGSR = reshape(xform_red,128,128,[],numBlocks);
                
                xform_datahb_runs_NoGSR = cat(5,xform_datahb_runs_NoGSR,xform_datahb_NoGSR(:,:,:,:,goodBlocks_NoGSR));
                xform_jrgeco1a_runs_NoGSR = cat(4,xform_jrgeco1a_runs_NoGSR,xform_jrgeco1a_NoGSR(:,:,:,goodBlocks_NoGSR));
                xform_jrgeco1aCorr_runs_NoGSR = cat(4,xform_jrgeco1aCorr_runs_NoGSR,xform_jrgeco1aCorr_NoGSR(:,:,:,goodBlocks_NoGSR));
                xform_red_runs_NoGSR = cat(4,xform_red_runs_NoGSR,xform_red_NoGSR(:,:,:,goodBlocks_NoGSR));
                
                
            elseif strcmp(char(sessionInfo.mouseType),'WT')
                load(fullfile(saveDir, processedName),'xform_datahb_GSR','sessionInfo','goodBlocks_GSR')
                if ~isempty(goodBlocks_GSR)
                    temp = reshape(xform_datahb_GSR,nVy,nVx,2,sessionInfo.stimblocksize,[]);
                    temp_goodBlocks_GSR = temp(:,:,:,:,goodBlocks_GSR);
                    xform_datahb_runs_GSR = cat(5,xform_datahb_runs_GSR,temp_goodBlocks_GSR);
                    load(fullfile(saveDir, processedName),'xform_datahb_NoGSR','sessionInfo','goodBlocks_NoGSR')
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
    else
        load(fullfile(saveDir,processedName_mouse))
    end
    
    
    
    
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline=excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{12};
    freqOut=1;
    
    
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
    end
    
    
    
    
    
    
    
    
    % Block Average
    texttitle_GSR = strcat(' Block Average for', "  " ,mouseName,'-stim'," ",'with GSR');
    output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim_GSR'));
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        
        stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
        stimEndTime= stimStartTime+sessionInfo.stimduration;
        
        oxy_downsampled_GSR = resampledata(oxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_GSR = resampledata(deoxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_GSR = resampledata(total_GSR,sessionInfo.framerate,freqOut,10^-5);
        
        gcampCorr_downsampled_GSR = resampledata(gcampCorr_GSR,sessionInfo.framerate,freqOut,10^-5);
        gcamp_downsampled_GSR = resampledata(gcamp_GSR,sessionInfo.framerate,freqOut,10^-5);
        
        [ROI_total_GSR,AvgOxy_stim_GSR, AvgDeOxy_stim_GSR, AvgTotal_stim_GSR,~,~,ROI_gcampCorr_GSR,AvggcampCorr_stim_GSR] = fluor.generatePeakMapandROI(oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,8*10^(-6),4*10^(-6),4*10^(-6),stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_downsampled_GSR,'temp_gcampCorr_max',0.03);
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(1,3,1)
        imagesc(AvgOxy_stim_GSR,[-9e-6 9e-6])
        colorbar
        axis image off
        title('Oxy')
        subplot(1,3,2)
        imagesc(AvgDeOxy_stim_GSR,[-3e-6 3e-6])
        colorbar
        axis image off
        title('DeOxy')
        subplot(1,3,3)
        imagesc(AvgTotal_stim_GSR,[-6e-6 6e-6])
        colorbar
        axis image off
        title('Total')
        colormap jet
        pause;
        prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'9e-6';'3.5e-6';'6e-6'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_oxy_max = str2double(answer{1});
        temp_deoxy_max = str2double(answer{2});
        temp_total_max = str2double(answer{3});
        
        figure
        imagesc(AvggcampCorr_stim_GSR,[-0.03 0.03])
        colorbar
        axis image off
        title('gcampCorr')
        colormap jet
        pause;
        prompt = {'Enter gcampCorr limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'0.01'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_gcampCorr_max = str2double(answer{1});
        numRows = 4;
        fluor.traceImagePlot(oxy_GSR,deoxy_GSR,total_GSR,oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,[],AvgOxy_stim_GSR, AvgDeOxy_stim_GSR, AvgTotal_stim_GSR, temp_oxy_max,temp_deoxy_max,temp_total_max,sessionInfo,output_GSR,texttitle_GSR,'gcampCorr_blocks',gcampCorr_GSR,'gcampCorr_blocks_downsampled',gcampCorr_downsampled_GSR,'temp_gcampCorr_max',temp_gcampCorr_max,'AvggcampCorr_stim',AvggcampCorr_stim_GSR,'ROI_gcampCorr',ROI_gcampCorr_GSR,'gcamp_blocks_downsampled',gcamp_downsampled_GSR,'gcamp_blocks',gcamp_GSR,'green_blocks',green_GSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
        
        close all
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
              
        stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
        stimEndTime= stimStartTime+sessionInfo.stimduration;
        
        oxy_downsampled_GSR = resampledata(oxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_GSR = resampledata(deoxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_GSR = resampledata(total_GSR,sessionInfo.framerate,freqOut,10^-5);
        
        jrgeco1aCorr_downsampled_GSR = resampledata(jrgeco1aCorr_GSR,sessionInfo.framerate,freqOut,10^-5);
        jrgeco1a_downsampled_GSR = resampledata(jrgeco1a_GSR,sessionInfo.framerate,freqOut,10^-5);
        
        [ROI_total_GSR,AvgOxy_stim_GSR, AvgDeOxy_stim_GSR, AvgTotal_stim_GSR,ROI_jrgeco1aCorr_GSR,Avgjrgeco1aCorr_stim_GSR,~,~] = fluor.generatePeakMapandROI(oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,8*10^(-6),4*10^(-6),4*10^(-6),stimStartTime,stimEndTime,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_GSR,'temp_jrgeco1aCorr_max',0.03);
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(1,3,1)
        imagesc(AvgOxy_stim_GSR,[-9e-6 9e-6])
        colorbar
        axis image off
        title('Oxy')
        subplot(1,3,2)
        imagesc(AvgDeOxy_stim_GSR,[-3e-6 3e-6])
        colorbar
        axis image off
        title('DeOxy')
        subplot(1,3,3)
        imagesc(AvgTotal_stim_GSR,[-6e-6 6e-6])
        colorbar
        axis image off
        title('Total')
        colormap jet
        pause;
        prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'9e-6';'3.5e-6';'6e-6'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_oxy_max = str2double(answer{1});
        temp_deoxy_max = str2double(answer{2});
        temp_total_max = str2double(answer{3});
        
        figure
        imagesc(Avgjrgeco1aCorr_stim_GSR,[-0.03 0.03])
        colorbar
        axis image off
        title('jrgeco1aCorr')
        colormap jet
        pause;
        prompt = {'Enter jrgeco1aCorr limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'0.01'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_jrgeco1aCorr_max = str2double(answer{1});
        numRows = 4;
        fluor.traceImagePlot(oxy_GSR,deoxy_GSR,total_GSR,oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,[],AvgOxy_stim_GSR, AvgDeOxy_stim_GSR, AvgTotal_stim_GSR, temp_oxy_max,temp_deoxy_max,temp_total_max,sessionInfo,output_GSR,texttitle_GSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_GSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_GSR,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim_GSR,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr_GSR,'jrgeco1a_blocks_downsampled',jrgeco1a_downsampled_GSR,'jrgeco1a_blocks',jrgeco1a_GSR,'red_blocks',red_GSR,'xform_isbrain',xform_isbrain)
        
        close all
        
        
        
        
        
        
        
        
        
    elseif strcmp(char(sessionInfo.mouseType),'WT')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
        oxy_downsampled_GSR = resampledata(oxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_GSR = resampledata(deoxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_GSR = resampledata(total_GSR,sessionInfo.framerate,freqOut,10^-5);
        
        baseline_oxy_downsampled = squeeze(mean(oxy_downsampled_GSR(:,:,1:stimStartTime),3));
        baseline_deoxy_downsampled = squeeze(mean(deoxy_downsampled_GSR(:,:,1:stimStartTime,2),3));
        baseline_total_downsampled = squeeze(mean(total_downsampled_GSR(:,:,1:stimStartTime,2),3));
        
        %                 fluor.traceImagePlot_WT(oxy_noGSR,deoxy_noGSR,total_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR)
        %                 clear oxy_noGSR deoxy_noGSR total_noGSR
    end
    
    %%
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline=excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{12};
    freqOut=1;
    
    
    oxy_NoGSR = double(squeeze(xform_datahb_runs_NoGSR(:,:,1,:)));
    deoxy_NoGSR = double(squeeze(xform_datahb_runs_NoGSR(:,:,2,:)));
    total_NoGSR = double(oxy_NoGSR+deoxy_NoGSR);
    
    clear xform_datahb_runs
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp_NoGSR = double(xform_gcamp_runs_NoGSR);
        gcampCorr_NoGSR = double(xform_gcampCorr_runs_NoGSR);
        green_NoGSR = double(xform_green_runs_NoGSR);
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        jrgeco1a_NoGSR = double(xform_jrgeco1a_runs_NoGSR);
        jrgeco1aCorr_NoGSR = double(xform_jrgeco1aCorr_runs_NoGSR);
        red_NoGSR = double(xform_red_runs_NoGSR);
        
        
    end
    
    
    xform_isbrain = double(xform_isbrain);
    xform_isbrain(xform_isbrain==2)=1;
    
    oxy_NoGSR = oxy_NoGSR.*xform_isbrain;
    deoxy_NoGSR = deoxy_NoGSR.*xform_isbrain;
    total_NoGSR = total_NoGSR .*xform_isbrain;
    
    oxy_NoGSR(isnan(oxy_NoGSR)) = 0;
    deoxy_NoGSR(isnan(deoxy_NoGSR)) = 0;
    total_NoGSR(isnan(total_NoGSR)) = 0;
    
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp_NoGSR= gcamp_NoGSR.*xform_isbrain;
        gcampCorr_NoGSR = gcampCorr_NoGSR.*xform_isbrain;
        green_NoGSR = green_NoGSR.*xform_isbrain;
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        jrgeco1a_NoGSR = jrgeco1a_NoGSR.*xform_isbrain;
        jrgeco1aCorr_NoGSR = jrgeco1aCorr_NoGSR.*xform_isbrain;
        red_NoGSR = red_NoGSR.*xform_isbrain;
    end
    
    
    
    
    
    
    
    
    % Block Average
    texttitle_NoGSR = strcat(' Block Average for', "  " ,mouseName,'-stim'," ",'without GSR');
    output_NoGSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim_NoGSR'));
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        
        stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
        stimEndTime= stimStartTime+sessionInfo.stimduration;
        
        oxy_downsampled_NoGSR = resampledata(oxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_NoGSR = resampledata(deoxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_NoGSR = resampledata(total_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        
        gcampCorr_downsampled_NoGSR = resampledata(gcampCorr_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        gcamp_downsampled_NoGSR = resampledata(gcamp_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        
        [ROI_total_NoGSR,AvgOxy_stim_NoGSR, AvgDeOxy_stim_NoGSR, AvgTotal_stim_NoGSR,~,~,ROI_gcampCorr_NoGSR,AvggcampCorr_stim_NoGSR] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,8*10^(-6),4*10^(-6),4*10^(-6),stimStartTime,stimEndTime,'gcampCorr_blocks_downsampled',gcampCorr_downsampled_NoGSR,'temp_gcampCorr_max',0.03);
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(1,3,1)
        imagesc(AvgOxy_stim_NoGSR,[-9e-6 9e-6])
        colorbar
        axis image off
        title('Oxy')
        subplot(1,3,2)
        imagesc(AvgDeOxy_stim_NoGSR,[-3e-6 3e-6])
        colorbar
        axis image off
        title('DeOxy')
        subplot(1,3,3)
        imagesc(AvgTotal_stim_NoGSR,[-6e-6 6e-6])
        colorbar
        axis image off
        title('Total')
        colormap jet
        pause;
        prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'9e-6';'3.5e-6';'6e-6'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_oxy_max = str2double(answer{1});
        temp_deoxy_max = str2double(answer{2});
        temp_total_max = str2double(answer{3});
        
        figure
        imagesc(AvggcampCorr_stim_NoGSR,[-0.03 0.03])
        colorbar
        axis image off
        title('gcampCorr')
        colormap jet
        pause;
        prompt = {'Enter gcampCorr limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'0.03'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_gcampCorr_max = str2double(answer{1});
        numRows = 4;
        fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,[],AvgOxy_stim_NoGSR, AvgDeOxy_stim_NoGSR, AvgTotal_stim_NoGSR, temp_oxy_max,temp_deoxy_max,temp_total_max,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr_blocks',gcampCorr_NoGSR,'gcampCorr_blocks_downsampled',gcampCorr_downsampled_NoGSR,'temp_gcampCorr_max',temp_gcampCorr_max,'AvggcampCorr_stim',AvggcampCorr_stim_NoGSR,'ROI_gcampCorr',ROI_gcampCorr_NoGSR,'gcamp_blocks_downsampled',gcamp_downsampled_NoGSR,'gcamp_blocks',gcamp_NoGSR,'green_blocks',green_NoGSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
        
        close all
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        
        stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
        stimEndTime= stimStartTime+sessionInfo.stimduration;
        
        oxy_downsampled_NoGSR = resampledata(oxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_NoGSR = resampledata(deoxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_NoGSR = resampledata(total_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        
        jrgeco1aCorr_downsampled_NoGSR = resampledata(jrgeco1aCorr_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        jrgeco1a_downsampled_NoGSR = resampledata(jrgeco1a_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        
        [ROI_total_NoGSR,AvgOxy_stim_NoGSR, AvgDeOxy_stim_NoGSR, AvgTotal_stim_NoGSR,ROI_jrgeco1aCorr_NoGSR,Avgjrgeco1aCorr_stim_NoGSR,~,~] = fluor.generatePeakMapandROI(oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,8*10^(-6),4*10^(-6),4*10^(-6),stimStartTime,stimEndTime,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_NoGSR,'temp_jrgeco1aCorr_max',0.03);
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(1,3,1)
        imagesc(AvgOxy_stim_NoGSR,[-9e-6 9e-6])
        colorbar
        axis image off
        title('Oxy')
        subplot(1,3,2)
        imagesc(AvgDeOxy_stim_NoGSR,[-3e-6 3e-6])
        colorbar
        axis image off
        title('DeOxy')
        subplot(1,3,3)
        imagesc(AvgTotal_stim_NoGSR,[-6e-6 6e-6])
        colorbar
        axis image off
        title('Total')
        colormap jet
        pause;
        prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'9e-6';'3.5e-6';'6e-6'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_oxy_max = str2double(answer{1});
        temp_deoxy_max = str2double(answer{2});
        temp_total_max = str2double(answer{3});
        
        figure
        imagesc(Avgjrgeco1aCorr_stim_NoGSR,[-0.03 0.03])
        colorbar
        axis image off
        title('jrgeco1aCorr')
        colormap jet
        pause;
        prompt = {'Enter jrgeco1aCorr limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'0.03'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_jrgeco1aCorr_max = str2double(answer{1});
        numRows = 4;
        fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,[],AvgOxy_stim_NoGSR, AvgDeOxy_stim_NoGSR, AvgTotal_stim_NoGSR, temp_oxy_max,temp_deoxy_max,temp_total_max,sessionInfo,output_NoGSR,texttitle_NoGSR,'jrgeco1aCorr_blocks',jrgeco1aCorr_NoGSR,'jrgeco1aCorr_blocks_downsampled',jrgeco1aCorr_downsampled_NoGSR,'temp_jrgeco1aCorr_max',temp_jrgeco1aCorr_max,'Avgjrgeco1aCorr_stim',Avgjrgeco1aCorr_stim_NoGSR,'ROI_jrgeco1aCorr',ROI_jrgeco1aCorr_NoGSR,'jrgeco1a_blocks_downsampled',jrgeco1a_downsampled_NoGSR,'jrgeco1a_blocks',jrgeco1a_NoGSR,'red_blocks',red_NoGSR,'xform_isbrain',xform_isbrain)
        
        close all
    elseif strcmp(char(sessionInfo.mouseType),'WT')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
        oxy_downsampled_NoGSR = resampledata(oxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_NoGSR = resampledata(deoxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_NoGSR = resampledata(total_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        
        baseline_oxy_downsampled = squeeze(mean(oxy_downsampled_NoGSR(:,:,1:stimStartTime),3));
        baseline_deoxy_downsampled = squeeze(mean(deoxy_downsampled_NoGSR(:,:,1:stimStartTime,2),3));
        baseline_total_downsampled = squeeze(mean(total_downsampled_NoGSR(:,:,1:stimStartTime,2),3));
        
        %                 fluor.traceImagePlot_WT(oxy_noGSR,deoxy_noGSR,total_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR)
        %                 clear oxy_noGSR deoxy_noGSR total_noGSR
    end
end


