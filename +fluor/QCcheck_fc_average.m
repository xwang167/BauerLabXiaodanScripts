close all;clearvars;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";


nVx = 128;
nVy = 128;
%
excelRows = [ 181 183 185 195 202 204];
runs = 1:3;
length_runs = length(runs);

for ii = 1
    isDetrend = logical(ii);
    for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        
        
        
        sessionInfo.darkFrameNum = excelRaw{15};
        rawdataloc = excelRaw{3};
        info.nVx = 128;
        info.nVy = 128;
        sessionInfo.mouseType = excelRaw{17};
        systemType =excelRaw{5};
        sessionInfo.framerate = excelRaw{7};
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            systemInfo.numLEDs = 3;
        end
        
        maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
        
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        if isDetrend
            processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
            visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
        else
            processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_NoDetrend','.mat');
            visName = strcat(recDate,'-',mouseName,'-',sessionType,'_NoDetrend');
        end
        
        R_oxy_Delta_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
        R_oxy_ISA_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
        Rs_oxy_Delta_mouse = zeros(14,14,length_runs);
        Rs_oxy_ISA_mouse = zeros(14,14,length_runs);
        oxy_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
        oxy_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
        fdata_oxy_mouse = [];
        powerdata_oxy_mouse = [];
        
        fdata_deoxy_mouse = [];
        powerdata_deoxy_mouse = [];
        
        fdata_total_mouse = [];
        powerdata_total_mouse = [];
        
        
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            R_gcampCorr_Delta_mouse = zeros(info.nVy,info.nVx,14,length_runs);
            R_gcampCorr_ISA_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
            Rs_gcampCorr_Delta_mouse = zeros(14,14,length_runs);
            Rs_gcampCorr_ISA_mouse = zeros(14,14,length_runs);
            fdata_gcampCorr_mouse = [];
            
            powerdata_gcampCorr_mouse = [];
            gcampCorr_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
            gcampCorr_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            R_jrgeco1aCorr_Delta_mouse = zeros(info.nVy,info.nVx,14,length_runs);
            R_jrgeco1aCorr_ISA_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
            Rs_jrgeco1aCorr_Delta_mouse = zeros(14,14,length_runs);
            Rs_jrgeco1aCorr_ISA_mouse = zeros(14,14,length_runs);
            jrgeco1aCorr_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
            jrgeco1aCorr_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
            fdata_jrgeco1aCorr_mouse = [];
            powerdata_jrgeco1aCorr_mouse = [];
            
            R_FADCorr_Delta_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
            R_FADCorr_ISA_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
            Rs_FADCorr_Delta_mouse = zeros(14,14,length_runs);
            Rs_FADCorr_ISA_mouse = zeros(14,14,length_runs);
            FADCorr_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
            FADCorr_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
            fdata_FADCorr_mouse = [];
            powerdata_FADCorr_mouse = [];
            
        end
        for n = runs
            
            
            disp('loading processed data')
            
            if isDetrend
                processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            else
                processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
            end
            if strcmp(sessionType,'fc')
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    load(fullfile(saveDir, processedName),'R_gcamp6fCorr_Delta','R_gcamp6fCorr_ISA','R_oxy_Delta','R_oxy_ISA','Rs_gcamp6fCorr_Delta','Rs_gcamp6fCorr_ISA','Rs_oxy_Delta','Rs_oxy_ISA','fdata_deoxy','fdata_oxy','fdata_gcamp6fCorr','fdata_total','powerdata_deoxy','powerdata_oxy','powerdata_gcamp6fCorr','powerdata_total','gcamp6fCorr_Delta_powerMap','gcamp6fCorr_ISA_powerMap','oxy_Delta_powerMap','oxy_ISA_powerMap','hz','hz2')
                    R_gcampCorr_Delta_mouse(:,:,:,n) = R_gcamp6fCorr_Delta;
                    R_gcampCorr_ISA_mouse(:,:,:,n) = R_gcamp6fCorr_ISA;
                    R_oxy_Delta_mouse(:,:,:,n) = R_oxy_Delta;
                    R_oxy_ISA_mouse(:,:,:,n) = R_oxy_ISA;
                    
                    Rs_gcampCorr_Delta_mouse(:,:,n) = Rs_gcamp6fCorr_Delta;
                    Rs_gcampCorr_ISA_mouse(:,:,n) = Rs_gcamp6fCorr_ISA;
                    Rs_oxy_Delta_mouse(:,:,n) = Rs_oxy_Delta;
                    Rs_oxy_ISA_mouse(:,:,n) = Rs_oxy_ISA;
                    
                    fdata_gcampCorr_mouse = cat(1,fdata_gcampCorr_mouse,squeeze(fdata_gcamp6fCorr));
                    fdata_oxy_mouse = cat(1,fdata_oxy_mouse,squeeze(fdata_oxy));
                    fdata_deoxy_mouse = cat(1,fdata_deoxy_mouse,squeeze(fdata_deoxy));
                    fdata_total_mouse = cat(1,fdata_total_mouse,squeeze(fdata_total));
                    
                    powerdata_gcampCorr_mouse = cat(1,powerdata_gcampCorr_mouse,squeeze(powerdata_gcamp6fCorr));
                    powerdata_oxy_mouse = cat(1,powerdata_oxy_mouse,squeeze(powerdata_oxy));
                    powerdata_deoxy_mouse = cat(1,powerdata_deoxy_mouse,squeeze(powerdata_deoxy));
                    powerdata_total_mouse = cat(1,powerdata_total_mouse,squeeze(powerdata_total));
                    
                    gcampCorr_Delta_powerMap_mouse(:,:,n) = gcamp6fCorr_Delta_powerMap;
                    gcampCorr_ISA_powerMap_mouse(:,:,n) = gcamp6fCorr_ISA_powerMap;
                    oxy_Delta_powerMap_mouse(:,:,n) = oxy_Delta_powerMap;
                    oxy_ISA_powerMap_mouse(:,:,n) = oxy_ISA_powerMap;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    load(fullfile(saveDir, processedName),'R_oxy_Delta','R_oxy_ISA','R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','R_FADCorr_Delta','R_FADCorr_ISA',...
                        'Rs_oxy_Delta','Rs_oxy_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA', 'Rs_FADCorr_Delta','Rs_FADCorr_ISA',...
                        'fdata_oxy','fdata_deoxy','fdata_total','fdata_jrgeco1aCorr','fdata_FADCorr',...
                        'powerdata_oxy','powerdata_deoxy','powerdata_jrgeco1aCorr','powerdata_total','powerdata_FADCorr',...
                        'oxy_Delta_powerMap','oxy_ISA_powerMap','jrgeco1aCorr_Delta_powerMap','jrgeco1aCorr_ISA_powerMap', 'FADCorr_Delta_powerMap','FADCorr_ISA_powerMap',...
                        'hz','hz2')
                    
                    R_oxy_Delta_mouse(:,:,:,n) = R_oxy_Delta;
                    R_oxy_ISA_mouse(:,:,:,n) = R_oxy_ISA;
                    Rs_oxy_Delta_mouse(:,:,n) = Rs_oxy_Delta;
                    Rs_oxy_ISA_mouse(:,:,n) = Rs_oxy_ISA;
                    fdata_oxy_mouse = cat(1,fdata_oxy_mouse,squeeze(fdata_oxy));
                    powerdata_oxy_mouse = cat(1,powerdata_oxy_mouse,squeeze(powerdata_oxy));
                    oxy_Delta_powerMap_mouse(:,:,n) = oxy_Delta_powerMap;
                    oxy_ISA_powerMap_mouse(:,:,n) = oxy_ISA_powerMap;
                    
                    fdata_deoxy_mouse = cat(1,fdata_deoxy_mouse,squeeze(fdata_deoxy));
                    powerdata_deoxy_mouse = cat(1,powerdata_deoxy_mouse,squeeze(powerdata_deoxy));
                    
                    fdata_total_mouse = cat(1,fdata_total_mouse,squeeze(fdata_total));
                    powerdata_total_mouse = cat(1,powerdata_total_mouse,squeeze(powerdata_total));
                    
                    R_jrgeco1aCorr_Delta_mouse(:,:,:,n) = R_jrgeco1aCorr_Delta;
                    R_jrgeco1aCorr_ISA_mouse(:,:,:,n) = R_jrgeco1aCorr_ISA;
                    Rs_jrgeco1aCorr_Delta_mouse(:,:,n) = Rs_jrgeco1aCorr_Delta;
                    Rs_jrgeco1aCorr_ISA_mouse(:,:,n) = Rs_jrgeco1aCorr_ISA;
                    fdata_jrgeco1aCorr_mouse = cat(1,fdata_jrgeco1aCorr_mouse,squeeze(fdata_jrgeco1aCorr));
                    powerdata_jrgeco1aCorr_mouse = cat(1,powerdata_jrgeco1aCorr_mouse,squeeze(powerdata_jrgeco1aCorr));
                    jrgeco1aCorr_Delta_powerMap_mouse(:,:,n) = jrgeco1aCorr_Delta_powerMap;
                    jrgeco1aCorr_ISA_powerMap_mouse(:,:,n) = jrgeco1aCorr_ISA_powerMap;
                    
                    R_FADCorr_Delta_mouse(:,:,:,n) = R_FADCorr_Delta;
                    R_FADCorr_ISA_mouse(:,:,:,n) = R_FADCorr_ISA;
                    Rs_FADCorr_Delta_mouse(:,:,n) = Rs_FADCorr_Delta;
                    Rs_FADCorr_ISA_mouse(:,:,n) = Rs_FADCorr_ISA;
                    fdata_FADCorr_mouse = cat(1,fdata_FADCorr_mouse,squeeze(fdata_FADCorr));
                    powerdata_FADCorr_mouse = cat(1,powerdata_FADCorr_mouse,squeeze(powerdata_FADCorr));
                    FADCorr_Delta_powerMap_mouse(:,:,n) = FADCorr_Delta_powerMap;
                    FADCorr_ISA_powerMap_mouse(:,:,n) = FADCorr_ISA_powerMap
                end
            end
        end
        R_oxy_Delta_mouse  = mean(R_oxy_Delta_mouse,4);
        R_oxy_ISA_mouse  = mean(R_oxy_ISA_mouse,4);
        Rs_oxy_Delta_mouse = mean(Rs_oxy_Delta_mouse,3);
        Rs_oxy_ISA_mouse = mean(Rs_oxy_ISA_mouse,3);
        fdata_oxy_mouse = mean(fdata_oxy_mouse,1);
        powerdata_oxy_mouse = mean(powerdata_oxy_mouse,1);
        
        fdata_deoxy_mouse = mean(fdata_deoxy_mouse,1);
        powerdata_deoxy_mouse = mean(powerdata_deoxy_mouse,1);
        
        fdata_total_mouse = mean(fdata_total_mouse,1);
        powerdata_total_mouse = mean(powerdata_total_mouse,1);
               
        oxy_Delta_powerMap_mouse = mean(oxy_Delta_powerMap_mouse,3);
        oxy_ISA_powerMap_mouse = mean(oxy_ISA_powerMap_mouse,3);
        
        
        disp(char(['QC check on ', processedName_mouse]))
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            R_gcampCorr_Delta_mouse = mean(R_gcampCorr_Delta_mouse,4);
            R_gcampCorr_ISA_mouse  = mean(R_gcampCorr_ISA_mouse,4);
            Rs_gcampCorr_Delta_mouse = mean(Rs_gcampCorr_Delta_mouse,3);
            Rs_gcampCorr_ISA_mouse = mean(Rs_gcampCorr_ISA_mouse,3);
            fdata_gcampCorr_mouse = mean(fdata_gcampCorr_mouse,1);
            powerdata_gcampCorr_mouse = mean(powerdata_gcampCorr_mouse,1);
            gcampCorr_Delta_powerMap_mouse = mean(gcampCorr_Delta_powerMap_mouse,3);
            gcampCorr_ISA_powerMap_mouse = mean(gcampCorr_ISA_powerMap_mouse,3);
            save(fullfile(saveDir, processedName_mouse),'R_gcampCorr_Delta_mouse','R_gcampCorr_ISA_mouse','R_oxy_Delta_mouse','R_oxy_ISA_mouse','Rs_gcampCorr_Delta_mouse','Rs_gcampCorr_ISA_mouse','Rs_oxy_Delta_mouse','Rs_oxy_ISA_mouse','fdata_deoxy_mouse','fdata_oxy_mouse','fdata_gcampCorr_mouse','fdata_total_mouse','powerdata_deoxy_mouse','powerdata_oxy_mouse','powerdata_gcampCorr_mouse','powerdata_total_mouse','gcampCorr_Delta_powerMap_mouse','gcampCorr_ISA_powerMap_mouse','oxy_Delta_powerMap_mouse','oxy_ISA_powerMap_mouse','hz','hz2')
            
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            
            
            QCcheck_fcVis_v1(refseeds,R_oxy_ISA_mouse, double(Rs_oxy_ISA_mouse),R_gcampCorr_ISA_mouse,double(Rs_gcampCorr_ISA_mouse), 'gcamp6f','ISA',saveDir,visName,false)
            QCcheck_fcVis_v1(refseeds,R_oxy_Delta_mouse, double(Rs_oxy_Delta_mouse),R_gcampCorr_Delta_mouse, double(Rs_gcampCorr_Delta_mouse), 'gcamp6f','Delta',saveDir,visName,false)
            close all
            traceSpecies = {'oxy','gcampCorr','deoxy','total'};
            traceColor = {'r', 'g','b','k'};
            
            for ii = 1:4
                
                fftCurve = genvarname(['fdata_' traceSpecies{ii} '_mouse']);
                powerCurve = genvarname(['powerdata_' traceSpecies{ii} '_mouse']);
                
                figure(1)
                subplot('position',[0.12 0.12 0.6 0.7])
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
                subplot('position',[0.12 0.12 0.6 0.7])
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
            legend(traceSpecies{2},'HbO_2','HbR','Total')
            xlabel('Frequency (Hz)')
            title(strcat(visName,'  Power Spectrum Density'),'Interpreter', 'none','fontsize',14);
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerCurve.jpg'))));
            figure(2)
            legend(traceSpecies{2},'HbO_2','HbR','Total')
            xlabel('Frequency (Hz)')
            title(strcat(visName,'  Normalized fft '),'Interpreter', 'none','fontsize',14);
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCfftCurve.jpg'))));
            
            
            
            
            close all
            
            bandTypes = {'ISA','Delta'};
            figure('units','normalized','outerposition',[0 0 1 1]);
            load('D:\OIS_Process\noVasculatureMask.mat')
            subplot_Index = 1;
            for ii=1:2
                for jj = 1:2
                    
                    powerMap = genvarname([traceSpecies{ii} '_' bandTypes{jj} '_powerMap' '_mouse']);
                    
                    subplot(2,2,subplot_Index)
                    mask = xform_isbrain.*(double(leftMask)+double(rightMask));
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
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerMap.jpg'))));
            
            
            
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            
            R_jrgeco1aCorr_Delta_mouse = mean(R_jrgeco1aCorr_Delta_mouse,4);
            R_jrgeco1aCorr_ISA_mouse  = mean(R_jrgeco1aCorr_ISA_mouse,4);
            Rs_jrgeco1aCorr_Delta_mouse = mean(Rs_jrgeco1aCorr_Delta_mouse,3);
            Rs_jrgeco1aCorr_ISA_mouse = mean(Rs_jrgeco1aCorr_ISA_mouse,3);
            fdata_jrgeco1aCorr_mouse = mean(fdata_jrgeco1aCorr_mouse,1);
            powerdata_jrgeco1aCorr_mouse = mean(powerdata_jrgeco1aCorr_mouse,1);
            jrgeco1aCorr_Delta_powerMap_mouse = mean(jrgeco1aCorr_Delta_powerMap_mouse,3);
            jrgeco1aCorr_ISA_powerMap_mouse = mean(jrgeco1aCorr_ISA_powerMap_mouse,3);
            
            R_FADCorr_Delta_mouse = mean(R_FADCorr_Delta_mouse,4);
            R_FADCorr_ISA_mouse  = mean(R_FADCorr_ISA_mouse,4);
            Rs_FADCorr_Delta_mouse = mean(Rs_FADCorr_Delta_mouse,3);
            Rs_FADCorr_ISA_mouse = mean(Rs_FADCorr_ISA_mouse,3);
            fdata_FADCorr_mouse = mean(fdata_FADCorr_mouse,1);
            powerdata_FADCorr_mouse = mean(powerdata_FADCorr_mouse,1);
            FADCorr_Delta_powerMap_mouse = mean(FADCorr_Delta_powerMap_mouse,3);
            FADCorr_ISA_powerMap_mouse = mean(FADCorr_ISA_powerMap_mouse,3);
            
            save(fullfile(saveDir, processedName_mouse),'R_oxy_ISA_mouse','R_jrgeco1aCorr_ISA_mouse','R_FADCorr_ISA_mouse',...
                'R_oxy_Delta_mouse','R_jrgeco1aCorr_Delta_mouse','R_FADCorr_Delta_mouse',...
                'Rs_oxy_ISA_mouse','Rs_jrgeco1aCorr_ISA_mouse','Rs_FADCorr_ISA_mouse',...
                'Rs_oxy_Delta_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_FADCorr_Delta_mouse',...
                'fdata_oxy_mouse','fdata_deoxy_mouse','fdata_total_mouse','fdata_jrgeco1aCorr_mouse','fdata_FADCorr_mouse',...
                'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_total_mouse','powerdata_jrgeco1aCorr_mouse','powerdata_FADCorr_mouse',...
                'oxy_ISA_powerMap_mouse','jrgeco1aCorr_ISA_powerMap_mouse','FADCorr_ISA_powerMap_mouse',...
                'oxy_Delta_powerMap_mouse','jrgeco1aCorr_Delta_powerMap_mouse','FADCorr_Delta_powerMap_mouse',...
                'hz','hz2')
            
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            bandTypes ={'ISA','Delta'};
            for ii = 1:length(bandTypes)
                fcMatrix1 = genvarname(['Rs_oxy_',bandTypes{ii},'_mouse']);
                fcMatrix2 = genvarname(['Rs_jrgeco1aCorr_',bandTypes{ii},'_mouse']);
                fcMatrix3 = genvarname(['Rs_FADCorr_',bandTypes{ii},'_mouse']);
                
                fcMap1 = genvarname(['R_oxy_',bandTypes{ii},'_mouse']);
                fcMap2 =  genvarname(['R_jrgeco1aCorr_',bandTypes{ii},'_mouse']);
                fcMap3 = genvarname(['R_FADCorr_',bandTypes{ii},'_mouse']);
                
                eval( ['QCcheck_fcVis_twoFluor(refseeds,' fcMap1 ',' fcMatrix1 ',' fcMap2 ',' fcMatrix2 ', ' char(39) 'Oxy' char(39)...
                    ',' char(39) 'jrgeco1aCorr' char(39) ',' char(39) 'r' char(39) ',' char(39)...
                   ' m' char(39) ',bandTypes{ii},saveDir,visName,false)']);
                eval( ['QCcheck_fcVis_twoFluor(refseeds,' fcMap3 ',' fcMatrix3 ',' fcMap2 ',' fcMatrix2 ', ' char(39) 'FADCorr' char(39)...
                    ',' char(39) 'jrgeco1aCorr' char(39) ',' char(39) 'g' char(39) ',' char(39)...
                    'm' char(39) ',bandTypes{ii},saveDir,visName,false)']);
                
            end
            close all
            traceSpecies = {'oxy','deoxy','total','jrgeco1aCorr','FADCorr'};
            traceColor = {'r', 'b','k','m','g'};
            
            for ii = 1:5
                
                fftCurve = genvarname(['fdata_' traceSpecies{ii} '_mouse']);
                powerCurve = genvarname(['powerdata_' traceSpecies{ii} '_mouse']);
                
                figure(1)
                subplot('position',[0.12 0.12 0.6 0.7])
                if ii>3
                    yyaxis right
                    set(gca, 'YScale', 'log')
                    ylabel('(Fluor(\DeltaF/F)^2/Hz)')
                    eval(['ylim([-inf 1.1*max(' powerCurve ')])'])
                else
                    yyaxis left
                    ylabel('Hb(M^2/Hz)')
                end
                eval(['p' num2str(ii) '= loglog(hz,' powerCurve ',traceColor{ii});']);
                hold on
                
                
                
                figure(2)
                subplot('position',[0.12 0.12 0.6 0.7])
                if ii>3
                    yyaxis right
                    set(gca, 'YScale', 'log')
                    ylabel('Fluor(\DeltaF/F/Hz)')
                    eval(['ylim([-inf 1.1*max(' fftCurve ')])'])
                else
                    yyaxis left
                    ylabel('Hb(M/Hz)')
                end
                eval(['p' num2str(ii) '= loglog(hz2(1:ceil(end/2)),' fftCurve '(1:ceil(end/2)),traceColor{ii});']);
                hold on
                
            end
            figure(1)
            legend('oxy','deoxy','total','jrgeco1aCorr','FADCorr')
            xlabel('Frequency (Hz)')
            title(strcat(visName,' PSD'),'fontsize',14,'Interpreter', 'none');
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerCurve.png'))));
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerCurve.fig'))));
            
            figure(2)
            legend('oxy','deoxy','total','jrgeco1aCorr','FADCorr')
            xlabel('Frequency (Hz)')
            title(strcat(visName,'  Normalized fft '),'fontsize',14,'Interpreter', 'none');
            ytickformat('%.1f');
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCfftCurve.png'))));
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCfftCurve.fig'))));
            
            
            
            
            close all
            
            bandTypes = {'ISA','Delta'};
            figure('units','normalized','outerposition',[0 0 1 1]);
            load('D:\OIS_Process\noVasculatureMask.mat')
            subplot_Index = 1;
            for ii= [1,4,5]
                for jj = 1:2
                    
                    powerMap = genvarname([traceSpecies{ii} '_' bandTypes{jj} '_powerMap_mouse']);
                    subplot(3,2,subplot_Index)
                    mask = xform_isbrain.*(double(leftMask)+double(rightMask));
                    mask(mask==0)=NaN;
                    eval([powerMap '=' powerMap '.*mask;']);
                    colormap jet
                    eval(['imagesc(log(' powerMap '))'])
                    cb = colorbar();
                    cb.Ruler.MinorTick = 'on';
                    if ii == 1
                        ylabel(cb,'log(M^2)','FontSize',12)
                    else
                        ylabel(cb,'log((\DeltaF/F)^2)','FontSize',12)
                    end
                    axis image off
                    title([ traceSpecies{ii} bandTypes{jj} ])
                    subplot_Index = subplot_Index+1;
                end
            end
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerMap.png'))));
            saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerMap.fig'))));
            
            
        end
        close all
    end
end