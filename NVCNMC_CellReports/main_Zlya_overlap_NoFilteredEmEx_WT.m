
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "X:\XW\Paper\PaperExperiment.xlsx";
excelRows = 12:16;%[3,5,7,8,10,11,12,13];%:450;
runs = 1;
isDetrend = 1;
nVy = 128;
nVx = 128;
% 
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    rawdataloc = excelRaw{3};
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    saveDir_corrected = fullfile('X:\XW\NoFilteredEmEX\WT',recDate);
    if ~exist(saveDir_corrected)
        mkdir(saveDir_corrected)
    end
    sessionInfo.mouseType = excelRaw{17};
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.totalFrameNum = excelRaw{22};
    sessionInfo.extCoeffFile = "prahl_extinct_coef.txt";
    sessionInfo.detrendSpatially = true;
    sessionInfo.detrendTemporally = true;
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.freqout = sessionInfo.framerate;
    
    muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
    systemType = excelRaw{5};
    
    if strcmp(sessionType,'stim')
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.stimduration = excelRaw{13};
    else
        sessionInfo.stimbaseline =0;
        sessionInfo.stimduration =0;
    end
    sessionInfo.hbSpecies = [3 4];
    sessionInfo.FADspecies = 1;
    sessionInfo.fluorSpecies = 2;
    sessionInfo.refChan = 4;
    sessionInfo.refChan_Green = 3;
    sessionInfo.fluorEmissionFile = "fad_emission.txt";
    
    sessionInfo.FADEmissionFile = "fad_emission.txt";
    systemInfo.LEDFiles = [
        "TwoCam_Mightex470_BP_Pol.txt",...
        "TwoCam_Mightex525_BP_Pol.txt",...
        "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
        "TwoCam_TL625_Pol_Longer593.txt"];
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    
    % end
    
    xform_isbrain(isnan(xform_isbrain)) = 0;
    xform_isbrain = logical(xform_isbrain);
    
    pkgDir = what('bauerParams');
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    %     badruns = str2num(excelRaw{19});
    %     runs(badruns) = [];
    
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        %         if ~exist(fullfile(saveDir,processedName),'file')
        if exist(fullfile(saveDir,rawName),'file')
            
            load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1a','xform_FAD')
            [op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
            [op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));
            
            dpIn = op_in.dpf/2;
            dpOut = op_out.dpf/2;
            
            xform_jrgeco1aCorr = mouse.physics.correctHb(xform_jrgeco1a,xform_datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
            xform_jrgeco1aCorr = process.smoothImage(xform_jrgeco1aCorr,systemInfo.gbox,systemInfo.gsigma);
            
            [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
            [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.FADEmissionFile));
            
            dpIn_FAD = op_in_FAD.dpf/2;
            dpOut_FAD = op_out_FAD.dpf/2;
            
            
            xform_FADCorr = mouse.physics.correctHb(xform_FAD,xform_datahb,...
                [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
            clear xform_datahb
            xform_FADCorr = mouse.process.smoothImage(xform_FADCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data%%%%%

            save(fullfile(saveDir_corrected,processedName),'xform_jrgeco1aCorr','xform_FADCorr',...
                'op_in', 'E_in','op_out', 'E_out','op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD')
            clear xform_jrgeco1a xform_jrgeco1aCorr xform_FAD xform_FADCorr
            %                                     save(fullfile(saveDir,processedName),'xform_jrgeco1a','xform_jrgeco1aCorr','xform_red','xform_FAD','xform_FADCorr','xform_green','op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','-append','-v7.3')
        end
    end
    
    %end
    clearvars -except excelFile excelRows runs isDetrend
end



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
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    if exist(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'file')
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataFluor.mat')),'xform_isbrain');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-','LandmarksAndMask.mat')),'affineMarkers')
    else
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        load(fullfile(maskDir,maskName),'affineMarkers','xform_isbrain','isbrain')
    end
    
    
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    saveDir_corrected = fullfile('X:\XW\NoFilteredEmEx\WT',recDate);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        if exist(fullfile(saveDir,processedName),'file')
            if strcmp(sessionType,'fc')
                
                    disp('loading processed data')
                    load(fullfile(saveDir,processedName),'xform_datahb','xform_jrgeco1a')
                    disp(strcat('fc QC check on ', processedName))                   
                        load(fullfile(saveDir_corrected, processedName),'xform_FADCorr','xform_jrgeco1aCorr')
                        sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
                        sessionInfo.bandtype_Delta = {"Delta",0.4,4};
                        total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
                        
                        
                        xform_jrgeco1aCorr = real(double(xform_jrgeco1aCorr));
                        xform_FADCorr = real(double(xform_FADCorr));
                        total = real(double(total));
                        xform_datahb = real(double(xform_datahb));
                        disp('calculate pds')
                        [hz,powerdata_jrgeco1aCorr] = QCcheck_CalcPDS(xform_jrgeco1aCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_jrgeco1a] = QCcheck_CalcPDS(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_FADCorr] = QCcheck_CalcPDS(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_total] = QCcheck_CalcPDS(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_oxy] = QCcheck_CalcPDS((xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_deoxy] = QCcheck_CalcPDS(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        
                        [hz,powerdata_average_jrgeco1aCorr] = QCcheck_CalcPDSAverage(xform_jrgeco1aCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_jrgeco1a] = QCcheck_CalcPDSAverage(double(xform_jrgeco1a)/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_FADCorr] = QCcheck_CalcPDSAverage(xform_FADCorr/0.01,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_total] = QCcheck_CalcPDSAverage(total*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_oxy] = QCcheck_CalcPDSAverage(xform_datahb(:,:,1,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        [~,powerdata_average_deoxy] = QCcheck_CalcPDSAverage(xform_datahb(:,:,2,:)*10^6,sessionInfo.framerate,xform_isbrain);
                        
                        clear xform_datahb
                        
                        
                        disp('calculate power map')
                        jrgeco1aCorr_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                        FADCorr_ISA_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                        total_ISA_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
                        
                        jrgeco1aCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                        FADCorr_Delta_powerMap = QCcheck_CalcPowerMap(double(xform_FADCorr)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                        total_Delta_powerMap = QCcheck_CalcPowerMap(double(total)*10^6,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
                        
                        disp('calculate fc')
                        refseeds=GetReferenceSeeds;
                        %refseeds = refseeds(1:14,:);
                        
                        [R_jrgeco1aCorr_ISA,Rs_jrgeco1aCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                        [R_FADCorr_ISA,Rs_FADCorr_ISA] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                        [R_total_ISA,Rs_total_ISA] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
                        
                        [R_jrgeco1aCorr_Delta,Rs_jrgeco1aCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                        [R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(xform_FADCorr)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                        [R_total_Delta,Rs_total_Delta] = QCcheck_CalcRRs(refseeds,double(total)*10^6,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
                        
                        clear xform_FADCorr xform_jrgeco1aCorr xform_jrgeco1a total
                        
                        
                        
                        save(fullfile(saveDir_corrected, processedName),'powerdata_jrgeco1aCorr','powerdata_jrgeco1a','powerdata_FADCorr','powerdata_total','powerdata_oxy','powerdata_deoxy',...
                            'powerdata_average_jrgeco1aCorr','powerdata_average_jrgeco1a','powerdata_average_FADCorr','powerdata_average_total','powerdata_average_oxy','powerdata_average_deoxy','hz',...
                            'jrgeco1aCorr_ISA_powerMap','FADCorr_ISA_powerMap','total_ISA_powerMap','jrgeco1aCorr_Delta_powerMap','FADCorr_Delta_powerMap','total_Delta_powerMap',...
                            'R_jrgeco1aCorr_ISA','Rs_jrgeco1aCorr_ISA','R_FADCorr_ISA','Rs_FADCorr_ISA','R_total_ISA','Rs_total_ISA',...
                            'R_jrgeco1aCorr_Delta','Rs_jrgeco1aCorr_Delta','R_FADCorr_Delta','Rs_FADCorr_Delta','R_total_Delta','Rs_total_Delta','xform_isbrain','-append')
                        
                        
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
                        
                        
                        QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,...
                            saveDir_corrected,strcat(visName, '_powerCurve'))
                        
                        
                        leftData = cell(3,1);
                        leftData{1} = powerdata_average_jrgeco1aCorr;
                        leftData{2} = powerdata_average_jrgeco1a;
                        leftData{3} = powerdata_average_FADCorr;
                        
                        rightData = cell(3,1);
                        rightData{1} = powerdata_average_oxy;
                        rightData{2} = powerdata_average_deoxy;
                        rightData{3} = powerdata_average_total;
                        
                        %                 leftLabel = 'Fluor(\DeltaF/F%)^2/Hz)';
                        %                 rightLabel = 'Hb(\muM^2/Hz)';
                        %                 leftLineStyle = {'m-','y-','g-'};
                        %                 rightLineStyle= {'r-','b-','k-'};
                        %                 legendName = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD","HbO","HbR","HbT"];
                        %
                        %                 leftLegend = ["Corrected jRGECO1a","jRGECO1a","Corrected FAD"];
                        %                 rightLegend = ["HbO","HbR","HbT"];
                        
                        
                        
                        QCcheck_fftVis(hz, leftData,rightData,leftLabel,rightLabel,leftLineStyle,rightLineStyle,legendName,...
                           saveDir_corrected,strcat(visName, '_powerCurve_average'))
                        %
                        %
                        QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir_corrected,strcat(visName, '_FADcam2ISA'))
                        QCcheck_powerMapVis(FADCorr_ISA_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir_corrected,strcat(visName, '_FADISA'))
                        QCcheck_powerMapVis(total_ISA_powerMap,xform_isbrain,'\muM',saveDir_corrected,strcat(visName, "_TotalISA"))

                        QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir_corrected,strcat(visName, "_FADcam2Delta"))
                        QCcheck_powerMapVis(FADCorr_Delta_powerMap,xform_isbrain,'(\DeltaF/F%)',saveDir_corrected,strcat(visName,"_FADDelta"))
                        QCcheck_powerMapVis(total_Delta_powerMap,xform_isbrain,'\muM',saveDir_corrected,strcat(visName,"_TotalDelta"))

                        
                        
                        
                        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA, Rs_jrgeco1aCorr_ISA,'FADCorr cam2','m','ISA',...
                            saveDir_corrected,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',...
                            saveDir_corrected,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_total_ISA, Rs_total_ISA,'total','k','ISA',...
                            saveDir_corrected,visName,false,xform_isbrain)
                        close all
                        
                        QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta,'FADCorr cam2','m','Delta',...
                            saveDir_corrected,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',...
                            saveDir_corrected,visName,false,xform_isbrain)
                        close all
                        QCcheck_fcVis(refseeds,R_total_Delta, Rs_total_Delta,'total','k','Delta',...
                            saveDir_corrected,visName,false,xform_isbrain)
                        close all

            elseif strcmp(sessionType,'stim')
                disp('loading processed data')
                load(fullfile(saveDir,processedName),'xform_datahb')
                for ii = 1:size(xform_datahb,4)
                    xform_isbrain(isinf(xform_datahb(:,:,1,ii))) = 0;
                    xform_isbrain(isnan(xform_datahb(:,:,1,ii))) = 0;
                    
                end
                xform_datahb(isinf(xform_datahb)) = 0;
                xform_datahb(isnan(xform_datahb)) = 0;
                %             load('D:\OIS_Process\noVasculatureMask.mat')
                %
                %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
                sessionInfo.stimblocksize = excelRaw{11};
                sessionInfo.stimbaseline=excelRaw{12};
                sessionInfo.stimduration = excelRaw{13};
                sessionInfo.stimFrequency = excelRaw{16};
                stimStartTime = 5;
                info.freqout=1;
                disp('loading Non GRS data')
                
                 load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                        'xform_jrgeco1a','xform_red','xform_FAD','xform_green','xform_datahb','ROI_NoGSR','ROI_GSR')
                 load(fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                     'xform_jrgeco1aCorr','xform_FADCorr')        
                numBlock = size(xform_datahb,4)/sessionInfo.stimblocksize;
                
                numDesample = size(xform_datahb,4)/sessionInfo.framerate*info.freqout;
                factor = round(numDesample/numBlock);
                numDesample = factor*numBlock;
                %
                texttitle_NoGSR = strcat(mouseName,'-stim',num2str(n)," ",'without GSR nor filtering');
                output_NoGSR= fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-NoGSR'));
                disp('QC on non GSR stim')
                
                
                [goodBlocks_NoGSR,ROI_NoGSR] = QC_stim_WT_FAD_camera2(squeeze(xform_datahb(:,:,1,:))*10^6,squeeze(xform_datahb(:,:,2,:))*10^6,...
                    xform_FAD*100,xform_FADCorr*100,xform_green*100,xform_jrgeco1a*100,xform_jrgeco1aCorr*100,xform_red*100,...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_NoGSR,output_NoGSR,ROI_NoGSR);
                
                close all
                save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_NoGSR','ROI_NoGSR','-append')
                
                disp('loading GRS data')
                
                texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
                output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'-GSR'));
                  
                load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_red_GSR','xform_FAD_GSR','xform_green_GSR')
              

                xform_jrgeco1aCorr_GSR = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
                clear xform_jrgeco1aCorr
                xform_FADCorr_GSR = mouse.process.gsr(xform_FADCorr,xform_isbrain);
                clear xform_FADCorr
                disp('saving fluorescence related data')
                
                save(fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),...
                    'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR','xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','-append')
                
                disp('QC on GSR stim')
                [goodBlocks_GSR,ROI_GSR] = QC_stim_WT_FAD_camera2(squeeze(xform_datahb_GSR(:,:,1,:))*10^6,squeeze(xform_datahb_GSR(:,:,2,:))*10^6,...
                    xform_FAD_GSR*100,xform_FADCorr_GSR*100,xform_green_GSR*100,xform_jrgeco1a_GSR*100,xform_jrgeco1aCorr_GSR*100,xform_red_GSR*100,...
                    xform_isbrain,numBlock,numDesample,stimStartTime,sessionInfo.stimduration,sessionInfo.stimFrequency,sessionInfo.framerate,sessionInfo.stimblocksize,sessionInfo.stimbaseline,texttitle_GSR,output_GSR,ROI_GSR);
                save(fullfile(saveDir_corrected,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','goodBlocks_NoGSR','ROI_NoGSR','ROI_GSR','-append')
                
                
            end
            close all
            
        end
        
    end
end