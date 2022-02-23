% load('X:\XW\PVChR2-Thy1RGECO\220208\220208-N13M309-GSR-AvgPeakMaps-Calcium.mat', 'gridPeakMaps_jrgeco1aCorr_mouse')
% gridPeakMaps_jrgeco1aCorr_mouse_1=gridPeakMaps_jrgeco1aCorr_mouse;
% load('X:\XW\PVChR2-Thy1RGECO\220212\220212-N13M548-GSR-AvgPeakMaps-Calcium.mat', 'gridPeakMaps_jrgeco1aCorr_mouse')
% gridPeakMaps_jrgeco1aCorr_mouse_2=gridPeakMaps_jrgeco1aCorr_mouse;
% load('X:\XW\PVChR2-Thy1RGECO\220210\220210-N13M549-GSR-AvgPeakMaps-Calcium.mat', 'gridPeakMaps_jrgeco1aCorr_mouse')
% gridPeakMaps_jrgeco1aCorr_mouse_3=gridPeakMaps_jrgeco1aCorr_mouse;
% 
% gridPeakMaps_jrgeco1aCorr_mice = mean(cat(4,gridPeakMaps_jrgeco1aCorr_mouse_1,...
%     gridPeakMaps_jrgeco1aCorr_mouse_2,gridPeakMaps_jrgeco1aCorr_mouse_3),4);
% 
% load('X:\XW\PVChR2-Thy1RGECO\220208\220208-N13M309-xform_laser_grid','gridLaser_mouse');
% gridLaser_mouse_1=gridLaser_mouse;
% load('X:\XW\PVChR2-Thy1RGECO\220212\220212-N13M548-xform_laser_grid','gridLaser_mouse');
% gridLaser_mouse_2=gridLaser_mouse;
% load('X:\XW\PVChR2-Thy1RGECO\220210\220210-N13M549-xform_laser_grid','gridLaser_mouse');
% gridLaser_mouse_3=gridLaser_mouse;
% gridLaser_mice = mean(cat(4,gridLaser_mouse_1,gridLaser_mouse_2,gridLaser_mouse_3),4);
% 
% save('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-PeakMap-Laser.mat',...
%     'gridPeakMaps_jrgeco1aCorr_mice','gridLaser_mice')
% 
% xform_isbrain_mice = 1;
% 
% excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
% 
% for excelRows = 2:4
%     runsInfo = parseRuns_xw(excelFile,excelRows);
%     load(runsInfo(1).saveMaskFile,'xform_isbrain')
%     xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
% end
%  
 
 
 
 load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
for ii = 1:160
    if ~isnan(gridLaser_mice(64,64,ii))
        colormap jet
        subplot(1,2,1)
        imagesc(gridPeakMaps_jrgeco1aCorr_mice(:,:,ii)*100,[-1 1]);
        axis image off
        hold on;
        imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice);
        colorbar
        title('jRGECO1a')
        subplot(1,2,2)
        imagesc(gridLaser_mice(:,:,ii))
        axis image off
        hold on;
        contour(xform_isbrain_mice,'k')
        colorbar
        title('Laser')
        suptitle(['GSR, Corrected jRGECO1a, position',num2str(ii),', averaged across 3 mice'])
        saveas(gcf,strcat('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GSR-PeakMap-Laser-#',num2str(ii),'.png'))
        saveas(gcf,strcat('X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-GSR-PeakMap-Laser-#',num2str(ii),'.fig'))        
    end
end


