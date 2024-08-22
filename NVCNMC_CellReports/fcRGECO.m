
close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = 236;%[181,183,185,228,232,236,195,202,204,230,234,240];

runs = 1;
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
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    load(fullfile(maskDir_new,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        if strcmp(sessionType,'fc')
            disp(strcat('fc QC check on ', processedName))
            
            nameString = fullfile(saveDir,visName);
            
            
            load(fullfile(saveDir, processedName),'xform_FADCorr','xform_FAD','xform_jrgeco1aCorr','xform_jrgeco1a','xform_isbrain')
            sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
            sessionInfo.bandtype_Delta = {"Delta",0.4,4};                disp('calculate fc')
            refseeds=GetReferenceSeeds;
            %refseeds = refseeds(1:14,:);
            refseeds(3,1) = 42;
            refseeds(3,2) = 88;
            refseeds(4,1) = 87;
            refseeds(4,2) = 88;
            refseeds(9,1) = 18;
            refseeds(9,2) = 66;
            refseeds(10,1) = 111;
            refseeds(10,2) = 66;
                   
            [R_FAD_ISA,Rs_FAD_ISA] = QCcheck_CalcRRs(refseeds,double(xform_FAD)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
            [R_FAD_Delta,Rs_FAD_Delta] = QCcheck_CalcRRs(refseeds,double(xform_FAD)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
            
            clear xform_FAD
            
            save(fullfile(saveDir, processedName),'R_FAD_ISA','Rs_FAD_ISA','R_FAD_Delta','Rs_FAD_Delta','-append')
            
            
            
            QCcheck_fcVis(refseeds,R_FAD_ISA, Rs_FAD_ISA,'FAD','g','ISA',saveDir,visName,false,xform_isbrain)
            
            QCcheck_fcVis(refseeds,R_FAD_Delta, Rs_FAD_Delta,'FAD','g','Delta',saveDir,visName,false,xform_isbrain)
            
            [R_FADCorr_ISA,Rs_FADCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
            [R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
            
            clear xform_FADCorr
            
            save(fullfile(saveDir, processedName),'R_FADCorr_ISA','Rs_FADCorr_ISA','R_FADCorr_Delta','Rs_FADCorr_Delta','-append')
            
            
            
            QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
            
            QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
            
                        [R_jrgeco1a_ISA,Rs_jrgeco1a_ISA] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
            [R_jrgeco1a_Delta,Rs_jrgeco1a_Delta] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
            
            clear xform_jrgeco1a
            
            save(fullfile(saveDir, processedName),'R_jrgeco1a_ISA','Rs_jrgeco1a_ISA','R_jrgeco1a_Delta','Rs_jrgeco1a_Delta','-append')
            
            
            
            QCcheck_fcVis(refseeds,R_jrgeco1a_ISA, Rs_jrgeco1a_ISA,'jrgeco1a','m','ISA',saveDir,visName,false,xform_isbrain)
            
            QCcheck_fcVis(refseeds,R_jrgeco1a_Delta, Rs_jrgeco1a_Delta,'jrgeco1a','m','Delta',saveDir,visName,false,xform_isbrain)
            
            [R_jrgeco1aCorr_ISA,Rs_jrgeco1aCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
            [R_jrgeco1aCorr_Delta,Rs_jrgeco1aCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
            
            clear xform_jrgeco1aCorr
            
            save(fullfile(saveDir, processedName),'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','-append')
            
            
            
            QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
            
            QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
            
        end
    end
end