function getStimMap(numBlocks,gcamp_peakAvg,gcampCorr_peakAvg,oxy_peakAvg,deoxy_peakAvg,total_peakAvg,AvgOxy_peakAvg,Avggcamp_peakAvg,AvgDeOxy_peakAvg,AvgTotal_peakAvg,AvggcampCorr_peakAvg,visName,saveDir,max_oxy,max_gcampCorr)
figure('units','normalized','outerposition',[0 0 1 1])
for b=1:numBlocks
    p = subplot('position', [0.015+(b-1)*0.095 0.8 0.095 0.095]);
    imagesc(gcamp_peakAvg(:,:,b), [-1.2*max_gcampCorr 1.2*max_gcampCorr]);
    if b == numBlocks
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.8 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('GcampRaw')
    end
    title(['Pres ', num2str(b)]);
    set(gca,'FontSize',10)
end


for b=1:numBlocks
    p = subplot('position', [0.015+(b-1)*0.095 0.65 0.095 0.095]);
    imagesc(gcampCorr_peakAvg(:,:,b), [-1.2*max_gcampCorr 1.2*max_gcampCorr]);
    if b == numBlocks
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.65 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('GcampCorr')
    end
    title(['Pres ', num2str(b)]);
    set(gca,'FontSize',10)
end


for b=1:numBlocks
    p = subplot('position', [0.015+(b-1)*0.095 0.5 0.095 0.095]);
    imagesc(oxy_peakAvg(:,:,b), [-1.2*max_oxy 1.2*max_oxy]);
    if b == numBlocks
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.5 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b == 1
        ylabel('Oxy')
    end
    title(['Pres ', num2str(b)]);
    set(gca,'FontSize',10)
end


for b=1:numBlocks
    p = subplot('position', [0.015+(b-1)*0.095 0.35 0.095 0.095]);
    imagesc(deoxy_peakAvg(:,:,b), [-0.9*max_oxy 0.9*max_oxy]);
    if b == numBlocks
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.35 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('DeOxy')
    end
    title(['Pres ', num2str(b)]);
    set(gca,'FontSize',10)
end




for b=1:numBlocks
    p = subplot('position', [0.015+(b-1)*0.095 0.2 0.095 0.095]);
    imagesc(total_peakAvg(:,:,b), [-1.2*max_oxy 1.2*max_oxy]);
    if b == numBlocks
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.2 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('Total')
    end
    title(['Pres ', num2str(b)]);
    set(gca,'FontSize',10)
end

clear oxy deoxy total gcamp gcampCorr

p = subplot('position', [0.015 0.05 0.095 0.095]);

imagesc(Avggcamp_peakAvg, [-1.2*max_gcampCorr 1.2*max_gcampCorr]);
colorbar
set(p,'Position',[0.015 0.05 0.095 0.095]);
axis image off
title('Avg Gcamp')
set(gca,'FontSize',10)


p = subplot('position', [0.165 0.05 0.095 0.095]);
imagesc(AvggcampCorr_peakAvg, [-1.2*max_gcampCorr 1.2*max_gcampCorr]);
colorbar
set(p,'Position',[0.165 0.05 0.095 0.095]);
axis image off
title('Avg GcampCorr')
set(gca,'FontSize',10)


p = subplot('position', [0.315 0.05 0.095 0.095]);
imagesc(AvgOxy_peakAvg, [-1.2*max_oxy 1.2*max_oxy]);
colorbar
set(p,'Position',[0.315 0.05 0.095 0.095]);
axis image off
title('Avg Oxy')
set(gca,'FontSize',10)

p = subplot('position', [0.465 0.05 0.095 0.095]);
imagesc(AvgDeOxy_peakAvg, [-0.9*max_oxy 0.9*max_oxy]);
colorbar
set(p,'Position',[0.465 0.05 0.095 0.095]);
axis image off
title('Avg DeOxy')
set(gca,'FontSize',10)

p = subplot('position', [0.615 0.05 0.095 0.095]);
imagesc(AvgTotal_peakAvg, [-1.2*max_oxy 1.2*max_oxy]);
colorbar
set(p,'Position',[0.615 0.05 0.095 0.095]);
axis image off
title('Avg Total')
set(gca,'FontSize',10)

t = annotation('textbox',[0.125 0.9 0.85 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName,' Processed Data Visualization'),'FontWeight','bold','Color',[1 0 0]);
t.FontSize = 14;
output= fullfile(saveDir,strcat(visName,'_StimMap.jpg'));
orient portrait
print ('-djpeg', '-r300', output);

figure('visible', 'on');
close all
clear AvgOxy AvgDeOxy AvgTotal Avggcamp AvggcampCorr


