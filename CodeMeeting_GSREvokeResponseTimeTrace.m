load('X:\XW\CodeModification\AnnieOpticalPropertySameOrder\200814\200814-CK5-stim1-dataHb.mat', 'xform_datahb') 
load('V:\ARB-Old\200814\200814-CK5-LandmarksandMask.mat', 'xform_isbrain')
xform_datahb_xw = xform_datahb;
% xform_datahb_xw = highpass(xform_datahb_xw,0.009,29.76);
% xform_datahb_xw = lowpass(xform_datahb_xw,0.5,29.76);
% xform_datahb_xw = resampledata_ori(xform_datahb_xw,29.76,1,10^-5); 
[Oxy_xw, DeOxy_xw]=gsr_ori(xform_datahb_xw,xform_isbrain);

Oxy_xw(:,:,end:end+3)=0;
DeOxy_xw(:,:,end:end+3)=0;


Oxy_xw=reshape(Oxy_xw,128,128,30,[]);
            
for b=1:size(Oxy_xw,4)
    MeanFrame=squeeze(mean(Oxy_xw(:,:,1:5,b),3));
    for t=1:size(Oxy_xw, 3);
        Oxy_xw(:,:,t,b)=squeeze(Oxy_xw(:,:,t,b))-MeanFrame;
    end
end

DeOxy_xw=reshape(DeOxy_xw,128,128,30,[]);
for b=1:size(DeOxy_xw,4)
    MeanFrame=squeeze(mean(DeOxy_xw(:,:,1:5,b),3));
    for t=1:size(DeOxy_xw, 3);
        DeOxy_xw(:,:,t,b)=squeeze(DeOxy_xw(:,:,t,b))-MeanFrame;
    end
end


AvgOxy_xw=mean(Oxy_xw,4);
AvgDeOxy_xw=mean(DeOxy_xw,4);
AvgTotal_xw=mean(Oxy_xw+DeOxy_xw,4);

MeanFrame=squeeze(mean(AvgOxy_xw(:,:,1:5),3));
for t=1:size(AvgOxy_xw, 3);
    AvgOxy_xw(:,:,t)=squeeze(AvgOxy_xw(:,:,t))-MeanFrame;
end

MeanFrame=squeeze(mean(AvgDeOxy_xw(:,:,1:5),3));
for t=1:size(AvgDeOxy_xw, 3);
    AvgDeOxy_xw(:,:,t)=squeeze(AvgDeOxy_xw(:,:,t))-MeanFrame;
end

MeanFrame=squeeze(mean(AvgTotal_xw(:,:,1:5),3));
for t=1:size(AvgTotal_xw, 3);
    AvgTotal_xw(:,:,t)=squeeze(AvgTotal_xw(:,:,t))-MeanFrame;
end





load('V:\ARB-Old\200814\200814-CK5-stim1-datahb.mat', 'xform_datahb')
xform_datahb_Annie = xform_datahb;
[Oxy_Annie, DeOxy_Annie]=gsr_ori(xform_datahb_Annie,xform_isbrain);
Oxy_Annie(:,:,end:end+3)=0;
DeOxy_Annie(:,:,end:end+3)=0;

Oxy_Annie=reshape(Oxy_Annie,128,128,30,[]);
            
for b=1:size(Oxy_Annie,4)
    MeanFrame=squeeze(mean(Oxy_Annie(:,:,1:5,b),3));
    for t=1:size(Oxy_Annie, 3);
        Oxy_Annie(:,:,t,b)=squeeze(Oxy_Annie(:,:,t,b))-MeanFrame;
    end
end

DeOxy_Annie=reshape(DeOxy_Annie,128,128,30,[]);
for b=1:size(DeOxy_Annie,4)
    MeanFrame=squeeze(mean(DeOxy_Annie(:,:,1:5,b),3));
    for t=1:size(DeOxy_Annie, 3);
        DeOxy_Annie(:,:,t,b)=squeeze(DeOxy_Annie(:,:,t,b))-MeanFrame;
    end
end


AvgOxy_Annie=mean(Oxy_Annie,4);
AvgDeOxy_Annie=mean(DeOxy_Annie,4);
AvgTotal_Annie=mean(Oxy_Annie+DeOxy_Annie,4);

MeanFrame=squeeze(mean(AvgOxy_Annie(:,:,1:5),3));
for t=1:size(AvgOxy_Annie, 3);
    AvgOxy_Annie(:,:,t)=squeeze(AvgOxy_Annie(:,:,t))-MeanFrame;
end

MeanFrame=squeeze(mean(AvgDeOxy_Annie(:,:,1:5),3));
for t=1:size(AvgDeOxy_Annie, 3);
    AvgDeOxy_Annie(:,:,t)=squeeze(AvgDeOxy_Annie(:,:,t))-MeanFrame;
end

MeanFrame=squeeze(mean(AvgTotal_Annie(:,:,1:5),3));
for t=1:size(AvgTotal_Annie, 3);
    AvgTotal_Annie(:,:,t)=squeeze(AvgTotal_Annie(:,:,t))-MeanFrame;
end







figure
imagesc(mean(AvgOxy_Annie(:,:,8:10),3))
axis image off
peakMap_ROI = mean(AvgOxy_Annie(:,:,8:10),3);
[X,Y] = meshgrid(1:128,1:128);
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
radius = sqrt((x1-x2)^2+(y1-y2)^2);
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap_ROI(ROI),99);
temp = double(peakMap_ROI).*double(ROI);
ROI = temp>max_ROI*0.5;
hold on
ROI_contour = bwperim(ROI);
[~,c] = contour( ROI_contour,'r');

iROI =  reshape(ROI,1,[]);


Oxy_xw = reshape(Oxy_xw,128*128,30,10);
DeOxy_xw = reshape(DeOxy_xw,128*128,30,10);
timecourse_Oxy_xw = squeeze(mean(Oxy_xw(iROI,:,:),1));
timecourse_DeOxy_xw = squeeze(mean(DeOxy_xw(iROI,:,:),1));
timecourse_Total_xw = timecourse_Oxy_xw + timecourse_DeOxy_xw;

AvgOxy_xw=reshape(AvgOxy_xw,128*128,30);
AvgDeOxy_xw=reshape(AvgDeOxy_xw,128*128,30);
AvgTotal_xw=reshape(AvgTotal_xw,128*128,30);

timecourse_AvgOxy_xw = squeeze(mean(AvgOxy_xw(iROI,:),1));
timecourse_AvgDeOxy_xw = squeeze(mean(AvgDeOxy_xw(iROI,:),1));
timecourse_AvgTotal_xw = squeeze(mean(AvgTotal_xw(iROI,:),1));

Oxy_Annie = reshape(Oxy_Annie,128*128,30,10);
DeOxy_Annie = reshape(DeOxy_Annie,128*128,30,10);
timecourse_Oxy_Annie = squeeze(mean(Oxy_Annie(iROI,:,:),1));
timecourse_DeOxy_Annie = squeeze(mean(DeOxy_Annie(iROI,:,:),1));
timecourse_Total_Annie = timecourse_Oxy_Annie + timecourse_DeOxy_Annie;

AvgOxy_Annie=reshape(AvgOxy_Annie,128*128,30);
AvgDeOxy_Annie=reshape(AvgDeOxy_Annie,128*128,30);
AvgTotal_Annie=reshape(AvgTotal_Annie,128*128,30);

timecourse_AvgOxy_Annie = squeeze(mean(AvgOxy_Annie(iROI,:),1));
timecourse_AvgDeOxy_Annie = squeeze(mean(AvgDeOxy_Annie(iROI,:),1));
timecourse_AvgTotal_Annie = squeeze(mean(AvgTotal_Annie(iROI,:),1));




for ii = 1:10
    subplot(11,2,2*ii-1)
    plot(0:29,timecourse_Oxy_xw(:,ii),'r')
    hold on
    plot(0:29,timecourse_DeOxy_xw(:,ii),'b')
    hold on
    plot(0:29,timecourse_Total_xw(:,ii),'k')
    title(strcat('pres',num2str(ii)))
    
    subplot(11,2,2*ii)
    plot(0:29,timecourse_Oxy_Annie(:,ii),'r')
    hold on
    plot(0:29,timecourse_DeOxy_Annie(:,ii),'b')
    hold on
    plot(0:29,timecourse_Total_Annie(:,ii),'k')
    title(strcat('pres',num2str(ii)))     
end

subplot(11,2,21)
plot(0:29,timecourse_AvgOxy_xw,'r')
hold on
plot(0:29,timecourse_AvgDeOxy_xw,'b')
hold on
plot(0:29,timecourse_AvgTotal_xw,'k')
title('Xiaodan Average')
subplot(11,2,22)
plot(0:29,timecourse_AvgOxy_Annie,'r')
hold on
plot(0:29,timecourse_AvgDeOxy_Annie,'b')
hold on
plot(0:29,timecourse_AvgTotal_Annie,'k')
title('Annie Average')
