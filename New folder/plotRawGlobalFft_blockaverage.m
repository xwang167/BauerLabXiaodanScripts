function plotRawGlobalFft_blockaverage(framerate,blocksize,raw,nVy,nVx,numChannels,numBlocks,mouseType,systemType,isbrain)
if strcmp(mouseType,'jrgeco1a')||strcmp(systemType,'EastOIS2')
    Colors = [0.6 0 0 ;0 1 0;1 0 0];
    legendName = {'red fluorescence', 'green LED', 'red LED'};
elseif strcmp(mouseType,'gcamp6f')||strcmp(systemType,'EastOIS2')
    Colors = [0 0.6 0 ;0 1 0;1 0 0];
    legendName = {'green fluorescence', 'green LED', 'red LED'};
end

raw4 = reshape(raw,[nVy*nVx numChannels numBlocks blocksize]);
raw_blockAverage = mean(raw4,3);
ibi=find(isbrain==1);
mdata_blockAverage = squeeze(mean(raw_blockAverage(ibi,:,:),1));
hz=linspace(0,framerate,blocksize);
fdata_blockAverage=abs(fft(logmean(mdata_blockAverage),[],2));
figure;
subplot('position',[0.15,0.15,0.7,0.7])
p=loglog(hz(1:ceil(blocksize)),fdata_blockAverage(:,1:ceil(blocksize))'); title('FFT Raw Data');
for c=1:numChannels
    set(p(c),'Color',Colors(c,:));
end
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT for Global Raw')

legend(p,legendName,'Location','southwest')
