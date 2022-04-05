 load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','xform_WL')
load('L:\RGECO\Kenny\190627\190627-R5M2285-LandmarksAndMask.mat', 'affineMarkers')
load('L:\RGECO\190627\190627-R5M2285-fc1.mat','rawdata')
load('L:\RGECO\Kenny\190627\190627-R5M2285-fc1-dataFluor.mat', 'xform_isbrain')
% cb = colorbar;
% cb.Ruler.MinorTick = 'on';
% set(cb,'YTick',[-1.5 0 1.5]);
saveDir = 'X:\XW\ToJonah';
xform_raw = affineTransform(rawdata,affineMarkers);
for ii = [100 500 2500 12500]
    imagesc(xform_raw(:,:,2,ii),[6000 90000])
    axis image off
    hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain);
    title(['Fluorescence Raw Counts, Frame #',num2str(ii)])
    saveas(gcf,fullfile(saveDir,strcat('Fluorescence-RawCounts_Frame',num2str(ii),'.png')));
    saveas(gcf,fullfile(saveDir,strcat('Fluorescence-RawCounts_Frame',num2str(ii),'.fig')));
end

for ii = [100 500 2500 12500]
    imagesc(xform_raw(:,:,3,ii),[70000 1100000])
    hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain);
    axis image off
    title(['Green Raw Counts, Frame #',num2str(ii)])
    saveas(gcf,fullfile(saveDir,strcat('Green-RawCounts_Frame',num2str(ii),'.png')));
    saveas(gcf,fullfile(saveDir,strcat('Green-RawCounts_Frame',num2str(ii),'.fig')));
end

for ii = [100 500 2500 12500]
    imagesc(xform_raw(:,:,4,ii),[20000 1000000])
    hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain);
    axis image off
    title(['Red Raw Counts, Frame #',num2str(ii)])
    saveas(gcf,fullfile(saveDir,strcat('Red-RawCounts_Frame',num2str(ii),'.png')));
    saveas(gcf,fullfile(saveDir,strcat('Red-RawCounts_Frame',num2str(ii),'.fig')));
end

load('L:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_jrgeco1a', 'xform_jrgeco1aCorr')

  
xform_isbrain(xform_jrgeco1a(:,:,2)*100<-7) = 0;
for ii = [100 500 2500 12500]
    imagesc(xform_jrgeco1a(:,:,ii)*100,[-7 7])
    hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain);
    axis image off
    title(['Raw Calcium, Frame #',num2str(ii)])
    saveas(gcf,fullfile(saveDir,strcat('RawCalcium_Frame',num2str(ii),'.png')));
    saveas(gcf,fullfile(saveDir,strcat('RawCalcium_Frame',num2str(ii),'.fig')));
end

for ii = [100 500 2500 12500]
    imagesc(xform_jrgeco1aCorr(:,:,ii)*100,[-7 7])
    colormap jet
    hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain);
    axis image off
    title(['Corrected Calcium, Frame #',num2str(ii)])
    saveas(gcf,fullfile(saveDir,strcat('CorrectedCalcium_Frame',num2str(ii),'.png')));
    saveas(gcf,fullfile(saveDir,strcat('CorrectedCalcium_Frame',num2str(ii),'.fig')));
end


