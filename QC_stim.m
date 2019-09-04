

function   [goodBlocks] = QC_stim(oxy,deoxy,FAD,FADCorr,green,jrgeco1a,jrgeco1aCorr,red,xform_isbrain,numBlock,numDesample,stimStartTime,stimduration,stimFreq,framerate,stimblocksize,stimbaseline,texttitle,output)

disp('downsampling')

oxy_downsampled  = processAndDownsample(oxy,xform_isbrain,numBlock,numDesample,stimStartTime);
deoxy_downsampled  = processAndDownsample(deoxy,xform_isbrain,numBlock,numDesample,stimStartTime);
total_downsampled  = oxy_downsampled + deoxy_downsampled;

FAD_downsampled  = processAndDownsample(FAD,xform_isbrain,numBlock,numDesample,stimStartTime);
FADCorr_downsampled  = processAndDownsample(FADCorr,xform_isbrain,numBlock,numDesample,stimStartTime);
green_downsampled  = processAndDownsample(green,xform_isbrain,numBlock,numDesample,stimStartTime);

jrgeco1a_downsampled  = processAndDownsample(jrgeco1a,xform_isbrain,numBlock,numDesample,stimStartTime);
jrgeco1aCorr_downsampled  = processAndDownsample(jrgeco1aCorr,xform_isbrain,numBlock,numDesample,stimStartTime);
red_downsampled  = processAndDownsample(red,xform_isbrain,numBlock,numDesample,stimStartTime);
stimEndTime= stimStartTime+stimduration;
[goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,FADCorr_downsampled,jrgeco1a_downsampled);



texttitle1 = strcat(' Peak Map for each block', {' '},texttitle,{' '}, 'blocks ',{' '}, num2str(goodBlocks),{' '},'are picked');
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle1,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
output1 = strcat(output,'_BlockPeakMap.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);


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
    [jrgeco1aCorr_downsampled_blocks,jrgeco1aCorr_blocks] = blockAverage...
        (jrgeco1aCorr_downsampled, jrgeco1aCorr,goodBlocks,numBlock,stimStartFrame);
    clear jrgeco1aCorr
    [jrgeco1a_downsampled_blocks,jrgeco1a_blocks] = blockAverage...
        (jrgeco1a_downsampled, jrgeco1a,goodBlocks,numBlock,stimStartFrame);
    clear jrgeco1a
    [red_downsampled_blocks,red_blocks] = blockAverage...
        (red_downsampled, red,goodBlocks,numBlock,stimStartFrame);
    clear red
    
    [FADCorr_downsampled_blocks,FADCorr_blocks] = blockAverage...
        (FADCorr_downsampled, FADCorr,goodBlocks,numBlock,stimStartFrame);
    clear FADCorr
    [FAD_downsampled_blocks,FAD_blocks] = blockAverage...
        (FAD_downsampled, FAD,goodBlocks,numBlock,stimStartFrame);
    clear FAD
    [green_downsampled_blocks,green_blocks] = blockAverage...
        (green_downsampled, green,goodBlocks,numBlock,stimStartFrame);
    clear green
    %% ROI
    
    Avgjrgeco1aCorr= jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime);
    
    figure
    imagesc(Avgjrgeco1aCorr,[min(Avgjrgeco1aCorr,[],'all') max(Avgjrgeco1aCorr,[],'all')])
    colorbar
    axis image off
    title('jrgeco1aCorr');
    colormap jet
    
    
    hold on
    load('D:\OIS_Process\atlas.mat','AtlasSeeds')
    barrel = AtlasSeeds == 9;
    ROI_barrel =  bwperim(barrel);
    contour(ROI_barrel,'k')
    [x1_jrgeco1aCorr,y1_jrgeco1aCorr] = ginput(1);
    [x2_jrgeco1aCorr,y2_jrgeco1aCorr] = ginput(1);
    [X,Y] = meshgrid(1:128,1:128);
    radius_jrgeco1aCorr = sqrt((x1_jrgeco1aCorr-x2_jrgeco1aCorr)^2+(y1_jrgeco1aCorr-y2_jrgeco1aCorr)^2);
    ROI_jrgeco1aCorr = sqrt((X-x1_jrgeco1aCorr).^2+(Y-y1_jrgeco1aCorr).^2)<radius_jrgeco1aCorr;
    max_jrgeco1aCorr = prctile(Avgjrgeco1aCorr(ROI_jrgeco1aCorr),99);
    temp = Avgjrgeco1aCorr.*ROI_jrgeco1aCorr;
    ROI_jrgeco1aCorr = temp>0.75*max_jrgeco1aCorr;
    
    ROI_jrgeco1aCorr_contour = bwperim(ROI_jrgeco1aCorr);
    contour( ROI_jrgeco1aCorr_contour,'k');
    
    
    %% Time trace plot
    iROI_jrgeco1a = reshape(ROI_jrgeco1aCorr,1,[]);
    jrgeco1aCorr_blocks= reshape(jrgeco1aCorr_blocks,length(iROI_jrgeco1a),[]);
    jrgeco1aCorr_active = mean(jrgeco1aCorr_blocks(iROI_jrgeco1a,:),1);
    
    jrgeco1a_blocks= reshape(jrgeco1a_blocks,length(iROI_jrgeco1a),[]);
    jrgeco1a_active = mean(jrgeco1a_blocks(iROI_jrgeco1a,:),1);
    
    red_blocks= reshape(red_blocks,length(iROI_jrgeco1a),[]);
    red_active = mean(red_blocks(iROI_jrgeco1a,:),1);
    
    FADCorr_blocks= reshape(FADCorr_blocks,length(iROI_jrgeco1a),[]);
    FADCorr_active = mean(FADCorr_blocks(iROI_jrgeco1a,:),1);
    
    FAD_blocks= reshape(FAD_blocks,length(iROI_jrgeco1a),[]);
    FAD_active = mean(FAD_blocks(iROI_jrgeco1a,:),1);
    
    green_blocks= reshape(green_blocks,length(iROI_jrgeco1a),[]);
    green_active = mean(green_blocks(iROI_jrgeco1a,:),1);
    
    oxy_blocks= reshape(oxy_blocks,length(iROI_jrgeco1a),[]);
    oxy_active = mean(oxy_blocks(iROI_jrgeco1a,:),1);
    
    deoxy_blocks= reshape(deoxy_blocks,length(iROI_jrgeco1a),[]);
    deoxy_active = mean(deoxy_blocks(iROI_jrgeco1a,:),1);
    
    total_blocks= reshape(total_blocks,length(iROI_jrgeco1a),[]);
    total_active = mean(total_blocks(iROI_jrgeco1a,:),1);
    
    cMax = max(abs([oxy_active,deoxy_active,total_active]),[],'all');
    
    fMax = max(abs([jrgeco1aCorr_active,FADCorr_active]),[],'all');
    
    
    figure;
    x = (1:round( stimblocksize))/ framerate;
    
    plot(x,jrgeco1aCorr_active,'m-');
    hold on
    plot(x,FADCorr_active,'g-')
    ylim([-1.1*fMax 1.1*fMax])
    ylabel('Fluorescence(\DeltaF/F)','FontSize',12);
    hold on
    
    
    
    yyaxis right
    plot(x,oxy_active,'r-');
    hold on
    plot(x,deoxy_active,'b-');
    hold on
    plot(x,total_active,'Color','k');
    set(findall(gca, 'Type', 'Line'),'LineWidth',1);
    
    
    xlabel('Time(s)','FontSize',12)
    ylabel('Hb(\DeltaM)','FontSize',12)
    ylim([-1.1*cMax 1.1*cMax])
    
    xlim([0 round( stimblocksize/ framerate)])
    hold on
    for i  = 0:1/ stimFreq: stimduration-1/ stimFreq
        line([ stimbaseline/ framerate+i  stimbaseline/ framerate+i],[-1.3*cMax 1.3*cMax]);
        hold on
    end
    legend('jRGECO1aCorr','FADCorr','HbO','HbR','Total','location','southeast')
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',10);
    
    saveas(gcf,strcat(output,'tracePlot.fig'))
    saveas(gcf,strcat(output,'tracePlot.png'))
    
    
    
    traceImage(oxy_downsampled_blocks,deoxy_downsampled_blocks,total_downsampled_blocks,...
        'HbO','HbR','Total',oxy_active,deoxy_active,total_active,'r','b','k',ROI_jrgeco1aCorr,'\DeltaM',...
         stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime)
    
    texttitle2 = strcat(' Block Average for ', {' '},texttitle);
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    saveas(gcf,strcat(output,'HbTraceImage.fig'))
    saveas(gcf,strcat(output,'HbTraceImage.png'))
    
    
    traceImage(jrgeco1a_downsampled_blocks,jrgeco1aCorr_downsampled_blocks,red_downsampled_blocks,...
        'jrgeco1a','jrgeco1aCorr','625nm',jrgeco1a_active,jrgeco1aCorr_active,red_active,'m','k','r',ROI_jrgeco1aCorr,'\DeltaF/F',...
         stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime)
   
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    saveas(gcf,strcat(output,'RGECOTraceImage.fig'))
    saveas(gcf,strcat(output,'RGECOTraceImage.png'))
    
    
    traceImage(FAD_downsampled_blocks,FADCorr_downsampled_blocks,green_downsampled_blocks,...
        'FAD','FADCorr','525nm',FAD_active,FADCorr_active,green_active,'g','k',[ 0 0.6 0],ROI_jrgeco1aCorr,'\DeltaF/F',...
         stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime)
    
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    saveas(gcf,strcat(output,'FADTraceImage.fig'))
    saveas(gcf,strcat(output,'FADTraceImage.png'))
end