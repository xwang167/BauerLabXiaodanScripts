

function    QC_stim_raw(frame1, frame2,frame3,stimBaselineFrames,stimDurationFrames,numBlocks,framerate,ROI,texttitle,output,systemType)

nVx = size(frame1,2);
nVy = size(frame1,1);
frame1 = reshape(frame1,nVy,nVx,[],numBlocks);
frame2 = reshape(frame2,nVy,nVx,[],numBlocks);
frame3 = reshape(frame3,nVy,nVx,[],numBlocks);

frame1_blocks = squeeze(mean(frame1,4));
frame2_blocks = squeeze(mean(frame2,4));
frame3_blocks = squeeze(mean(frame3,4));

frame1_off = mean(frame1_blocks(:,:,1:stimBaselineFrames),3);
frame1_on = mean(frame1_blocks(:,:,stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames),3);

frame2_off = mean(frame2_blocks(:,:,1:stimBaselineFrames),3);
frame2_on = mean(frame2_blocks(:,:,stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames),3);

frame3_off = mean(frame3_blocks(:,:,1:stimBaselineFrames),3);
frame3_on = mean(frame3_blocks(:,:,stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames),3);

figure('units','normalized','outerposition',[0 0 1 1]);


% if strcmp(systemType,'EastOIS2')
% baseRange = [2600 3200];
% differenceRange1 = [-50 50];
% differenceRange2 = [-50 50];
% differenceRange3 = [-3000 3000];
% laserOn = [2600 6000];
% else
% baseRange = [96 105];
% %baseRange = [92 99];
% differenceRange1 = [-2 2];
% differenceRange2 = [-0.6 0.6];
% differenceRange3 = [-100 100];
% laserOn = [100 300];
% %laserOn = [94 150];
% end
%
%
% subplot(3,3,1);imagesc(squeeze(frame1_off),baseRange);axis image;title('off');set(gca,'xtick',[]);set(gca,'ytick',[]);ylabel('Green');colorbar;
% subplot(3,3,2);imagesc(squeeze(frame1_on),baseRange);axis image off;title('on');colorbar;
% subplot(3,3,3);imagesc(squeeze(frame1_on-frame1_off),differenceRange1);axis image off;title('On-off');colorbar;hold on;ROI_contour = bwperim(ROI);contour( ROI_contour,'k');
% 
% subplot(3,3,4);imagesc(squeeze(frame2_off),baseRange);axis image;set(gca,'xtick',[]);set(gca,'ytick',[]);ylabel('Red');colorbar;
% subplot(3,3,5);imagesc(squeeze(frame2_on),baseRange);axis image off;colorbar;
% subplot(3,3,6);imagesc(squeeze(frame2_on-frame2_off),differenceRange2);axis image off;colorbar;hold on;ROI_contour = bwperim(ROI);contour( ROI_contour,'k');
% 
% subplot(3,3,7);imagesc(squeeze(frame3_off),baseRange);axis image;set(gca,'xtick',[]);set(gca,'ytick',[]);ylabel('FLuor');colorbar;
% subplot(3,3,8);imagesc(squeeze(frame3_on),laserOn);axis image off;colorbar;
% subplot(3,3,9);imagesc(squeeze(frame3_on-frame3_off),differenceRange3);axis image off;colorbar;hold on;ROI_contour = bwperim(ROI);contour( ROI_contour,'k');
% colormap jet
% texttitle1 = strcat(' Averaged Image', {' '},texttitle);
% annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle1,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
% output1 = strcat(output,'_AveragedImage.jpg');
% orient portrait
% print ('-djpeg', '-r1000',output1);



iROI = reshape(ROI,1,[]);

%frame1_blocks= reshape(frame1_blocks-squeeze(frame1_off),length(iROI),[]);
frame1_blocks= reshape((frame1_blocks-squeeze(frame1_off))./squeeze(frame1_off),length(iROI),[]);
frame1_active = mean(frame1_blocks(iROI,:),1);

%frame2_blocks= reshape(frame2_blocks-squeeze(frame2_off),length(iROI),[]);
frame2_blocks= reshape((frame2_blocks-squeeze(frame2_off))./squeeze(frame2_off),length(iROI),[]);
frame2_active = mean(frame2_blocks(iROI,:),1);

%frame3_blocks= reshape(frame3_blocks-squeeze(frame3_off),length(iROI),[]);
frame3_blocks= reshape((frame3_blocks-squeeze(frame3_off))./squeeze(frame3_off),length(iROI),[]);
frame3_active = mean(frame3_blocks(iROI,:),1);
% if ~strcmp(mouseType,'jrgeco1a')
%     
%     if strcmp(systemType,'EastOIS2')
%         maxVal = 120;
%     else
%         maxVal = 1;
%     end
% end
display(['LED1 is ' num2str(mean(frame1_active(stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames)))])
display(['LED2 is ' num2str(mean(frame2_active(stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames)))])
display(['Laser is ' num2str(mean(frame3_active(stimBaselineFrames+1:stimBaselineFrames+stimDurationFrames)))])
figure
x = (1:length( frame1_active))/ framerate;
plot(x,frame1_active.*100,'g-');
hold on
plot(x,frame2_active*100,'r-');
hold on
plot(x,frame3_active*100,'m-');


xlabel('Time(s)','FontSize',12)
ylabel('\DeltaR/R(%)','FontSize',12)

%xlim([0 (length(frame1_active)/ framerate)]);
% ylim([-maxVal maxVal])
legend('green','red','Red Fluor','location','southeast')

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',10);

saveas(gcf,strcat(output,'tracePlot.fig'))
saveas(gcf,strcat(output,'tracePlot.png'))
save(strcat(output,'xform_RawROI.mat'),'frame1_active','frame2_active','frame3_active')



end