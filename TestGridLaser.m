load('W:\220210\220210-m.mat')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
[refseeds, ~]=GetReferenceGridSeeds;


for excelRows = 11
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
for excelRows = 11
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


GoodSeedsidx = zeros(160,1);
for ii = 1:160
    if xform_isbrain(refseeds(m(ii),1),refseeds(m(ii),2))==1
        GoodSeedsidx(ii) = 1;
    end        
end