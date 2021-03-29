%%ROI time trace

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [149];
runsInfo = parseTiffRuns(excelFile,excelRows);
runNum = numel(runsInfo);

for runInd = 1:runNum
    runInfo=runsInfo(runInd);
    load('L:\GCaMP\190527\190527-G11M2-awake-stim3_processed.mat', 'xform_datahb','gcampCorr')
    load('L:\GCaMP\Xiaodan_dpf\191002\191002-G36M3-awake-1hz-LandmarksAndMask.mat', 'xform_isbrain')
%     load(runInfo.saveHbFile,'xform_datahb');
%     load(runInfo.saveMaskFile,'xform_isbrain')
    if ~isempty(runInfo.fluorChInd)
        %load(runinfo.saveFluorFile,'xform_datafluorCorr')
        contrastName = {'HbO','HbR','HbT','Fluor'};
    else
        contrastName = {'HbO','HbR','HbT'};
    end

    % all contrast to one matrix
    data = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),length(contrastName));
    data(:,:,:,1) = squeeze(xform_datahb(:,:,1,:))*10^6;
    data(:,:,:,2) = squeeze(xform_datahb(:,:,2,:))*10^6;
   clear xform_datahb
    data(:,:,:,3) = data(:,:,:,1) + data(:,:,:,2);
    if ~isempty(runInfo.fluorChInd)
        data(:,:,:,4) = xform_datafluorCorr*100;
        clear xform_datafluorCorr
    end
    numBlocks = size(data,3)/(runInfo.blockLen*runInfo.samplingRate);
    data = reshape(data,size(data,1),size(data,2),[],numBlocks,size(data,4));
%subtract Baseline
    xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data,3),1,1);
    for ii = 1:numBlocks
        for jj = length(contrastName)
            meanFrame = squeeze(mean(data(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
            data(:,:,:,ii,jj) = data(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data,3),1,1);
            data(:,:,:,ii,jj) = data(:,:,:,ii,jj).*xform_isbrain_matrix;
        end
    end
    range = nan(1,length(contrastName));
    range(1) = 10;
    range(2) = 5;
    range(3) = 5;
    if ~isempty(runInfo.fluorChInd)
        range(4) = 2;
    end
% % pick good blocks and determine ROI
    [fh_NoGSR,goodBlocks_NoGSR,ROI_NoGSR] = PickGoodBlockandROI(data,contrastName,range,runInfo,numBlocks,xform_isbrain);
    suptitle(strcat(runInfo.saveFilePrefix(17:end),' NoGSR Peak Map for Each Block'))
    saveName = strcat(runInfo.saveFilePrefix,'_NoGSR_BlockPeak');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    save(runInfo.saveHbFile,'ROI_NoGSR','goodBlocks_NoGSR','-append');
   
    range = nan(1,length(contrastName));
    range(1) = 8;
    range(2) = 4;
    range(3) = 4;
    if ~isempty(runInfo.fluorChInd)
        range(4) = 0.8;
    end
    
    % all contrast to one matrix
    data = reshape(data,size(data,1),size(data,2),[],length(contrastName));
     % gsr
    for ii = size(data,4)
        data(:,:,:,ii) = gsr(squeeze(data(:,:,:,ii)),xform_isbrain);
    end
    % pick block and generate ROI
    data = reshape(data,size(data,1),size(data,2),[],numBlocks,length(contrastName));
    [fh_GSR,goodBlocks_GSR,ROI_GSR] = PickGoodBlockandROI(data,contrastName,range,runInfo,numBlocks,xform_isbrain);
    suptitle(strcat(runInfo.saveFilePrefix(17:end),' GSR Peak Map for Each Block'))
    %save
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    save(runInfo.saveHbFile,'ROI_GSR','goodBlocks_GSR','-append')
    close all
end


for runInd = 1:runNum
    runInfo=runsInfo(runInd);
    %load(runInfo.saveHbFile,'xform_datahb','ROI_NoGSR','ROI_GSR');
    %load(runInfo.saveMaskFile,'xform_isbrain')
    if ~isempty(runInfo.fluorChInd)
        %load(runinfo.saveFluorFile,'xform_datafluorCorr','xform_datafluor')
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
    
    %reshape
    numBlocks = size(data,3)/(runInfo.blockLen*runInfo.samplingRate);
    data = reshape(data,size(data,1), size(data,2),[],numBlocks,size(data,4));
    
    %subtract Baseline
    xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data,3),1,1);
    for ii = 1:numBlocks
        for jj = 1:length(contrastName)
            meanFrame = squeeze(mean(data(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
            data(:,:,:,ii,jj) = data(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data,3),1,1);
            data(:,:,:,ii,jj) = data(:,:,:,ii,jj).*xform_isbrain_matrix;
        end
    end
    %Plot for all contrasts
    fh = timeTraceforall(data,runInfo,ROI_NoGSR,colors,contrastName,goodBlocks_NoGSR);
    suptitle([runInfo.saveFilePrefix(17:end),'No GSR'])
    saveName = strcat(runInfo.saveFilePrefix,'_NoGSR_TimeTrace');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    
    
    %% Image sequence + time trace + peakMap
    contrastHb = {'HbO','HbR','HbT'};
    colorsHb = {'r','b','k'};
    fh = imageSequenceandTimeTrace(data(:,:,:,:,1:3),runInfo,xform_isbrain,...
        goodBlocks_NoGSR,contrastHb,ROI_NoGSR,colorsHb,'Hb(\Delta\muM)');
    
    suptitle([runInfo.saveFilePrefix(17:end),'No GSR'])
    saveName= strcat(runInfo.saveFilePrefix,'_NoGSR_imageSequence_Hb');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    if ~isempty(runInfo.fluorChInd)
        xform_datafluor = reshape(xform_datafluor,size(xform_datafluor,1), size(xform_datafluor,2),[],numBlocks);
        data2 = nan(size(xform_datafluor,1),size(xform_datafluor,2),...
            size(xform_datafluor,3),size(xform_datafluor,4),2);
        data2(:,:,:,:,1) = xform_datafluor*100;
        clear xform_datafluor
        data2(:,:,:,:,2) = data(:,:,:,:,4);
        clear data
        fh = imageSequenceandTimeTrace(data2,runInfo,xform_isbrain,...
            goodBlocks_NoGSR,{'fluor','Corrected Fluor'},ROI_NoGSR,{'k','g'},'Fluorescence(\DeltaF/F)');
        
        suptitle([runInfo.saveFilePrefix(17:end),'No GSR'])
        saveName = strcat(runInfo.saveFilePrefix,'_NoGSR_imageSequence_fluor');
        saveas(gcf,strcat(saveName,'.fig'))
        saveas(gcf,strcat(saveName,'.png'))
    end
    close all
end
