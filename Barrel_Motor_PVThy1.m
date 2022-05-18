%%cam1
rawFile ='Z:\220314\220314-N27M753-WhiskerOnly-stim2-cam1' ;
load(rawFile)   %JPC partial load  -- has size size(test,'raw_unregistered')
raw_unregistered = reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),[]);
darkFramesInd = 1:80;
numBlocks = 10;
stimStartTime = 5;
stimEndTime = 10;
samplingRate = 20;
figure
imagesc(raw_unregistered(:,:,darkFramesInd(end)+1));
prompt = "Is this the right frame? (1 or 0)";
x = input(prompt);
if ~logical(x)
   raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
   imagesc(raw_unregistered(:,:,darkFramesInd(end)+1));
end

raw_unregistered(:,:,darkFramesInd) = [];
raw_unregistered=reshape(raw_unregistered,size(raw_unregistered,1),size(raw_unregistered,2),4,[],numBlocks);
raw_avg = mean(raw_unregistered(:,:,1,:,:),5);
clear raw_unregistered
raw_cam1 = squeeze(raw_avg);
clear raw_avg

% ROI

fh = figure('units','normalized','outerposition',[0 0 1 1]);

tmp=(mean(raw_cam1(:,:,stimStartTime*samplingRate+1:stimEndTime*samplingRate),3)-...
    mean(raw_cam1(:,:,1:stimStartTime*samplingRate),3)).^2; %mean from dark frames to end
imagesc(tmp)
caxis(quantile(reshape(tmp,1,[]),[0.001,.999]))
axis image
set(gca,'tag',num2str(1))
sgtitle({'Click Subplot With Best Stim','Click Center for Barrel Cortex'})
% ROI for barrel

StimROIMask_Barrel=findStimROIMask_xw(tmp,size(tmp,1),size(tmp,2));
StimROIMask_Barrel=imgaussfilt(double(StimROIMask_Barrel),4); %smooth with 4 pixel kernel
StimROIMask_Barrel=StimROIMask_Barrel>.5*max(max(StimROIMask_Barrel));
imagesc(StimROIMask_Barrel)
pause(0.5)
stats = regionprops(StimROIMask_Barrel);
[xy_Barrel_cam1] = stats.Centroid;

% ROI for MOTOR
fh = figure('units','normalized','outerposition',[0 0 1 1]);

tmp=(mean(raw_cam1(:,:,stimStartTime*samplingRate+1:stimEndTime*samplingRate),3)-...
    mean(raw_cam1(:,:,1:stimStartTime*samplingRate),3)).^2; %mean from dark frames to end
imagesc(tmp)
caxis(quantile(reshape(tmp,1,[]),[0.001,.999]))
axis image
set(gca,'tag',num2str(1))

sgtitle({'Click Subplot With Best Stim','Click Center for Motor Cortex'})
StimROIMask_Motor=findStimROIMask_xw(tmp,size(tmp,1),size(tmp,2));
StimROIMask_Motor=imgaussfilt(double(StimROIMask_Motor),4); %smooth with 4 pixel kernel
StimROIMask_Motor=StimROIMask_Motor>.5*max(max(StimROIMask_Motor));

imagesc(StimROIMask_Motor)
pause(0.5)

stats = regionprops(StimROIMask_Motor);
[xy_Motor_cam1] = stats.Centroid;



