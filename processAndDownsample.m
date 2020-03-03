function downSampledData  = processAndDownsample(data,mask,numBlock,numDesample,stimStartTime)
%input needs to be 128*128*time



mask = double(mask);
data = double(data).*mask;
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = reshape(data,size(data,1),size(data,2),[]);
import mouse.*
downSampledData = resampledata(data,size(data,3),numDesample,10^-5);
downSampledData = reshape(downSampledData,size(data,1),size(data,2),[],numBlock);
downSampledDataBlockAvg = squeeze(mean(downSampledData,4));
downSampledDataBaseline = squeeze(mean(downSampledDataBlockAvg(:,:,1:stimStartTime),3));
downSampledData = downSampledData-downSampledDataBaseline;
end
