function [lagTimeProjectionMatrix,lagAmpProjectionMatrix ] = calcProjectionLagMatrix(data,minFreq,maxFreq,fs,edgeLen,validRange,corrThr)
load('D:\OIS_Process\noVasculatureMask.mat')

%% resize to half
data = imresize(data,0.5);
leftMask = imresize(leftMask,0.5);
rightMask = imresize(rightMask,0.5);
mask = leftMask+rightMask;
for ii = 1:length(data)
    data(:,:,ii) = data(:,:,ii).*double(mask);
end
data = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
if maxFreq == 4
    outFreq = 10;
else
    outFreq = 1;
end
data = resampledata(data,fs,outFreq,10^-5);
validRange = validRange*outFreq/fs;
mask = logical(mask); 
totalLength = sum(mask,'all');
nVx= size(mask,2);
nVy = size(mask,1);
mask = reshape(mask,[],1);
data = reshape(data,[],size(data,3));
data = data(mask,:);
lagTimeProjectionMatrix = zeros(totalLength,totalLength);
lagAmpProjectionMatrix = zeros(totalLength,totalLength);
for ii = 1:totalLength
    for jj = 1:totalLength
            [lagTimeProjectionMatrix(ii,jj),lagAmpProjectionMatrix(ii,jj)] = mouse.conn.findLag(...
                data(ii,:),data(jj,:),true,true,validRange,edgeLen,corrThr);           
    end
end
clear data
lagTimeProjectionMatrix = lagTimeProjectionMatrix/outFreq;
end