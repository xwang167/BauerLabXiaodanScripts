
close all;clear all;clc
import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelRows = [327];

runs = 1;
isDetrend = 1;
nVy = 128;
nVx = 128;

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
    systemType = excelRaw{5};
    sessionInfo.framerate = excelRaw{7};
    if strcmp(char(sessionInfo.mouseType),'jrgeco1a-opto3')
        maskDir = fullfile(rawdataloc,recDate);
    else
        maskDir = saveDir;
    end
    
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
    load(fullfile(maskDir,maskName),'isbrain')
    
    for n = runs
        
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        if exist(fullfile(saveDir,rawName),'file')
            disp(strcat('registered rawdata file already exist for ',rawName ))
            
        else
            disp('loading unregistered data')
            wlName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
            disp(strcat('Register and Combine two cameras for ', rawName))
            fileName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
            fileName_cam1 = fullfile(rawdataloc,recDate,fileName_cam1);
            fileName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
            fileName_cam2 = fullfile(rawdataloc,recDate,fileName_cam2);
            load(fileName_cam1)
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,4,[]);
                binnedRaw_cam1 = raw_unregistered(:,:,[1,2],:);
                
            end
            clear raw_unregistered
            load(fileName_cam2)
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,4,[]);
                binnedRaw_cam2= raw_unregistered(:,:,[3,4],:);
                load(fullfile(maskDir,wlName),'transformMat');
                rawdata = fluor.registerCam2andCombineTwoCams(binnedRaw_cam1,binnedRaw_cam2,transformMat,sessionInfo.mouseType);
                
            end
            clear raw_unregistered
                 darkFrameInd = 2:sessionInfo.darkFrameNum/size(rawdata,3);
                darkFrame = squeeze(mean(rawdata(:,:,:,darkFrameInd),4));
                raw_baselineMinus = rawdata - repmat(darkFrame,1,1,1,size(rawdata,4));
                clear rawdata
                raw_baselineMinus(:,:,:,1:sessionInfo.darkFrameNum/size(raw_baselineMinus,3))=[];
                rawdata = raw_baselineMinus;
                clear raw_baselineMinus
                
         
            
            
            %                 else
            %                 rawdata = fluor.registerCam2andCombineTwoCams(binnedRaw_cam1(:,:,1,:),binnedRaw_cam2(:,:,[2 3],:),transformMat,sessionInfo.mouseType);
            %                 end
            %                 disp(strcat('QC raw for ',rawName))
            visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
            mdata = QCcheck_raw(rawdata,isbrain,systemType,sessionInfo.framerate,saveDir,visName,sessionInfo.mouseType);
            save(fullfile(saveDir,rawName),'rawdata','mdata','-v7.3')
            
        end
    end
end
