close all;clearvars -except hz;clc
import mice.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 8:13;%:450;

numMice = length(excelRows);
xform_isbrain_mice = 1;
sessionInfo.miceType = 'jrgeco1a';
saveDir_cat = 'L:\RGECO\cat';
powerdata_average_total_mice = [];
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
    load(fullfile(saveDir, processedName),'powerdata_average_total_mouse','hz')
    powerdata_average_total_mice = cat(2,powerdata_average_total_mice,powerdata_average_total_mouse);
end

powerdata_average_total_mice = mean(powerdata_average_total_mice,2);

processedName_mice = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc.mat';

