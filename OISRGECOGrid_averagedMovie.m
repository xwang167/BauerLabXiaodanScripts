clear all;close all;
%% Get Run and System Info
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('Z:\220210\220210-m.mat')
[refseeds, ~]=GetReferenceGridSeeds;
for excelRows = 2
    
    runsInfo = parseRuns_xw(excelFile,excelRows);
    [row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
    runNum=start_ind_mouse';
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runInfo.saveMaskFile,'xform_isbrain')
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        numBlocks = size(laserFrames_cam1,3);
        AvgMovie_jRGECO1a = zeros(128,128,runInfo.samplingRate*runInfo.blockLen*numBlocks,3);
        for runInd = 1:3
            runInfo = runsInfo(runInd);
            load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat'),'xform_datafluorCorr')
            AvgMovie_jRGECO1a(:,:,:,runInd) = gsr(xform_datafluorCorr,xform_isbrain);
        end
        AvgMovie_jRGECO1a = mean(AvgMovie_jRGECO1a,4);
        save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a','-v7.3')
    end
end

for excelRows = 2    
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
                suptitle(strcat(runInfo.recDate,'-',runInfo.mouseName,'-',...
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


%% find shared seeds
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
GoodSeedsidx_shared = 1;
load('Z:\220210\220210-m.mat')
[refseeds, I]=GetReferenceGridSeeds;
figure
imagesc(xform_WL)
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    load(runsInfo(1).saveMaskFile,'GoodSeedsidx','xform_isbrain')
    GoodSeedsidx_shared = GoodSeedsidx_shared.*GoodSeedsidx;
    hold on
    contour(xform_isbrain,'k')
end


axis image off
for jj = 1:160    
    if GoodSeedsidx_shared(m(jj)) == 1
        hold on
        scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)        
    end
end
title('Shared Laser Sites')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\SharedLaserSites.fig')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\SharedLaserSites.png')