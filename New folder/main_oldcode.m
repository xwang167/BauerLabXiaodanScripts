
system = 'EastOIS1_Fluor';
sessionInfo.framerate = 23.529;
sessionInfo.stimblocksize = 707;
sessionInfo.stimduration = 5;

info.framerate=23.5294;
info.freqout=1;
%info.lowpass=0.5;
%info.highpass=0.009;
info.stimblocksize=60;
info.stimbaseline=5;
info.stimduration=10;
% %load('J:\ProcessedData_3\GCaMP\181217\181217-G3M1-stim1-NoGSR-Detrend.mat','raw');
% [datahb, WL, op, E, info] = procOIS_XW(raw, info, system);
% load('J:\ProcessedData_3\GCaMP\181217\181217-G3M1-mask.mat')
% 
% [nVy, nVx, hem, T]=size(datahb);
% for h=1:hem;
%     for m=1:T;
%         xform_datahb_old(:,:,h,m)=Affine(I, datahb(:,:,h,m));
%     end
% end
% 
 xform_datahb_old=real(xform_datahb_old);
% load('J:\ProcessedData_3\GCaMP\181217\181217-G3M6-stim1-GSR-Detrend-0.01Hz-8Hz.mat','xform_datahb_bandpass_GSR')
%  sessionInfo.bandtype = {"0.01Hz-8Hz",0.01,8};
% 
xform_datahb_bandpass =highpass(xform_datahb_old,sessionInfo.bandtype{2},sessionInfo.framerate);
 xform_datahb_bandpass=lowpass(xform_datahb_bandpass ,sessionInfo.bandtype{3},sessionInfo.framerate);
% 
% 
% 
 xform_isbrain = Affine(I,isbrain);
% 
 xform_datahb_bandpass_GSR = mouse.preprocess.gsr(xform_datahb_bandpass,xform_isbrain);
% 
% 
% if ~isempty(find(isnan(xform_datahb_bandpass_GSR), 1))
%     xform_datahb_bandpass_GSR(isnan(xform_datahb_bandpass_GSR))=0;
%     disp(strcat(tiffFileName,'xform_datahb_bandpass_GSR has NAN'));
% end
% 
% 
% 

oxy = squeeze(xform_datahb_bandpass_GSR(:,:,1,:));
deoxy = squeeze(xform_datahb_bandpass_GSR(:,:,2,:));
total = oxy+deoxy;


oxy = oxy.*xform_isbrain;
deoxy = deoxy.*xform_isbrain;
total = total .*xform_isbrain;

oxy(isnan(oxy)) = 0;
deoxy(isnan(deoxy)) = 0;
total(isnan(total)) = 0;


fhraw=figure('Units','inches','Position',[7 3 10 7], 'PaperPositionMode','auto','PaperOrientation','Landscape');
set(fhraw,'Units','normalized','visible','off');
sessionInfo.stimbaseline = 118;
plotedit on
R=mod(size(oxy,3),sessionInfo.stimblocksize);
if R~=0
    pad=sessionInfo.stimblocksize-R;
    disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with ',' ', num2str(pad), ' zeros **'))
    oxy(:,:,end:end+pad)=0;
    deoxy(:,:,end:end+pad)=0;
    total(:,:,end:end+pad)=0;

end

oxy=reshape(oxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);

for b=1:size(oxy,4)
    MeanFrame=squeeze(mean(oxy(:,:,1:sessionInfo.stimbaseline,b),3));
    for t=1:size(oxy, 3);
        oxy(:,:,t,b)=squeeze(oxy(:,:,t,b))-MeanFrame;
    end
end

deoxy=reshape(deoxy,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
for b=1:size(deoxy,4)
    MeanFrame=squeeze(mean(deoxy(:,:,1:sessionInfo.stimbaseline,b),3));
    for t=1:size(deoxy, 3);
        deoxy(:,:,t,b)=squeeze(deoxy(:,:,t,b))-MeanFrame;
    end
end

total=reshape(total,info.nVy,info.nVx,sessionInfo.stimblocksize,[]);
for b=1:size(total,4)
    MeanFrame=squeeze(mean(total(:,:,1:sessionInfo.stimbaseline,b),3));
    for t=1:size(total, 3);
        total(:,:,t,b)=squeeze(total(:,:,t,b))-MeanFrame;
    end
end




% Block Average
disp(strcat('Generate ROI and Block average plot for '))

AvgOxy= mean(oxy,4);
MeanFrame_oxy=mean(AvgOxy(:,:,1:sessionInfo.stimbaseline),3);
AvgOxy_stim = mean(AvgOxy(:,:,(sessionInfo.stimbaseline+1):(sessionInfo.stimbaseline+round((sessionInfo.stimduration+1)*sessionInfo.framerate)))-MeanFrame_oxy,3);
    load('atlas.mat','AtlasSeeds');
    roi = AtlasSeeds == 9;
temp_oxy_area = AvgOxy_stim.*roi;
temp_oxy_max = max(temp_oxy_area,[],'all');
roi_contour = bwperim(roi);

mask_oxy = zeros(128,128);
mask_oxy(temp_oxy_area>= 0.75*temp_oxy_max) = 1;
mask_oxy = logical(mask_oxy);
mask_oxy_contour = bwperim(mask_oxy );







R=mod(size(oxy,3),sessionInfo.stimblocksize);

if R~=0
    pad=sessionInfo.stimblocksize-R;
    disp(strcat('** Non integer number of blocks presented. Padded ', processedDataName, num2str(run), ' with ', num2str(pad), ' zeros **'))
    oxy(:,:,end:end+pad)=0;
    deoxy(:,:,end:end+pad)=0;
    total(:,:,end:end+pad)=0;

end





oxy_blocks = mean(oxy,4);
deoxy_blocks = mean(deoxy,4);
total_blocks = mean(total,4);




oxy_blocks_baseline = oxy_blocks-mean(oxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
deoxy_blocks_baseline = deoxy_blocks-mean(deoxy_blocks(:,:,1:sessionInfo.stimbaseline),3);
total_blocks_baseline = total_blocks-mean(total_blocks(:,:,1:sessionInfo.stimbaseline),3);




clear oxy_blocks deoxy_blocks  total_blocks 


oxy_blocks_baseline_active =  zeros(1,sessionInfo.stimblocksize);
deoxy_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);
total_blocks_baseline_active = zeros(1,sessionInfo.stimblocksize);

for i = 1:sessionInfo.stimblocksize
    
    oxy_temp = oxy_blocks_baseline(:,:,i);
    oxy_blocks_baseline_active(i) = mean(oxy_temp(mask_oxy));
    
    deoxy_temp = deoxy_blocks_baseline(:,:,i);
    deoxy_blocks_baseline_active(i) = mean(deoxy_temp(mask_oxy));
    
    total_temp = total_blocks_baseline(:,:,i);
    total_blocks_baseline_active(i) = mean(total_temp(mask_oxy));
    

end
stimDurationFrames = round(sessionInfo.stimduration*sessionInfo.framerate);
[max_oxy,locs_oxy] = max(oxy_blocks_baseline_active(sessionInfo.stimbaseline:(sessionInfo.stimbaseline+stimDurationFrames+round(1*sessionInfo.framerate))));%find peaks


x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
plotedit on

figure;
subplot('position',[0.1,0.08,0.4,0.35])

yyaxis right
p2 = plot(x,oxy_blocks_baseline_active,'r-');

hold on
yyaxis right
p3 = plot(x,deoxy_blocks_baseline_active,'b-');

ylim([-1.2*max_oxy 1.2*max_oxy])
p4 = plot(x,total_blocks_baseline_active,'y-');
yyaxis left;

sessionInfo.stimFrequency = 1;
hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[-1.2*max_oxy 1.2*max_oxy]);
    hold on
end
ax = gca;
ax.FontSize = 4; 

legend([p2 p3 p4 ],'HbO_2','HbR','HbTotal','FontSize',4);
xlabel('Time(s)','FontSize',6)

yyaxis right
ylabel('HBO_2,HbR(\DeltaM)','FontSize',6)


subplot('position',[0.6,0.08,0.35,0.35])
imagesc(AvgOxy_stim,[-1.5*temp_oxy_max 1.5*temp_oxy_max])
hold on
contour(roi_contour,'r')
hold on
contour(mask_oxy_contour,'k')
axis image off
title('oxy 75% to oxy, deoxy, total' )



annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(' Block Average for  ' ,{' '}),'FontWeight','bold','Color',[1 0 0],'FontSize',8);

% output=fullfile(saveDir,strcat(visName,'_Vis.jpg'));
% orient portrait
% print ('-djpeg', '-r1000',output);
% figure('visible', 'on');
% close all