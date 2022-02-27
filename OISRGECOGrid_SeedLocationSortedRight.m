clear all;close all;clc
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load(which('AtlasandIsbrain.mat'))
AtlasSeedsFilled(:,65:end)=AtlasSeedsFilled(:,65:end)+20;
AtlasSeedsFilled(AtlasSeedsFilled==20) = 0;
imagesc(AtlasSeedsFilled)
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','I')
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_new_mice')
colors = {'r','g','b','w'};
ll = 1;
imagesc(AtlasSeedsFilled)
load('Z:\220210\220210-m.mat')
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     totalSubFileNum = length(runInfo.rawFile)/2;
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
%     seedLocation_mouse = nan(2,160);
%     seedLocation_mouse_valid = nan(2,79);
%     seedLocation_mouse_R = nan(2,160);
%     seedLocation_mouse_valid_R = nan(2,79);
%     jj = 1;
%     for ii = 1:160
%         if GoodSeedsidx_new_mice(ii)
%             [~,I_temp] = max(gridLaser_mouse(:,:,ii,1),[],'all','linear');
%             [row,col] = ind2sub([128 128],I_temp);
% 
%             seedLocation_mouse(1,ii) = row;
%             seedLocation_mouse(2,ii) = col;
%             seedLocation_mouse_valid(1,jj) = row;
%             seedLocation_mouse_valid(2,jj) = col;
% 
%             seedLocation_mouse_R(1,ii) = row;
%             seedLocation_mouse_R(2,ii) = 128-col+1;
%             seedLocation_mouse_valid_R(1,jj) = row;
%             seedLocation_mouse_valid_R(2,jj) = 128-col+1;
%             jj = jj+1;
%         end
%     end
%     seedLocation_mouse_valid_sorted = seedLocation_mouse_valid(:,I);
%      seedLocation_mouse_valid_sorted_R = seedLocation_mouse_valid_R(:,I);
%     for kk = 1:79
%         hold on
%         scatter(seedLocation_mouse_valid_sorted(2,kk),...
%             seedLocation_mouse_valid_sorted(1,kk),colors{ll})
%     end
%     for kk = 1:79
%         hold on
%         scatter(seedLocation_mouse_valid_sorted_R(2,kk),...
%             seedLocation_mouse_valid_sorted_R(1,kk),colors{ll})
%     end
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),...
%         'seedLocation_mouse','seedLocation_mouse_valid','seedLocation_mouse_valid_sorted',...
%         'seedLocation_mouse_R','seedLocation_mouse_valid_R','seedLocation_mouse_valid_sorted_R')
%     ll = ll+1;
% end
% 
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     totalSubFileNum = length(runInfo.rawFile)/2;
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse_R')
%     load(runInfo.saveMaskFile,'GoodSeedsidx')
%     gridevokeTimeTrace_jRGECO1a_R = nan(runInfo.samplingRate*runInfo.blockLen,160);
%     jj = 1;
%     for ii = 1:totalSubFileNum
%         load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
%         AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
%         numBlock = size(AvgMovie_jRGECO1a,4);
%         kk = 1;
%         while kk < numBlock+1
%             if GoodSeedsidx(m(jj)) == 1               
%                 x1 = seedLocation_mouse_R(2,m(jj));
%                 y1 = seedLocation_mouse_R(1,m(jj));
%                 [X,Y] = meshgrid(1:128,1:128);
%                 radius = 3;
%                 ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%                 movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
%                 ROI = ROI(:);
%                 movie_jRGECO1a = reshape(movie_jRGECO1a,[],size(movie_jRGECO1a,3));
%                 gridevokeTimeTrace_jRGECO1a_R(:,m(jj)) = squeeze(mean(movie_jRGECO1a(ROI,:)));       
%                 kk = kk+1;
%             end
%             jj = jj+1;
%         end       
%     end
%     gridEvokeTimeTrace_jRGECO1a_valid_R = gridevokeTimeTrace_jRGECO1a_R;
%     gridEvokeTimeTrace_jRGECO1a_valid_R(:,logical(1-GoodSeedsidx_new_mice)) = [];
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),...
%     'gridevokeTimeTrace_jRGECO1a_R','gridEvokeTimeTrace_jRGECO1a_valid_R','-append')
% end


ECMatrix_calcium_mice_R = nan(79,79,3);
numMouse = 1;
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium'),...
        'gridEvokeTimeTrace_jRGECO1a_valid','gridEvokeTimeTrace_jRGECO1a_valid_R') 
    ECMatrix_calcium_R = nan(79);
    for kk = 1:79
        for ll = 1:79
            ECMatrix_calcium_R(kk,ll) = corr(gridEvokeTimeTrace_jRGECO1a_valid(:,kk),...
                gridEvokeTimeTrace_jRGECO1a_valid_R(:,ll));
        end
    end
    ECMatrix_calcium_R_sorted = ECMatrix_calcium_R(I,I);
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),...
    'ECMatrix_calcium_R','ECMatrix_calcium_R_sorted','-append')
    ECMatrix_calcium_mice_R(:,:,numMouse) = atanh(ECMatrix_calcium_R);
    figure
    colormap jet
    imagesc(ECMatrix_calcium_R,[-1 1])
    h = colorbar;
    ylabel(h, 'r')
    title([runInfo.mouseName,'-ECMatrix-Calcium-Right'])
    axis image off
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium-R.png'))
    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium-R.fig'))
    close all
    numMouse = numMouse+1;
end

ECMatrix_calcium_mice_R = mean(ECMatrix_calcium_mice_R,3);
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-Atlas.mat','atlasIndx_valid_sorted','I')
ECMatrix_calcium_mice_R_sorted = ECMatrix_calcium_mice_R(I,I);
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
    'ECMatrix_calcium_mice_R_sorted','-append')
figure
colormap jet
imagesc(ECMatrix_calcium_mice_R_sorted,[-1 1])
title('N13M309-N13M548-N13M549-ECMatrix-Calcium-R')
h = colorbar;
ylabel(h, 'z(r)')
axis image
 [C, ia, ic] = unique(atlasIndx_valid_sorted);
seednames_sorted = cell(1,17);
for ii = 1:17
    seednames_sorted{ii} = seednames{atlasIndx_valid_sorted(ia(ii))};
end
yticks(ia)
yticklabels(seednames_sorted)
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-R.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-R.fig')
close all


load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
    'ECMatrix_calcium_mice_sorted')
ECMatrix_calcium_mice_sorted_LR = nan(79,79*2);
ECMatrix_calcium_mice_sorted_LR(:,1:79) = ECMatrix_calcium_mice_sorted;
ECMatrix_calcium_mice_sorted_LR(:,79+1:end) =  ECMatrix_calcium_mice_R_sorted;
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix.mat',...
    'ECMatrix_calcium_mice_sorted_LR','-append')

figure
colormap jet
imagesc(ECMatrix_calcium_mice_sorted_LR,[-0.6 0.6]);
title('N13M309-N13M548-N13M549-ECMatrix-Calcium-LR')
h = colorbar;
ylabel(h, 'z(r)','fontsize',10,'FontWeight','bold')
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
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-ECMatrix-Calcium-LR.fig')