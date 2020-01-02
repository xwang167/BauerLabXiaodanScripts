close all;clear all;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

excelRows = [231,235,241];%[229,231,233,235];%203,2   

runs = 1:3;
nVy = 128;
nVx = 128;

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
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    saveDir_new = fullfile("K:\RGECO\Raw",recDate);
    if ~exist(saveDir_new)
        mkdir(saveDir_new)
    end
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.stimbaseline = excelRaw{12};
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %    load(fullfile(maskDir_new,maskName_new), 'isbrain')
    %   isbrain = double(isbrain);
    isbrain = ones(128,128);
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        if strcmp(systemType,'EastOIS2')
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                load(fullfile(saveDir,rawName))
                load(fullfile(saveDir,maskName_new),'affineMarkers')
                numChan = size(rawdata,3);
                xform_raw = process.affineTransform(rawdata(:,:,:, sessionInfo.darkFrameNum/numChan+1:end),affineMarkers);
                
            else
                rawName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
                load(fullfile(rawdataloc,recDate,rawName_cam1))
                rawdata = raw_unregistered;
                rawName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
                load(fullfile(rawdataloc,recDate,rawName_cam2))
                rawdata(:,:,2,:) = raw_unregistered(:,:,2,:);
            end
            
            
        else
            rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
            rawdata = double(readtiff(fullfile(rawdataloc ,recDate,rawName)));
        end
        
        if strcmp(sessionInfo.mouseType,'jrgeco1a-opto4')
            rawdata = reshape(rawdata,128,128,5,[]);
            peakMap_ROI = rawdata(:,:,5,sessionInfo.stimbaseline+2);
        elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')
            rawdata = reshape(rawdata,128,128,3,[]);
            peakMap_ROI = rawdata(:,:,3,sessionInfo.stimbaseline+2);
        end
        
        %
        if strcmp(sessionInfo.mouseType,'jrgeco1a')
            processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
            load(fullfile('K:\RGECO\Raw\awake_ROI.mat'),'ROI_NoGSR')
            ROI = ROI_NoGSR;
        else
            imagesc(peakMap_ROI)
            axis image off
            colormap jet
            [x1,y1] = ginput(1);
            [X,Y] = meshgrid(1:128,1:128);
            radius = 5;
            ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
            max_ROI = prctile(peakMap_ROI(ROI),70);
            temp = double(peakMap_ROI).*double(ROI);
            ROI = temp>=max_ROI;
            hold on
            ROI_contour = bwperim(ROI);
            contour( ROI_contour,'k');
            pause;
            nonROI = roipoly();
            ROI(nonROI) = 0;
            figure;
            imagesc(peakMap_ROI)
            axis image off
            colormap jet
            hold on
            ROI_contour = bwperim(ROI);
            contour( ROI_contour,'k');
        end
        
        
        %save(fullfile(saveDir_new,'ROI.mat'),'ROI')
        
        %             load('D:\OIS_Process\noVasculatureMask.mat')
        %             xform_isbrain= xform_isbrain.*(double(leftMask)+double(rightMask));
        sessionInfo.stimblocksize = excelRaw{11};
        sessionInfo.stimbaseline=excelRaw{12};
        sessionInfo.stimduration = excelRaw{13};
        sessionInfo.stimFrequency = excelRaw{16};
        stimStartTime = 5;

        %
        %
        %         load(fullfile(saveDir_new,'ROI.mat'))
        %load(fullfile(saveDir,strcat(visName,'_processed.mat')),'ROI_NoGSR')
        %        ROI = ROI_NoGSR;
        
        
        
        texttitle= strcat(mouseName,'-stim',num2str(n)," ",'xform raw in ROI from Corrected Fluor');
        output = fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-stim',num2str(n),'for Raw'));
        disp('QC on non GSR stim')
        
        
        
        
        
        if strcmp(sessionInfo.mouseType,'jrgeco1a')
            QC_stim_raw(squeeze(xform_raw(:,:,3,:)), squeeze(xform_raw(:,:,4,:)),squeeze(xform_raw(:,:,2,:)),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(xform_raw,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output,systemType)
            
        elseif strcmp(sessionInfo.mouseType,'jrgeco1a-opto4')
            QC_stim_raw(squeeze(rawdata(:,:,1,:)), squeeze(rawdata(:,:,2,:)),squeeze(rawdata(:,:,5,:)),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(rawdata,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output,systemType)
            
            
        elseif    strcmp(sessionInfo.mouseType,'jrgeco1a-opto2')
            QC_stim_raw(squeeze(rawdata(:,:,1,:)), squeeze(rawdata(:,:,2,:)),squeeze(rawdata(:,:,3,:)),sessionInfo.stimbaseline,sessionInfo.stimduration*sessionInfo.framerate,size(rawdata,4)/sessionInfo.stimblocksize,sessionInfo.framerate,ROI,texttitle,output,systemType)
            
        end
        close all
        
        
        
    end
end
