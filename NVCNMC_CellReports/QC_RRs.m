close all;clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [ 202 195 204 230 234 240]; %[ 181 183 185  228 232 236 ];%[3,5,7,8,10,11];%:450;
runs = 1:3;
isDetrend = 1;
nVy = 128;
nVx = 128;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-newOrder');
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_newOrder','.mat');
        load(fullfile(saveDir, strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat')),'xform_FADCorr','xform_jrgeco1aCorr','xform_datahb')
        sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
        sessionInfo.bandtype_Delta = {"Delta",0.4,4};
        total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
        
        
        xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
        xform_FADCorr = real(double(xform_FADCorr));
        total = real(double(total));
        xform_datahb = real(double(xform_datahb));
        disp('calculate fc')
        refseeds=GetReferenceSeeds;
        %refseeds = refseeds(1:14,:);
        
        [R_jrgeco1aCorr_ISA,Rs_jrgeco1aCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
        [R_FADCorr_ISA,Rs_FADCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
        [R_total_ISA,Rs_total_ISA] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
        
        [R_jrgeco1aCorr_Delta,Rs_jrgeco1aCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        [R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        [R_total_Delta,Rs_total_Delta] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
        
        clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
        save(fullfile(saveDir, processedName),'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
            'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta')
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',saveDir,visName,false,xform_isbrain)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',saveDir,visName,false,xform_isbrain)
        close all
        
    end
end
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
        goodRuns = str2num(excelRaw{18});
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            systemInfo.numLEDs = 3;
        end
        maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
        if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')))
            
            load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor','.mat')),'xform_isbrain');
            
        else
            maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
            load(fullfile(saveDir,maskName), 'xform_isbrain')
        end
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        if isDetrend
            processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed_newOrder','.mat');
            visName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed');
        else
            processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_NoDetrend','.mat');
            visName = strcat(recDate,'-',mouseName,'-',sessionType,'_NoDetrend');
        end
        
        R_total_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
        R_total_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
        Rs_total_Delta_mouse = zeros(16,16,length_runs);
        Rs_total_ISA_mouse = zeros(16,16,length_runs);
        
        
        
        
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            R_gcampCorr_Delta_mouse = zeros(info.nVy,info.nVx,14,length_runs);
            R_gcampCorr_ISA_mouse  = zeros(info.nVy,info.nVx,14,length_runs);
            Rs_gcampCorr_Delta_mouse = zeros(14,14,length_runs);
            Rs_gcampCorr_ISA_mouse = zeros(14,14,length_runs);
            powerdata_average_gcampCorr_mouse = [];
            
            powerdata_gcampCorr_mouse = [];
            gcampCorr_Delta_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
            gcampCorr_ISA_powerMap_mouse = zeros(info.nVy,info.nVx,length_runs);
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            R_jrgeco1aCorr_Delta_mouse = zeros(info.nVy,info.nVx,16,length_runs);
            R_jrgeco1aCorr_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
            Rs_jrgeco1aCorr_Delta_mouse = zeros(16,16,length_runs);
            Rs_jrgeco1aCorr_ISA_mouse = zeros(16,16,length_runs);
            
            R_FADCorr_Delta_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
            R_FADCorr_ISA_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
            Rs_FADCorr_Delta_mouse = zeros(16,16,length_runs);
            Rs_FADCorr_ISA_mouse = zeros(16,16,length_runs);
            
        end
        for n = runs
            
            
            disp('loading processed data')
            
            %             if isDetrend
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_newOrder','.mat');
            %             else
            %                 processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
            %             end
            if strcmp(sessionType,'fc')
                if strcmp(char(sessionInfo.mouseType),'gcamp6f')
                    load(fullfile(saveDir, processedName),'R_gcamp6fCorr_Delta','R_gcamp6fCorr_ISA','R_total_Delta','R_total_ISA','Rs_gcamp6fCorr_Delta','Rs_gcamp6fCorr_ISA','Rs_total_Delta','Rs_total_ISA','powerdata_average_deoxy','powerdata_deoxy','powerdata_oxy','powerdata_gcamp6fCorr','powerdata_total','gcamp6fCorr_Delta_powerMap','gcamp6fCorr_ISA_powerMap','total_Delta_powerMap','total_ISA_powerMap','hz','hz2')
                    R_gcampCorr_Delta_mouse(:,:,:,n) = R_gcamp6fCorr_Delta;
                    R_gcampCorr_ISA_mouse(:,:,:,n) = R_gcamp6fCorr_ISA;
                    R_total_Delta_mouse(:,:,:,n) = R_total_Delta;
                    R_total_ISA_mouse(:,:,:,n) = R_total_ISA;
                    
                    Rs_gcampCorr_Delta_mouse(:,:,n) = Rs_gcamp6fCorr_Delta;
                    Rs_gcampCorr_ISA_mouse(:,:,n) = Rs_gcamp6fCorr_ISA;
                    Rs_total_Delta_mouse(:,:,n) = Rs_total_Delta;
                    Rs_total_ISA_mouse(:,:,n) = Rs_total_ISA;
                    
                    %                     if ismember(n,goodRuns)
                    %                         powerdata_average_gcampCorr_mouse = cat(1,powerdata_average_gcampCorr_mouse,squeeze(powerdata_average_gcamp6fCorr));
                    %                         powerdata_average_oxy_mouse = cat(1,powerdata_average_oxy_mouse,squeeze(powerdata_average_oxy));
                    %                         powerdata_average_deoxy_mouse = cat(1,powerdata_average_deoxy_mouse,squeeze(powerdata_average_deoxy));
                    %                         powerdata_average_total_mouse = cat(1,powerdata_average_total_mouse,squeeze(powerdata_average_total));
                    %
                    %                         powerdata_gcampCorr_mouse = cat(1,powerdata_gcampCorr_mouse,squeeze(powerdata_gcamp6fCorr));
                    %                         powerdata_oxy_mouse = cat(1,powerdata_oxy_mouse,squeeze(powerdata_oxy));
                    %                         powerdata_deoxy_mouse = cat(1,powerdata_deoxy_mouse,squeeze(powerdata_deoxy));
                    %                         powerdata_total_mouse = cat(1,powerdata_total_mouse,squeeze(powerdata_total));
                    %                    end
                    %
                    %                     gcampCorr_Delta_powerMap_mouse(:,:,n) = gcamp6fCorr_Delta_powerMap;
                    %                     gcampCorr_ISA_powerMap_mouse(:,:,n) = gcamp6fCorr_ISA_powerMap;
                    %                     total_Delta_powerMap_mouse(:,:,n) = total_Delta_powerMap;
                    %                     total_ISA_powerMap_mouse(:,:,n) = total_ISA_powerMap;
                elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
                    load(fullfile(saveDir, processedName),'R_total_Delta','R_total_ISA','R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','R_FADCorr_Delta','R_FADCorr_ISA',...
                        'Rs_total_Delta','Rs_total_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA', 'Rs_FADCorr_Delta','Rs_FADCorr_ISA',...
                        'total_Delta_powerMap','total_ISA_powerMap','jrgeco1aCorr_Delta_powerMap','jrgeco1aCorr_ISA_powerMap', 'FADCorr_Delta_powerMap','FADCorr_ISA_powerMap',...
                        'hz')
                    
                    R_total_Delta_mouse(:,:,:,n) = R_total_Delta;
                    R_total_ISA_mouse(:,:,:,n) = R_total_ISA;
                    
                    Rs_total_Delta_mouse(:,:,n) = Rs_total_Delta;
                    Rs_total_ISA_mouse(:,:,n) = Rs_total_ISA;
                    
                    
                    R_jrgeco1aCorr_Delta_mouse(:,:,:,n) = R_jrgeco1aCorr_Delta;
                    R_jrgeco1aCorr_ISA_mouse(:,:,:,n) = R_jrgeco1aCorr_ISA;
                    Rs_jrgeco1aCorr_Delta_mouse(:,:,n) = Rs_jrgeco1aCorr_Delta;
                    Rs_jrgeco1aCorr_ISA_mouse(:,:,n) = Rs_jrgeco1aCorr_ISA;
                    
                    
                    
                    R_FADCorr_Delta_mouse(:,:,:,n) = R_FADCorr_Delta;
                    R_FADCorr_ISA_mouse(:,:,:,n) = R_FADCorr_ISA;
                    Rs_FADCorr_Delta_mouse(:,:,n) = Rs_FADCorr_Delta;
                    Rs_FADCorr_ISA_mouse(:,:,n) = Rs_FADCorr_ISA;
                    
                end
            end
        end
        
        
        R_total_Delta_mouse  = mean(R_total_Delta_mouse,4);
        R_total_ISA_mouse  = mean(R_total_ISA_mouse,4);
        Rs_total_Delta_mouse = mean(Rs_total_Delta_mouse,3);
        Rs_total_ISA_mouse = mean(Rs_total_ISA_mouse,3);
        
        
        
        disp(char(['QC check on ', processedName_mouse]))
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            R_gcampCorr_Delta_mouse = mean(R_gcampCorr_Delta_mouse,4);
            R_gcampCorr_ISA_mouse  = mean(R_gcampCorr_ISA_mouse,4);
            Rs_gcampCorr_Delta_mouse = mean(Rs_gcampCorr_Delta_mouse,3);
            Rs_gcampCorr_ISA_mouse = mean(Rs_gcampCorr_ISA_mouse,3);
            %             powerdata_average_gcampCorr_mouse = mean(powerdata_average_gcampCorr_mouse,1);
            %             powerdata_gcampCorr_mouse = mean(powerdata_gcampCorr_mouse,1);
            %             gcampCorr_Delta_powerMap_mouse = mean(gcampCorr_Delta_powerMap_mouse,3);
            %             gcampCorr_ISA_powerMap_mouse = mean(gcampCorr_ISA_powerMap_mouse,3);
            save(fullfile(saveDir, processedName_mouse),'R_gcampCorr_Delta_mouse','R_gcampCorr_ISA_mouse','R_total_Delta_mouse','R_total_ISA_mouse','Rs_gcampCorr_Delta_mouse','Rs_gcampCorr_ISA_mouse','Rs_total_Delta_mouse','Rs_total_ISA_mouse','powerdata_average_deoxy_mouse','powerdata_average_oxy_mouse','powerdata_average_gcampCorr_mouse','powerdata_average_total_mouse','powerdata_deoxy_mouse','powerdata_oxy_mouse','powerdata_gcampCorr_mouse','powerdata_total_mouse','gcampCorr_Delta_powerMap_mouse','gcampCorr_ISA_powerMap_mouse','total_Delta_powerMap_mouse','total_ISA_powerMap_mouse','hz','hz2')
            
            refseeds=GetReferenceSeeds;
            refseeds = refseeds(1:14,:);
            
            
            QCcheck_fcVis_v1(refseeds,R_total_ISA_mouse, double(Rs_total_ISA_mouse),R_gcampCorr_ISA_mouse,double(Rs_gcampCorr_ISA_mouse), 'gcamp6f','ISA',saveDir,visName,false)
            QCcheck_fcVis_v1(refseeds,R_total_Delta_mouse, double(Rs_total_Delta_mouse),R_gcampCorr_Delta_mouse, double(Rs_gcampCorr_Delta_mouse), 'gcamp6f','Delta',saveDir,visName,false)
            close all
            traceSpecies = {'oxy','gcampCorr','deoxy','total'};
            traceColor = {'r', 'g','b','k'};
            
            for ii = 1:4
                
                fftCurve = genvarname(['powerdata_average_' traceSpecies{ii} '_mouse']);
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
                    %                     mask = xform_isbrain.*(double(leftMask)+double(rightMask));
                    %                     mask(mask==0)=NaN;
                    %                     eval([powerMap '=' powerMap '.*mask;']);
                    
                    
                    colormap jet
                    eval(['imagesc(log10(' powerMap '.*xform_isbrain))'])
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
            
            R_FADCorr_Delta_mouse = mean(R_FADCorr_Delta_mouse,4);
            R_FADCorr_ISA_mouse  = mean(R_FADCorr_ISA_mouse,4);
            Rs_FADCorr_Delta_mouse = mean(Rs_FADCorr_Delta_mouse,3);
            Rs_FADCorr_ISA_mouse = mean(Rs_FADCorr_ISA_mouse,3);
            save(fullfile(saveDir, processedName_mouse),'R_total_ISA_mouse','R_jrgeco1aCorr_ISA_mouse','R_FADCorr_ISA_mouse',...
                'R_total_Delta_mouse','R_jrgeco1aCorr_Delta_mouse','R_FADCorr_Delta_mouse',...
                'Rs_total_ISA_mouse','Rs_jrgeco1aCorr_ISA_mouse','Rs_FADCorr_ISA_mouse',...
                'Rs_total_Delta_mouse','Rs_jrgeco1aCorr_Delta_mouse','Rs_FADCorr_Delta_mouse')
            %
            
            visName = strcat(recDate,'-',mouseName,'-',sessionType,'-newOrder');
            
                    refseeds=GetReferenceSeeds;
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mouse, Rs_jrgeco1aCorr_ISA_mouse,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_FADCorr_ISA_mouse, Rs_FADCorr_ISA_mouse,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_ISA_mouse, Rs_total_ISA_mouse,'total','k','ISA',saveDir,visName,false,xform_isbrain)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mouse, Rs_jrgeco1aCorr_Delta_mouse,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_FADCorr_Delta_mouse, Rs_FADCorr_Delta_mouse,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_Delta_mouse, Rs_total_Delta_mouse,'total','k','Delta',saveDir,visName,false,xform_isbrain)
        end
        
        %

        
        
        
    end
    close all
end

