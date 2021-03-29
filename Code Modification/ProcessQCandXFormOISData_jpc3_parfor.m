poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end

%% Get Masks and WL
excelFile='/Volumes/JPC/Code Modification/exampleTiffOIS+Gcamp.xlsx';
excelRows=[16];  % Rows from Excell Database
runsInfo = parseTiffRuns(excelFile,excelRows); 
[mice,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.mouseName});
runNum=start_ind_mouse;
for runInd=runNum

    runInfo=runsInfo(runInd); % if for each mouse then we want first run
    % find the full mask file directory. This file will be checked for
    % mask. If this file does not exist, following if/else statement
    % creates the file.
    maskFileName = runInfo.saveMaskFile;
    saveFolder = runInfo.saveFolder;
    
    % create the white light image and mask file if it does not exist
    if ~exist(maskFileName,'file')
        
        % instantiate VideosReader - reads the raw files to output matrix
      
        raw = readTiff(runInfo.rawFile{1});
        raw = reshape(raw,size(raw,1),size(raw,2),runInfo.numCh,[]);
        [isbrain,xform_isbrain,I,WL,xform_WL] = getMask(raw,runInfo.darkFramesInd,runInfo.invalidFramesInd,runInfo.rgbInd);
        
        if ~exist(saveFolder)
            mkdir(saveFolder);
        end
        
        save(maskFileName,'xform_WL','isbrain','I','xform_isbrain','WL','-v7.3');
    end
    
end



%% Process Data
% Process multiple OIS files with the following naming convention:

% filedate: YYMMDD
% subjname: any alphanumberic convention is ok, e.g. "Mouse1"
% suffix: filename run number, e.g. "fc1"
% In Andor Solis, files are saved as "YYMMDD-MouseName-suffixN.tif"

% "directory" is where processed data will be stored. If the
% folder does not exist, it is created, and if directory is not
% specified, data will be saved in the current folder:

clearvars -except runsInfo
runNum = numel(runsInfo); 


tic
for runInd = 1:runNum
    runInfo=runsInfo(runInd);
    
%Checks if alreay been processed     
    if exist(runInfo.saveHbFile,'file') 
        disp([runInfo.saveHbFile,' Already processed']) 
    else
        
        disp(['Processing ', runInfo.saveHbFile ' on ', runInfo.system]) 
        sessionInfo = sysInfo(runInfo.system);
        raw = readTiff(runInfo.rawFile{1});
        raw = reshape(raw,size(raw,1),size(raw,2),runInfo.numCh,[]);
        
% Remove Dark Frames
        if ~isempty(runInfo.darkFramesInd) 
            darkFrame = squeeze(mean(raw(:,:,:,runInfo.darkFramesInd),4,'omitnan'));
            raw = double(raw) - double(repmat(darkFrame,1,1,1,size(raw,4)));
            raw(:,:,:,1:length(runInfo.darkFramesInd))=[];
        end
        
%QC raw data. CAN WE COMBINE QC WITH DORPPED FRAMES!?
        disp('rawQC analysis...');
        if ~isempty(runInfo.fluorChInd)
            representativeCh = runInfo.fluorChInd;
        else
            representativeCh = runInfo.hbChInd(1); %which channel are we using as a reference
        end
        droppedFrames = []; % assume no dropped frames by default
        rawTime = 1:size(raw,4);
        rawTime = rawTime/runInfo.samplingRate;
        load(runInfo.saveMaskFile)
        qcRawFig = qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames,runInfo.system);%%%%%save specific data to both hb and fluor data%%%color of lines 
        savefig(qcRawFig,runInfo.saveRawQCFig);
        saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
        close(qcRawFig);        
        
    % Perform check for corrected dropped frames and QC fixed 
        disp('checking for dropped frames...');
        fixedData = false; % flag to see if data has been fixed yet or not
        [dfIndRaw, dfIndFixed, fixedRaw, fixedRawTime] = fixDroppedFrames(runInfo,raw,rawTime,fixedData);
        
        if isempty(dfIndRaw) % if no dropped frames, continue as normal
            disp('No dropped frames detected.');
            clear dfIndRaw dfIndFixed fixedRaw fixedRawTime;
        else
            disp(['Detected and correcting for ' num2str(length(dfIndRaw)) ' dropped frames!']);
            raw = fixedRaw;
            rawTime = fixedRawTime;
            droppedFrames = dfIndFixed;
            
    % Re-run rawQC after correction
            representativeCh = runInfo.hbChInd(1);
            qcRawFig =qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames,runInfo.system);
            newQCSaveLoc = [runInfo.saveRawQCFig '_dropCorr']; 
            saveas(qcRawFig,[newQCSaveLoc '.png']);
            savefig(qcRawFig,newQCSaveLoc);
            close(qcRawFig);
            % check to make sure all dropped frames have been removed
            fixedData = true;
            [dfIndRaw, ~, ~, ~] = fixDroppedFrames(runInfo,fixedRaw,fixedRawTime,fixedData);
            if ~isempty(dfIndRaw)
                currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
                    '' num2str(runInfo.run)];
                disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
            end
            clear fixedRaw fixedRawTime;
        end
                               
 %Get optical Properties!     
    %Hb
        [op, E] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.hbChInd}});
    %Fluoro        
        [op_in, E_in] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.fluorChInd}});
        [op_out, E_out] = getHbOpticalProperties_new(runInfo.fluorFiles);        
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
 %Spectroscopy   
    %Hb
        datahb = procOIS_xw(raw(:,:,runInfo.hbChInd,:),op.dpf,E,isbrain);
        datahb = smoothImage(datahb,runInfo.gbox,runInfo.gsigma); 
        xform_datahb = affineTransform(datahb,I);    
    %Fluoro       
        datafluor = procFluor(squeeze(raw(:,:,runInfo.fluorChInd,:)),mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan'));
        datafluor = smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
        xform_datafluor = affineTransform(datafluor,I);        
clear raw
    %Fluoro-Correction                     
        datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);%%%% gcamp only flag
        datafluorCorr = smoothImage(datafluorCorr,runInfo.gbox,runInfo.gsigma);
        xform_datafluorCorr=affineTransform(datafluorCorr,I);
    end
end
toc



%Save        
        disp('Saving Data')
        save(runInfo.saveHbFile,'xform_datahb','sessionInfo','op','E') %How is sessionInfo different than runInfo?
        save(runinfo.saveFluorFile,'xofrm_datafluor','xform_datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','-append')
        disp('Finally DONE Saving Data')       
        %%%depackage
%         fcqc
%         stim
    end
end

%% Averaging 
