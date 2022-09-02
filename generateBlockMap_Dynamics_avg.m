function  [fh,peakMaps] = generateBlockMap_Dynamics_avg(data,data_gsr,runInfo,peakRange,isbrain,ROIMask)
% pres of each block during stim period
OGsize=size(data_gsr);
Mask_ind=find(ROIMask.*isbrain);
parampath=what('bauerparams');
load(which('noVasculatureMask.mat'))
mask_new = logical(mask_new);
numRows = length(runInfo.Contrasts);
fh = figure('units','normalized','outerposition',[0 0 1 1]);
colormap jet
peakMaps = nan(128,128,length(runInfo.Contrasts));

for ii = 1:length(runInfo.Contrasts)
    p = subplot(2,3,ii);
    peakMap = squeeze(mean(data_gsr(:,:,(round(peakRange{ii}(1)*runInfo.samplingRate)):(round(peakRange{ii}(end)*runInfo.samplingRate)),ii),3));
    peakMaps(:,:,ii) = peakMap;
    maxVal = prctile(abs(peakMap(mask_new)),90,'all')*2.5;
    maxVal = round(maxVal,2,'significant');
    imagesc(peakMap,'AlphaData',isbrain,[-maxVal,maxVal])
    axis image
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    title(runInfo.Contrasts{ii},'Color',sysInfo(runInfo.system).colors{ii})
    Pos = get(p,'Position');
    cb = colorbar;
    caxis([-maxVal maxVal])
    set(p,'Position',Pos)
    set(cb,'YTick',[-maxVal,0,maxVal]);
    
    if sum(contains({'HbO','HbR','HbT'},runInfo.Contrasts{ii}))>0
        set(get(cb,'label'),'string','Hb(\Delta\muM)');
    elseif sum(contains({'Calcium','FAD'},runInfo.Contrasts{ii}))>0
        set(get(cb,'label'),'string','Fluorescence(\DeltaF/F%)');
    end

end


data_dynam=data;
data_dynam=reshape(data_dynam,OGsize(1)*OGsize(2),[],numel(runInfo.Contrasts));
data_dynam=data_dynam(Mask_ind,:,:);
subplot(2,3,length(runInfo.Contrasts)+1)
for jj=1:numel(runInfo.Contrasts)
    if sum(contains({'HbO','HbR','HbT'},runInfo.Contrasts{jj}))>0
        yyaxis left
        plot(squeeze(squeeze(mean(data_dynam(:,:,jj),'omitnan'))),'Color',sysInfo(runInfo.system).colors{jj})
        hold on
        ylabel('[Hb](\Delta\muM)');
    elseif sum(contains({'Calcium','FAD'},runInfo.Contrasts{jj}))>0
        yyaxis right
        plot(squeeze(squeeze(mean(data_dynam(:,:,jj),'omitnan'))),'Color',sysInfo(runInfo.system).colors{jj})
        hold on
        ylabel('Fluoro(\DeltaF/F%)');
    end
end
grid on
ylimz=ylim;
ylim([ylimz(1)+.1*ylimz(1),ylimz(2)+.1*ylimz(2) ])

xlim([runInfo.stimStartTime*runInfo.samplingRate-3*runInfo.samplingRate runInfo.stimEndTime*runInfo.samplingRate+3*runInfo.samplingRate])   %halft second before to full second after
xticks([runInfo.stimEndTime*runInfo.samplingRate-(2/3)*runInfo.stimEndTime*runInfo.samplingRate,...
    runInfo.stimEndTime*runInfo.samplingRate-(1/3)*runInfo.stimEndTime*runInfo.samplingRate,...
    runInfo.stimEndTime*runInfo.samplingRate])
xticklab=[0,( runInfo.stimEndTime-runInfo.stimStartTime)/2, runInfo.stimEndTime-runInfo.stimStartTime];
xticklabels({num2str(xticklab(1)), num2str(xticklab(2)),num2str(xticklab(3))})

xline(runInfo.stimEndTime*runInfo.samplingRate)
xline(runInfo.stimStartTime*runInfo.samplingRate)

Ax = gca;
xt = Ax.XTick;
Ax.XTickLabel = xt/runInfo.samplingRate-runInfo.stimStartTime;
Ax.XLabel.String = 'Time (sec)';

xlabel('Time (sec)')


