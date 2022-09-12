figure
plot((1:6000)/20,HbR_ROI,'r')
hold on
plot((1:6000)/20,HbR_filter_ROI,'b')
xlabel('Time(s)')
ylabel('\Delta\muM')
title('HbR')
legend('No filter','Filter')

figure
plot((1:6000)/20,HbR_filter_ROI-HbR_ROI,'k')
xlabel('Time(s)')
ylabel('\Delta\muM')
title('filter-no filter')

[Pxx_HbR,hz] = pwelch(HbR_ROI,[],[],[],20);
[Pxx_HbR_filter,hz] = pwelch(HbR_filter_ROI,[],[],[],20);

figure
loglog(hz,Pxx_HbR)
grid on
hold on
loglog(hz,Pxx_HbR_filter)
legend('No filter','Filter','location','southwest')
xlabel('Frequency(Hz)')
ylabel('(\Delta\muM)^2/Hz')

figure
loglog(hz,Pxx_HbR_filter./Pxx_HbR)
xlabel('Frequency(Hz)')
title('filter/nofilter')


peakMaps_calcium_filter = nan(128,128,10);
peakMaps_HbO_filter = nan(128,128,10);
peakMaps_HbR_filter= nan(128,128,10);
for ii = 1:10
    peakMaps_calcium_filter(:,:,ii) = mean(calcium_filter(:,:,100:200,ii),3);
    peakMaps_HbO_filter(:,:,ii) = mean(HbO_filter(:,:,100:200,ii),3);
    peakMaps_HbR_filter(:,:,ii) = mean(HbR_filter(:,:,100:200,ii),3);
end
figure
for jj = 1:3
    for kk = 1:10
        subplot(3,11,kk)
        imagesc(peakMaps_HbO_filter(:,:,kk),[-10 10])
        colorbar
        axis image off
        subplot(3,11,kk+11);
        imagesc(peakMaps_HbR_filter(:,:,kk),[-4 4])
        colorbar
        axis image off
        subplot(3,11,kk+22);
        imagesc(peakMaps_calcium_filter(:,:,kk),[-6 6])
        colorbar
        axis image off
    end
end

colormap jet