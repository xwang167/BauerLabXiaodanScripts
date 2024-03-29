clear all;close all;
%% Get Run and System Info
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = [3:4];

runsInfo = parseRuns_xw(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';
runNum = numel(runsInfo);
load('Z:\220210\220210-m.mat')
[refseeds, I]=GetReferenceGridSeeds;
for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta refseeds m
    runInfo=runsInfo(runInd);
    load(runInfo.saveMaskFile,'GoodSeedsidx','xform_isbrain','I')
    jj = 1;
    for ii = 1:length(runInfo.rawFile)/2
        runInfo.saveHbFile = strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataHb.mat');
        load(runInfo.saveHbFile,'xform_datahb')
        runInfo.saveFluorFile = strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat');
        load(runInfo.saveFluorFile,'xform_datafluorCorr')
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        xform_laserFrames_cam1 = affineTransform(laserFrames_cam1,I);
        xform_datahb_GSR = gsr(xform_datahb,xform_isbrain);
        clear xform_datahb
        xform_datafluorCorr_GSR = gsr(xform_datafluorCorr,xform_isbrain);
        clear xform_datafluorCorr
        xform_datahb_GSR = reshape(xform_datahb_GSR,128,128,2,runInfo.blockLen*runInfo.samplingRate,[]);
        xform_datahb_GSR_on = squeeze(mean(xform_datahb_GSR(:,:,:,runInfo.stimStartTime*runInfo.samplingRate+1:runInfo.stimEndTime*runInfo.samplingRate,:),4));
        
        clear xform_datahb_GSR
        xform_datafluorCorr_GSR = reshape(xform_datafluorCorr_GSR,128,128,runInfo.blockLen*runInfo.samplingRate,[]);
        xform_datafluorCorr_GSR_on = squeeze(mean(xform_datafluorCorr_GSR(:,:,runInfo.stimStartTime*runInfo.samplingRate+1:runInfo.stimEndTime*runInfo.samplingRate,:),3));
        numBlock = size(xform_datafluorCorr_GSR,4);
        clear xform_datafluorCorr_GSR
        
        gridImage_HbO = nan(128,128,160);
        gridImage_HbR = nan(128,128,160);
        gridImage_HbT = nan(128,128,160);
        gridImage_jrgeco1aCorr = nan(128,128,160);
        kk = 1;
        while kk < numBlock+1         
            if GoodSeedsidx(m(jj)) == 1
                gridImage_HbO(:,:,m(jj)) = squeeze(xform_datahb_GSR_on(:,:,1,kk));
                gridImage_HbR(:,:,m(jj)) = squeeze(xform_datahb_GSR_on(:,:,2,kk));
                gridImage_HbT(:,:,m(jj)) = gridImage_HbO(:,:,m(jj))+gridImage_HbR(:,:,m(jj));
                gridImage_jrgeco1aCorr(:,:,m(jj)) = xform_datafluorCorr_GSR_on(:,:,kk);
                
                figure('units','normalized','outerposition',[0 0 1 1])
                colormap jet
                subplot(2,3,1)
                imagesc(gridImage_HbO(:,:,m(jj)));
                axis image off
                colorbar                            
                hold on               
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('HbO')
                
                subplot(2,3,2)
                imagesc(gridImage_HbR(:,:,m(jj)));
                axis image off
                colorbar                            
                hold on               
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('HbR')
                
                subplot(2,3,3)
                imagesc(gridImage_HbT(:,:,m(jj)));
                axis image off
                colorbar                            
                hold on               
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('HbT')
                
                subplot(2,3,4)
                imagesc(gridImage_jrgeco1aCorr(:,:,m(jj)));
                axis image off
                colorbar                            
                hold on               
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('jRGECO1a')
                
                subplot(2,3,5)
                imagesc(xform_laserFrames_cam1(:,:,kk));
                axis image off
                colorbar                            
                hold on               
                scatter(refseeds(m(jj),1),refseeds(m(jj),2),'w','LineWidth',2)
                title('xform Laser')
                suptitle(strcat(runInfo.recDate,'-',runInfo.mouseName,'-',...
                  runInfo.session,num2str(runInfo.run),'-',num2str(ii),'-',num2str(kk),'-GSR-PeakMaps'))
                saveas(gcf,strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-',num2str(kk),'-GSR-PeakMaps.fig'))
                saveas(gcf,strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-',num2str(kk),'-GSR-PeakMaps.png'))
                kk = kk+1;
            end
            jj = jj+1;
        end
    end
end