load('220702-N26M761-WhiskerOnly-stim1-dataFluor.mat', 'xform_datafluorCorr')
load('220702-N26M761-WhiskerOnly-stim1-dataHb.mat', 'xform_datahb','runInfo')
load('220702-N26M761-WhiskerOnly-LandmarksAndMask.mat', 'xform_isbrain')
xform_isbrain = logical(xform_isbrain);

calcium = reshape(xform_datafluorCorr*100,128,128,600,10);
HbO = reshape(xform_datahb(:,:,1,:)*10^6,128,128,600,10);
HbR = reshape(xform_datahb(:,:,2,:)*10^6,128,128,600,10);
HbT = HbO + HbR;

%% peak map
calcium_avg = mean(calcium,4);
peakMap_avg = mean(calcium_avg(:,:,100:200),3);
load('D:\OIS_Process\atlas.mat')
ROI_barrel = AtlasSeeds == 9;


figure
imagesc(peakMap_avg)
axis image off
[x,y] = ginput(1);
nX = size(peakMap_avg,2);
nY = size(peakMap_avg,1);



[X,Y] = meshgrid(1:nX,1:nY); % coordinates for the whole matrix
radius = .1*nX; %calculate radius that is 2mm
ROI = sqrt((X-x).^2+(Y-y).^2)<radius;%all the region inside of the cercle that defined by user input
max_ROI = prctile(peakMap_avg(ROI),99); % find 99% value just in case maximum value is from bubbles and stuff that make a super bright pixel
temp = peakMap_avg.*ROI;
ROI = temp>0.75*max_ROI;

% ROI=imgaussfilt(double(ROI),4); %smooth with 4 pixel kernel
% ROI=ROI>.5*max(max(ROI));
% figure(2)
% imagesc(ROI)




peakMaps_calcium = nan(128,128,10);
peakMaps_HbO = nan(128,128,10);
peakMaps_HbR= nan(128,128,10);
for ii = 1:10
    peakMaps_calcium(:,:,ii) = mean(calcium(:,:,100:200,ii),3);
    peakMaps_HbO(:,:,ii) = mean(HbO(:,:,100:200,ii),3);
    peakMaps_HbR(:,:,ii) = mean(HbR(:,:,100:200,ii),3);
end
% figure
% for jj = 1:3
%     for kk = 1:10
%         subplot(3,11,kk)
%         imagesc(peakMaps_HbO(:,:,kk),[-10 10])
%         colorbar
%         axis image off
%         subplot(3,11,kk+11);
%         imagesc(peakMaps_HbR(:,:,kk),[-5 5])
%         colorbar
%         axis image off
%         subplot(3,11,kk+22);
%         imagesc(peakMaps_calcium(:,:,kk),[-6 6])
%         colorbar
%         axis image off
%     end
% end
% 
% colormap jet
% sgtitle('No Filter')


calcium = reshape(calcium,128,128,[]);
HbO = reshape(xform_datahb(:,:,1,:)*10^6,128,128,[]);
HbR = reshape(xform_datahb(:,:,2,:)*10^6,128,128,[]);

calcium_filter = filterData(calcium,0.01,5,runInfo.samplingRate); 
HbO_filter = filterData(HbO,0.01,5,runInfo.samplingRate); 
HbR_filter = filterData(HbR,0.01,5,runInfo.samplingRate);

calcium_filter = reshape(calcium_filter,128,128,600,10);
HbO_filter = reshape(HbO_filter,128,128,600,10);
HbR_filter = reshape(HbR_filter,128,128,600,10);


peakMaps_calcium_filter = nan(128,128,10);
peakMaps_HbO_filter = nan(128,128,10);
peakMaps_HbR_filter= nan(128,128,10);
for ii = 1:10
    peakMaps_calcium_filter(:,:,ii) = mean(calcium_filter(:,:,100:200,ii),3);
    peakMaps_HbO_filter(:,:,ii) = mean(HbO_filter(:,:,100:200,ii),3);
    peakMaps_HbR_filter(:,:,ii) = mean(HbR_filter(:,:,100:200,ii),3);
end
% figure
% for jj = 1:3
%     for kk = 1:10
%         subplot(3,11,kk)
%         imagesc(peakMaps_HbO_filter(:,:,kk),[-10 10])
%         colorbar
%         axis image off
%         subplot(3,11,kk+11);
%         imagesc(peakMaps_HbR_filter(:,:,kk),[-5 5])
%         colorbar
%         axis image off
%         subplot(3,11,kk+22);
%         imagesc(peakMaps_calcium_filter(:,:,kk),[-6 6])
%         colorbar
%         axis image off
%     end
% end
% 
% colormap jet



    peakMaps_calcium_diff = (peakMaps_calcium_filter-peakMaps_calcium)./peakMaps_calcium_filter*100;
    peakMaps_HbO_diff = (peakMaps_HbO_filter-peakMaps_HbO)./peakMaps_HbO_filter*100;
    peakMaps_HbR_diff = (peakMaps_HbR_filter-peakMaps_HbR)./peakMaps_HbR_filter*100;
figure
for jj = 1:3
    for kk = 1:10
        subplot(9,10,kk)
        imagesc(peakMaps_HbO(:,:,kk),[-10 10])
        colorbar
        axis image off
        subplot(9,10,kk+10);
        imagesc(peakMaps_HbR(:,:,kk),[-6 6])
        colorbar
        axis image off
        subplot(9,10,kk+20);
        imagesc(peakMaps_calcium(:,:,kk),[-6 6])
        colorbar
        axis image off
        
        
        subplot(9,10,kk+30)
        imagesc(peakMaps_HbO_filter(:,:,kk),[-10 10])
        colorbar
        axis image off
        subplot(9,10,kk+40);
        imagesc(peakMaps_HbR_filter(:,:,kk),[-6 6])
        colorbar
        axis image off
        subplot(9,10,kk+50);
        imagesc(peakMaps_calcium_filter(:,:,kk),[-6 6])
        colorbar
        axis image off

        subplot(9,10,kk+60)
        imagesc(peakMaps_HbO_diff(:,:,kk),[-25 25])
       diff = peakMaps_HbO_diff(:,:,kk);
       diff_median = median(diff(xform_isbrain),'all');
       title([num2str(diff_median),'%'])
        colorbar
        axis image off
        subplot(9,10,kk+70);
        imagesc(peakMaps_HbR_diff(:,:,kk),[-25 25])
        diff = peakMaps_HbR_diff(:,:,kk);
       diff_median = median(diff(xform_isbrain),'all');
       title([num2str(diff_median),'%'])
        colorbar
        axis image off
        subplot(9,10,kk+80);
        imagesc(peakMaps_calcium_diff(:,:,kk),[-25 25])
        diff = peakMaps_calcium_diff(:,:,kk);
       diff_median = median(diff(xform_isbrain),'all');
       title([num2str(diff_median),'%'])
        colorbar
        axis image off
    end
end
colormap jet

HbR = reshape(HbR,128,128,600,10);
HbR_filter = reshape(HbR_filter,128,128,600,10);
for ii = 100:200
    subplot(121)    
    imagesc(HbR(:,:,ii,10),[-6 6])
    axis image off
    title(['No filter: t = ',num2str(ii/20),'s'])
    subplot(122)
    
    imagesc(HbR_filter(:,:,ii,10),[-6 6]);
    axis image off
    title(['Filter: t = ',num2str(ii/20),'s'])
    pause(0.1)
end

%% dynamic
calcium = reshape(calcium,128*128,[]);
HbO = reshape(HbO,128*128,[]);
HbR = reshape(HbR,128*128,[]);

calcium_filter = reshape(calcium_filter,128*128,[]);
HbO_filter = reshape(HbO_filter,128*128,[]);
HbR_filter = reshape(HbR_filter,128*128,[]);

calcium_ROI = mean(calcium(ROI(:),:));
HbO_ROI = mean(HbO(ROI(:),:));
HbR_ROI = mean(HbR(ROI(:),:));

calcium_filter_ROI = mean(calcium_filter(ROI(:),:));
HbO_filter_ROI = mean(HbO_filter(ROI(:),:));
HbR_filter_ROI = mean(HbR_filter(ROI(:),:));

figure
plot((1:6000)/20,calcium_ROI,'r')
hold on
plot((1:6000)/20,calcium_filter_ROI,'b')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('calcium')
legend('No filter','Filter')

figure
plot((1:6000)/20,calcium_filter_ROI-calcium_ROI,'k')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('filter-no filter')

[Pxx_calcium,hz] = pwelch(calcium_ROI,[],[],[],20);
[Pxx_calcium_filter,hz] = pwelch(calcium_filter_ROI,[],[],[],20);
[Pxx_calcium_diff,hz] = pwelch(calcium_filter_ROI-calcium_ROI,[],[],[],20);

figure
loglog(hz,Pxx_calcium)
grid on
hold on
loglog(hz,Pxx_calcium_filter)
legend('No filter','Filter','location','southwest')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F%)^2/Hz')

figure
loglog(hz,Pxx_calcium_filter./Pxx_calcium)
xlabel('Frequency(Hz)')
title('filter/nofilter')

figure
loglog(hz,Pxx_calcium_diff)
xlabel('Frequency(Hz)')
title('Filter-NoFilter')


figure
plot((1:6000)/20,HbO_ROI,'r')
hold on
plot((1:6000)/20,HbO_filter_ROI,'b')
xlabel('Time(s)')
ylabel('\Delta\muM')
title('HbO')
legend('No filter','Filter')

figure
plot((1:6000)/20,HbO_filter_ROI-HbO_ROI,'k')
xlabel('Time(s)')
ylabel('\Delta\muM')
title('filter-no filter')

[Pxx_HbO,hz] = pwelch(HbO_ROI,[],[],[],20);
[Pxx_HbO_filter,hz] = pwelch(HbO_filter_ROI,[],[],[],20);

figure
loglog(hz,Pxx_HbO)
grid on
hold on
loglog(hz,Pxx_HbO_filter)
legend('No filter','Filter','location','southwest')
xlabel('Frequency(Hz)')
ylabel('(\Delta\muM)^2/Hz')

figure
loglog(hz,Pxx_HbO_filter./Pxx_HbO)
xlabel('Frequency(Hz)')
title('filter/nofilter')

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

