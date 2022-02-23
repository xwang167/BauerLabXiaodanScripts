
%% Get Run and System Info
excelFile="X:\XW\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO-LeftGrid.xlsx";
excelRows = [2:4];

runsInfo = parseRuns_xw(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';
ii = 3;

load('Z:\220208\220208-N13M309-stim1-cam1_1.mat', 'raw_unregistered')
runInfo = runsInfo(1);
darkFrames = raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh);

if sum(darkFrames(:,:,end),'all')/sum(darkFrames(:,:,end-1),'all')>5
    darkFrames(:,:,end) = [];
    raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh-1) = [];
else
    raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh) = [];
end
clear raw_unregistered
darkFrames(:,:,runInfo.invalidFramesInd) = [];
darkFrame_cam1 = mean(darkFrames,3);

load('Z:\220208\220208-N13M309-stim1-cam1_2.mat', 'raw_unregistered')
raw_cam1 = raw_unregistered - repmat(darkFrame_cam1,1,1,size(raw_unregistered,3));
clear raw_unregistered
% get indx for laser frame
rightRectangle_cam1 = squeeze(mean(mean(raw_cam1(48:97,79:105,:),1),2));
laser_indx_cam1 = find(rightRectangle_cam1 < 1000)';
%take laser frames out
laserFrames_cam1 = raw_cam1(:,:,laser_indx_cam1);
raw_cam1(:,:,laser_indx_cam1) = [];
raw_cam1 = reshape(raw_cam1,128,128,runInfo.numCh,[]);

        
        % representative channel
        representativeCh_cam1 = runInfo.hbChInd(1);
        droppedFrames_cam1 = [];
        rawTime_cam1 = 1:size(raw_cam1,4);
        rawTime_cam1 = rawTime_cam1/runInfo.samplingRate;
        load(runInfo.saveMaskFile)
        raw_cam1 = single(raw_cam1);
        %QC raw_cam1
        qcRawFig = qcRaw_xw(runInfo,rawTime_cam1,raw_cam1,representativeCh_cam1,isbrain,droppedFrames_cam1,runInfo.system,['-' 'cam1' '-' num2str(ii)]);
        runInfo.saveRawQCFig = strcat(runInfo.saveFilePrefix, '-cam1', '_',num2str(ii),'-rawQC');
        savefig(qcRawFig,runInfo.saveRawQCFig);
        saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
        close(qcRawFig);
        
        disp('checking for dropped frames...');
        fixedData_cam1 = false; % flag to see if data has been fixed yet or not
        [dfIndRaw_cam1, dfIndFixed_cam1, fixedRaw_cam1] = fixDroppedFrames_xw(runInfo,raw_cam1,fixedData_cam1,['-' 'cam1' '-' num2str(ii)]);
        
        if isempty(dfIndRaw_cam1) % if no dropped frames, continue as normal
            disp('No dropped frames detected.');
            clear dfIndRaw dfIndFixed fixedRaw fixedRawTime;
        else
            disp(['Detected and correcting for ' num2str(length(dfIndRaw_cam1)) ' dropped frames!']);
            raw_cam1 = fixedRaw_cam1;
            droppedFrames_cam1 = dfIndFixed_cam1;
            
            % Re-run rawQC after correction
            representativeCh_cam1 = runInfo.hbChInd(1);
            qcRawFig =qcRaw_xw(runInfo,rawTime_cam1,raw_cam1,representativeCh_cam1,isbrain,droppedFrames_cam1,runInfo.system,['-' 'cam1' '-' num2str(ii)]);
            newQCSaveLoc = [runInfo.saveRawQCFig '_dropCorr'];
            saveas(qcRawFig,[newQCSaveLoc '.png']);
            savefig(qcRawFig,newQCSaveLoc);
            close(qcRawFig);
            % Check to make sure all dropped frames have been removed
            fixedData_cam1 = true;
            [dfIndRaw_cam1, ~, ~] = fixDroppedFrames_xw(runInfo,fixedRaw_cam1,fixedData_cam1,ii);
            if ~isempty(dfIndRaw_cam1)
                currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
                    '' num2str(runInfo.run) '_' num2str(ii)];
                disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
            end
            clear fixedRaw fixedRawTimeWL;
            
        end
        
% % representative channel
% representativeCh_cam1 = runInfo.hbChInd(1);
% droppedFrames_cam1 = [];
% rawTime_cam1 = 1:size(raw_cam1,4);
% rawTime_cam1 = rawTime_cam1/runInfo.samplingRate;
% load(runInfo.saveMaskFile)
% raw_cam1 = single(raw_cam1);
% qcRawFig = qcRaw_xw(runInfo,rawTime_cam1,raw_cam1,representativeCh_cam1,isbrain,droppedFrames_cam1,runInfo.system,ii);
% runInfo.saveRawQCFig = strcat(runInfo.saveFilePrefix, '_cam1', '_',num2str(ii),'-rawQC');
% savefig(qcRawFig,runInfo.saveRawQCFig);
% saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
% close(qcRawFig);
% 
% 
% disp('checking for dropped frames...');
% fixedData_cam1 = false; % flag to see if data has been fixed yet or not
% [dfIndRaw_cam1, dfIndFixed_cam1, fixedRaw_cam1] = fixDroppedFrames_xw(runInfo,raw_cam1,fixedData_cam1,ii);
% 
% if isempty(dfIndRaw_cam1) % if no dropped frames, continue as normal
%     disp('No dropped frames detected.');
%     clear dfIndRaw dfIndFixed fixedRaw fixedRawTime;
% else
%     disp(['Detected and correcting for ' num2str(length(dfIndRaw_cam1)) ' dropped frames!']);
%     raw_cam1 = fixedRaw_cam1;
%     droppedFrames_cam1 = dfIndFixed_cam1;
%     
%     % Re-run rawQC after correction
%     representativeCh_cam1 = runInfo.hbChInd(1);
%     qcRawFig =qcRaw_xw(runInfo,rawTime_cam1,raw_cam1,representativeCh_cam1,isbrain,droppedFrames_cam1,runInfo.system,ii);
%     newQCSaveLoc = [runInfo.saveRawQCFig '_dropCorr'];
%     saveas(qcRawFig,[newQCSaveLoc '.png']);
%     savefig(qcRawFig,newQCSaveLoc);
%     close(qcRawFig);
%     % Check to make sure all dropped frames have been removed
%     fixedData_cam1 = true;
%     [dfIndRaw_cam1, ~, ~] = fixDroppedFrames_xw(runInfo,fixedRaw_cam1,fixedData_cam1,ii);
%     if ~isempty(dfIndRaw_cam1)
%         currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
%             '' num2str(runInfo.run) '_' num2str(ii)];
%         disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
%     end
%     clear fixedRaw fixedRawTimeWL;
%     
% end