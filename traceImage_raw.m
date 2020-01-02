function  traceImage_raw(downSampledBlocks1,downSampledBlocks2,downSampledBlocks3,name1,name2,name3,active1,active2,active3,color1,color2,color3,ROI_contour,yunit,stimduration,stimblocksize,stimFrequency,framerate,stimbaseline,stimStartTime,stimEndTime,xform_isbrain)
x = linspace(0,stimblocksize/framerate,length(active1));
figure('units','normalized','outerposition',[0 0 1 1]);
subplot('position',[0.05,0.08,0.55,0.35])
plot(x,active1,'color',color1);
hold on
plot(x,active2,'color',color2);
hold on
plot(x,active3,'color',color3);
hold on


minimum = min([active1 active2 active3],[],'all');
maxmum = max([active1 active2 active3],[],'all');

set(findall(gca, 'Type', 'Line'),'LineWidth',2);

% for i  = 0:1/stimFrequency:stimduration-1/stimFrequency
%     line([stimbaseline/framerate+i stimbaseline/framerate+i],[ 1.1*minimum 1.1*maxmum]);
%     hold on
% end

ax = gca;
ax.FontSize = 8;
xlim([0 round(stimblocksize/framerate)])
ylim([ 1.1*minimum 1.1*maxmum])
[max1] = max(abs(active1(round(framerate*stimStartTime):round(framerate*stimEndTime))));
[max2] = max(abs(active2(round(framerate*stimStartTime):round(framerate*stimEndTime))));
[max3] = max(abs(active3(round(framerate*stimStartTime):round(framerate*stimEndTime))));





lgd =legend(name1,name2,name3);
lgd.FontSize = 14;
xlabel('Time(s)','FontSize',20,'FontWeight','bold')
ylabel(yunit,'FontSize',20,'FontWeight','bold')

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')

subplot('position',[0.8,0.1,0.2,0.25])

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','WL')
for b=stimStartTime: stimEndTime+4
    p = subplot('position', [0.015+(b-stimStartTime)*0.09 0.80 0.07 0.12]);
    imagesc(downSampledBlocks1(:,:,b), [0 0.7]);
    if b == stimEndTime+4
        colorbar
        set(p,'Position',[0.015+(b-stimStartTime)*0.09 0.80 0.07 0.12]);
    end
    axis image off
    hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
    
    if b == stimStartTime
        ylabel(name1,'FontWeight','bold')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    colormap jet
end

for b=stimStartTime: stimEndTime+4
    p = subplot('position', [0.015+(b-stimStartTime)*0.09 0.64 0.07 0.12]);
    imagesc(downSampledBlocks2(:,:,b), [0 0.7]);
    if b == stimEndTime+4
        colorbar
        set(p,'Position',[0.015+(b-stimStartTime)*0.09 0.64 0.07 0.12]);
    end
    axis image off;
%     set(gca, 'XTick', []);
%     set(gca, 'YTick', []);
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
    
    if b==stimStartTime
        ylabel(name2,'FontWeight','bold')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    colormap jet
end



for b=stimStartTime: stimEndTime+4
    p = subplot('position', [0.015+(b-stimStartTime)*0.09 0.48 0.07 0.12]);
    imagesc(downSampledBlocks3(:,:,b), [0 80]);
    if b == stimEndTime+4
        colorbar
        set(p,'Position',[0.015+(b-stimStartTime)*0.09 0.48 0.07 0.12]);
    end
    axis image off;
     hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)

    if b==stimStartTime
        ylabel(name3,'FontWeight','bold')
    end
    title([num2str(b),'s']);
    ax = gca;
    ax.FontSize = 10;
    colormap jet
end


subplot('position',[0.79,0.27,0.13,0.18])
imagesc(downSampledBlocks1(:,:,stimEndTime),...
    [-0.5,1.5])
colorbar
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
hold on
contour(ROI_contour,'k')
axis image off
title(name1);

subplot('position',[0.64,0.05,0.13,0.18])
imagesc(downSampledBlocks2(:,:,stimEndTime),...
    [-0.5 1.5])
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
colorbar
hold on
contour(ROI_contour,'k')
axis image off
title(name2);


subplot('position',[0.79,0.05,0.13,0.18])

imagesc(downSampledBlocks3(:,:,stimEndTime),...
    [0 20])
colorbar
 hold on
    imagesc(WL,'AlphaData',1-xform_isbrain)
hold on
contour(ROI_contour,'k')
axis image off
title(name3)
colormap jet


% 
% figure
% 
% mask = poly2mask(ROI_contour);
% imagesc(downSampledBlocks1(:,:,stimEndTime),...
%     [min(downSampledBlocks1(:,:,stimEndTime),[],'all'),max(downSampledBlocks1(:,:,stimEndTime),[],'all')])
% colorbar
%  hold on
%     imagesc(WL,'AlphaData',1-mask)
% axis image off
% title(name1);
% 
% figure
% mask = poly2mask(ROI_contour);
% imagesc(downSampledBlocks2(:,:,stimEndTime),...
%     [min(downSampledBlocks2(:,:,stimEndTime),[],'all'),max(downSampledBlocks2(:,:,stimEndTime),[],'all')])
% colorbar
%  hold on
%     imagesc(WL,'AlphaData',1-mask)
% axis image off
% title(name2);
% 


colormap jet


end



