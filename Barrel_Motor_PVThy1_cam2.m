%%cam1
rawFile ='Z:\220314\220314-N27M753-WhiskerOnly-stim2-cam2' ;
load(rawFile)   %JPC partial load  -- has size size(test,'raw_unregistered')
raw_unregistered = reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),[]);
darkFramesInd = 1:80;
numBlocks = 10;
stimStartTime = 5;
stimEndTime = 10;
samplingRate = 20;
figure
imagesc(raw_unregistered(:,:,darkFramesInd(end)+2));
prompt = "Is this the right frame? (1 or 0)";
x = input(prompt);
if ~logical(x)
   raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
   imagesc(raw_unregistered(:,:,darkFramesInd(end)+1));
end

raw_unregistered(:,:,darkFramesInd) = [];
raw_unregistered=reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),4,[],numBlocks);
raw_avg_red = mean(raw_unregistered(:,:,2,:,:),5);
raw_avg_calcium = mean(raw_unregistered(:,:,3,:,:),5);
clear raw_unregistered
raw_cam1_red = squeeze(raw_avg_red);
raw_cam1_calcium = squeeze(raw_avg_calcium);
clear raw_avg_red raw_avg_calcium

% ROI
tmp_red=(mean(raw_cam1_red(:,:,stimStartTime*samplingRate+1:stimEndTime*samplingRate),3)-...
    mean(raw_cam1_red(:,:,1:stimStartTime*samplingRate),3)).^2; %mean from dark frames to end

tmp_calcium=(mean(raw_cam1_calcium(:,:,stimStartTime*samplingRate+1:stimEndTime*samplingRate),3)-...
    mean(raw_cam1_calcium(:,:,1:stimStartTime*samplingRate),3)).^2;
%%
fh = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1)
imagesc(tmp_red)
caxis(quantile(reshape(tmp_red,1,[]),[0.001,.999]))
axis image
set(gca,'tag',num2str(1))

subplot(2,1,2)
imagesc(tmp_calcium)
caxis(quantile(reshape(tmp_calcium,1,[]),[0.001,.999]))
axis image
set(gca,'tag',num2str(2))


% ROI for barrel
sgtitle({'Click Subplot With Best Stim','Click Center for Barrel Cortex'})
tmp = zeros(128,128,2);
tmp(:,:,1) = tmp_red;
tmp(:,:,2) = tmp_calcium;
StimROIMask_Barrel=findStimROIMask_xw(tmp,size(tmp,1),size(tmp,2));
StimROIMask_Barrel=imgaussfilt(double(StimROIMask_Barrel),4); %smooth with 4 pixel kernel
StimROIMask_Barrel=StimROIMask_Barrel>.5*max(max(StimROIMask_Barrel));
imagesc(StimROIMask_Barrel)
pause(0.5)
stats = regionprops(StimROIMask_Barrel);
[xy_Barrel_cam2] = stats.Centroid;

% ROI for MOTOR
fh = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1)
imagesc(tmp_red)
caxis(quantile(reshape(tmp_red,1,[]),[0.001,.999]))
axis image
set(gca,'tag',num2str(1))

subplot(2,1,2)
imagesc(tmp_calcium)
caxis(quantile(reshape(tmp_calcium,1,[]),[0.001,.999]))
axis image
set(gca,'tag',num2str(2))
sgtitle({'Click Subplot With Best Stim','Click Center for Motor Cortex'})
StimROIMask_Motor=findStimROIMask_xw(tmp,size(tmp,1),size(tmp,2));
StimROIMask_Motor=imgaussfilt(double(StimROIMask_Motor),4); %smooth with 4 pixel kernel
StimROIMask_Motor=StimROIMask_Motor>.5*max(max(StimROIMask_Motor));
close
imagesc(StimROIMask_Motor)
pause(0.5)
close
stats = regionprops(StimROIMask_Motor);
[xy_Motor_cam2] = stats.Centroid;




