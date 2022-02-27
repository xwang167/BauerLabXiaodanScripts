% clear all;close all;clc
% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% load('Z:\220210\220210-m.mat')
%  load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
%  xform_isbrain_mice = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'xform_isbrain')
%     xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
% end
%  xform_isbrain_mice = xform_isbrain_mice & fliplr(xform_isbrain_mice);
% GoodSeedsidx_shared = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'GoodSeedsidx','xform_isbrain')
%     GoodSeedsidx_shared = GoodSeedsidx_shared.*GoodSeedsidx;
% end



%
% gridEFC_jRGECO1a_mice = nan(128,128,160,3);
%
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runInfo = runsInfo(1);
%     totalSubFileNum = length(runInfo.rawFile)/2;
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
%     load(runInfo.saveMaskFile,'GoodSeedsidx')
%     GoodSeedsidx_new = GoodSeedsidx;
%     gridEFC_jRGECO1a = nan(128,128,160);
%     gridevokeTimeTrace_jRGECO1a = nan(runInfo.samplingRate*runInfo.blockLen,160);
%     jj = 1;
%     for ii = 1:totalSubFileNum
%         load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
%         AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
%         numBlock = size(AvgMovie_jRGECO1a,4);
%         kk = 1;
%         while kk < numBlock+1
%             if GoodSeedsidx(m(jj)) == 1
%                 laser_location = gridLaser_mouse(:,:,m(jj));
%                 [M,I_1] = max(laser_location,[],'all','linear');
%                 [row,col] = ind2sub([128 128],I_1);
%                 x1 = col;
%                 y1 = row;
%                 [X,Y] = meshgrid(1:128,1:128);
%                 radius = 3;
%                 ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%                 if M < 10000 || xform_isbrain_mice(row,col) == 0 || GoodSeedsidx_shared(m(jj)) ==0
%                     GoodSeedsidx_new(m(jj)) = 0;
%                     disp([runInfo.mouseName,'#' num2str(m(jj)) ])
%                 else
%                     movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
%                     [gridEFC_jRGECO1a(:,:,m(jj)),gridevokeTimeTrace_jRGECO1a(:,m(jj))] = seedFCMap_xw(movie_jRGECO1a,logical(ROI));
%                     figure
%                     colormap jet
%                     subplot(1,2,1)
%                     imagesc(gridEFC_jRGECO1a(:,:,m(jj)),[-1 1])
%                     axis image off
%                     colorbar
%                     hold on
%                     contour(ROI,'w')
%                     hold on;
%                     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice);
%                     title('Effective Connectivity')
%                     subplot(1,2,2)
%                     plot((1:runInfo.samplingRate*runInfo.blockLen)/runInfo.samplingRate,...
%                         gridevokeTimeTrace_jRGECO1a(:,m(jj)),'m');
%                     title('Evoked Time Trace')
%                     suptitle([runInfo.mouseName, ' ', 'Position #',num2str(m(jj))])
%                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace.fig'))
%                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_ECROIEvokedTimeTrace.png'))
%                     close all
%                     %                     figure
%                     %                     colormap jet
%                     %                     imagesc(laser_location)
%                     %                     axis image off
%                     %                     colorbar
%                     %                     hold on
%                     %                     contour(ROI,'w')
%                     %                     title(['Position #',num2str(m(jj))])
%                     %                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_laserROI.fig'))
%                     %                     saveas(gcf,strcat(runInfo.saveFilePrefix(1:end-6),'_Position',num2str(m(jj)),'_laserROI.png'))
%                     %                     close all
%                 end
%                 kk = kk+1;
%             end
%             jj = jj+1;
%         end
%
%     end
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEFC_jRGECO1a')
%     save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),'gridevokeTimeTrace_jRGECO1a')
%     save(runInfo.saveMaskFile,'GoodSeedsidx_new','-append')
%
% end
%
%
% mouseInd = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runI=runsInfo(1);
%     load(strcat(runInfo.saveFilePrefix(1:end-6),'-ECMap-Calcium.mat'),'gridEFC_jRGECO1a')
%     gridEFC_jRGECO1a_mice(:,:,:,mouseInd) = atanh(gridEFC_jRGECO1a);
%     mouseInd = mouseInd+1;
% end
% gridEFC_jRGECO1a_mice = mean(gridEFC_jRGECO1a_mice,4);
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat','gridEFC_jRGECO1a_mice')
% %
% % for ii = 1:160
% %     imagesc(gridEFC_jRGECO1a_mice(:,:,ii),[-2 2])
% %     pause
% % end
%
% %% how many good seeds
% GoodSeedsidx_new_mice = 1;
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     runI=runsInfo(1);
%     load(runInfo.saveMaskFile,'GoodSeedsidx_new')
%     GoodSeedsidx_new_mice = GoodSeedsidx_new_mice.*GoodSeedsidx_new;
% end
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_new_mice')
%
% %how many valid frames in gridEFC
% numValid = 0;
% for ii = 1:160
%     if ~isnan(gridEFC_jRGECO1a_mice(64,64,ii))
%         numValid = numValid+1;
%     end
% end
%
%
%
gridLaser_mice = nan(128,128,160,3);
ii = 1;
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-xform_laser_grid.mat'),'gridLaser_mouse')
    gridLaser_mice(:,:,:,ii)= gridLaser_mouse;
    ii = ii+1;
end
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridLaser_mice.mat','gridLaser_mice')
%
load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GoodSeedsNew.mat','GoodSeedsidx_new_mice')
seedLocation = nan(2,3,160);
seedLocation_mice = nan(2,160);
for ii = 1:160
    if GoodSeedsidx_new_mice(ii)
        [~,I_1] = max(gridLaser_mice(:,:,ii,1),[],'all','linear');
        [row_1,col_1] = ind2sub([128 128],I_1);
        seedLocation(1,1,ii) = row_1;
        seedLocation(2,1,ii) = col_1;

        [~,I_2] = max(gridLaser_mice(:,:,ii,2),[],'all','linear');
        [row_2,col_2] = ind2sub([128 128],I_2);
        seedLocation(1,2,ii) = row_2;
        seedLocation(2,2,ii) = col_2;

        [~,I_3] = max(squeeze(gridLaser_mice(:,:,ii,3)),[],'all','linear');
        [row_3,col_3] = ind2sub([128 128],I_3);
        seedLocation(1,3,ii) = row_3;
        seedLocation(2,3,ii) = col_3;
        seedLocation_mice(1,ii) = mean(seedLocation(1,:,ii),2);
        seedLocation_mice(2,ii)= mean(seedLocation(2,:,ii),2);
    end
end
save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat','seedLocation_mice')


jj = 1;
figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
[X,Y] = meshgrid(1:128,1:128);
 load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-gridEFC.mat')
 load('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-SeedLocation.mat')
for ii = 1:160
    if ~isnan(gridEFC_jRGECO1a_mice(64,64,ii))
        x1 = seedLocation_mice(1,ii);
        y1 = seedLocation_mice(2,ii);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        subplot(5,8,jj)
        imagesc(gridEFC_jRGECO1a_mice(:,:,ii),[-2 2])
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
            suptitle('N13M309-N13M548-N13M549 Calcium EC -1')
            
            jj = 1;
            saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-1.png')
            saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-1.fig')
            figure('units','normalized','outerposition',[0 0 1 1])
            colormap jet
            suptitle('N13M309-N13M548-N13M549 Calcium EC -2')
        end
    end
end
p = subplot(5,8,39);
Pos = get(p,'Position');
h = colorbar;
ylabel(h, 'z(r)')
set(p,'Position',Pos)
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-2.png')
saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EC-Calcium-2.fig')
























