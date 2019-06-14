function traceImagePlot_gcamp(oxy,deoxy,total,gcamp,gcampCorr,green,info,sessionInfo,outputName,texttitle,xform_isbrain)
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
    total_downsampled = mouse.freq.resampledata(total,tIn,tOut);
    gcamp_downsampled = mouse.freq.resampledata(gcamp,tIn,tOut);
    gcampCorr_downsampled = mouse.freq.resampledata(gcampCorr,tIn,tOut);
 %gcampCorr_downsampled = resampledata(permute(gcampCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);

    
    
    
    %reshape
    numBlock = size(oxy,3)/sessionInfo.stimblocksize;     
    oxy_downsampled = reshape(oxy_downsampled,size(oxy,1),size(oxy,2),[],numBlock);
    deoxy_downsampled = reshape(deoxy_downsampled,size(deoxy,1),size(deoxy,2),[],numBlock);
    total_downsampled = reshape(total_downsampled,size(total,1),size(total,2),[],numBlock);
    gcamp_downsampled = reshape(gcamp_downsampled,size(gcamp,1),size(gcamp,2),[],numBlock);
    gcampCorr_downsampled = reshape(gcampCorr_downsampled,size(gcampCorr,1),size(gcampCorr,2),[],numBlock);
    
    %block average
    oxy_blocks_downsampled = mean(oxy_downsampled,4);
    deoxy_blocks_downsampled = mean(deoxy_downsampled,4);
    total_blocks_downsampled = mean(total_downsampled,4);
    gcamp_blocks_downsampled = mean(gcamp_downsampled,4);
    gcampCorr_blocks_downsampled = mean(gcampCorr_downsampled,4);

    % baseline substraction
       MeanFrame_oxy_downsampled=mean(oxy_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    oxy_blocks_baseline_downsampled = oxy_blocks_downsampled-MeanFrame_oxy_downsampled;
    
     MeanFrame_deoxy_downsampled=mean(deoxy_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
     deoxy_blocks_baseline_downsampled = deoxy_blocks_downsampled-MeanFrame_deoxy_downsampled;
    
      MeanFrame_total_downsampled=mean(total_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    total_blocks_baseline_downsampled = total_blocks_downsampled-MeanFrame_total_downsampled;
    
    MeanFrame_gcamp_downsampled=mean(gcamp_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    gcamp_blocks_baseline_downsampled = gcamp_blocks_downsampled-MeanFrame_gcamp_downsampled;
    
    MeanFrame_gcampCorr_downsampled=mean(gcampCorr_blocks_downsampled(:,:,1:sessionInfo.stimduration),3);
    gcampCorr_blocks_baseline_downsampled = gcampCorr_blocks_downsampled-MeanFrame_gcampCorr_downsampled;
    %save
    if exist(strcat(outputName,'_vis.mat'),'file')
    save(strcat(outputName,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','gcamp_blocks_baseline_downsampled', 'gcampCorr_blocks_baseline_downsampled','-append');
    else
        save(strcat(outputName,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','gcamp_blocks_baseline_downsampled', 'gcampCorr_blocks_baseline_downsampled');

    end

else 
    load(strcat(outputName,'_vis.mat'))
end

% time average the image sequence from half way of the activation to the end of
% the activation to create Average_stim
stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
stimMidTime = round(stimStartTime + 0.5*sessionInfo.stimduration);
stimEndTime= stimStartTime+sessionInfo.stimduration;
AvgOxy_stim = mean(oxy_blocks_baseline_downsampled(:,:,stimMidTime:stimEndTime),3);
AvgDeOxy_stim = mean(deoxy_blocks_baseline_downsampled(:,:,stimMidTime:stimEndTime),3);
AvgTotal_stim = mean(total_blocks_baseline_downsampled(:,:,stimMidTime:stimEndTime),3);
AvggcampCorr_stim = mean(gcampCorr_blocks_baseline_downsampled(:,:,stimMidTime:stimEndTime),3);




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
if exist(strcat(outputName,'_vis.mat'),'file')
    
    C = who('-file',strcat(outputName,'_vis.mat'));
    for  k=1:length(C)
        if strcmp(C(k),'temp_oxy_max')
            isROI = true;
        end
    end
end

if ~isROI
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(2,2,1)
    imagesc(AvggcampCorr_stim);
    %     imagesc(AvggcampCorr_stim,[-0.4*temp_gcampCorr_max 0.4*temp_gcampCorr_max])
    hold on
    colorbar
    axis image off
    title('1. gcampCorr');
    
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
    
    prompt = {'Enter rgeco1aCorr limit:'};
    title1 = 'Input';
    dims = [1 35];
    definput = {'0.003'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_gcampCorr_max = str2double(answer{1});
    
    
    [X,Y] = meshgrid(1:128,1:128);
    
    [x1_total,y1_total] = ginput(1);
    [x2_total,y2_total] = ginput(1);
    
    [x1_gcampCorr,y1_gcampCorr] = ginput(1);
    [x2_gcampCorr,y2_gcampCorr] = ginput(1);
    
    radius_total = sqrt((x1_total-x2_total)^2+(y1_total-y2_total)^2);
    
    
    ROI_total = sqrt((X-x1_total).^2+(Y-y1_total).^2)<radius_total;
    
    max_total = prctile(AvgTotal_stim(ROI_total),99);
    temp = AvgTotal_stim.*ROI_total;
    ROI_total = temp>0.75*max_total;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(ROI_total);
    
    ROI_holes = roipoly;
    ROI_smallarea = roipoly;
    
    ROI_total(ROI_holes)= 1;
    ROI_total(ROI_smallarea) = 0;
    ROI_total_contour = bwperim(ROI_total); 
    
    
    
    radius_gcampCorr = sqrt((x1_gcampCorr-x2_gcampCorr)^2+(y1_gcampCorr-y2_gcampCorr)^2);
    ROI_gcampCorr = sqrt((X-x1_gcampCorr).^2+(Y-y1_gcampCorr).^2)<radius_gcampCorr;
    
    max_gcampCorr = prctile(AvggcampCorr_stim(ROI_gcampCorr),99);
    temp = AvggcampCorr_stim.*ROI_gcampCorr;
    ROI_gcampCorr = temp>0.75*max_gcampCorr;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(ROI_gcampCorr);
    
    ROI_holes = roipoly;
    ROI_smallarea = roipoly;
    
    ROI_gcampCorr(ROI_holes)= 1;
    ROI_gcampCorr(ROI_smallarea) = 0;
    ROI_gcampCorr_contour = bwperim(ROI_gcampCorr);
    
    
    figure;
    subplot(2,2,1)
    imagesc(AvggcampCorr_stim,[-temp_gcampCorr_max temp_gcampCorr_max])
    hold on
    contour(ROI_gcampCorr_contour,'k')
    axis image off
    title('1. gcampCorr');
    
    subplot(2,2,2)
    
    imagesc(AvgOxy_stim,[-temp_oxy_max  temp_oxy_max])
    hold on
    contour(ROI_total_contour,'k')
    axis image off
    title('2. oxy');
    
    subplot(2,2,3)
    imagesc(AvgDeOxy_stim,[-0.5*temp_oxy_max 0.5*temp_oxy_max])
    hold on
    contour(ROI_total_contour,'k')
    axis image off
    title('3. deoxy');
    
    subplot(2,2,4)
    imagesc(AvgTotal_stim,[-temp_oxy_max  temp_oxy_max ])
    hold on
    contour(ROI_total_contour,'g')
    axis image off
    title('4. total');

    if exist(strcat(outputName,'_vis.mat'),'file')
        
        save(strcat(outputName,'_vis.mat'),'ROI_total','ROI_gcampCorr','temp_oxy_max','temp_gcampCorr_max','-append');
    else
        save(strcat(outputName,'_vis.mat'),'ROI_total','ROI_gcampCorr','temp_oxy_max','temp_gcampCorr_max');
    end
else
    load(strcat(outputName,'_vis.mat'),'ROI_total','ROI_gcampCorr','temp_oxy_max','temp_gcampCorr_max')
    ROI_total_contour = bwperim(ROI_total);
    ROI_gcampCorr_contour = bwperim(ROI_gcampCorr);
end


%     gcampCorr_downsampled = resampledata(permute(gcampCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
%     gcampCorr_blocks_downsampled= mean(permute(gcampCorr_downsampled,[1 2 4 3]),4);
%     MeanFrame_gcampCorr_downsampled=mean(gcampCorr_blocks_downsampled(:,:,1:5),3);
%     gcampCorr_blocks_baseline_downsampled = gcampCorr_blocks_downsampled-MeanFrame_gcampCorr_downsampled;
%     save(strcat(output,'_vis.mat'),'gcamp_blocks_baseline_downsampled', 'gcampCorr_blocks_baseline_downsampled','-append')
%%

subplot('position',[0.6,0.25,0.15,0.2])
imagesc(AvggcampCorr_stim,[-1.1*temp_gcampCorr_max 1.1*temp_gcampCorr_max])
colorbar
hold on
contour(ROI_gcampCorr_contour,'k')
axis image off
title('gcampCorr at peaks');

subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-1.1*temp_oxy_max 1.1*temp_oxy_max])
colorbar
hold on
contour(ROI_gcampCorr_contour,'k')
axis image off
title('oxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgDeOxy_stim,[-0.7*temp_oxy_max 0.7*temp_oxy_max])
colorbar
hold on
contour(ROI_gcampCorr_contour,'k')
axis image off
title('deoxy');

subplot('position',[0.75,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-1.1*temp_oxy_max 1.1*temp_oxy_max])% colorbar
hold on
contour(ROI_gcampCorr_contour,'g')
axis image off
title('total');


figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
disp('image sequence of Hb')
for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.80 0.07 0.12]);
    imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-0.8*temp_oxy_max 0.8*temp_oxy_max]);
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
    imagesc(deoxy_blocks_baseline_downsampled(:,:,b), [-0.4*temp_oxy_max 0.4*temp_oxy_max]);
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
gcamp = reshape(gcamp,size(gcamp,1),size(gcamp,2),[],numBlock);
gcampCorr = reshape(gcampCorr,size(gcampCorr,1),size(gcampCorr,2),[],numBlock);
green = reshape(green,size(green,1),size(green,2),[],numBlock);

disp(strcat('Generate ROI and Block average plot'))
oxy_blocks = mean(oxy(:,:,:,2:end),4);
deoxy_blocks = mean(deoxy(:,:,:,2:end),4);
total_blocks = mean(total(:,:,:,2:end),4);
gcamp_blocks = mean(gcamp(:,:,:,2:end),4);
gcampCorr_blocks = mean(gcampCorr(:,:,:,2:end),4);
green_blocks = mean(green(:,:,:,2:end),4);

oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:sessionInfo.stimbaseline),3);
gcamp_blocks_baseline = gcamp_blocks-mean(gcamp_blocks(:,:,1:sessionInfo.stimbaseline),3);
gcampCorr_blocks_baseline = gcampCorr_blocks-mean(gcampCorr_blocks(:,:,1:sessionInfo.stimbaseline),3);
green_blocks_baseline = green_blocks-mean(green_blocks(:,:,1:sessionInfo.stimbaseline),3);

clear oxy_blocks deoxy_blocks  total_blocks gcamp_blocks gcampCorr_blocks green_blocks


oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
gcamp_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
gcampCorr_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
green_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);

for i = 1:sessionInfo.stimblocksize
    
    oxy_temp = oxy_blocks_baseline(:,:,i);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(ROI_total));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(ROI_total));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(ROI_total));
    
    gcamp_temp = gcamp_blocks_baseline(:,:,i);
    gcamp_blocks_baseline_active(i) = mean(gcamp_temp(ROI_gcampCorr));
    
    gcampCorr_temp = gcampCorr_blocks_baseline(:,:,i);
    gcampCorr_blocks_baseline_active(i) = mean(gcampCorr_temp(ROI_gcampCorr));
    green_temp = green_blocks_baseline(:,:,i);
    green_blocks_baseline_active(i) = mean(green_temp(ROI_gcampCorr));
end

stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
max_oxy = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
max_gcampCorr = max(gcampCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
min_green = min(green_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
min_gcampCorr = min(gcampCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
min_gcampPlot = min(min_green,min_gcampCorr);

x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
hold on
subplot('position',[0.05,0.08,0.5,0.35])
yyaxis left
p1 = plot(x,gcampCorr_blocks_baseline_active,'k-');
ylim([-1.1*max_gcampCorr 1.1*max_gcampCorr])


hold on
yyaxis right
p2 = plot(x,oxy_blocks_baseline_active,'r-');
hold on
p3 = plot(x,deoxy_blocks_baseline_active,'b-');
p4 = plot(x,total_blocks_baseline_active,'Color',[.61 .51 .74]);
ylim([-1.3*max_oxy 1.3*max_oxy])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
%sessionInfo.stimFrequency = 1;
hold on
for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1
    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ -1.1*max_gcampCorr 1.1*max_gcampCorr]);
    hold on
end

xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
lgd = legend('G6f(corr.)','HbO_2','HbR','HbTotal');
lgd.FontSize = 14;

xlabel('Time(s)','FontSize',12)
yyaxis left;
ylabel('gcamp6f(\DeltaF/F)','FontSize',12);
yyaxis right
ylabel('HBO_2,HbR(\DeltaM)','FontSize',12)



subplot('position',[0.6,0.25,0.15,0.2])
imagesc(AvggcampCorr_stim,[-temp_gcampCorr_max temp_gcampCorr_max])
colorbar
hold on
contour(ROI_gcampCorr_contour,'k')
axis image off
title('gcampCorr at peaks');

subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
contour(ROI_total_contour,'k')
axis image off
title('oxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgDeOxy_stim,[-0.5*temp_oxy_max 0.5*temp_oxy_max])
colorbar
hold on
contour(ROI_total_contour,'k')
axis image off
title('deoxy');

subplot('position',[0.75,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
contour(ROI_total_contour,'g')
axis image off
title('total');
colormap jet
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(outputName,'_OISgcamp.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);



figure('units','normalized','outerposition',[0 0 1 1]);
disp('image sequence of gcamp')

for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.80 0.07 0.12]);
    imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-0.8*temp_oxy_max 0.8*temp_oxy_max]);
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
    imagesc(gcamp_blocks_baseline_downsampled(:,:,b), [-1*temp_gcampCorr_max 1*temp_gcampCorr_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.64 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==4
        ylabel('gcamp')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end



for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.48 0.07 0.12]);
    imagesc(gcampCorr_blocks_baseline_downsampled(:,:,b), [-1*temp_gcampCorr_max 1*temp_gcampCorr_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.48 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==4
        ylabel('gcampCorr')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end




hold on
subplot('position',[0.05,0.08,0.4,0.35])
p4 = plot(x,gcampCorr_blocks_baseline_active,'k-');

ylim([1.1*min_gcampPlot 1.1*max_gcampCorr])

hold on
p5=plot(x,gcamp_blocks_baseline_active,'Color',[ 0 0.6 0]);

hold on
p6=plot(x,green_blocks_baseline_active,'g-');
hold on
for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1
    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ 1.1*min_gcampPlot 1.1*max_gcampCorr]);
    hold on
end
ax = gca;
ax.FontSize = 8;
xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
lgd =legend('G6f(corr.)','G6f(raw)','637nm');
lgd.FontSize = 14;
xlabel('Time(s)','FontSize',20,'FontWeight','bold')
ylabel('GCaMP6f(\DeltaF/F)','FontSize',20,'FontWeight','bold')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')

subplot('position',[0.5,0.1,0.2,0.25])
imagesc(AvggcampCorr_stim*100,[-temp_gcampCorr_max*100 temp_gcampCorr_max*100])
colormap jet
hold on
contour(ROI_gcampCorr_contour,'k')
axis image off
c = colorbar;
c.FontSize = 14;
c.FontWeight = 'bold';
title('Corrected GCaMP6f 75%','fontsize',16)
title('Corrected GCaMP6f Percentage Change')

subplot('position',[0.76,0.1,0.17,0.3])
disp('Calculating fft curve')
info.nVy = 128;
info.nVx =128;
ibi=find(xform_isbrain==1);
T1 =  length(oxy);
hz=linspace(0,sessionInfo.framerate,T1);
oxy2 = single(reshape(oxy,info.nVy*info.nVx,[]));
mdata_oxy = squeeze(mean(oxy2(ibi,:),1));
fdata_oxy = abs(fft(mdata_oxy));
fdata_oxy = fdata_oxy./mean(fdata_oxy);
p1 = loglog(hz(1:ceil(T1/2)), fdata_oxy(1:ceil(T1/2)),'g');


gcampCorr2 = single(reshape(gcampCorr,info.nVy*info.nVx,[]));
mdata_gcampCorr = squeeze(mean(gcampCorr2(ibi,:),1));
fdata_gcampCorr = abs(fft(mdata_gcampCorr));
fdata_gcampCorr = fdata_gcampCorr./mean(fdata_gcampCorr);
hold on
p2 = loglog(hz(1:ceil(T1/2)), fdata_gcampCorr(1:ceil(T1/2)),'k');
ylim([10^-2 10^2])
legend('HbO_2','gcampCorr','location','southwest')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
xlim([0.01 15]);
title( 'FFT Normalized Data');
ytickformat('%.1f');

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
% save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info','oxy_mice');
output2 = strcat(outputName,'_gcamp.jpg');
orient portrait
print ('-djpeg', '-r1000',output2);


