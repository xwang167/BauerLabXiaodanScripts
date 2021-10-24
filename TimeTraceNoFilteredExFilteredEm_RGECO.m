
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 14:18;%[3,5,7,8,10,11,12,13];%:450;
runs = 1:3;
nVy = 128;
nVx = 128;
datahb_timetrace_mice = NaN(2,750,5);
jrgeco1aCorr_timetrace_mice = NaN(750,5);
FADCorr_timetrace_mice= NaN(750,5);
ll = 1;
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
    saveDir_corrected = fullfile('X:\XW\NoFilteredEx-FilteredEm\RGECO_Timetrace',recDate);
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
    sessionInfo.fluorEmissionFile = "jRGECO1a_emission_580_593.txt";  
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
    datahb_timetrace_mouse = NaN(2,750,3);
    jrgeco1aCorr_timetrace_mouse = NaN(750,3);
    FADCorr_timetrace_mouse= NaN(750,3);
    timetraceName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_timetrace','.mat');
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        timetraceName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_timetrace','.mat');
        %         if ~exist(fullfile(saveDir,processedName),'file')
        load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1a','xform_FAD','ROI_NoGSR')
        iROI = reshape(ROI_NoGSR,1,[]);
        xform_datahb = reshape(xform_datahb,128*128,2,[]);
        xform_jrgeco1a = reshape(xform_jrgeco1a,128*128,[]);
        xform_FAD = reshape(xform_FAD,128*128,[]);
        
        datahb_timetrace = mean(xform_datahb(ROI_NoGSR,:,:),1);
        jrgeco1a_timetrace = mean(xform_jrgeco1a(ROI_NoGSR,:),1);
        FAD_timetrace = mean(xform_FAD(ROI_NoGSR,:),1);
        
        clear xform_datahb xform_jrgeco1a xform_FAD
        
        datahb_timetrace =  reshape(datahb_timetrace,1,1,2,[]);
        jrgeco1a_timetrace = reshape(jrgeco1a_timetrace,1,1,[]);
        FAD_timetrace = reshape(FAD_timetrace,1,1,[]);
        
        [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
        [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
        
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
        jrgeco1aCorr_timetrace = mouse.physics.correctHb(jrgeco1a_timetrace,datahb_timetrace,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
        
        
        [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
        [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.FADEmissionFile));
        
        dpIn_FAD = op_in_FAD.dpf/2;
        dpOut_FAD = op_out_FAD.dpf/2;
        
        FADCorr_timetrace = mouse.physics.correctHb(FAD_timetrace,datahb_timetrace,...
            [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
        

        datahb_timetrace = reshape(datahb_timetrace,2,[],10);
        jrgeco1aCorr_timetrace = reshape(jrgeco1aCorr_timetrace,[],10);
        FADCorr_timetrace = reshape(FADCorr_timetrace,[],10);
        
        baseline_datahb = mean(datahb_timetrace(:,1:sessionInfo.stimbaseline,:),2);
        baseline_datahb = repmat(baseline_datahb,1,length(FADCorr_timetrace),1);
        datahb_timetrace = datahb_timetrace-baseline_datahb;
        
        baseline_jrgeco1aCorr = mean(jrgeco1aCorr_timetrace(1:sessionInfo.stimbaseline,:),1);
        baseline_jrgeco1aCorr = repmat(baseline_jrgeco1aCorr,length(jrgeco1aCorr_timetrace),1);
        jrgeco1aCorr_timetrace = jrgeco1aCorr_timetrace-baseline_jrgeco1aCorr;
        
        baseline_FADCorr = mean(FADCorr_timetrace(1:sessionInfo.stimbaseline,:),1);
        baseline_FADCorr = repmat(baseline_FADCorr,length(FADCorr_timetrace),1);
        FADCorr_timetrace = FADCorr_timetrace-baseline_FADCorr;

        save(fullfile(saveDir_corrected,timetraceName),...
            'datahb_timetrace','jrgeco1aCorr_timetrace','FADCorr_timetrace')           
        
        datahb_timetrace_mean = mean(datahb_timetrace,3);
        jrgeco1aCorr_timetrace_mean = mean(jrgeco1aCorr_timetrace,2);
        FADCorr_timetrace_mean = mean(FADCorr_timetrace,2);
        
        datahb_timetrace_mouse(:,:,n) = datahb_timetrace_mean;
        jrgeco1aCorr_timetrace_mouse(:,n) = jrgeco1aCorr_timetrace_mean;
        FADCorr_timetrace_mouse(:,n) = FADCorr_timetrace_mean;
        
        figure
        yyaxis left
        ylabel('Hb(M)')
        plot((1:length(FADCorr_timetrace_mean))/25,datahb_timetrace_mean(1,:),'r-')
        hold on
        plot((1:length(FADCorr_timetrace_mean))/25,datahb_timetrace_mean(2,:),'b-')
        hold on
        ylim([-1*10^(-5) 2*10^(-5)])
        yyaxis right
        ylabel('Fluorescence(\DeltaF/F)')
        plot((1:length(FADCorr_timetrace_mean))/25,jrgeco1aCorr_timetrace_mean,'m-')
        hold on
        plot((1:length(FADCorr_timetrace_mean))/25,FADCorr_timetrace_mean,'g-')
        xlabel('Time(s)')
        ylim([-0.035 0.07])
        title(strcat(recDate,'-', mouseName,'-',sessionType,num2str(n),'-Ex w/o filter, Em w/ filter'))
        legend('HBO','HbR','jRGECO1a','FAD','location','northeast')
        output = fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)));
        saveas(gcf,strcat(output,'timetrace.fig'))
        saveas(gcf,strcat(output,'timetrace.png'))
        close all
    end
    datahb_timetrace_mouse = mean(datahb_timetrace_mouse,3);
    jrgeco1aCorr_timetrace_mouse = mean(jrgeco1aCorr_timetrace_mouse,2);
    FADCorr_timetrace_mouse = mean(FADCorr_timetrace_mouse,2);
    save(fullfile(saveDir_corrected,timetraceName_mouse),...
            'datahb_timetrace_mouse','jrgeco1aCorr_timetrace_mouse','FADCorr_timetrace_mouse') 
    
    figure
    yyaxis left
    ylabel('Hb(M)')
    plot((1:length(FADCorr_timetrace_mouse))/25,datahb_timetrace_mouse(1,:),'r-')
    hold on
    plot((1:length(FADCorr_timetrace_mouse))/25,datahb_timetrace_mouse(2,:),'b-')
    hold on
    ylim([-1*10^(-5) 2*10^(-5)])
    yyaxis right
    ylabel('Fluorescence(\DeltaF/F)')
    plot((1:length(FADCorr_timetrace_mouse))/25,jrgeco1aCorr_timetrace_mouse,'m-')
    hold on
    plot((1:length(FADCorr_timetrace_mouse))/25,FADCorr_timetrace_mouse,'g-')
    xlabel('Frequency(Hz)')
    ylim([-0.035 0.07])
    title(strcat(recDate,'-', mouseName,'-',sessionType,'-Ex w/o filter, Em w/ filter'))
    legend('HBO','HbR','jRGECO1a','FAD','location','northeast')
    
    output = fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-',sessionType));
    saveas(gcf,strcat(output,'timetrace.fig'))
    saveas(gcf,strcat(output,'timetrace.png'))
    close all
    
    datahb_timetrace_mice(:,:,ll) = datahb_timetrace_mouse;
    jrgeco1aCorr_timetrace_mice(:,ll) = jrgeco1aCorr_timetrace_mouse;
    FADCorr_timetrace_mice(:,ll)= FADCorr_timetrace_mouse;
    ll = ll + 1;
    
    clearvars -except excelFile excelRows runs  miceName ll datahb_timetrace_mice jrgeco1aCorr_timetrace_mice FADCorr_timetrace_mice recDate
end

datahb_timetrace_mice = mean(datahb_timetrace_mice,3);
jrgeco1aCorr_timetrace_mice = mean(jrgeco1aCorr_timetrace_mice,2);
FADCorr_timetrace_mice = mean(FADCorr_timetrace_mice,2);
save(fullfile('X:\XW\NoFilteredEx-FilteredEm\RGECO_Timetrace\cat',strcat(recDate,'-',miceName,'-stim')),...
            'datahb_timetrace_mice','jrgeco1aCorr_timetrace_mice','FADCorr_timetrace_mice') 

figure
yyaxis left
plot((1:length(FADCorr_timetrace_mice))/25,datahb_timetrace_mice(1,:),'r-')
hold on
plot((1:length(FADCorr_timetrace_mice))/25,datahb_timetrace_mice(2,:),'b-')
ylim([-1*10^(-5) 1.5*10^(-5)])
ylabel('Hb(M)')
yyaxis right
ylabel('Fluorescence(\DeltaF/F)')
hold on
plot((1:length(FADCorr_timetrace_mice))/25,jrgeco1aCorr_timetrace_mice,'m-')
hold on
plot((1:length(FADCorr_timetrace_mice))/25,FADCorr_timetrace_mice,'g-')
xlabel('Time(s)')
ylim([-0.035 0.0525])
title(strcat(recDate,'-RGECO-stim-Ex w/o filter, Em w/ filter'))
legend('HBO','HbR','jRGECO1a','FAD','location','northeast')
output = fullfile('X:\XW\NoFilteredEx-FilteredEm\RGECO_Timetrace\cat',strcat(recDate,'-',miceName,'-stim'));
saveas(gcf,strcat(output,'timetrace.fig'))
saveas(gcf,strcat(output,'timetrace.png'))
close all