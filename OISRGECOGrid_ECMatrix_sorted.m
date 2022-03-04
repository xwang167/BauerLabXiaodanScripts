clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','I')
ECMatrix_calcium_mice_LR_sorted = nan(79,79*2,3);
numMouse = 1;
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium'),...
        'gridEvokeTimeTrace_jRGECO1a_valid','gridEvokeTimeTrace_jRGECO1a_valid_R') 
    gridEvokeTimeTrace_jRGECO1a_valid_sorted = gridEvokeTimeTrace_jRGECO1a_valid(:,I);
    gridEvokeTimeTrace_jRGECO1a_valid_R_sorted = gridEvokeTimeTrace_jRGECO1a_valid_R(:,I);
    ECMatrix_calcium_R_sorted = nan(79);
    ECMatrix_calcium_sorted = nan(79);
    ECMatrix_calcium_LR_sorted = nan(79,79*2);
    for kk = 1:79
        for ll = 1:79
            ECMatrix_calcium_R_sorted(kk,ll) = corr(gridEvokeTimeTrace_jRGECO1a_valid_sorted(:,kk),...
                gridEvokeTimeTrace_jRGECO1a_valid_R_sorted(:,ll));
            ECMatrix_calcium_sorted(kk,ll) = corr(gridEvokeTimeTrace_jRGECO1a_valid_sorted(:,kk),...
                gridEvokeTimeTrace_jRGECO1a_valid_sorted(:,ll));           
        end
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),...
    'ECMatrix_calcium_sorted','ECMatrix_calcium_R_sorted','-append')
    ECMatrix_calcium_LR_sorted(:,1:79) = ECMatrix_calcium_sorted;
    ECMatrix_calcium_LR_sorted(:,80:end) = ECMatrix_calcium_R_sorted;
    
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),...
    'ECMatrix_calcium_sorted','ECMatrix_calcium_R_sorted','ECMatrix_calcium_LR_sorted','-append')

    ECMatrix_calcium_mice_LR_sorted(:,1:79,numMouse) = atanh(ECMatrix_calcium_sorted);
    ECMatrix_calcium_mice_LR_sorted(:,80:end,numMouse) = atanh(ECMatrix_calcium_R_sorted);
    numMouse = numMouse+1;
    figure
    colormap jet
    imagesc(ECMatrix_calcium_LR_sorted,[-1 1])
    h = colorbar;
    ylabel(h, 'r')
    title([runInfo.mouseName,'-ECMatrix-Calcium-LR'])
    axis image off
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium-LR.png'))
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium-LR.fig'))
    close all
end
ECMatrix_calcium_mice_LR_sorted = mean(ECMatrix_calcium_mice_LR_sorted,3);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
    'ECMatrix_calcium_mice','ECMatrix_calcium_mice_LR_sorted')

 load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
 load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat', 'atlasIndx_valid_sorted')
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_calcium_mice_LR_sorted,[-1 1]);
title('N13M309-N13M548-N13M549-ECMatrix-Calcium-LR')
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
axis image
 [C, ia, ic] = unique(atlasIndx_valid_sorted);
seednames_sorted = cell(1,17*2);
for ii = 1:17
    seednames_sorted{ii} = seednames{atlasIndx_valid_sorted(ia(ii))};
    seednames_sorted{ii+17} = seednames{atlasIndx_valid_sorted(ia(ii))};
end
yticks(ia)
yticklabels(seednames_sorted)
xticks([ia' ia'+79])
xticklabels(seednames_sorted)
xtickangle(45)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridColor
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR.fig')

