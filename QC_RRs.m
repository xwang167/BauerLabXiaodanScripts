close all;clear all;clc
import mouse.*
excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = [3,5,7,8,10,11];%:450;
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
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    maskDir = saveDir;
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr','xform_datahb')
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
                            'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta','-append')
%         QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
%         QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
%         QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',saveDir,visName,false,xform_isbrain)
%         
%         QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
%         QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
%         QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',saveDir,visName,false,xform_isbrain)
        close all
        
    end
end
