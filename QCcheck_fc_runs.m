close all;clearvars -except hz;clc



import mice.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
isZTransform = true;
set(0,'defaultaxesfontsize',12);


info.nVx = 128;
info.nVy = 128;
%
for run = 1:9;
    excelRows =321:327;
    
    numMice = length(excelRows);
    xform_isbrain_mice = 1;
    sessionInfo.miceType = 'jrgeco1a';
    saveDir_cat = 'K:\Glucose\cat';
    
    R_total_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
    R_total_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
    Rs_total_Delta_mice = zeros(16,16,numMice);
    Rs_total_ISA_mice = zeros(16,16,numMice);
    total_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    total_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
    powerdata_average_oxy_mice = [];
    powerdata_oxy_mice = [];
    
    powerdata_average_deoxy_mice = [];
    powerdata_deoxy_mice = [];
    
    powerdata_average_total_mice = [];
    powerdata_total_mice = [];
    
    if strcmp(char(sessionInfo.miceType),'jrgeco1a')
        R_jrgeco1aCorr_Delta_mice = zeros(info.nVy,info.nVx,16,numMice);
        R_jrgeco1aCorr_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
        Rs_jrgeco1aCorr_Delta_mice = zeros(16,16,numMice);
        Rs_jrgeco1aCorr_ISA_mice = zeros(16,16,numMice);
        jrgeco1aCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        jrgeco1aCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        powerdata_average_jrgeco1aCorr_mice = [];
        powerdata_jrgeco1aCorr_mice = [];
        
        R_FADCorr_Delta_mice  = zeros(info.nVy,info.nVx,16,numMice);
        R_FADCorr_ISA_mice  = zeros(info.nVy,info.nVx,16,numMice);
        Rs_FADCorr_Delta_mice = zeros(16,16,numMice);
        Rs_FADCorr_ISA_mice = zeros(16,16,numMice);
        FADCorr_Delta_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        FADCorr_ISA_powerMap_mice = zeros(info.nVy,info.nVx,numMice);
        powerdata_average_FADCorr_mice = [];
        powerdata_FADCorr_mice = [];
        
    end
    
    
    
    miceName = [];
    miceName_powerdata = [];
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
        %goodRuns = str2num(excelRaw{18});
        if strcmp(char(sessionInfo.miceType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.miceType),'jrgeco1a')
            systemInfo.numLEDs = 3;
        end
        %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        
        maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
        load(fullfile(saveDir,maskName), 'xform_isbrain')
        
        %load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
        xform_isbrain(xform_isbrain ==2)=1;
        xform_isbrain = double(xform_isbrain);
        
        if ~isempty(find(isnan(xform_isbrain), 1))
            xform_isbrain(isnan(xform_isbrain))=0;
        end
        xform_isbrain(isinf(xform_isbrain)) = 0;
        xform_isbrain_mice = xform_isbrain_mice.*xform_isbrain;
        
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(run),'_processed.mat');
        
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.miceType),'jrgeco1a')
                
                
                
                load(fullfile(saveDir, processedName),'R_total_Delta','R_total_ISA','R_jrgeco1aCorr_Delta','R_jrgeco1aCorr_ISA','R_FADCorr_Delta','R_FADCorr_ISA',...
                    'Rs_total_Delta','Rs_total_ISA','Rs_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_ISA', 'Rs_FADCorr_Delta','Rs_FADCorr_ISA',...
                    'powerdata_average_oxy','powerdata_average_deoxy','powerdata_average_total','powerdata_average_jrgeco1aCorr','powerdata_average_FADCorr',...
                    'powerdata_oxy','powerdata_deoxy','powerdata_jrgeco1aCorr','powerdata_total','powerdata_FADCorr',...
                    'total_Delta_powerMap','total_ISA_powerMap','jrgeco1aCorr_Delta_powerMap','jrgeco1aCorr_ISA_powerMap', 'FADCorr_Delta_powerMap','FADCorr_ISA_powerMap',...
                    'hz','hz2')
                
                R_total_Delta_mice(:,:,:,ll) = atanh(R_total_Delta);
                R_total_ISA_mice(:,:,:,ll) = atanh(R_total_ISA);
                Rs_total_Delta_mice(:,:,ll) = atanh(Rs_total_Delta);
                Rs_total_ISA_mice(:,:,ll) = atanh(Rs_total_ISA);
                total_Delta_powerMap_mice(:,:,ll) = total_Delta_powerMap;
                total_ISA_powerMap_mice(:,:,ll) = total_ISA_powerMap;
                
                %     if goodRuns ~=0
                
                
                miceName_powerdata =  char(strcat(miceName_powerdata, '-', mouseName));
                powerdata_average_oxy_mice = cat(1,powerdata_average_oxy_mice,squeeze(powerdata_average_oxy));
                powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy));
                
                
                powerdata_average_deoxy_mice = cat(1,powerdata_average_deoxy_mice,squeeze(powerdata_average_deoxy));
                powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy));
                
                powerdata_average_total_mice = cat(1,powerdata_average_total_mice,squeeze(powerdata_average_total));
                powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total));
                
                powerdata_average_jrgeco1aCorr_mice = cat(1,powerdata_average_jrgeco1aCorr_mice,squeeze(powerdata_average_jrgeco1aCorr));
                powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr));
                powerdata_average_FADCorr_mice = cat(1,powerdata_average_FADCorr_mice,squeeze(powerdata_average_FADCorr));
                powerdata_FADCorr_mice = cat(1,powerdata_FADCorr_mice,squeeze(powerdata_FADCorr));
                
                % end
                
                
                R_jrgeco1aCorr_Delta_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_Delta);
                R_jrgeco1aCorr_ISA_mice(:,:,:,ll) = atanh(R_jrgeco1aCorr_ISA);
                Rs_jrgeco1aCorr_Delta_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_Delta);
                Rs_jrgeco1aCorr_ISA_mice(:,:,ll) = atanh(Rs_jrgeco1aCorr_ISA);
                jrgeco1aCorr_Delta_powerMap_mice(:,:,ll) = jrgeco1aCorr_Delta_powerMap;
                jrgeco1aCorr_ISA_powerMap_mice(:,:,ll) = jrgeco1aCorr_ISA_powerMap;
                
                
                R_FADCorr_Delta_mice(:,:,:,ll) = atanh(R_FADCorr_Delta);
                R_FADCorr_ISA_mice(:,:,:,ll) = atanh(R_FADCorr_ISA);
                Rs_FADCorr_Delta_mice(:,:,ll) = atanh(Rs_FADCorr_Delta);
                Rs_FADCorr_ISA_mice(:,:,ll) = atanh(Rs_FADCorr_ISA);
                FADCorr_Delta_powerMap_mice(:,:,ll) = FADCorr_Delta_powerMap;
                FADCorr_ISA_powerMap_mice(:,:,ll) = FADCorr_ISA_powerMap;
                
                
            end
            ll = ll+1;
        end
    end
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,num2str(run),'.mat');
    R_total_Delta_mice  = mean(R_total_Delta_mice,4);
    R_total_ISA_mice  = mean(R_total_ISA_mice,4);
    Rs_total_Delta_mice = mean(Rs_total_Delta_mice,3);
    Rs_total_ISA_mice = mean(Rs_total_ISA_mice,3);
    
    
    
    %if goodRuns ~=0
    powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,1);
    powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
    
    
    powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,1);
    powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
    
    powerdata_average_total_mice = mean(powerdata_average_total_mice,1);
    powerdata_total_mice = mean(powerdata_total_mice,1);
    
    total_Delta_powerMap_mice = mean(total_Delta_powerMap_mice,3);
    total_ISA_powerMap_mice = mean(total_ISA_powerMap_mice,3);
    powerdata_average_jrgeco1aCorr_mice = mean(powerdata_average_jrgeco1aCorr_mice,1);
    powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);
    
    powerdata_average_FADCorr_mice = mean(powerdata_average_FADCorr_mice,1);
    powerdata_FADCorr_mice = mean(powerdata_FADCorr_mice,1);
    %end
    
    
    
    
    R_jrgeco1aCorr_Delta_mice = mean(R_jrgeco1aCorr_Delta_mice,4);
    R_jrgeco1aCorr_ISA_mice  = mean(R_jrgeco1aCorr_ISA_mice,4);
    Rs_jrgeco1aCorr_Delta_mice = mean(Rs_jrgeco1aCorr_Delta_mice,3);
    Rs_jrgeco1aCorr_ISA_mice = mean(Rs_jrgeco1aCorr_ISA_mice,3);
    
    jrgeco1aCorr_Delta_powerMap_mice = mean(jrgeco1aCorr_Delta_powerMap_mice,3);
    jrgeco1aCorr_ISA_powerMap_mice = mean(jrgeco1aCorr_ISA_powerMap_mice,3);
    
    R_FADCorr_Delta_mice = mean(R_FADCorr_Delta_mice,4);
    R_FADCorr_ISA_mice  = mean(R_FADCorr_ISA_mice,4);
    Rs_FADCorr_Delta_mice = mean(Rs_FADCorr_Delta_mice,3);
    Rs_FADCorr_ISA_mice = mean(Rs_FADCorr_ISA_mice,3);
    
    FADCorr_Delta_powerMap_mice = mean(FADCorr_Delta_powerMap_mice,3);
    FADCorr_ISA_powerMap_mice = mean(FADCorr_ISA_powerMap_mice,3);
    save(fullfile(saveDir_cat, processedName_mice),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
        'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice',...
        'Rs_total_ISA_mice','Rs_jrgeco1aCorr_ISA_mice','Rs_FADCorr_ISA_mice',...
        'Rs_total_Delta_mice','Rs_jrgeco1aCorr_Delta_mice','Rs_FADCorr_Delta_mice',...
        'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
        'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
        'total_ISA_powerMap_mice','jrgeco1aCorr_ISA_powerMap_mice','FADCorr_ISA_powerMap_mice',...
        'total_Delta_powerMap_mice','jrgeco1aCorr_Delta_powerMap_mice','FADCorr_Delta_powerMap_mice',...
        'hz','xform_isbrain_mice','-append')
    
%     disp(char(['QC check on ', processedName_mice]))
%     if strcmp(char(sessionInfo.miceType),'jrgeco1a')
%         visName = strcat(miceName,"-",sessionType,num2str(run));
%         %if goodRuns ~=0
%         
%         
%         leftData = cell(2,1);
%         leftData{1} = powerdata_jrgeco1aCorr_mice;
%         leftData{2} = powerdata_FADCorr_mice;
%         
%         rightData = cell(3,1);
%         rightData{1} = powerdata_oxy_mice;
%         rightData{2} = powerdata_deoxy_mice;
%         rightData{3} = powerdata_total_mice;
%         
%         leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
%         rightLabel = 'Hb(\muM^2/Hz)';
%         leftLineStyle = {'m-','g-'};
%         rightLineStyle= {'r-','b-','k-'};
%         legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
%         
%         QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(miceName_powerdata, '_powerCurve'))
%         
%         
%         
%         leftData = cell(2,1);
%         leftData{1} = powerdata_average_jrgeco1aCorr_mice;
%         
%         leftData{2} = powerdata_average_FADCorr_mice;
%         
%         rightData = cell(3,1);
%         rightData{1} = powerdata_average_oxy_mice;
%         rightData{2} = powerdata_average_deoxy_mice;
%         rightData{3} = powerdata_average_total_mice;
%         
%         leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
%         rightLabel = 'Hb(\muM^2/Hz)';
%         leftLineStyle = {'m-','g-'};
%         rightLineStyle= {'r-','b-','k-'};
%         legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
%         QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve_average'))
%         
%         %end
%         
% %         
                refseeds=GetReferenceSeeds;
                refseeds = refseeds(1:14,:);
                refseeds(3,1) = 42;
                refseeds(3,2) = 88;
                refseeds(4,1) = 87;
                refseeds(4,2) = 88;
                refseeds(9,1) = 18;
                refseeds(9,2) = 66;
                refseeds(10,1) = 111;
                refseeds(10,2) = 66;
        
      QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_mice, Rs_jrgeco1aCorr_ISA_mice(1:14,1:14),'jrgeco1aCorr','m','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_FADCorr_ISA_mice, Rs_FADCorr_ISA_mice(1:14,1:14),'FADCorr','g','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_total_ISA_mice, Rs_total_ISA_mice(1:14,1:14),'total','k','ISA',saveDir_cat,visName,true,xform_isbrain_mice)
        
        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_mice, Rs_jrgeco1aCorr_Delta_mice(1:14,1:14),'jrgeco1aCorr','m','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_FADCorr_Delta_mice, Rs_FADCorr_Delta_mice(1:14,1:14),'FADCorr','g','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
        QCcheck_fcVis(refseeds,R_total_Delta_mice, Rs_total_Delta_mice(1:14,1:14),'total','k','Delta',saveDir_cat,visName,true,xform_isbrain_mice)
%         
%         QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_RGECOISA'))
%         QCcheck_powerMapVis(FADCorr_ISA_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, '_FADISA'))
%         QCcheck_powerMapVis(total_ISA_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName, "_TotalISA"))
%         
%         QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName, "_RGECODelta"))
%         QCcheck_powerMapVis(FADCorr_Delta_powerMap_mice,xform_isbrain_mice,'(\DeltaF/F%)',saveDir_cat,strcat(visName,"_FADDelta"))
%         QCcheck_powerMapVis(total_Delta_powerMap_mice,xform_isbrain_mice,'\muM',saveDir_cat,strcat(visName,"_TotalDelta"))
% 
%     end
    close all
end







