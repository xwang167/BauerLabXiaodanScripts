close all;clearvars;clc
import mice.*
excelFile = "D:\gcamp\gcamp_awake.xlsx";
isZTransform = true;
set(0,'defaulttextfontsize',28);
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;
%
excelRows = [195 202 204];

numMice = length(excelRows);
suffix = {'_cat','NoDetrend_cat','_processed','_NoDetrend'};
ll = 1:2;
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'J:\RGECO\cat';
for ii = 3
    if strcmp(char(sessionInfo.miceType),'jrgeco1a')
        R_jrgeco1aCorr_Delta_mice = zeros(info.nVy,info.nVx,14,numMice);
        R_jrgeco1aCorr_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
        R_oxy_Delta_mice  = zeros(info.nVy,info.nVx,14,numMice);
        R_oxy_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
        Rs_jrgeco1aCorr_Delta_mice = zeros(14,14,numMice);
        Rs_jrgeco1aCorr_ISA_mice = zeros(14,14,numMice);
        Rs_oxy_Delta_mice = zeros(14,14,numMice);
        Rs_oxy_ISA_mice = zeros(14,14,numMice);
        fdata_deoxy_mice = [];
        fdata_oxy_mice = [];
        fdata_jrgeco1aCorr_mice = [];
        fdata_total_mice = [];
                powerdata_deoxy_mice = [];
        powerdata_oxy_mice = [];
        powerdata_jrgeco1aCorr_mice = [];
        powerdata_total_mice = [];
        jrgeco1aCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        jrgeco1aCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        oxy_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        oxy_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    end
    miceName = [];
    ll = 1;
    for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        miceName = char(strcat(miceName, '-', mouseName));
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        sessionInfo.darkFrameNum = excelRaw{11};
        rawdataloc = excelRaw{3};
        info.nVx = 128;
        info.nVy = 128;
        systemType =excelRaw{5};
        sessionInfo.darkFrameNum = excelRaw{11};
        sessionInfo.framerate = excelRaw{7};
        if strcmp(char(sessionInfo.miceType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            systemInfo.numLEDs = 3;
        end
          maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
  
        
 
  load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,suffix(ii),'.mat');
        
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.miceType),'jrgeco1a')
                if ii<3
                    disp('loading processed data')
                    load(fullfile(saveDir, processedName),'R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','R_oxy_Delta','R_oxy_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA','Rs_oxy_Delta','Rs_oxy_ISA','fdata_deoxy','fdata_oxy','fdata_jrgeco1aCorr','fdata_total','powerdata_deoxy','powerdata_oxy','powerdata_jrgeco1aCorr','powerdata_total','jrgeco1aCorr_Delta_powerMap','jrgeco1aCorr_ISA_powerMap','oxy_Delta_powerMap','oxy_ISA_powerMap')
                    R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta);
                    R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA);
                    R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta);
                    R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA);
                    
                    Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta);
                    Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA);
                    Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta);
                    Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA);
                    
                    fdata_jrgeco1aCorr_mice = cat(1,fdata_jrgeco1aCorr_mice,squeeze(fdata_jrgeco1aCorr));
                    fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fdata_oxy));
                    fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy));
                    fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_total));
                    
                    jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap;
                    jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap;
                    oxy_Delta_powerMap_mice(:,:,ll) = oxy_Delta_powerMap;
                    oxy_ISA_powerMap_mice(:,:,ll) = oxy_ISA_powerMap;
                  else
                     
                    load(fullfile(saveDir, processedName),'R_jrgeco1aCorr_Delta_mouse','R_jrgeco1aCorr_ISA_mouse','R_oxy_Delta_mouse','R_oxy_ISA_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_jrgeco1aCorr_ISA_mouse','Rs_oxy_Delta_mouse','Rs_oxy_ISA_mouse','fdata_deoxy_mouse','fdata_oxy_mouse','fdata_jrgeco1aCorr_mouse','fdata_total_mouse','powerdata_deoxy_mouse','powerdata_oxy_mouse','powerdata_jrgeco1aCorr_mouse','powerdata_total_mouse','jrgeco1aCorr_Delta_powerMap_mouse','jrgeco1aCorr_ISA_powerMap_mouse','oxy_Delta_powerMap_mouse','oxy_ISA_powerMap_mouse','hz','hz2')
                    R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta_mouse);
                    R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA_mouse);
                    R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta_mouse);
                    R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA_mouse);
                    
                    Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta_mouse);
                    Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA_mouse);
                    Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta_mouse);
                    Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA_mouse);
                    
                    fdata_jrgeco1aCorr_mice = cat(1,fdata_jrgeco1aCorr_mice,squeeze(fdata_jrgeco1aCorr_mouse));
                    fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fdata_oxy_mouse));
                    fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy_mouse));
                    fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_total_mouse));
                               powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr_mouse));
                    powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));
                    powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));
                    powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
 
                    
                    jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap_mouse;
                    jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap_mouse;
                    oxy_Delta_powerMap_mice(:,:,ll) = oxy_Delta_powerMap_mouse;
                    oxy_ISA_powerMap_mice(:,:,ll) = oxy_ISA_powerMap_mouse;
                end
            elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
                
                load(fullfile(saveDir, processedName),'xform_datahb','xform_jrgeco1aCorr')
            end
            ll = ll+1;
        end
    end
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,suffix(ii),'.mat');
    titleName = strcat(recDate,miceName);
    visName = 'Averaged Across Mice';
    R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
    R_jrgeco1aCorr_ISA_mice  = mean(R_jrgeco1aCorr_ISA_mice,4);
    R_oxy_Delta_mice  = mean(R_oxy_Delta_mice,4);
    R_oxy_ISA_mice  = mean(R_oxy_ISA_mice,4);
    Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
    Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);
    Rs_oxy_Delta_mice = mean(Rs_oxy_Delta_mice,3);
    Rs_oxy_ISA_mice = mean(Rs_oxy_ISA_mice,3);
    fdata_deoxy_mice = mean(fdata_deoxy_mice,1);
    fdata_oxy_mice = mean(fdata_oxy_mice,1);
    fdata_jrgeco1aCorr_mice = mean(fdata_jrgeco1aCorr_mice,1);
    fdata_total_mice = mean(fdata_total_mice,1);
    
        powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
    powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
    powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);
    powerdata_total_mice = mean(powerdata_total_mice,1);
    
    jrgeco1aCorr_Delta_powerMap_mice = mean(jrgeco1aCorr_Delta_powerMap_mice,3);
    jrgeco1aCorr_ISA_powerMap_mice = mean(jrgeco1aCorr_ISA_powerMap_mice,3);
    oxy_Delta_powerMap_mice = mean(oxy_Delta_powerMap_mice,3);
    oxy_ISA_powerMap_mice = mean(oxy_ISA_powerMap_mice,3);
    save(fullfile(saveDir_cat, processedName_mice),'R_jrgeco1aCorr_Delta_mice','R_jrgeco1aCorr_ISA_mice','R_oxy_Delta_mice','R_oxy_ISA_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_oxy_Delta_mice','Rs_oxy_ISA_mice','fdata_deoxy_mice','fdata_oxy_mice','fdata_jrgeco1aCorr_mice','fdata_total_mice','jrgeco1aCorr_Delta_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','oxy_Delta_powerMap_mice','oxy_ISA_powerMap_mice')
    
    isQC = false;
    %                         C = who('-file',fullfile(saveDir,processedName_mice));
    %                         for  k=1:length(C)
    %                             if strcmp(C(k),'fdata_total_mice')
    %                                 isQC= true;
    %                             end
    %                         end
    if isQC
    else
        
        disp(char(['QC check on ', processedName_mice]))
        if strcmp(char(sessionInfo.miceType),'jrgeco1a')
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            
            QCcheck_fcVis_v1(refseeds,R_oxy_ISA_mice, double(Rs_oxy_ISA_mice),R_jrgeco1aCorr_ISA_mice,double(Rs_jrgeco1aCorr_ISA_mice), 'jrgeco1a','ISA',saveDir_cat,visName,isZTransform)
            QCcheck_fcVis_v1(refseeds,R_oxy_Delta_mice, double(Rs_oxy_Delta_mice),R_jrgeco1aCorr_Delta_mice, double(Rs_jrgeco1aCorr_Delta_mice), 'jrgeco1a','Delta',saveDir_cat,visName,isZTransform)
            close all
            traceSpecies = {'oxy','jrgeco1aCorr','deoxy','total'};
            traceColor = {'r', 'g','b','k'};
            figure

            
            for ii = 1:4
                
                fftCurve = genvarname(['fdata_' traceSpecies{ii} '_mice']);
                powerCurve = genvarname(['powerdata_' traceSpecies{ii} '_mice']);
                
                figure(1)
                subplot('position', [0.2 0.14 0.6 0.8])
                if ii==2
                    yyaxis left
                    set(gca, 'YScale', 'log')
                    ylabel('R1((\DeltaF/F)^2/Hz)')
                    eval(['ylim([-inf 1.1*max(' powerCurve ')])'])
                else
                    yyaxis right
                    ylabel('Hb(M^2/Hz)')
                end
                eval(['p' num2str(ii) '= loglog(hz,' powerCurve ',traceColor{ii});']);
                xlim([10^-2,hz(end)])
                hold on
                
                
                               
                figure(2)
                subplot('position', [0.2 0.14 0.6 0.8])
                if ii==2
                    yyaxis left
                    set(gca, 'YScale', 'log')
                    ylabel('R1(\DeltaF/F/Hz)')
                    eval(['ylim([-inf 1.1*max(' fftCurve ')])'])
                else
                    yyaxis right
                    ylabel('Hb(M/Hz)')
                end
                eval(['p' num2str(ii) '= loglog(hz2(1:ceil(end/2)),' fftCurve '(1:ceil(end/2)),traceColor{ii});']);
                xlim([10^-2 hz(ceil(end/2))])
                hold on
                
            end
            
            figure(1)
            legend(traceSpecies{2},'HbO_2','HbR','Total','location','southwest')
            xlabel('Frequency (Hz)')
            suptitle(strcat(' Power Spectrum Density',32, visName));
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir_cat,strcat(titleName,'_FCpowerCurve.jpg'))));
            savefig(fullfile(saveDir_cat,strcat(titleName,'_FCpowerCurve')))
            figure(2)
            legend(traceSpecies{2},'HbO_2','HbR','Total','location','southwest')
            xlabel('Frequency (Hz)')
            suptitle(strcat(' Normalized fft',32,visName));
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir_cat,strcat(titleName,'_FCfftCurve.jpg'))));
            savefig(fullfile(saveDir_cat,strcat(visName,'_FCfftCurve')))
      
            
            close all
            
            
            
            bandTypes = {'ISA','Delta'};
            figure;
            load('D:\OIS_Process\noVasculatureMask.mat')
            subplot_Index = 1;
            for ii=1:2
                for jj = 1:2
                    
                    powerMap = genvarname([traceSpecies{ii} '_' bandTypes{jj} '_powerMap' '_mice']);
                    
                    subplot(2,2,subplot_Index)
                    mask = xform_isbrain_mice.*(double(leftMask)+double(rightMask));
                    mask(mask==0)=NaN;
                    eval([powerMap '=' powerMap '.*mask;']);
                    
                    
                    colormap jet
                    if strcmp(bandTypes{jj},'ISA');
                    bandRange = [0.4 4];
                 
                    elseif strcmp(bandTypes{jj},'Delta');
                      bandRange = [0.009 0.08];   
                    end
                    eval(['imagesc(log(' powerMap '/(bandRange(2)-bandRange(1))))'])
                    cb = colorbar();
                    cb.Ruler.MinorTick = 'on';
                    if ii == 1
                        ylabel(cb,'log(M^2)','FontSize',12)
                    elseif ii==2
                        ylabel(cb,'log((\DeltaF/F)^2)','FontSize',12)
                    end
                    axis image off
                    title([ traceSpecies{ii} bandTypes{jj} ])
                    
                    
                    subplot_Index = subplot_Index+1;
                    
                    
                end
            end
            suptitle(strcat('Power Map', 32 ,visName))
            saveas(gcf,(fullfile(saveDir_cat,strcat(visName,'_FCpowerMap.jpg'))));
            savefig(fullfile(saveDir_cat,strcat(visName,'_FCpowerMap')))
            
            
            
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            QCcheck_fc(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_datahbt(:,:,2,:))),double(squeeze(xform_datahb(:,:,1,:)))+double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_jrgeco1aCorr)),'jrgeco1a',xform_isbrain_mice, sessionInfo,saveDir,strcat(visName,'_processed'));
            clear xform_datahb xform_jrgeco1aCorr
        end
    end
end

