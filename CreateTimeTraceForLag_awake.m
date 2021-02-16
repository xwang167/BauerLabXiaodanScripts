load('L:\RGECO\190627\190627-R5M2286-fc1_processed.mat', 'xform_datahb','xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M2286-fc1
load('D:\OIS_Process\noVasculatureMask.mat');
WB = 255*ones(128,128,3);
mask = leftMask+rightMask;
xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
% Hb_filter = mouse.freq.lowpass(double(xform_datahb),0.4,25);
% FAD_filter = mouse.freq.lowpass(double(squeeze(xform_FADCorr)),0.4,25);
% Calcium_filter = mouse.freq.lowpass(double(squeeze(xform_jrgeco1aCorr)),0.4,25);
% 
% Hb_filter = double(xform_datahb);
% FAD_filter = double(squeeze(xform_FADCorr));
% Calcium_filter = double(squeeze(xform_jrgeco1aCorr));

Hb_filter = mouse.freq.filterData(double(xform_datahb),0.02,2,25);
FAD_filter = mouse.freq.filterData(double(squeeze(xform_FADCorr)),0.02,2,25);
Calcium_filter = mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr)),0.02,2,25);
HbT_filter = Hb_filter(:,:,1,:) + Hb_filter(:,:,2,:);
Calcium = squeeze(mean(mean(Calcium_filter(71:75,17:21,:),1),2))*100;
FAD = squeeze(mean(mean(FAD_filter(71:75,17:21,:),1),2))*100;
HbT = squeeze(mean(mean(HbT_filter(71:75,17:21,:),1),2))*10^6;
figure
time = (1:1+60*25)/25;
yyaxis left
h(1) = plot(time,Calcium(3769:3769+60*25)/4,'m-')
hold on
h(2) = plot(time,FAD(3769:3769+60*25),'g-')
ylabel('\DeltaF/F%')
hold on
ylim([-2.5 2.5])
yyaxis right
h(3) = plot(time,HbT(3769:3769+60*25)/2,'k-')
ylabel('\muM')
xlabel('time(s)')
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
legend(h,{'Corrected jRGECO1a/4','Corrected FAD','HbT'},'location','northwest','FontSize',14,'FontWeight','Bold')
xlim([0,60])
ylim([-2.5 2.5])
ROI = zeros(128,128);
ROI(71:75,17:21) =1;
patch([23.64,23.64+90/25,23.64+90/25,23.64],[-5 -5 10 10],[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5)
legend(h,{'Corrected jRGECO1a/4','Corrected FAD','HbT'},'location','northwest','FontSize',14,'FontWeight','Bold')

% 
% 


figure
ax = subplot(3,10,1);
imagesc(Calcium_filter(:,:,4360).*mask*100,[-5 5]);axis image off;
hold on;
contour(ROI,'k')
hold on;
imagesc(WB,'AlphaData',1-mask)
ylabel('Calcium')
title([num2str(23.64),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,11);
imagesc(FAD_filter(:,:,4360)*100.*mask,[-0.6 0.6]);axis image off;
hold on
contour(ROI,'k')
hold on;
imagesc(WB,'AlphaData',1-mask)
ylabel('FAD')
colormap(ax,summer)

ax = subplot(3,10,21);
imagesc(Hb_filter(:,:,1,4360).*mask*10^6,[-9 9 ]);axis image off;
ylabel('HbT')
hold on
contour(ROI,'k')
hold on;
imagesc(WB,'AlphaData',1-mask)
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)



ax = subplot(3,10,2);
imagesc(Calcium_filter(:,:,4360+10).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+10/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,12);
imagesc(FAD_filter(:,:,4360+10)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,22);
imagesc(Hb_filter(:,:,1,4360+10).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)



ax = subplot(3,10,3);
imagesc(Calcium_filter(:,:,4360+10*2).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+20/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,13);
imagesc(FAD_filter(:,:,4360+10*2)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,23);
imagesc(Hb_filter(:,:,1,4360+10*2).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)



ax = subplot(3,10,4);
imagesc(Calcium_filter(:,:,4360+10*2).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+30/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,14);
imagesc(FAD_filter(:,:,4360+10*2)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,24);
imagesc(Hb_filter(:,:,1,4360+10*2).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)


ax = subplot(3,10,5);
imagesc(Calcium_filter(:,:,4360+10*3).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+40/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,15);
imagesc(FAD_filter(:,:,4360+10*3)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,25);
imagesc(Hb_filter(:,:,1,4360+10*3).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)


ax = subplot(3,10,6);
imagesc(Calcium_filter(:,:,4360+10*4).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+50/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,16);
imagesc(FAD_filter(:,:,4360+10*4)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,26);
imagesc(Hb_filter(:,:,1,4360+10*4).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)


ax = subplot(3,10,7);
imagesc(Calcium_filter(:,:,4360+10*5).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+60/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,17);
imagesc(FAD_filter(:,:,4360+10*5)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,27);
imagesc(Hb_filter(:,:,1,4360+10*5).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)


ax = subplot(3,10,8);
imagesc(Calcium_filter(:,:,4360+10*6).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+70/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,18);
imagesc(FAD_filter(:,:,4360+10*6)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,28);
imagesc(Hb_filter(:,:,1,4360+10*6).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax, gray)


ax = subplot(3,10,9);
imagesc(Calcium_filter(:,:,4360+10*7).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
title([num2str(23.64+80/25),'s'],'FontSize',20)
colormap(ax,hot)

ax = subplot(3,10,19);
imagesc(FAD_filter(:,:,4360+10*7)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)

ax = subplot(3,10,29);
imagesc(Hb_filter(:,:,1,4360+10*7).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
colormap(ax,summer)
colormap(ax, gray)


ax = subplot(3,10,10);
imagesc(Calcium_filter(:,:,4360+10*8).*mask*100,[-5 5]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-10 0 10])
ylabel(cb,'\DeltaF/F%','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
title([num2str(23.64+90/25),'s'],'FontSize',20)
colormap(ax,hot)

ax =subplot(3,10,20);
imagesc(FAD_filter(:,:,4360+10*8)*100.*mask,[-0.6 0.6]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-1 0 1])
ylabel(cb,'\DeltaF/F%','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
colormap(ax,summer)

ax = subplot(3,10,30);
imagesc(Hb_filter(:,:,1,4360+10*8).*mask*10^6,[-9 9 ]);axis image off;
hold on;
imagesc(WB,'AlphaData',1-mask)
originalSize = get(gca,'Position');
cb = colorbar('FontSize',20,'Fontweight','bold');
set(cb,'Ytick',[-3 0 3])
ylabel(cb,'\Delta\muM','FontSize',20,'fontweight','bold')
set(ax,'Position',originalSize)
colormap(ax, gray)