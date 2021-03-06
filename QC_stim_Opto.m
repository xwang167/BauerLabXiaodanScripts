

function   [goodBlocks,ROI] = QC_stim(oxy,oxy_downsampled,deoxy,deoxy_downsampled,...
    greenFluor,greenFluorCorr,green,...
    jrgeco1a,jrgeco1a_downsampled,jrgeco1aCorr,jrgeco1aCorr_downsampled,red,red_downsampled,...
    xform_isbrain,numBlock,stimStartTime,stimduration,stimFreq,framerate,stimblocksize,stimbaseline,texttitle,output,input_ROI,...
    InstMvMt_detrend,LTMvMt_detrend)

maxTotal = 0.6; % 0.6;
maxRGECO = 1; %1.6;
total_downsampled  = oxy_downsampled + deoxy_downsampled;
stimEndTime= stimStartTime+stimduration;

if isempty(InstMvMt_detrend)

    goodBlocks = 1;
else
    if ~isempty(jrgeco1a)
        [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,[],jrgeco1a_downsampled,input_ROI,InstMvMt_detrend,LTMvMt_detrend,framerate);
    elseif ~isempty(greenFluor)
        [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,greenFluorCorr_downsampled,[],InstMvMt_detrend,LTMvMt_detrend,framerate);
    else
        [goodBlocks] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,[],[],InstMvMt_detrend,LTMvMt_detrend,framerate);
        
    end

end
texttitle1 = strcat(' Peak Map for each block', {' '},texttitle,{' '}, 'blocks ',{' '}, num2str(goodBlocks),{' '},'are picked');
annotation('textbox',  [0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle1,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
output1 = strcat(output,'_BlockPeakMap.jpg');
orient portrait
print ('-djpeg', '-r1000',output1);
ROI = [];

if ~isempty(goodBlocks)
    stimStartFrame = stimStartTime* framerate;
    [oxy_downsampled_blocks,oxy_blocks] = blockAverage...
        (oxy_downsampled, oxy,goodBlocks,numBlock,stimStartFrame/framerate);
    clear oxy
    [deoxy_downsampled_blocks,deoxy_blocks] = blockAverage...
        (deoxy_downsampled, deoxy,goodBlocks,numBlock,stimStartFrame/framerate);
    clear deoxy
    total_downsampled_blocks = oxy_downsampled_blocks+deoxy_downsampled_blocks;
    total_blocks = oxy_blocks+deoxy_blocks;
    if ~isempty(greenFluor)
        [greenFluorCorr_downsampled_blocks,greenFluorCorr_blocks] = blockAverage...
            (greenFluorCorr_downsampled, greenFluorCorr,goodBlocks,numBlock,stimStartFrame);
        clear greenFluorCorr
        [greenFluor_downsampled_blocks,greenFluor_blocks] = blockAverage...
            (greenFluor_downsampled, greenFluor,goodBlocks,numBlock,stimStartFrame);
        [green_downsampled_blocks,green_blocks] = blockAverage...
            (green_downsampled, green,goodBlocks,numBlock,stimStartFrame);
        clear green
    end
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
        imagesc(peakMap_ROI,[-maxRGECO maxRGECO])
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
    if isempty(jrgeco1a)&&isempty(greenFluor)
        peakMap_ROI= total_downsampled_blocks(:,:,stimEndTime);
        figure
        imagesc(peakMap_ROI,[min(peakMap_ROI,[],'all') max(peakMap_ROI,[],'all')])
        colorbar
        axis image off
        title('Total');
        colormap jet
    end
    
    
    
    hold on
    load('D:\OIS_Process\atlas.mat','AtlasSeeds')
    barrel = AtlasSeeds == 9;
    ROI_barrel =  bwperim(barrel);
    
    
    contour(ROI_barrel,'k')
    if isempty(input_ROI)
        [x1,y1] = ginput(1);
        [x2,y2] = ginput(1);
        [X,Y] = meshgrid(1:128,1:128);
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        max_ROI = prctile(peakMap_ROI(ROI),99);
        temp = peakMap_ROI.*ROI;
        ROI = temp>0.90*max_ROI;
    else
        ROI = input_ROI;
    end
    hold on
    ROI_contour = bwperim(ROI);
    contour( ROI_contour,'k');

    
    
    %% Time trace plot
    
    iROI = reshape(ROI,1,[]);
    
    if ~isempty(jrgeco1a)
        jrgeco1aCorr_blocks= reshape(jrgeco1aCorr_blocks,length(iROI),[]);
        jrgeco1aCorr_active = mean(jrgeco1aCorr_blocks(iROI,:),1);
        jrgeco1aCorr_active = jrgeco1aCorr_active - mean(jrgeco1aCorr_active(1:stimbaseline));
        
        jrgeco1a_blocks= reshape(jrgeco1a_blocks,length(iROI),[]);
        jrgeco1a_active = mean(jrgeco1a_blocks(iROI,:),1);
        jrgeco1a_active = jrgeco1a_active - mean(jrgeco1a_active(1:stimbaseline));
        
        red_blocks= reshape(red_blocks,length(iROI),[]);
        red_active = mean(red_blocks(iROI,:),1);
        red_active = red_active - mean(red_active(1:stimbaseline));
    end
    
    if ~isempty(greenFluor)
        greenFluorCorr_blocks= reshape(greenFluorCorr_blocks,length(iROI),[]);
        greenFluorCorr_active = mean(greenFluorCorr_blocks(iROI,:),1);
         greenFluorCorr_active = greenFluorCorr_active - mean(greenFluorCorr_active(1:stimbaseline));
        
        greenFluor_blocks= reshape(greenFluor_blocks,length(iROI),[]);
        greenFluor_active = mean(greenFluor_blocks(iROI,:),1);
         greenFluor_active = greenFluor_active - mean(greenFluor_active(1:stimbaseline));
       
        green_blocks= reshape(green_blocks,length(iROI),[]);
        green_active = mean(green_blocks(iROI,:),1);
          green_active = green_active - mean(green_active(1:stimbaseline));
    end
    
    oxy_blocks= reshape(oxy_blocks,length(iROI),[]);
    oxy_active = mean(oxy_blocks(iROI,:),1);
    oxy_active = oxy_active - mean(oxy_active(1:stimbaseline));
    
    deoxy_blocks= reshape(deoxy_blocks,length(iROI),[]);
    deoxy_active = mean(deoxy_blocks(iROI,:),1);
    deoxy_active = deoxy_active - mean(deoxy_active(1:stimbaseline));
    
    total_blocks= reshape(total_blocks,length(iROI),[]);
    total_active = mean(total_blocks(iROI,:),1);
    total_active = total_active - mean(total_active(1:stimbaseline));
    
    cMax = max(abs([oxy_active,deoxy_active,total_active]),[],'all');
    if ~isempty(jrgeco1a)
        fMax = max(abs(jrgeco1aCorr_active),[],'all');
    end
    if ~isempty(greenFluor)
        if ~isempty(jrgeco1a)
            fMax = max(abs([jrgeco1aCorr_active,greenFluorCorr_active]),[],'all');
        else
            fMax = max(abs(greenFluorCorr_active),[],'all');
        end
    end
    
    figure;
    x = (1:round( stimblocksize))/ framerate;
    
    if ~isempty(jrgeco1a)
        plot(x,jrgeco1aCorr_active,'m-');
        ylim([-1.1*fMax 1.1*fMax])
        ylabel('Fluorescence(\DeltaF/F%)','FontSize',12);
        hold on
    end
    
    if ~isempty(greenFluor)
        plot(x,greenFluorCorr_active,'g-')
        ylim([-1.1*fMax 1.1*fMax])
        ylabel('Fluorescence(\DeltaF/F%)','FontSize',12);
        hold on
    end
    
    
    yyaxis right
    plot(x,oxy_active,'r-');
    hold on
    plot(x,deoxy_active,'b-');
    hold on
    plot(x,total_active,'Color','k');
    set(findall(gca, 'Type', 'Line'),'LineWidth',1);
    
    
    xlabel('Time(s)','FontSize',12)
    ylabel('Hb(\Delta\muM)','FontSize',12)
    ylim([-1.1*cMax 1.1*cMax])
    
    xlim([0 round( stimblocksize/ framerate)])
    hold on
    
    for i  = [0, stimduration-1/ stimFreq]
        line([ stimbaseline/ framerate+i  stimbaseline/ framerate+i],[-1.3*cMax 1.3*cMax],'LineWidth',0.01);
        hold on
    end
    
%     for i  = 0:1/ stimFreq: stimduration-1/ stimFreq
%         line([ stimbaseline/ framerate+i  stimbaseline/ framerate+i],[-1.3*cMax 1.3*cMax],'LineWidth',0.01);
%         hold on
%     end
    if ~isempty(jrgeco1a)&&~isempty(greenFluor)
        legend('jRGECO1aCorr','greenFluorCorr','HbO','HbR','Total','location','southeast')
    elseif ~isempty(jrgeco1a)
        legend('jRGECO1aCorr','HbO','HbR','Total','location','southeast')
    elseif ~isempty(greenFluor)
        legend('gcampCorr','HbO','HbR','Total','location','southeast')
    else
        legend('HbO','HbR','Total','location','southeast')
    end
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',10);
    
    saveas(gcf,strcat(output,'tracePlot.fig'))
    saveas(gcf,strcat(output,'tracePlot.png'))
    
    load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','WL')
    
    traceImage(oxy_downsampled_blocks,total_downsampled_blocks,deoxy_downsampled_blocks,...
        'HbO','Total','HbR',oxy_active,total_active,deoxy_active,'r','k','b',ROI,'\Delta\muM',...
        stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain,[maxTotal maxTotal/1.1 maxTotal/1.5])
    
    texttitle2 = strcat(' Block Average for ', {' '},texttitle);
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    saveas(gcf,strcat(output,'HbTraceImage.fig'))
    saveas(gcf,strcat(output,'HbTraceImage.png'))
    
    %     figure
    %     imagesc(total_downsampled_blocks(:,:,stimEndTime),...
    %         [-maxTotal maxTotal])
    %     colorbar
    %     hold on
    %     imagesc(WL,'AlphaData',1-ROI)
    %     axis image off
    %     title('Total');
    %     colormap jet
    %     saveas(gcf,strcat(output,'HbTpeak.fig'))
    %     saveas(gcf,strcat(output,'Hbpeak.png'))
    
    
    
    if ~isempty(jrgeco1a)
        traceImage_rgeco(jrgeco1a_downsampled_blocks,jrgeco1aCorr_downsampled_blocks,red_downsampled_blocks,...
            'jrgeco1a','jrgeco1aCorr','625nm Reflectance',jrgeco1a_active,jrgeco1aCorr_active,red_active,'k','m','r',ROI,'\DeltaF/F%',...
            stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain,[maxRGECO maxRGECO maxRGECO/5])
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
        saveas(gcf,strcat(output,'RGECOTraceImage.fig'))
        saveas(gcf,strcat(output,'RGECOTraceImage.png'))
        
        %         figure
        %         imagesc(jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime),...
        %             [-maxRGECO maxRGECO])
        %         colorbar
        %         hold on
        %         imagesc(WL,'AlphaData',1-ROI)
        %         axis image off
        %         title('jregeco1Corr');
        %         colormap jet
        %         saveas(gcf,strcat(output,'rgecopeak.fig'))
        %         saveas(gcf,strcat(output,'rgecopeak.png'))
        
        if ~isempty(greenFluor)
            traceImage(greenFluor_downsampled_blocks,greenFluorCorr_downsampled_blocks,green_downsampled_blocks,...
                'FAD','FADCorr','525nm Reflectance',greenFluor_active,greenFluorCorr_active,green_active,'k','g',[ 0 0.6 0],ROI,'\DeltaF/F%',...
                stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain)
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
            saveas(gcf,strcat(output,'FADTraceImage.fig'))
            saveas(gcf,strcat(output,'FADTraceImage.png'))
            
            %             figure
            %             imagesc(greenFluorCorr_downsampled_blocks(:,:,stimEndTime),...
            %                 [min(greenFluorCorr_downsampled_blocks(:,:,stimEndTime),[],'all'),max(greenFluorCorr_downsampled_blocks(:,:,stimEndTime),[],'all')])
            %             colorbar
            %             hold on
            %             imagesc(WL,'AlphaData',1-ROI)
            %             axis image off
            %             title('FAD');
            %             colormap jet
            %             saveas(gcf,strcat(output,'FADpeak.fig'))
            %             saveas(gcf,strcat(output,'FADpeak.png'))
        end
        
        
    elseif ~isempty(greenFluor)
        traceImage(greenFluor_downsampled_blocks,greenFluorCorr_downsampled_blocks,green_downsampled_blocks,...
            'gcamp','gcampCorr','525nm',greenFluor_active,greenFluorCorr_active,green_active,'k','g',[ 0 0.6 0],ROI,'\DeltaF/F%',...
            stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain)
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
        saveas(gcf,strcat(output,'gcampTraceImage.fig'))
        saveas(gcf,strcat(output,'gcampTraceImage.png'))
    end
end