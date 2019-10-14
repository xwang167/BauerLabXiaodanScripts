% dataO = squeeze(xform_datahb(:,:,1,:));
% dataFluor = xform_jrgeco1aCorr;
% 
% paramPath = what('bauerParams');
% stdMask = load(fullfile(paramPath.path,'noVasculatureMask.mat'));
% meanMask = stdMask.leftMask | stdMask.rightMask;

fprintf('Frame: ');
ini = 20;
for i=ini:20:1000
    movFig = figure('position', [50 50 300 500], 'color', 'w','Visible', 'off');
    
    if i>5000
        for j=0:log10(i-1)
            fprintf('\b');
        end
    end
    fprintf('%d', i);
    pause(.05)
   
    subplot(1,3,1);
    imagesc(Kenny(:,:,i),[-0.04 0.04])
    %imagesc(dataO(:,:,i), 'AlphaData', meanMask, [-5e-6 5e-6]);
    colorbar;
    axis(gca,'square');
    set(gca,'Visible','off');
    colormap jet;
    
    subplot(1,3,2);
    imagesc(Hillman(:,:,i),[-0.04 0.04])
    %imagesc(dataFluor(:,:,i),'AlphaData', meanMask, [-0.06 0.06]);
    colorbar;
    axis(gca,'square');
    set(gca,'Visible','off');
    colormap jet;
    
        subplot(1,3,3);
        
    imagesc(Kenny(:,:,i)-Hillman(:,:,i),[-0.04 0.04])
   %imagesc(dataFluor(:,:,i),'AlphaData', meanMask, [-0.06 0.06]);
    colorbar;
    axis(gca,'square');
    set(gca,'Visible','off');
    colormap jet;
    
    
    Frames(i-(ini-1)) = getframe(movFig);
    drawnow;
    clf(movFig);
end

saveDest = 'L:\movie\dpcmpare.avi';
writerObj = VideoWriter(saveDest);
writerObj.FrameRate = 1;

open(writerObj);
for i=1:length(Frames)
    frame=Frames(i);
    writeVideo(writerObj, frame);
end

close(writerObj);
close(movFig);
clear('Frames');