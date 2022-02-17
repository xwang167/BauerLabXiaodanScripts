clear all;close all;
poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = [2:4];
istransform = 1;

runsInfo = parseRuns_xw(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';

% get xform_isbrain
for runInd=runNum %for each mouse
    
    runInfo=runsInfo(runInd);
    load(runInfo.saveMaskFile,'isbrain','I')
    I.bregma = I.bregma(1:2);
    I.tent = I.tent(1:2);
    I.OF = I.OF(1:2);
    [xform_isbrain]=Affine(I, isbrain, 'New');
    save(runInfo.saveMaskFile,'xform_isbrain','I','-append')
end

runNum = numel(runsInfo);

for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    sessionInfo = sysInfo_xw(runInfo.system);
    %dark frame from CMOS1
    for ii = 1:length(runInfo.rawFile)/2
        load(runInfo.rawFile{ii})
        if ii == 1
            darkFrames = raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh);
            if sum(darkFrames(:,:,end),'all')/sum(darkFrames(:,:,end-1),'all')>5
                darkFrames(:,:,end) = [];
                raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh-1) = [];
            else
                raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh) = [];
            end
            darkFrames(:,:,runInfo.invalidFramesInd) = [];
            darkFrame_cam1 = mean(darkFrames,3);
            clear darkFrames
        end
        
        %subtract dark frame
        raw_cam1 = raw_unregistered - repmat(darkFrame_cam1,1,1,size(raw_unregistered,3));
        clear raw_unregistered
        
        % get indx for laser frame
        rightRectangle_cam1 = squeeze(mean(mean(raw_cam1(48:97,79:105,:),1),2));
        laser_indx_cam1 = find(rightRectangle_cam1 < 1000)';
        indx = 5*20*3+4;
        totalFrames_cam1 = size(raw_cam1,3);
        laser_indx_nodrop_cam1 = indx:1801:totalFrames_cam1;% The laser indx without dropping frames
        difference_laser_indx_cam1 = laser_indx_nodrop_cam1-laser_indx_cam1;
        dropFrameIndx = find(diff(difference_laser_indx_cam1)==1);
        if difference_laser_indx_cam1(1)>0
            dropFrameIndx = [1 dropFrameIndx];
        end
        if ~isempty(dropFrameIndx)
            for jj = 1:length(dropFrameIndx)
                if dropFrameIndx(jj) == 1
                    temp(:,:,1:difference_laser_indx_cam1(1)) = raw_cam1(:,:,4-difference_laser_indx_cam1(1):3);
                    temp(:,:,difference_laser_indx_cam1(1)+1:difference_laser_indx_cam1(1)+totalFrames_cam1) = raw_cam1(:,:,1:totalFrames_cam1);
                elseif dropFrameIndx(jj) <4
                    temp = raw_cam1(:,:,1:1801*dropFrameIndx(jj));
                    temp(:,:,end+1) = raw_cam1(:,:,1801*dropFrameIndx(jj)+3);
                    temp(:,:,end+1:end+totalFrames_cam1-1-1801*dropFrameIndx(jj)) = raw_cam1(:,:,1801*dropFrameIndx(jj)+1:totalFrames_cam1-1);
                    dropFrameIndx = dropFrameIndx+1;
                else
                    disp('drop frames more than 3 in the beginning');
                end
            end
            raw_cam1 = temp;
            clear temp
        end
        laserFrames_cam1 = raw_cam1(:,:,laser_indx_nodrop_cam1);
        raw_cam1(:,:,laser_indx_nodrop_cam1) = [];
        raw_cam1 = reshape(raw_cam1,128,128,runInfo.numCh,[]);
        
        %%CMOS2
        load(runInfo.rawFile{length(runInfo.rawFile)/2+ii})
        if ii == 1
            darkFrames = raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh);
            if sum(darkFrames(:,:,end),'all')/sum(darkFrames(:,:,end-1),'all')>5
                darkFrames(:,:,end) = [];
                raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh-1) = [];
            else
                raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh) = [];
            end
            darkFrames(:,:,runInfo.invalidFramesInd) = [];
            darkFrame_cam2 = mean(darkFrames,3);
            clear darkFrames
        end
        %subtract dark frame
        raw_cam2 = raw_unregistered - repmat(darkFrame_cam2,1,1,size(raw_unregistered,3));
        clear raw_unregistered
        
        % get indx for laser frame
        rightRectangle_cam2 = squeeze(mean(mean(raw_cam2(48:97,79:105,:),1),2));
        laser_indx_cam2 = find(rightRectangle_cam2 < 1000)';
        indx = 5*20*3+4;
        totalFrames_cam2 = size(raw_cam2,3);
        laser_indx_nodrop_cam2 = indx:1801:totalFrames_cam2;% The laser indx without dropping frames
        difference_laser_indx_cam2 = laser_indx_nodrop_cam2-laser_indx_cam2;
        
        % find the block with drop frame
        dropFrameIndx = find(diff(difference_laser_indx_cam2)==1);
        if difference_laser_indx_cam2(1)>0
            dropFrameIndx = [1 dropFrameIndx];
        end
        %pad frames where there is drop frames
        if ~isempty(dropFrameIndx)
            for jj = 1:length(dropFrameIndx)
                if dropFrameIndx(jj) == 1
                    temp(:,:,1:difference_laser_indx_cam2(1)) = raw_cam2(:,:,4-difference_laser_indx_cam2(1):3);
                    temp(:,:,difference_laser_indx_cam2(1)+1:totalFrames_cam2) = raw_cam2(:,:,1:totalFrames_cam2-difference_laser_indx_cam2);
                elseif dropFrameIndx(jj)<4
                    temp = raw_cam2(:,:,1:1801*dropFrameIndx(jj));
                    temp(:,:,end+1) = raw_cam2(:,:,1801*dropFrameIndx(jj)+3);
                    temp(:,:,end+1:end+totalFrames_cam2-1-1801*dropFrameIndx(jj)) = raw_cam2(:,:,1801*dropFrameIndx(jj)+1:totalFrames_cam2-1);
                    dropFrameIndx = dropFrameIndx+1;
                else
                    disp('drop frames more than 3 in the beginning');
                end
            end
            raw_cam2 = temp;
            clear temp
        end
        laserFrames_cam2 = raw_cam2(:,:,laser_indx_nodrop_cam2);
        raw_cam2(:,:,laser_indx_nodrop_cam2) = [];
        raw_cam2 = reshape(raw_cam2,128,128,runInfo.numCh,[]);
        %register cam2 to cam1 and take the right channels
        k = strfind(runInfo.rawFile{1},'-');
        load(strcat(runInfo.rawFile{1}(1:k(1)),'mytform.mat'))
        raw  = registerCam2andCombineTwoCams(raw_cam1(:,:,sessionInfo.cam1Chan,:),raw_cam2(:,:,sessionInfo.cam2Chan,:),mytform,sessionInfo.cam1Chan,sessionInfo.cam2Chan);
        
        %save
        eval(strcat('save(strcat(runInfo.saveFilePrefix,',char(39),'_',char(39),',',...
            char(39),num2str(ii),char(39),'),',char(39),'raw',char(39),',',char(39),...
            'laserFrames_cam1',char(39),',',char(39),'laserFrames_cam2',char(39),',',char(39),'-v7.3',char(39),');'))
    end
end