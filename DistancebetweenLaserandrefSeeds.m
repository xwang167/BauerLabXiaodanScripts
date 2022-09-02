load('W:\220210\220210-m.mat')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
excelRows = 2:11;
distance = nan(length(excelRows),160);
GoodSeedsidx_NoLaserOutFOV = zeros(1,160);
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    [refseeds, ~]=GetReferenceGridSeeds;
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    GoodSeedsidx_NoLaserOutFOV = zeros(1,160);
    for ii = 1:160
        if GoodSeedsidx(ii) ==1
            tmp=gridLaser_mouse(:,:,ii);          
            [maximum,I] = max(tmp(:));
            if maximum>10000
                GoodSeedsidx_NoLaserOutFOV(ii) = 1;
                [row,col] = ind2sub([128 128],I);
                distance(excelRow-1,ii) = sqrt((row-refseeds(ii,2))^2 + (col-refseeds(ii,1))^2);
            end
        end
        
    end
    save(runInfo.saveMaskFile,'GoodSeedsidx_NoLaserOutFOV','-append')
end
distance_mean = nanmean(distance);
distance_mean = distance_mean/128*10;

figure
[refseeds, ~]=GetReferenceGridSeeds;
imagesc(xform_WL(:,1:64,:));
hold on
for jj = 1:160
    scatter(refseeds(m(jj),1),refseeds(m(jj),2),30,distance_mean(m(jj)),'filled')
    hold on
end
colormap jet
h = colorbar;
ylabel(h, 'mm')
axis image off
title('Distance b/t actual loc and common seeds')

% excelRow = 8;
% runsInfo = parseRuns_xw(excelFile,excelRow);
% runInfo = runsInfo(1);
% load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
% 
% for ii = 1:160
%     subplot(1,2,1)
%     imagesc(gridLaser(:,:,ii));
%     hold on
%     scatter(refseeds(ii,1),refseeds(ii,2),'w','filled')
%     subplot(1,2,2)
%     imagesc(gridLaser_mouse(:,:,ii))
%     hold on
%      scatter(refseeds(ii,1),refseeds(ii,2),'w','filled')
%     disp(num2str(GoodSeedsidx(ii)))
%     title(num2str(ii))
%     pause
% end
%
%
%
%
% %% store laser maps in the right order
% for excelRows = 11
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     totalSubFileNum = length(runInfo.rawFile)/2;
%     load(runInfo.saveMaskFile,'GoodSeedsidx','I')
%     jj = 1;
%     for ii = 1:totalSubFileNum
%         gridLaser = nan(128,128,160);
%         kk = 1;
%         load(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'laserFrames_cam1')
%         xform_laserFrames_cam1 = affineTransform(laserFrames_cam1,I);
%         numBlock = size(xform_laserFrames_cam1,3);
%         while kk < numBlock+1
%             if GoodSeedsidx(m(jj)) == 1
%                 gridLaser(:,:,m(jj)) = xform_laserFrames_cam1(:,:,kk);
%                 kk = kk+1;
%             end
%             jj = jj+1;
%         end
%         save(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-xform_laser_grid.mat'),'gridLaser')
%     end
% end
%
% %% collect all the laser for one mouse
% for excelRows = 11
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     totalSubFileNum = length(runInfo.rawFile)/2;
%     gridLaser_mouse = nan(128,128,160,totalSubFileNum);
%     for ii = 1:totalSubFileNum
%         load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-xform_laser_grid.mat'),'gridLaser')
%         gridLaser_mouse(:,:,:,ii) = gridLaser;
%     end
%     gridLaser_mouse = nanmean(gridLaser_mouse,4);
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
% end
%
% GoodSeedsidx = zeros(160,1);
% for ii = 1:160
%     if ~isnan(gridLaser_mouse(64,64,ii))
%         GoodSeedsidx(ii) = 1;
%     end
% end
%
% save('220608-N24M322-LandmarksandMask.mat', 'GoodSeedsidx','-append')