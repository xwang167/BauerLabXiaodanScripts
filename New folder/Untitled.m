clear all;close all;clc
isTimetrend = false;
if isTimetrend
    suffix = 'Time detrend';
else
    suffix ='';
end 

load(strcat('D:\ProcessedData\181031\181031-GCampM2-stim1-Affine_GSR_NewDetrend',suffix),'AvgOxy', 'AvggcampCorr','info','time')
temp_oxy=mean(AvgOxy(:,:,5+5-2:5+5),3);
imagesc(temp_oxy, [-1e-5 1e-5]);                
axis image off
title('Avg Oxy')
disp('Create mask')
p = drawpolygon('LineWidth',7,'Color','cyan');
bw = poly2mask(p.Position(:,1),p.Position(:,2),128,128);
isActivate=double(bw);
temp_oxy_area = temp_oxy.*isActivate;
temp_oxy_max = min(temp_oxy_area,[],'all');


temp_gcampCorr=mean(AvggcampCorr(:,:,5+5-2:5+5),3);
imagesc(temp_gcampCorr, [-10e-2 10e-2]);                
axis image off
title('Avg GcampCorr')
disp('Create mask')
p_gcampCorr = drawpolygon('LineWidth',7,'Color','cyan');
bw_gcampCorr = poly2mask(p_gcampCorr.Position(:,1),p_gcampCorr.Position(:,2),128,128);
isActivate_gcampCorr=double(bw_gcampCorr);
temp_gcampCorr_area = temp_gcampCorr.*isActivate_gcampCorr;
temp_gcampCorr_max = min(temp_gcampCorr_area,[],'all');


for run = 1:3
%         rawdata = readtiff(strcat('\\10.39.168.176\RawData_East3410\181031\181031-GCampM2-stim',num2str(run),'.tif'));
%         [~, ~, L]=size(rawdata);
 load(strcat('D:\ProcessedData\181031\181031-GCampM2-stim',num2str(run), '-Affine_GSR_NewDetrend',suffix),'oxy','deoxy','gcamp6all')
 frames = length(time);
 oxy_active =  zeros(1,frames);
 deoxy_active = zeros(1,frames);
 gcamp_active = zeros(1,frames);
 gcampCorr_active = zeros(1,frames);
 
 for i = 1:frames
     oxy_1 = squeeze(oxy(:,:,i));
     oxy_active(i) = mean(oxy_1(temp_oxy_area>=temp_oxy_max));
     
     deoxy_1 = squeeze(deoxy(:,:,i));
     deoxy_active(i) = mean(deoxy_1(temp_oxy_area>=temp_oxy_max));     
     
     gcamp = squeeze(gcamp6all(:,:,2,i));
     gcamp_active(i) = mean(gcamp(temp_gcampCorr_area>=0.75*temp_gcampCorr_max));
     
     gcampCorr = squeeze(gcamp6all(:,:,1,i));
     gcampCorr_active(i) = mean(gcampCorr(temp_gcampCorr_area>=0.75*temp_gcampCorr_max));     
 end
 
 
 x = (1:16.8*30)./16.8;
 figure;
 plot(x,gcampCorr_active(1:16.8*30),'g')
 hold on
 plot(x,oxy_active(1:16.8*30).*10^3,'r')
 hold on
 plot(x,deoxy_active(1:16.8*30).*10^3,'b')
 hold on
 plot(x,gcamp_active(1:16.8*30),'k')
 
 
      
end