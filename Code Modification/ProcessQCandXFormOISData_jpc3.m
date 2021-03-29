poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Masks and WL
excelFile="G:\Code Modification\exampleTiffOIS+Gcamp.xlsx";
excelRows=[18];  % Rows from Excell Database
runsInfo = parseTiffRuns(excelFile,excelRows); 

[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters!

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

for runInd = 1:runNum
    runInfo=runsInfo(runInd);
%If is this already processed
    if exist(runInfo.saveHbFile,'file') 
        disp([runInfo.saveHbFile,' Already processed']) 
    else
        disp(['Processing ', runInfo.saveHbFile ' on ', runInfo.system]) 
        sessionInfo = sysInfo(runInfo.system);
        raw = readTiff(runInfo.rawFile{1});
        raw = reshape(raw,size(raw,1),size(raw,2),runInfo.numCh,[]);
% Remove dark  frames
        if ~isempty(runInfo.darkFramesInd) 
            darkFrame = squeeze(mean(raw(:,:,:,runInfo.darkFramesInd),4,'omitnan'));
            raw = double(raw) - double(repmat(darkFrame,1,1,1,size(raw,4)));
            raw(:,:,:,1:length(runInfo.darkFramesInd))=[];
        end
        
        clear darkFrame
        
%QC raw data. CAN WE COMBINE QC WITH DORPPED FRAMES!?
        disp('rawQC analysis...');
        if ~isempty(runInfo.fluorChInd)
            representativeCh = runInfo.fluorChInd;
        else
            %which channel are we using as a reference
            representativeCh = runInfo.hbChInd(1); 
        end
        % Assume no dropped frames by default
        droppedFrames = []; 
        rawTime = 1:size(raw,4);
        rawTime = rawTime/runInfo.samplingRate;
        load(runInfo.saveMaskFile)
        qcRawFig = qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames,runInfo.system);
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
            clear fixedRaw fixedRawTimeWL;
        end
%Detrending        
    parfor i=1: size(raw,3)
    raw(:,:,i,:)=temporalDetrend(raw(:,:,i,:),isbrain);
    end

%Grab Optical Properties   
    %Hb
        [op, E] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.hbChInd}});
    %Fluoro        
        [op_in, E_in] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.fluorChInd}});
        [op_out, E_out] = getHbOpticalProperties_new(runInfo.fluorFiles);        
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
 %Spectroscopy   
    %Hb
        datahb = procOIS_xw(raw(:,:,runInfo.hbChInd,:),op.dpf,E,isbrain); %where is xform_isbrain made?
        datahb = smoothImage(datahb,runInfo.gbox,runInfo.gsigma); 
        xform_datahb = affineTransform(datahb,I);    
    %Fluoro       
        % ADD CONDITIONAL FOR IF EXIST FLUOR and isbrain?
        datafluor = procFluor(squeeze(raw(:,:,runInfo.fluorChInd,:)),mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan')); 
        datafluor = smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
        xform_datafluor = affineTransform(datafluor,I);   %can I  delete this xform_dataflour; when is it used again in the future??     
clear raw
    %Fluoro-Correction
             %%%% gcamp/FAD flag?
        datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
        datafluorCorr = smoothImage(datafluorCorr,runInfo.gbox,runInfo.gsigma);
        xform_datafluorCorr=affineTransform(datafluorCorr,I);
clear datafluor datahb rawTime datafluorCorr isbrain 

%Save     
        disp('Saving Data')
        save(runInfo.saveHbFile,'xform_datahb','sessionInfo','op','E','-v7.3') 
        save(runInfo.saveFluorFile,'xform_datafluor','xform_datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','-v7.3')
        disp('Finally DONE Saving Data')   
        
%Pre-FC Process    
    %GSR (nan vs zero?)
        data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),4);
        parfor  i=1:size(data_full,4)
        data_full(:,:,:,i) = gsr(squeeze(xform_datahb(:,:,1,:)),xform_isbrain); % gsr
        end
        if ~isempty(runInfo.fluorChInd)
            data_full(:,:,:,4) = gsr(xform_datafluorCorr,xform_isbrain);
        end
    %Filter
        data_isa= nan(size(data_full));
        data_delta= nan(size(data_full));
        parfor ii=1:size(data_full,4)
        data_isa(:,:,:,ii)=filterData(data_full(:,:,:,ii),0.008,0.09,runInfo.samplingRate); 
        data_delta(:,:,:,ii)=filterData(data_full(:,:,:,ii),0.4,4,runInfo.samplingRate); 
        end
            clear data_full xform_datafluorCorr xform_datahb
%QC FC
    %ISA
    contrastName={'Hb','HbO','HbT','Fluor'}; %how can we make this hardwired?
            fRange = [0.009 0.08];
            fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];
            fStr(strfind(fStr,'.')) = 'p';
            
    [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap]...
    = qcFC(data_isa,xform_isbrain,runInfo.samplingRate,contrastName,runInfo,fRange);
    %Saving   
            saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
            save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
            saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
            save(saveBilateralFCName,'contrastName','bilatFCMap','xform_isbrain','-v7.3');
    %Delta
            fRange = [0.4 4]; 
            fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];
            fStr(strfind(fStr,'.')) = 'p';
    contrastName={'Hb','HbO','HbT','Fluor'}; %how can we make this hardwired?
    [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap]...
    = qcFC(data_delta,xform_isbrain,runInfo.samplingRate,contrastName,runInfo,fRange);     
    %Saving   
            saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
            save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
            saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
            save(saveBilateralFCName,'contrastName','bilatFCMap','xform_isbrain','-v7.3');

    end
end



%% Averaging 
