poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
% excelFile="C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\examples\Code Modification\exampleTiffOIS+Gcamp.xlsx";
% excelRows=[15];  % Rows from Excell Database
%clear all;close all;
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO_OptoWhisker.xlsx";
excelRows=3:14;

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';
runNum = numel(runsInfo);

for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    
    %If is this already processed
  
    
        load(runInfo.saveHbFile,'xform_datahb')
        load(runInfo.saveMaskFile,'xform_isbrain')
        if ~isempty(runInfo.fluorChInd)
            load(runInfo.saveFluorFile,'xform_datafluorCorr')
        end
        if ~isempty(runInfo.FADChInd)
            load(runInfo.saveFADFile,'xform_dataFADCorr')
        end
   
    
    
    
    %Pre-FC Process:
    if runInfo.session =="fc"
        %Initialize
        if ~isempty(runInfo.fluorChInd)
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),4);
        elseif ~isempty(runInfo.FADChInd)
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),5);
        else
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),3);
        end
        %Shape Data
        data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:));
        data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:));
        data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))+squeeze(xform_datahb(:,:,2,:));
        if ~isempty(runInfo.fluorChInd)
            data_full(:,:,:,4) = xform_datafluorCorr;
        end
        if ~isempty(runInfo.FADChInd)
            data_full(:,:,:,5) = xform_dataFADCorr;
        end

        %Power Break- Can we initalize it?
        for i=1:size(data_full,4)
        [whole_spectra_map(:,:,:,i),powerMap(:,:,:,i),hz, global_sig_for(:,i),glob_sig_power(:,i)]= PowerAnalysis(squeeze(data_full(:,:,:,i)),runInfo.samplingRate,xform_isbrain); %anmol-semicolon    
        end
        save(strcat(runInfo.saveFilePrefix,'-Power.mat'),'hz','whole_spectra_map','powerMap','global_sig_for','glob_sig_power','-v7.3')
        
        clear  xform_datafluorCorr xform_datahb xform_dataFADCorr ...
            whole_spectra_map powerMap global_sig_for glob_sig_power
        
        %Filter
        data_isa= nan(size(data_full));
        data_delta= nan(size(data_full));
        for ii=1:size(data_full,4) %!JPC-210924 changed filterdata to take in xform_isbrain.
            data_isa(:,:,:,ii)=filterData_isbrain(data_full(:,:,:,ii),fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate,xform_isbrain);
            data_delta(:,:,:,ii)=filterData_isbrain(data_full(:,:,:,ii),fRange_delta(1),fRange_delta(2),runInfo.samplingRate,xform_isbrain);
        end
                
        clear data_full
        
        %GSR
        for  ii=1:size(data_isa,4)
            data_isa(:,:,:,ii) = gsr(squeeze(data_isa(:,:,:,ii)),xform_isbrain);
            data_delta(:,:,:,ii) = gsr(squeeze(data_delta(:,:,:,ii)),xform_isbrain);
        end
        
            xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data_delta,3),size(data_delta,4));
            data_isa(logical(1-xform_isbrain_matrix)) = NaN;%do we
            data_delta(logical(1-xform_isbrain_matrix)) = NaN;
        %QC FC
        %ISA
tic
        fStr = [num2str(fRange_ISA(1)) '-' num2str(fRange_ISA(2))];
        fStr(strfind(fStr,'.')) = 'p';
        ContFig2Save= {'HbO','HbT'};
        [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap]...
            = qcFC(data_isa,xform_isbrain,runInfo.Contrasts,runInfo,fRange_ISA,ContFig2Save);
        
        for contrastInd = 1:numel(ContFig2Save)
            saveFCQCFigName = [runInfo.saveFCQCFig '-' ContFig2Save{contrastInd} '-' fStr ];
            saveas(fh(contrastInd),[saveFCQCFigName '.png']);
            close(fh(contrastInd));
        end
toc
        %Saving
        contrastName = runInfo.Contrasts;
        saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
        save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
        saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
        save(saveBilateralFCName,'contrastName','bilatFCMap','xform_isbrain','-v7.3');
        
        
        %Delta Band
        if ~isempty(runInfo.fluorChInd)
            
            fStr = [num2str(fRange_delta(1)) '-' num2str(fRange_delta(2))];
            fStr(strfind(fStr,'.')) = 'p';
            ContFig2Save= {'Calcium'};
            if ~isempty(runInfo.FADChInd)
                ContFig2Save= {'Calcium','FAD'};
            end
            clear fh
            if ~strcmp(runInfo.system,'EastOIS1')
                [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap]...
                    = qcFC(data_delta,xform_isbrain,runInfo.Contrasts,runInfo,fRange_delta,ContFig2Save);
                
                for contrastInd = 1:numel(ContFig2Save)
                    saveFCQCFigName = [runInfo.saveFCQCFig '-' ContFig2Save{contrastInd} '-' fStr ];
                    saveas(fh(contrastInd),[saveFCQCFigName '.png']);
                    close(fh(contrastInd));
                end
            end
            %Saving
            saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
            save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
            saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
            save(saveBilateralFCName,'contrastName','bilatFCMap','xform_isbrain','-v7.3');
        end
        
        
        
        
    elseif runInfo.session =="stim"
        load(runInfo.saveMaskFile,'xform_isbrain')
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

        %Power Break- Can we initalize it?
        for i=1:size(data_full,4)
        [whole_spectra_map(:,:,:,i),powerMap(:,:,:,i),hz, global_sig_for(:,i),glob_sig_power(:,i)]= PowerAnalysis(squeeze(data_full(:,:,:,i)),runInfo.samplingRate,xform_isbrain); %anmol-semicolon    
        end
        save(strcat(runInfo.saveFilePrefix,'-Power.mat'),'hz','whole_spectra_map','powerMap','global_sig_for','glob_sig_power','-v7.3')
        
        clear whole_spectra_map powerMap global_sig_for glob_sig_power
  
        if ~isempty(runInfo.FADChInd)
            peakTimeRange = {runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime};%%
        elseif ~isempty(runInfo.fluorChInd)
            peakTimeRange = {runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime};
        else
            peakTimeRange = {runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime};
        end
        
        stimBlockSize=round(runInfo.blockLen*runInfo.samplingRate);
        R=mod(size(data_full,3),stimBlockSize);
        
        if R~=0
            pad=stimBlockSize-R;
            disp(['** Non integer number of blocks presented. Padded with ' , num2str(pad), ' zeros **'])
            data_full(:,:,end:end+pad,:)=0;
            runInfo.appendedZeros=pad;
        end
        
        numBlocks = round(size(data_full,3)/(runInfo.blockLen*runInfo.samplingRate));%what if not integer
        
        % GSR function takes concatonated data
        data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],length(runInfo.Contrasts));
        % gsr
        for ii = 1:size(data_full,4)
            data_full(:,:,:,ii) = gsr(squeeze(data_full(:,:,:,ii)),xform_isbrain);
        end
        
      data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,size(data_full,4));
        %Baseline Subtract
        xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data_full,3),1,1);
        for ii = 1:numBlocks
            for jj = 1:length(runInfo.Contrasts)
                meanFrame = squeeze(mean(data_full(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
                data_full(:,:,:,ii,jj) = data_full(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data_full,3),1,1);
                data_full(:,:,:,ii,jj) = data_full(:,:,:,ii,jj).*xform_isbrain_matrix;
            end
        end
        clear xform_isbrain_matrix meanFrame
        %Reshape
        data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,length(runInfo.Contrasts));
        %Create pres maps
        
        
        fh= generateBlockMap(data_full,runInfo.Contrasts,runInfo,numBlocks,peakTimeRange,xform_isbrain);
        %save
        sgtitle([runInfo.saveFilePrefix(17:end),'GSR']) %anmol - suptitle to sgtitle
        saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak');
        saveas(gcf,strcat(saveName,'.fig'))
        saveas(gcf,strcat(saveName,'.png'))
        close all
        
        
    end
    disp(['Done Processing ', runInfo.saveHbFile ' on ', runInfo.system])
    
end


%% Averaging
