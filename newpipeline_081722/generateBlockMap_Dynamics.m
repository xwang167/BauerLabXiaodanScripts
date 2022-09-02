function  [fh,peakMaps] = generateBlockMap_Dynamics(data,data_gsr,runInfo,numBlocks,peakRange,isbrain,ROIMask)
% pres of each block during stim period
OGsize=size(data_gsr);
Mask_ind=find(ROIMask.*isbrain);

parampath=what('bauerparams');
load(which('noVasculatureMask.mat'))
mask_new = logical(mask_new);
numRows = length(runInfo.Contrasts);
fh = figure('units','normalized','outerposition',[0 0 1 1]);
colormap jet
peakMaps = nan(128,128,numBlocks+1,numRows);
for ii = 1:numBlocks+1
    
    for jj = 1:numRows+1
        if jj<=numRows
            peakMap = squeeze(mean(data_gsr(:,:,:,:,jj),4));
            peakMap = squeeze(mean(peakMap(:,:,(round(peakRange{jj}(1)*runInfo.reSamplingRate)):(round(peakRange{jj}(end)*runInfo.reSamplingRate))),3));
            maxVal = prctile(abs(peakMap(mask_new)),90,'all')*2.5;
            maxVal = round(maxVal,2,'significant');
            p = subplot(numRows+1,numBlocks+1,(numBlocks+1)*(jj-1)+ii);
            if ii == numBlocks+1
                imagesc(peakMap,'AlphaData',isbrain,[-maxVal,maxVal])
                peakMaps(:,:,ii,jj) = peakMap;
                axis image
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                title('Averaged')
                Pos = get(p,'Position');
                cb = colorbar;
                caxis([-maxVal maxVal])
                set(p,'Position',Pos)
                set(cb,'YTick',[-maxVal,0,maxVal]);
                
                if sum(contains({'HbO','HbR','HbT'},runInfo.Contrasts{jj}))>0
                    set(get(cb,'label'),'string','Hb(\Delta\muM)');
                elseif sum(contains({'Calcium','FAD'},runInfo.Contrasts{jj}))>0
                    set(get(cb,'label'),'string','Fluorescence(\DeltaF/F%)');
                end
            else
                pre = squeeze(mean(data_gsr(:,:,(round(peakRange{jj}(1)*runInfo.reSamplingRate)):(round(peakRange{jj}(end)*runInfo.reSamplingRate)),ii,jj),3));
                imagesc(pre,'AlphaData',isbrain,[-maxVal,maxVal]);
                peakMaps(:,:,ii,jj) = pre;
                
                axis image
                set(gca, 'XTick', []);
                set(gca, 'YTick', []);
                if jj==1
                    title(strcat('Pres',{' '},num2str(ii)))
                end
                if ii == 1
                    ylabel(runInfo.Contrasts{jj},'Color',sysInfo(runInfo.system).colors{jj})
                end
            end
            
        else %Plot dynamics
            data_dynam=data;
            data_dynam=reshape(data_dynam,OGsize(1)*OGsize(2),[],numBlocks,numel(runInfo.Contrasts));
            data_dynam=data_dynam(Mask_ind,:,:,:);
            
            p = subplot(numRows+1,numBlocks+1,(numBlocks+1)*(jj-1)+ii);
            
            if ii~=numBlocks+1
                
                for jjj=1:numel(runInfo.Contrasts)
                    if sum(contains({'HbO','HbR','HbT'},runInfo.Contrasts{jjj}))>0
                        yyaxis left
                        plot(squeeze(squeeze(mean(data_dynam(:,:,ii,jjj),'omitnan'))),'Color',sysInfo(runInfo.system).colors{jjj})
                        hold on
                        ylabel('[Hb](\Delta\muM)');
                    elseif sum(contains({'Calcium','FAD'},runInfo.Contrasts{jjj}))>0
                        yyaxis right
                        plot(squeeze(squeeze(mean(data_dynam(:,:,ii,jjj),'omitnan'))),'Color',sysInfo(runInfo.system).colors{jjj})
                        hold on
                        ylabel('Fluoro(\DeltaF/F%)');
                    end
                end
                grid on
                ylimz=ylim;
                ylim([ylimz(1)+.1*ylimz(1),ylimz(2)+.1*ylimz(2) ])
                
                %xw 220731, make tick -5, 0, stimOnTime, stimOff time,
                %stimOfftime+5
                if runInfo.stimStartTime<5
                    tick1 = 0;
                else
                    tick1 = (runInfo.stimStartTime-5)*runInfo.reSamplingRate;
                end
                tick2 = runInfo.stimStartTime*runInfo.reSamplingRate;
                tick3 = runInfo.stimEndTime*runInfo.reSamplingRate;
                
                if size(data_dynam,2)< (runInfo.stimEndTime+5)*runInfo.reSamplingRate
                    tick4 = size(data_dynam,2);
                else
                    tick4 = (runInfo.stimEndTime+5)*runInfo.reSamplingRate;
                end
                
                xlim([runInfo.stimStartTime*runInfo.reSamplingRate-5*runInfo.reSamplingRate runInfo.stimEndTime*runInfo.reSamplingRate+5*runInfo.reSamplingRate])   %halft second before to full second after
                xticks([tick1,tick2,tick3,tick4])
                xticklab = xticks/runInfo.reSamplingRate-runInfo.stimStartTime;
                xticklabels({num2str(xticklab(1)), num2str(xticklab(2)),num2str(xticklab(3)),num2str(xticklab(4))})
            else
                for jjj=1:numel(runInfo.Contrasts)
                    if sum(contains({'HbO','HbR','HbT'},runInfo.Contrasts{jjj}))>0
                        yyaxis left
                        plot(squeeze(squeeze(squeeze(mean(mean(data_dynam(:,:,:,jjj),3,'omitnan'),'omitnan')))),'Color',sysInfo(runInfo.system).colors{jjj})
                        hold on
                        ylabel('[Hb](\Delta\muM)');
                    elseif sum(contains({'Calcium','FAD'},runInfo.Contrasts{jjj}))>0
                        yyaxis right
                        plot(squeeze(squeeze(squeeze(mean(mean(data_dynam(:,:,:,jjj),3,'omitnan'),'omitnan')))),'Color',sysInfo(runInfo.system).colors{jjj})
                        hold on
                        ylabel('Fluoro(\DeltaF/F%)');
                    end
                end
                
                grid on
                ylimz=ylim;
                ylim([ylimz(1)+.1*ylimz(1),ylimz(2)+.1*ylimz(2) ])
                
                %xw 220731, make tick -5, 0, stimOnTime, stimOff time,
                %stimOfftime+5
                if runInfo.stimStartTime<5
                    tick1 = 0;
                else
                    tick1 = (runInfo.stimStartTime-5)*runInfo.reSamplingRate;
                end
                tick2 = runInfo.stimStartTime*runInfo.reSamplingRate;
                tick3 = runInfo.stimEndTime*runInfo.reSamplingRate;
                
                if size(data_dynam,2)< (runInfo.stimEndTime+5)*runInfo.reSamplingRate
                    tick4 = size(data_dynam,2);
                else
                    tick4 = (runInfo.stimEndTime+5)*runInfo.reSamplingRate;
                end
                
                xlim([tick1 tick4])   %halft second before to full second after
                xticks([tick1,tick2,tick3,tick4])
                xticklab = xticks/runInfo.reSamplingRate-runInfo.stimStartTime;
                xticklabels({num2str(xticklab(1)), num2str(xticklab(2)),num2str(xticklab(3)),num2str(xticklab(4))})
            end
            
            xline(runInfo.stimEndTime*runInfo.reSamplingRate)
            xline(runInfo.stimStartTime*runInfo.reSamplingRate)
            
            Ax = gca;
            xt = Ax.XTick;
            Ax.XTickLabel = xt/runInfo.reSamplingRate-runInfo.stimStartTime;
            Ax.XLabel.String = 'Time (sec)';
            
            xlabel('Time (sec)')
            
        end
    end
end


end
