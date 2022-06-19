clear all;close all;clc
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load(which('AtlasandIsbrain.mat'))
AtlasSeedsFilled(:,65:end)=AtlasSeedsFilled(:,65:end)+20;
AtlasSeedsFilled(AtlasSeedsFilled==20) = 0;
imagesc(AtlasSeedsFilled)
load('W:\220210\220210-m.mat')
excelRows = 5:11;

%load the laser frame (first frame of the laser stim)
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    gridLaser_mouse = nan(128,128,160,totalSubFileNum);
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-xform_laser_grid.mat'),'gridLaser')
        gridLaser_mouse(:,:,:,ii) = gridLaser;
    end
    gridLaser_mouse = nanmean(gridLaser_mouse,4);
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
end

%loading prevoius step into one step file
gridLaser_mice = nan(128,128,160,10);
ii = 1;
excelRows = 2:11;
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = strcat(miceName,'-',runInfo.mouseName);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    gridLaser_mice(:,:,:,ii)= gridLaser_mouse;
    ii = ii+1;
end
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridLaser_mice.mat'),'gridLaser_mice')


%Find the maximum of each of the laser frames
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-GoodSeedsNew.mat'),'GoodSeedsidx_new_mice')
seedLocation = nan(2,10,160);
seedLocation_mice = nan(2,160);
for ii = 1:160
    if GoodSeedsidx_new_mice(ii)
        for jj = 1:10
            tmp=gridLaser_mice(:,:,ii,jj);
            [~,I] = max(tmp(:));
            [row,col] = ind2sub([128 128],I);
            seedLocation(1,jj,ii) = row;
            seedLocation(2,jj,ii) = col;
        end
        seedLocation_mice(1,ii) = mean(seedLocation(1,:,ii),2);
        seedLocation_mice(2,ii)= mean(seedLocation(2,:,ii),2);
    end
    save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
end

% find index to sort the matrix in the order of functional regions
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
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
seedLocation_mice_valid_sorted = seedLocation_mice_valid(:,I);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-Atlas.mat'),'atlasIndx_valid_sorted','I','atlasIndx_valid')
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice_valid','seedLocation_mice_valid_sorted','-append')

%create sorted seed location
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end)),'-GoodSeedsNew.mat')
colors = {'r','g','b','w'};
ll = 1;
for excelRow = 5:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    seedLocation_mouse = nan(2,160);
    seedLocation_mouse_valid = nan(2,79);
    seedLocation_mouse_R = nan(2,160);
    seedLocation_mouse_valid_R = nan(2,79);
    jj = 1;
    for ii = 1:160
        if GoodSeedsidx_new_mice(ii)
            temp = gridLaser_mouse(:,:,ii,1);
            [~,I_temp] = max(temp(:));
            [row,col] = ind2sub([128 128],I_temp);
            
            seedLocation_mouse(1,ii) = row;
            seedLocation_mouse(2,ii) = col;
            seedLocation_mouse_valid(1,jj) = row;
            seedLocation_mouse_valid(2,jj) = col;
            
            seedLocation_mouse_R(1,ii) = row;
            seedLocation_mouse_R(2,ii) = 128-col+1;
            seedLocation_mouse_valid_R(1,jj) = row;
            seedLocation_mouse_valid_R(2,jj) = 128-col+1;
            jj = jj+1;
        end
    end
    seedLocation_mouse_valid_sorted = seedLocation_mouse_valid(:,I);
    seedLocation_mouse_valid_sorted_R = seedLocation_mouse_valid_R(:,I);
    for kk = 1:79
        hold on
        scatter(seedLocation_mouse_valid_sorted(2,kk),...
            seedLocation_mouse_valid_sorted(1,kk),colors{ll})
    end
    for kk = 1:79
        hold on
        scatter(seedLocation_mouse_valid_sorted_R(2,kk),...
            seedLocation_mouse_valid_sorted_R(1,kk),colors{ll})
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),...
        'seedLocation_mouse','seedLocation_mouse_valid','seedLocation_mouse_valid_sorted',...
        'seedLocation_mouse_R','seedLocation_mouse_valid_R','seedLocation_mouse_valid_sorted_R')
    ll = ll+1;
end

% create time trace for each seed
for excelRow = 5:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse','seedLocation_mouse_R')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    gridEvokeTimeTrace_jRGECO1a_L = nan(runInfo.samplingRate*runInfo.blockLen,160);
    gridEvokeTimeTrace_jRGECO1a_R = nan(runInfo.samplingRate*runInfo.blockLen,160);
    
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
        AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
        numBlock = size(AvgMovie_jRGECO1a,4);
        kk = 1;
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                x1 = seedLocation_mouse(2,m(jj));
                y1 = seedLocation_mouse(1,m(jj));
                [X,Y] = meshgrid(1:128,1:128);
                radius = 3;
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
                ROI = ROI(:);
                movie_jRGECO1a = reshape(movie_jRGECO1a,[],size(movie_jRGECO1a,3));
                gridEvokeTimeTrace_jRGECO1a_L(:,m(jj)) = squeeze(mean(movie_jRGECO1a(ROI,:)));
                
                x1 = seedLocation_mouse_R(2,m(jj));
                y1 = seedLocation_mouse_R(1,m(jj));
                [X,Y] = meshgrid(1:128,1:128);
                radius = 3;
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
                ROI = ROI(:);
                movie_jRGECO1a = reshape(movie_jRGECO1a,[],size(movie_jRGECO1a,3));
                gridEvokeTimeTrace_jRGECO1a_R(:,m(jj)) = squeeze(mean(movie_jRGECO1a(ROI,:)));
                kk = kk+1;
            end
            jj = jj+1;
        end
    end
    gridEvokeTimeTrace_jRGECO1a_valid_L = gridEvokeTimeTrace_jRGECO1a_L;
    gridEvokeTimeTrace_jRGECO1a_valid_L(:,logical(1-GoodSeedsidx_new_mice)) = [];
    gridEvokeTimeTrace_jRGECO1a_valid_L_sorted = gridEvokeTimeTrace_jRGECO1a_valid_L(:,I);
    
    gridEvokeTimeTrace_jRGECO1a_valid_R = gridEvokeTimeTrace_jRGECO1a_R;
    gridEvokeTimeTrace_jRGECO1a_valid_R(:,logical(1-GoodSeedsidx_new_mice)) = [];
    gridEvokeTimeTrace_jRGECO1a_valid_R_sorted = gridEvokeTimeTrace_jRGECO1a_valid_R(:,I);
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),...
        'gridEvokeTimeTrace_jRGECO1a_L','gridEvokeTimeTrace_jRGECO1a_valid_L','gridEvokeTimeTrace_jRGECO1a_valid_L_sorted',...
        'gridEvokeTimeTrace_jRGECO1a_R','gridEvokeTimeTrace_jRGECO1a_valid_R','gridEvokeTimeTrace_jRGECO1a_valid_R_sorted')
end

%Generate EC matrix
ECMatrix_calcium_mice_LR_sorted = nan(79,79*2,10);
numMouse = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium'),...
        'gridEvokeTimeTrace_jRGECO1a_valid_L_sorted','gridEvokeTimeTrace_jRGECO1a_valid_R_sorted')
    ECMatrix_calcium_R_sorted = nan(79);
    ECMatrix_calcium_L_sorted = nan(79);
    ECMatrix_calcium_LR_sorted = nan(79,79*2);
    for kk = 1:79
        for ll = 1:79
            ECMatrix_calcium_R_sorted(kk,ll) = corr(gridEvokeTimeTrace_jRGECO1a_valid_L_sorted(:,kk),...
                gridEvokeTimeTrace_jRGECO1a_valid_R_sorted(:,ll));
            ECMatrix_calcium_L_sorted(kk,ll) = corr(gridEvokeTimeTrace_jRGECO1a_valid_L_sorted(:,kk),...
                gridEvokeTimeTrace_jRGECO1a_valid_L_sorted(:,ll));
        end
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),...
        'ECMatrix_calcium_L_sorted','ECMatrix_calcium_R_sorted','-append')
    ECMatrix_calcium_LR_sorted(:,1:79) = ECMatrix_calcium_L_sorted;
    ECMatrix_calcium_LR_sorted(:,80:end) = ECMatrix_calcium_R_sorted;
    
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMatrix-Calcium'),...
        'ECMatrix_calcium_L_sorted','ECMatrix_calcium_R_sorted','ECMatrix_calcium_LR_sorted','-append')
    
    ECMatrix_calcium_mice_LR_sorted(:,1:79,numMouse) = atanh(ECMatrix_calcium_L_sorted);
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
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-ECMatrix.mat'),...
    'ECMatrix_calcium_mice_LR_sorted')


load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-Atlas.mat'), 'atlasIndx_valid_sorted')
for ii = 1:79
    ECMatrix_calcium_mice_LR_sorted(ii,ii) = 0;
    ECMatrix_calcium_mice_LR_sorted(ii,ii+79) = 0;
end
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_calcium_mice_LR_sorted,[-0.8 0.8]);
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
ax.GridAlpha = 1;
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-ECMatrix-Calcium-LR.png'))
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-ECMatrix-Calcium-LR.fig')


