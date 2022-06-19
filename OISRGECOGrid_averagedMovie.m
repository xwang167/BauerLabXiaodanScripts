clear all;close all;
%% Get Run and System Info
load('W:\220210\220210-m.mat')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
[refseeds, ~]=GetReferenceGridSeeds;
%% Average movies across runs for each mouse
for excelRows = 5:11
    
    runsInfo = parseRuns_xw(excelFile,excelRows);
    [row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
    runNum=start_ind_mouse';
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runInfo.saveMaskFile,'xform_isbrain')
    for ii = 1:totalSubFileNum
        if ~exist(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'file')
            load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
            numBlocks = size(laserFrames_cam1,3);
            AvgMovie_jRGECO1a = [];
            for runInd = 1:length(runsInfo)
                runInfo = runsInfo(runInd);
                load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat'),'xform_datafluorCorr')
                AvgMovie_jRGECO1a = cat(4,AvgMovie_jRGECO1a,gsr(xform_datafluorCorr,xform_isbrain));
            end
            AvgMovie_jRGECO1a = mean(AvgMovie_jRGECO1a,4);
            save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a','-v7.3')
        end
    end
end

%% Peak maps for each mouse, each site, averaged across runs
for excelRows = 5:11
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runInfo.saveMaskFile,'GoodSeedsidx','I')
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
        AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
        AvgPeakMap = squeeze(mean(AvgMovie_jRGECO1a(:,:,runInfo.samplingRate*runInfo.stimStartTime:runInfo.samplingRate*runInfo.stimEndTime,:),3));
        numBlock = size(AvgPeakMap,3);
        gridPeakMaps_jrgeco1aCorr = nan(128,128,160);
        kk = 1;
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        xform_laserFrames_cam1 = affineTransform(laserFrames_cam1,I);
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                gridPeakMaps_jrgeco1aCorr(:,:,m(jj)) = AvgPeakMap(:,:,kk);
                figure('units','normalized','outerposition',[0 0 1 1])
                colormap jet
                subplot(1,2,1)
                imagesc(gridPeakMaps_jrgeco1aCorr(:,:,m(jj))*100,[-1.5 1.5]);
                axis image off
                colorbar
                hold on
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('jRGECO1a')
                
                subplot(1,2,2)
                imagesc(xform_laserFrames_cam1(:,:,kk));
                axis image off
                colorbar
                hold on
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('xform Laser')
                sgtitle(strcat(runInfo.recDate,'-',runInfo.mouseName,'-',...
                    num2str(ii),'-',num2str(kk),'-GSR-AvgPeakMaps-Calcium'))
                saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-',num2str(kk),'-GSR-AvgPeakMaps-Calcium.fig'))
                saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-',num2str(kk),'-GSR-AvgPeakMaps-Calcium.png'))
                close all
                kk = kk+1;
            end
            jj = jj+1;
        end
        save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-GSR-AvgPeakMaps-Calcium.mat'),'gridPeakMaps_jrgeco1aCorr')
    end
end

%% collect all the peak maps for one mouse
for excelRows = 5:11
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    gridPeakMaps_jrgeco1aCorr_mouse = nan(128,128,160,totalSubFileNum);
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-GSR-AvgPeakMaps-Calcium.mat'),'gridPeakMaps_jrgeco1aCorr')
        gridPeakMaps_jrgeco1aCorr_mouse(:,:,:,ii) = gridPeakMaps_jrgeco1aCorr;
    end
    gridPeakMaps_jrgeco1aCorr_mouse = nanmean(gridPeakMaps_jrgeco1aCorr_mouse,4);
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-GSR-AvgPeakMaps-Calcium.mat'),'gridPeakMaps_jrgeco1aCorr_mouse')
end

%% store laser maps in the right order
for excelRows = 5:11
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runInfo.saveMaskFile,'GoodSeedsidx','I')
    jj = 1;
    for ii = 1:totalSubFileNum
        gridLaser = nan(128,128,160);
        kk = 1;
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        xform_laserFrames_cam1 = affineTransform(laserFrames_cam1,I);
        numBlock = size(xform_laserFrames_cam1,3);
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                gridLaser(:,:,m(jj)) = xform_laserFrames_cam1(:,:,kk);
                kk = kk+1;
            end
            jj = jj+1;
        end
        save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-xform_laser_grid.mat'),'gridLaser')
    end
end

%% collect all the laser for one mouse
for excelRows = 5:11
    runsInfo = parseRuns_xw(excelFile,excelRows);
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

% %% find shared seeds
% load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% GoodSeedsidx_shared = 1;
% load('Z:\220210\220210-m.mat')
% [refseeds, I]=GetReferenceGridSeeds;
% figure
% imagesc(xform_WL)
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'GoodSeedsidx','xform_isbrain')
%     GoodSeedsidx_shared = GoodSeedsidx_shared.*GoodSeedsidx;
%     hold on
%     contour(xform_isbrain,'k')
% end
%
%
% axis image off
% for jj = 1:160
%     if GoodSeedsidx_shared(m(jj)) == 1
%         hold on
%         scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
%     end
% end
% title('Shared Laser Sites')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\SharedLaserSites.fig')
% saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\SharedLaserSites.png')