function ProcMultiOISFiles_fluor(recDate, mouseName, systemType,saveDir, rawdataloc, sessionInfo, systemInfo,sessionType)



%% Process Resting State Data
rawdatatype='.tif';
filename = strcat(recDate,'-',mouseName,'-',sessionType);

n=1; %code assumes the first run is labeled as "1"
while 1 %this loop will execute as long as a run is found
    
    loopfile=fullfile(rawdataloc,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),rawdatatype));
    
    if ~exist(loopfile,'file'); % increments run number
        n=n+1;
        loopfile=fullfile(rawdataloc,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),rawdatatype));
        
        if ~exist(loopfile,'file'); % if 2 runs were skipped
            n=n+1;
            loopfile=fullfile(rawdataloc,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),rawdatatype));
            
            if ~exist(loopfile,'file'); %stops executing loop if more than one fc run was skipped.
                disp(strcat(' **** No more data found for ', filename, ' ****'))
                break
            end
        end
    end
    saveDataFileName = strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend.mat");
    saveDataFileName = fullfile(saveDir,saveDataFileName);
    
    if exist(saveDataFileName,'file') %checks to see if the raw data were already processed
        disp(strcat(filename,num2str(n),' Already processed'))
        n=n+1;
    else
        disp(strcat('Processing '," ", filename,num2str(n), ' on ', " ", systemType))
        
        maskFileName = fullfile(saveDir, strcat(recDate,'-', mouseName,'-mask.mat'));
        % %
        %         %% procOIS and transform
        if isfile(maskFileName)
            load(maskFileName ,'isbrain','I')
            isbrain = logical(isbrain);
            [raw, time, xform_datahb, xform_gcamp, xform_gcampCorr, isbrain, xform_isbrain, markers] = probe.probeImaging(loopfile, systemInfo, sessionInfo, isbrain, I ,'darkFrameNum',sessionInfo.darkFrameNum);
            xform_total = xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:);
            %
        else
            % mask file does not exist, so it has to be created
            [raw, time, xform_datahb, xform_gcamp, xform_gcampCorr,isbrain, xform_isbrain, markers] = probe.probeImaging(loopfile, systemInfo,sessionInfo,'darkFrameNum',sessionInfo.darkFrameNum);
            xform_total = xform_datahb(:,:,1,:) + xform_datahb(:,:,2,:);
            % save mask
            
        end
        
        
        
        greenData = raw(:,:,2,:);
        greenData = mouse.expSpecific.procFluor(greenData);
        xform_green = mouse.expSpecific.transformHb(greenData, markers);
        disp('Saving Data')
        save(saveDataFileName,'raw','time','xform_datahb','xform_total','xform_gcamp','xform_gcampCorr','xform_green',...
            'isbrain','xform_isbrain','markers','sessionInfo','systemInfo','-v7.3');
        
        
        disp('create video of xform data')
        
        temp_name = char(fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend_OxyMovie.avi")));
        outputVideo_oxy = VideoWriter(temp_name);
        outputVideo_oxy.FrameRate = sessionInfo.framerate;
        open(outputVideo_oxy)
        for ii = 1:size(xform_datahb(:,:,1,:),4)
            temp =  squeeze(xform_datahb(:,:,1,ii)).*xform_isbrain;
            imagesc(temp,[-6e-6, 6e-6])
            
            axis image
            axis off
            colorbar
            title(strcat('time = ', num2str(ii/sessionInfo.framerate)))
            saveas(gcf,'temp.png') ;
            temp_matrix = imread('temp.png');
            writeVideo(outputVideo_oxy,temp_matrix)
        end
        
        close(outputVideo_oxy)
        
        
        outputVideo_gcampCorr = VideoWriter(char(fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend_GcampCorrMovie.avi"))));
        outputVideo_gcampCorr.FrameRate = sessionInfo.framerate;
        open(outputVideo_gcampCorr)
        for ii = 1:size(xform_gcampCorr(:,:,1,:),4)
            temp =  squeeze(xform_gcampCorr(:,:,1,ii)).*xform_isbrain;
            
            imagesc(temp,[-0.1 0.1])
            colorbar
            axis image
            axis off
            colorbar
            title(strcat('time = ', num2str(ii/sessionInfo.framerate)))
            saveas(gcf,'temp.png') ;
            temp_matrix = imread('temp.png');
            writeVideo(outputVideo_gcampCorr,temp_matrix)
        end
        
        close(outputVideo_gcampCorr)
        
        
        %% bandpass
        if strcmp(char(sessionType),'fc')
            
            sessionInfo.bandtype_ISA = {"ISA",0.01,0.5};
            sessionInfo.bandtype_Delta = {"Delta",0.5,4};
            
            xform_datahb_ISA =highpass(xform_datahb,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
            xform_datahb_ISA =lowpass(xform_datahb_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
            xform_datahb_Delta =highpass(xform_datahb,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
            xform_datahb_Delta =lowpass(xform_datahb_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
            
            xform_gcamp_ISA = highpass(xform_gcamp,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
            xform_gcamp_ISA = lowpass(xform_gcamp_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
            xform_gcamp_Delta = highpass(xform_gcamp,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
            xform_gcamp_Delta = lowpass(xform_gcamp_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
            
            xform_gcampCorr_ISA =highpass(xform_gcampCorr,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
            xform_gcampCorr_ISA =lowpass(xform_gcampCorr_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
            xform_gcampCorr_Delta = highpass(xform_gcampCorr,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
            xform_gcampCorr_Delta = lowpass(xform_gcampCorr_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
            
            xform_green_ISA =highpass(xform_green,sessionInfo.bandtype_ISA{2},sessionInfo.framerate);
            xform_green_ISA =lowpass(xform_green_ISA ,sessionInfo.bandtype_ISA{3},sessionInfo.framerate);
            xform_green_Delta =highpass(xform_green,sessionInfo.bandtype_Delta{2},sessionInfo.framerate);
            xform_green_Delta =lowpass(xform_green_Delta ,sessionInfo.bandtype_Delta{3},sessionInfo.framerate);
            clear  xform_datahb   xform_total   xform_gcamp   xform_gcampCorr   xform_green
            if ~isempty(find(isnan(xform_datahb_ISA), 1))
                xform_datahb_ISA(isnan(xform_datahb_ISA))=0;
                disp(strcat(tiffFileName,'xform_datahb_ISA has NAN'));
            end
            if ~isempty(find(isnan(xform_gcampCorr_ISA), 1))
                xform_gcampCorr_ISA(isnan(xform_gcampCorr_ISA))=0;
                disp(strcat(tiffFileName,'xform_gcampCorr_ISA has NAN'));
            end
            
            if ~isempty(find(isnan(xform_datahb_Delta), 1))
                xform_datahb_Delta(isnan(xform_datahb_Delta))=0;
                disp(strcat(tiffFileName,'xform_datahb_Delta has NAN'));
            end
            if ~isempty(find(isnan(xform_gcampCorr_Delta), 1))
                xform_gcampCorr_Delta(isnan(xform_gcampCorr_Delta))=0;
                disp(strcat(tiffFileName,'xform_gcampCorr_Delta has NAN'));
            end
            
            
            xform_datahb_ISA = mouse.preprocess.gsr(xform_datahb_ISA,xform_isbrain);
            
            xform_gcamp_ISA = mouse.preprocess.gsr(xform_gcamp_ISA,xform_isbrain);
            xform_gcampCorr_ISA = mouse.preprocess.gsr(xform_gcampCorr_ISA,xform_isbrain);
            xform_green_ISA = mouse.preprocess.gsr(xform_green_ISA,xform_isbrain);
            xform_total_ISA = xform_datahb_ISA(:,:,1,:) + xform_datahb_ISA(:,:,2,:);
            
            
            xform_total_Delta = xform_datahb_Delta(:,:,1,:) + xform_datahb_Delta(:,:,2,:);
            saveDataFileName_ISA = strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend-ISA.mat");
            saveDataFileName_Delta = strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend-Delta.mat");
            
            
            
            save(saveDataFileName_ISA,'xform_datahb_ISA','xform_total_ISA','xform_gcamp_ISA','xform_gcampCorr_ISA','xform_green_ISA','isbrain','xform_isbrain','markers','sessionInfo','systemInfo','-v7.3');
            clear  xform_datahb_ISA   xform_total_ISA   xform_gcamp_ISA   xform_gcampCorr_ISA   xform_green_ISA
            
            save(saveDataFileName_Delta,'xform_datahb_Delta','xform_total_Delta','xform_gcamp_Delta','xform_gcampCorr_Delta','xform_green_Delta','isbrain','xform_isbrain','markers','sessionInfo','systemInfo','-v7.3');
            
            
            clear xform_datahb_Delta   xform_total_Delta   xform_gcamp_Delta   xform_gcampCorr_Delta   xform_green_Delta  ...
                
        elseif strcmp(char(sessionType),'stim')
            
            sessionInfo.bandtype = {"0.01Hz-8Hz",0.01,8};
            disp('0.01Hz-8Hz Filter')
            xform_datahb_bandpass =highpass(xform_datahb,sessionInfo.bandtype{2},sessionInfo.framerate);
            xform_datahb_bandpass=lowpass(xform_datahb_bandpass ,sessionInfo.bandtype{3},sessionInfo.framerate);
            xform_total_bandpass =highpass(xform_total,sessionInfo.bandtype{2},sessionInfo.framerate);
            xform_total_bandpass=lowpass(xform_total_bandpass ,sessionInfo.bandtype{3},sessionInfo.framerate);
            xform_gcamp_bandpass =highpass(xform_gcamp,sessionInfo.bandtype{2},sessionInfo.framerate);
            xform_gcamp_bandpass =lowpass(xform_gcamp_bandpass ,sessionInfo.bandtype{3},sessionInfo.framerate);
            xform_gcampCorr_bandpass =highpass(xform_gcampCorr,sessionInfo.bandtype{2},sessionInfo.framerate);
            xform_gcampCorr_bandpass=lowpass(xform_gcampCorr_bandpass ,sessionInfo.bandtype{3},sessionInfo.framerate);
            if ~isempty(find(isnan(xform_datahb_bandpass), 1))
                xform_datahb_bandpass(isnan(xform_datahb_bandpass))=0;
                disp(strcat(tiffFileName,'xform_datahb_bandpass has NAN'));
            end
            
            if ~isempty(find(isnan(xform_total_bandpass), 1))
                xform_total_bandpass(isnan(xform_total_bandpass))=0;
                disp(strcat(tiffFileName,'xform_datahb_bandpass has NAN'));
            end
            
            
            if ~isempty(find(isnan(xform_gcamp_bandpass), 1))
                xform_gcampCorr_bandpass(isnan(xform_gcamp_bandpass))=0;
                disp(strcat(tiffFileName,'xform_gcamp_bandpass has NAN'));
            end
            if ~isempty(find(isnan(xform_gcampCorr_bandpass), 1))
                xform_gcampCorr_bandpass(isnan(xform_gcampCorr_bandpass))=0;
                disp(strcat(tiffFileName,'xform_gcampCorr_bandpass has NAN'));
            end
            xform_green_bandpass =highpass(xform_green,sessionInfo.bandtype{2},sessionInfo.framerate);
            xform_green_bandpass =lowpass(xform_green_bandpass ,sessionInfo.bandtype{3},sessionInfo.framerate);
            if ~isempty(find(isnan(xform_green_bandpass), 1))
                xform_green_bandpass(isnan(xform_green_bandpass))=0;
                disp(strcat(tiffFileName,'xform_green_bandpass has NAN'));
            end
            disp('saving filtered data')
            saveDataFileName_stim = fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend-",sessionInfo.bandtype{1} ,".mat"));
            save(saveDataFileName_stim,'xform_datahb_bandpass','xform_total_bandpass','xform_gcamp_bandpass','xform_gcampCorr_bandpass','xform_green_bandpass',...
                'xform_isbrain','sessionInfo','systemInfo','-v7.3');
            disp('create video for xform 0.01Hz-8Hz without GSR')
            outputVideo_oxy = VideoWriter(char(fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend-0.01-8Hz_OxyMovie.avi"))));
            outputVideo_oxy.FrameRate = sessionInfo.framerate;
            open(outputVideo_oxy)
            for ii = 1:size(xform_datahb_bandpass(:,:,1,:),4)
                temp =  squeeze(xform_datahb_bandpass(:,:,1,ii)).*xform_isbrain;
                imagesc(temp,[-4e-6, 4e-6])
                colorbar
                axis image
                axis off
                title(strcat('time = ', num2str(ii/sessionInfo.framerate)))
                saveas(gcf,'temp.png') ;
                temp_matrix = imread('temp.png');
                writeVideo(outputVideo_oxy,temp_matrix)
            end
            
            close(outputVideo_oxy)
            
            outputVideo_gcampCorr = VideoWriter(char(fullfile(saveDir,strcat(recDate,"-",mouseName,"-",sessionType,num2str(n),'-NoGSR' ,"-Detrend-0.01-8Hz_GcampCorrMovie.avi"))));
            outputVideo_gcampCorr.FrameRate = sessionInfo.framerate;
            open(outputVideo_gcampCorr)
            for ii = 1:size(xform_gcampCorr_bandpass(:,:,1,:),4)
                temp =  squeeze(xform_gcampCorr_bandpass(:,:,1,ii)).*xform_isbrain;
                imagesc(temp,[-0.1 0.1])
                colorbar
                axis image
                axis off
                title(strcat('time = ', num2str(ii/sessionInfo.framerate)))
                saveas(gcf,'temp.png') ;
                temp_matrix = imread('temp.png');
                writeVideo(outputVideo_gcampCorr,temp_matrix)
            end
            
            close(outputVideo_gcampCorr)
            
            
            
            
        end
        n=n+1;
    end
end