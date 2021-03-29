function [fh,f,ROI] = generateBlockMapandROI(data,contrastName,range,runInfo,numBlocks,xform_isbrain)
% pres of each block during stim period
numRows = length(contrastName);
fh = figure('units','normalized','outerposition',[0 0 1 1]);
colormap jet
for ii = 1:numBlocks
    for jj = 1:length(contrastName)
        p = subplot(numRows,numBlocks,numBlocks*(jj-1)+ii);
        pre = squeeze(mean(data(:,:,runInfo.stimStartTime*runInfo.samplingRate+1:runInfo.stimEndTime*runInfo.samplingRate,ii,jj),3));
        imagesc(pre,[-range(jj),range(jj)]);
                    axis image
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
        if jj==1
        title(strcat('Pres',{' '},num2str(ii)))
        end
        if ii == 1
            ylabel(contrastName{jj})
        end
        if ii == numBlocks
            Pos = get(p,'Position');
            colorbar
            set(p,'Position',Pos)
        end
    end
end


% generate ROI
temp = squeeze(mean(data(:,:,runInfo.stimStartTime*runInfo.samplingRate+1:runInfo.stimEndTime*runInfo.samplingRate,1:numBlocks,end),3));
peakMap = squeeze(mean(temp,3));
f=figure;
imagesc(peakMap.*xform_isbrain)
colormap jet
colorbar
axis image off
title(contrastName(end));
load('D:\OIS_Process\atlas.mat','AtlasSeeds')
Barrel = AtlasSeeds==9;

[~,loc] = max(Barrel.*peakMap,[],'all','linear');
[row,col] = ind2sub([128,128],loc);

x1 = col;
y1 = row;
[X,Y] = meshgrid(1:128,1:128);
radius = 9;
ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
max_ROI = prctile(peakMap(ROI),99);
temp = peakMap.*ROI;
ROI = temp>0.75*max_ROI;
hold on
contour(ROI,'k')
pause(0.1)
