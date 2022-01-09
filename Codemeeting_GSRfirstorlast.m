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
            peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime};%%
        elseif ~isempty(runInfo.fluorChInd)
            peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimStartTime:runInfo.stimEndTime};
        else
            peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1};
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
        for ii = [1 2 4 5]
            data_full(:,:,:,ii) = gsr(squeeze(data_full(:,:,:,ii)),xform_isbrain);
        end
        data_full(:,:,:,3) = squeeze(data_full(:,:,:,1)+data_full(:,:,:,2));
      data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,size(data_full,4));
        %Baseline Subtract
        xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data_full,3),1,1);
        for ii = 1:numBlocks
            for jj = length(runInfo.Contrasts)
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
        
        
for ii = 1:10
peakMap_addfirst(:,:,ii) = mean(total(:,:,25*9:25*11,ii),3);
end

difference = peakMap_addfirst-peakMap_gsrFirst;
for ii = 1:9
    subplot(1,10,ii)
    imagesc(difference(:,:,ii),[-0.2 0.2])
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
end
p = subplot(1,10,10);
imagesc(difference(:,:,10),[-0.2 0.2])
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
cb = colorbar;

Pos = get(p,'Position');
set(p,'Position',Pos)
set(get(cb,'label'),'string','Hb(\Delta\muM)');
suptitle('add hb first - gsr Hb first')







 total = squeeze(data_full(:,:,:,:,3));
peakMap_gsrFirst = nan(128,128,10);
for ii = 1:10
peakMap_gsrFirst(128,128,ii) = mean(total(:,:,125:250,ii),3);
end
Unable to perform assignment because the size of the left side is 1-by-1 and the
size of the right side is 128-by-128.
 
peakMap_gsrFirst(:,:,ii) = mean(total(:,:,125:250,ii),3);
figure;imagesc(peakMap_gsrFirst(:,:,1))
figure;imagesc(peakMap_gsrFirst(:,:,2))
for ii = 1:10
peakMap_gsrFirst(128,128,ii) = mean(total(:,:,125:250,ii),3);
end
Unable to perform assignment because the size of the left side is 1-by-1 and the
size of the right side is 128-by-128.
 
peakMap_gsrFirst(:,:,ii) = mean(total(:,:,125:250,ii),3);
for ii = 1:10
peakMap_gsrFirst(:,:,ii) = mean(total(:,:,125:250,ii),3);
end
figure
imagesc(peakMap_gsrFirst(:,:,2))
colormap jet
for ii = 1:10
peakMap_gsrFirst(:,:,ii) = mean(total(:,:,25*9:25*11,ii),3);
end
figure
imagesc(peakMap_gsrFirst(:,:,2))
colormap jet
figure
imagesc(peakMap_gsrFirst(:,:,10))
colormap jet
data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),3);
data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:))*10^6;
        data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:))*10^6;
        data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))*10^6+squeeze(xform_datahb(:,:,2,:))*10^6;
data_full(:,:,:,4) = xform_datafluorCorr*100;
data_full(:,:,:,5) = xform_dataFADCorr*100;
data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],length(runInfo.Contrasts));
for ii = 1:size(data_full,4)
            data_full(:,:,:,ii) = gsr(squeeze(data_full(:,:,:,ii)),xform_isbrain);
        end
data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,size(data_full,4));
        %Baseline Subtract
        xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data_full,3),1,1);
        for ii = 1:numBlocks
            for jj = length(runInfo.Contrasts)
                meanFrame = squeeze(mean(data_full(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
                data_full(:,:,:,ii,jj) = data_full(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data_full,3),1,1);
                data_full(:,:,:,ii,jj) = data_full(:,:,:,ii,jj).*xform_isbrain_matrix;
            end
        end
data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,length(runInfo.Contrasts));
total = squeeze(data_full(:,:,:,:,3));
peakMap_addfirst = nan(128,128,10);


for ii = 1:9
    subplot(1,10,ii)
    imagesc(difference(:,:,ii),[-0.8 0.8])
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
end
p = subplot(1,10,10);
imagesc(difference(:,:,10),[-0.8 0.8])
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
cb = colorbar;

Pos = get(p,'Position');
set(p,'Position',Pos)
set(get(cb,'label'),'string','Hb(\Delta\muM)');
suptitle('add hb first - gsr Hb first')


