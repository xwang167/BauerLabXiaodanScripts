import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [195 ];%202 204 230 234 240];%[185,228,232,236,181];%321:327;
runs = 1;
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

xform_WL = imresize(xform_WL,0.5);
mask = imresize(mask,0.5);
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        load(fullfile(saveDir, processedName),'xform_jrgeco1aCorr')
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        edgeLen =1;
        tZone = 4;
        ISA = [0.009 0.08];
        Delta = [0.4 4];
        validRange = -round(tZone*fs): round(tZone*fs);
        tLim_ISA = [-1.5 1.5];
        tLim_Delta = [-0.05 0.05];
        corrThr = 0;
        rLim = [-1 1];
        tic;
        [lagTime_Projection_Calcium_ISA,lagAmp_Projection_Calcium_ISA] = calcProjectionLagMatrix(squeeze(xform_jrgeco1aCorr),ISA(1),ISA(2),fs,edgeLen,validRange,corrThr);
          [lagTime_Projection_Calcium_Delta,lagAmp_Projection_Calcium_Delta] = calcProjectionLagMatrix(squeeze(xform_jrgeco1aCorr),Delta(1),Delta(2),fs,edgeLen,validRange,corrThr);
    end
end