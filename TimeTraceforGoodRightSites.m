% jj = 1;
% figure('units','normalized','outerposition',[0 0 1 1])
% [X,Y] = meshgrid(1:128,1:128);
% for ii = 1:79
%     x1 = seedLocation_mice_valid_sorted(2,ii);
%     y1 = seedLocation_mice_valid_sorted(1,ii);
%     radius = 3;
%     ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%     
%     x2 = 129-seedLocation_mice_valid_sorted(2,ii);
%     y2 = seedLocation_mice_valid_sorted(1,ii);
%     radius = 3;
%     ROI_2 = sqrt((X-x2).^2+(Y-y2).^2)<radius;
%     
%     subplot(5,8,jj)
%     imagesc(gridPeakMaps_jrgeco1aCorr_mice_valid_sorted(:,:,ii)*100,[-0.5 0.5])
%     hold on
%     contour(ROI,'w')
%     hold on
%     contour(ROI_2,'w')
% %     hold on;
% %     imagesc(xform_WL,'AlphaData',1-xform_isbrain_mice);
%     title(num2str(ii))
%     axis image off
%     if jj ==40
%         p = subplot(5,8,40);
%         Pos = get(p,'Position');
%         h = colorbar;
%         ylabel(h, 'z(r)')
%         set(p,'Position',Pos)
%     end
%     colormap jet
%     jj = jj+1;
%     if jj==41
%         suptitle('N13M309-N13M548-N13M549 Calcium Evoke Response sorted -1')
%         jj = 1;
%         saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponse-Calcium-sorted-1.png')
%         saveas(gcf,'X:\XW\PVChR2-Thy1RGECO\cat\N13M309-N13M548-N13M549-EvokeResponse-Calcium-sorted-1.fig')
%         figure('units','normalized','outerposition',[0 0 1 1])
%         colormap jet
%         suptitle('N13M309-N13M548-N13M549 Calcium Evoke Response -2')
%     end
% end
% p = subplot(5,8,39);
% Pos = get(p,'Position');
% h = colorbar;
% ylabel(h, 'z(r)')
% set(p,'Position',Pos)
% 
% index = 1:79;
% index([5,9,11,25,26,28,39,52,60,66]) = [];
% load('220208-N13M309-evokeTimeTrace-Calcium.mat', 'gridEvokeTimeTrace_jRGECO1a_valid_L_sorted')
% ipsi = mean(gridEvokeTimeTrace_jRGECO1a_valid_L_sorted(:,index),2);
% plot((1:600)/20,ipsi*100,'m')
% xlabel('Time(s)')
% ylabel('\DeltaF/F')

% index2 = 1:79;
% index2([5,6,12,13,21,24,26,28:52,54,56,63:68,70:72,74,76:78]) = [];
% index2 = [4,7,10,17,19,61,62];
% load('220208-N13M309-evokeTimeTrace-Calcium.mat', 'gridEvokeTimeTrace_jRGECO1a_valid_R_sorted')
% contra= mean(gridEvokeTimeTrace_jRGECO1a_valid_R_sorted(:,index2),2);
% load('220210-N13M549-evokeTimeTrace-Calcium.mat', 'gridEvokeTimeTrace_jRGECO1a_valid_R_sorted')
% 
% 
% plot((1:600)/20,contra*100,'m')
% xlabel('Time(s)')
% ylabel('\DeltaF/F')
contra = [];
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
    [X,Y] = meshgrid(1:128,1:128);
for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-GSR-AvgPeakMaps-Calcium'),'gridPeakMaps_jrgeco1aCorr_mouse')
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation'),'seedLocation_mouse_R')
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'), 'gridEvokeTimeTrace_jRGECO1a_R')
    for ii = 1:160        
        if ~isnan(seedLocation_mouse_R(1,ii))
        x1 = seedLocation_mouse_R(2,ii);
        y1 = seedLocation_mouse_R(1,ii);
        radius = 3;
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        ROI = ROI(:);
        map = gridPeakMaps_jrgeco1aCorr_mouse(:,:,ii);
        map = reshape(map,128*128,[]);
        temp = mean(map(ROI)); 
        if temp<0
            contra = cat(2,contra,gridEvokeTimeTrace_jRGECO1a_R(:,ii));
        end
        end
    end
end

contra_mean = mean(contra,2);
baseline = mean(contra_mean(1:100));
contra_baseline = contra_mean-baseline;
figure
plot((1:600)/20,contra_baseline*100,'m')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Contralateral')