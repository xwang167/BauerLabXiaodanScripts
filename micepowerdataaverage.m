close all;clearvars -except hz;clc
import mice.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 8:13;%:450;

numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';
powerdata_jrgeco1aCorr_mice = []; 
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

    processedName = strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat');
    
    if strcmp(sessionType,'fc')
        if strcmp(char(sessionInfo.miceType),'jrgeco1a')
            
            
            
            load(fullfile(saveDir, processedName),'powerdata_jrgeco1aCorr_mouse','hz')
         
             powerdata_jrgeco1aCorr_mice = cat(1,powerdata_jrgeco1aCorr_mice,squeeze(powerdata_jrgeco1aCorr_mouse));       
        end
        ll = ll+1;
    end
end

powerdata_jrgeco1aCorr_mice = mean(powerdata_jrgeco1aCorr_mice,1);

processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';


save(fullfile(saveDir_cat, processedName_mice), 'powerdata_jrgeco1aCorr_mice','-append')



