close all;clearvars -except hz;clc
import mice.*

isZTransform = true;
set(0,'defaultaxesfontsize',12);

info.nVx = 128;
info.nVy = 128;
%
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 8:13;% [228 230 232 234 236 240];
numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\allruns\cat';

powerdata_average_oxy_mice = [];
powerdata_oxy_mice = [];

powerdata_average_deoxy_mice = [];
powerdata_deoxy_mice = [];

powerdata_average_total_mice = [];
powerdata_total_mice = [];

if strcmp(char(sessionInfo.miceType),'jrgeco1a')
    
    powerdata_average_jrgeco1aCorr_mice = [];
    powerdata_jrgeco1aCorr_mice = [];
    
    powerdata_average_FADCorr_mice = [];
    powerdata_FADCorr_mice = [];
    
end


    
    miceName = [];
    ll = 1;
    for excelRow = excelRows
        [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':R',num2str(excelRow)]);
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        miceName = char(strcat(miceName, '-', mouseName));
        saveDir = excelRaw{4}; 
        saveDir_new = fullfile(string(saveDir),'allruns',recDate);
        saveDir = fullfile(string(saveDir),recDate);
        sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
        sessionInfo.darkFrameNum = excelRaw{11};
        rawdataloc = excelRaw{3};
        info.nVx = 128;
        info.nVy = 128;
        systemType =excelRaw{5};

        processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
        
        if strcmp(sessionType,'fc')
            if strcmp(char(sessionInfo.miceType),'jrgeco1a')
                
                
                
                load(fullfile(saveDir_new, processedName),'powerdata_average_oxy_mouse','powerdata_average_deoxy_mouse','powerdata_average_total_mouse','powerdata_average_jrgeco1aCorr_mouse','powerdata_average_FADCorr_mouse',...
                    'powerdata_oxy_mouse','powerdata_deoxy_mouse','powerdata_jrgeco1aCorr_mouse','powerdata_total_mouse','powerdata_FADCorr_mouse',...
                    'hz')
                
                powerdata_average_oxy_mice = cat(1,powerdata_average_oxy_mice,squeeze(powerdata_average_oxy_mouse));
                powerdata_oxy_mice = cat(1,powerdata_oxy_mice,squeeze(powerdata_oxy_mouse));
                
                
                powerdata_average_deoxy_mice = cat(1,powerdata_average_deoxy_mice,squeeze(powerdata_average_deoxy_mouse));
                powerdata_deoxy_mice = cat(1,powerdata_deoxy_mice,squeeze(powerdata_deoxy_mouse));
                
                powerdata_average_total_mice = cat(1,powerdata_average_total_mice,squeeze(powerdata_average_total_mouse));
                powerdata_total_mice = cat(1,powerdata_total_mice,squeeze(powerdata_total_mouse));
                
                
        
                powerdata_average_jrgeco1aCorr_mice = cat(1,powerdata_average_jrgeco1aCorr_mice,squeeze(powerdata_average_jrgeco1aCorr_mouse));
                powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr_mouse));
                
            
                powerdata_average_FADCorr_mice = cat(1,powerdata_average_FADCorr_mice,squeeze(powerdata_average_FADCorr_mouse));
                powerdata_FADCorr_mice = cat(1,powerdata_FADCorr_mice,squeeze(powerdata_FADCorr_mouse));
                
            end
            ll = ll+1;
        end
    end
    processedName_mice = strcat(recDate,'-',miceName,'-',sessionType,'.mat');
 
    powerdata_average_oxy_mice = mean(powerdata_average_oxy_mice,1);
    powerdata_oxy_mice = mean(powerdata_oxy_mice,1);
    
    powerdata_average_deoxy_mice = mean(powerdata_average_deoxy_mice,1);
    powerdata_deoxy_mice = mean(powerdata_deoxy_mice,1);
    
    powerdata_average_total_mice = mean(powerdata_average_total_mice,1);
    powerdata_total_mice = mean(powerdata_total_mice,1);
    

    
    powerdata_average_jrgeco1aCorr_mice = mean(powerdata_average_jrgeco1aCorr_mice,1);
    powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);

 
    powerdata_average_FADCorr_mice = mean(powerdata_average_FADCorr_mice,1);
    powerdata_FADCorr_mice = mean(powerdata_FADCorr_mice,1);

    if exist(fullfile(saveDir_cat, processedName_mice,'file'))
    save(fullfile(saveDir_cat, processedName_mice), 'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
        'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
        'hz','-append')
    else
        save(fullfile(saveDir_cat, processedName_mice), 'powerdata_average_oxy_mice','powerdata_average_deoxy_mice','powerdata_average_total_mice','powerdata_average_jrgeco1aCorr_mice','powerdata_average_FADCorr_mice',...
        'powerdata_oxy_mice','powerdata_deoxy_mice','powerdata_total_mice','powerdata_jrgeco1aCorr_mice','powerdata_FADCorr_mice',...
        'hz')
    end
    disp(char(['QC check on ', processedName_mice]))
   
        visName = miceName;
        %if goodRuns ~=0
        
        
        leftData = cell(2,1);
        leftData{1} = powerdata_jrgeco1aCorr_mice;
        leftData{2} = powerdata_FADCorr_mice;
        
        rightData = cell(3,1);
        rightData{1} = powerdata_oxy_mice;
        rightData{2} = powerdata_deoxy_mice;
        rightData{3} = powerdata_total_mice;
        
        leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
        rightLabel = 'Hb(\muM^2/Hz)';
        leftLineStyle = {'m-','g-'};
        rightLineStyle= {'r-','b-','k-'};
        legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
        
        QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve'))
        
        
        
        leftData = cell(2,1);
        leftData{1} = powerdata_average_jrgeco1aCorr_mice;
        
        leftData{2} = powerdata_average_FADCorr_mice;
        
        rightData = cell(3,1);
        rightData{1} = powerdata_average_oxy_mice;
        rightData{2} = powerdata_average_deoxy_mice;
        rightData{3} = powerdata_average_total_mice;
        
        leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
        rightLabel = 'Hb(\muM^2/Hz)';
        leftLineStyle = {'m-','g-'};
        rightLineStyle= {'r-','b-','k-'};
        legendName = ["Corrected jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
        QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir_cat,strcat(visName, '_powerCurve_average'))
        
        %end

    close all

