function FCMatrix = calcFCMatrix(data,minFreq,maxFreq,fs,isbrain)
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\CerebMask.mat')
mask = cerebralMask.*isbrain;
mask = logical(mask); 
for ii = 1:length(data)
    data(:,:,ii) = data(:,:,ii).*double(mask);
end
data = mouse.process.gsr(data,mask);
data = mouse.freq.filterData(double(data),minFreq,maxFreq,fs);
if maxFreq == 4
    outFreq = 10;
else
    outFreq = 1;
end
data = resampledata(data,fs,outFreq,10^-5);

totalLength = sum(mask,'all');
mask = reshape(mask,[],1);
data = reshape(data,[],size(data,3));
data = data(mask,:);
FCMatrix = zeros(totalLength,totalLength);
for ii = 1:totalLength
    for jj = 1:totalLength
       FCMatrix(ii,jj) = normRow(data(ii,:))*normRow(data(jj,:))';           
    end
end
