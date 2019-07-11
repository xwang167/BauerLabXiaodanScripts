function OISGCaMPQC_mouse(recDate, mouseName, sessionType, saveDir, isGsr,sessionInfo,goodRuns)

filename = strcat(recDate,'-',mouseName,'-',sessionType);

    %% Check Evoked Responses
    
    if strcmp(sessionType, 'stim')

        
        %% Block Average
        
        oxy_runs_baseline_active = zeros(length(goodRuns),sessionInfo.stimblocksize);
        deoxy_runs_baseline_active = zeros(length(goodRuns),sessionInfo.stimblocksize);
        total_runs_baseline_active = zeros(length(goodRuns),sessionInfo.stimblocksize);
        gcamp_runs_baseline_active = zeros(length(goodRuns),sessionInfo.stimblocksize);
        gcampCorr_runs_baseline_active = zeros(length(goodRuns),sessionInfo.stimblocksize);
        green_runs_baseline_active = zeros(length(goodRuns),sessionInfo.stimblocksize);
        disp(strcat('Generate Block average plot for ', filename))
        
        
        ii = 1;
        for run = goodRuns
            if isGsr         
            stimName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'-GSR' ,'-Detrend','-',sessionInfo.bandtype{1});      
            else
            stimName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'-NoGSR' ,'-Detrend','-',sessionInfo.bandtype{1});
            end
        load(fullfile(saveDir,strcat(stimName,'.mat')),'gcampCorr_blocks_baseline_active','oxy_blocks_baseline_active','deoxy_blocks_baseline_active','total_blocks_baseline_active','gcamp_blocks_baseline_active','green_blocks_baseline_active')
              
        
        oxy_runs_baseline_active(ii,:) =  oxy_blocks_baseline_active;
        deoxy_runs_baseline_active(ii,:) = deoxy_blocks_baseline_active;
        total_runs_baseline_active(ii,:) = total_blocks_baseline_active;
        gcamp_runs_baseline_active(ii,:) = gcamp_blocks_baseline_active;
        gcampCorr_runs_baseline_active(ii,:) = gcampCorr_blocks_baseline_active;
        green_runs_baseline_active(ii,:) = green_blocks_baseline_active;
        ii = ii+1;
        end
        oxy_runs_baseline_active = mean(oxy_runs_baseline_active,1);
        deoxy_runs_baseline_active = mean(deoxy_runs_baseline_active,1);
        total_runs_baseline_active = mean(total_runs_baseline_active,1);
        gcamp_runs_baseline_active = mean(gcamp_runs_baseline_active,1);
        gcampCorr_runs_baseline_active = mean(gcampCorr_runs_baseline_active,1);
        green_runs_baseline_active = mean(green_runs_baseline_active,1);
        
        stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
        max_oxy = max(oxy_runs_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
        min_green = min(green_runs_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
        max_gcampCorr = max(gcampCorr_runs_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));
        
        
        peakValue_gcampCorr = findpeaks(gcampCorr_runs_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))),'MinPeakHeight',0.7*max_gcampCorr);
        
        
        max_gcampCorr = mean(peakValue_gcampCorr);
        
        if isGsr
            tempName = strcat(recDate,'-',mouseName,'-',sessionType,'-GSR' ,'-Detrend','-',sessionInfo.bandtype{1});
        else
            tempName = strcat(recDate,'-',mouseName,'-',sessionType,'-NoGSR' ,'-Detrend','-',sessionInfo.bandtype{1});
        end
        visName = strcat(tempName,'-BlockAvg');
        plotBlockAvg_mouse(gcampCorr_runs_baseline_active,gcamp_runs_baseline_active,green_runs_baseline_active,oxy_runs_baseline_active,deoxy_runs_baseline_active,total_runs_baseline_active,visName,saveDir,sessionInfo,max_oxy,max_gcampCorr,min_green,temp_oxy_max,temp_gcampCorr_max)
        
        save(fullfile(saveDir,strcat(tempName,'.mat')),'gcampCorr_blocks_baseline_active','oxy_blocks_baseline_active','deoxy_blocks_baseline_active','total_blocks_baseline_active','gcamp_blocks_baseline_active','green_blocks_baseline_active')
    
        close all
        
        %% StimMap
        
        
        disp(strcat('Generate StimMap for ',filename));
        
        
                ii = 1;
        for run = goodRuns
            if isGsr         
            stimName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'-GSR' ,'-Detrend','-',sessionInfo.bandtype{1});      
            else
            stimName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'-NoGSR' ,'-Detrend','-',sessionInfo.bandtype{1});
            end
        load(fullfile(saveDir,strcat(stimName,'.mat')),'info','AvgOxy_peakAvg', 'AvgDeOxy_peakAvg', 'AvgTotal_peakAvg','Avggcamp_peakAvg','AvggcampCorr_peakAvg','gcamp_peakAvg','gcampCorr_peakAvg','oxy_peakAvg','deoxy_peakAvg','total_peakAvg')
              
        
        oxy_peakAvg_runs(:,:,:,ii) = oxy_peakAvg;
        deoxy_peakAvg_runs(:,:,:,ii) = deoxy_peakAvg;
        total_peakAvg_runs(:,:,:,ii) = total_peakAvg;
        gcamp_peakAvg_runs(:,:,:,ii) = gcamp_peakAvg;
        gcampCorr_peakAvg_runs(:,:,:,ii) = gcampCorr_peakAvg;
        
        AvgOxy_peakAvg_runs(:,:,ii) = AvgOxy_peakAvg;
        AvgDeOxy_peakAvg_runs(:,:,ii) = AvgDeOxy_peakAvg;
        AvgTotal_peakAvg_runs(:,:,ii) = AvgTotal_peakAvg;
        Avggcamp_peakAvg_runs(:,:,ii) = Avggcamp_peakAvg;
        AvggcampCorr_peakAvg_runs(:,:,ii) = AvggcampCorr_peakAvg;
        
        ii = ii+1;
        end
        numBlocks = size(oxy_peakAvg_runs,3);
        oxy_peakAvg_runs = mean(oxy_peakAvg_runs,4);
        deoxy_peakAvg_runs = mean(deoxy_peakAvg_runs,4);
        total_peakAvg_runs = mean(total_peakAvg_runs,4);
        gcamp_peakAvg_runs = mean(gcamp_peakAvg_runs,4);
        gcampCorr_peakAvg_runs= mean(gcampCorr_peakAvg_runs,4);
        
        AvgOxy_peakAvg_runs = mean(AvgOxy_peakAvg_runs,3);
        AvgDeOxy_peakAvg_runs(:,:,ii) = mean(AvgDeOxy_peakAvg_runs,3);
        AvgTotal_peakAvg_runs(:,:,ii) = mean(AvgTotal_peakAvg_runs,3);
        Avggcamp_peakAvg_runs(:,:,ii) = mean(Avggcamp_peakAvg_runs,3);
        AvggcampCorr_peakAvg_runs(:,:,ii) = mean(AvggcampCorr_peakAvg_runs,3);
        
        
        save(fullfile(saveDir,strcat(tempName,'.mat')) , 'info','AvgOxy_peakAvg_runs', 'AvgDeOxy_peakAvg_runs', 'AvgTotal_peakAvg_runs','Avggcamp_peakAvg_runs','AvggcampCorr_peakAvg_runs','gcamp_peakAvg_runs','gcampCorr_peakAvg_runs','oxy_peakAvg_runs','deoxy_peakAvg_runs','total_peakAvg_runs', '-append');
        getStimMap(numBlocks,gcamp_peakAvg_runs,gcampCorr_peakAvg_runs,oxy_peakAvg_runs,deoxy_peakAvg_runs,total_peakAvg_runs,AvgOxy_peakAvg_runs,Avggcamp_peakAvg_runs,AvgDeOxy_peakAvg_runs,AvgTotal_peakAvg_runs,AvggcampCorr_peakAvg_runs,tempName,saveDir,max_oxy,max_gcampCorr)
        
    elseif strcmp(sessionType,'fc')
        %% Check functional connectivty
        saveDataFileName_ISA = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-NoGSR' ,'-Detrend-ISA.mat');
        saveDataFileName_Delta = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-NoGSR' ,'-Detrend-Delta.mat');
        
        load(fullfile(saveDir,strcat(saveDataFileName_ISA,'.mat')),'xform_datahb_ISA','xform_gcampCorr_ISA')
        load(fullfile(saveDir,strcat(saveDataFileName_Delta,'.mat')),'xform_datahb_Delta','xform_gcampCorr_Delta')
        saveDataFileName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-NoGSR' ,'-Detrend');
        load(fullfile(saveDir,strcat(saveDataFileName,'.mat')),'xform_isbrain','sessionInfo')
        
        if isGsr
            xform_datahb_bandpass = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
            xform_gcamp_bandpass = mouse.preprocess.gsr(xform_gcamp_bandpass,xform_isbrain);
            xform_gcampCorr_bandpass = mouse.preprocess.gsr(xform_gcampCorr_bandpass,xform_isbrain);
            xform_green_bandpass = mouse.preprocess.gsr(xform_green_bandpass,xform_isbrain);
        end
        
        [info.nVy,info.nVx,~,~] = size(xform_datahb_ISA);
        oxy_ISA = squeeze(xform_datahb_ISA (:,:,1,:));
        gcampCorr_ISA  = squeeze(xform_gcampCorr_ISA (:,:,1,:));
        oxy_Delta = squeeze(xform_datahb_Delta(:,:,1,:));
        gcampCorr_Delta = squeeze(xform_gcampCorr_Delta(:,:,1,:));
        clear xform_datahb_ISA   xform_gcampCorr_ISA   xform_datahb_Delta   xform_gcampCorr_Delta
        
        oxy_ISA = oxy_ISA.*xform_isbrain;
        gcampCorr_ISA = gcampCorr_ISA.*xform_isbrain;
        oxy_Delta = oxy_Delta.*xform_isbrain;
        gcampCorr_Delta = gcampCorr_Delta.*xform_isbrain;
        
        oxy_ISA(isnan(oxy_ISA)) = 0;
        gcampCorr_ISA(isnan(gcampCorr_ISA)) = 0;
        oxy_Delta(isnan(oxy_Delta)) = 0;
        gcampCorr_Delta(isnan(gcampCorr_Delta)) = 0;
        
        fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
        set(fhraw,'Units','normalized','visible','off');
        
        plotedit on
        oxy_ISA=reshape(oxy_ISA,info.nVy*info.nVx,[]);
        gcampCorr_ISA = reshape(gcampCorr_ISA,info.nVy*info.nVx,[]);
        
        oxy_Delta = reshape(oxy_Delta,info.nVy*info.nVx,[]);
        gcampCorr_Delta = reshape(gcampCorr_Delta,info.nVy*info.nVx,[]);
        
        refseeds=GetReferenceSeeds;
        refseeds = refseeds(1:14,:);
        
        mm=10;
        mpp=mm/info.nVx;
        seedradmm=0.1;%0.25
        seedradpix=seedradmm/mpp;
        P=burnseeds(refseeds,seedradpix,xform_isbrain);
        
        strace_oxy_ISA = P2strace(P,oxy_ISA, refseeds); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
        strace_gcampCorr_ISA = P2strace(P,gcampCorr_ISA, refseeds);
        strace_oxy_Delta = P2strace(P,oxy_Delta, refseeds); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
        strace_gcampCorr_Delta=P2strace(P,gcampCorr_Delta, refseeds);
        
        R_oxy_ISA=strace2R(strace_oxy_ISA,oxy_ISA, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
        R_gcampCorr_ISA = strace2R(strace_gcampCorr_ISA,gcampCorr_ISA, info.nVx, info.nVy);
        R_oxy_Delta = strace2R(strace_oxy_Delta,oxy_Delta, info.nVx, info.nVy); %% normalize  rows in time, dot product of those rows with strce
        R_gcampCorr_Delta = strace2R(strace_gcampCorr_Delta,gcampCorr_Delta, info.nVx, info.nVy);
        
        clear oxy_ISA    gcampCorr_ISA    oxy_Delta    gcampCorr_Delta
        
        R_oxy_ISA(isnan(R_oxy_ISA)) = 0;
        Rs_oxy_ISA=normRow(strace_oxy_ISA)*normRow(strace_oxy_ISA)';
        R_gcampCorr_ISA(isnan(R_gcampCorr_ISA)) = 0;
        Rs_gcampCorr_ISA = normRow(strace_gcampCorr_ISA)*normRow(strace_gcampCorr_ISA)';
        
        R_oxy_Delta(isnan(R_oxy_Delta)) = 0;
        Rs_oxy_Delta = normRow(strace_oxy_Delta)*normRow(strace_oxy_Delta)';
        R_gcampCorr_Delta(isnan(R_gcampCorr_Delta)) = 0;
        Rs_gcampCorr_Delta =normRow(strace_gcampCorr_Delta)*normRow(strace_gcampCorr_Delta)';
        
        save(fullfile(saveDir,strcat(saveDataFileName_ISA,'.mat','.mat')),'R_oxy_ISA', 'Rs_oxy_ISA','R_gcampCorr_ISA', 'Rs_gcampCorr_ISA');
        save(fullfile(saveDir,strcat(saveDataFileName_Delta,'.mat','.mat')),'R_oxy_Delta', 'Rs_oxy_Delta','R_gcampCorr_Delta', 'Rs_gcampCorr_Delta', '-v7.3','-append');
        createFCMap()
        clear  R_oxy_ISA    Rs_oxy_ISA   R_gcampCorr_ISA    Rs_gcampCorr_ISA   R_oxy_Delta    Rs_oxy_Delta   R_gcampCorr_Delta    Rs_gcampCorr_Delta
    end







