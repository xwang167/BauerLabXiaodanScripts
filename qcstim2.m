runInd = 1;
runInfo=runsInfo(runInd);
if runsInfo(1).session =="stim"
    load(runInfo.saveMaskFile,'xform_isbrain')
    if ~isempty(runInfo.fluorChInd)
        contrastName = {'HbO','HbR','HbT','Fluor'};
        colors = {'r','b','k','g'};
    else
        contrastName = {'HbO','HbR','HbT'};
        colors = {'r','b','k'};
    end
    
    data = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),length(contrastName));
    data(:,:,:,1) = squeeze(xform_datahb(:,:,1,:))*10^6;
    data(:,:,:,2) = squeeze(xform_datahb(:,:,2,:))*10^6;
        clear xform_datahb
    data(:,:,:,3) = data(:,:,:,1) + data(:,:,:,2);
    if ~isempty(runInfo.fluorChInd)
        data(:,:,:,4) = xform_datafluorCorr*100;
        clear xform_datafluorCorr
    end
    numBlocks = size(data,3)/(runInfo.blockLen*runInfo.samplingRate);%what if not integer
        
      % GSR function takes concatonated data
    data = reshape(data,size(data,1),size(data,2),[],length(contrastName));
     % gsr
    for ii = size(data,4)
        data(:,:,:,ii) = gsr(squeeze(data(:,:,:,ii)),xform_isbrain);
    end
        data = reshape(data,size(data,1),size(data,2),[],numBlocks,size(data,4));
%Baseline Subtract
    xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data,3),1,1);
    for ii = 1:numBlocks
        for jj = length(contrastName)
            meanFrame = squeeze(mean(data(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
            data(:,:,:,ii,jj) = data(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data,3),1,1);
            data(:,:,:,ii,jj) = data(:,:,:,ii,jj).*xform_isbrain_matrix;
        end
    end
    clear xform_isbrain_matrix meanFrame 
    %Reshape to OG shape
    data = reshape(data,size(data,1),size(data,2),[],numBlocks,length(contrastName));
 %QC and Plotting for GSR data       
    range = nan(1,length(contrastName));
    range(1) = 8;
    range(2) = 4;
    range(3) = 4;
    if ~isempty(runInfo.fluorChInd)
        range(4) = 0.8;
    end
    
    [fh] = generateBlockMap(data,contrastName,range,runInfo,numBlocks);
    %save
    suptitle([runInfo.saveFilePrefix(17:end),'GSR'])
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    save(runInfo.saveHbFile,'ROI_GSR','-append')
    close all
    
    suptitle([runInfo.saveFilePrefix(17:end),'GSR'])
    [fh,ROI] = generateROI(data,contrastName,runInfo,numBlocks,xform_isbrain);
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_PeakMap');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    close all
    
    %Plot Average Time Traces for all contrasts
    timeTraceforall(data,runInfo,ROI_NoGSR,colors,contrastName,1:numBlocks);
    suptitle([runInfo.saveFilePrefix(17:end),'GSR'])
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_TimeTrace');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    %close all
    
end