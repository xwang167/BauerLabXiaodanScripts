function [oxy_downsampled,deoxy_downsampled,total_downsampled,goodBlocks,AvgOxy_stim, AvgDeOxy_stim, AvgTotal_stim, ROI_oxy,temp_oxy_max,temp_deoxy_max,temp_total_max] = pickGoodBlocks(oxy_GSR,deoxy_GSR,total_GSR,freqOut,sessionInfo)
%downsample the data
%Peak image of every block
%Select blocks
% blockaveraged peak image of the good block
% generate ROI on block averaged peak image

oxy_downsampled = resampledata(oxy_GSR,sessionInfo.framerate,freqOut,10^-5);
deoxy_downsampled = resampledata(deoxy_GSR,sessionInfo.framerate,freqOut,10^-5);
total_downsampled = resampledata(total_GSR,sessionInfo.framerate,freqOut,10^-5);
numBlock = size(oxy_GSR,3)/sessionInfo.stimblocksize;     
oxy_downsampled = reshape(oxy_downsampled,size(oxy_GSR,1),size(oxy_GSR,2),[],numBlock);
deoxy_downsampled = reshape(deoxy_downsampled,size(deoxy_GSR,1),size(deoxy_GSR,2),[],numBlock);
total_downsampled = reshape(total_downsampled,size(total_GSR,1),size(total_GSR,2),[],numBlock);
stimStartTime = round(sessionInfo.stimbaseline/sessionInfo.framerate);
baseline_oxy_downsampled = squeeze(mean(oxy_downsampled(:,:,1:stimStartTime,2),3));
baseline_deoxy_downsampled = squeeze(mean(deoxy_downsampled(:,:,1:stimStartTime,2),3));
baseline_total_downsampled = squeeze(mean(total_downsampled(:,:,1:stimStartTime,2),3));

stimEndTime= stimStartTime+sessionInfo.stimduration;
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
imagesc(squeeze(oxy_downsampled(:,:,stimEndTime,2))-baseline_oxy_downsampled,[-10e-6 10e-6])
colorbar
axis image off
subplot(1,3,2)

imagesc(squeeze(deoxy_downsampled(:,:,stimEndTime,2))-baseline_deoxy_downsampled,[-5e-6 5e-6])
colorbar
axis image off
subplot(1,3,3)
imagesc(squeeze(total_downsampled(:,:,stimEndTime,2))-baseline_total_downsampled,[-5e-6 5e-6])
colorbar
axis image off
colormap jet
pause;
    prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
    title1 = 'Selet scale';
    dims = [1 35];
    definput = {'10e-6';'5e-6';'5e-6'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_oxy_max = str2double(answer{1});
    temp_deoxy_max = str2double(answer{2});
    temp_total_max = str2double(answer{3});
    figure('units','normalized','outerposition',[0 0 1 1]);
for ii = 1:numBlock
    subplot(3,numBlock,ii)
    imagesc(squeeze(oxy_downsampled(:,:,stimEndTime,ii))-baseline_oxy_downsampled,[-temp_oxy_max temp_oxy_max]);
    title(strcat('Pres',num2str(ii)))
    axis image off
    subplot(3,numBlock,numBlock+ii)
    imagesc(squeeze(deoxy_downsampled(:,:,stimEndTime,ii))-baseline_deoxy_downsampled,[-temp_deoxy_max temp_deoxy_max]);
    axis image off
    subplot(3,numBlock,2*numBlock+ii)
    imagesc(squeeze(total_downsampled(:,:,stimEndTime,ii))-baseline_total_downsampled,[-temp_total_max temp_total_max]);
    axis image off
end
pause;
    prompt = {'Enter good blocks:'};
    title1 = 'Pick block';
    dims = [1 35];
    definput = {'[1 2 3 4 5 6 7 8 9 10]'};
    answer = inputdlg(prompt,title1,dims,definput);
    goodBlocks = str2num(answer{1});
    
    
   oxy_goodLocalizedblocks_downsampled = mean(oxy_downsampled(:,:,:,goodBlocks),4);
    deoxy_goodLocalizedblocks_downsampled = mean(deoxy_downsampled(:,:,:,goodBlocks),4);
    total_goodLocalizedblocks_downsampled = mean(total_downsampled(:,:,:,goodBlocks),4);
 
    % baseline substraction
    MeanFrame_oxy_downsampled=mean(oxy_goodLocalizedblocks_downsampled(:,:,1:stimStartTime),3);
    oxy_goodLocalizedblocks_baseline_downsampled = oxy_goodLocalizedblocks_downsampled-MeanFrame_oxy_downsampled;
    
     MeanFrame_deoxy_downsampled=mean(deoxy_goodLocalizedblocks_downsampled(:,:,1:stimStartTime),3);
     deoxy_goodLocalizedblocks_baseline_downsampled = deoxy_goodLocalizedblocks_downsampled-MeanFrame_deoxy_downsampled;
    
    MeanFrame_total_downsampled=mean(total_goodLocalizedblocks_downsampled(:,:,1:stimStartTime),3);
    total_goodLocalizedblocks_baseline_downsampled = total_goodLocalizedblocks_downsampled-MeanFrame_total_downsampled;

    AvgOxy_stim = oxy_goodLocalizedblocks_baseline_downsampled(:,:,stimEndTime);
    AvgDeOxy_stim = deoxy_goodLocalizedblocks_baseline_downsampled(:,:,stimEndTime);
    AvgTotal_stim = total_goodLocalizedblocks_baseline_downsampled(:,:,stimEndTime);
       
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(1,3,1)
    imagesc(AvgOxy_stim,[-temp_oxy_max temp_oxy_max])
    colorbar
    axis image off
    title('2. oxy');
    subplot(1,3,2)

    imagesc(AvgDeOxy_stim,[-temp_deoxy_max temp_deoxy_max])
    colorbar
   axis image off
    title('3. deoxy');
    subplot(1,3,3)
    imagesc(AvgTotal_stim,[-temp_total_max temp_total_max])
    colorbar
    axis image off
    title('4. total');
    
        [X,Y] = meshgrid(1:128,1:128);
    
    [x1_oxy,y1_oxy] = ginput(1);
    [x2_oxy,y2_oxy] = ginput(1);
        
    radius_oxy = sqrt((x1_oxy-x2_oxy)^2+(y1_oxy-y2_oxy)^2);  
    ROI_oxy = sqrt((X-x1_oxy).^2+(Y-y1_oxy).^2)<radius_oxy;   
    max_oxy = prctile(AvgOxy_stim(ROI_oxy),99);
    temp = AvgOxy_stim.*ROI_oxy;
    ROI_oxy = temp>0.75*max_oxy;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(ROI_oxy);
    axis image off;
    ROI_holes = roipoly;
    ROI_smallarea = roipoly;
    
    ROI_oxy(ROI_holes)= 1;
    ROI_oxy(ROI_smallarea) = 0;
    ROI_oxy_contour = bwperim(ROI_oxy); 
    
    figure;
    subplot(1,3,1)
    
    imagesc(AvgOxy_stim,[-2*temp_oxy_max  2*temp_oxy_max])
    hold on
    contour(ROI_oxy_contour,'k')
    axis image off
    title('1. oxy');
    
    subplot(1,3,2)
    imagesc(AvgDeOxy_stim,[-temp_oxy_max temp_oxy_max])
    hold on
    contour(ROI_oxy_contour,'k')
    axis image off
    title('2. deoxy');
    
    subplot(1,3,1)
    imagesc(AvgTotal_stim,[-temp_oxy_max  temp_oxy_max ])
    hold on
    contour(ROI_oxy_contour,'k')
    axis image off
    title('3. total');



    

