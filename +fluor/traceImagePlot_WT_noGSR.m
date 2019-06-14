function traceImagePlot_WT_noGSR(oxy,deoxy,total,info,sessionInfo,output,texttitle)
oxy_blocks = mean(oxy(:,:,:,2:end),4);
deoxy_blocks = mean(deoxy(:,:,:,2:end),4);
total_blocks = mean(total(:,:,:,2:end),4);


startFrame = sessionInfo.stimbaseline+round(1*sessionInfo.framerate+0.5*sessionInfo.stimduration*sessionInfo.framerate);
endFrame = sessionInfo.stimbaseline+round(sessionInfo.stimduration*sessionInfo.framerate);

AvgOxy_stim = mean(oxy_blocks(:,:,startFrame:endFrame),3);
AvgDeOxy_stim = mean(deoxy_blocks(:,:,startFrame:endFrame),3);
AvgTotal_stim = mean(total_blocks(:,:,startFrame:endFrame),3);
isROI = false;
if exist(strcat(output,'_vis.mat'),'file')
    
    C = who('-file',strcat(output,'_vis.mat'));
    for  k=1:length(C)
        if strcmp(C(k),'mask_total')
            isROI = true;
        end
    end
end

if ~isROI
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    subplot(1,3,1)
    imagesc(AvgOxy_stim);
    %imagesc(AvgOxy_stim,[-2*temp_oxy_max  2*temp_oxy_max])
    axis image off
    title('oxy');
    
    subplot(1,3,2)
     imagesc(AvgDeOxy_stim);
%     imagesc(AvgDeOxy_stim,[-0.5*temp_oxy_max  0.5*temp_oxy_max])
    axis image off
    title('deoxy');
    
    subplot(1,3,3)
    imagesc(AvgTotal_stim)
%    imagesc(AvgTotal_stim,[-2*temp_oxy_max  2*temp_oxy_max])
    
    axis image off
    title('total');
    pause;
    
    prompt = {'Enter total limit:'};
   title1 = 'Input';
   dims = [1 35];
   definput = {'5e-6'};
   answer = inputdlg(prompt,title1,dims,definput);
     temp_oxy_max = str2double(answer{1});
    
    
    
  [X,Y] = meshgrid(1:128,1:128);
  
    [x1_total,y1_total] = ginput(1);
    [x2_total,y2_total] = ginput(1);
    
    radius_total = sqrt((x1_total-x2_total)^2+(y1_total-y2_total)^2);
    
  
    ROI_total = sqrt((X-x1_total).^2+(Y-y1_total).^2)<radius_total;

    max_total = max(max(AvgTotal_stim(ROI_total)));
    temp = AvgTotal_stim.*ROI_total;
    mask_total = temp>0.75*max_total;
        


    figure;
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
    
    
    figure;imagesc(mask_total);
figure;

subplot(1,3,1)

imagesc(AvgOxy_stim,[-2*temp_oxy_max  2*temp_oxy_max])
hold on
contour(mask_total_contour,'k')
axis image off
title('oxy');

subplot(1,3,2)
imagesc(AvgDeOxy_stim,[-temp_oxy_max temp_oxy_max])
hold on
contour(mask_total_contour,'k')
axis image off
title('deoxy');

subplot(1,3,3)
imagesc(AvgTotal_stim,[-temp_oxy_max  temp_oxy_max ])
hold on
contour(mask_total_contour,'r')
axis image off
title('total');

    
    
    save(strcat(output,'_vis.mat'),'mask_total','temp_oxy_max');
else
    load(strcat(output,'_vis.mat'),'mask_total','temp_oxy_max')
    mask_total_contour = bwperim(mask_total);
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

    save(strcat(output,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled','info','-append');
else
    load(strcat(output,'_vis.mat'),'oxy_blocks_baseline_downsampled','deoxy_blocks_baseline_downsampled','total_blocks_baseline_downsampled')
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
    imagesc(oxy_blocks_baseline_downsampled(:,:,b), [-3*temp_oxy_max 3*temp_oxy_max]);
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
    imagesc(deoxy_blocks_baseline_downsampled(:,:,b), [-1.5*temp_oxy_max 1.5*temp_oxy_max]);
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
    imagesc(total_blocks_baseline_downsampled(:,:,b), [-1.5*temp_oxy_max 1.5*temp_oxy_max]);
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
clear oxy_blocks deoxy_blocks  total_blocks jrgeco1a_blocks jrgeco1aCorr_blocks red_blocks


oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);

for i = 1:sessionInfo.stimblocksize
    
    oxy_temp = oxy_blocks_baseline(:,:,i);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(mask_total));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(mask_total));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(mask_total));
    
 end

stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
max_oxy = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
% min_red = min(red_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks
% min_jrgeco1aCorr = min(jrgeco1aCorr_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks


x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
hold on
subplot('position',[0.05,0.08,0.5,0.35])
p2 = plot(x,oxy_blocks_baseline_active,'r-');
hold on
p3 = plot(x,deoxy_blocks_baseline_active,'b-');
p4 = plot(x,total_blocks_baseline_active,'Color',[.61 .51 .74]);
ylim([-1.3*max_oxy 1.3*max_oxy])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
%sessionInfo.stimFrequency = 1;
hold on
for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-0.01
    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[ -2*max_oxy 2*max_oxy]);
    hold on
end

xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)])
legend([p2 p3 p4 ],'HbO_2','HbR','HbTotal','FontSize',10);
xlabel('Time(s)','FontSize',12)
ylabel('HBO_2,HbR(\DeltaM)','FontSize',12)


subplot('position',[0.6,0.25,0.15,0.2])
imagesc(AvgOxy_stim,[-2*temp_oxy_max 2*temp_oxy_max])
colorbar
hold on
contour(mask_total_contour,'k')
axis image off
title('oxy');

subplot('position',[0.75,0.25,0.15,0.2])
imagesc(AvgDeOxy_stim,[-1*temp_oxy_max 1*temp_oxy_max])
colorbar
hold on
contour(mask_total_contour,'k')
axis image off
title('deoxy');

subplot('position',[0.6,0.03,0.15,0.2])
imagesc(AvgTotal_stim,[-1*temp_oxy_max 1*temp_oxy_max])
colorbar
hold on
contour(mask_total_contour,'r')
axis image off
title('total');

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(output,'_OIS.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);




