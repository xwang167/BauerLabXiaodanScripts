% dataO = squeeze(xform_datahb(:,:,1,:));
% dataFluor = xform_jrgeco1aCorr;
% 
% paramPath = what('bauerParams');
% stdMask = load(fullfile(paramPath.path,'noVasculatureMask.mat'));
% meanMask = stdMask.leftMask | stdMask.rightMask;
% load('190707-R5M2286-anes-fc1_processed.mat', 'xform_jrgeco1aCorr','xform_FADCorr')
fprintf('Frame: ');
ini = 1;
for i=ini:1:1000
    movFig = figure('position', [50 50 300 500], 'color', 'w','Visible', 'off');
    
    if i>5000
        for j=0:log10(i-1)
            fprintf('\b');
        end
    end
    fprintf('%d', i);
    disp(' ')
    pause(.04)
    subplot(1,2,1);
    imagesc(xform_jrgeco1aCorr(:,:,i),[-0.1 0.1])
    %imagesc(dataO(:,:,i), 'AlphaData', meanMask, [-5e-6 5e-6]);
    colorbar;
    axis(gca,'square');
    set(gca,'Visible','off');
    colormap jet;
    title('Calcium')
    
    subplot(1,2,2);
    imagesc(xform_FADCorr(:,:,i),[-0.02 0.02])
    %imagesc(dataFluor(:,:,i),'AlphaData', meanMask, [-0.06 0.06]);
    colorbar;
    axis(gca,'square');
    set(gca,'Visible','off');
    colormap jet;
    title('FAD')
    Frames(i-(ini-1)) = getframe(movFig);
    drawnow;
    clf(movFig);
end

saveDest = 'L:\movie\CalciumFAD_anes.avi';
writerObj = VideoWriter(saveDest);
writerObj.FrameRate = 1;

open(writerObj);
for i=1:length(Frames)
    frame=Frames(i).cdata;
    writeVideo(writerObj, frame);
end

close(writerObj);
close(movFig);
clear('Frames');