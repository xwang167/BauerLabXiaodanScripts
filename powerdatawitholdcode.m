
import mice.*
excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 8:13;%:450;
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};

    sessionInfo.framerate = excelRaw{7};
 
     saveDir_new = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datafluor','.mat');

    if ~exist(fullfile(saveDir_new,maskName),'file')
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(saveDir,maskName),'xform_isbrain')
    else
        load(fullfile(saveDir_new,maskName),'xform_isbrain')
    end
    mask = logical(mask_new.*xform_isbrain);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        processedName_save = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed_old','.mat');
        if exist(fullfile(saveDir,processedName),'file')
            
            
            if strcmp(sessionType,'fc')
                C = who('-file',fullfile(saveDir,processedName));
                isQCGot = false;
                %                 for  k=1:length(C)
                %                     if strcmp(C(k),'powerdata_oxy')
                %                         isQCGot = true;
                %                     end
                %                 end
                if ~isQCGot
                    disp('loading processed data')
                    load(fullfile(saveDir,processedName),'xform_datahb')
                    %                     for ii = 1:size(xform_datahb,4)
                    %                         xform_isbrain(isinf(real(xform_datahb(:,:,1,ii)))) = 0;
                    %                         xform_isbrain(isnan(real(xform_datahb(:,:,1,ii)))) = 0;
                    %
                    %                     end
                    disp(strcat('fc QC check on ', processedName))
                    
                    if strcmp(sessionInfo.mouseType,'gcamp6f')
                        
                        load(fullfile(saveDir,processedName),'xform_gcampCorr')
                        
                        QCcheck_fc_twoFluor(double(squeeze(xform_datahb(:,:,1,:))),double(squeeze(xform_gcampCorr)),'oxy','gcampCorr','r-','g-',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),false,'(\DeltaM)','(\DeltaF/F)');
                        close all
                        clear xform_gcampCorr xform_datahb
                        
                    elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                        load(fullfile(saveDir, processedName),'xform_FADCorr','xform_jrgeco1aCorr','xform_jrgeco1a')
                        sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
                        sessionInfo.bandtype_Delta = {"Delta",0.4,4};
                        total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
                        
                        %                         disp('calculate pds')
                        xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
                        xform_FADCorr = real(double(xform_FADCorr));
                        total = real(double(total));
                        xform_datahb = real(double(xform_datahb));
                        [hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS_191112(xform_jrgeco1aCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_jrgeco1a] = QCcheck_CalcPDS_191112(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_FADCorr] = QCcheck_CalcPDS_191112(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_total] = QCcheck_CalcPDS_191112(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_oxy] = QCcheck_CalcPDS_191112((xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_deoxy] = QCcheck_CalcPDS_191112(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        
                        [hz,powerdata_average_jrgeco1aCorr] =QCcheck_CalcPDSAverage_191112(xform_jrgeco1aCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_jrgeco1a] =QCcheck_CalcPDSAverage_191112(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_FADCorr] =QCcheck_CalcPDSAverage_191112(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_total] =QCcheck_CalcPDSAverage_191112(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_oxy] =QCcheck_CalcPDSAverage_191112(xform_datahb(:,:,1,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_deoxy] =QCcheck_CalcPDSAverage_191112(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                                        
                        
                        save(fullfile(saveDir, processedName_save),'powerdata_jrgeco1aCorr','powerdata_jrgeco1a','powerdata_FADCorr','powerdata_total','powerdata_oxy','powerdata_deoxy',...
                            'powerdata_average_jrgeco1aCorr','powerdata_average_jrgeco1a','powerdata_average_FADCorr','powerdata_average_total','powerdata_average_oxy','powerdata_average_deoxy','hz')
                                                
                        nameString = fullfile(saveDir,visName);                        
                        leftData = cell(3,1);
                        leftData{1} = powerdata_jrgeco1aCorr;
                        leftData{2} = powerdata_jrgeco1a;
                        leftData{3} = powerdata_FADCorr;
                        
                        rightData = cell(3,1);
                        rightData{1} = powerdata_oxy;
                        rightData{2} = powerdata_deoxy;
                        rightData{3} = powerdata_total;
                        
                        leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                        rightLabel = 'Hb(\muM^2/Hz)';
                        leftLineStyle = {'m-','y-','g-'};
                        rightLineStyle= {'r-','b-','k-'};
                        legendName = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD","HbO","HbR","HbT"];                       
                        
                        QCcheck_fftVis_191112(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve_old'))

                        leftData = cell(3,1);
                        leftData{1} = powerdata_average_jrgeco1aCorr;
                        leftData{2} = powerdata_average_jrgeco1a;
                        leftData{3} = powerdata_average_FADCorr;
                        
                        rightData = cell(3,1);
                        rightData{1} = powerdata_average_oxy;
                        rightData{2} = powerdata_average_deoxy;
                        rightData{3} = powerdata_average_total;
                        
                        
                        QCcheck_fftVis_191112(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,saveDir,strcat(visName, '_powerCurve_average_old'))
  
                    end
                    
                end
                
           
            end
            close all
            
        end
        
    end
end