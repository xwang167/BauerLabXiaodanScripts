function [lagTime_projection,lagAmp_projection] = calcProjectionLag(data,minFreq,maxFreq,fs,edgeLen,validRange,corrThr)
load('D:\OIS_Process\noVasculatureMask.mat')
data = data
mask = leftMask+rightMask;
for ii = 1:length(data)
    data(:,:,ii) = data(:,:,ii).*double(mask);
end
data_filtered = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
clear data
mask = logical(mask);
nVx= size(mask,2);
nVy = size(mask,1);
mask = reshape(mask,[],1);
data_filtered = reshape(data_filtered,[],size(data_filtered,3));
lagTimeProjectionMatrix = zeros(size(data_filtered,1),size(data_filtered,1));
lagAmpProjectionMatrix = zeros(size(data_filtered,1),size(data_filtered,1));
for ii = 1:size(data_filtered,1)
    for jj = 1:size(data_filtered,1)
        if mask(ii)==1 && mask(jj)==1
            [lagTimeProjectionMatrix(ii,jj),lagAmpProjectionMatrix(ii,jj),~] = mouse.conn.findLag(...
                data_filtered(ii,:),data_filtered(jj,:),false,true,validRange,edgeLen,corrThr);

            
        else
            lagTimeProjectionMatrix(ii,jj) = nan;
            lagAmpProjectionMatrix(ii,jj) = nan;
        end
    end
end
lagTime_projection = nanmean(lagTimeProjectionMatrix,2);
lagAmp_projection = nanmean(lagAmpProjectionMatrix,2);

lagTime_projection = reshape(lagTime_projection,nVy,nVx);
lagAmp_projection = reshape(lagAmp_projection,nVy,nVx);
lagTime_projection = lagTime_projection./fs;
end