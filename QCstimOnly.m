excelFile="X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\PVChR2_Thy1RGECO_sensorimotor.xlsx";
excelRows=13;

runsInfo = parseRuns(excelFile,excelRows);
runInfo = runsInfo(1);
load(runInfo.saveMaskFile,'xform_isbrain')
               load(runInfo.saveHbFile,'xform_datahb')
        
        if ~isempty(runInfo.fluorChInd)
            load(runInfo.saveFluorFile,'xform_datafluorCorr')
        end
        
        
        if ~isempty(runInfo.laserChInd)    %xw 220603 add for laser channel
            load(strcat(runInfo.saveFilePrefix,'-dataLaser.mat'),'xform_datalaser')
        end
        
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
        if strcmp(runInfo.system,'EastOIS2+laser')%xw 220702 add laser channel
            data_full(:,:,:,5) = xform_datalaser;
        end
        
        clear xform_datafluorCorr xform_dataFADCorr xform_datahb
        
%         %Power Break- Can we initalize it?
%         hz_size=2049; %seems to be the default...Need to find a data driven way. This is for pwelch
%         whole_spectra_map=nan(128,128,hz_size,numel(runInfo.Contrasts));
%         avg_cort_spec=nan(hz_size,numel(runInfo.Contrasts));
%         powerMap=nan(128,128,3,numel(runInfo.Contrasts));
%         global_sig_for=nan(hz_size,numel(runInfo.Contrasts));
%         glob_sig_power=nan(3,numel(runInfo.Contrasts));
%         
%         for contrast=1:numel(runInfo.Contrasts)
%             [whole_spectra_map(:,:,:,contrast),avg_cort_spec(:,contrast),powerMap(:,:,:,contrast),hz, global_sig_for(:,contrast),glob_sig_power(:,contrast)]= PowerAnalysis(squeeze(data_full(:,:,:,contrast)),runInfo.samplingRate,xform_isbrain);
%         end
%         save(strcat(runInfo.saveFilePrefix,'-Power.mat'),'hz','whole_spectra_map','powerMap','global_sig_for','glob_sig_power','-v7.3')
%         
%         clear whole_spectra_map powerMap global_sig_for glob_sig_power
        
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
        fRange_delta = [0.5 4];
        data_full_BaselineShift= resample(data_full,(2*fRange_delta(2)*1.25),runInfo.samplingRate,'Dimension',3 ); %resample to 10 Hz
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
        
        [fh,peakMaps]= generateBlockMap_Dynamics(data_full_BaselineShift,data_full_gsr_BaselineShift,runInfo,numBlocks,peakTimeRange,xform_isbrain,xform_StimROIMask);
        %save
        sgtitle([runInfo.recDate '-' runInfo.mouseName '-' num2str(runInfo.run),'-GSR'])
        saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak_Dynamics');
        saveas(gcf,strcat(saveName,'.fig'))
        export_fig(strcat(saveName,'.png'), '-transparent')
        close all
        save([runInfo.saveFilePrefix '-StimResults'],'data_full_gsr_BaselineShift','data_full_BaselineShift','-v7.3');
        





