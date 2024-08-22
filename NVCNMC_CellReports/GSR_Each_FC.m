close all;clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = 438:439;
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
    maskName_new = strcat(recDate,'-N8M864-opto3-LandmarksAndMask','.mat');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    % maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-dataFluor','.mat');
    %     maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskDir = saveDir;
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %load(fullfile(rawdataloc,recDate,maskName_new), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir,processedName),'file')
            C = who('-file',fullfile(saveDir,processedName));
            isQCGot = false;
            %                 for  k=1:length(C)
            %                     if strcmp(C(k),'powerdata_oxy')
            %                         isQCGot = true;
            %                     end
            %                 end
            if ~isQCGot
                disp('loading processed data')
                load(fullfile(saveDir,processedName),'xform_datahb')
                %                     for ii = 1:size(xform_datahb,4)
                %                         xform_isbrain(isinf(real(xform_datahb(:,:,1,ii)))) = 0;
                %                         xform_isbrain(isnan(real(xform_datahb(:,:,1,ii)))) = 0;
                %
                %                     end
                disp(strcat('fc QC check on ', processedName))
                
                if strcmp(sessionInfo.mouseType,'gcamp6f')
                    
                    load(fullfile(saveDir,processedName),'xform_gcampCorr')
                    
                    QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_gcampCorr)),'oxy','gcampCorr','r-','g-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                    close all
                    clear xform_gcampCorr xform_datahb
                    
                elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                    sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
                    sessionInfo.bandtype_Delta = {"Delta",0.4,4};
                    load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr','xform_jrgeco1a')
                    total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
                    
                    %                         disp('calculate pds')
                    xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
                    xform_FADCorr = real(double(xform_FADCorr));
                    total = real(double(total));
                    
                    disp('calculate fc')
                    refseeds=GetReferenceSeeds_xw;
                    %refseeds = refseeds(1:14,:);
                    
                    [R_jrgeco1aCorr_ISA,Rs_jrgeco1aCorr_ISA] = QCcheck_CalcRRs_GSR_Each(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                    [R_FADCorr_ISA,Rs_FADCorr_ISA] = QCcheck_CalcRRs_GSR_Each(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                    [R_total_ISA,Rs_total_ISA] = QCcheck_CalcRRs_GSR_Each(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                    
                    [R_jrgeco1aCorr_Delta,Rs_jrgeco1aCorr_Delta] = QCcheck_CalcRRs_GSR_Each(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                    [R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs_GSR_Each(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                    [R_total_Delta,Rs_total_Delta] = QCcheck_CalcRRs_GSR_Each(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                    
                    clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
                    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
                    QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)
                    QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',saveDir,visName,false,xform_isbrain)
                    
                    QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
                    QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,visName,false,xform_isbrain)
                    QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',saveDir,visName,false,xform_isbrain)
                    
                    
                    save(fullfile(saveDir, processedName),'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
                        'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta','xform_isbrain','-append')
                    
                end
                close all
                
            end
            close all
            
        end
        
    end
end

