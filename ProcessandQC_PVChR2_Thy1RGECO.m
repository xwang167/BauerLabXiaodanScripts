poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
excelFile="Z:\PVChR2Thy1RGECO_whisker_laser.xlsx";
excelRows=[4];

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
%% Get Masks and WL
previousDate = []; %initialize the date
mouse_ind=start_ind_mouse';
for runInd=mouse_ind %for each mouse
    
    runInfo=runsInfo(runInd);
    currentDate = runInfo.recDate;
    
    sessionInfo = sysInfo(runInfo.system);
    
    tmp=matfile(runInfo.rawFile{1});   %JPC partial load  -- has size size(test,'raw_unregistered')
    raw_unregistered=tmp.raw_unregistered(:,:,1:200*runInfo.numCh); %JPC
    raw_unregistered=reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),runInfo.numCh,[]);
    
    %getting ROI for stim
    tmp=nan(size(raw_unregistered,1),size(raw_unregistered,2),runInfo.numCh);
    fh = figure('units','normalized','outerposition',[0 0 1 1]);
    for jj=1:runInfo.numCh
        tmp(:,:,jj)=(mean(raw_unregistered(:,:,jj,runInfo.stimStartTime*runInfo.samplingRate+runInfo.darkFramesInd(end)+1:end),4)-...
            mean(raw_unregistered(:,:,jj,runInfo.darkFramesInd(end)+1:1+runInfo.darkFramesInd(end)+runInfo.stimStartTime*runInfo.samplingRate),4)).^2; %mean from dark frames to end
        subplot(1,runInfo.numCh,jj)
        imagesc(squeeze(tmp(:,:,jj)))
        title(['CH:', num2str(jj)])
        if jj==2
            title(['PICK ME! CH:', num2str(jj)])
        end
        try
            caxis(quantile(reshape(tmp(:,:,jj),1,[]),[0.001,.999]))
        catch
            caxis([min(reshape(tmp(:,:,jj),1,[])) max(reshape(tmp(:,:,jj),1,[]))] )
        end
        axis image
        set(gca,'tag',num2str(jj))
    end
    sgtitle({'Click Subplot With Best Stim','Click Center'})
    [StimROIMask, StimCh]=findStimROIMask(tmp,size(tmp,1),size(tmp,2));
    StimROIMask=imgaussfilt(double(StimROIMask),4); %smooth with 4 pixel kernel
    StimROIMask=StimROIMask>.5*max(max(StimROIMask));
    close
    imagesc(StimROIMask)
    pause(0.5)
    close
    xform_StimROIMask=affineTransform(StimROIMask,I);
    xform_StimROIMask=single(uint8(xform_StimROIMask));
    save(runInfo.saveMaskFile,'StimROIMask','xform_StimROIMask','-append');
    
    
end


%% Process Data
% Process multiple OIS files with the following naming convention:

% filedate: YYMMDD
% subjname: any alphanumberic convention is ok, e.g. "Mouse1"
% suffix: filename run number, e.g. "fc1"
% In Andor Solis, files are saved as "YYMMDD-MouseName-suffixN.tif"

% "directory" is where processed data will be stored. If the
% folder does not exist, it is created, and if directory is not
% specified, data will be saved in the current folder:

runNum = numel(runsInfo);

for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    
    %do these exist?
    stimExist=[runInfo.saveFilePrefix ,'-StimResults','.mat'];
    fcExist=[runInfo.saveFilePrefix '-seedFC-' num2str(fRange_ISA(1)) '-' num2str(fRange_ISA(2)) ];
    fcExist(strfind(fcExist,'.')) = 'p';
    fcExist=[fcExist '.mat'];
    %If is this already processed
    
    load(runInfo.saveMaskFile);
    
    disp(['Processing ', runInfo.saveHbFile ' on ', runInfo.system])
    sessionInfo = sysInfo(runInfo.system);
    
    %READ DATA AND FIND DROPPED FRAMES, and reshape
    if ~contains(runInfo.system,'EastOIS2')
        raw = readtiff(runInfo.rawFile{1});
        raw=FindandFixDroppedFrames(raw,runInfo); %JPC added
    else
        load(fullfile(runInfo.rawFile{1}))
        fixed_by_channel_cam1=FindandFixDroppedFrames(raw_unregistered,runInfo);
        binnedRaw_cam1 = fixed_by_channel_cam1(:,:,sessionInfo.cam1Chan,:);
        clear raw_unregistered fixed_by_channel_cam1
        
        load(fullfile(runInfo.rawFile{2}))
        fixed_by_channel_cam2=FindandFixDroppedFrames(raw_unregistered,runInfo);
        binnedRaw_cam2= fixed_by_channel_cam2(:,:,sessionInfo.cam2Chan,:);
        clear raw_unregistered fixed_by_channel_cam2
        
        load(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat')),'mytform')
        raw  = registerCam2andCombineTwoCams(binnedRaw_cam1,binnedRaw_cam2,mytform,sessionInfo.cam1Chan,sessionInfo.cam2Chan);
        save(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run))),'raw','-v7.3')
    end
    
    %DARK FRAME REMOVAL
    % Remove dark  frames (JPC changed to subtract average across all
    % darkframes
    if ~isempty(runInfo.darkFramesInd)
        runInfo.darkFramesInd(runInfo.darkFramesInd == runInfo.invalidFramesInd) = [];
        darkFrame = squeeze(mean(reshape(raw(:,:,:,runInfo.darkFramesInd),size(raw,1),size(raw,2),[]),3,'omitnan')); %JPC made it so that we took average across all 4 "channels"
        
        %Eliminate dark frames from
        if contains(runInfo.system,'EastOIS2')
            raw(:,:,sessionInfo.cam2Chan,:) = double(raw(:,:,sessionInfo.cam2Chan,:)) - double(repmat(darkFrame,1,1,numel(sessionInfo.cam2Chan),size(raw(:,:,sessionInfo.cam2Chan,:),4)));
            raw(:,:,sessionInfo.cam1Chan,:) = double(raw(:,:,sessionInfo.cam1Chan,:)) - double(repmat(darkFrame,1,1,numel(sessionInfo.cam1Chan),size(raw(:,:,sessionInfo.cam1Chan,:),4)));
        else
            raw = double(raw) - double(repmat(darkFrame,1,1,size(raw,3),size(raw,4)));
        end
        
        %             raw(:,:,:,1:runInfo.darkFramesInd(end)+1)=[]; %JPC get rid of the dark frames,
        raw(:,:,:,end)=raw(:,:,:,end-1); %JPC get rid of last frame too and make it the same as the one before it
        raw(:,:,:,1:runInfo.darkFramesInd(end))=[]; %JPC get rid of the dark frames
        
    else
        raw(:,:,:,runInfo.invalidFramesInd) = [];%invalidFramesInd default is 1
    end
    clear darkFrame
    
    % QC RAW DATA
    disp('rawQC analysis...');
    if ~isempty(runInfo.fluorChInd)
        representativeCh = runInfo.fluorChInd;
    else
        %which channel are we using as a reference
        representativeCh = runInfo.hbChInd(1);
    end
    
    rawTime = 1:size(raw,4);
    rawTime = rawTime/runInfo.samplingRate;
    load(runInfo.saveMaskFile)
    raw = single(raw);
    qcRawFig = qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,runInfo.system);
    savefig(qcRawFig,runInfo.saveRawQCFig);
    saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
    close(qcRawFig);
    
    %Detrending
    for i=1: size(raw,3)
        raw(:,:,i,:)=temporalDetrend(squeeze(raw(:,:,i,:)),isbrain);
    end
    %OPTICAL PROP AND SPECTROSCOPY
    %HB
    [op, E] = getHbOpticalProperties({runInfo.lightSourceFiles{runInfo.hbChInd}});
    datahb = procOIS(raw(:,:,runInfo.hbChInd,:),op.dpf,E,isbrain); %where is xform_isbrain made?
    datahb = smoothImage(datahb,runInfo.gbox,runInfo.gsigma);
    xform_datahb = affineTransform(datahb,I); %error here
    xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(xform_datahb,3),size(xform_datahb,4));
    xform_datahb(logical(1-xform_isbrain_matrix)) = NaN;
    save(runInfo.saveHbFile,'xform_datahb','op','E','runInfo','-v7.3')
    
    
    %Fluoro (calcium)
    if ~isempty(runInfo.fluorChInd)
        [op_in, E_in] = getHbOpticalProperties({runInfo.lightSourceFiles{runInfo.fluorChInd}});
        [op_out, E_out] = getHbOpticalProperties(runInfo.fluorFiles);
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
        datafluor = procFluor(squeeze(raw(:,:,runInfo.fluorChInd,:)),mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan'));
        datafluor = smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
        xform_datafluor = affineTransform(datafluor,I);
        %Fluoro-Correction
        if  strcmp('EastOIS1_GCaMP',runInfo.system) %gcamp correction
            datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
        elseif contains(runInfo.system,'EastOIS2') %jRGECGO1a correction %xw
            datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,1,1);
        end
        datafluorCorr = smoothImage(datafluorCorr,runInfo.gbox,runInfo.gsigma);
        xform_datafluorCorr=affineTransform(datafluorCorr,I);
        save(runInfo.saveFluorFile,'xform_datafluor','xform_datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','runInfo','-v7.3')
        clear datafluor datafluorCorr xform_datafluor
    end
    
    
    %FAD
    if ~isempty(runInfo.FADChInd)
        [op_inFAD, E_inFAD] = getHbOpticalProperties({runInfo.lightSourceFiles{runInfo.FADChInd}});
        [op_outFAD, E_outFAD] = getHbOpticalProperties(runInfo.FADFiles);
        dpIn = op_inFAD.dpf/2;
        dpOut = op_outFAD.dpf/2;
        
        dataFAD = procFluor(squeeze(raw(:,:,runInfo.FADChInd,:)),mean(raw(:,:,runInfo.FADChInd,:),4,'omitnan'));
        dataFAD = smoothImage(dataFAD,runInfo.gbox,runInfo.gsigma);
        xform_dataFAD = affineTransform(dataFAD,I);
        clear raw
        %FAD-Correction
        dataFADCorr = correctHb_differentBeta(dataFAD,datahb,[E_inFAD(1) E_outFAD(1)],[E_inFAD(2) E_outFAD(2)],dpIn,dpOut,1,1);
        dataFADCorr = smoothImage(dataFADCorr,runInfo.gbox,runInfo.gsigma);
        xform_dataFADCorr=affineTransform(dataFADCorr,I);
        
        
        save(runInfo.saveFADFile,'xform_dataFAD','xform_dataFADCorr','op_inFAD', 'E_inFAD', 'op_outFAD', 'E_outFAD','runInfo','-v7.3')
        clear dataFAD xform_dataFAD dataFADCorr
    end
    
    clear datahb rawTime  isbrain
    
    %Laser Frame
    if ~isempty(sessionInfo.chLaser)
        datalaser =  squeeze(raw(:,:,sessionInfo.chLaser,:));
        xform_datalaser = affineTransform(datalaser,I);
        xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(xform_datalaser,3));
        xform_datalaser(logical(1-xform_isbrain_matrix)) = NaN;
        save(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'),'xform_datalaser','runInfo','-v7.3')
    end
    
    
    
    
    %Pre-FC Process:
    OGsize=size(xform_datahb);
    
    load(runInfo.saveMaskFile,'xform_isbrain')
    mask=find(xform_isbrain);
    %Building Data Full
    if ~isempty(runInfo.fluorChInd)
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),4);
    elseif ~isempty(runInfo.FADChInd)
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),5);
    else
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),3);
    end
    %Shape Data
    data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:))*10^6;
    data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:))*10^6;
    data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))*10^6+squeeze(xform_datahb(:,:,2,:))*10^6;
    if ~isempty(runInfo.fluorChInd)
        data_full(:,:,:,4) = xform_datafluorCorr*100;
    end
    if ~isempty(runInfo.FADChInd)
        data_full(:,:,:,5) = xform_dataFADCorr*100;
    end
    
    clear xform_datafluorCorr xform_dataFADCorr xform_datahb
    
    %Power Break- Can we initalize it?
    for i=1:size(data_full,4)
        [whole_spectra_map(:,:,:,i),avg_cort_spec(:,i),powerMap(:,:,:,i),hz, global_sig_for(:,i),glob_sig_power(:,i)]= PowerAnalysis(squeeze(data_full(:,:,:,i)),runInfo.samplingRate,xform_isbrain); %anmol-semicolon
    end
    save(strcat(runInfo.saveFilePrefix,'-Power.mat'),'hz','whole_spectra_map','powerMap','global_sig_for','glob_sig_power','avg_cort_spec','-v7.3')
    
    clear whole_spectra_map powerMap global_sig_for glob_sig_power
    
    %Time Ranges: This is for anesthetized
    %do we need this...? Cant we just call runsInfo? -- JPC
    peakTimeRange(1:size(data_full,4))={runInfo.stimStartTime:runInfo.stimEndTime};
    %Setting up stim
    stimBlockSize=round(runInfo.blockLen*runInfo.samplingRate); %stim length in frames
    %why is this here?
    R=mod(size(data_full,3),stimBlockSize); %are there dropped frames?
    %if there is dropped frames
    if R~=0
        pad=stimBlockSize-R;
        disp(['** Non integer number of blocks presented. Padded with ' , num2str(pad), ' zeros **'])
        data_full(:,:,end:end+pad,:)=0;
        runInfo.appendedZeros=pad;
    end
    numBlocks = round(size(data_full,3)/(runInfo.blockLen*runInfo.samplingRate));%what if not integer
    
    % GSR, Filter, Downsample
    data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],length(runInfo.Contrasts));
    for ii = 1:length(runInfo.Contrasts)
        data_full(:,:,:,ii) =  filterData(squeeze(squeeze(data_full(:,:,:,ii))),0.01,5,runInfo.samplingRate);
    end
    data_full_BaselineShift= resample(data_full,(2*fRange_delta(2)*1.25),runInfo.samplingRate,'Dimension',3 ); %resample to 10 Hz%xw fromresample to resampledata
    data_full_gsr_BaselineShift=nan(size(data_full_BaselineShift));
    for ii = 1:length(runInfo.Contrasts)
        data_full_gsr_BaselineShift(:,:,:,ii) = gsr(squeeze(data_full_BaselineShift(:,:,:,ii)),xform_isbrain);
    end
    
    
    
    runInfo.samplingRate=(2*fRange_delta(2)*1.25); %change the sampling rate to fit the resample frequency
    clear data_full_gsr data_full
    
    %Reshape into blocks
    data_full_gsr_BaselineShift = reshape(data_full_gsr_BaselineShift,size(data_full_gsr_BaselineShift,1),size(data_full_gsr_BaselineShift,2),[],numBlocks,size(data_full_gsr_BaselineShift,4)); %reshape to pixel-pixel-blockSize-numblock-species
    data_full_BaselineShift = reshape(data_full_BaselineShift,size(data_full_BaselineShift,1),size(data_full_BaselineShift,2),[],numBlocks,size(data_full_BaselineShift,4)); %reshape to pixel-pixel-blockSize-numblock-species
    
    %Mean subtraction
    meanFrame = squeeze(mean(data_full_BaselineShift(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,:,:),3));
    data_full_BaselineShift = xform_isbrain.*(data_full_BaselineShift - permute(repmat(meanFrame,1,1,1,1, size(data_full_BaselineShift,3)), [1,2,5,3,4]  ));
    
    meanFrame = squeeze(mean(data_full_gsr_BaselineShift(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,:,:),3));
    data_full_gsr_BaselineShift = xform_isbrain.*(data_full_gsr_BaselineShift - permute(repmat(meanFrame,1,1,1,1, size(data_full_gsr_BaselineShift,3)), [1,2,5,3,4]  ));
    clear  meanFrame
    
    %Create Peak maps
    load(runInfo.saveMaskFile,'xform_StimROIMask');
    
    fh= generateBlockMap_Dynamics(data_full_BaselineShift,data_full_gsr_BaselineShift,runInfo,numBlocks,peakTimeRange,xform_isbrain,xform_StimROIMask);
    %save
    sgtitle([runInfo.recDate '-' runInfo.mouseName '-' num2str(runInfo.run),'-GSR'])
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak_Dynamics');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    close all
    save([runInfo.saveFilePrefix '-StimResults'],'data_full_gsr_BaselineShift','data_full_BaselineShift','-v7.3');

    disp(['Done Processing ', runInfo.saveHbFile ' on ', runInfo.system])
    
end


