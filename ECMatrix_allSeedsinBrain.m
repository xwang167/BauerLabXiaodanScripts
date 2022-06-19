% clear all;close all;clc
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% load('Z:\220210\220210-m.mat')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
load('W:\220210\220210-m.mat')
xform_isbrain_union = zeros(128,128,10);
numMouse = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    load(runsInfo(1).saveMaskFile,'xform_isbrain')
    xform_isbrain_union(:,:,numMouse) = xform_isbrain;
        figure;imagesc(xform_isbrain)
    numMouse = numMouse+1;
end
xform_isbrain_union = nanmean(xform_isbrain_union,3);
xform_isbrain_union(xform_isbrain_union>0) = 1;
xform_isbrain_union = xform_isbrain_union & fliplr(xform_isbrain_union);

%%
excelRows = 2:11;
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo=runsInfo(1);
    miceName = strcat(miceName,'-',runInfo.mouseName);
end
%%
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runsInfo(1).saveMaskFile,'xform_isbrain')
    xform_isbrain = xform_isbrain & fliplr(xform_isbrain);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    GoodSeedsidx_FOV = GoodSeedsidx;
    gridEC_jRGECO1a_FOV = nan(128,128,160);
    gridevokeTimeTrace_jRGECO1a_FOV = nan(runInfo.samplingRate*runInfo.blockLen,160);
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
        AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
        numBlock = size(AvgMovie_jRGECO1a,4);
        kk = 1;
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                laser_location = gridLaser_mouse(:,:,m(jj));
                [M,I_1] = max(laser_location,[],'all','linear');
                [row,col] = ind2sub([128 128],I_1);
                x1 = col;
                y1 = row;
                [X,Y] = meshgrid(1:128,1:128);
                radius = 3;
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                if M < 10000 || xform_isbrain(row,col) == 0
                    GoodSeedsidx_FOV(m(jj)) = 0;
                    disp([runInfo.mouseName,'#' num2str(m(jj)) ])
                else
                    movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
                    [gridEC_jRGECO1a_FOV(:,:,m(jj)),gridevokeTimeTrace_jRGECO1a_FOV(:,m(jj))] = seedFCMap_xw(movie_jRGECO1a,logical(ROI));
                    figure
                    colormap jet
                    subplot(1,2,1)
                    imagesc(gridEC_jRGECO1a_FOV(:,:,m(jj)),[-1 1])
                    axis image off
                    colorbar
                    hold on
                    contour(ROI,'w')
                    hold on;
                    imagesc(xform_WL,'AlphaData',1-xform_isbrain);
                    title('Effective Connectivity')
                    subplot(1,2,2)
                    plot((1:runInfo.samplingRate*runInfo.blockLen)/runInfo.samplingRate,...
                        gridevokeTimeTrace_jRGECO1a_FOV(:,m(jj)),'m');
                    title('Evoked Time Trace')
                    sgtitle([runInfo.mouseName, ' ', 'Position #',num2str(m(jj))])
                    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace_FOV.fig'))
                    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace_FOV.png'))
                    close all
                    
                end
                kk = kk+1;
            end
            jj = jj+1;
        end
        
    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEC_jRGECO1a_FOV','-append')
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),'gridevokeTimeTrace_jRGECO1a_FOV','-append')
    save(runInfo.saveMaskFile,'GoodSeedsidx_FOV','-append')
    
end

%% EC averaged across mice
gridEC_jRGECO1a_mice_FOV = nan(128,128,160,10);
mouseInd = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo=runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEC_jRGECO1a_FOV')
    gridEC_jRGECO1a_mice_FOV(:,:,:,mouseInd) = atanh(gridEC_jRGECO1a_FOV);
    mouseInd = mouseInd+1;
end

gridEC_jRGECO1a_mice_FOV = nanmean(gridEC_jRGECO1a_mice_FOV,4);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')

% for ii = 1:160
%     imagesc(gridEC_jRGECO1a_mice_FOV(:,:,ii),[-2 2])
%     pause
% end

%% how many seeds inside union of xform_isbrains
GoodSeedsidx_FOV_mice =nan(160,10);
numMouse = 1;
for excelRow = 2:11
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo=runsInfo(1);
    load(runInfo.saveMaskFile,'GoodSeedsidx_FOV')
    GoodSeedsidx_FOV_mice(:,numMouse) = GoodSeedsidx_FOV;
    numMouse = numMouse+1;
end
GoodSeedsidx_FOV_mice = nanmean(GoodSeedsidx_FOV_mice,2);
GoodSeedsidx_FOV_mice(GoodSeedsidx_FOV_mice>0)=1;

save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-GoodSeedsNew.mat'),'GoodSeedsidx_FOV_mice')

%how many valid frames in gridEC
% load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')
% numValid = 0;
% for ii = 1:160
%     if ~isnan(gridEC_jRGECO1a_mice_FOV(64,64,ii))
%         numValid = numValid+1;
%     end
% end


%% Averaged Seed Location
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridLaser_mice.mat'),'gridLaser_mice')
seedLocation_mice_FOV = nan(2,160);
excelRows = 2:11;
for ii = 1:160
    row_mice = nan(1,length(excelRows));
    col_mice = nan(1,length(excelRows));
    for jj = 1: length(excelRows)
        if ~isnan(gridLaser_mice(64,64,ii,jj))
            [Maximum,loc] = max(gridLaser_mice(:,:,ii,jj),[],'all','linear');
            if Maximum>10000
                [row_mice(jj),col_mice(jj)] = ind2sub([128 128],loc);
            end
        end
    end
    seedLocation_mice_FOV(1,ii) = nanmean(row_mice);
    seedLocation_mice_FOV(2,ii)= nanmean(col_mice);
end
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice_FOV','-append')

%% EC Map
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice_FOV')
jj = 1;
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
[X,Y] = meshgrid(1:128,1:128);
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridEC.mat'))
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'))
num = 1;
for ii = 1:160
    if ~isnan(gridEC_jRGECO1a_mice_FOV(64,64,ii))
        x1 = seedLocation_mice_FOV(2,ii);
        y1 = seedLocation_mice_FOV(1,ii);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        subplot(5,8,jj)
        imagesc(gridEC_jRGECO1a_mice_FOV(:,:,ii),[-2 2])
        hold on
        contour(ROI,'w')
        hold on;
        imagesc(xform_WL,'AlphaData',logical(1-xform_isbrain_union));
        title(['Position #',num2str(ii)])
        axis image off
        jj = jj+1;
        if jj == 41
            p = subplot(5,8,40);
            Pos = get(p,'Position');
            h = colorbar;
            ylabel(h, 'z(r)')
            set(p,'Position',Pos)
            sgtitle(strcat(miceName(2:end), 'Calcium EC -',num2str(num)))
            jj = 1;
            saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-EC-Calcium-',num2str(num),'.png'))
            saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-EC-Calcium-',num2str(num),'.fig'))
            num = num+1;
            figure('units','normalized','outerposition',[0 0 1 1])
            colormap jet
        end
    end
end
p = subplot(5,8,jj-1);
Pos = get(p,'Position');
h = colorbar;
ylabel(h, 'z(r)')
set(p,'Position',Pos)
sgtitle(strcat(miceName(2:end), 'Calcium EC -',num2str(num)))
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-EC-Calcium-',num2str(num),'.png'))
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-EC-Calcium-',num2str(num),'.fig'))



%% find index to sort the matrix in the order of functional regions
load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice_FOV')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat')
seed_frame = find(isnan(seedLocation_mice_FOV(1,:)));
gridEC_frame = find(isnan(squeeze(gridEC_jRGECO1a_mice_FOV(64,64,:))));
badFrames = union(seed_frame,gridEC_frame);

atlasIndx = nan(1,160);
seedLocation_mice_valid_FOV = nan(2,160);
for ii = 1:160
    if ~ismember(ii,badFrames)
        seedLocation_mice_valid_FOV(:,ii) = round(seedLocation_mice_FOV(:,ii));
        atlasIndx(ii) = AtlasSeedsFilled(seedLocation_mice_valid_FOV(1,ii),...
           seedLocation_mice_valid_FOV(2,ii));
        if atlasIndx(ii)==0
          atlasIndx(ii) = NaN;
        end
    end
end

atlas_Frame = find(isnan(atlasIndx));
badFrames = union(badFrames,atlas_Frame);
atlasIndx_valid_FOV = atlasIndx;
atlasIndx_valid_FOV(badFrames) = [];
seedLocation_mice_valid_FOV(:,badFrames) = [];


[atlasIndx_valid_sorted_FOV,I_FOV] = sort(atlasIndx_valid_FOV);

load(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridEC.mat'),'gridEC_jRGECO1a_mice_FOV')
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";

gridEC_jRGECO1a_mice_valid_FOV = gridEC_jRGECO1a_mice_FOV;
gridEC_jRGECO1a_mice_valid_FOV(:,:,badFrames)=[];
gridEC_jRGECO1a_mice_valid_sorted_FOV = gridEC_jRGECO1a_mice_valid_FOV(:,:,I_FOV);


save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-gridEC.mat'),...
    'gridEC_jRGECO1a_mice_valid_FOV','gridEC_jRGECO1a_mice_valid_sorted_FOV','-append')

seedLocation_mice_valid_sorted_FOV = seedLocation_mice_valid_FOV(:,I_FOV);

save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-Atlas.mat'),'atlasIndx_valid_sorted_FOV','I_FOV','atlasIndx_valid_FOV')
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice_valid_FOV','seedLocation_mice_valid_sorted_FOV','-append')
%







%%
seedLocation_mice_valid_sorted_R_FOV = nan(2,length(seedLocation_mice_valid_sorted_FOV));
seedLocation_mice_valid_sorted_R_FOV(1,:) = seedLocation_mice_valid_sorted_FOV(1,:);
seedLocation_mice_valid_sorted_R_FOV(2,:) = 129-seedLocation_mice_valid_sorted_FOV(2,:);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-SeedLocation.mat'),...
    'seedLocation_mice_valid_sorted_R_FOV','-append')

[X,Y] = meshgrid(1:128,1:128);
ECMatrix_mice_valid_sorted_L_FOV = nan(length(seedLocation_mice_valid_sorted_FOV),length(seedLocation_mice_valid_sorted_FOV)); %95
ECMatrix_mice_valid_sorted_R_FOV = nan(length(seedLocation_mice_valid_sorted_FOV),length(seedLocation_mice_valid_sorted_FOV));

for ii = 1:length(seedLocation_mice_valid_sorted_FOV)
    map = gridEC_jRGECO1a_mice_valid_sorted_FOV(:,:,ii);
    for jj = 1:length(seedLocation_mice_valid_sorted_FOV)
        x1 = seedLocation_mice_valid_sorted_FOV(2,jj);
        y1 = seedLocation_mice_valid_sorted_FOV(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = reshape(map,128*128,[]);
        ECMatrix_mice_valid_sorted_L_FOV(ii,jj) = nanmean(map(ROI));
    end
end

%%
for ii = 1:length(seedLocation_mice_valid_sorted_FOV)
    map = gridEC_jRGECO1a_mice_valid_sorted_FOV(:,:,ii);
    for jj = 1:length(seedLocation_mice_valid_sorted_FOV)
        x1 = seedLocation_mice_valid_sorted_R_FOV(2,jj);
        y1 = seedLocation_mice_valid_sorted_R_FOV(1,jj);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = reshape(map,128*128,[]);
        ECMatrix_mice_valid_sorted_R_FOV(ii,jj) = nanmean(map(ROI));
    end
end
ECMatrix_mice_valid_sorted_LR_FOV = nan(length(seedLocation_mice_valid_sorted_FOV),length(seedLocation_mice_valid_sorted_FOV)*2);
ECMatrix_mice_valid_sorted_LR_FOV(:,1:length(seedLocation_mice_valid_sorted_FOV)) = ECMatrix_mice_valid_sorted_L_FOV;
ECMatrix_mice_valid_sorted_LR_FOV(:,length(seedLocation_mice_valid_sorted_FOV)+1:end) = ECMatrix_mice_valid_sorted_R_FOV;
%%
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
imagesc(ECMatrix_mice_valid_sorted_LR_FOV,[-1.4 1.4]);
title([miceName(2:end),'-Calcium-LR'])
h = colorbar;
ylabel(h, 'z(r)','fontsize',14,'FontWeight','bold')
set(h,'XTick',[-1.4 0 1.4])
axis image
[C, ia, ic] = unique(atlasIndx_valid_sorted_FOV);
seednames_sorted = cell(1,length(C)*2);
for ii = 1:length(C)
    seednames_sorted{ii} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
    seednames_sorted{ii+length(C)} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)
xticks([ia'-0.5 ia'-0.5+size(ECMatrix_mice_valid_sorted_L_FOV,1)])
xticklabels(seednames_sorted)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','bold')
grid on
ax = gca;
ax.GridAlpha = 1;
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-Calcium-LR-FOV.png'))
saveas(gcf,strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-ECMatrix-Calcium-LR-FOV.fig'))
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName(2:end),'-ECMatrix.mat'),...
    'ECMatrix_mice_valid_sorted_LR_FOV')





figure
imagesc(atlasIndx_valid_sorted_FOV')
colormap hsv
axis image
[C, ia, ic] = unique(atlasIndx_valid_sorted_FOV);
seednames_sorted = cell(1,length(C)*2);
for ii = 1:length(C)
seednames_sorted{ii} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
seednames_sorted{ii+length(C)*2} = seednames{atlasIndx_valid_sorted_FOV(ia(ii))};
end
yticks(ia-0.5)
yticklabels(seednames_sorted)















