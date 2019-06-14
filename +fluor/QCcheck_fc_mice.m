close all;clearvars;clc
import mice.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
isZTransform = true;

info.nVx = 128;
info.nVy = 128;
%
excelRows = [129 131 133 135 137];

numMice = length(excelRows);
suffix = {'_cat','NoDetrend_cat','_processed','_NoDetrend'};
ll = 1:2;
xform_isbrain_mice = 1;
sessionInfo.miceType = 'gcamp6f';
saveDir_cat = 'J:\ProcessedData_3\GCaMP\cat';
for ii = 3
    if strcmp(char(sessionInfo.miceType),'gcamp6f')
        R_gcampCorr_Delta_mice = zeros(info.nVy,info.nVx,14,numMice);
        R_gcampCorr_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
        R_oxy_Delta_mice  = zeros(info.nVy,info.nVx,14,numMice);
        R_oxy_ISA_mice  = zeros(info.nVy,info.nVx,14,numMice);
        Rs_gcampCorr_Delta_mice = zeros(14,14,numMice);
        Rs_gcampCorr_ISA_mice = zeros(14,14,numMice);
        Rs_oxy_Delta_mice = zeros(14,14,numMice);
        Rs_oxy_ISA_mice = zeros(14,14,numMice);
        fdata_deoxy_mice = [];
        fdata_oxy_mice = [];
        fdata_gcampCorr_mice = [];
        fdata_total_mice = [];
                powerdata_deoxy_mice = [];
        powerdata_oxy_mice = [];
        powerdata_gcampCorr_mice = [];
        powerdata_total_mice = [];
        gcampCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        gcampCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
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
        elseif strcmp(char(sessionInfo.miceType),'gcamp6f')
            systemInfo.numLEDs = 3;
        end
        
        
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,suffix(ii),'.mat');
        
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.miceType),'gcamp6f')
                if ii<3
                    disp('loading processed data')
                    load(fullfile(saveDir, processedName),'R_gcampCorr_Delta','R_gcampCorr_ISA','R_oxy_Delta','R_oxy_ISA','Rs_gcampCorr_Delta','Rs_gcampCorr_ISA','Rs_oxy_Delta','Rs_oxy_ISA','fdata_deoxy','fdata_oxy','fdata_gcampCorr','fdata_total','powerdata_deoxy','powerdata_oxy','powerdata_gcampCorr','powerdata_total','gcampCorr_Delta_powerMap','gcampCorr_ISA_powerMap','oxy_Delta_powerMap','oxy_ISA_powerMap')
                    R_gcampCorr_Delta_mice(:,:,:,ll) = atanh(R_gcampCorr_Delta);
                    R_gcampCorr_ISA_mice(:,:,:,ll) = atanh(R_gcampCorr_ISA);
                    R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta);
                    R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA);
                    
                    Rs_gcampCorr_Delta_mice(:,:,ll) = atanh(Rs_gcampCorr_Delta);
                    Rs_gcampCorr_ISA_mice(:,:,ll) = atanh(Rs_gcampCorr_ISA);
                    Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta);
                    Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA);
                    
                    fdata_gcampCorr_mice = cat(1,fdata_gcampCorr_mice,squeeze(fdata_gcampCorr));
                    fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fdata_oxy));
                    fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy));
                    fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_total));
                    
                    gcampCorr_Delta_powerMap_mice(:,:,ll) = gcampCorr_Delta_powerMap;
                    gcampCorr_ISA_powerMap_mice(:,:,ll) = gcampCorr_ISA_powerMap;
                    oxy_Delta_powerMap_mice(:,:,ll) = oxy_Delta_powerMap;
                    oxy_ISA_powerMap_mice(:,:,ll) = oxy_ISA_powerMap;
                  else
                     
                    load(fullfile(saveDir, processedName),'R_gcampCorr_Delta_mouse','R_gcampCorr_ISA_mouse','R_oxy_Delta_mouse','R_oxy_ISA_mouse','Rs_gcampCorr_Delta_mouse','Rs_gcampCorr_ISA_mouse','Rs_oxy_Delta_mouse','Rs_oxy_ISA_mouse','fdata_deoxy_mouse','fdata_oxy_mouse','fdata_gcampCorr_mouse','fdata_total_mouse','powerdata_deoxy_mouse','powerdata_oxy_mouse','powerdata_gcampCorr_mouse','powerdata_total_mouse','gcampCorr_Delta_powerMap_mouse','gcampCorr_ISA_powerMap_mouse','oxy_Delta_powerMap_mouse','oxy_ISA_powerMap_mouse','hz','hz2')
                    R_gcampCorr_Delta_mice(:,:,:,ll) = atanh(R_gcampCorr_Delta_mouse);
                    R_gcampCorr_ISA_mice(:,:,:,ll) = atanh(R_gcampCorr_ISA_mouse);
                    R_oxy_Delta_mice(:,:,:,ll) = atanh(R_oxy_Delta_mouse);
                    R_oxy_ISA_mice(:,:,:,ll) = atanh(R_oxy_ISA_mouse);
                    
                    Rs_gcampCorr_Delta_mice(:,:,ll) = atanh(Rs_gcampCorr_Delta_mouse);
                    Rs_gcampCorr_ISA_mice(:,:,ll) = atanh(Rs_gcampCorr_ISA_mouse);
                    Rs_oxy_Delta_mice(:,:,ll) = atanh(Rs_oxy_Delta_mouse);
                    Rs_oxy_ISA_mice(:,:,ll) = atanh(Rs_oxy_ISA_mouse);
                    
                    fdata_gcampCorr_mice = cat(1,fdata_gcampCorr_mice,squeeze(fdata_gcampCorr_mouse));
                    fdata_oxy_mice = cat(1,fdata_oxy_mice,squeeze(fdata_oxy_mouse));
                    fdata_deoxy_mice = cat(1,fdata_deoxy_mice,squeeze(fdata_deoxy_mouse));
                    fdata_total_mice = cat(1,fdata_total_mice,squeeze(fdata_total_mouse));
                               powerdata_gcampCorr_mice = cat(1,powerdata_gcampCorr_mice,squeeze(powerdata_gcampCorr_mouse));
                    powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));
                    powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));
                    powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
 
                    
                    gcampCorr_Delta_powerMap_mice(:,:,ll) = gcampCorr_Delta_powerMap_mouse;
                    gcampCorr_ISA_powerMap_mice(:,:,ll) = gcampCorr_ISA_powerMap_mouse;
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
    visName = strcat(recDate,'-',miceName,'-',sessionType,suffix(ii));
    R_gcampCorr_Delta_mice = mean(R_gcampCorr_Delta_mice,4);
    R_gcampCorr_ISA_mice  = mean(R_gcampCorr_ISA_mice,4);
    R_oxy_Delta_mice  = mean(R_oxy_Delta_mice,4);
    R_oxy_ISA_mice  = mean(R_oxy_ISA_mice,4);
    Rs_gcampCorr_Delta_mice = mean(Rs_gcampCorr_Delta_mice,3);
    Rs_gcampCorr_ISA_mice = mean(Rs_gcampCorr_ISA_mice,3);
    Rs_oxy_Delta_mice = mean(Rs_oxy_Delta_mice,3);
    Rs_oxy_ISA_mice = mean(Rs_oxy_ISA_mice,3);
    fdata_deoxy_mice = mean(fdata_deoxy_mice,1);
    fdata_oxy_mice = mean(fdata_oxy_mice,1);
    fdata_gcampCorr_mice = mean(fdata_gcampCorr_mice,1);
    fdata_total_mice = mean(fdata_total_mice,1);
    
        powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
    powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
    powerdata_gcampCorr_mice = mean(powerdata_gcampCorr_mice,1);
    powerdata_total_mice = mean(powerdata_total_mice,1);
    
    gcampCorr_Delta_powerMap_mice = mean(gcampCorr_Delta_powerMap_mice,3);
    gcampCorr_ISA_powerMap_mice = mean(gcampCorr_ISA_powerMap_mice,3);
    oxy_Delta_powerMap_mice = mean(oxy_Delta_powerMap_mice,3);
    oxy_ISA_powerMap_mice = mean(oxy_ISA_powerMap_mice,3);
    save(fullfile(saveDir_cat, processedName_mice),'R_gcampCorr_Delta_mice','R_gcampCorr_ISA_mice','R_oxy_Delta_mice','R_oxy_ISA_mice','Rs_gcampCorr_Delta_mice','Rs_gcampCorr_ISA_mice','Rs_oxy_Delta_mice','Rs_oxy_ISA_mice','fdata_deoxy_mice','fdata_oxy_mice','fdata_gcampCorr_mice','fdata_total_mice','gcampCorr_Delta_powerMap_mice','gcampCorr_ISA_powerMap_mice','oxy_Delta_powerMap_mice','oxy_ISA_powerMap_mice')
    
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
        if strcmp(char(sessionInfo.miceType),'gcamp6f')
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            
            QCcheck_fcVis_v1(refseeds,R_oxy_ISA_mice, double(Rs_oxy_ISA_mice),R_gcampCorr_ISA_mice,double(Rs_gcampCorr_ISA_mice), 'gcamp6f','ISA',saveDir_cat,visName,isZTransform)
            QCcheck_fcVis_v1(refseeds,R_oxy_Delta_mice, double(Rs_oxy_Delta_mice),R_gcampCorr_Delta_mice, double(Rs_gcampCorr_Delta_mice), 'gcamp6f','Delta',saveDir_cat,visName,isZTransform)
            close all
            traceSpecies = {'oxy','gcampCorr','deoxy','total'};
            traceColor = {'r', 'g','b','k'};
            figure
            subplot('position', [0.12 0.12 0.6 0.6])
            
            for ii = 1:4
                
                fftCurve = genvarname(['fdata_' traceSpecies{ii} '_mice']);
                powerCurve = genvarname(['powerdata_' traceSpecies{ii} '_mice']);
                
                figure(1)
                if ii==2
                    yyaxis left
                    set(gca, 'YScale', 'log')
                    ylabel('G6((\DeltaF/F)^2/Hz)')
                    eval(['ylim([-inf 1.1*max(' powerCurve ')])'])
                else
                    yyaxis right
                    ylabel('Hb(M^2/Hz)')
                end
                eval(['p' num2str(ii) '= loglog(hz,' powerCurve ',traceColor{ii});']);
                hold on
                
                
                               
                figure(2)
                if ii==2
                    yyaxis left
                    set(gca, 'YScale', 'log')
                    ylabel('G6(\DeltaF/F/Hz)')
                    eval(['ylim([-inf 1.1*max(' fftCurve ')])'])
                else
                    yyaxis right
                    ylabel('Hb(M/Hz)')
                end
                eval(['p' num2str(ii) '= loglog(hz2(1:ceil(end/2)),' fftCurve '(1:ceil(end/2)),traceColor{ii});']);
                hold on
                
            end
            
            figure(1)
            legend('HbO_2',traceSpecies{2},'HbR','Total')
            xlabel('Frequency (Hz)')
            title(strcat(visName,'  Power Spectrum Density'),'fontsize',14);
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir_cat,strcat(visName,'_FCpowerCurve.jpg'))));
            figure(2)
            legend('HbO_2',traceSpecies{2},'HbR','Total')
            xlabel('Frequency (Hz)')
            title(strcat(visName,'  Normalized fft '),'fontsize',14);
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir_cat,strcat(visName,'_FCfftCurve.jpg'))));
      
            
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
                    eval(['imagesc(log(' powerMap '))'])
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
            saveas(gcf,(fullfile(saveDir_cat,strcat(visName,'_FCpowerMap.jpg'))));
            
            
            
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            QCcheck_fc(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_datahbt(:,:,2,:))),double(squeeze(xform_datahb(:,:,1,:)))+double(squeeze(xform_datahb(:,:,2,:))),double(squeeze(xform_jrgeco1aCorr)),'jrgeco1a',xform_isbrain_mice, sessionInfo,saveDir,strcat(visName,'_processed'));
            clear xform_datahb xform_jrgeco1aCorr
        end
    end
end

