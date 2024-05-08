clear all;close all;
% need ProcOISRGECOGrid to process the raw data.

%% Get Run and System Info
load('W:\220210\220210-m.mat')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
[refseeds, ~]=GetReferenceGridSeeds;
excelRows = 2:11;
%% Average movies across runs for each mouse without gsr for calcium
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    [row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
    runNum=start_ind_mouse';
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    for ii = 1:totalSubFileNum
        
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        numBlocks = size(laserFrames_cam1,3);
        AvgMovie_jRGECO1a_NoGSR = [];
        for runInd = 1:length(runsInfo)
            runInfo = runsInfo(runInd);
            load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat'),'xform_datafluorCorr')
            AvgMovie_jRGECO1a_NoGSR = cat(4,AvgMovie_jRGECO1a_NoGSR,xform_datafluorCorr);
            clear xform_datafluorCorr
        end
        AvgMovie_jRGECO1a_NoGSR = mean(AvgMovie_jRGECO1a_NoGSR,4);
        save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie_NoGSR.mat'),'AvgMovie_jRGECO1a_NoGSR','-v7.3')
        
    end
end


%% Average movies across runs for each mouse without gsr for HbT
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    [row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
    runNum=start_ind_mouse';
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(runInfo.saveMaskFile,'xform_isbrain')
    for ii = 1:totalSubFileNum
        
        load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
        numBlocks = size(laserFrames_cam1,3);
        AvgMovie_HbT_NoGSR = [];
        for runInd = 1:length(runsInfo)
            runInfo = runsInfo(runInd);
            load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-datahb.mat'),'xform_datahb')
            HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:));
            AvgMovie_HbT_NoGSR = cat(4,AvgMovie_HbT_NoGSR,HbT);
            clear xform_datahb
        end
        AvgMovie_HbT_NoGSR = mean(AvgMovie_HbT_NoGSR,4);
        save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgHbTMovie_NoGSR.mat'),'AvgMovie_HbT_NoGSR','-v7.3')
        clear AvgMovie_HbT_NoGSR
    end
end

%% put AvgMovie_jRGECO1a_NoGSR at right order for each mouse
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    GoodSeedsidx_new = GoodSeedsidx;
    AvgMovie_jRGECO1a_NoGSR_ordered = nan(128,128,runInfo.samplingRate*runInfo.blockLen,160);
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie_NoGSR.mat'),'AvgMovie_jRGECO1a_NoGSR')
        AvgMovie_jRGECO1a_NoGSR = reshape(AvgMovie_jRGECO1a_NoGSR,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
        numBlock = size(AvgMovie_jRGECO1a_NoGSR,4);
        kk = 1;
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                laser_location = gridLaser_mouse(:,:,m(jj));
                [M,~] = max(laser_location,[],'all','linear');
                if M < 10000 %|| GoodSeedsidx_shared(m(jj)) ==0
                    GoodSeedsidx_new(m(jj)) = 0;
                    disp([runInfo.mouseName,'#' num2str(m(jj)) ])
                else
                    AvgMovie_jRGECO1a_NoGSR_ordered(:,:,:,m(jj)) = AvgMovie_jRGECO1a_NoGSR(:,:,:,kk);
                    clear AvgMovie_jRGECO1a_NoGSR
                end
                kk = kk+1;
            end
            jj = jj+1;
        end
        
    end
%     for ll = 1:160
%         imagesc(mean(AvgMovie_jRGECO1a_NoGSR_ordered(:,:,101:200,ll),3))
%         pause
%     end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-CalciumMovieOrdered.mat'),'AvgMovie_jRGECO1a_NoGSR_ordered','-v7.3')
    clear AvgMovie_jRGECO1a_NoGSR_ordered
    save(runInfo.saveMaskFile,'GoodSeedsidx_new','-append')
end



%% put AvgMovie_HbT_NoGSR at right order
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    AvgMovie_HbT_NoGSR_ordered = nan(128,128,runInfo.samplingRate*runInfo.blockLen,160);
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgHbTMovie_NoGSR.mat'),'AvgMovie_HbT_NoGSR')
        AvgMovie_HbT_NoGSR = reshape(AvgMovie_HbT_NoGSR,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
        numBlock = size(AvgMovie_HbT_NoGSR,4);
        kk = 1;
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1
                laser_location = gridLaser_mouse(:,:,m(jj));
                [M,~] = max(laser_location,[],'all','linear');
                if M < 10000 %|| GoodSeedsidx_shared(m(jj)) ==0
                    disp([runInfo.mouseName,'#' num2str(m(jj)) ])
                else
                    AvgMovie_HbT_NoGSR_ordered(:,:,:,m(jj)) = AvgMovie_HbT_NoGSR(:,:,:,kk);
                    clear AvgMovie_HbT_NoGSR
                end
                kk = kk+1;
            end
            jj = jj+1;
        end
        
    end
%     for ll = 1:160
%         imagesc(mean(AvgMovie_HbT_NoGSR_ordered(:,:,101:200,ll),3))
%         pause
%     end
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-HbTMovieOrdered.mat'),'AvgMovie_HbT_NoGSR_ordered','-v7.3')
    clear AvgMovie_HbT_NoGSR_ordered

end

%% save the movie averaged across mice for each site
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = 2:11;
%AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites = nan(128,128,600,160);
for ii = 1:160
    AvgMovie_jRGECO1a_NoGSR_ordered_mice= nan(128,128,600,length(excelRows));
    jj = 1;
    for excelRow = excelRows
        runsInfo = parseRuns_xw(excelFile,excelRow);
        runInfo = runsInfo(1);
        load(strcat(runInfo.saveFilePrefix(1:end-6),'-CalciumMovieOrdered.mat'),'AvgMovie_jRGECO1a_NoGSR_ordered') 
        AvgMovie_jRGECO1a_NoGSR_ordered_mice(:,:,:,jj) = AvgMovie_jRGECO1a_NoGSR_ordered(:,:,:,ii);
        clear AvgMovie_jRGECO1a_NoGSR_ordered
        jj = jj+1;
    end
    AvgMovie_jRGECO1a_NoGSR_ordered_mice = nanmean(AvgMovie_jRGECO1a_NoGSR_ordered_mice,4);
    %AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites(:,:,:,ii) = AvgMovie_jRGECO1a_NoGSR_ordered_mice;
    clear AvgMovie_jRGECO1a_NoGSR_ordered_mice
end
miceName = [];
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    miceName = [miceName,'-', runInfo.mouseName];
end
miceName = miceName(2:end);
save(strcat('X:\PVChR2-Thy1RGECO\cat\',miceName,'-AvgMovie-jRGECO1a-NoGSR-ordered.mat','AvgMovie_jRGECO1a_NoGSR_ordered_mice_allsites'))