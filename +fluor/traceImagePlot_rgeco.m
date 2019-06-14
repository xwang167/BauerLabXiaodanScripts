function traceImagePlot_rgeco(oxy,deoxy,total,jrgeco1a,jrgeco1aCorr,red,info,sessionInfo,output,texttitle,xform_isbrain)
oxy_blocks = mean(oxy(:,:,:,2:end),4);
deoxy_blocks = mean(deoxy(:,:,:,2:end),4);
total_blocks = mean(total(:,:,:,2:end),4);
jrgeco1a_blocks = mean(jrgeco1a(:,:,:,2:end),4);
jrgeco1aCorr_blocks = mean(jrgeco1aCorr(:,:,:,2:end),4);
red_blocks = mean(red(:,:,:,2:end),4);


stimTimePoints  = round(sessionInfo.stimbaseline/sessionInfo.framerate):(1/sessionInfo.stimFrequency):round(sessionInfo.stimbaseline/sessionInfo.framerate)+sessionInfo.stimduration;
peakStartTimePoints = stimTimePoints+0.16;
peakEndTimePoints = stimTimePoints+0.22;

numPeaks = size(stimTimePoints,2);
meanjrgeco1aCorr_peaks = zeros(128,128,numPeaks);

for jj = 1
    meanjrgeco1aCorr_peaks(:,:,jj) = mean(jrgeco1aCorr_blocks(:,:,round(peakStartTimePoints(jj)*sessionInfo.framerate):round(peakEndTimePoints(jj)*sessionInfo.framerate)),3);
end


startFrame = sessionInfo.stimbaseline+round(1*sessionInfo.framerate+0.5*sessionInfo.stimduration*sessionInfo.framerate);
endFrame = sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate);
Avgjrgeco1aCorr_stim = mean(meanjrgeco1aCorr_peaks,3);
AvgOxy_stim = mean(oxy_blocks(:,:,startFrame:endFrame),3);
AvgDeOxy_stim = mean(deoxy_blocks(:,:,startFrame:endFrame),3);
AvgTotal_stim = mean(total_blocks(:,:,startFrame:endFrame),3);
isROI = false;
if exist(strcat(output,'_vis.mat'),'file')
    
    C = who('-file',strcat(output,'_vis.mat'));
    for  k=1:length(C)
        if strcmp(C(k),'temp_oxy_max')
            isROI = true;
        end
    end
end

if ~isROI
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(2,2,1)
    imagesc(Avgjrgeco1aCorr_stim);
%     imagesc(Avgjrgeco1aCorr_stim,[-0.4*temp_jrgeco1aCorr_max 0.4*temp_jrgeco1aCorr_max])
    hold on
    axis image off
    title('1. jrgeco1aCorr');
    
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
    pause;
    
    
  prompt = {'Enter total limit:'};
   title1 = 'Input';
   dims = [1 35];
   definput = {'5e-6'};
   answer = inputdlg(prompt,title1,dims,definput);
     temp_oxy_max = str2double(answer{1});
pause;
   prompt = {'Enter rgeco1aCorr limit:'};
   title1 = 'Input';
   dims = [1 35];
   definput = {'0.001'};
   answer = inputdlg(prompt,title1,dims,definput);
     temp_jrgeco1aCorr_max = str2double(answer{1});
     
    
  [X,Y] = meshgrid(1:128,1:128);
  
    [x1_total,y1_total] = ginput(1);
    [x2_total,y2_total] = ginput(1);
    
    [x1_jrgeco1aCorr,y1_jrgeco1aCorr] = ginput(1);
    [x2_jrgeco1aCorr,y2_jrgeco1aCorr] = ginput(1);

    radius_total = sqrt((x1_total-x2_total)^2+(y1_total-y2_total)^2);
    
  
    ROI_total = sqrt((X-x1_total).^2+(Y-y1_total).^2)<radius_total;

    max_total = max(max(AvgTotal_stim(ROI_total)));
    temp = AvgTotal_stim.*ROI_total;
    mask_total = temp>0.75*max_total;
    
       figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(mask_total); 
mask_holes = roipoly;
   

    mask_total(mask_holes)= 1;
    
        prompt = {'Enter smaller area:'};
   title1 = 'Input';
   dims = [1 35];
   definput = {'100'};
   answer = inputdlg(prompt,title1,dims,definput);
    area_pixel = str2double(answer{1});
mask_total = bwareaopen(mask_total,area_pixel);
    mask_total_contour = bwperim(mask_total); 

    
    
    
    
    radius_jrgeco1aCorr = sqrt((x1_jrgeco1aCorr-x2_jrgeco1aCorr)^2+(y1_jrgeco1aCorr-y2_jrgeco1aCorr)^2);
    ROI_jrgeco1aCorr = sqrt((X-x1_jrgeco1aCorr).^2+(Y-y1_jrgeco1aCorr).^2)<radius_jrgeco1aCorr;

    max_jrgeco1aCorr = max(max(Avgjrgeco1aCorr_stim(ROI_jrgeco1aCorr)));
    temp = Avgjrgeco1aCorr_stim.*ROI_jrgeco1aCorr;
    mask_jrgeco1aCorr = temp>0.75*max_jrgeco1aCorr;

           figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(mask_jrgeco1aCorr); 
mask_holes = roipoly;
   

    mask_jrgeco1aCorr(mask_holes)= 1;
    
        prompt = {'Enter smaller area:'};
   title1 = 'Input';
   dims = [1 35];
   definput = {'100'};
   answer = inputdlg(prompt,title1,dims,definput);
    area_pixel = str2double(answer{1});
mask_jrgeco1aCorr = bwareaopen(mask_jrgeco1aCorr,area_pixel);
    mask_jrgeco1aCorr_contour = bwperim(mask_jrgeco1aCorr); 
    
    
figure;
subplot(2,2,1)
imagesc(Avgjrgeco1aCorr_stim,[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max])
hold on
contour(mask_jrgeco1aCorr_contour,'k')
axis image off
title('1. jrgeco1aCorr');

subplot(2,2,2)

imagesc(AvgOxy_stim,[-temp_oxy_max  temp_oxy_max])
hold on
contour(mask_total_contour,'k')
axis image off
title('2. oxy');

subplot(2,2,3)
imagesc(AvgDeOxy_stim,[-0.5*temp_oxy_max 0.5*temp_oxy_max])
hold on
contour(mask_total_contour,'k')
axis image off
title('3. deoxy');

subplot(2,2,4)
imagesc(AvgTotal_stim,[-temp_oxy_max  temp_oxy_max ])
hold on
contour(mask_total_contour,'r')
axis image off
title('4. total');

    if exist(strcat(output,'_vis.mat'),'file')
    
    save(strcat(output,'_vis.mat'),'mask_total','mask_jrgeco1aCorr','temp_oxy_max','temp_jrgeco1aCorr_max','-append');
    else
       save(strcat(output,'_vis.mat'),'mask_total','mask_jrgeco1aCorr','temp_oxy_max','temp_jrgeco1aCorr_max'); 
    end
else
    load(strcat(output,'_vis.mat'),'mask_total','mask_jrgeco1aCorr','temp_oxy_max','temp_jrgeco1aCorr_max')
    mask_total_contour = bwperim(mask_total);
    mask_jrgeco1aCorr_contour = bwperim(mask_jrgeco1aCorr);
end






%
% prompt = 'Does the ROI seem to be right? Y/N';



isDownsampled = false;
C = who('-file',strcat(output,'_vis.mat'));
for  k=1:length(C)
    if strcmp(C(k),'oxy_blocks_baseline_downsampled')
        isDownsampled = true;
    end
end

if ~isDownsampled
    disp('downsample data')
    oxy_downsampled = resampledata(permute(oxy,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
    oxy_blocks_downsampled= mean(permute(oxy_downsampled,[1 2 4 3]),4);
    MeanFrame_oxy_downsampled=mean(oxy_blocks_downsampled(:,:,1:5),3);
    oxy_blocks_baseline_downsampled = oxy_blocks_downsampled-MeanFrame_oxy_downsampled;
    
    deoxy_downsampled = resampledata(permute(deoxy,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
    deoxy_blocks_downsampled= mean(permute(deoxy_downsampled,[1 2 4 3]),4);
    MeanFrame_deoxy_downsampled=mean(deoxy_blocks_downsampled(:,:,1:5),3);
    deoxy_blocks_baseline_downsampled = deoxy_blocks_downsampled-MeanFrame_deoxy_downsampled;
    
    total_downsampled = resampledata(permute(total,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
    total_blocks_downsampled= mean(permute(total_downsampled,[1 2 4 3]),4);
    MeanFrame_total_downsampled=mean(total_blocks_downsampled(:,:,1:5),3);
    total_blocks_baseline_downsampled = total_blocks_downsampled-MeanFrame_total_downsampled;
    jrgeco1a_downsampled = resampledata(permute(jrgeco1a,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
    jrgeco1a_blocks_downsampled= mean(permute(jrgeco1a_downsampled,[1 2 4 3]),4);
    MeanFrame_jrgeco1a_downsampled=mean(jrgeco1a_blocks_downsampled(:,:,1:5),3);
    jrgeco1a_blocks_baseline_downsampled = jrgeco1a_blocks_downsampled-MeanFrame_jrgeco1a_downsampled;
    jrgeco1aCorr_downsampled = resampledata(permute(jrgeco1aCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
    jrgeco1aCorr_blocks_downsampled= mean(permute(jrgeco1aCorr_downsampled,[1 2 4 3]),4);
    MeanFrame_jrgeco1aCorr_downsampled=mean(jrgeco1aCorr_blocks_downsampled(:,:,1:5),3);
    jrgeco1aCorr_blocks_baseline_downsampled = jrgeco1aCorr_blocks_downsampled-MeanFrame_jrgeco1aCorr_downsampled;
    save(strcat(output,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info','jrgeco1a_blocks_baseline_downsampled', 'jrgeco1aCorr_blocks_baseline_downsampled','-append');
else
    C = who('-file',strcat(output,'_vis.mat'));
    isFluorGot = false;
    for  k=1:length(C)
        if strcmp(C(k),'jrgeco1aCorr_blocks_baseline_downsampled')
            isFluorGot = true;
        end
    end
    if isFluorGot
        disp('load resample')
        load(strcat(output,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','jrgeco1a_blocks_baseline_downsampled', 'jrgeco1aCorr_blocks_baseline_downsampled')
    else
        load(strcat(output,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled')
        jrgeco1a_downsampled = resampledata(permute(jrgeco1a,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
        jrgeco1a_blocks_downsampled= mean(permute(jrgeco1a_downsampled,[1 2 4 3]),4);
        MeanFrame_jrgeco1a_downsampled=mean(jrgeco1a_blocks_downsampled(:,:,1:5),3);
        jrgeco1a_blocks_baseline_downsampled = jrgeco1a_blocks_downsampled-MeanFrame_jrgeco1a_downsampled;
        jrgeco1aCorr_downsampled = resampledata(permute(jrgeco1aCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
        jrgeco1aCorr_blocks_downsampled= mean(permute(jrgeco1aCorr_downsampled,[1 2 4 3]),4);
        MeanFrame_jrgeco1aCorr_downsampled=mean(jrgeco1aCorr_blocks_downsampled(:,:,1:5),3);
        jrgeco1aCorr_blocks_baseline_downsampled = jrgeco1aCorr_blocks_downsampled-MeanFrame_jrgeco1aCorr_downsampled;
        save(strcat(output,'_vis.mat'),'jrgeco1a_blocks_baseline_downsampled', 'jrgeco1aCorr_blocks_baseline_downsampled','-append');
    end
    
end




%     jrgeco1aCorr_downsampled = resampledata(permute(jrgeco1aCorr,[1 2 4 3]),sessionInfo.framerate,info.freqout,10^-5);
%     jrgeco1aCorr_blocks_downsampled= mean(permute(jrgeco1aCorr_downsampled,[1 2 4 3]),4);
%     MeanFrame_jrgeco1aCorr_downsampled=mean(jrgeco1aCorr_blocks_downsampled(:,:,1:5),3);
%     jrgeco1aCorr_blocks_baseline_downsampled = jrgeco1aCorr_blocks_downsampled-MeanFrame_jrgeco1aCorr_downsampled;
%     save(strcat(output,'_vis.mat'),'jrgeco1a_blocks_baseline_downsampled', 'jrgeco1aCorr_blocks_baseline_downsampled','-append')
%%
%
% subplot('position',[0.6,0.25,0.15,0.2])
% imagesc(Avgjrgeco1aCorr_stim,[-1.1*temp_jrgeco1aCorr_max 1.1*temp_jrgeco1aCorr_max])
% colorbar
% hold on
% contour(mask_jrgeco1aCorr_contour,'k')
% axis image off
% title('jrgeco1aCorr at peaks');
%
% subplot('position',[0.75,0.25,0.15,0.2])
% imagesc(AvgOxy_stim,[-1.1*temp_oxy_max 1.1*temp_oxy_max])
% colorbar
% hold on
% contour(mask_jrgeco1aCorr_contour,'k')
% axis image off
% title('oxy');
%
% subplot('position',[0.6,0.03,0.15,0.2])
% imagesc(AvgDeOxy_stim,[-0.7*temp_oxy_max 0.7*temp_oxy_max])
% colorbar
% hold on
% contour(mask_jrgeco1aCorr_contour,'k')
% axis image off
% title('deoxy');
%
% subplot('position',[0.75,0.03,0.15,0.2])
% imagesc(AvgTotal_stim,[-1.1*temp_total_max 1.1*temp_total_max])% colorbar
% hold on
% contour(mask_jrgeco1aCorr_contour,'r')
% axis image off
% title('total');
%

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



disp(strcat('Generate ROI and Block average plot'))
oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:sessionInfo.stimbaseline),3);
jrgeco1a_blocks_baseline = jrgeco1a_blocks-mean(jrgeco1a_blocks(:,:,1:sessionInfo.stimbaseline),3);
jrgeco1aCorr_blocks_baseline = jrgeco1aCorr_blocks-mean(jrgeco1aCorr_blocks(:,:,1:sessionInfo.stimbaseline),3);
red_blocks_baseline = red_blocks-mean(red_blocks(:,:,1:sessionInfo.stimbaseline),3);

clear oxy_blocks deoxy_blocks  total_blocks jrgeco1a_blocks jrgeco1aCorr_blocks red_blocks


oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
jrgeco1a_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
jrgeco1aCorr_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
red_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);

for i = 1:sessionInfo.stimblocksize
    
    oxy_temp = oxy_blocks_baseline(:,:,i);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(mask_total));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(mask_total));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(mask_total));
    
    jrgeco1a_temp = jrgeco1a_blocks_baseline(:,:,i);
    jrgeco1a_blocks_baseline_active(i) = mean(jrgeco1a_temp(mask_jrgeco1aCorr));
    
    jrgeco1aCorr_temp = jrgeco1aCorr_blocks_baseline(:,:,i);
    jrgeco1aCorr_blocks_baseline_active(i) = mean(jrgeco1aCorr_temp(mask_jrgeco1aCorr));
    red_temp = red_blocks_baseline(:,:,i);
    red_blocks_baseline_active(i) = mean(red_temp(mask_jrgeco1aCorr));
end

stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
max_oxy = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
max_jrgeco1aCorr = max(jrgeco1aCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
% min_red = min(red_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
% min_jrgeco1aCorr = min(jrgeco1aCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks


x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
hold on
subplot('position',[0.05,0.08,0.5,0.35])
yyaxis left
p1 = plot(x,jrgeco1aCorr_blocks_baseline_active,'k-');
ylim([-1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr])


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
    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ -1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr]);
    hold on
end

xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
lgd = legend('R1a(corr.)','HbO_2','HbR','HbTotal');
lgd.FontSize = 14;

xlabel('Time(s)','FontSize',12,'FontWeight','bold')
yyaxis left;
ylabel('jrgeco1a6f(\DeltaF/F)','FontSize',12,'FontWeight','bold');
yyaxis right
ylabel('HBO_2,HbR(\DeltaM)','FontSize',12,'FontWeight','bold')



subplot('position',[0.6,0.25,0.15,0.2])
imagesc(Avgjrgeco1aCorr_stim,[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max])
colorbar
hold on
contour(mask_jrgeco1aCorr_contour,'k')
axis image off
title('jrgeco1aCorr at peaks');

subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
contour(mask_total_contour,'k')
axis image off
title('oxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgDeOxy_stim,[-0.5*temp_oxy_max 0.5*temp_oxy_max])
colorbar
hold on
contour(mask_total_contour,'k')
axis image off
title('deoxy');

subplot('position',[0.75,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-temp_oxy_max temp_oxy_max])
colorbar
hold on
contour(mask_total_contour,'r')
axis image off
title('total');
colormap jet
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(output,'_OISjrgeco1a.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);



figure('units','normalized','outerposition',[0 0 1 1]);
disp('image sequence of rgeco')

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
    imagesc(jrgeco1a_blocks_baseline_downsampled(:,:,b), [-2*temp_jrgeco1aCorr_max 2*temp_jrgeco1aCorr_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.64 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==4
        ylabel('jrgeco1a')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end



for b=4:13
    p = subplot('position', [0.015+(b-4)*0.09 0.48 0.07 0.12]);
    imagesc(jrgeco1aCorr_blocks_baseline_downsampled(:,:,b), [-2*temp_jrgeco1aCorr_max 2*temp_jrgeco1aCorr_max]);
    if b == 13
        colorbar
        set(p,'Position',[0.015+(b-4)*0.09 0.48 0.07 0.12]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==4
        ylabel('jrgeco1aCorr')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
end




hold on
subplot('position',[0.05,0.08,0.4,0.35])
p4 = plot(x,jrgeco1aCorr_blocks_baseline_active,'k-');

ylim([-1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr])

hold on
p5=plot(x,jrgeco1a_blocks_baseline_active,'Color',[0.6 0 0]);

hold on
p6=plot(x,red_blocks_baseline_active,'r-');
hold on
for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1
    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ -1.1*max_jrgeco1aCorr 1.1*max_jrgeco1aCorr]);
    hold on
end
ax = gca;
ax.FontSize = 8;
xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
lgd =legend('R1a(corr.)','R1a(raw)','637nm');
lgd.FontSize = 14;
xlabel('Time(s)','FontSize',20,'FontWeight','bold')
ylabel('jRGECO1a(\DeltaF/F)','FontSize',20,'FontWeight','bold')

set(findall(gca, 'Type', 'Line'),'LineWidth',2);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')


subplot('position',[0.5,0.1,0.2,0.25])
imagesc(Avgjrgeco1aCorr_stim*100,[-temp_jrgeco1aCorr_max*100 temp_jrgeco1aCorr_max*100])
colormap jet
hold on
contour(mask_jrgeco1aCorr_contour,'k')
axis image off
title('Corrected jRGECO1a','fontsize',16)
c = colorbar;
c.FontSize = 12;
c.FontWeight = 'bold';
title('Corrected jRGECO1a Percentage Change')

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
p1 = loglog(hz(1:ceil(T1/2)), fdata_oxy(1:ceil(T1/2)),'r');


jrgeco1aCorr2 = single(reshape(jrgeco1aCorr,info.nVy*info.nVx,[]));
mdata_jrgeco1aCorr = squeeze(mean(jrgeco1aCorr2(ibi,:),1));
fdata_jrgeco1aCorr = abs(fft(mdata_jrgeco1aCorr));
fdata_jrgeco1aCorr = fdata_jrgeco1aCorr./mean(fdata_jrgeco1aCorr);
hold on
p2 = loglog(hz(1:ceil(T1/2)), fdata_jrgeco1aCorr(1:ceil(T1/2)),'k');
ylim([10^-1 10^2])
legend('HbO_2','jrgeco1aCorr','location','southwest')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
xlim([0.01 15]);
title( 'FFT Normalized Data');
ytickformat('%.1f');


annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
% save(strcat('J:\ProcessedData_2\Zyla\',recDate,'\',recDate,'-',mouseName,'-stim_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','oxy','deoxy','total','info','oxy_mice');
output2 = strcat(output,'_jrgeco1a.jpg');
orient portrait
print ('-djpeg', '-r1000',output2);


