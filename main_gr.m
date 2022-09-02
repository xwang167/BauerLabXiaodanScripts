load('L:\RGECO\190627\190627-R5M2286-LandmarksandMask.mat', 'transformMat','isbrain')
 load('190627-R5M2286-LandmarksandMask_Eric.mat', 'I')
raw_blocks = [];
for n = 1:3
    load(['W:\190627\190627-R5M2286-cam1-stim',num2str(n),'.mat'])
    raw_unregistered_cam1 = raw_unregistered;
    clear raw_unregistered
    green = squeeze(raw_unregistered_cam1(:,:,2,:));
    clear raw_unregistered_cam1
    
    load(['W:\190627\190627-R5M2286-cam2-stim',num2str(n),'.mat'])
    raw_unregistered_cam2 = raw_unregistered;
    clear raw_unregistered
    red = squeeze(raw_unregistered_cam2(:,:,2,:));
    clear raw_unregistered_cam2
    
    for ii = 1:7525
        red(:,:,ii) = imwarp(red(:,:,ii), transformMat,'OutputView',imref2d(size(red)));
    end

    darkFrameInd = 2:25;
    gbox = 5;
    gsigma = 1.2;

    %Calculate averaged dark frame
    darFrames_red = mean(red(:,:,darkFrameInd),3);
    darFrames_green = mean(green(:,:,darkFrameInd),3);
    
    %subtract the dark frame
    red_minusdark = red- repmat(darFrames_red,1,1,size(red,3));
    green_minusdark = green-repmat(darFrames_green,1,1,size(red,3));
    clear red green
    %delete the dark frames in the beginning
    red_minusdark(:,:,1:darkFrameInd(end)) = [];
    green_minusdark(:,:,1:darkFrameInd(end)) = [];
    
    %make the first frame the same as second stim
    red_minusdark(:,:,1) = red_minusdark(:,:,2);
    green_minusdark(:,:,1) = green_minusdark(:,:,2);
    
    %combine to one matrix
    raw = nan(size(red_minusdark,1),size(red_minusdark,2),2,size(red_minusdark,3));
    raw(:,:,1,:) = green_minusdark;
    raw(:,:,2,:) = red_minusdark;
    clear green_minusdark red_minusdark
    
    %temporal detrending
    for ii=1: size(raw,3)
        raw(:,:,ii,:)=temporalDetrend(squeeze(raw(:,:,ii,:)),isbrain);
    end
    raw = reshape(raw,128,128,2,750,10);
    raw_blocks = cat(5,raw_blocks,raw);
end
raw_blocks = mean(raw_blocks,5);
save('X:\ToAdam\190627-R5M2286-stim-gr.mat','raw_blocks', 'transformMat','isbrain', 'I','xform_isbrain','ROI_NoGSR')
raw_blocks = reshape(raw_blocks,128*128,2,750);

green_blocks = squeeze(mean(raw_blocks(ROI_NoGSR(:),1,:)));
red_blocks = squeeze(mean(raw_blocks(ROI_NoGSR(:),2,:)));
figure
subplot(2,1,1)
plot((1:750)/25,green_blocks/mean(green_blocks(1:125)),'g')
hold on
plot((1:750)/25,red_blocks/mean(red_blocks(1:125)),'r')
xlabel('Time(s)')
ylabel('OIS S/S_0')
legend('526 nm','638 nm','location','southeast')

LEDFiles = ["X:\ToAdam\+bauerParams\ledSpectra\TwoCam_Mightex525_BP_Pol_500-580.txt", ...
        "X:\ToAdam\+bauerParams\ledSpectra\TwoCam_TL625_Pol_Longer593.txt"];
raw_blocks = reshape(raw_blocks,128,128,2,750);
%OPTICAL PROP AND SPECTROSCOPY
[op, E] = getHbOpticalProperties(LEDFiles);
datahb = procOIS(raw_blocks,op.dpf,E,isbrain);
%Smooth spatially
datahb = smoothImage(datahb,gbox,gsigma);
%transform to atlas space
xform_datahb = affineTransform(datahb,I);

%convert pixel value outside xform_isbrain to nan
xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(xform_datahb,3),size(xform_datahb,4));
xform_datahb(logical(1-xform_isbrain_matrix)) = NaN;
save('X:\ToAdam\190627-R5M2286-stim-processed.mat','xform_datahb','op','E','-v7.3')

HbO = squeeze(xform_datahb(:,:,1,:));
HbR = squeeze(xform_datahb(:,:,2,:));
HbT = HbO+HbR;
% peakMap_ROI = mean(HbT(:,:,125:500),3);
% imagesc(peakMap_ROI,[-1E-6 1E-6])
%    [x1,y1] = ginput(1);
%         
%         [x2,y2] = ginput(1);
%         
%         [X,Y] = meshgrid(1:128,1:128);
%         
%         radius = sqrt((x1-x2)^2+(y1-y2)^2);
%         
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         
%         max_ROI = prctile(peakMap_ROI(ROI),99);
%         
%         temp = peakMap_ROI.*ROI;
%         
%         ROI = temp>0.75*max_ROI;
%         ROI_NoGSR = ROI;

HbO = reshape(HbO,128*128,[]);
HbO_ROI = mean(HbO(ROI_NoGSR(:),:))*10^6;

HbR = reshape(HbR,128*128,[]);
HbR_ROI = mean(HbR(ROI_NoGSR(:),:))*10^6;

HbT = reshape(HbT,128*128,[]);
HbT_ROI = mean(HbT(ROI_NoGSR(:),:))*10^6;

subplot(2,1,2)
plot((1:750)/25,HbO_ROI-mean(HbO_ROI(1:125)),'r')
hold on
plot((1:750)/25,HbR_ROI-mean(HbR_ROI(1:125)),'b')
hold on
plot((1:750)/25,HbT_ROI-mean(HbT_ROI(1:125)),'k')
xlabel('Time(s)')
ylabel('\DeltaC(\muM)')
legend('HbO','HbR','HbT')
