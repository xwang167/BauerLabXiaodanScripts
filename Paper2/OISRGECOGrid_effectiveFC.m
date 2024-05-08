clear all;close all;clc
excelFile = "X:\Paper3\PilotStudyComparison\ExcelSheet\PVChR2_Group1.xlsx";
excelRows = [23,26];
catDir = "W:\PV Mapping After Stroke\PV\cat\";
excelData = readtable(excelFile);
groupLabel = excelData{excelRows,'Group'};

% check if the mice from the same group
for ii = 2:length(groupLabel{1})
    if ~strcmp(groupLabel{1},groupLabel{1})
        error('Mice from different groups are combined!')
    end
end
% load('W:\220210\220210-m.mat')
 load('AtlasandIsbrain.mat','xform_WL')
 load('Y:\220210\220210-m.mat')
 xform_isbrain_mice = 1;
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    load(runsInfo(1).saveMaskFile,'xform_isbrain')
    xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
end
 xform_isbrain_mice = xform_isbrain_mice & fliplr(xform_isbrain_mice);

GoodSeedsidx_shared = 1;
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    load(runsInfo(1).saveMaskFile,'GoodSeedsidx','xform_isbrain')
    GoodSeedsidx_shared = GoodSeedsidx_shared.*GoodSeedsidx;
end
%% Calcium EC for each mouse
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    GoodSeedsidx_new = GoodSeedsidx;
    gridEC_jRGECO1a = nan(128,128,160);
    gridevokeTimeTrace_jRGECO1a = nan(runInfo.samplingRate*runInfo.blockLen,160);
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
                if M <1000 || xform_isbrain_mice(row,col) == 0 %|| GoodSeedsidx_shared(m(jj)) ==0
                    GoodSeedsidx_new(m(jj)) = 0;
                    disp([runInfo.mouseName,'#' num2str(m(jj)) ])
                else
                    movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
                    [gridEC_jRGECO1a(:,:,m(jj)),gridevokeTimeTrace_jRGECO1a(:,m(jj))] = seedFCMap_xw(movie_jRGECO1a,logical(ROI));
                    figure
                    colormap jet
                    subplot(1,2,1)
                    imagesc(gridEC_jRGECO1a(:,:,m(jj)),[-1 1])
                    axis image off
                    colorbar
                    hold on
                    contour(ROI,'w')
                    hold on;
                    imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice);
                    title('Effective Connectivity')
                    subplot(1,2,2)
                    plot((1:runInfo.samplingRate*runInfo.blockLen)/runInfo.samplingRate,...
                        gridevokeTimeTrace_jRGECO1a(:,m(jj)),'m');
                    title('Evoked Time Trace')
                    sgtitle([runInfo.mouseName, ' ', 'Position #',num2str(m(jj))])
                    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace.fig'))
                    saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace.png'))
                    close all
                    %                     figure
                    %                     colormap jet
                    %                     imagesc(laser_location)
                    %                     axis image off
                    %                     colorbar
                    %                     hold on
                    %                     contour(ROI,'w')
                    %                     title(['Position #',num2str(m(jj))])
                    %                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_laserROI.fig'))
                    %                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_laserROI.png'))
                    %                     close all
                end
                kk = kk+1;
            end
            jj = jj+1;
        end

    end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEC_jRGECO1a')
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),'gridevokeTimeTrace_jRGECO1a')
    save(runInfo.saveMaskFile,'GoodSeedsidx_new','-append')

end
%% group average 
gridEC_jRGECO1a_mice = nan(128,128,160,length(excelRows));
mouseInd = 1;
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo=runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEC_jRGECO1a')
    gridEC_jRGECO1a_mice(:,:,:,mouseInd) = atanh(gridEC_jRGECO1a);
    mouseInd = mouseInd+1;
    miceName = strcat(miceName,'-',runInfo.mouseName);
end
gridEC_jRGECO1a_mice = nanmean(gridEC_jRGECO1a_mice,4);
save(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-gridEFC.mat'),'gridEC_jRGECO1a_mice')
% %
% for ii = 1:160
%     imagesc(gridEC_jRGECO1a_mice(:,:,ii),[-2 2])
%     pause
% end


%how many good seeds

GoodSeedsidx_new_mice = 1;
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo=runsInfo(1);
    load(runInfo.saveMaskFile,'GoodSeedsidx_new')
    GoodSeedsidx_new_mice = GoodSeedsidx_new_mice.*GoodSeedsidx_new;
end
save(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-GoodSeedsNew.mat'),'GoodSeedsidx_new_mice')

%how many valid frames in gridEFC
numValid = 0;
for ii = 1:160
    if ~isnan(gridEC_jRGECO1a_mice(64,64,ii))
        numValid = numValid+1;
    end
end



gridLaser_mice = nan(128,128,160,length(excelRows));
ii = 1;
for excelRow = excelRows;
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    gridLaser_mice(:,:,:,ii)= gridLaser_mouse;
    ii = ii+1;
end
save(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-gridLaser_mice.mat'),'gridLaser_mice')

%Find the maximum of each of the laser frames
load(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-GoodSeedsNew.mat'),'GoodSeedsidx_new_mice')
seedLocation = nan(2,length(excelRows),160);
seedLocation_mice = nan(2,160);
for ii = 1:160
    if GoodSeedsidx_new_mice(ii)
        for jj = 1:length(excelRows)
            tmp=gridLaser_mice(:,:,ii,jj);
            [~,I] = max(tmp(:));
            [row,col] = ind2sub([128 128],I);
            seedLocation(1,jj,ii) = row;
            seedLocation(2,jj,ii) = col;
        end
        seedLocation_mice(1,ii) = nanmean(seedLocation(1,:,ii),2);
        seedLocation_mice(2,ii)= nanmean(seedLocation(2,:,ii),2);
    end
    save(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-SeedLocation.mat'),'seedLocation_mice')
end

%% Visualization
jj = 1;
kk = 1;
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
[X,Y] = meshgrid(1:128,1:128);
 load(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-gridEFC.mat'))
 load(strcat(catDir,groupLabel{1},'-',miceName(2:end),'-SeedLocation.mat'))
for ii = 1:160
    if ~isnan(gridEC_jRGECO1a_mice(64,64,ii))
        x1 = seedLocation_mice(2,ii);
        y1 = seedLocation_mice(1,ii);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        subplot(5,8,jj)
        imagesc(gridEC_jRGECO1a_mice(:,:,ii),[-2 2])
        hold on
        contour(ROI,'w')
        hold on;
        imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice);
        title(['Position #',num2str(ii)])
        axis image off
        if jj ==40
        p = subplot(5,8,40);
        Pos = get(p,'Position');
        h = colorbar;
        ylabel(h, 'z(r)')
        set(p,'Position',Pos)
        end
        
        jj = jj+1;
        if jj==41
            sgtitle(strcat(groupLabel{1},'-',miceName(2:end),' Calcium EC -',num2str(kk)))           
            jj = 1;
            saveas(gcf,strcat(catDir,groupLabel{1},'-',miceName(2:end),'-EC-Calcium-',num2str(kk),'.png'))
            saveas(gcf,strcat(catDir,groupLabel{1},'-',miceName(2:end),'-EC-Calcium-',num2str(kk),'.fig'))
            kk = kk+1;
            figure('units','normalized','outerposition',[0 0 1 1])
            colormap jet
        end
    end
end
p = subplot(5,8,40);
Pos = get(p,'Position');
h = colorbar;
ylabel(h, 'z(r)')
set(p,'Position',Pos)
sgtitle(strcat(groupLabel{1},'-',miceName(2:end),' Calcium EC -',num2str(kk)))            
saveas(gcf,strcat(catDir,groupLabel{1},'-',miceName(2:end),'-EC-Calcium-',num2str(kk),'.png'))
saveas(gcf,strcat(catDir,groupLabel{1},'-',miceName(2:end),'-EC-Calcium-',num2str(kk),'.fig'))






















