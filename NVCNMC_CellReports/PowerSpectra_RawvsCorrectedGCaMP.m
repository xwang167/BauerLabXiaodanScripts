%
excelFile = "X:\RGECO\DataBase_Xiaodan_1.xlsx";
excelRows = [139,120,122,123];
runs= 1:3;
ii = 1;
powerdata_gcamp = nan(12,1025);
powerdata_gcampCorr = nan(12,1025);
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
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    maskDir = saveDir;
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    for n = runs    
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat'); 
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        load(fullfile(saveDir,processedName), 'xform_gcamp','xform_gcampCorr','sessionInfo')
        [hz,powerdata_gcamp(ii,:)] = QCcheck_CalcPDS(double(xform_gcamp)*100,sessionInfo.framerate,double(xform_isbrain));
        [~,powerdata_gcampCorr(ii,:)] = QCcheck_CalcPDS(double(xform_gcampCorr)*100,sessionInfo.framerate,double(xform_isbrain));
        figure
        loglog(hz,powerdata_gcamp(ii,:),'g')
        hold on
        loglog(hz,powerdata_gcampCorr(ii,:),'color',[0 0.5 0])
        legend('Raw GCaMP','Corrected GCaMP')
        xlabel('Frequency(Hz)')
        ylabel('Power/Frequency((\DeltaF/F%)^2/Hz)')     
        saveas(gcf,fullfile("X:\Paper1\Revision\GCaMPPowerSpectra",strcat(visName,'_GCaMPPowerCurve.png')));
        ii = ii+1;
    end
end

powerdata_gcamp_avg = mean(powerdata_gcamp);
powerdata_gcampCorr_avg = mean(powerdata_gcampCorr);

figure
loglog(hz,powerdata_gcamp_avg,'g')
hold on
loglog(hz,powerdata_gcampCorr_avg,'color',[0 0.5 0])
xlabel('Frequency(Hz)')
ylabel('Power/Frequency((\DeltaF/F%)^2/Hz)')
legend('Raw GCaMP','Corrected GCaMP')
title('Averaged across 4 mice')
