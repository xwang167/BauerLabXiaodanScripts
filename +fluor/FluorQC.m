clear all;close all;clc
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
info.nVx = 128;
info.nVy = 128;

excelRows = [42 43];
numMouse = length(excelRows);

oxy_mice = [];
deoxy_mice = [];
total_mice = [];

gcamp_mice = [];
gcampCorr_mice = [];
green_mice = [];

rgeco_mice = [];
rgecoCorr_mice = [];
red_mice = [];



mouseName_cat = [];
%n =1;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    systemType = excelRaw{5};
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    sessionInfo.mouseType = excelRaw{13};
    sessionInfo.framerate = excelRaw{7};
    mouseName_cat = strcat(mouseName_cat,'-',mouseName);
    goodRuns = excelRaw{14};
    
    if strcmp(sessionType,'stim')
        sessionInfo.stimblocksize = excelRaw{8};
        sessionInfo.stimbaseline=excelRaw{9};
        sessionInfo.stimduration = excelRaw{10};
        sessionInfo.stimFrequency = excelRaw{12};
        info.newFreq = 8;
        info.freqout=1;
        info.bandtype = {"0.01Hz-8Hz",0.01,8};
    end
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    load(fullfile(saveDir,maskName), 'isbrain',  'I')

    %
    % [nVy, nVx, hem, T]=size(datahb);
    % for h=1:hem;
    %     for m=1:T;
    %         xform_datahb_old(:,:,h,m)=Affine(I, datahb(:,:,h,m));
    %     end
    % end
    %
    %  xform_datahb_old=real(xform_datahb_old);
    % load('J:\ProcessedData_3\GCaMP\181217\181217-G3M6-stim1-GSR-Detrend-0.01Hz-8Hz.mat','xform_datahb_bandpass_GSR')
    
    oxy_runs = [];
    deoxy_runs = [];
    total_runs = [];
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp_runs = [];
        gcampCorr_runs = [];
        green_runs = [];
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        jrgeco1a_runs = [];
        jrgeco1aCorr_runs = [];
        red_runs = [];
    end
    
    for ii = 1:3
        disp('loading processed data');
        load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(ii),'_processed.mat')),'xform_datahb')
        
        xform_datahb_bandpass =highpass(xform_datahb,info.bandtype{2},sessionInfo.framerate);
        xform_datahb_bandpass =lowpass(xform_datahb_bandpass,info.bandtype{3},sessionInfo.framerate);
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'.mat');
        
        disp('loading raw data');
        if strcmp(systemType,'EastOIS2')
         directory = fullfile(saveDir, 'Combined');
        load(fullfile(directory,rawName),'xform_raw')
        elseif strcmp(systemType,'EastOIS1_Fluor')
            load(fullfile(saveDir,rawName),'xform_raw');
        end
        xform_raw = double(mouse.expSpecific.procFluor(xform_raw));
        if ~isempty(find(isnan(xform_raw), 1))
            xform_raw(isnan(xform_raw))=0;
        end
        xform_isbrain = Affine(I,isbrain);
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        
        %xform_datahb_bandpass=lowpass(xform_datahb_bandpass ,info.bandtype{3},info.newFreq);
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(ii),'_processed.mat')),'xform_gcamp','xform_gcampCorr')
            if ~isempty(find(isnan(xform_gcamp), 1))
                xform_gcamp(isnan(xform_gcamp))=0;
            end
            if ~isempty(find(isnan(xform_gcampCorr), 1))
                xform_gcampCorr(isnan(xform_gcampCorr))=0;
            end
            
            
            
            
            xform_gcamp_bandpass =highpass(double(xform_gcamp),info.bandtype{2},sessionInfo.framerate);
            xform_gcampCorr_bandpass =highpass(double(xform_gcampCorr),info.bandtype{2},sessionInfo.framerate);
            xform_green_bandpass =highpass(xform_raw(:,:,2,:),info.bandtype{2},sessionInfo.framerate);
            
           xform_gcamp_bandpass =lowpass(double(xform_gcamp_bandpass),info.bandtype{3},sessionInfo.framerate);
            xform_gcampCorr_bandpass =lowpass(double(xform_gcampCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
            xform_green_bandpass =lowpass(xform_green_bandpass,info.bandtype{3},sessionInfo.framerate);
            %
            
            
            
            
            xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
            xform_gcamp_GSR = mouse.preprocess.gsr(xform_gcamp_bandpass,xform_isbrain);
            xform_gcampCorr_GSR = mouse.preprocess.gsr(xform_gcampCorr_bandpass,xform_isbrain);
            xform_green_GSR = mouse.preprocess.gsr(xform_green_bandpass,xform_isbrain);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(ii),'_processed.mat')),'xform_datahb_GSR','xform_gcampCorr_GSR','-append');
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            load(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_processed.mat'),'xform_jrgeco1a','xform_jrgeco1aCorr')
            if ~isempty(find(isnan(xform_jrgeco1a), 1))
                xform_jrgeco1a(isnan(xform_jrgeco1a))=0;
            end
            if ~isempty(find(isnan(xform_jrgeco1aCorr), 1))
                xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr))=0;
            end
            
            xform_jrgeco1a_bandpass =highpass(double(xform_jrgeco1a),info.bandtype{2},sessionInfo.framerate);
            xform_jrgeco1aCorr_bandpass =highpass(double(xform_jrgeco1aCorr),info.bandtype{2},sessionInfo.framerate);
            xform_red_bandpass =highpass(xform_raw(:,:,3,:),info.bandtype{2},sessionInfo.framerate);
                        xform_jrgeco1a_bandpass =lowpass(double(xform_jrgeco1a_bandpass),info.bandtype{3},sessionInfo.framerate);
            xform_jrgeco1aCorr_bandpass =lowpass(double(xform_jrgeco1aCorr_bandpass),info.bandtype{3},sessionInfo.framerate);
            xform_red_bandpass =lowpass(xform_red_bandpass,info.bandtype{3},sessionInfo.framerate);

            %
            
            xform_datahb_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
            xform_jrgeco1a_GSR = mouse.preprocess.gsr(xform_jrgeco1a_bandpass,xform_isbrain);
            xform_jrgeco1aCorr_GSR = mouse.preprocess.gsr(xform_jrgeco1aCorr_bandpass,xform_isbrain);
            xform_red_GSR = mouse.preprocess.gsr(xform_red_bandpass,xform_isbrain);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(ii),'_processed.mat')),'xform_datahb_GSR','xform_jrgeco1aCorr_GSR','-append');

        end
        %
        %
        % if ~isempty(find(isnan(xform_datahb_bandpass_GSR), 1))
        %     xform_datahb_bandpass_GSR(isnan(xform_datahb_bandpass_GSR))=0;
        %     disp(strcat(tiffFileName,'xform_datahb_bandpass_GSR has NAN'));
        % end
        %
        %
        %
        
        oxy = double(squeeze(xform_datahb_GSR(:,:,1,:)));
        deoxy = double(squeeze(xform_datahb_GSR(:,:,2,:)));
        total = double(oxy+deoxy);
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcamp = double(squeeze(xform_gcamp_GSR(:,:,1,:)));
            gcampCorr = double(squeeze(xform_gcampCorr_GSR(:,:,1,:)));
            green = double(squeeze(xform_green_GSR(:,:,1,:)));
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            jrgeco1a = double(squeeze(xform_jrgeco1a_GSR(:,:,1,:)));
            jrgeco1aCorr = double(squeeze(xform_jrgeco1aCorr_GSR(:,:,1,:)));
            red = double(squeeze(xform_red_GSR(:,:,1,:)));
        end
        
        
        xform_isbrain = double(xform_isbrain);
        
        oxy = oxy.*xform_isbrain;
        deoxy = deoxy.*xform_isbrain;
        total = total .*xform_isbrain;
        
        oxy(isnan(oxy)) = 0;
        deoxy(isnan(deoxy)) = 0;
        total(isnan(total)) = 0;
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcamp = gcamp.*xform_isbrain;
            gcampCorr = gcampCorr.*xform_isbrain;
            green = green.*xform_isbrain;
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            jrgeco1a = jrgeco1a.*xform_isbrain;
            jrgeco1aCorr = jrgeco1aCorr.*xform_isbrain;
            red = red.*xform_isbrain;
        end
        
        
        fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
        set(fhraw,'Units','normalized','visible','off');
        
        plotedit on
        R=mod(size(oxy,3),sessionInfo.stimblocksize);
        if R~=0
            pad=sessionInfo.stimblocksize-R;
            disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with '," ", num2str(pad), ' zeros **'))
            oxy(:,:,end:end+pad)=0;
            deoxy(:,:,end:end+pad)=0;
            total(:,:,end:end+pad)=0;
            if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                gcamp(:,:,end:end+pad)=0;
                gcampCorr(:,:,end:end+pad)=0;
                green(:,:,end:end+pad)=0;
            elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                jrgeco1a(:,:,end:end+pad)=0;
                jrgeco1aCorr(:,:,end:end+pad)=0;
                red(:,:,end:end+pad)=0;
            end
            
        end
        
        oxy=reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        
        for b=1:size(oxy,4)
            MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(oxy, 3);
                oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
            end
        end
        
        deoxy=reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        for b=1:size(deoxy,4)
            MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(deoxy, 3);
                deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
            end
        end
        
        total=reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
        for b=1:size(total,4)
            MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,b),3));
            for t=1:size(total, 3);
                total(:,:,t,b)=squeeze(total(:,:,t,b))-MeanFrame;
            end
        end
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcamp=reshape(gcamp,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(gcamp,4)
                MeanFrame=squeeze(mean(gcamp(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(gcamp, 3);
                    gcamp(:,:,t,b)=squeeze(gcamp(:,:,t,b))-MeanFrame;
                end
            end
            
            gcampCorr=reshape(gcampCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(gcampCorr,4)
                MeanFrame=squeeze(mean(gcampCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(gcampCorr, 3);
                    gcampCorr(:,:,t,b)=squeeze(gcampCorr(:,:,t,b))-MeanFrame;
                end
            end
            
            
            green=reshape(green,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(green,4)
                MeanFrame=squeeze(mean(green(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(green, 3);
                    green(:,:,t,b)=squeeze(green(:,:,t,b))-MeanFrame;
                end
            end
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            jrgeco1a=reshape(jrgeco1a,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(jrgeco1a,4)
                MeanFrame=squeeze(mean(jrgeco1a(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(jrgeco1a, 3);
                    jrgeco1a(:,:,t,b)=squeeze(jrgeco1a(:,:,t,b))-MeanFrame;
                end
            end
            jrgeco1aCorr=reshape(jrgeco1aCorr,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(jrgeco1aCorr,4)
                MeanFrame=squeeze(mean(jrgeco1aCorr(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(jrgeco1aCorr, 3);
                    jrgeco1aCorr(:,:,t,b)=squeeze(jrgeco1aCorr(:,:,t,b))-MeanFrame;
                end
            end
            red=reshape(red,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
            
            for b=1:size(red,4)
                MeanFrame=squeeze(mean(red(:,:,1:sessionInfo.stimbaseline,b),3));
                for t=1:size(red, 3);
                    red(:,:,t,b)=squeeze(red(:,:,t,b))-MeanFrame;
                end
            end
            
        end
        
        
        
        %                 oxy = resampledata(permute(oxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
        %                 deoxy = resampledata(permute(deoxy,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
        %                 total = resampledata(permute(total,[1 2 4 3]),sessionInfo.framerate,info.newFreq,10^-5);
        %
        %                 oxy = permute(oxy,[1 2 4 3]);
        %                 deoxy = permute(deoxy,[1 2 4 3]);
        %                 total = permute(total,[1 2 4 3]);
        %
        %                 info.stimblocksize = size(oxy,3);
        %                 info.stimbaseline = round(sessionInfo.stimbaseline/sessionInfo.stimblocksize*info.stimblocksize);
        oxy_runs = cat(5,oxy_runs,oxy);
        deoxy_runs = cat(5,deoxy_runs,deoxy);
        total_runs = cat(5,total_runs,total);
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            gcamp_runs = cat(5,gcamp_runs,gcamp);
            gcampCorr_runs = cat(5,gcampCorr_runs,gcampCorr);
            green_runs = cat(5,green_runs,green);
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            
            jrgeco1a_runs = cat(5,jrgeco1a_runs,jrgeco1a);
            jrgeco1aCorr_runs = cat(5,jrgeco1aCorr_runs,jrgeco1aCorr);
            red_runs = cat(5,red_runs,red);
        end
        
        
        % Block Average
        texttitle = strcat(' Block Average for', "  " ,mouseName,'-stim',num2str(ii));
        output= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(ii)));
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            
            fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle)
            
            close all
            
            %save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info')
            %strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat')
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            fluor.traceImagePlot_rgeco(oxy,deoxy,total,jrgeco1a,jrgeco1aCorr,red,info,sessionInfo,output,texttitle)
            close all
        end
        
    end
    oxy = mean(oxy_runs,5);
    deoxy = mean(deoxy_runs,5);
    total = mean(total_runs,5);
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        gcamp = mean(gcamp_runs,5);
        gcampCorr = mean(gcampCorr_runs,5);
        green = mean(green_runs,5);
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        
        jrgeco1a = mean(jrgeco1a_runs,5);
        jrgeco1aCorr = mean(jrgeco1aCorr_runs,5);
        red = mean(red_runs,5);
    end
    
    
    oxy_mice = cat(5,oxy_mice,oxy);
    deoxy_mice = cat(5,deoxy_mice,deoxy);
    total_mice = cat(5,total_mice,total);
    
    texttitle = strcat(' Block Average for',"  " ,recDate,'-',mouseName,'-stim');
    output= strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim');
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        
        fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle)
        
        close all
        gcamp_mice = cat(5,gcamp_mice,gcamp);
        gcampCorr_mice = cat(5,gcampCorr_mice,gcampCorr);
        green_mice = cat(5,green_mice,green);
        %save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info')
        %strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat')
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        fluor.traceImagePlot_rgeco(oxy,deoxy,total,jrgeco1a,jrgeco1aCorr,red,info,sessionInfo,output,texttitle)
        close all
        jrgeco1a_mice = cat(5,jrgeco1a_mice,jrgeco1a);
        jrgeco1aCorr_mice = cat(5,jrgeco1aCorr_mice,jrgeco1aCorr);
        red_mice = cat(5,red_mice,red);
    end
    
    %n = n+1;
end

oxy = mean(oxy_mice,5);
deoxy = mean(deoxy_mice,5);
total = mean(total_mice,5);

if strcmp(char(sessionInfo.mouseType),'gcamp6f')
    gcamp = mean(gcamp_mice,5);
    gcampCorr = mean(gcampCorr_mice,5);
    green = mean(green_mice,5);
elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
    
    jrgeco1a = mean(jrgeco1a_mice,5);
    jrgeco1aCorr = mean(jrgeco1aCorr_mice,5);
    red = mean(red_mice,5);
end

texttitle = strcat('Block Average for', " " ,mouseName_cat);
output= strcat('J:\ProcessedData_2\Zyla\190102\190102-',mouseName_cat,'-stim','_cat');
if strcmp(char(sessionInfo.mouseType),'gcamp6f')
    
    fluor.traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,output,texttitle)
    
    close all
    
    %save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info')
    %strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim',num2str(ii),'_vis.mat')
elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
    fluor.traceImagePlot_rgeco(oxy,deoxy,total,jrgeco1a,jrgeco1aCorr,red,info,sessionInfo,output,texttitle)
    close all
end

close all