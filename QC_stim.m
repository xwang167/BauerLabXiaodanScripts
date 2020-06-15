function   [goodBlocks,ROI] = QC_stim(oxy,deoxy,greenFluor,greenFluorCorr,green,jrgeco1a,jrgeco1aCorr,red,xform_isbrain,numBlock,numDesample,stimStartTime,stimduration,stimFreq,framerate,stimblocksize,stimbaseline,texttitle,output,input_ROI)

disp('downsampling')

oxy_downsampled  = processAndDownsample(oxy,xform_isbrain,numBlock,numDesample,stimStartTime);
deoxy_downsampled  = processAndDownsample(deoxy,xform_isbrain,numBlock,numDesample,stimStartTime);
total_downsampled  = oxy_downsampled + deoxy_downsampled;

if ~isempty(greenFluor)
    greenFluor_downsampled  = processAndDownsample(greenFluor,xform_isbrain,numBlock,numDesample,stimStartTime);
    greenFluorCorr_downsampled  = processAndDownsample(greenFluorCorr,xform_isbrain,numBlock,numDesample,stimStartTime);
    green_downsampled  = processAndDownsample(green,xform_isbrain,numBlock,numDesample,stimStartTime);
end

if ~isempty(jrgeco1a)
    jrgeco1a_downsampled  = processAndDownsample(jrgeco1a,xform_isbrain,numBlock,numDesample,stimStartTime);
    jrgeco1aCorr_downsampled  = processAndDownsample(jrgeco1aCorr,xform_isbrain,numBlock,numDesample,stimStartTime);
    red_downsampled  = processAndDownsample(red,xform_isbrain,numBlock,numDesample,stimStartTime);
end
stimEndTime= stimStartTime+stimduration;

% if ~isempty(jrgeco1a)
%     [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,greenFluorCorr_downsampled,jrgeco1a_downsampled);
% elseif ~isempty(greenFluor)
%     [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,greenFluorCorr_downsampled,[]);
% else
%     [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,[],[]);
%     
% end
goodBlocks = 1:5;%Delete

texttitle1 = strcat(' Peak Map for each block', {' '},texttitle,{' '}, 'blocks ',{' '}, num2str(goodBlocks),{' '},'are picked');
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle1,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
output1 = strcat(output,'_BlockPeakMap.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);
@ -41,10 +25,10 @@ ROI = [];
if ~isempty(goodBlocks)
    stimStartFrame = stimStartTime* framerate;
    [oxy_downsampled_blocks,oxy_blocks] = blockAverage...
        (oxy_downsampled, oxy,goodBlocks,numBlock,stimStartFrame);
    clear oxy
    [deoxy_downsampled_blocks,deoxy_blocks] = blockAverage...
        (deoxy_downsampled, deoxy,goodBlocks,numBlock,stimStartFrame);
    clear deoxy
    total_downsampled_blocks = oxy_downsampled_blocks+deoxy_downsampled_blocks;
    total_blocks = oxy_blocks+deoxy_blocks;
@ -57,35 +41,36 @@ if ~isempty(goodBlocks)
        [green_downsampled_blocks,green_blocks] = blockAverage...
            (green_downsampled, green,goodBlocks,numBlock,stimStartFrame);
        clear green
        if ~isempty(jrgeco1a)
            [jrgeco1aCorr_downsampled_blocks,jrgeco1aCorr_blocks] = blockAverage...
                (jrgeco1aCorr_downsampled, jrgeco1aCorr,goodBlocks,numBlock,stimStartFrame);
            clear jrgeco1aCorr
            [jrgeco1a_downsampled_blocks,jrgeco1a_blocks] = blockAverage...
                (jrgeco1a_downsampled, jrgeco1a,goodBlocks,numBlock,stimStartFrame);
            clear jrgeco1a
            jrgeco1a = 1;
            [red_downsampled_blocks,red_blocks] = blockAverage...
                (red_downsampled, red,goodBlocks,numBlock,stimStartFrame);
            clear red
            peakMap_ROI= jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime);
            figure
            imagesc(peakMap_ROI,[min(peakMap_ROI,[],'all') max(peakMap_ROI,[],'all')])
            colorbar
            axis image off
            title('jrgeco1aCorr');
            colormap jet
            
        else
            peakMap_ROI= greenFluorCorr_downsampled_blocks(:,:,stimEndTime);
            figure
            imagesc(peakMap_ROI,[min(peakMap_ROI,[],'all') max(peakMap_ROI,[],'all')])
            colorbar
            axis image off
            title('gcampCorr');
            colormap jet
        end
else
                        peakMap_ROI= total_downsampled_blocks(:,:,stimEndTime);
        figure
        imagesc(peakMap_ROI,[min(peakMap_ROI,[],'all') max(peakMap_ROI,[],'all')])
@ -157,7 +142,9 @@ if ~isempty(goodBlocks)
    total_active = mean(total_blocks(iROI,:),1);
    
    cMax = max(abs([oxy_active,deoxy_active,total_active]),[],'all');
 if ~isempty(greenFluor)
        if ~isempty(jrgeco1a)
            fMax = max(abs([jrgeco1aCorr_active,greenFluorCorr_active]),[],'all');
     
    if ~isempty(jrgeco1a)
        plot(x,jrgeco1aCorr_active,'m-');
              hold on
    end
    
    if ~isempty(greenFluor)
        plot(x,greenFluorCorr_active,'g-')
        ylim([-1.1*fMax 1.1*fMax])
        ylabel('Fluorescence(\DeltaF/F)','FontSize',12);
       hold on
    end
    
    
         yyaxis right
    plot(x,oxy_active,'r-');