close all;clearvars -except hz;clc
import mouse.*

nVx = 128;
nVy = 128;
%
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 2:13;%:450;
runs = 1:3;
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
        
        if strcmp(char(sessionInfo.mouseType),'WT')
            systemInfo.numLEDs = 2;
        elseif strcmp(char(sessionInfo.mouseType),'gcamp6f')
            systemInfo.numLEDs = 3;
        end
    
        processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
        powerdata_jrgeco1aCorr_mouse = [];
        for n = runs
            disp('loading processed data')
            
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');

            if strcmp(sessionType,'fc')
                
               
                    load(fullfile(saveDir, processedName),'powerdata_jrgeco1aCorr')
                    powerdata_jrgeco1aCorr_mouse = cat(1,powerdata_jrgeco1aCorr_mouse,squeeze(powerdata_jrgeco1aCorr));
         
                
            end
        end
        
        
        disp(char(['QC check on ', processedName_mouse]))
        
        powerdata_jrgeco1aCorr_mouse = mean(powerdata_jrgeco1aCorr_mouse,1);
        save(fullfile(saveDir, processedName_mouse),'powerdata_jrgeco1aCorr_mouse','-append')
        
    end
end
close all



