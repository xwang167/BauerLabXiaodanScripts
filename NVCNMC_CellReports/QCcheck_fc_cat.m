close all;clearvars;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

isDetrend = false;

nVx = 128;
nVy = 128;
%
excelRows = 118;

runs = 1:6;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{11};
    rawdataloc = excelRaw{3};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{13};
    systemType =excelRaw{5};
    sessionInfo.darkFrameNum = excelRaw{11};
    sessionInfo.framerate = excelRaw{7};
    if strcmp(char(sessionInfo.mouseType),'WT')
        systemInfo.numLEDs = 2;
    elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
        systemInfo.numLEDs = 3;
    end
    
    ISA = [0.009,0.08];
    Delta = [0.4,4];
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMarks','.mat');
    load(fullfile(saveDir,maskName), 'isbrain','xform_isbrain');
    xform_isbrain(xform_isbrain ==2)=1;
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    if strcmp(sessionType,'fc')
        xform_datahb_cat = [];
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            xform_gcampCorr_cat = [];
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            xform_jrgeco1aCorr_cat = [];
        end
        if isDetrend
        visName_cat = strcat(recDate,'-',mouseName,'-',sessionType,'_cat');
        else
            visName_cat = strcat(recDate,'-',mouseName,'-',sessionType,'NoDetrend_cat');
        end
    end
    xform_datahb_cat = single(zeros(128,128,2,60000));
    lastTInd = 0;
    for n = runs
        disp(['Run # ' num2str(n)]);
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'xform_datahb')
        xform_datahb = single(xform_datahb);
        xform_datahb_cat(:,:,:,lastTInd+1:lastTInd+size(xform_datahb,4)) = xform_datahb;
        
        lastTInd = lastTInd + size(xform_datahb,4);
        clear xform_datahb;
        
    end
    xform_datahb_cat = xform_datahb_cat(:,:,:,1:lastTInd);
    xform_isbrain = single(xform_isbrain);
    [R_oxy_ISA,Rs_oxy_ISA,oxy_ISA_fftMap] = fluor.calculateRRsfftMap(squeeze(xform_datahb_cat(:,:,1,:)),'oxy',xform_isbrain,sessionInfo.framerate,ISA,128,128);
    [R_oxy_Delta,Rs_oxy_Delta,oxy_Delta_fftMap] = fluor.calculateRRsfftMap(double(squeeze(xform_datahb_cat(:,:,1,:))),'oxy',xform_isbrain,sessionInfo.framerate,Delta,128,128);
      [R_oxy,Rs_oxy,oxy_fftMap] = fluor.calculateRRsfftMap(double(squeeze(xform_datahb_cat(:,:,1,:))),'oxy',xform_isbrain,sessionInfo.framerate,[],128,128);
  
    fdata_oxy = fluor.calculatefftCurve(double(squeeze(xform_datahb_cat(:,:,1,:))),xform_isbrain,sessionInfo.framerate,128,128);
    fdata_deoxy = fluor.calculatefftCurve(double(squeeze(xform_datahb_cat(:,:,2,:))),xform_isbrain,sessionInfo.framerate,128,128);
    [fdata_total,hz] = fluor.calculatefftCurve(double(squeeze(xform_datahb_cat(:,:,1,:)))+double(squeeze(xform_datahb_cat(:,:,2,:))),xform_isbrain,sessionInfo.framerate,128,128);
    clear xform_dathb_cat
    if exist(strcat(fullfile(saveDir,visName_cat),".mat"),'file')
        save(strcat(fullfile(saveDir,visName_cat),".mat"),'R_oxy_ISA' ,'Rs_oxy_ISA' ,'oxy_ISA_fftMap', 'R_oxy_Delta', 'Rs_oxy_Delta', 'oxy_Delta_fftMap', 'fdata_oxy', 'fdata_deoxy', 'fdata_total','-append')
    else
        save(strcat(fullfile(saveDir,visName_cat),".mat"),'R_oxy_ISA' ,'Rs_oxy_ISA' ,'oxy_ISA_fftMap', 'R_oxy_Delta', 'Rs_oxy_Delta', 'oxy_Delta_fftMap', 'fdata_oxy', 'fdata_deoxy', 'fdata_total')
    end
    for n = runs
        if isDetrend
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        else
             processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
   
        end
        if strcmp(char(sessionInfo.mouseType),'gcamp6f')
            load(fullfile(saveDir, processedName),'xform_gcampCorr')
            
            xform_gcampCorr_cat = cat(3,xform_gcampCorr_cat,xform_gcampCorr);
            clear xform_gcampCorr
        elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
            
            load(fullfile(saveDir, processedName),'xform_jrgeco1aCorr')
            xform_jrgeco1aCorr_cat = cat(3,xform_jrgeco1aCorr_cat,xform_jrgeco1aCorr);
            clear xform_jrgeco1aCorr
        end
    end
    
    if strcmp(char(sessionInfo.mouseType),'gcamp6f')
        [R_gcampCorr_ISA,Rs_gcampCorr_ISA,gcampCorr_ISA_fftMap] = fluor.calculateRRsfftMap(double(xform_gcampCorr_cat),'gcampCorr',xform_isbrain,sessionInfo.framerate,ISA,128,128);
        [R_gcampCorr_Delta,Rs_gcampCorr_Delta,gcampCorr_Delta_fftMap] = fluor.calculateRRsfftMap(double(xform_gcampCorr_cat),'gcampCorr',xform_isbrain,sessionInfo.framerate,Delta,128,128);
         [R_gcampCorr,Rs_gcampCorr,gcampCorr_fftMap,refseeds] = fluor.calculateRRsfftMap(double(xform_gcampCorr_cat),'gcampCorr',xform_isbrain,sessionInfo.framerate,[],128,128);
        
        [fdata_gcampCorr,Hz] = fluor.calculatefftCurve(double(xform_gcampCorr_cat),xform_isbrain,sessionInfo.framerate,128,128);
        clear xform_gcampCorr_cat
        if exist(strcat(fullfile(saveDir,visName_cat),".mat"),'file')
            save(strcat(fullfile(saveDir,visName_cat),".mat"),'R_gcampCorr_ISA' ,'Rs_gcampCorr_ISA' ,'gcampCorr_ISA_fftMap', 'R_gcampCorr_Delta', 'Rs_gcampCorr_Delta', 'gcampCorr_Delta_fftMap', 'fdata_gcampCorr', '-append')
        else
            save(strcat(fullfile(saveDir,visName_cat),".mat"),'R_gcampCorr_ISA' ,'Rs_gcampCorr_ISA' ,'gcampCorr_ISA_fftMap', 'R_gcampCorr_Delta', 'Rs_gcampCorr_Delta', 'gcampCorr_Delta_fftMap', 'fdata_gcampCorr')
        end
        QCcheck_fcVis_v1(refseeds,R_oxy_ISA, Rs_oxy_ISA,R_gcampCorr_ISA,Rs_gcampCorr_ISA, 'gcamp6f','ISA',saveDir,visName_cat)
        QCcheck_fcVis_v1(refseeds,R_oxy_Delta, Rs_oxy_Delta,R_gcampCorr_Delta, Rs_gcampCorr_Delta, 'gcamp6f','Delta',saveDir,visName_cat)
           QCcheck_fcVis_v1(refseeds,R_oxy, Rs_oxy,R_gcampCorr, Rs_gcampCorr, 'gcamp6f','Whole',saveDir,visName_cat)
      
        traceSpecies = {'oxy','gcampCorr','deoxy','total'};
        traceColor = {'r', 'g','b','k'};
        figure
        subplot('position', [0.12 0.12 0.8 0.8])
        
        for ii = 1:4
            
            fftCurve = genvarname(['fdata_' traceSpecies{ii}]);
            if ii==2
                yyaxis left
                set(gca, 'YScale', 'log')
                ylabel('G6(\DeltaF^2/Hz)')
                eval(['ylim([-inf 1.1*max(' fftCurve ')])'])
            else
                yyaxis right
                ylabel('Hb(M^2/Hz)')
            end
            eval(['p' num2str(ii) '= loglog(hz,' fftCurve ',traceColor{ii});']);
            hold on
        end
        legend(traceSpecies{2},'HbO_2','HbR','Total')
        xlabel('Frequency (Hz)')
        title(strcat(visName_cat,'  FFT Normalized Data'),'fontsize',14);
        ytickformat('%.1f');
        saveas(gcf,(fullfile(saveDir,strcat(visName_cat,'_FCfftCurve.jpg'))));
        close all
        
        
        
        bandTypes = {'ISA','Delta'};
        figure;
        load('D:\OIS_Process\noVasculatureMask.mat')
        subplot_Index = 1;
        for ii=1:2
            for jj = 1:2
                
                fftMap = genvarname([traceSpecies{ii} '_' bandTypes{jj} '_fftMap']);
                
                subplot(2,2,subplot_Index)
                mask = xform_isbrain.*(double(leftMask)+double(rightMask));
                mask(mask==0)=NaN;
                eval([fftMap '=' fftMap '.*mask;']);
                
                
                    colormap jet
            eval(['imagesc(log(' fftMap '))'])
            cb = colorbar();
            cb.Ruler.MinorTick = 'on';
            if ii == 1
                ylabel(cb,'log(M^2)','FontSize',12)
            elseif ii==2
                ylabel(cb,'log(\DeltaF^2)','FontSize',12)
            end
            axis image off
            title([ traceSpecies{ii} bandTypes{jj} ])
                
               
                subplot_Index = subplot_Index+1;
                
                
            end
        end
        saveas(gcf,(fullfile(saveDir,strcat(visName_cat,'_FCfftMap.jpg'))));
        
    elseif strcmp(char(sessionInfo.mouseType),'jrgeco1a')
        [R_rgecoCorr_ISA,Rs_rgecoCorr_ISA,rgecoCorr_ISA_fftMap] = calculateRRsfftMap(double(xform_rgecoCorr_cat),'rgecoCorr',xform_isbrain,sessionInfo.framerate,ISA);
        [R_rgecoCorr_Delta,Rs_rgecoCorr_Delta,rgecoCorr_Delta_fftMap,refseeds] = calculateRRsfftMap(double(xform_rgecoCorr_cat),'rgecoCorr',xform_isbrain,sessionInfo.framerate,Delta);
        [fdata_rgecoCorr,hz] = calculatefftCurve(double(xform_rgecoCorr_cat),xform_isbrain);
        clear xform_rgecoCorr_cat
        if exist(strcat(fullfile(saveDir,visName_cat),".mat"),'file')
            save(strcat(fullfile(saveDir,visName_cat),".mat"),'R_rgecoCorr_ISA' ,'Rs_rgecoCorr_ISA' ,'rgecoCorr_ISA_fftMap', 'R_rgecoCorr_Delta', 'Rs_rgecoCorr_Delta', 'rgecoCorr_Delta_fftMap', 'fdata_rgecoCorr', '-append')
        else
            save(strcat(fullfile(saveDir,visName_cat),".mat"),'R_rgecoCorr_ISA' ,'Rs_rgecoCorr_ISA' ,'rgecoCorr_ISA_fftMap', 'R_rgecoCorr_Delta', 'Rs_rgecoCorr_Delta', 'rgecoCorr_Delta_fftMap', 'fdata_rgecoCorr')
        end
    end
    
end



