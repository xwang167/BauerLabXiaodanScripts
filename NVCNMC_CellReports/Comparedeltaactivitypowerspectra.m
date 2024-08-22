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
        [hz, powerdata_RawRGECO] = QCcheck_CalcPDS(squeeze(xform_jrgeco1a),framerate,xform_isbrain);
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
        [hz, powerdata_Rawcam1] = QCcheck_CalcPDS(squeeze(xform_FAD),framerate,xform_isbrain);
        [hz, powerdata_Rawcam2] = QCcheck_CalcPDS(squeeze(xform_jrgeco1a),framerate,xform_isbrain);
        
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
        load(fullfile(saveDir,processedName),'xform_red','xform_green');
        
        [hz, powerdata_red] = QCcheck_CalcPDS(squeeze(xform_red),framerate,xform_isbrain);
        [hz, powerdata_green] = QCcheck_CalcPDS(squeeze(xform_green),framerate,xform_isbrain);
        
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
semilogx(hz,10*log10(powerdata_RawRGECO/interp1(hz,powerdata_RawRGECO,0.01)),'m-');
hold on
semilogx(hz,10*log10(powerdata_Rawcam1_mice/interp1(hz,powerdata_Rawcam1_mice,0.01)),'g-');
hold on
semilogx(hz,10*log10(powerdata_Rawcam2_mice/interp1(hz,powerdata_Rawcam2_mice,0.01)),'k-');
hold on
semilogx(hz,10*log10(powerdata_red_mice/interp1(hz,powerdata_red_mice,0.01)),'r-');
hold on
semilogx(hz,10*log10(powerdata_green_mice/interp1(hz,powerdata_green_mice,0.01)),'color',[0 0.5 0]);
xlim([0.01 10])
ylabel('dB(\DeltaF/F)^2/Hz or dB(\DeltaR/R)^2/Hz')
xlabel('frequency')
legend('Raw RGECO Em in cam1','WT Raw FAD Em in cam2','530 Ex in cam2','WT 625nm relfectance','WT 530nm reflectance','location','southwest')
