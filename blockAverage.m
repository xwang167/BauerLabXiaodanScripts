function [downSampledDataBlockAvg,dataBlockAvg,dataBlockAvgBaseline] = blockAverage(downSampledData,data,goodBlocks,numBlock,stimStartFrame)
downSampledDataBlockAvg = squeeze(mean(downSampledData(:,:,:,goodBlocks),4));
data = reshape(data,size(data,1),size(data,2),[],numBlock);
dataBlockAvg = squeeze(mean(data(:,:,:,goodBlocks),4));
dataBlockAvgBaseline = squeeze(mean(dataBlockAvg(:,:,1:stimStartFrame),3));
dataBlockAvg = dataBlockAvg - dataBlockAvgBaseline;
end