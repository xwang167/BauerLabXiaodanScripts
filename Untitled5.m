
%load('J:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat','xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')

xform_datahb(isinf(xform_datahb)) = 0;
xform_datahb(isnan(xform_datahb)) = 0;
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;

xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;

xform_datahb_filtered = mouse.freq.filterData(xform_datahb,0.02,2,25);
xform_FADCorr_filtered = mouse.freq.filterData(xform_FADCorr,0.02,2,25);
xform_jrgeco1aCorr_filtered = mouse.freq.filterData(xform_jrgeco1aCorr,0.02,2,25);


paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'noVasculatureMask.mat'));
meanMask = stdMask.leftMask | stdMask.rightMask;
%% plot Fluor

nFrames = 750;
% Frames(1:nFrames) = struct('cdata',[], 'colormap',[]);
saveDest = 'J:\RGECO\anesRest.avi';
writerObj = VideoWriter(saveDest);
writerObj.FrameRate = 25;

fig1 = figure(1);
set(fig1, 'Position', [50 50 1100 275], 'Visible', 'off', 'Color', 'white');

disp('Running...');
for ii=1000:1750
    disp(num2str(ii-999));
    sgtitle(['t=' sprintf('%.2f',ii/25-1000/25) 's']);
    
        subplot(1,3,1);
    imagesc(xform_jrgeco1aCorr_filtered(:,:,ii),'Alphadata',meanMask,[-0.06 0.06]);
    set(gca,'Visible','off');
    colorbar; colormap('jet');
    axis(gca,'square');
    titleObj = title('Calcium Corr');
    set(titleObj,'Visible','on');
    
        subplot(1,3,2);
    imagesc(xform_FADCorr_filtered(:,:,ii),'Alphadata',meanMask,[-0.015 0.015]);
    set(gca,'Visible','off');
    colorbar; colormap('jet');
    axis(gca,'square');
    titleObj = title('FAD Corr');
    set(titleObj,'Visible','on');
    
    subplot(1,3,3);imagesc(xform_datahb_filtered(:,:,1,ii)+xform_datahb_filtered(:,:,2,ii),'Alphadata',meanMask,[-3e-6 3e-6])
    set(gca,'Visible','off');
    colorbar; colormap('jet');
    axis(gca,'square');
    titleObj = title('Total Hb');
    set(titleObj,'Visible','on');
       
    Frames(ii-999) = getframe(fig1);
    drawnow;
    
end

% save video at desired framerate
% disp('Saving video...');
open(writerObj);
for ii=1:length(Frames)
   frame = Frames(ii);
   writeVideo(writerObj,frame);
end
close(writerObj);
close(fig1);
clear('Frames');
disp('Finished!');