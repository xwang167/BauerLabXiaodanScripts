import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
excelRows = [181 183 185 228 232];
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    newDir = 'L:\RGECO\ToMitchell';
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');
    
    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr','xform_FADCorr','xform_datahb');
        
        xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
        xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
        
        xform_FADCorr(isinf(xform_FADCorr)) = 0;
        xform_FADCorr(isnan(xform_FADCorr)) = 0;
        
        xform_datahb(isinf(xform_datahb)) = 0;
        xform_datahb(isnan(xform_datahb)) = 0;
        
        xform_jrgeco1aCorr_ISA = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.009,0.08,sessionInfo.framerate);
        xform_FADCorr_ISA = mouse.freq.filterData(double(xform_FADCorr),0.009,0.08,sessionInfo.framerate);
        xform_datahb_ISA = mouse.freq.filterData(double(xform_datahb),0.009,0.08,sessionInfo.framerate);
        
        xform_jrgeco1aCorr_Delta = mouse.freq.filterData(double(xform_jrgeco1aCorr),0.4, 4, sessionInfo.framerate);
        xform_FADCorr_Delta = mouse.freq.filterData(double(xform_FADCorr),0.4, 4, sessionInfo.framerate);
        xform_datahb_Delta = mouse.freq.filterData(double(xform_datahb),0.4, 4, sessionInfo.framerate);
        
        save(fullfile(newDir,processedName),'xform_jrgeco1aCorr','xform_FADCorr','xform_datahb',...
            'xform_jrgeco1aCorr_ISA','xform_FADCorr_ISA','xform_datahb_ISA',...
            'xform_jrgeco1aCorr_Delta','xform_FADCorr_Delta','xform_datahb_Delta',...
            'xform_isbrain','-v7.3')
    end
end












