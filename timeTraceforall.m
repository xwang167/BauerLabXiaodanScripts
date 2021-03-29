function fh = timeTraceforall(data,runInfo,ROI)
    numBlocks = size(data,3)/(runInfo.blockLen*runInfo.samplingRate);
    data = reshape(data,size(data,1)*size(data,2),[],numBlocks,size(data,4));
    data = squeeze(mean(data(:,:,goodBlocks,:),3));
    ibi = reshape(ROI,1,[]);
    data_ROI = squeeze(mean(data(ibi,:,:),1));
    time = (1:size(data_ROI,1)/runInfo.samplingRate);
    cMax = nan(1,3);
    fh = figure;
    for ii = 1:3
        cMax(ii) = max(abs(data(:,ii)),[]);
    end
    cMax = max(cMax,[]);
    for ii = 1:3
        plot(time,data(:,ii),colors{ii})
        hold on
        
    end
    xlabel('Time(s)','FontSize',12)
    ylabel('Hb(\Delta\muM)','FontSize',12)
    ylim([-1.1*cMax 1.1*cMax])
    
    
    if ~isempty(runInfo.fluorChInd)
        fmax = max(data(:,end),[]);
        yyaxis right
        plot(time,data(:,4))
        ylabel('Fluorescence(\DeltaF/F)','FontSize',12);
        ylim([-1.1*fMax 1.1*fMax])
        
    end
    legend(contrastName)
    set(findall(gca, 'Type', 'Line'),'LineWidth',1);