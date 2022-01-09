close all;clearvars -except hz;clc
import mouse.*

nVx = 128;
nVy = 128;
%
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 8:13;%:450;
runs = 1:3;
length_runs = length(runs);


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
    
    processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_processed','.mat');
    powerdata_average_total_mouse = [];
    for n = runs
        disp('loading processed data')
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir, processedName),'powerdata_average_total')
        powerdata_average_total_mouse = cat(2,powerdata_average_total_mouse,squeeze(powerdata_average_total));
        
    end
    
    
    disp(char(['QC check on ', processedName_mouse]))
    
    powerdata_average_total_mouse = mean(powerdata_average_total_mouse,2);
    save(fullfile(saveDir, processedName_mouse),'powerdata_average_total_mouse','-append')
    
end

close all



