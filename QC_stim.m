function   [goodBlocks,ROI] = QC_stim(oxy,deoxy,greenFluor,greenFluorCorr,green,jrgeco1a,jrgeco1aCorr,red,xform_isbrain,numBlock,numDesample,stimStartTime,stimduration,stimFreq,framerate,stimblocksize,stimbaseline,texttitle,output,input_ROI)


load('noVasculatureMask.mat')
mask_new = logical(mask_new);
disp('downsampling')



oxy_downsampled  = processAndDownsample(oxy,xform_isbrain,numBlock,numDesample,stimStartTime);

deoxy_downsampled  = processAndDownsample(deoxy,xform_isbrain,numBlock,numDesample,stimStartTime);

total_downsampled  = oxy_downsampled + deoxy_downsampled;

greenFluorCorr_downsampled = [];
jrgeco1aCorr_downsampled = [];

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

disp('all blocks')
goodBlocks = 1:numBlock;



[goodBlocks,temp_oxy_max,temp_deoxy_max,temp_total_max,temp_jrgeco1aCorr_max,temp_greenFluorCorr_max] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled,deoxy_downsampled,total_downsampled,...
    greenFluorCorr_downsampled,jrgeco1aCorr_downsampled,input_ROI);
% if ~isempty(ifGoodBlocks)
%     goodBlocks = goodBlocks(ifGoodBlocks);
% else
%     prompt = {'Bad blocks to remove:'};
%     title1 = 'Pick block';
%     dims = [1 35];
%     definput = {'[]'};
%     answer = inputdlg(prompt,title1,dims,definput);
%     blocks = 1:numBlock;
%     if ~isempty(str2num(answer{1}))
%         blocks(str2num(answer{1})) = [];
%     end
%     goodBlocks = blocks;
% end
texttitle1 = strcat(' Peak Map for each block', {' '},texttitle,{' '}, 'blocks ',{' '}, num2str(goodBlocks),{' '},'are picked');

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle1,'FontWeight','bold','Color',[1 0 0],'FontSize',16);

output1 = strcat(output,'_BlockPeakMap.jpg');


saveas(gcf,output1)





if ~isempty(goodBlocks)
    
    
    [oxy_downsampled_blocks,oxy_blocks] = blockAverage...
        (oxy_downsampled, oxy,goodBlocks,numBlock,stimbaseline);
    
    clear oxy
    
    [deoxy_downsampled_blocks,deoxy_blocks] = blockAverage...
        (deoxy_downsampled, deoxy,goodBlocks,numBlock,stimbaseline);
    
    clear deoxy
    
    total_downsampled_blocks = oxy_downsampled_blocks+deoxy_downsampled_blocks;
    
    total_blocks = oxy_blocks+deoxy_blocks;
    
    if ~isempty(jrgeco1a)
        
        [jrgeco1aCorr_downsampled_blocks,jrgeco1aCorr_blocks] = blockAverage...
            (jrgeco1aCorr_downsampled, jrgeco1aCorr,goodBlocks,numBlock,stimbaseline);
        
        clear jrgeco1aCorr
        
        [jrgeco1a_downsampled_blocks,jrgeco1a_blocks] = blockAverage...
            (jrgeco1a_downsampled, jrgeco1a,goodBlocks,numBlock,stimbaseline);
        
        clear jrgeco1a
        
        jrgeco1a = 1;
        
        [red_downsampled_blocks,red_blocks] = blockAverage...
            (red_downsampled, red,goodBlocks,numBlock,stimbaseline);
        
        clear red
        
        peakMap_ROI= jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime);
        
        figure
        
        imagesc(peakMap_ROI.*xform_isbrain,[min(peakMap_ROI.*xform_isbrain,[],'all') max(peakMap_ROI.*xform_isbrain,[],'all')])
        
        colorbar
        
        axis image off
        
        title('jrgeco1aCorr');
        
        colormap jet
        
        if ~isempty(greenFluor)
            
            [greenFluorCorr_downsampled_blocks,greenFluorCorr_blocks] = blockAverage...
                (greenFluorCorr_downsampled, greenFluorCorr,goodBlocks,numBlock,stimbaseline);
            
            clear greenFluorCorr
            
            [greenFluor_downsampled_blocks,greenFluor_blocks] = blockAverage...
                (greenFluor_downsampled, greenFluor,goodBlocks,numBlock,stimbaseline);
            
            [green_downsampled_blocks,green_blocks] = blockAverage...
                (green_downsampled, green,goodBlocks,numBlock,stimbaseline);
            
            clear green
            
        end
        
        
        
        
    else
        [greenFluorCorr_downsampled_blocks,greenFluorCorr_blocks] = blockAverage...
            (greenFluorCorr_downsampled, greenFluorCorr,goodBlocks,numBlock,stimbaseline);
        
        clear greenFluorCorr
        
        [greenFluor_downsampled_blocks,greenFluor_blocks] = blockAverage...
            (greenFluor_downsampled, greenFluor,goodBlocks,numBlock,stimbaseline);
        
        [green_downsampled_blocks,green_blocks] = blockAverage...
            (green_downsampled, green,goodBlocks,numBlock,stimbaseline);
        
        clear green
        
        peakMap_ROI= greenFluorCorr_downsampled_blocks(:,:,stimEndTime);
        
        figure
        
        imagesc(peakMap_ROI,[min(peakMap_ROI,[],'all') max(peakMap_ROI,[],'all')])
        
        colorbar
        
        axis image off
        
        title('gcampCorr');
        
        colormap jet
        
        
    end
    
    
    
    
    
    
    
    
    
    
    
    %
    % hold on
    % load('D:\OIS_Process\atlas.mat','AtlasSeeds')
    % barrel = AtlasSeeds == 9;
    % ROI_barrel =  bwperim(barrel);
    % contour(ROI_barrel,'k')
    
    if isempty(input_ROI)
        
        [x1,y1] = ginput(1);
        
        [x2,y2] = ginput(1);
        
        [X,Y] = meshgrid(1:128,1:128);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        
        max_ROI = prctile(peakMap_ROI(ROI),99);
        
        temp = peakMap_ROI.*ROI;
        
        ROI = temp>0.75*max_ROI;
        
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
        
        
        
        jrgeco1a_blocks= reshape(jrgeco1a_blocks,length(iROI),[]);
        
        jrgeco1a_active = mean(jrgeco1a_blocks(iROI,:),1);
        
        
        
        red_blocks= reshape(red_blocks,length(iROI),[]);
        
        red_active = mean(red_blocks(iROI,:),1);
        
    end
    
    
    
    if ~isempty(greenFluor)
        
        greenFluorCorr_blocks= reshape(greenFluorCorr_blocks,length(iROI),[]);
        
        greenFluorCorr_active = mean(greenFluorCorr_blocks(iROI,:),1);
        
        
        
        greenFluor_blocks= reshape(greenFluor_blocks,length(iROI),[]);
        
        greenFluor_active = mean(greenFluor_blocks(iROI,:),1);
        
        
        
        green_blocks= reshape(green_blocks,length(iROI),[]);
        
        green_active = mean(green_blocks(iROI,:),1);
        
    end
    
    
    
    oxy_blocks= reshape(oxy_blocks,length(iROI),[]);
    
    oxy_active = mean(oxy_blocks(iROI,:),1);
    
    
    
    deoxy_blocks= reshape(deoxy_blocks,length(iROI),[]);
    
    deoxy_active = mean(deoxy_blocks(iROI,:),1);
    
    
    
    total_blocks= reshape(total_blocks,length(iROI),[]);
    
    total_active = mean(total_blocks(iROI,:),1);
    
    
    
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
        ylabel('Fluorescence(\DeltaF/F)','FontSize',12);
        
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
    
    for i  = [0, stimduration]
        
        xline(stimbaseline/ framerate+i);
        
        hold on
        
    end
    
    if ~isempty(jrgeco1a)&&~isempty(greenFluor)
        
        legend('jRGECO1aCorr','greenFluorCorr','HbO','HbR','Total','location','southeast')
    elseif ~isempty(jrgeco1a)&&isempty(greenFluor)
        legend('jRGECO1aCorr','HbO','HbR','Total','location','southeast')
        
    elseif ~isempty(greenFluor)
        
        legend('gcampCorr','HbO','HbR','Total','location','southeast')
        
    else
        
        legend('HbO','HbR','Total','location','southeast')
        
    end
    
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',10);
    
    
    
    saveas(gcf,strcat(output,'tracePlot.fig'))
    
    saveas(gcf,strcat(output,'tracePlot.png'))
    load('GoodWL','WL')
    traceImage(oxy_downsampled_blocks,deoxy_downsampled_blocks,total_downsampled_blocks,...
        'HbO','HbR','Total',oxy_active,deoxy_active,total_active,'r','b','k',ROI,'\Delta\muM',...
        stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain,[temp_oxy_max*1.2,temp_deoxy_max*1.2,temp_total_max*1.2])%]3,2,1
    
    
    texttitle2 = strcat(' Block Average for ', {' '},texttitle);
    
    annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
    
    saveas(gcf,strcat(output,'HbTraceImage.fig'))
    
    saveas(gcf,strcat(output,'HbTraceImage.png'))
    
    
    %
    %     figure
    %     imagesc(total_downsampled_blocks(:,:,stimEndTime),...
    %         [min(total_downsampled_blocks(:,:,stimEndTime),[],'all'),max(total_downsampled_blocks(:,:,stimEndTime),[],'all')])
    %
    %     colorbar
    %
    %     hold on
    %
    %     imagesc(WL,'AlphaData',1-ROI)
    %
    %     axis image off
    %
    %     title('Total');
    %
    %     saveas(gcf,strcat(output,'HbTpeak.fig'))
    %
    %     saveas(gcf,strcat(output,'Hbpeak.png'))
    
    if ~isempty(jrgeco1a)
        jrgeco1a_peak = abs(mean(jrgeco1a_downsampled_blocks(:,:,stimStartTime+1:stimEndTime),3));
        red_peak = abs(mean(red_downsampled_blocks(:,:,stimStartTime+1:stimEndTime),3));
        temp_jrgeco1a_max = prctile(jrgeco1a_peak(mask_new),90,'all')*1.4;
        temp_red_max = prctile(red_peak(mask_new),90,'all')*1.4;
        
        traceImage(jrgeco1a_downsampled_blocks,jrgeco1aCorr_downsampled_blocks,red_downsampled_blocks,...
            'jrgeco1a','jrgeco1aCorr','625nm Reflectance',jrgeco1a_active,jrgeco1aCorr_active,red_active,'m','k','r',ROI,'\DeltaF/F%',...
            stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain,[temp_jrgeco1a_max*1.2 temp_jrgeco1aCorr_max*1.2 temp_red_max*1.2])%2 2 0.2
        
        
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
        
        saveas(gcf,strcat(output,'RGECOTraceImage.fig'))
        
        saveas(gcf,strcat(output,'RGECOTraceImage.png'))
        
        if ~isempty(greenFluor)
            
            %             figure
            %             imagesc(jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime),...
            %                 [min(jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime),[],'all'),max(jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime),[],'all')])
            %
            %             colorbar
            %
            %             hold on
            %
            %             imagesc(WL,'AlphaData',1-ROI)
            %
            %             axis image off
            %
            %             title('jregeco1Corr');
            %
            %             saveas(gcf,strcat(output,'rgecopeak.fig'))
            %
            %             saveas(gcf,strcat(output,'rgecopeak.png'))
            
            greenFluor_peak = abs(mean(greenFluor_downsampled_blocks(:,:,stimStartTime+1:stimEndTime),3));
            green_peak = abs(mean(green_downsampled_blocks(:,:,stimStartTime+1:stimEndTime),3));
            temp_greenFluor_max = prctile(greenFluor_peak(mask_new),90,'all')*1.4;
            temp_green_max = prctile(green_peak(mask_new),90,'all')*1.4;
            
            traceImage(greenFluor_downsampled_blocks,greenFluorCorr_downsampled_blocks,green_downsampled_blocks,...
                'FAD','FADCorr','525nm Reflectance',greenFluor_active,greenFluorCorr_active,green_active,'g','k',[ 0 0.6 0],ROI,'\DeltaF/F%',...
                stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain,[temp_greenFluor_max*1.2 temp_greenFluorCorr_max*1.2 temp_green_max*1.2]) %2,1,1.5
            
            
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
            
            saveas(gcf,strcat(output,'FADTraceImage.fig'))
            
            saveas(gcf,strcat(output,'FADTraceImage.png'))
            
            
            
            %             figure
            %
            %             imagesc(greenFluorCorr_downsampled_blocks(:,:,stimEndTime),...
            %                 [min(greenFluorCorr_downsampled_blocks(:,:,stimEndTime),[],'all'),max(greenFluorCorr_downsampled_blocks(:,:,stimEndTime),[],'all')])
            %
            %             colorbar
            %
            %             hold on
            %
            %             imagesc(WL,'AlphaData',1-ROI)
            %
            %             axis image off
            %
            %             title('FAD');
            %
            %             saveas(gcf,strcat(output,'FADpeak.fig'))
            %
            %             saveas(gcf,strcat(output,'FADpeak.png'))
            
        end
        
        
    elseif ~isempty(greenFluor)
        greenFluor_peak = abs(mean(greenFluor_downsampled_blocks(:,:,stimStartTime+1:stimEndTime),3));
        green_peak = abs(mean(green_downsampled_blocks(:,:,stimStartTime+1:stimEndTime),3));
        temp_greenFluor_max = prctile(greenFluor_peak(mask_new),90,'all')*1.4;
        temp_green_max = prctile(green_peak(mask_new),90,'all')*1.4;
        traceImage(greenFluor_downsampled_blocks,greenFluorCorr_downsampled_blocks,green_downsampled_blocks,...
            'gcamp','gcampCorr','525nm Reflectance',greenFluor_active,greenFluorCorr_active,green_active,'g','k',[ 0 0.6 0],ROI,'\DeltaF/F%',...
            stimduration, stimblocksize, stimFreq, framerate, stimbaseline,stimStartTime,stimEndTime,xform_isbrain,[temp_greenFluor_max*1.2 temp_greenFluorCorr_max*1.2 temp_green_max*1.2]) %2,1,1.5
        
        annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle2,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
        
        saveas(gcf,strcat(output,'gcampTraceImage.fig'))
        
        saveas(gcf,strcat(output,'gcampTraceImage.png'))
        
    end
end
end