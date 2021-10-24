excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 2:6;%[3,5,7,8,10,11,12,13];%:450;
runs = 1:3;

I_FAD1_mice_awake = [];
I_FAD2_mice_awake = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5}; 
    I_FAD1_mouse = [];
    I_FAD2_mouse = [];

    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'mdata');
        I_FAD1 = mdata(1,:);
        I_FAD2 = mdata(2,:);
        I_FAD1_mouse = [I_FAD1_mouse,I_FAD1];
        I_FAD2_mouse = [I_FAD2_mouse,I_FAD2];
    end
    I_FAD1_mouse = mean(I_FAD1_mouse);
    I_FAD2_mouse = mean(I_FAD2_mouse);
    I_FAD1_mice_awake = [I_FAD1_mice_awake,I_FAD1_mouse];
    I_FAD2_mice_awake = [I_FAD2_mice_awake,I_FAD2_mouse];
end
I_FAD1_mice_awake_mean = mean(I_FAD1_mice_awake);
I_FAD2_mice_awake_mean = mean(I_FAD2_mice_awake);


excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 7:11;%[3,5,7,8,10,11,12,13];%:450;
runs = 1:3;

I_FAD1_mice_anes = [];
I_FAD2_mice_anes = [];
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    rawdataloc = excelRaw{3};
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    systemType = excelRaw{5}; 
    I_FAD1_mouse = [];
    I_FAD2_mouse = [];

    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'mdata');
        I_FAD1 = mdata(1,:);
        I_FAD2 = mdata(2,:);
        I_FAD1_mouse = [I_FAD1_mouse,I_FAD1];
        I_FAD2_mouse = [I_FAD2_mouse,I_FAD2];
    end
    I_FAD1_mouse = mean(I_FAD1_mouse);
    I_FAD2_mouse = mean(I_FAD2_mouse);
    I_FAD1_mice_anes = [I_FAD1_mice_anes,I_FAD1_mouse];
    I_FAD2_mice_anes = [I_FAD2_mice_anes,I_FAD2_mouse];
end
I_FAD1_mice_anes_mean = mean(I_FAD1_mice_anes);
I_FAD2_mice_anes_mean = mean(I_FAD2_mice_anes);


load('X:\XW\Paper\WT\RGECO Emission\cat\210830--W30M1-W30M2-W30M3-W31M1-W31M2-stim_processed_mice.mat',...
    'ROI','xform_FAD_mice_NoGSR','xform_jrgeco1a_mice_NoGSR')
ROI = reshape(ROI,1,[]);
xform_FAD_mice_NoGSR = reshape(xform_FAD_mice_NoGSR,128*128,[]);
xform_jrgeco1a_mice_NoGSR = reshape(xform_jrgeco1a_mice_NoGSR,128*128,[]);
FAD1 = mean(xform_FAD_mice_NoGSR(ROI,:),1);
FAD1_baseline = mean(FAD1(1:125));
FAD1 = FAD1-FAD1_baseline;
FAD2 = mean(xform_jrgeco1a_mice_NoGSR(ROI,:),1);
FAD2_baseline = mean(FAD2(1:125));
FAD2 = FAD2-FAD2_baseline;

load('L:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat',...
    'ROI_NoGSR','xform_FAD_mice_NoGSR','xform_jrgeco1a_mice_NoGSR')
ROI = reshape(ROI_NoGSR,1,[]);
xform_FAD_mice_NoGSR = reshape(xform_FAD_mice_NoGSR,128*128,[]);
xform_jrgeco1a_mice_NoGSR = reshape(xform_jrgeco1a_mice_NoGSR,128*128,[]);
FAD = mean(xform_FAD_mice_NoGSR(ROI,:),1);
FAD_baseline = mean(FAD(1:125));
FAD = FAD-FAD_baseline;
RGECO = mean(xform_jrgeco1a_mice_NoGSR(ROI,:),1);
RGECO_baseline = mean(RGECO(1:125));
RGECO = RGECO-RGECO_baseline;


figure
plot((1:750)/25,FAD1,'-','color','[0 0.5 0]')
hold on
plot((1:750)/25,FAD2,'r-')
hold on
plot((1:750)/25,FAD,'g-')
hold on
plot((1:750)/25,RGECO,'m-')
xlabel('Time(s)')
ylabel('Fluorescence(\DeltaF/F)')
legend('uncorrected FAD-cam1 of WT mouse','uncorrected FAD-cam2 of WT mouse','uncorrected FAD of RGECO mouse','uncorrected RGECO of RGECO mouse')

FAD1_mean = mean(FAD1(125:250));
FAD2_mean = mean(FAD2(125:250));
FAD_mean = mean(FAD(125:250));
RGECO_mean = mean(RGECO(125:250));