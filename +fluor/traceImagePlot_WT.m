function traceImagePlot_WT(oxy,deoxy,total,info,sessionInfo,outputName,texttitle)
%oxy, deoxy, total, gcamp, gcampCorr, green in [nVx,nVy,time] without dark
%frame
%info is a struct, which includes nVx nVy freqout(output frequency)
% outputName is char for naming the file
% this downsampes inputs to info.freqout 
% reshape to [nVx,nVy,time,block]
% then block average the downsampled variables 
% baseline substraction and save the downsampled variables
% time average the image sequence from half way of the activation to the end of
% the activation to create AvgOxy_stim AvgDeOxy_stim AvgTotal_stim AvggcampCorr_stim
% Use AvgTotal_stim and AvggcampCorr_Stim to create different ROIs for total and fluor with 75% maximum and
% save the ROI and the max of AvggcampCorr_stim and AvgTotal_stim
% plot the image sequence


% block average non-downsampled oxy,deoxy, total, gcamp, gcampCorr, green 
%baseline substraction
% plot time trace of the ROI

%save the plots in jpg

import mouse.*


%
% prompt = 'Does the ROI seem to be right? Y/N';



isDownsampled = false;
if exist(strcat(outputName,'_vis.mat'),'file')
    C = who('-file',strcat(outputName,'_vis.mat'));
    for  k=1:length(C)
        if strcmp(C(k),'oxy_blocks_baseline_downsampled')
            isDownsampled = true;
        end
    end
end
if ~isDownsampled
    disp('downsample data')
    
    %downsample
%     tIn = 1:size(oxy,3);tIn = tIn./sessionInfo.framerate;
%     tOut= 1:round(max(tIn));
    
oxy_downsampled = resampledata(oxy,sessionInfo.framerate,info.freqout,10^-5);
deoxy_downsampled = resampledata(deoxy,sessionInfo.framerate,info.freqout,10^-5);

%     deoxy_downsampled = mouse.freq.resampledata(deoxy,tIn,tOut);
    total_downsampled = resampledata(total,sessionInfo.framerate,info.freqout,10^-5);
 %gcampCorr_downsampled = resampledata(permute(gcampCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);

    
    
    
    %reshape
    numBlock = size(oxy,3)/sessionInfo.stimblocksize;     
    oxy_downsampled = reshape(oxy_downsampled,size(oxy,1),size(oxy,2),[],numBlock);
    deoxy_downsampled = reshape(deoxy_downsampled,size(deoxy,1),size(deoxy,2),[],numBlock);
    total_downsampled = reshape(total_downsampled,size(total,1),size(total,2),[],numBlock);
    
    %block average
    oxy_blocks_downsampled = mean(oxy_downsampled,4);
    deoxy_blocks_downsampled = mean(deoxy_downsampled,4);
    total_blocks_downsampled = mean(total_downsampled,4);
 
    % baseline substraction
       MeanFrame_oxy_downsampled=mean(oxy_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    oxy_blocks_baseline_downsampled = oxy_blocks_downsampled-MeanFrame_oxy_downsampled;
    
     MeanFrame_deoxy_downsampled=mean(deoxy_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
     deoxy_blocks_baseline_downsampled = deoxy_blocks_downsampled-MeanFrame_deoxy_downsampled;
    
      MeanFrame_total_downsampled=mean(total_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    total_blocks_baseline_downsampled = total_blocks_downsampled-MeanFrame_total_downsampled;
     %save
    if exist(strcat(outputName,'_vis.mat'),'file')
    save(strcat(outputName,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','-append');
    else
        save(strcat(outputName,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled');

    end

else 
    load(strcat(outputName,'_vis.mat'))
end

% time average the image sequence from half way of the activation to the end of
% the activation to create Average_stim
stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
% stimMidTime = round(stimStartTime + 0.5*sessionInfo.stimduration);
stimEndTime= stimStartTime+sessionInfo.stimduration;
AvgOxy_stim = oxy_blocks_baseline_downsampled(:,:,stimEndTime);
AvgDeOxy_stim = deoxy_blocks_baseline_downsampled(:,:,stimEndTime);
AvgTotal_stim = total_blocks_baseline_downsampled(:,:,stimEndTime);





% stimTimePoints  = round(sessionInfo.stimbaseline/sessionInfo.framerate):(1/sessionInfo.stimFrequency):round(sessionInfo.stimbaseline/sessionInfo.framerate)+sessionInfo.stimduration;
% peakStartTimePoints = stimTimePoints+0.16;
% peakEndTimePoints = stimTimePoints+0.22;
% 
% numPeaks = size(stimTimePoints,2);
% meangcampCorr_peaks = zeros(128,128,numPeaks);
% 
% for jj = 1
%     meangcampCorr_peaks(:,:,jj) = mean(gcampCorr_blocks(:,:,round(peakStartTimePoints(jj)*sessionInfo.framerate):round(peakEndTimePoints(jj)*sessionInfo.framerate)),3);
% end


isROI = false;
% if exist(strcat(outputName,'_vis.mat'),'file')
%     
%     C = who('-file',strcat(outputName,'_vis.mat'));
%     for  k=1:length(C)
%         if strcmp(C(k),'temp_oxy_max')
%             isROI = true;
%         end
%     end
% end

if ~isROI
      
    subplot(2,2,2)
    imagesc(AvgOxy_stim);
    %imagesc(AvgOxy_stim,[-2*temp_oxy_max  2*temp_oxy_max])
    axis image off
    title('2. oxy');
    
    subplot(2,2,3)
    imagesc(AvgDeOxy_stim);
    %     imagesc(AvgDeOxy_stim,[-0.5*temp_oxy_max  0.5*temp_oxy_max])
    axis image off
    title('3. deoxy');
    
    subplot(2,2,4)
    imagesc(AvgTotal_stim)
    %    imagesc(AvgTotal_stim,[-2*temp_oxy_max  2*temp_oxy_max])
    
    axis image off
    title('4. total');
    colorbar
    pause;
    
    
    prompt = {'Enter total limit:'};
    title1 = 'Input';
    dims = [1 35];
    definput = {'3e-6'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_oxy_max = str2double(answer{1});

    
    
    [X,Y] = meshgrid(1:128,1:128);
    
    [x1_total,y1_total] = ginput(1);
    [x2_total,y2_total] = ginput(1);
    
    
    radius_total = sqrt((x1_total-x2_total)^2+(y1_total-y2_total)^2);
    
    
    ROI_oxy = sqrt((X-x1_total).^2+(Y-y1_total).^2)<radius_total;
    
    max_oxy = prctile(AvgOxy_stim(ROI_oxy),99);
    temp = AvgOxy_stim.*ROI_oxy;
    ROI_oxy = temp>0.5*max_oxy;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(ROI_oxy);
    
    ROI_holes = roipoly;
    ROI_smallarea = roipoly;
    
    ROI_oxy(ROI_holes)= 1;
    ROI_oxy(ROI_smallarea) = 0;
    ROI_oxy_contour = bwperim(ROI_oxy); 
    
    
    
    
    figure;
    subplot(2,2,2)
    
    imagesc(AvgOxy_stim,[-2*temp_oxy_max  2*temp_oxy_max])
    hold on
    contour(ROI_oxy_contour,'k')
    axis image off
    title('2. oxy');
    
    subplot(2,2,3)
    imagesc(AvgDeOxy_stim,[-temp_oxy_max temp_oxy_max])
    hold on
    contour(ROI_oxy_contour,'k')
    axis image off
    title('3. deoxy');
    
    subplot(2,2,4)
    imagesc(AvgTotal_stim,[-temp_oxy_max  temp_oxy_max ])
    hold on
    contour(ROI_oxy_contour,'k')
    axis image off
    title('4. total');

    if exist(strcat(outputName,'_vis.mat'),'file')
        
        save(strcat(outputName,'_vis.mat'),'ROI_oxy','temp_oxy_max','-append');
    else
        save(strcat(outputName,'_vis.mat'),'ROI_oxy','temp_oxy_max');
    end
else
    load(strcat(outputName,'_vis.mat'),'ROI_oxy','temp_oxy_max')
    ROI_oxy_contour = bwperim(ROI_oxy);

end


%     gcampCorr_downsampled = resampledata(permute(gcampCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
%     gcampCorr_blocks_downsampled= mean(permute(gcampCorr_downsampled,[1 2 4 3]),4);
%     MeanFrame_gcampCorr_downsampled=mean(gcampCorr_blocks_downsampled(:,:,1:5),3);
%     gcampCorr_blocks_baseline_downsampled = gcampCorr_blocks_downsampled-MeanFrame_gcampCorr_downsampled;
%     save(strcat(output,'_vis.mat'),'gcamp_blocks_baseline_downsampled', 'gcampCorr_blocks_baseline_downsampled','-append')
%%

subplot('position',[0.6,0.25,0.15,0.2])


subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-1.1*temp_oxy_max 1.1*temp_oxy_max])
colorbar
hold on
contour(ROI_oxy_contour,'k')
axis image off
title('oxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgDeOxy_stim,[-0.7*temp_oxy_max 0.7*temp_oxy_max])
colorbar
hold on
contour(ROI_oxy_contour,'k')
axis image off
title('deoxy');

subplot('position',[0.75,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-1.1*temp_oxy_max 1.1*temp_oxy_max])% colorbar
hold on
contour(ROI_oxy_contour,'g')
axis image off
title('total');


figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
disp('image sequence of Hb')
for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.80 0.07 0.12]);
    imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-2*temp_oxy_max 2*temp_oxy_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.80 0.07 0.12]);
    end
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b == 4
        ylabel('Oxy')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end

for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.64 0.07 0.12]);
    imagesc(deoxy_blocks_baseline_downsampled(:,:,b), [-0.8*temp_oxy_max 0.8*temp_oxy_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.64 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==4
        ylabel('DeOxy')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end



for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.48 0.07 0.12]);
    imagesc(total_blocks_baseline_downsampled(:,:,b), [-temp_oxy_max temp_oxy_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.48 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==4
        ylabel('Total')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end

numBlock = size(oxy,3)/sessionInfo.stimblocksize; 
oxy = reshape(oxy,size(oxy,1),size(oxy,2),[],numBlock);
deoxy = reshape(deoxy,size(deoxy,1),size(deoxy,2),[],numBlock);
total = reshape(total,size(total,1),size(total,2),[],numBlock);

disp(strcat('Generate ROI and Block average plot'))
oxy_blocks = mean(oxy(:,:,:,2:end),4);
deoxy_blocks = mean(deoxy(:,:,:,2:end),4);
total_blocks = mean(total(:,:,:,2:end),4);

oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:sessionInfo.stimbaseline),3);

clear oxy_blocks deoxy_blocks  total_blocks


oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);

for i = 1:sessionInfo.stimblocksize
    
    oxy_temp = oxy_blocks_baseline(:,:,i);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(ROI_oxy));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(ROI_oxy));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(ROI_oxy));
    
end

stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
max_oxy = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks

x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
hold on
subplot('position',[0.05,0.08,0.5,0.35])


hold on
p2 = plot(x,oxy_blocks_baseline_active,'r-');
hold on
p3 = plot(x,deoxy_blocks_baseline_active,'b-');
p4 = plot(x,total_blocks_baseline_active,'Color',[.61 .51 .74]);
ylim([-1.3*max_oxy 1.3*max_oxy])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
%sessionInfo.stimFrequency = 1;
hold on
for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1/sessionInfo.stimFrequency
    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[-1.3*max_oxy 1.3*max_oxy]);
    hold on
end

xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
lgd = legend('HbO_2','HbR','HbTotal');
lgd.FontSize = 14;

xlabel('Time(s)','FontSize',12)
ylabel('HBO_2,HbR(\DeltaM)','FontSize',12)



subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-2*temp_oxy_max 2*temp_oxy_max])
colorbar
hold on
contour(ROI_oxy_contour,'k')
axis image off
title('oxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgDeOxy_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
contour(ROI_oxy_contour,'k')
axis image off
title('deoxy');

subplot('position',[0.75,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
contour(ROI_oxy_contour,'g')
axis image off
title('total');
colormap jet
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(outputName,'_OISgcamp.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);



