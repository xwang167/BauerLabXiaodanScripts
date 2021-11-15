function FCMatrix = calcFCMatrix_noGSR(data,minFreq,maxFreq,fs,isbrain)
load('D:\OIS_Process\noVasculatureMask.mat')
data = imresize(data,0.5);
mask = (leftMask+rightMask).*isbrain;
mask = imresize(mask,0.5);
mask(mask<0.5) = 0;
mask = logical(mask);  
for ii = 1:length(data)
    data(:,:,ii) = data(:,:,ii).*double(mask);
end
data = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
% if maxFreq > 2
%     outFreq = 10;
% elseif maxFreq > 0.2
%     outFreq = 5;
% else
%     outFreq = 1;
% end
% data = resampledata(data,fs,outFreq,10^-5);

totalLength = sum(mask,'all');
mask = reshape(mask',[],1);
data = reshape(permute(data,[2 1 3]),[],size(data,3));
data = data(mask,:);
FCMatrix = normRow(data)*normRow(data)';           

