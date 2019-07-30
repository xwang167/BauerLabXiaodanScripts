raw = squeeze(rawdata(:,:,1,7:end));
raw_smooth = mouse.process.smoothImage(raw,5,1.2);
raw = reshape(raw,[],5999);
mdata_raw = squeeze(mean(raw(ibi,:),1));
raw_smooth = reshape(raw_smooth,[],5999);
mdata_raw_smooth = squeeze(mean(raw_smooth(ibi,:),1));
fdata_raw = abs(fft(mdata_raw));
fdata_raw_smooth = abs(fft(mdata_raw_smooth));
hz = linspace(0,20,5999);
figure;loglog(hz(1:round(end/2)),fdata_raw(1:round(end/2)));
hold on
loglog(hz(1:round(end/2)),fdata_raw_smooth(1:round(end/2)));
raw_detrend = temporalDetrendAdam(squeeze(rawdata(:,:,1,7:end)));
raw_detrend = reshape(raw_detrend,[],5999);
mdata_raw_detrend = squeeze(mean(raw_detrend(ibi,:),1));
fdata_raw_detrend = abs(fft(mdata_raw_detrend));
loglog(hz(1:round(end/2)),fdata_raw_detrend(1:round(end/2)));
gcamp = reshape(xform_gcamp,[],5999);
gcampCorr = reshape(xform_gcampCorr,[],5999);
mdata_gcamp = squeeze(nanmean(gcamp(ibi,:),1));
mdata_gcampCorr = squeeze(nanmean(gcampCorr(ibi,:),1));
fdata_gcamp = fft(mdata_gcamp);
fdata_gcampCorr = fft(mdata_gcampCorr);
%%

figure; 

loglog(hz(1:round(end/2)),abs(fdata_blue(1:round(end/2)))/mean(abs(fdata_blue(1:round(end/2)))),'b')
hold on; loglog(hz(1:round(end/2)),abs(fdata_blue_detrend(1:round(end/2)))/mean(abs(fdata_blue_detrend(1:round(end/2)))),'r')
hold on;loglog(hz(1:round(end/2)),abs(fdata_raw_smooth(1:round(end/2)))/mean(abs(fdata_raw_smooth(1:round(end/2)))),'y')
hold  on; loglog(hz(1:round(end/2)),abs(fdata_gcamp(1:round(end/2)))/mean(abs(fdata_gcamp(1:round(end/2)))),'g')
hold on; loglog(hz(1:round(end/2)),abs(fdata_gcampCorr(1:round(end/2)))/mean(abs(fdata_gcampCorr(1:round(end/2)))),'k')
legend('raw','detrended raw','detrend and then smoothed raw','gcamp','gcampCorr','location','southwest')
title('fft after getting global signal')



 fdata_blue2 = zeros(16384,5999);
fdata_blue_detrend2 =zeros(16384,5999);
fdata_blue_smooth2 = zeros(16384,5999);
fdata_gcampCorr2 = zeros(16384,5999);
fdata_gcamp2 = zeros(16384,5999);
for ii = 1:16384
        fdata_blue2(ii,:) = abs(fft(squeeze(blue(ii,:))));
        fdata_blue_detrend2(ii,:) =abs(fft(squeeze(blue_detrend(ii,:))));
        fdata_blue_smooth2(ii,:) = abs(fft(squeeze(blue_smooth(ii,:))));
        fdata_gcampCorr2(ii,:) = abs(fft(squeeze(gcampCorr(ii,:))));
        fdata_gcamp2(ii,:) = abs(fft(squeeze(gcamp(ii,:)))); 
end

fdata_blue2_avg = nanmean(fdata_blue2(ibi,:));
fdata_blue_detrend2_avg = nanmean(fdata_blue_detrend2(ibi,:));
fdata_blue_smooth2_avg = nanmean(fdata_blue_smooth2(ibi,:));
fdata_gcampCorr2_avg = nanmean(fdata_gcampCorr2(ibi,:));
fdata_gcamp2_avg = nanmean(fdata_gcamp2(ibi,:));

figure; 
loglog(hz(1:round(end/2)),abs(fdata_blue2_avg(1:round(end/2)))/mean(abs(fdata_blue2_avg(1:round(end/2)))),'b')
hold on; loglog(hz(1:round(end/2)),abs(fdata_blue_detrend2_avg(1:round(end/2)))/mean(abs(fdata_blue_detrend2_avg(1:round(end/2)))),'r')
hold on;loglog(hz(1:round(end/2)),abs(fdata_blue_smooth2_avg(1:round(end/2)))/mean(abs(fdata_blue_smooth2_avg(1:round(end/2)))),'y')
hold  on; loglog(hz(1:round(end/2)),abs(fdata_gcamp2_avg(1:round(end/2)))/mean(abs(fdata_gcamp2_avg(1:round(end/2)))),'g')
hold on; loglog(hz(1:round(end/2)),abs(fdata_gcampCorr2_avg(1:round(end/2)))/mean(abs(fdata_gcampCorr2_avg(1:round(end/2)))),'k')
legend('raw','detrended raw','detrend and then smoothed raw','gcamp','gcampCorr','location','southwest')
title('Average abs(fft) across all pixels')