function bleedOverVis(excelFile,excelRows,runs,miceName,saveDir_cat,nVx,nVy,ROI)
import mouse.*
interestedChannel = [1,2,3];
LaserChannel = 4;
% raw_mice = zeros(nVy,nVx,4,600,length(excelRows));
% mouseInd = 1;
% 
% for excelRow = excelRows
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     if ~exist(saveDir)
%         mkdir(saveDir)
%     end
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     sessionInfo.darkFrameNum = excelRaw{15};
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{5};
%     maskDir_new = saveDir;
%     rawdataloc = excelRaw{3};
%     %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
%     sessionInfo.framerate = excelRaw{7};
%     sessionInfo.blockLength = excelRaw{11};
%     sessionInfo.stimbaseline = excelRaw{12};
%     maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
%     %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     %load(fullfile(maskDir,maskName), 'xform_isbrain')
%     %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
%     %    load(fullfile(maskDir_new,maskName_new), 'isbrain')
%     %   isbrain = double(isbrain);
%     isbrain = ones(128,128);
% 
%     raw_mouse = zeros(nVy,nVx,4,sessionInfo.blockLength,length(runs));
%     disp(mouseName)
%     for n = runs
%         visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
%         if strcmp(systemType,'EastOIS2')
%             if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
%                 rawName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
%                 load(fullfile(rawdataloc,recDate,rawName_cam1))
%                 load(fullfile(rawdataloc,recDate,maskName_new),'affineMarkers')
%                 numChan = size(raw_unregistered,3);
%                 rawdata = process.affineTransform(raw_unregistered(:,:,:,sessionInfo.darkFrameNum/numChan+1:end),affineMarkers);
%                 clear raw_unregistered
%             elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
%                 rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%                 load(fullfile(saveDir,rawName))
%                 load(fullfile(saveDir,maskName_new),'affineMarkers')
%                 numChan = size(rawdata,3);
%                 xform_raw = process.affineTransform(rawdata(:,:,:, sessionInfo.darkFrameNum/numChan+1:end),affineMarkers);
%             elseif strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')||strcmp(sessionInfo.mouseType,'PV')
%                 rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
%                 load(fullfile(saveDir,rawName))
%             else
%                 rawName_cam1 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam1.mat');
%                 load(fullfile(rawdataloc,recDate,rawName_cam1))
%                 rawdata = raw_unregistered;
%                 rawName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
%                 load(fullfile(rawdataloc,recDate,rawName_cam2))
%                 rawdata(:,:,2,:) = raw_unregistered(:,:,2,:);
%             end
% 
% 
%         else
%             rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.tif');
%             rawdata = double(readtiff(fullfile(rawdataloc ,recDate,rawName)));
%         end
%         detrendInterestedRaw = temporalDetrendAdam(rawdata(:,:,interestedChannel,:));
%         laserRaw = squeeze(rawdata(:,:,LaserChannel,:));
%         clear rawdata
% 
%         detrendInterestedRaw  = reshape(detrendInterestedRaw,nVx,nVy,size(detrendInterestedRaw,3),sessionInfo.blockLength,[]);
%         laserRaw = reshape(laserRaw,nVx,nVy,sessionInfo.blockLength,[]);
%         raw_mouse(:,:,interestedChannel,:,n) = squeeze(mean(detrendInterestedRaw,5));
%         clear detrendInterestedRaw
%         raw_mouse(:,:,LaserChannel,:,n) = squeeze(mean(laserRaw,4));
%         clear laserRaw
% 
%         disp(['run #' num2str(n)])
%     end
% 
%     raw_mouse = squeeze(mean(raw_mouse,5));
      save(fullfile(saveDir,strcat(reDate,mouseName,'-cam1')),raw_mouse);
%     raw_mice(:,:,:,:,mouseInd)= raw_mouse;
%     mouseInd = mouseInd+1;
% end
% raw_mice = squeeze(mean(raw_mice,5));
% 
% if ~exist('ROI', 'var')
%     peakMap_ROI = raw_mice(:,:,4,sessionInfo.stimbaseline+1);
%     if strcmp(sessionInfo.mouseType,'jrgeco1a')
%         processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
%         load(fullfile('K:\RGECO\Raw\awake_ROI.mat'),'ROI_NoGSR')
%         ROI = ROI_NoGSR;
%     else
%         imagesc(peakMap_ROI)
%         axis image off
%         colormap jet
%         [x1,y1] = ginput(1);
%         [X,Y] = meshgrid(1:128,1:128);
%         radius = 5;
%         ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
%         max_ROI = prctile(peakMap_ROI(ROI),70);
%         temp = double(peakMap_ROI).*double(ROI);
%         ROI = temp>=max_ROI;
%         hold on
%         ROI_contour = bwperim(ROI);
%         contour( ROI_contour,'k');
%         pause;
%         nonROI = roipoly();
%         ROI(nonROI) = 0;
%         figure;
%         imagesc(peakMap_ROI)
%         axis image off
%         colormap jet
%         hold on
%         ROI_contour = bwperim(ROI);
%         contour( ROI_contour,'k');
%     end
% 
% end
% 
% 
% sessionInfo.stimblocksize = excelRaw{11};
% sessionInfo.stimbaseline=excelRaw{12};
% sessionInfo.stimduration = excelRaw{13};
% sessionInfo.stimFrequency = excelRaw{16};
% stimBaselineFrames = sessionInfo.stimbaseline;
% stimDurationFrames = sessionInfo.stimduration*sessionInfo.framerate;
% %
% %
% % texttitle = strcat(miceName,'Averaged counts for LED1 from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED1-Cam1'));
% % quanti_bleedover(raw_mice(:,:,1,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2*10^5,9*10^5,2*10^3,texttitle,output)
% %
% % texttitle = strcat(miceName,'Averaged counts for LED2 from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED2-Cam1'));
% % quanti_bleedover(raw_mice(:,:,2,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,0.5*10^4,3.5*10^4,50,texttitle,output)
% %
% % texttitle = strcat(miceName,'Averaged counts for Fluor from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED3-Cam1'));
% % quanti_bleedover(raw_mice(:,:,3,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1.045*10^6,1.05*10^6,10,texttitle,output)
% %
% % texttitle = strcat(miceName,'Averaged counts for Laser from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'Laser-Cam1'));
% % quanti_bleedover(raw_mice(:,:,4,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,3000,4500,100000,texttitle,output)
% 
% 
% 
% 
% texttitle = strcat('Averaged counts for LED1 from Cam1 under NonOverlap Mode');
% output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED1-Cam1'));
% quanti_bleedover(raw_mice(:,:,1,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2*10^5,9*10^5,2*10^3,texttitle,output)
% 
% texttitle = strcat('Averaged counts for LED2 from Cam1 under NonOverlap Mode');
% output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED2-Cam1'));
% quanti_bleedover(raw_mice(:,:,2,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,0.5*10^4,3.5*10^4,25,texttitle,output)
% 
% texttitle = strcat('Averaged counts for Fluor from Cam1 under NonOverlap Mode');
% output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED3-Cam1'));
% quanti_bleedover(raw_mice(:,:,3,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1.045*10^6,1.05*10^6,10,texttitle,output)
% 
% texttitle = strcat('Averaged counts for Laser from Cam1 under NonOverlap Mode');
% output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'Laser-Cam1'));
% quanti_bleedover(raw_mice(:,:,4,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2500,4500,50,texttitle,output)
% 
% save(fullfile(saveDir,strcat(recDate,'-',miceName,'cam1-MiceRawData.mat')),'raw_mice')
% clear raw_mice
% 
% 
% 
% %
% %
% % texttitle = strcat(miceName,'Averaged counts for LED1 from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED1-Cam1'));
% % quanti_bleedover(raw_mice(:,:,1,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2*10^5,9*10^5,2*10^3,texttitle,output)
% %
% % texttitle = strcat(miceName,'Averaged counts for LED2 from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED2-Cam1'));
% % quanti_bleedover(raw_mice(:,:,2,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,0.5*10^4,3.5*10^4,50,texttitle,output)
% %
% % texttitle = strcat(miceName,'Averaged counts for Fluor from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED3-Cam1'));
% % quanti_bleedover(raw_mice(:,:,3,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1.045*10^6,1.05*10^6,10,texttitle,output)
% %
% % texttitle = strcat(miceName,'Averaged counts for Laser from Cam1 under NonOverlap Mode');
% % output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'Laser-Cam1'));
% % quanti_bleedover(raw_mice(:,:,4,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,3000,4500,100000,texttitle,output)
% % save(fullfile(saveDir,strcat(recDate,'-',mouseName,'cam1-MiceRawData.mat')),'raw_mice')
% % clear raw_mice




raw_mice = zeros(nVy,nVx,4,600,length(excelRows));
mouseInd = 1;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    %maskDir = strcat('J:\RGECO\Kenny\', recDate, '\');
    sessionInfo.framerate = excelRaw{7};
    sessionInfo.blockLength = excelRaw{11};
    sessionInfo.stimbaseline = excelRaw{12};
    maskName_new = strcat(recDate,'-',mouseName,'-LandmarksandMask','.mat');
    %maskName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(maskDir,maskName), 'xform_isbrain')
    %save(fullfile(maskDir_new,maskName_new),'xform_isbrain')
    %    load(fullfile(maskDir_new,maskName_new), 'isbrain')
    %   isbrain = double(isbrain);
    isbrain = ones(128,128);
    
    raw_mouse = zeros(nVy,nVx,4,sessionInfo.blockLength,length(runs));
    disp(mouseName)
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        if strcmp(systemType,'EastOIS2')
            if strcmp(sessionInfo.mouseType,'jrgeco1a-opto3')
                rawName_cam2 = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-cam2.mat');
                load(fullfile(rawdataloc,recDate,rawName_cam2))
                load(fullfile(rawdataloc,recDate,maskName_new),'affineMarkers','mytform')
                numChan = size(raw_unregistered,3);
                registered_cam2 = zeros(size(raw_unregistered));
                for ii = 1: numChan
                    for jj = 1:size(raw_unregistered,4)
                        registered_cam2(:,:,ii,jj) = imwarp(raw_unregistered(:,:,ii,jj), mytform,'OutputView',imref2d(size(raw_unregistered)));
                    end
                end
                clear raw_unregistered
                rawdata = process.affineTransform(registered_cam2(:,:,:,sessionInfo.darkFrameNum/numChan+1:end),affineMarkers);
                clear registered_cam2
                
            elseif strcmp(sessionInfo.mouseType,'jrgeco1a')
                rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                load(fullfile(saveDir,rawName))
                load(fullfile(saveDir,maskName_new),'affineMarkers')
                numChan = size(rawdata,3);
                xform_raw = process.affineTransform(rawdata(:,:,:, sessionInfo.darkFrameNum/numChan+1:end),affineMarkers);
            elseif strcmp(sessionInfo.mouseType,'Gopto3')||strcmp(sessionInfo.mouseType,'Wopto3')||strcmp(sessionInfo.mouseType,'PV')
                rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
                load(fullfile(saveDir,rawName))
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
        detrendInterestedRaw = temporalDetrendAdam(rawdata(:,:,interestedChannel,:));
        laserRaw = squeeze(rawdata(:,:,LaserChannel,:));
        clear rawdata
        
        detrendInterestedRaw  = reshape(detrendInterestedRaw,nVx,nVy,size(detrendInterestedRaw,3),sessionInfo.blockLength,[]);
        laserRaw = reshape(laserRaw,nVx,nVy,sessionInfo.blockLength,[]);
        raw_mouse(:,:,interestedChannel,:,n) = squeeze(mean(detrendInterestedRaw,5));
        clear detrendInterestedRaw
        raw_mouse(:,:,LaserChannel,:,n) = squeeze(mean(laserRaw,4));
        clear laserRaw
        
        disp(['run #' num2str(n)])
    end
    
    raw_mouse = squeeze(mean(raw_mouse,5));
    save(fullfile(saveDir,strcat(reDate,mouseName,'-cam2')),raw_mouse);
    raw_mice(:,:,:,:,mouseInd)= raw_mouse;
    mouseInd = mouseInd+1;
end
raw_mice = squeeze(mean(raw_mice,5));
sessionInfo.stimblocksize = excelRaw{11};
sessionInfo.stimbaseline=excelRaw{12};
sessionInfo.stimduration = excelRaw{13};
sessionInfo.stimFrequency = excelRaw{16};

stimBaselineFrames = sessionInfo.stimbaseline;
stimDurationFrames = sessionInfo.stimduration*sessionInfo.framerate;

save(fullfile(saveDir,strcat(recDate,'-',mouseName,'cam2-MiceRawData.mat')),'raw_mice')

texttitle = strcat(miceName,'Averaged counts for LED1 from Cam2 under NonOverlap Mode');
output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'-LED1-Cam2-'));
quanti_bleedover(raw_mice(:,:,1,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2.5*10^3,5.5*10^3,50,texttitle,output)

texttitle = strcat(miceName,'Averaged counts for LED2 from Cam2 under NonOverlap Mode');
output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED2-Cam2'));
quanti_bleedover(raw_mice(:,:,2,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1*10^5,7.5*10^5,500,texttitle,output)

texttitle = strcat(miceName,'Averaged counts for Fluor from Cam2 under NonOverlap Mode');
output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'LED3-Cam2'));
quanti_bleedover(raw_mice(:,:,3,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1*10^4,6*10^4,500,texttitle,output)

texttitle = strcat(miceName,'Averaged counts for Laser from Cam2 under NonOverlap Mode');
output = fullfile(saveDir_cat,strcat(recDate,'-',miceName,'Laser-Cam2'));
quanti_bleedover(raw_mice(:,:,4,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2600,5000,10000,texttitle,output)




% 
% texttitle = strcat('Averaged counts for LED1 from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-LED1-Cam2-'));
% quanti_bleedover(raw_mice(:,:,1,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2*10^3,1.8*10^4,50,texttitle,output)
% 
% texttitle = strcat(mouseName,'Averaged counts for LED2 from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-LED2-Cam2-'));
% quanti_bleedover(raw_mice(:,:,2,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1*10^5,8*10^5,500,texttitle,output)
% 
% texttitle = strcat(mouseName,'Averaged counts for Fluor from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-LED3-Cam2-'));
% quanti_bleedover(raw_mice(:,:,3,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,1*10^4,4*10^5,500,texttitle,output)
% 
% texttitle = strcat(mouseName,'Averaged counts for Laser from Cam2 under NonOverlap Mode');
% output = fullfile(saveDir,strcat(recDate,'-',mouseName,'-Laser-Cam2-'));
% quanti_bleedover(raw_mice(:,:,4,:),stimBaselineFrames,stimDurationFrames,1,sessionInfo.framerate,ROI,2600,5000,10000,texttitle,output)
% % 




