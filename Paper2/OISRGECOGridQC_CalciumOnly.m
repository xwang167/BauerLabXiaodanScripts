clear all;close all;
%% Get Run and System Info
excelFile="X:\Paper2\Hemi_Thy1_jRGECO1a_leftGrid\Control_Hemi_Thy1_jRGECO1a_leftGrid.xlsx";
excelRows = 3;

runsInfo = parseRuns_xw(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!

runNum = numel(runsInfo);
load('Y:\220210\220210-m.mat')
[refseeds, I]=GetReferenceGridSeeds;
for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta refseeds m
    runInfo=runsInfo(runInd);
    load(runInfo.saveMaskFile,'GoodSeedsidx','xform_isbrain','I')
    jj = 1;
    for ii = 1:length(runInfo.rawFile)/2

        runInfo.saveFluorFile = strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat');
        load(runInfo.saveFluorFile,'xform_datafluorCorr')
        xform_datafluorCorr_GSR = gsr(xform_datafluorCorr,xform_isbrain);
        clear xform_datafluorCorr
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        xform_laserFrames_cam1 = affineTransform(laserFrames_cam1,I);
        xform_datafluorCorr_GSR = reshape(xform_datafluorCorr_GSR,128,128,runInfo.blockLen*runInfo.samplingRate,[]);
        xform_datafluorCorr_GSR_on = squeeze(mean(xform_datafluorCorr_GSR(:,:,runInfo.stimStartTime*runInfo.samplingRate+1:runInfo.stimEndTime*runInfo.samplingRate,:),3));
        numBlock = size(xform_datafluorCorr_GSR,4);
        clear xform_datafluorCorr_GSR       
        gridImage_jrgeco1aCorr = nan(128,128,160);
        kk = 1;
        while kk < numBlock+1         
            if GoodSeedsidx(m(jj)) == 1  
                gridImage_jrgeco1aCorr(:,:,m(jj)) = xform_datafluorCorr_GSR_on(:,:,kk);
                
                figure('units','normalized','outerposition',[0 0 1 1])
                colormap jet                            
                subplot(1,2,1)
                imagesc(gridImage_jrgeco1aCorr(:,:,m(jj))*100,[-1.5 1.5]);
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
                  runInfo.session,num2str(runInfo.run),'-',num2str(ii),'-',num2str(kk),'-GSR-PeakMaps-Calcium'))
                saveas(gcf,strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-',num2str(kk),'-GSR-PeakMaps-Calcium.fig'))
                saveas(gcf,strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-',num2str(kk),'-GSR-PeakMaps-Calcium.png'))
                close all
                kk = kk+1;
            end
            jj = jj+1;
        end
    end
        save(strcat(runInfo.saveFilePrefix,'_GSR_PeakMaps.mat'),'gridImage_jrgeco1aCorr')
end