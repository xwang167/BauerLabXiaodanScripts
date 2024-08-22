excelFile = "L:\RGECO\RGECO.xlsx";
excelRows =  8:13;
powerdata_RawRGECO_mice = [];
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    framerate = 25;
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    powerdata_RawRGECO_mouse = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1a');
        [hz, powerdata_RawRGECO] = QCcheck_CalcPDS(squeeze(xform_jrgeco1a*100),framerate,xform_isbrain);
        powerdata_RawRGECO_mouse = cat(1,powerdata_RawRGECO_mouse,powerdata_RawRGECO);
    end
    powerdata_RawRGECO_mouse = mean(powerdata_RawRGECO_mouse);
    powerdata_RawRGECO_mice = cat(1,powerdata_RawRGECO_mice,powerdata_RawRGECO_mouse);
end
powerdata_RawRGECO_mice = mean(powerdata_RawRGECO_mice);
%



excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 7:11;
powerdata_Rawcam1_mice = [];
powerdata_Rawcam2_mice = [];
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    framerate = 25;
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    powerdata_Rawcam1_mouse = [];
    powerdata_Rawcam2_mouse = [];
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat');
        load(fullfile(saveDir,processedName),'xform_FAD','xform_jrgeco1a');
        [hz, powerdata_Rawcam1] = QCcheck_CalcPDS(squeeze(xform_FAD*100),framerate,xform_isbrain);
        [hz, powerdata_Rawcam2] = QCcheck_CalcPDS(squeeze(xform_jrgeco1a*100),framerate,xform_isbrain);
        
        powerdata_Rawcam1_mouse = cat(1,powerdata_Rawcam1_mouse,powerdata_Rawcam1);
        powerdata_Rawcam2_mouse = cat(1,powerdata_Rawcam2_mouse,powerdata_Rawcam2);
    end
    powerdata_Rawcam1_mouse = mean(powerdata_Rawcam1_mouse);
    powerdata_Rawcam2_mouse = mean(powerdata_Rawcam2_mouse);
    powerdata_Rawcam1_mice = cat(1,powerdata_Rawcam1_mice,powerdata_Rawcam1_mouse);
    powerdata_Rawcam2_mice = cat(1,powerdata_Rawcam2_mice,powerdata_Rawcam2_mouse);
end
powerdata_Rawcam1_mice = mean(powerdata_Rawcam1_mice);
powerdata_Rawcam2_mice = mean(powerdata_Rawcam2_mice);



excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 7:11;
powerdata_red_mice = [];
powerdata_green_mice = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    framerate = 25;
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5};
    powerdata_red_mouse = [];
    powerdata_green_mouse = [];
    
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'xform_isbrain')
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat');
        load(fullfile(saveDir,processedName),'xform_red*100','xform_green*100');
        
        [hz, powerdata_red] = QCcheck_CalcPDS(squeeze(xform_red*100),framerate,xform_isbrain);
        [hz, powerdata_green] = QCcheck_CalcPDS(squeeze(xform_green*100),framerate,xform_isbrain);
        
        powerdata_red_mouse = cat(1,powerdata_red_mouse,powerdata_red);
        powerdata_green_mouse = cat(1,powerdata_green_mouse,powerdata_green);
    end
    powerdata_red_mouse = mean(powerdata_red_mouse);
    powerdata_green_mouse = mean(powerdata_green_mouse);
    
    powerdata_red_mice = cat(1,powerdata_red_mice,powerdata_red_mouse);
    powerdata_green_mice = cat(1,powerdata_green_mice,powerdata_green_mouse);
    
end
powerdata_red_mice = mean(powerdata_red_mice);
powerdata_green_mice = mean(powerdata_green_mice);
figure
loglog(hz,powerdata_RawRGECO,'m-');
hold on
loglog(hz,powerdata_Rawcam1_mice,'g-');
hold on
loglog(hz,powerdata_Rawcam2_mice,'k-');
hold on
loglog(hz,powerdata_red_mice,'r-');
hold on
loglog(hz,powerdata_green_mice,'color',[0 0.5 0]);
xlim([0.01 10])
ylabel('(\DeltaF/F%)^2/Hz or (\DeltaR/R%)^2/Hz')
xlabel('Frequency(Hz)')
legend('Raw jRGECO1a Em in CMOS2','C57BL6 Raw FAD Em in CMOS1','C57BL6 Raw in CMOS2','C57BL6 625nm Relfectance','C57BL6 530nm Reflectance','location','southwest')
