clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load(which('AtlasandIsbrain.mat'))
AtlasSeedsFilled(:,65:end)=AtlasSeedsFilled(:,65:end)+20;
imagesc(AtlasSeedsFilled)
AtlasSeedsFilled(AtlasSeedsFilled==20) = 0;
imagesc(AtlasSeedsFilled)

load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice')
atlasIndx = nan(1,160);
atlasIndx_valid = nan(1,79);
seedLocation_mice_valid = nan(2,79);
jj = 1;
for ii = 1:160
    if ~isnan(seedLocation_mice(1,ii))
        seedLocation_mice_valid(:,jj) = round(seedLocation_mice(:,ii));
        atlasIndx(ii) = AtlasSeedsFilled(seedLocation_mice_valid(1,jj),...
            seedLocation_mice_valid(2,jj));
        atlasIndx_valid(jj) = atlasIndx(ii);
        jj = jj+1;
    end
end
[atlasIndx_valid_sorted,I] = sort(atlasIndx_valid);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted','I','atlasIndx_valid')

seedLocation_mice_valid_sorted = seedLocation_mice_valid(:,I);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat',...
    'seedLocation_mice_valid_sorted','seedLocation_mice_valid','-append')

ECMatrix_jRGECO1a_sorted = nan(79);
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),...
        'gridEvokeTimeTrace_jRGECO1a_valid')
    gridEvokeTimeTrace_jRGECO1a_valid_sorted = gridEvokeTimeTrace_jRGECO1a_valid(I);
    for ii = 1:79
        for jj = 1:79
            ECMatrix_jRGECO1a_sorted(ii,jj) = corr(gridEvokeTimeTrace_jRGECO1a_valid(:,ii),...
                gridEvokeTimeTrace_jRGECO1a_valid(:,jj));
        end
    end
end

% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% ECMatrix_calcium_mice_sorted = nan(79,79,3);
% numMouse = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),'ECMatrix_calcium')
%     ECMatrix_calcium_sorted = ECMatrix_calcium(I,I);
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),'ECMatrix_calcium_sorted','-append')
%     ECMatrix_calcium_mice_sorted(:,:,numMouse) = atanh(ECMatrix_calcium_sorted);
%     figure
%     colormap jet
%     imagesc(ECMatrix_calcium_sorted,[-1 1])
%     colorbar
%     title([runInfo.mouseName,'-ECMatrix-Calcium-sorted'])
%     axis image off
%     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium-sorted.png'))
%     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium-sorted.fig'))
%     %close all
%     numMouse = numMouse+1;
% end
% ECMatrix_calcium_mice_sorted = mean(ECMatrix_calcium_mice_sorted,3);
% figure
% colormap jet
% imagesc(ECMatrix_calcium_mice_sorted,[-1 1])
% colorbar
% title('N13M309-N13M548-N13M549-ECMatrix-Calcium-Sorted')
% h = colorbar;
% ylabel(h, 'z(r)')
% [C, ia, ic] = unique(atlasIndx_valid_sorted);
% seednames_sorted = cell(1,17);
% for ii = 1:17
%     seednames_sorted{ii} = seednames{atlasIndx_valid_sorted(ia(ii))};
% end
% yticks(ia)
% yticklabels(seednames_sorted)
% axis square
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-Sorted.png')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-Sorted.fig')
% %close all
