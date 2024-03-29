load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat")
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat")
Group_directory = 'X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\cat';
cd(Group_directory)
load('WhiskerOnly-AvgStimResults.mat', 'ROI_mice','peakMaps_mice')
peakMaps_mice= reshape(peakMaps_mice,128,128,5,7);
peakMaps_whiskerOnly = mean(peakMaps_mice,4);
whiskerOnly = ROI_mice;
load('S1bLWhisker-AvgStimResults.mat', 'ROI_mice','peakMaps_mice')
peakMaps_mice= reshape(peakMaps_mice,128,128,5,7);
peakMaps_S1bLWhisker = mean(peakMaps_mice,4);
S1bLWhisker = ROI_mice;

% get xform_isbrain_intersect
runsInfo = parseRuns(excelFile,excelRows);
runNum = numel(runsInfo);
xform_isbrain_intersect = 1;
for runInd = 1:runNum
    runInfo=runsInfo(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain')
    xform_isbrain_intersect = xform_isbrain_intersect.*xform_isbrain;
end

% PeakMaps visualization
hbcolormap = customcolormap_preset('red-white-blue');
calciumcolormap = customcolormap_preset('pink-white-green');
xform_isbrain_intersect = xform_isbrain_intersect.*(leftMask+rightMask);
figure
ax1 = subplot(2,4,1)
imagesc(peakMaps_whiskerOnly(:,:,1),[-6 6])
colormap(ax1,hbcolormap)
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
axis image off
colorbar('southoutside')

ax2 = subplot(2,4,2)
imagesc(peakMaps_whiskerOnly(:,:,2),[-4 4])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax2,hbcolormap)
axis image off
colorbar('southoutside')

ax3 = subplot(2,4,3)
imagesc(peakMaps_whiskerOnly(:,:,3),[-4 4])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax3,hbcolormap)
axis image off
colorbar('southoutside')

ax4 = subplot(2,4,4)
imagesc(peakMaps_whiskerOnly(:,:,4),[-4 4])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax4,calciumcolormap)
axis image off
colorbar('southoutside')
%contour(ROI,'w')

ax5 = subplot(2,4,5)
imagesc(peakMaps_S1bLWhisker(:,:,1),[-6 6])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax5,hbcolormap)
colorbar('southoutside')
axis image off
colorbar('southoutside')

ax6 = subplot(2,4,6)
imagesc(peakMaps_S1bLWhisker(:,:,2),[-4 4])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax6,hbcolormap)
colorbar('southoutside')
axis image off
colorbar('southoutside')

ax7 = subplot(2,4,7)
imagesc(peakMaps_S1bLWhisker(:,:,3),[-4 4])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax7,hbcolormap)
colorbar('southoutside')
axis image off
colorbar('southoutside')

ax8 = subplot(2,4,8)
imagesc(peakMaps_S1bLWhisker(:,:,4),[-4 4])
hold on
imagesc(xform_WL,'AlphaData',1-xform_isbrain_intersect);
colormap(ax8,calciumcolormap)
colorbar('southoutside')
axis image off
colorbar('southoutside')

S1bLWhisker_mean = nanmean(S1bLWhisker,2);
whiskerOnly_mean = nanmean(whiskerOnly,2);
%%
data = [];
for ii = 1:4
    data = cat(1,data,whiskerOnly_mean(ii));
    data = cat(1,data,S1bLWhisker_mean(ii));
end

%%
S1bLWhisker_std = nanstd(S1bLWhisker,0,2);
whiskerOnly_std = nanstd(whiskerOnly,0,2);
error = [];
for ii = 1:4
    error = cat(1,error,whiskerOnly_std(ii));
    error = cat(1,error,S1bLWhisker_std(ii));
end
figure
x =1:8;
errhigh = error;
errlow  = error;
errhigh(3:4) = 0;
errlow([1,2,5,6,7,8]) = 0
b=bar(x,data);

b.FaceColor = 'flat';
for ii = 1:2
b.CData(ii,:) = [1 0 0];
end

for ii = 3:4
b.CData(ii,:) = [0 0 1];
end

for ii = 5:6
b.CData(ii,:) = [0 0 0];
end

for ii = 7:8
b.CData(ii,:) = [1 0 1];
end


hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

hold off

grid on
xticklabels({'WS','WS+PS_{S1bL}','WS','WS+PS_{S1bL}','WS','WS+PS_{S1bL}','WS','WS+PS_{S1bL}'})
ylabel('%')

yyaxis left
ylabel('\Delta\muM')
ylim([-3,6])
yyaxis right
ylim([-3,6])
ylabel('\DeltaF/F%')
set(gca,'ycolor','k') 
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
[h, p]=ttest2(whiskerOnly(1,:), S1bLWhisker(1,:), 0.05, 'both', 'unequal')

[h, p]=ttest2(whiskerOnly(2,:), S1bLWhisker(2,:), 0.05, 'both', 'unequal')

[h, p]=ttest2(whiskerOnly(3,:), S1bLWhisker(3,:), 0.05, 'both', 'unequal')

[h, p]=ttest2(whiskerOnly(4,:), S1bLWhisker(4,:), 0.05, 'both', 'unequal')


