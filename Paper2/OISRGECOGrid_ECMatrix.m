clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_new_mice')
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','I')
ECMatrix_calcium_mice = nan(79,79,3);
numMouse = 1;
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium'),'gridevokeTimeTrace_jRGECO1a')
    
    gridEvokeTimeTrace_jRGECO1a_valid = nan(600,79);
    jj = 1;
    position = cell(1,79);
    for ii = 1:160
        if GoodSeedsidx_new_mice(ii)
            gridEvokeTimeTrace_jRGECO1a_valid(:,jj) = gridevokeTimeTrace_jRGECO1a(:,ii);
            position{jj} = num2str(ii);
            jj = jj+1;
        end
    end
    
    ECMatrix_calcium = nan(79);
    for kk = 1:79
        for ll = 1:79
            ECMatrix_calcium(kk,ll) = corr(gridEvokeTimeTrace_jRGECO1a_valid(:,kk),...
                gridEvokeTimeTrace_jRGECO1a_valid(:,ll));
        end
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium'),'gridEvokeTimeTrace_jRGECO1a_valid','-append')
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),'ECMatrix_calcium')
    ECMatrix_calcium_mice(:,:,numMouse) = atanh(ECMatrix_calcium);
    figure
    colormap jet
    imagesc(ECMatrix_calcium,[-1 1])
    colorbar
    title([runInfo.mouseName,'-ECMatrix-Calcium'])
    axis image off
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium.png'))
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium.fig'))
    close all
    numMouse = numMouse+1;
end
ECMatrix_calcium_mice = mean(ECMatrix_calcium_mice,3);
figure
colormap jet
imagesc(ECMatrix_calcium_mice,[-1 1])
colorbar
title('N13M309-N13M548-N13M549-ECMatrix-Calcium')
h = colorbar;
ylabel(h, 'z(r)')
axis image off
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium.fig')
close all
ECMatrix_calcium_mice_sorted = ECMatrix_calcium_mice(I,I);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
    'ECMatrix_calcium_mice','ECMatrix_calcium_mice_sorted')



