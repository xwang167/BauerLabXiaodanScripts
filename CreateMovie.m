load('L:\RGECO\190707\190707-R5M2286-anes-fc1_processed.mat', 'xform_jrgeco1aCorr','xform_FADCorr');%190627-R5M86-fc1
mouseName = '190707-R5M2286-anes';
% xform_datahb(isinf(xform_datahb)) = 0;
% xform_datahb(isnan(xform_datahb)) = 0;
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;

xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
% xform_datahb_awake(isinf(xform_datahb_awake)) = 0;
% xform_datahb_awake(isnan(xform_datahb_awake)) = 0;
% xform_FADCorr_awake(isinf(xform_FADCorr_awake)) = 0;
% xform_FADCorr_awake(isnan(xform_FADCorr_awake)) = 0;
%
% xform_jrgeco1aCorr_awake(isinf(xform_jrgeco1aCorr_awake)) = 0;
% xform_jrgeco1aCorr_awake(isnan(xform_jrgeco1aCorr_awake)) = 0;
%
% xform_datahb_awake_filtered = freq.filterData(xform_datahb_awake,0.02,2,25);
% xform_FADCorr_awake_filtered = freq.filterData(xform_FADCorr_awake,0.02,2,25);
% xform_jrgeco1aCorr_awake_filtered = freq.filterData(xform_jrgeco1aCorr_awake,0.02,2,25);
%
paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'noVasculatureMask.mat'));
meanMask = stdMask.leftMask | stdMask.rightMask;
%% plot Fluor

nFrames = 14999;
Frames(1:nFrames) = struct('cdata',[], 'colormap',[]);
saveDest = strcat('D:\movie\',mouseName,'.avi');

writerObj = VideoWriter(saveDest);
writerObj.FrameRate = 25/2;

fig1 = figure(1);
set(fig1, 'Position', [50 50 1100 275], 'Visible', 'off', 'Color', 'white');

disp('Running...');
for ii=1:nFrames
    disp(num2str(ii));
    sgtitle(['t=' sprintf('%.2f',(ii-1)/25) 's']);
    
    subplot(1,2,1);
    imagesc(xform_jrgeco1aCorr(:,:,ii),'Alphadata',meanMask,[-0.08 0.08]);
    set(gca,'Visible','off');
    colorbar; colormap('jet');
    axis(gca,'square');
    titleObj = title('Calcium Corr');
    set(titleObj,'Visible','on');
    
    subplot(1,2,2);
    imagesc(xform_FADCorr(:,:,ii),'Alphadata',meanMask,[-0.015 0.015]);
    set(gca,'Visible','off');
    colorbar; colormap('jet');
    axis(gca,'square');
    titleObj = title('FAD Corr');
    set(titleObj,'Visible','on');
    
%     subplot(1,3,3);imagesc(xform_datahb(:,:,1,ii)+xform_datahb(:,:,2,ii),'Alphadata',meanMask,[-0.4e-5 0.4e-5])
%     set(gca,'Visible','off');
%     colorbar; colormap('jet');
%     axis(gca,'square');
%     titleObj = title('Total Hb');
%     set(titleObj,'Visible','on');
%     
    Frames(ii) = getframe(fig1);
    drawnow;
    
end

% save video at desired framerate
% disp('Saving video...');
open(writerObj);
for ii=1:nFrames
    frame = Frames(ii);
    writeVideo(writerObj,frame);
end
close(writerObj);
close(fig1);
clear('Frames');
disp('Finished!');