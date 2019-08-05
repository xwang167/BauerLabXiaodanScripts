
%% This script is used to add the FAD process and analysis to the processed data
close all;clear all;clc
import mouse.*
excelFile = "D:\FAD\FAD_awake.xlsx";


nVx = 128;
nVy = 128;
%
excelRows = [182];%[181:186  195 202:205];

runs =1:3;
isDetrend = 1;

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
    
    
    sessionInfo.FADspecies = 1;
    sessionInfo.FADEmissionFile = "fad_emission.txt";
    
    
    systemInfo.numLEDs = 4;
    systemInfo.LEDFiles = ["TwoCam_Mightex470_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_Mightex525_BP_Pol.txt", ...
        "TwoCam_TL625_Pol.txt"];
    
    systemInfo.invalidFrameInd = 1;
    systemInfo.gbox = 5;
    systemInfo.gsigma = 1.2;
    
    
    
    
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'affineMarkers')
    
    
    pkgDir = what('bauerParams');
    
    fluorDir = fullfile(pkgDir.path,'probeSpectra');
    sessionInfo.FADEmissionFile = fullfile(fluorDir,sessionInfo.FADEmissionFile);
    
    for n = runs
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        disp('loading raw data')
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        
        load(fullfile(saveDir,rawName),'rawdata')
        
        if mod(sessionInfo.darkFrameNum,systemInfo.numLEDs)~=0
            sessionInfo.darkFrameNum = sessionInfo.darkFrameNum+1;
        end
        
        
        
        
        
        maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
        load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-dataHb','.mat')),'xform_isbrain');
        load(fullfile(maskDir,maskName), 'affineMarkers','isbrain')
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        QCcheck_raw(rawdata(:,:,:,sessionInfo.darkFrameNum/systemInfo.numLEDs+2:end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
        
        disp('preprocess raw and tranform raw');
        
        % detrend raw
        if sessionInfo.darkFrameNum ==0
            raw_nondark =rawdata;
            darkName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Dark.mat');
            darkName =  fullfile(rawdataloc,recDate,darkName);
            load(darkName)
            darkFrame = squeeze(mean(rawdata(:,:,:,2:end),4));
            clear rawdata
            raw_baselineMinus = raw_nondark - repmat(darkFrame,1,1,1,size(raw_nondark,4));
            clear raw_baselineMinus
            rawdata = raw_baselineMinus;
        else
            darkFrameInd = 2:sessionInfo.darkFrameNum/systemInfo.numLEDs;
            darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
            raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
            clear rawdata
            raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/systemInfo.numLEDs)=[];
            rawdata = raw_baselineMinus;
            clear raw_baselineMinus
            
        end
        
        if strcmp(sessionType,'stim')
            rawdata(:,:,:,1) = rawdata(:,:,:,2);
        elseif strcmp(sessionType,'fc')
            rawdata(:,:,:,1) = [];
        end
        if isDetrend
            %                 raw_detrend = process.temporalDetrend(rawdata,true);
            raw_detrend = temporalDetrendAdam(rawdata);
        end
        % affine transform
        
        
        xform_raw = process.affineTransform(raw_detrend,affineMarkers);
        clear raw_detrend
        xform_raw(isnan(xform_raw)) = 0;
        disp(strcat('get hemoglobin data for', recDate,'-',mouseName,'-',sessionType,num2str(n)));
        
        xform_isbrain(isnan(xform_isbrain)) = 0;
        xform_isbrain = logical(xform_isbrain);
        
        BaselineFunction  = @(x) mean(x,numel(size(x)));
        baselineValues = BaselineFunction(xform_raw);
        
        load(fullfile(saveDir,processedName),'xform_datahb')
        
        
        
        
        
        disp('correct FAD')
        xform_FAD = squeeze(xform_raw(:,:,sessionInfo.FADSpecies,:));
        xform_FAD = mouse.expSpecific.procFluor(xform_FAD); % make the data ratiometric
        
        
        
        
        baseline = nanmean(xform_FAD,3);
        xform_FAD = xform_FAD./repmat(baseline,[1 1 size(xform_FAD,3)]); % make the data ratiometric
        xform_FAD = xform_FAD - 1; % make the data change from baseline (center at zero)
        
        
        [op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,systemInfo.LEDFiles(sessionInfo.FADSpecies));
        [op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,sessionInfo.FADEmissionFile);
        
        
        dpIn_FAD = op_in_FAD.dpf/2;
        dpOut_FAD = op_out_FAD.dpf/2;
        
        
        xform_FADCorr = mouse.physics.correctHb(xform_FAD,xform_datahb,...
            [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);
        xform_green = squeeze(xform_raw(:,:,3,:));
        clear xform_raw
        xform_FAD = process.smoothImage(xform_FAD,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
        xform_FADCorr = process.smoothImage(xform_FADCorr,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
        
        baseline = nanmean(xform_green,3);
        xform_green = xform_green./repmat(baseline,[1 1 size(xform_green,3)]); % make the data ratiometric
        xform_green = xform_green - 1;
        xform_green = process.smoothImage(xform_green,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
        
        save(fullfile(saveDir, processedName),'xform_FAD','xform_FADCorr','xform_green',...
            'op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','op_in_FAD', 'E_in_FAD','op_out_FAD', 'E_out_FAD','-append')
    end
    
    
    
end





for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    
    load(fullfile(maskDir,maskName), 'isbrain');
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    maskName = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    load(fullfile(maskDir,maskName), 'isbrain');
    load(fullfile(maskDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-dataHb','.mat')),'xform_isbrain');
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'rawdata')
        disp(strcat('QC raw for ',rawName))
        QCcheck_raw(rawdata(:,:,:,(sessionInfo.darkFrameNum/4+1):end),isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType)
        
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')
        
        if strcmp(sessionType,'fc')
            load(fullfile(saveDir, processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
            
            disp(char(['QC check on ', processedName]))
            QCcheck_fc_twoFluor(double(squeeze(xform_jrgeco1aCorr)),double(squeeze(xform_FADCorr)),'FAD','jrgeco1a','g','r',xform_isbrain, sessionInfo.framerate,saveDir,strcat(visName,'_processed'),true);
            clear xform_FADCorr xform_jrgeco1aCorr
            
            
        elseif strcmp(sessionType,'stim')
            
            load('D:\OIS_Process\noVasculatureMask.mat')
            
            xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
            sessionInfo.stimblocksize = excelRaw{11};
            sessionInfo.stimbaseline=excelRaw{12};
            sessionInfo.stimduration = excelRaw{13};
            sessionInfo.stimFrequency = excelRaw{16};
            info.freqout=1;
            if ~isempty(excelRaw(20))
                fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                load(fullfile(saveDir,fileName_cam1));
                startInd = sessionInfo.darkFrameNum/systemInfo.numLEDs/sessionInfo.framerate*excelRaw{20};
                time = timeStamps(startInd+1:end);
                darkTime = timeStamps(startInd);
                input_stimbox = data(startInd+1:end);
                time = time(1:end/4)-darkTime;
                input_stimbox = input_stimbox(1:end/4);
                [~,locs] = findpeaks(input_stimbox,'MinPeakHeight',4.5);
                sessionInfo.stimbaseline = round(time(locs(1))*sessionInfo.framerate);
            end
            
            
            disp('loading GRS data')
            load(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_datahb_GSR','xform_jrgeco1a_GSR','xform_jrgeco1aCorr_GSR','xform_red_GSR')
            xform_FAD_GSR = mouse.process.gsr(xform_FAD,xform_isbrain);
            clear xform_FAD
            xform_FADCorr_GSR = mouse.process.gsr(xform_FADCorr,xform_isbrain);
            clear xform_FADCorr
            xform_green_GSR = mouse.process.gsr(xform_green,xform_isbrain);
            clear xform_green
            disp('saving')
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'xform_FAD_GSR','xform_FADCorr_GSR','xform_green_GSR','-append')
            numBlock = size(red_GSR,3)/sessionInfo.stimblocksize;
            
            
            numDesample = size(red_GSR,3)/sessionInfo.framerate*info.freqout;
            factor = round(numDesample/numBlock);
            numDesample = factor*numBlock;
            
            
            oxy_downsampled_GSR  = processAndDownsample(squeeze(xform_datahb_GSR(:,:,1,:)),xform_isbrain,numBlock,numDesample);
            deoxy_downsampled_GSR  = processAndDownsample(squeeze(xform_datahb_GSR(:,:,2,:)),xform_isbrain,numBlock,numDesample);
            total_downsampled_GSR  = processAndDownsample(squeeze(xform_datahb_GSR(:,:,1,:)+xform_datahb_GSR(:,:,2,:)),xform_isbrain,numBlock,numDesample);
            
            FAD_downsampled_GSR  = processAndDownsample(xform_FAD_GSR,xform_isbrain,numBlock,numDesample);
            FADCorr_downsampled_GSR  = processAndDownsample(xform_FADCorr_GSR,xform_isbrain,numBlock,numDesample);
            green_downsampled_GSR  = processAndDownsample(xform_green_GSR,xform_isbrain,numBlock,numDesample);
            
            jrgeco1a_downsampled_GSR  = processAndDownsample(xform_jrgeco1a_GSR,xform_isbrain,numBlock,numDesample);
            jrgeco1aCorr_downsampled_GSR  = processAndDownsample(xform_jrgeco1aCorr_GSR,xform_isbrain,numBlock,numDesample);
            red_downsampled_GSR  = processAndDownsample(xform_red_GSR,xform_isbrain,numBlock,numDesample);
            stimEndTime= stimStartTime+sessionInfo.stimduration;
            [goodBlocks,temp_jrgeco1aCorr_max] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxy_downsampled_GSR,deoxy_downsampled_GSR,total_downsampled_GSR,FADCorr_downsampled_GSR,jrgeco1a_downsampled_GSR);
            
            
            texttitle_GSR = strcat(mouseName,'-stim',num2str(n)," ",'with GSR without filtering');
            output_GSR= fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_GSR'));
            texttitle = strcat(' Peak Map for each block', {' '},texttitle_GSR,{' '}, 'blocks ',{' '}, answer{1},'are picked');
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',texttitle,'FontWeight','bold','Color',[1 0 0],'FontSize',16);
            
            output1 = strcat(outputName_GSR,'_BlockPeakMap.jpg');
            orient portrait
            print ('-djpeg', '-r1000',output1);
            save(fullfile(saveDir,strcat(recDate,'-',mouseName,'-stim',num2str(n),'_processed.mat')),'goodBlocks_GSR','-append')
            
            if ~isempty(goodBlocks_GSR)
                [oxy_downsampled_blocks,oxy_GSR_blocks] = blockAverage...
                    (oxy_downsampled_GSR, squeeze(xform_datahb_GSR(:,:,1,:)),goodBlocks,numBlock);
                [deoxy_downsampled_blocks,deoxy_GSR_blocks] = blockAverage...
                    (deoxy_downsampled_GSR, squeeze(xform_datahb_GSR(:,:,2,:)),goodBlocks,numBlock);
                total_downsampled_blocks = oxy_downsampled_blocks+deoxy_downsampled_blocks;
                
                [jrgeco1aCorr_downsampled_blocks,jrgeco1aCorr_GSR_blocks] = blockAverage...
                    (jrgeco1aCorr_downsampled_GSR, xform_jrgeco1aCorr_GSR,goodBlocks,numBlock);
                [jrgeco1a_downsampled_blocks,jrgeco1a_GSR_blocks] = blockAverage...
                    (jrgeco1a_downsampled_GSR, xform_jrgeco1a_GSR,goodBlocks,numBlock);
                [red_downsampled_blocks,red_GSR_blocks] = blockAverage...
                    (red_downsampled_GSR, xform_red_GSR,goodBlocks,numBlock);
                
                [FADCorr_downsampled_blocks,FADCorr_GSR_blocks] = blockAverage...
                    (FADCorr_downsampled_GSR, xform_FADCorr_GSR,goodBlocks,numBlock);
                [FAD_downsampled_blocks,FAD_GSR_blocks] = blockAverage...
                    (FAD_downsampled_GSR, xform_FAD_GSR,goodBlocks,numBlock);
                [green_downsampled_blocks,green_GSR_blocks] = blockAverage...
                    (green_downsampled_GSR, xform_green_GSR,goodBlocks,numBlock);
               %% ROI 
                
                imagesc(jrgeco1aCorr_downsampled_blocks(:,:,stimEndTime),[-temp_jrgeco1aCorr_max,temp_jrgeco1aCorr_max])
                colorbar
                axis image off
                title('jrgeco1aCorr');
                colormap jet
                
                
                hold on
                contour(ROI_barrel,'k')
                [x1_jrgeco1aCorr,y1_jrgeco1aCorr] = ginput(1);
                [x2_jrgeco1aCorr,y2_jrgeco1aCorr] = ginput(1);
                
                radius_jrgeco1aCorr = sqrt((x1_jrgeco1aCorr-x2_jrgeco1aCorr)^2+(y1_jrgeco1aCorr-y2_jrgeco1aCorr)^2);
                ROI_jrgeco1aCorr = sqrt((X-x1_jrgeco1aCorr).^2+(Y-y1_jrgeco1aCorr).^2)<radius_jrgeco1aCorr;
                
                max_jrgeco1aCorr = prctile(Avgjrgeco1aCorr_stim(ROI_jrgeco1aCorr),99);
                temp = Avgjrgeco1aCorr_stim.*ROI_jrgeco1aCorr;
                ROI_jrgeco1aCorr = temp>0.75*max_jrgeco1aCorr;
                
                figure;
                imagesc(ROI_jrgeco1aCorr);
                axis image off;
                ROI_holes = roipoly;
                %ROI_smallarea = roipoly;
                %
                ROI_jrgeco1aCorr(ROI_holes)= 1;
                ROI_jrgeco1aCorr = logical(ROI_jrgeco1aCorr);
                %     ROI_jrgeco1aCorr(ROI_smallarea) = 0;
                ROI_jrgeco1aCorr_contour = bwperim(ROI_jrgeco1aCorr);
                activeArea = repmat(ROI_jrgeco1aCorr,1,1,size(jrgeco1aCorr_GSR_blocks,3));
                
                %% Time trace plot
                jrgeco1aCorr_active = mean(jrgeco1aCorr_GSR_blocks(activeArea));
                FADCorr_active = mean(FADCorr_GSR_blocks(activeArea));
                
                oxy_active = mean(oxy_GSR_blocks(activeArea));
                deoxy_active = mean(deoxy_GSR_blocks(activeArea));
                total_active = mean(total_GSR_blocks(activeArea));
                
                cMax = max(abs([oxy_active,deoxy_active,total_active]),[],'all');
                
                fMax = max(abs([jrgeco1aCorr_active,FADCorr_active]),[],'all');
                
                
                figure;
                x = (1:round(sessionInfo.stimblocksize))/sessionInfo.framerate;
                yyaxis left
                plot(x,jrgeco1aCorr_active,'m-');
                hold on
                plot(x,FADCorr)
                ylim([-1.1*max_fMax 1.1*fMax])
                ylabel('Fluorescence(\DeltaF/F)','FontSize',12);
                hold on
                
                
                
                yyaxis right
                plot(x,oxy_blocks_baseline_active,'r-');
                hold on
                plot(x,deoxy_blocks_baseline_active,'b-');
                hold on
                plot(x,total_blocks_baseline_active,'Color',[.61 .51 .74]);
                set(findall(gca, 'Type', 'Line'),'LineWidth',1);
                
                hold on
                xlabel('Time(s)','FontSize',12)
                ylabel('Hb(\DeltaM)','FontSize',12)
                ylim([-1.1*cMax 1.1*cMax])
                
                xlim([0 round(sessionInfo.stimblocksize/sessionInfo.framerate)]                
                
                for i  = 0:1/sessionInfo.stimFrequency:sessionInfo.stimduration-1/sessionInfo.stimFrequency
                    line([sessionInfo.stimbaseline/sessionInfo.framerate+i sessionInfo.stimbaseline/sessionInfo.framerate+i],[-1.3*max_oxy 1.3*max_oxy]);
                    hold on                   
                end
                
                
                
                
                
            end
            
            
            
            
            close all
            
        end
    end
    
    function downSampledData  = processAndDownsample(data,mask,numBlock,numDesample,stimStartTime)
    %input needs to be 128*128*time
    mask = double(mask);
    data = double(data).*mask;
    data(isnan(data)) = 0;
    data(isinf(data)) = 0;
    data = reshape(data,size(data,1),size(data,2),[],numBlock);
    downSampledData = resampledata(data,size(data,3),numDesample,10^-5);
    downSampledData = reshape(downSampledData,size(data,1),size(data,2),[],numBlock);
    downSampledDataBlockAvg = squeeze(mean(downSampledData,4));
    downSampledDataBaseline = squeeze(mean(downSampledDataBlockAvg(:,:,1:stimStartTime),3));
    downSampledData = downSampledData-downSampledDataBaseline;
    end
    
    function [goodBlocks,temp_jrgeco1aCorr_max] = pickGoodBlocks(stimStartTime,stimEndTime,numBlock,oxyDownSampled, ...
        deoxyDownSampled,totalDownSampled,FADCorrDownSampled,jrgecoCorrDownSampled)
    
    subplot(1,3,1)
    imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,2),3)))
    colorbar
    axis image off
    title('Oxy')
    
    subplot(1,3,2)
    imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,2),3)))
    colorbar
    axis image off
    title('DeOxy')
    
    subplot(1,3,3)
    imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,2),3)))
    colorbar
    axis image off
    title('Total')
    
    colormap jet
    pause;
    prompt = {'Enter oxy limit:';'Enter deoxy limit:';'Enter total limit:'};
    title1 = 'Selet scale';
    dims = [1 35];
    definput = {'8e-6';'2e-6';'6e-6'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_oxy_max = str2double(answer{1});
    temp_deoxy_max = str2double(answer{2});
    temp_total_max = str2double(answer{3});
    close all;
    
    figure
    subplot(1,2,1)
    imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,2),3)))
    colorbar
    axis image off
    title('jrgeco1aCorr')
    
    subplot(1,2,2)
    imagesc(squeeze(mean(FADCorrDownSampled(:,:,stimStartTime+1:stimEndTime,2),3)))
    colorbar
    axis image off
    title('FADCorr')
    colormap jet
    pause;
    prompt = {'Enter jrgeco1aCorr limit:';'Enter FADCorr limit:'};
    title1 = 'Selet scale';
    dims = [1 35];
    definput = {'0.01','0.01'};
    answer = inputdlg(prompt,title1,dims,definput);
    temp_jrgeco1aCorr_max = str2double(answer{1});
    temp_FADCorr_max = str2double(answer{2});
    numRows = 4;
    
    close all
    
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    for ii = 1:numBlock
        subplot(numRows,numBlock,ii)
        imagesc(squeeze(mean(oxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_oxy_max temp_oxy_max]);
        title(strcat('Pres',{' '},num2str(ii)))
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if ii == 1
            ylabel('oxy')
        end
        
        subplot(numRows,numBlock,numBlock+ii)
        imagesc(squeeze(mean(deoxyDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_deoxy_max temp_deoxy_max]);
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if ii == 1
            ylabel('deoxy')
        end
        
        
        subplot(numRows,numBlock,2*numBlock+ii)
        imagesc(squeeze(mean(totalDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_total_max temp_total_max]);
        colormap jet
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if ii == 1
            ylabel('total')
        end
        
        subplot(numRows,numBlock,3*numBlock+ii)
        imagesc(squeeze(mean(jrgecoCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_jrgeco1aCorr_max temp_jrgeco1aCorr_max]);
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if ii == 1
            ylabel('jrgeco1aCorr')
        end
        subplot(numRows,numBlock,3*numBlock+ii)
        imagesc(squeeze(mean(FADCorrDownSampled(:,:,stimStartTime+1:stimEndTime,ii),3)),[-temp_FADCorr_max temp_FADCorr_max]);
        if ii == 1
            ylabel('FADCorr')
        end
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
    
    prompt = {'Bad blocks to remove:'};
    title1 = 'Pick block';
    dims = [1 35];
    definput = {strcat('[', num2str(1), ']')};
    answer = inputdlg(prompt,title1,dims,definput);
    blocks = 1:numBlocks;
    blocks(answer) = [];
    goodBlocks = blocks;
    end
    
    function [downSampledDataBlockAvg,dataBlockAvg] = blockAverage(downSampledData,data,goodBlocks,numBlock)
    downSampledDataBlockAvg = squeeze(mean(downSampledData(:,:,:,goodBlocks),4));
    data = reshape(data,size(data,1),size(data,2),[],numBlock);
    dataBlockAvg = squeeze(mean(data(:,:,:,goodBlocks),4));
    dataBlockAvgBaseline = squeeze(mean(data(:,:,1:stimStartTime),3));
    dataBlockAvg = dataBlockAvg - dataBlockAvgBaseline;
    end
    
    function  traceImage(downSampledBlocks1,downSampledBlocks2,downSampledBlocks3,name1,name2,name3,active1,active2,active3,color1,color2,color3,ROI_contour,yunit,stimDuration,stimFrequency,framerate,stimStartTime,stimEndTime);
    
    
    
    figure;
    subplot('position',[0.05,0.08,0.7,0.35])
    plot(x,active1,'color',color1);
    hold on
    plot(x,active2,'color',color2);
    hold on
    plot(x,active3,'color',color3);
    hold on
    
    minimum = min([active1 active2 active3],[],'all'); 
    maxmum = max([active1 active2 active3],[],'all');
    
    set(findall(gca, 'Type', 'Line'),'LineWidth',2);

    for i  = 0:1/stimFrequency:stimduration-1/stimFrequency
        line([stimbaseline/framerate+i stimbaseline/framerate+i],[ 1.1*minimum 1.1*maxmum]);
        hold on
    end

    ax = gca;
    ax.FontSize = 8;
    xlim([0 round(stimblocksize/framerate)])
    
    ylim([ 1.1*minimum 1.1*maxmum])
    [max1,loc1] = max(active1);
    [max2,loc2] = max(active2);
    [max3,loc3] = max(active3);
    
    
    
    lgd =legend(name1,name2,name3);
    lgd.FontSize = 14;
    xlabel('Time(s)','FontSize',20,'FontWeight','bold')
    ylabel(unit,'FontSize',20,'FontWeight','bold')
    
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',14,'fontweight','bold')

    subplot('position',[0.8,0.1,0.2,0.25])
  
    imagesc(Avgjrgeco1aCorr_stim*100,[-temp_jrgeco1aCorr_max*100 temp_jrgeco1aCorr_max*100])
    colormap jet
    hold on
    contour(ROI_jrgeco1aCorr_contour,'k')
    axis image off
    c = colorbar;
    c.FontSize = 14;
    c.FontWeight = 'bold';
    title('Corrected jrgeco1a 75%','fontsize',16)
    title('Corrected jrgeco1a Percentage Change')
    
    
    for b=stimStartTime: stimEndTime+4
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
        imagesc(downSampledBlocks1(:,:,b), [-0.3*temp_jrgeco1aCorr_max 0.3*temp_jrgeco1aCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.80 0.07 0.12]);
        end
        axis image
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b == 4
            ylabel('625nm')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    for b=stimStartTime: stimEndTime+4
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
        imagesc(jrgeco1a_blocks_baseline_downsampled(:,:,b), [-1*temp_jrgeco1aCorr_max 1*temp_jrgeco1aCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.64 0.07 0.12]);
        end
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==startSecond
            ylabel('jrgeco1a')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    
    
    for b=stimStartTime: stimEndTime+4
        p = subplot('position', [0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
        imagesc(jrgeco1aCorr_blocks_baseline_downsampled(:,:,b), [-1*temp_jrgeco1aCorr_max 1*temp_jrgeco1aCorr_max]);
        if b == startSecond+9
            colorbar
            set(p,'Position',[0.015+(b-startSecond)*0.09 0.48 0.07 0.12]);
        end
        axis image;
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        if b==startSecond
            ylabel('jrgeco1aCorr')
        end
        title([num2str(b),'s']);
        ax = gca;
        ax.FontSize = 10;
        colormap jet
    end
    
    
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
