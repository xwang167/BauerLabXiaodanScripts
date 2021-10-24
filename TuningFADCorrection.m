
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*

excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 12:16;%[3,5,7,8,10,11,12,13];%:450;
runs = 1:3;
nVy = 128;
nVx = 128;

FAD2Corr_timetrace_matrix_mice = NaN(750,5,10,10);
FADCorr_timetrace_matrix_mice = NaN(750,5,10,10);

FAD2Corr_timetrace_matrix_mice_mean = NaN(750,10,10);
FADCorr_timetrace_matrix_mice_mean = NaN(750,10,10);



ll = 1;
Alpha = 0.1:0.1:1;
Beta = 0.1:0.1:1;
miceName = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    miceName = strcat(miceName,'-',mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    saveDir_corrected = fullfile('X:\XW\CorrectFAD\WT_Timetrace',recDate);
    if ~exist(saveDir_corrected)
        mkdir(saveDir_corrected)
    end
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    systemType = excelRaw{5};
    
    if strcmp(sessionType,'stim')
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.stimduration = excelRaw{13};
    else
        sessionInfo.stimbaseline =0;
        sessionInfo.stimduration =0;
    end
    sessionInfo.hbSpecies = [3 4];
    sessionInfo.FADspecies = 1;
    sessionInfo.fluorSpecies = 2;
    sessionInfo.refChan = 4;
    sessionInfo.refChan_Green = 3;
    sessionInfo.fluorEmissionFile = "fad_emission_580_593.txt";
    sessionInfo.FADEmissionFile = "fad_emission_580_500.txt";
    systemInfo.LEDFiles = [
        "TwoCam_Mightex470_BP_Pol.txt",...
        "TwoCam_Mightex525_BP_Pol.txt",...
        "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
        "TwoCam_TL625_Pol_Longer593.txt"];
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    
    pkgDir = what('bauerParams');
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    %     badruns = str2num(excelRaw{19});
    %     runs(badruns) = [];
    
    FAD2Corr_timetrace_matirx_mouse = NaN(750,3,10,10);
    FADCorr_timetrace_matirx_mouse= NaN(750,3,10,10);
    
    FAD2Corr_timetrace_matirx_mouse_mean = NaN(750,10,10);
    FADCorr_timetrace_matirx_mouse_mean= NaN(750,10,10);
    
    timetraceName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_timetrace_correct','.mat');
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        timetraceName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_timetrace_correct','.mat');
        %         if ~exist(fullfile(saveDir,processedName),'file')
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1a','xform_FAD')
        load(fullfile('X:\XW\Paper\WT\RGECO Emission',recDate,processedName),'ROI_NoGSR')
        
        iROI = reshape(ROI_NoGSR,1,[]);
        
        xform_datahb = reshape(xform_datahb,128*128,2,[]);
        xform_jrgeco1a = reshape(xform_jrgeco1a,128*128,[]);
        xform_FAD = reshape(xform_FAD,128*128,[]);
        
        datahb_timetrace = mean(xform_datahb(ROI_NoGSR,:,:),1);
        FAD2_timetrace = mean(xform_jrgeco1a(ROI_NoGSR,:),1);
        FAD_timetrace = mean(xform_FAD(ROI_NoGSR,:),1);
        
        clear xform_jrgeco1a xform_FAD
        
        datahb_timetrace =  reshape(datahb_timetrace,1,1,2,[]);
        FAD2_timetrace = reshape(FAD2_timetrace,1,1,[]);
        FAD_timetrace = reshape(FAD_timetrace,1,1,[]);
        
        [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
        [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
        
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
        [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
        [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.FADEmissionFile));
        
        dpIn_FAD = op_in_FAD.dpf/2;
        dpOut_FAD = op_out_FAD.dpf/2;
        
        FADCorr_timetrace_matrix = NaN(750,length(0.1:0.1:1),length(0.1:0.1:1));
        FAD2Corr_timetrace_matrix = NaN(750,length(0.1:0.1:1),length(0.1:0.1:1));
        rms_Value = NaN(10,10);
        for ii = 1:10
            for jj = 1:10
                FADCorr_timetrace = correctHb_differentBeta(FAD_timetrace,datahb_timetrace,...
                    [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD,Alpha(ii),Beta(jj));
                
                FAD2Corr_timetrace = correctHb_differentBeta(FAD2_timetrace,datahb_timetrace,...
                    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,Alpha(ii),Beta(jj));
                
                FAD2Corr_timetrace = reshape(FAD2Corr_timetrace,[],10);
                FADCorr_timetrace = reshape(FADCorr_timetrace,[],10);
                
                baseline_FAD2Corr = mean(FAD2Corr_timetrace(1:125,:),1);
                baseline_FAD2Corr = repmat(baseline_FAD2Corr,length(FAD2Corr_timetrace),1);
                FAD2Corr_timetrace = FAD2Corr_timetrace-baseline_FAD2Corr;
                
                baseline_FADCorr = mean(FADCorr_timetrace(1:125,:),1);
                baseline_FADCorr = repmat(baseline_FADCorr,length(FADCorr_timetrace),1);
                FADCorr_timetrace = FADCorr_timetrace-baseline_FADCorr;
                
                FAD2Corr_timetrace_mean = mean(FAD2Corr_timetrace,2);
                FADCorr_timetrace_mean = mean(FADCorr_timetrace,2);
                rms_Value(ii,jj) = rms(FAD2Corr_timetrace_mean(125:250)-FADCorr_timetrace_mean(125:250));
                
                figure
                plot((1:750)/25,FAD2Corr_timetrace_mean,'m')
                hold on
                plot((1:750)/25,FADCorr_timetrace_mean, 'g')
                title(strcat(recDate,'-', mouseName,'-',sessionType,num2str(n),'-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),', rms = ',num2str(rms_Value(ii,jj))))
                xlabel('Time(s)')
                legend('FAD Cam2','FAD Cam1','location','southeast')
                ylabel('Fluorescence(\DeltaF/F)')
                ylim([-0.04 0.04])
                output = fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)));
                saveas(gcf,strcat(output,'timetrace_correct','-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),'.fig'))
                saveas(gcf,strcat(output,'timetrace_correct,-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),'.png'))
                close all
                FADCorr_timetrace_matrix(:,ii,jj) = FAD2Corr_timetrace_mean;
                FAD2Corr_timetrace_matrix(:,ii,jj) = FADCorr_timetrace_mean;
                
                FAD2Corr_timetrace_matirx_mouse(:,n,ii,jj) = FAD2Corr_timetrace_mean;
                FADCorr_timetrace_matirx_mouse(:,n,ii,jj) = FADCorr_timetrace_mean;
            end
            
        end
        figure
        imagesc(rms_Value)
        title(strcat(recDate,'-', mouseName,'-',sessionType,num2str(n),', RMS'))
        xticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
        yticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
        ylabel('Alpha')
        xlabel('Beta')
        save(fullfile(saveDir_corrected,timetraceName),...
            'FADCorr_timetrace_matrix','FAD2Corr_timetrace_matrix','rms_Value')
    end

    rms_Value_mouse = NaN(10,10);
    for ii = 1:10
        for jj = 1:10
            
            FAD2Corr_timetrace_matirx_mouse_mean(:,ii,jj) = squeeze(mean(FAD2Corr_timetrace_matirx_mouse(:,:,ii,jj),2));
            FADCorr_timetrace_matirx_mouse_mean(:,ii,jj) = squeeze(mean(FADCorr_timetrace_matirx_mouse(:,:,ii,jj),2));
            rms_Value_mouse(ii,jj) = rms(FAD2Corr_timetrace_matirx_mouse_mean(125:250,ii,jj)-FADCorr_timetrace_matirx_mouse_mean(125:250,ii,jj));
            figure
            plot((1:750)/25,FAD2Corr_timetrace_matirx_mouse_mean(:,ii,jj),'m')
            hold on
            plot((1:750)/25,FADCorr_timetrace_matirx_mouse_mean(:,ii,jj), 'g')
            title(strcat(recDate,'-', mouseName,'-',sessionType,'-alpha = ',num2str(Alpha(ii)), ',beta = ',num2str(Beta(jj)),', rms = ',num2str(rms_Value_mouse(ii,jj))))
            xlabel('Time(s)')
            legend('FAD Cam2','FAD Cam1','location','southeast')
            ylabel('Fluorescence(\DeltaF/F)')
            ylim([-0.04 0.04])
            ylabel('Alpha')
            xlabel('Beta')
            output = fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-',sessionType));
            saveas(gcf,strcat(output,'timetrace_correct','-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),'.fig'))
            saveas(gcf,strcat(output,'timetrace_correct','-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),'.png'))
            close all
            FAD2Corr_timetrace_matrix_mice(:,ll,ii,jj) = FAD2Corr_timetrace_matirx_mouse_mean(:,ii,jj);
            FADCorr_timetrace_matrix_mice(:,ll,ii,jj)= FADCorr_timetrace_matirx_mouse_mean(:,ii,jj);
        end
    end
    figure
    imagesc(rms_Value_mouse)
    title(strcat(recDate,'-', mouseName,'-',sessionType,',RMS'))
    xticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
    yticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
    output = fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-',sessionType));
    saveas(gcf,strcat(output,'timetrace_correct_rms.fig'))
    saveas(gcf,strcat(output,'timetrace_correct_rms.png'))
    save(fullfile(saveDir_corrected,timetraceName_mouse),...
        'FAD2Corr_timetrace_matirx_mouse_mean','FADCorr_timetrace_matirx_mouse_mean','rms_Value_mouse')
    ll = ll + 1;
end


% FAD2Corr_timetrace_matrix_mice_mean = squeeze(mean(FAD2Corr_timetrace_mice,2));
% FADCorr_timetrace_matrix_mice_mean = squeeze(mean(FADCorr_timetrace_mice,2));

rms_Value_mice = NaN(10,10);
for ii = 1:10
    for jj = 1:10
        FAD2Corr_timetrace_matrix_mice_mean(:,ii,jj) = squeeze(mean(FAD2Corr_timetrace_matrix_mice(:,:,ii,jj),2));
        FADCorr_timetrace_matrix_mice_mean(:,ii,jj) = squeeze(mean(FADCorr_timetrace_matrix_mice(:,:,ii,jj),2));
        rms_Value_mice(ii,jj) = rms(FAD2Corr_timetrace_matrix_mice_mean(125:250,ii,jj)-FADCorr_timetrace_matrix_mice_mean(125:250,ii,jj));
        figure
        plot((1:750)/25,FAD2Corr_timetrace_matrix_mice_mean(:,ii,jj),'m')
        hold on
        plot((1:750)/25,FADCorr_timetrace_matrix_mice_mean(:,ii,jj), 'g')
        title(strcat(recDate,'-WT-',sessionType,'-alpha = ',...
            num2str(Alpha(ii)), ',beta = ',num2str(Beta(jj)),', rms = ',num2str(rms_Value_mice(ii,jj))))
        xlabel('Time(s)')
        legend('FAD Cam2','FAD Cam1','location','southeast')
        ylabel('Fluorescence(\DeltaF/F)')
        ylim([-0.04 0.04])
        output = fullfile('X:\XW\CorrectFAD\WT_Timetrace\cat',strcat(recDate,'-',miceName,'-',sessionType));
        saveas(gcf,strcat(output,'timetrace_correct','-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),'.fig'))
        saveas(gcf,strcat(output,'timetrace_correct','-alpha = ',num2str(Alpha(ii)),',beta = ',num2str(Beta(jj)),'.png'))
        close all
    end
end
imagesc(rms_Value_mice)
title(strcat(recDate,'-WT-',sessionType,', RMS'))
xticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
yticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
ylabel('Alpha')
xlabel('Beta')
output = fullfile('X:\XW\CorrectFAD\WT_Timetrace\cat',strcat(recDate,'-',miceName,'-',sessionType));
saveas(gcf,strcat(output,'timetrace_correct_rms.fig'))
saveas(gcf,strcat(output,'timetrace_correct_rms.png'))
save(fullfile('X:\XW\CorrectFAD\WT_Timetrace\cat',strcat(recDate,'-',miceName,'-stim')),...
    'FAD2Corr_timetrace_matrix_mice_mean','FADCorr_timetrace_matrix_mice_mean','rms_Value_mice')