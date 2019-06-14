close all;clearvars;clc
%excelRows = 113:115;
excelRows = [129 131 133 135 137];
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
nVx = 128;
nVy = 128;
catDir = 'J:\ProcessedData_3\GCaMP\cat' ;
%catDir = 'J:\ProcessedData_2\Zyla\cat';
miceName = [];
xform_datahb_mice_GSR = [];

xform_gcamp_mice_GSR = [];
xform_gcampCorr_mice_GSR = [];
xform_green_mice_GSR = [];
freqOut = 1;
xform_jrgeco1a_mice_GSR = [];
xform_jrgeco1aCorr_mice_GSR = [];
xform_red_mice_GSR = [];

info.nVx = 128;
info.nVy = 128;
for excelRow = excelRows
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':T',num2str(excelRow)]);
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    if strcmp(systemType,'EastOIS2')
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            sessionInfo.hbSpecies = 1:2;
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.hbSpecies = 2:3;
            sessionInfo.fluorSpecies = 1;
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 3;
        end
        
    elseif strcmp(systemType,'EastOIS1_Fluor')
        
        sessionInfo.hbSpecies = 2:4;
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            sessionInfo.fluorSpecies = 1;
            sessionInfo.darkFrameNum = excelRaw{11};
            systemInfo.numLEDs = 4;
        end
    end
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    load(fullfile(saveDir,processedName_mouse),'xform_datahb_runs_GSR');
    fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'.mat');
    load(fullfile(rawdataloc,recDate,fileName_cam1));
    startInd = sessionInfo.darkFrameNum/systemInfo.numLEDs/sessionInfo.framerate*excelRaw{20};
    time = timeStamps(startInd+1:end);
    darkTime = timeStamps(startInd);
    input_stimbox = data(startInd+1:end);
    time = time(1:end/4)-darkTime;
    input_stimbox = input_stimbox(1:end/4);
    xform_datahb_mice_GSR = cat(5,xform_datahb_mice_GSR,xform_datahb_runs_GSR);
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        load(fullfile(saveDir,processedName_mouse),'xform_gcamp_runs_GSR','xform_gcampCorr_runs_GSR','xform_green_runs_GSR');
        xform_gcamp_mice_GSR = cat(4,xform_gcamp_mice_GSR,xform_gcamp_runs_GSR);
        xform_gcampCorr_mice_GSR = cat(4,xform_gcampCorr_mice_GSR,xform_gcampCorr_runs_GSR);
        xform_green_mice_GSR = cat(4,xform_green_mice_GSR,xform_green_runs_GSR);
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        load(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_runs_GSR','xform_jrgeco1aCorr_runs_GSR','xform_red_runs_GSR')
        xform_jrgeco1a_mice = cat(5,xform_jrgeco1a_mice,xform_jrgeco1a_runs_GSR);
        xform_jrgeco1aCorr_mice_GSR = cat(5,xform_jrgeco1aCorr_mice_GSR,xform_jrgeco1aCorr_runs_GSR);
        xform_red_mice_GSR = cat(5,xform_red_mice_GSR,xform_red_runs_GSR);
    end
end

xform_datahb_mice_GSR = mean(xform_datahb_mice_GSR,5);
visName = strcat(recDate,miceName,'-',sessionType,'_GSR');

if strcmp(sessionType,'fc')
    oxy = double(squeeze(xform_datahb_mice_GSR(:,:,1,:)));
    disp(char(['QC check on ', miceName]))
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        xform_gcampCorr_mice_GSR = mean(xform_gcampCorr_mice_GSR,5);
        gcampCorr_GSR = double(squeeze(xform_gcampCorr_mice_GSR));
        QCcheck_fc(oxy,gcampCorr_GSR,'gcamp',xform_isbrain, sessionInfo,saveDir,visName);
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,5);
        jrgeco1aCorr = double(squeeze(xform_jrgeco1aCorr_mice_GSR));
        QCcheck_fc(oxy,jrgeco1aCorr,'jrgeco1a',xform_isbrain, sessionInfo,saveDir,visName);
    end
elseif strcmp(sessionType,'stim')
    
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline=excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{12};
    info.newFreq = 8;
    info.freqout=1;
    
    xform_datahb_mice_GSR = mean(xform_datahb_mice_GSR,5);
    oxy_GSR = double(squeeze(xform_datahb_mice_GSR(:,:,1,:)));
    deoxy_GSR = double(squeeze(xform_datahb_mice_GSR(:,:,2,:)));
    total_GSR = double(oxy_GSR+deoxy_GSR);
    figure;imagesc(total_GSR(:,:,1));
    xform_isbrain = roipoly;
    clear xform_datahb_runs
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        xform_gcamp_mice_GSR = mean(xform_gcamp_mice_GSR,4);
        xform_gcampCorr_mice_GSR = mean(xform_gcampCorr_mice_GSR,4);
        xform_green_mice_GSR = mean(xform_green_mice_GSR,4);
        gcamp_GSR = double(xform_gcamp_mice_GSR);
        gcampCorr_GSR = double(xform_gcampCorr_mice_GSR);
        green_GSR = double(xform_green_mice_GSR);
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1a_mice = mean(xform_jrgeco1a_mice,5);
        xform_jrgeco1aCorr_mice_GSR = mean(xform_jrgeco1aCorr_mice_GSR,5);
        xform_red_mice_GSR = mean(xform_red_mice_GSR,5);
        jrgeco1a_GSR = double(squeeze(xform_jrgeco1a_mice(:,:,1,:)));
        jrgeco1aCorr_GSR = double(squeeze(xform_jrgeco1aCorr_mice_GSR(:,:,1,:)));
        red_GSR = double(squeeze(xform_red_mice_GSR(:,:,1,:)));
        clear xform_jrgeco1a_runs xform_jrgeco1aCorr_runs xform_red_runs
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
    texttitle_GSR = strcat(' Block Average for', "  " ,miceName,'-stim'," ",'with GSR');
    output_GSR= fullfile(catDir,strcat(recDate,miceName,'-stim','_GSR'));
    
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
        definput = {'9e-6';'3e-6';'6e-6'};
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
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
        fluor.traceImagePlot_rgeco(oxy_GSR,deoxy_GSR,total_GSR,jrgeco1a_GSR,jrgeco1aCorr_GSR,red_GSR,info,sessionInfo,output_GSR,texttitle_GSR,xform_isbrain)
        clear oxy_GSR deoxy_GSR total_GSR
        %         fluor.traceImagePlot_rgeco(oxy_noGSR,deoxy_noGSR,total_noGSR,jrgeco1a_noGSR,jrgeco1aCorr_noGSR,red_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR,xform_isbrain)
        %         clear oxy_noGSR deoxy_noGSR total_noGSR
        close all
    elseif strcmp(char(sessionInfo.mouseType),'WT')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
        oxy_downsampled_GSR = resampledata(oxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_GSR = resampledata(deoxy_GSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_GSR = resampledata(total_GSR,sessionInfo.framerate,freqOut,10^-5);
        
        baseline_oxy_downsampled = squeeze(mean(oxy_downsampled_GSR(:,:,1:stimStartTime),3));
        baseline_deoxy_downsampled = squeeze(mean(deoxy_downsampled_GSR(:,:,1:stimStartTime,2),3));
        baseline_total_downsampled = squeeze(mean(total_downsampled_GSR(:,:,1:stimStartTime,2),3));
        
        fluor.traceImagePlot_gcamp(oxy_GSR,deoxy_GSR,total_GSR,gcamp_GSR,gcampCorr_GSR,green_GSR,info,sessionInfo,output_GSR,texttitle_GSR,xform_isbrain)
        close all
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        
        fluor.traceImagePlot_rgeco(oxy_GSR,deoxy_GSR,total_GSR,jrgeco1a_GSR,jrgeco1aCorr_GSR,red_GSR,info,sessionInfo,output_GSR,texttitle_GSR,xform_isbrain)
        clear oxy_GSR deoxy_GSR total_GSR
        %         fluor.traceImagePlot_rgeco(oxy_noGSR,deoxy_noGSR,total_noGSR,jrgeco1a_noGSR,jrgeco1aCorr_noGSR,red_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR,xform_isbrain)
        %         clear oxy_noGSR deoxy_noGSR total_noGSR
        close all
    elseif strcmp(char(sessionInfo.mouseType),'WT')
        fluor.traceImagePlot_WT(oxy_GSR,deoxy_GSR,total_GSR,info,sessionInfo,output_GSR,texttitle_GSR)
        clear oxy_GSR deoxy_GSR total_GSR
        %                 fluor.traceImagePlot_WT(oxy_noGSR,deoxy_noGSR,total_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR)
        %                 clear oxy_noGSR deoxy_noGSR total_noGSR
    end
end

miceName = [];
xform_datahb_mice_NoGSR = [];

xform_gcamp_mice_NoGSR = [];
xform_gcampCorr_mice_NoGSR = [];
xform_green_mice_NoGSR = [];
freqOut = 1;
xform_jrgeco1a_mice_NoGSR = [];
xform_jrgeco1aCorr_mice_NoGSR = [];
xform_red_mice_NoGSR = [];

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_mouse','.mat');
    load(fullfile(saveDir,processedName_mouse),'xform_datahb_runs_NoGSR');
    xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_runs_NoGSR);
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        load(fullfile(saveDir,processedName_mouse),'xform_gcamp_runs_NoGSR','xform_gcampCorr_runs_NoGSR','xform_green_runs_NoGSR');
        xform_gcamp_mice_NoGSR = cat(4,xform_gcamp_mice_NoGSR,xform_gcamp_runs_NoGSR);
        xform_gcampCorr_mice_NoGSR = cat(4,xform_gcampCorr_mice_NoGSR,xform_gcampCorr_runs_NoGSR);
        xform_green_mice_NoGSR = cat(4,xform_green_mice_NoGSR,xform_green_runs_NoGSR);
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        load(fullfile(saveDir,processedName_mouse),'xform_jrgeco1a_runs_NoGSR','xform_jrgeco1aCorr_runs_NoGSR','xform_red_runs_NoGSR')
        xform_jrgeco1a_mice = cat(5,xform_jrgeco1a_mice_NoGSR,xform_jrgeco1a_runs_NoGSR);
        xform_jrgeco1aCorr_mice_NoGSR = cat(5,xform_jrgeco1aCorr_mice_NoGSR,xform_jrgeco1aCorr_runs_NoGSR);
        xform_red_mice_NoGSR = cat(5,xform_red_mice_NoGSR,xform_red_runs_NoGSR);
    end
end

xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
visName = strcat(recDate,miceName,'-',sessionType,'_NoGSR');

if strcmp(sessionType,'fc')
    oxy = double(squeeze(xform_datahb_mice_NoGSR(:,:,1,:)));
    disp(char(['QC check on ', miceName]))
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        xform_gcampCorr_mice_NoGSR = mean(xform_gcampCorr_mice_NoGSR,5);
        gcampCorr_NoGSR = double(squeeze(xform_gcampCorr_mice_NoGSR));
        QCcheck_fc(oxy,gcampCorr_NoGSR,'gcamp',xform_isbrain, sessionInfo,saveDir,visName);
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,5);
        jrgeco1aCorr = double(squeeze(xform_jrgeco1aCorr_mice_NoGSR));
        QCcheck_fc(oxy,jrgeco1aCorr,'jrgeco1a',xform_isbrain, sessionInfo,saveDir,visName);
    end
elseif strcmp(sessionType,'stim')
    
    sessionInfo.stimblocksize = excelRaw{8};
    sessionInfo.stimbaseline=excelRaw{9};
    sessionInfo.stimduration = excelRaw{10};
    sessionInfo.stimFrequency = excelRaw{12};
    info.newFreq = 8;
    info.freqout=1;
    
    xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
    oxy_NoGSR = double(squeeze(xform_datahb_mice_NoGSR(:,:,1,:)));
    deoxy_NoGSR = double(squeeze(xform_datahb_mice_NoGSR(:,:,2,:)));
    total_NoGSR = double(oxy_NoGSR+deoxy_NoGSR);
    figure;imagesc(total_NoGSR(:,:,1));
    xform_isbrain = roipoly;
    clear xform_datahb_runs
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        xform_gcamp_mice_NoGSR = mean(xform_gcamp_mice_NoGSR,4);
        xform_gcampCorr_mice_NoGSR = mean(xform_gcampCorr_mice_NoGSR,4);
        xform_green_mice_NoGSR = mean(xform_green_mice_NoGSR,4);
        gcamp_NoGSR = double(xform_gcamp_mice_NoGSR);
        gcampCorr_NoGSR = double(xform_gcampCorr_mice_NoGSR);
        green_NoGSR = double(xform_green_runs_NoGSR);
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        xform_jrgeco1a_mice = mean(xform_jrgeco1a_mice,5);
        xform_jrgeco1aCorr_mice_NoGSR = mean(xform_jrgeco1aCorr_mice_NoGSR,5);
        xform_red_mice_NoGSR = mean(xform_red_mice_NoGSR,5);
        jrgeco1a_NoGSR = double(squeeze(xform_jrgeco1a_mice(:,:,1,:)));
        jrgeco1aCorr_NoGSR = double(squeeze(xform_jrgeco1aCorr_mice_NoGSR(:,:,1,:)));
        red_NoGSR = double(squeeze(xform_red_mice_NoGSR(:,:,1,:)));
        clear xform_jrgeco1a_runs xform_jrgeco1aCorr_runs xform_red_runs
    end
    
    
    xform_isbrain = double(xform_isbrain);
    
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
    texttitle_NoGSR = strcat(' Block Average for', "  " ,miceName,'-stim'," ",'with GSR');
    output_NoGSR= fullfile(catDir,strcat(recDate,miceName,'-stim','_NoGSR'));
    
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
        imagesc(AvgOxy_stim_NoGSR,[-20e-6 20e-6])
        colorbar
        axis image off
        title('Oxy')
        subplot(1,3,2)
        imagesc(AvgDeOxy_stim_NoGSR,[-10e-6 10e-6])
        colorbar
        axis image off
        title('DeOxy')
        subplot(1,3,3)
        imagesc(AvgTotal_stim_NoGSR,[-10e-6 10e-6])
        colorbar
        axis image off
        title('Total')
        colormap jet
        pause;
        prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
        title1 = 'Selet scale';
        dims = [1 35];
        definput = {'20e-6';'10e-6';'10e-6'};
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
        definput = {'0.01'};
        answer = inputdlg(prompt,title1,dims,definput);
        temp_gcampCorr_max = str2double(answer{1});
        numRows = 4;
        fluor.traceImagePlot(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,oxy_downsampled_NoGSR,deoxy_downsampled_NoGSR,total_downsampled_NoGSR,[],AvgOxy_stim_NoGSR, AvgDeOxy_stim_NoGSR, AvgTotal_stim_NoGSR, temp_oxy_max,temp_deoxy_max,temp_total_max,sessionInfo,output_NoGSR,texttitle_NoGSR,'gcampCorr_blocks',gcampCorr_NoGSR,'gcampCorr_blocks_downsampled',gcampCorr_downsampled_NoGSR,'temp_gcampCorr_max',temp_gcampCorr_max,'AvggcampCorr_stim',AvggcampCorr_stim_NoGSR,'ROI_gcampCorr',ROI_gcampCorr_NoGSR,'gcamp_blocks_downsampled',gcamp_downsampled_NoGSR,'gcamp_blocks',gcamp_NoGSR,'green_blocks',green_NoGSR,'xform_isbrain',xform_isbrain,'time',time,'input',input_stimbox)
        
        close all
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
        fluor.traceImagePlot_rgeco(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,jrgeco1a_NoGSR,jrgeco1aCorr_NoGSR,red_NoGSR,info,sessionInfo,output_NoGSR,texttitle_NoGSR,xform_isbrain)
        clear oxy_NoGSR deoxy_NoGSR total_NoGSR
        %         fluor.traceImagePlot_rgeco(oxy_noGSR,deoxy_noGSR,total_noGSR,jrgeco1a_noGSR,jrgeco1aCorr_noGSR,red_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR,xform_isbrain)
        %         clear oxy_noGSR deoxy_noGSR total_noGSR
        close all
    elseif strcmp(char(sessionInfo.mouseType),'WT')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain','isbrain')
        oxy_downsampled_NoGSR = resampledata(oxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        deoxy_downsampled_NoGSR = resampledata(deoxy_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        total_downsampled_NoGSR = resampledata(total_NoGSR,sessionInfo.framerate,freqOut,10^-5);
        
        baseline_oxy_downsampled = squeeze(mean(oxy_downsampled_NoGSR(:,:,1:stimStartTime),3));
        baseline_deoxy_downsampled = squeeze(mean(deoxy_downsampled_NoGSR(:,:,1:stimStartTime,2),3));
        baseline_total_downsampled = squeeze(mean(total_downsampled_NoGSR(:,:,1:stimStartTime,2),3));
        
        fluor.traceImagePlot_gcamp(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,gcamp_NoGSR,gcampCorr_NoGSR,green_NoGSR,info,sessionInfo,output_NoGSR,texttitle_NoGSR,xform_isbrain)
        close all
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        
        fluor.traceImagePlot_rgeco(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,jrgeco1a_NoGSR,jrgeco1aCorr_NoGSR,red_NoGSR,info,sessionInfo,output_NoGSR,texttitle_NoGSR,xform_isbrain)
        clear oxy_NoGSR deoxy_NoGSR total_NoGSR
        %         fluor.traceImagePlot_rgeco(oxy_noGSR,deoxy_noGSR,total_noGSR,jrgeco1a_noGSR,jrgeco1aCorr_noGSR,red_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR,xform_isbrain)
        %         clear oxy_noGSR deoxy_noGSR total_noGSR
        close all
    elseif strcmp(char(sessionInfo.mouseType),'WT')
        fluor.traceImagePlot_WT(oxy_NoGSR,deoxy_NoGSR,total_NoGSR,info,sessionInfo,output_NoGSR,texttitle_NoGSR)
        clear oxy_NoGSR deoxy_NoGSR total_NoGSR
        %                 fluor.traceImagePlot_WT(oxy_noGSR,deoxy_noGSR,total_noGSR,info,sessionInfo,output_noGSR,texttitle_noGSR)
        %                 clear oxy_noGSR deoxy_noGSR total_noGSR
    end
end
