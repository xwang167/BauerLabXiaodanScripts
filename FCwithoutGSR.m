
close all;clear all;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


nVx = 128;
nVy = 128;
%
excelRows = 185; %[183,195];
runs = 1:3;
length_runs = length(runs);
% 
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
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
  
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
 load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
   
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-NoGSR');
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        load(fullfile(saveDir, processedName),'xform_jrgeco1aCorr','xform_datahb')
        sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
        sessionInfo.bandtype_Delta = {"Delta",0.4,4};
        total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
        clear xform_datahb
        disp('calculate fc')
        refseeds=GetReferenceSeeds_xw;
        %refseeds = refseeds(1:14,:);
        
        [R_jrgeco1aCorr_ISA_NoGSR,Rs_jrgeco1aCorr_ISA_NoGSR] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],false);
        [R_total_ISA_NoGSR,Rs_total_ISA_NoGSR] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],false);
        
        [R_jrgeco1aCorr_Delta_NoGSR,Rs_jrgeco1aCorr_Delta_NoGSR] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
        [R_total_Delta_NoGSR,Rs_total_Delta_NoGSR] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
        
        clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
        
        
        save(fullfile(saveDir, processedName),'R_jrgeco1aCorr_ISA_NoGSR','Rs_jrgeco1aCorr_ISA_NoGSR','R_total_ISA_NoGSR','Rs_total_ISA_NoGSR',...
            'R_jrgeco1aCorr_Delta_NoGSR','Rs_jrgeco1aCorr_Delta_NoGSR','R_total_Delta_NoGSR','Rs_total_Delta_NoGSR','xform_isbrain','-append')
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_NoGSR, Rs_jrgeco1aCorr_ISA_NoGSR,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_ISA_NoGSR, Rs_total_ISA_NoGSR,'total','k','ISA',saveDir,visName,false,xform_isbrain)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_NoGSR, Rs_jrgeco1aCorr_Delta_NoGSR,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_Delta_NoGSR, Rs_total_Delta_NoGSR,'total','k','Delta',saveDir,visName,false,xform_isbrain)
    end
end







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
        
        
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
        %         maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        %         load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
        
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
        
        R_total_Delta_NoGSR_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
        R_total_ISA_NoGSR_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
        Rs_total_Delta_NoGSR_mouse = zeros(16,16,length_runs);
        Rs_total_ISA_NoGSR_mouse = zeros(16,16,length_runs);
        
        R_jrgeco1aCorr_Delta_NoGSR_mouse = zeros(info.nVy,info.nVx,16,length_runs);
        R_jrgeco1aCorr_ISA_NoGSR_mouse  = zeros(info.nVy,info.nVx,16,length_runs);
        Rs_jrgeco1aCorr_Delta_NoGSR_mouse = zeros(16,16,length_runs);
        Rs_jrgeco1aCorr_ISA_NoGSR_mouse = zeros(16,16,length_runs);
        
        %

        
        for n = runs
            
            
            disp('loading processed data')
            
            %             if isDetrend
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            %             else
            %                 processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_NoDetrend','.mat');
            %             end
            
            load(fullfile(saveDir, processedName),'R_total_Delta_NoGSR','R_total_ISA_NoGSR','R_jrgeco1aCorr_Delta_NoGSR','R_jrgeco1aCorr_ISA_NoGSR',...
                'Rs_total_Delta_NoGSR','Rs_total_ISA_NoGSR','Rs_jrgeco1aCorr_Delta_NoGSR','Rs_jrgeco1aCorr_ISA_NoGSR')
            
            R_total_Delta_NoGSR_mouse(:,:,:,n) = R_total_Delta_NoGSR;
            R_total_ISA_NoGSR_mouse(:,:,:,n) = R_total_ISA_NoGSR;
            
            Rs_total_Delta_NoGSR_mouse(:,:,n) = Rs_total_Delta_NoGSR;
            Rs_total_ISA_NoGSR_mouse(:,:,n) = Rs_total_ISA_NoGSR;
            
            
            
            
            
            R_jrgeco1aCorr_Delta_NoGSR_mouse(:,:,:,n) = R_jrgeco1aCorr_Delta_NoGSR;
            R_jrgeco1aCorr_ISA_NoGSR_mouse(:,:,:,n) = R_jrgeco1aCorr_ISA_NoGSR;
            Rs_jrgeco1aCorr_Delta_NoGSR_mouse(:,:,n) = Rs_jrgeco1aCorr_Delta_NoGSR;
            Rs_jrgeco1aCorr_ISA_NoGSR_mouse(:,:,n) = Rs_jrgeco1aCorr_ISA_NoGSR;
            
            %
            
        end
        
        
        
        R_total_Delta_NoGSR_mouse  = mean(R_total_Delta_NoGSR_mouse,4);
        R_total_ISA_NoGSR_mouse  = mean(R_total_ISA_NoGSR_mouse,4);
        Rs_total_Delta_NoGSR_mouse = mean(Rs_total_Delta_NoGSR_mouse,3);
        Rs_total_ISA_NoGSR_mouse = mean(Rs_total_ISA_NoGSR_mouse,3);
        
        
        
        disp(char(['QC check on ', processedName_mouse]))
        
        
        
        R_jrgeco1aCorr_Delta_NoGSR_mouse = mean(R_jrgeco1aCorr_Delta_NoGSR_mouse,4);
        R_jrgeco1aCorr_ISA_NoGSR_mouse  = mean(R_jrgeco1aCorr_ISA_NoGSR_mouse,4);
        Rs_jrgeco1aCorr_Delta_NoGSR_mouse = mean(Rs_jrgeco1aCorr_Delta_NoGSR_mouse,3);
        Rs_jrgeco1aCorr_ISA_NoGSR_mouse = mean(Rs_jrgeco1aCorr_ISA_NoGSR_mouse,3);
        %
        
        
        save(fullfile(saveDir, processedName_mouse),'R_total_ISA_NoGSR_mouse','R_jrgeco1aCorr_ISA_NoGSR_mouse',...
            'R_total_Delta_NoGSR_mouse','R_jrgeco1aCorr_Delta_NoGSR_mouse',...
            'Rs_total_ISA_NoGSR_mouse','Rs_jrgeco1aCorr_ISA_NoGSR_mouse',...
            'Rs_total_Delta_NoGSR_mouse','Rs_jrgeco1aCorr_Delta_NoGSR_mouse',...
            '-append')
        
        
        visName = strcat(recDate,'-',mouseName,'-',sessionType,'-NoGSR');
        
        
        
        refseeds=GetReferenceSeeds_xw;
        
        %
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_NoGSR_mouse, Rs_jrgeco1aCorr_ISA_NoGSR_mouse,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_ISA_NoGSR_mouse, Rs_total_ISA_NoGSR_mouse,'total','k','ISA',saveDir,visName,false,xform_isbrain)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_NoGSR_mouse, Rs_jrgeco1aCorr_Delta_NoGSR_mouse,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
        QCcheck_fcVis(refseeds,R_total_Delta_NoGSR_mouse, Rs_total_Delta_NoGSR_mouse,'total','k','Delta',saveDir,visName,false,xform_isbrain)
        
        
        
    end
    close all
end