clear all;close all;
%% Get Run and System Info
excelFile="X:\Paper2\Hemi_Thy1_jRGECO1a_leftGrid\Control_Hemi_Thy1_jRGECO1a_leftGrid.xlsx";
excelRows = 3;

runsInfo = parseRuns_xw(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';

% %get xform_isbrain
for runInd=runNum %for each mouse
    %copy landmarksandmask from couchraw to saveDir
    runInfo=runsInfo(runInd);
    load(runInfo.saveMaskFile,'isbrain','I')
    if I.tent(1)>I.tent(2)
        temp = I;
        I.bregma = nan(1,2);
        I.tent = nan(1,2);
        I.OF = nan(1,2);
        I.bregma(1) = temp.bregma(2);
        I.bregma(2) = temp.bregma(1);
        I.tent(1) = temp.tent(2);
        I.tent(2) = temp.tent(1);
        I.OF(1) = temp.OF(2);
        I.OF(2) = temp.OF(1);
        [xform_isbrain]=Affine(I, isbrain, 'New');
        save(runInfo.saveMaskFile,'xform_isbrain','I','-append')
        clear I xform_isbrain
    end
end
%
runNum = numel(runsInfo);

for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    sessionInfo = sysInfo_xw(runInfo.system);
    %dark frame from CMOS1
    for ii = 1:length(runInfo.rawFile)/2
        if ~exist(strcat(runInfo.saveFilePrefix,'_',num2str(ii),'.mat'),'file')
            load(runInfo.rawFile{ii})
            if ii == 1
                darkFrames_cam1 = raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh);
                if sum(darkFrames_cam1(:,:,end),'all')/sum(darkFrames_cam1(:,:,end-1),'all')>5
                    darkFrames_cam1(:,:,end) = [];
                    raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh-1) = [];
                else
                    raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh) = [];
                end
                darkFrames_cam1(:,:,runInfo.invalidFramesInd) = [];
                darkFrame_cam1 = mean(darkFrames_cam1,3);
                clear darkFrames_cam1
            end

            %subtract dark frame
            raw_cam1 = raw_unregistered - repmat(darkFrame_cam1,1,1,size(raw_unregistered,3));
            clear raw_unregistered

            % get indx for laser frame
            rightRectangle_cam1 = squeeze(mean(mean(raw_cam1(48:97,79:105,:),1),2));
            laser_indx_cam1 = find(rightRectangle_cam1 < 1500)';

            %take laser frames out
            laserFrames_cam1 = raw_cam1(:,:,laser_indx_cam1);
            raw_cam1(:,:,laser_indx_cam1) = [];

            % representative channel
            representativeCh_cam1 = runInfo.hbChInd(1);
            droppedFrames_cam1 = [];
            load(runInfo.saveMaskFile)
            raw_cam1 = single(raw_cam1);
            eval(strcat('frames_nextFile_cam1_',num2str(ii), '= [];'))


            if ii>1
                eval(strcat('ifFramesfromLastSubfoler = ~isempty(frames_nextFile_cam1_',num2str(ii-1),');'))
                if ifFramesfromLastSubfoler
                    eval(strcat('droppedFrameNum = size(frames_nextFile_cam1_',num2str(ii-1),',3);'))
                    eval(strcat('frames_nextFile_cam1_',num2str(ii), '= raw_cam1(:,:,end-droppedFrameNum+1:end);'))
                    if ii<length(runInfo.rawFile)/2
                        raw_cam1(:,:,droppedFrameNum+1:end) = raw_cam1(:,:,1:end-droppedFrameNum);
                    else
                        raw_cam1(:,:,droppedFrameNum+1:end+droppedFrameNum) = raw_cam1(:,:,1:end);
                    end
                    eval(strcat('raw_cam1(:,:,1:droppedFrameNum) = frames_nextFile_cam1_',num2str(ii-1),';'));
                end
            end
            %QC raw_cam1

            raw_cam1 = reshape(raw_cam1,128,128,runInfo.numCh,[]);
            rawTime_cam1 = 1:size(raw_cam1,4);
            rawTime_cam1 = rawTime_cam1/runInfo.samplingRate;
            qcRawFig = qcRaw_xw(runInfo,rawTime_cam1,raw_cam1,representativeCh_cam1,isbrain,droppedFrames_cam1,runInfo.system,['-' 'cam1' '-' num2str(ii)]);
            runInfo.saveRawQCFig = strcat(runInfo.saveFilePrefix, '-cam1', '_',num2str(ii),'-rawQC');
            savefig(qcRawFig,runInfo.saveRawQCFig);
            saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
            close(qcRawFig);

            disp('checking for dropped frames...');
            fixedData_cam1 = false; % flag to see if data has been fixed yet or not
            [dfIndRaw_cam1, dfIndFixed_cam1, fixedRaw_cam1] = fixDroppedFrames_xw(runInfo,raw_cam1,fixedData_cam1,['-' 'cam1' '-' num2str(ii)]);

            if ~isempty(dfIndRaw_cam1)
                raw_cam1 = reshape(raw_cam1,128,128,[]);
                if ii ==1 || ~ifFramesfromLastSubfoler
                    eval(strcat('frames_nextFile_cam1_',num2str(ii), '= raw_cam1(:,:,end-length(dfIndFixed_cam1)+1:end);'))
                elseif ii<length(runInfo.rawFile)/2
                    eval(strcat('frames_nextFile_cam1_',num2str(ii),'(:,:,length(dfIndRaw_cam1)+1:length(dfIndRaw_cam1)+size(frames_nextFile_cam1_',num2str(ii-1),...
                        ',3)) = frames_nextFile_cam1_',num2str(ii),';'))
                    eval(strcat('frames_nextFile_cam1_',num2str(ii),'(:,:,1:length(dfIndRaw_cam1)) = raw_cam1(:,:,end-length(dfIndRaw_cam1)+1:end);'))
                end
            end
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
                [dfIndRaw_cam1, ~, ~] = fixDroppedFrames_xw(runInfo,fixedRaw_cam1,fixedData_cam1,['-' 'cam1' '-' num2str(ii)]);
                if ~isempty(dfIndRaw_cam1)
                    currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
                        '' num2str(runInfo.run) '_' num2str(ii)];
                    disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
                end
                clear fixedRaw fixedRawTimeWL;

            end

            load(runInfo.rawFile{length(runInfo.rawFile)/2+ii})
            if ii == 1
                darkFrames_cam2 = raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh);
                if sum(darkFrames_cam2(:,:,end),'all')/sum(darkFrames_cam2(:,:,end-1),'all')>5
                    darkFrames_cam2(:,:,end) = [];
                    raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh-1) = [];
                else
                    raw_unregistered(:,:,1:runInfo.darkFramesInd(end)*runInfo.numCh) = [];
                end
                darkFrames_cam2(:,:,runInfo.invalidFramesInd) = [];
                darkFrame_cam2 = mean(darkFrames_cam2,3);
                clear darkFrames_cam2
            end

            %subtract dark frame
            raw_cam2 = raw_unregistered - repmat(darkFrame_cam2,1,1,size(raw_unregistered,3));
            clear raw_unregistered

            % get indx for laser frame
            rightRectangle_cam2 = squeeze(mean(mean(raw_cam2(48:97,79:105,:),1),2));
            laser_indx_cam2 = find(rightRectangle_cam2 < 800)';
            %take laser frames out
            laserFrames_cam2 = raw_cam2(:,:,laser_indx_cam2);
            raw_cam2(:,:,laser_indx_cam2) = [];

            % representative channel
            representativeCh_cam2 = runInfo.hbChInd(1);
            droppedFrames_cam2 = [];
            load(runInfo.saveMaskFile)
            raw_cam2 = single(raw_cam2);
            eval(strcat('frames_nextFile_cam2_',num2str(ii), '= [];'))


            if ii>1
                eval(strcat('ifFramesfromLastSubfoler = ~isempty(frames_nextFile_cam2_',num2str(ii-1),');'))
                if ifFramesfromLastSubfoler
                    eval(strcat('droppedFrameNum = size(frames_nextFile_cam2_',num2str(ii-1),',3);'))
                    eval(strcat('frames_nextFile_cam2_',num2str(ii), '= raw_cam2(:,:,end-droppedFrameNum+1:end);'))
                    if ii<length(runInfo.rawFile)/2
                        raw_cam2(:,:,droppedFrameNum+1:end) = raw_cam2(:,:,1:end-droppedFrameNum);
                    else
                        raw_cam2(:,:,droppedFrameNum+1:end+droppedFrameNum) = raw_cam2(:,:,1:end);
                    end
                    eval(strcat('raw_cam2(:,:,1:droppedFrameNum) = frames_nextFile_cam2_',num2str(ii-1),';'));
                end
            end
            %QC raw_cam2

            raw_cam2 = reshape(raw_cam2,128,128,runInfo.numCh,[]);
            rawTime_cam2 = 1:size(raw_cam2,4);
            rawTime_cam2 = rawTime_cam2/runInfo.samplingRate;
            qcRawFig = qcRaw_xw(runInfo,rawTime_cam2,raw_cam2,representativeCh_cam2,isbrain,droppedFrames_cam2,runInfo.system,['-' 'cam2' '-' num2str(ii)]);
            runInfo.saveRawQCFig = strcat(runInfo.saveFilePrefix, '-cam2', '_',num2str(ii),'-rawQC');
            savefig(qcRawFig,runInfo.saveRawQCFig);
            saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
            close(qcRawFig);

            disp('checking for dropped frames...');
            fixedData_cam2 = false; % flag to see if data has been fixed yet or not
            [dfIndRaw_cam2, dfIndFixed_cam2, fixedRaw_cam2] = fixDroppedFrames_xw(runInfo,raw_cam2,fixedData_cam2,['-' 'cam2' '-' num2str(ii)]);

            if ~isempty(dfIndRaw_cam2)
                raw_cam2 = reshape(raw_cam2,128,128,[]);
                if ii ==1 || ~ifFramesfromLastSubfoler
                    eval(strcat('frames_nextFile_cam2_',num2str(ii), '= raw_cam2(:,:,end-length(dfIndFixed_cam2)+1:end);'))
                elseif ii<length(runInfo.rawFile)/2
                    eval(strcat('frames_nextFile_cam2_',num2str(ii),'(:,:,length(dfIndRaw_cam2)+1:length(dfIndRaw_cam2)+size(frames_nextFile_cam2_',num2str(ii-1),...
                        ',3)) = frames_nextFile_cam2_',num2str(ii),';'))
                    eval(strcat('frames_nextFile_cam2_',num2str(ii),'(:,:,1:length(dfIndRaw_cam2)) = raw_cam2(:,:,end-length(dfIndRaw_cam2)+1:end);'))
                end
            end
            if isempty(dfIndRaw_cam2) % if no dropped frames, continue as normal
                disp('No dropped frames detected.');
                clear dfIndRaw dfIndFixed fixedRaw fixedRawTime;
            else
                disp(['Detected and correcting for ' num2str(length(dfIndRaw_cam2)) ' dropped frames!']);
                raw_cam2 = fixedRaw_cam2;
                droppedFrames_cam2 = dfIndFixed_cam2;
                % Re-run rawQC after correction
                representativeCh_cam2 = runInfo.hbChInd(1);
                qcRawFig =qcRaw_xw(runInfo,rawTime_cam2,raw_cam2,representativeCh_cam2,isbrain,droppedFrames_cam2,runInfo.system,['-' 'cam2' '-' num2str(ii)]);
                newQCSaveLoc = [runInfo.saveRawQCFig '_dropCorr'];
                saveas(qcRawFig,[newQCSaveLoc '.png']);
                savefig(qcRawFig,newQCSaveLoc);
                close(qcRawFig);
                % Check to make sure all dropped frames have been removed
                fixedData_cam2 = true;
                [dfIndRaw_cam2, ~, ~] = fixDroppedFrames_xw(runInfo,fixedRaw_cam2,fixedData_cam2,['-' 'cam2' '-' num2str(ii)]);
                if ~isempty(dfIndRaw_cam2)
                    currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
                        '' num2str(runInfo.run) '_' num2str(ii)];
                    disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
                end
                clear fixedRaw fixedRawTimeWL;

            end
            k = strfind(runInfo.rawFile{1},'-');
            load(strcat(runInfo.rawFile{1}(1:k(1)),'tform.mat'))
            raw  = registerCam2andCombineTwoCams(raw_cam1(:,:,sessionInfo.cam1Chan,:),raw_cam2(:,:,sessionInfo.cam2Chan,:),mytform,sessionInfo.cam1Chan,sessionInfo.cam2Chan);
            eval(strcat('save(strcat(runInfo.saveFilePrefix,',char(39),'_',char(39),',',...
                char(39),num2str(ii),char(39),'),',char(39),'raw',char(39),',',char(39),...
                'laserFrames_cam1',char(39),',',char(39),'laserFrames_cam2',char(39),',',char(39),'-v7.3',char(39),');'))

        end
    end
end

runNum = numel(runsInfo);
for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd
    runInfo=runsInfo(runInd);
    sessionInfo = sysInfo_xw(runInfo.system);
    disp('rawQC analysis...');
    if ~isempty(runInfo.fluorChInd)
        representativeCh = runInfo.fluorChInd;
    else
        %which channel are we using as a reference
        representativeCh = runInfo.hbChInd(1);
    end
    for ii = 1:length(runInfo.rawFile)/2  
           eval(strcat('load(strcat(runInfo.saveFilePrefix,',char(39),'_',char(39),',',...
                char(39),num2str(ii),char(39),'),',char(39),'raw',char(39),');'))
            %% Raw QC
            rawTime = 1:size(raw,4);
            rawTime = rawTime/runInfo.samplingRate;
            load(runInfo.saveMaskFile)
            raw = single(raw);
            droppedFrames = [];
            qcRawFig = qcRaw_xw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames,runInfo.system,['-' num2str(ii)]);
            runInfo.saveRawQCFig = strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-rawQC');
            savefig(qcRawFig,runInfo.saveRawQCFig);
            saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
            close(qcRawFig);
            for i=1: size(raw,3)
                raw(:,:,i,:)=temporalDetrend(raw(:,:,i,:),isbrain); %?!fix?!
            end

            %OPTICAL PROP AND SPECTROSCOPY
            %HB

            [op, E] = getHbOpticalProperties({runInfo.lightSourceFiles{runInfo.hbChInd}});
            datahb = procOIS(raw(:,:,runInfo.hbChInd,:),op.dpf,E,isbrain); %where is xform_isbrain made?
            datahb = smoothImage(datahb,runInfo.gbox,runInfo.gsigma);
            xform_datahb = affineTransform(datahb,I); %error here
            xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(xform_datahb,3),size(xform_datahb,4));
            xform_datahb(logical(1-xform_isbrain_matrix)) = NaN;
            runInfo.saveHbFile = strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataHb.mat');
            save(runInfo.saveHbFile,'xform_datahb','op','E','runInfo','-v7.3')
            %Fluoro (calcium)

            [op_in, E_in] = getHbOpticalProperties({runInfo.lightSourceFiles{runInfo.fluorChInd}});
            [op_out, E_out] = getHbOpticalProperties(runInfo.fluorFiles);
            dpIn = op_in.dpf/2;
            dpOut = op_out.dpf/2;

            datafluor = procFluor(squeeze(raw(:,:,runInfo.fluorChInd,:)),mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan'));
            datafluor = smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
            xform_datafluor = affineTransform(datafluor,I);
            %Fluoro-Correction
            %jRGECGO1a correction
            datafluorCorr = correctHb_differentBeta(squeeze(raw(:,:,runInfo.fluorChInd,:)./mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan')),datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,1,1);
            datafluorCorr = smoothImage(datafluorCorr,runInfo.gbox,runInfo.gsigma);
            xform_datafluorCorr=affineTransform(datafluorCorr,I);
            runInfo.saveFluorFile = strcat(runInfo.saveFilePrefix,'_',num2str(ii),'-dataFluor.mat');
            save(runInfo.saveFluorFile,'xform_datafluor','xform_datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','runInfo','-v7.3')
            clear datafluor datafluorCorr xform_datafluor
    
    end
end