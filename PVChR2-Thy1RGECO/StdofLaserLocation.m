load('W:\220210\220210-m.mat')
excelFile="X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
excelRows = 2:11;
loc = nan(2,length(excelRows),160);
for excelRow = excelRows
    runsInfo = parseRuns_xw(excelFile,excelRow);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    for ii = 1:160
        if GoodSeedsidx(ii) ==1
            tmp=gridLaser_mouse(:,:,ii);          
            [maximum,I] = max(tmp(:));
            if maximum>10000
                [row,col] = ind2sub([128 128],I);
                loc(1,excelRow-1,ii) = col;
                loc(2,excelRow-1,ii) = row;
            end
        end
        
    end
end
loc_row_std = nanstd(squeeze(loc(2,:,:)));
loc_col_std = nanstd(squeeze(loc(1,:,:)));

loc_row_mean = nanmean(squeeze(loc(2,:,:)));
loc_col_mean = nanmean(squeeze(loc(1,:,:)));

figure
imagesc(xform_WL(:,1:64,:));
hold on
for jj = 1:160
    scatter(loc_col_mean(jj),loc_row_mean(jj),30,loc_row_std(jj)/128*10,'filled')
    hold on
end
h = colorbar;
ylabel(h, 'mm')
colormap jet
colorbar
axis image off
title('Std for row')

figure
[refseeds, ~]=GetReferenceGridSeeds;
imagesc(xform_WL(:,1:64,:));
hold on
for jj = 1:160
    scatter(loc_col_mean(jj),loc_row_mean(jj),30,loc_col_std(jj)/128*10,'filled')
    hold on
end
colormap jet
h = colorbar;
ylabel(h, 'mm')
axis image off
title('Std for col')


