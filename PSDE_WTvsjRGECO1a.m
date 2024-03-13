close all;clear all;clc
import mouse.*
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";

%% Panel A Resting PDSE in anesthetized C57 and jRGECO1a mice detected by CMOS2
% psd of raw jRGECO1a in anesthetized Thy1-jRGECO1a mice
excelRows_anes = [ 202 195 204 230 234 240];
powerdata_jrgeco1a_mice = [];
for excelRow = excelRows_anes
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    powerdata_jrgeco1a_mouse = [];
    for n = runs
        processedName = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat'));
        load(processedName,'powerdata_jrgeco1a')
        powerdata_jrgeco1a_mouse = cat(1,powerdata_jrgeco1a_mouse,powerdata_jrgeco1a);
    end
    powerdata_jrgeco1a_mouse = mean(powerdata_jrgeco1a_mouse);
    processedeName_mouse = fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'_processed.mat'));
    if exist(processedeName_mouse,'file')
        save(processedeName_mouse,'powerdata_jrgeco1a_mouse','-append')
    else
        save(processedeName_mouse,'powerdata_jrgeco1a_mouse')
    end
    powerdata_jrgeco1a_mice = cat(1,powerdata_jrgeco1a_mice,powerdata_jrgeco1a_mouse);
end
%% mice average for signal (std)
catDir = 'E:\RGECO\cat\';
saveName_mice = fullfile(catDir,strcat())
figure
subplot(221)

loglog()
