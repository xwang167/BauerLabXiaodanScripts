
tic
poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
% excelFile="C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\examples\Code Modification\exampleTiffOIS+Gcamp.xlsx";
% excelRows=[15];  % Rows from Excell Database
%clear all;close all;
excelFile="X:\XW\Paper\PaperExperiment.xlsx";
excelRows=26:28;

fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';


%% Process Data
% Process multiple OIS files with the following naming convention:

% filedate: YYMMDD
% subjname: any alphanumberic convention is ok, e.g. "Mouse1"
% suffix: filename run number, e.g. "fc1"
% In Andor Solis, files are saved as "YYMMDD-MouseName-suffixN.tif"

% "directory" is where processed data will be stored. If the
% folder does not exist, it is created, and if directory is not
% specified, data will be saved in the current folder:
previousDate = [];
for runInd=runNum %for each mouse
    
    runInfo=runsInfo(runInd);
    currentDate = runInfo.recDate;
    
    if  ~contains(runInfo.system,'EastOIS2')
        
        if ~exist(runInfo.saveMaskFile,'file')
            raw = readtiff(runInfo.rawFile{1});
            raw = reshape(raw,size(raw,1),size(raw,2),runInfo.numCh,[]);
            [isbrain,xform_isbrain,I,WL,xform_WL] = getMask(raw,runInfo.darkFramesInd,runInfo.invalidFramesInd,runInfo.rgbInd);
            if ~exist(runInfo.saveFolder)
                mkdir(runInfo.saveFolder);
            end
            save(runInfo.saveMaskFile,'xform_WL','isbrain','I','xform_isbrain','WL','-v7.3');
        end
        
    else     %elseif?? strcmp('EastOIS2',runInfo.system)
        
        if ~exist(runInfo.saveMaskFile,'file')
            load(fullfile(runInfo.rawFile{1}))
            %%% Check Dropped Frame. If there is, assume it to be the 80th
            %%% dark frame
            sessionInfo = sysInfo(runInfo.system);
            if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
                numCh = size(raw_unregistered,3);
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
            end

            firstFrame_cam1  = squeeze(raw_unregistered(:,:,sessionInfo.rgb(2),runInfo.darkFramesInd(end)+1));
            
            clear raw_unregistered
            load(fullfile(runInfo.rawFile{2}))
            if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
                numCh = size(raw_unregistered,3);
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
            end
            
            firstFrame_cam2  = squeeze(raw_unregistered(:,:,sessionInfo.rgb(1),runInfo.darkFramesInd(end)+1));

            clear raw_unregistered
            
            if ~strcmp(previousDate,currentDate)
                load(strcat('\\10.23.92.192\RawData_EastOIS2\',runInfo.recDate,'\',runInfo.recDate,'-grid-WL-cam1.mat'))
                cam1 = raw_unregistered(:,:,1,21);
                clear raw_unregistered
                load(strcat('\\10.23.92.192\RawData_EastOIS2\',runInfo.recDate,'\',runInfo.recDate,'-grid-WL-cam2.mat'))
                cam2 = raw_unregistered(:,:,1,21);
                clear raw_unregistered
                [mytform,fixed_cam1,registered_cam2] = getTransformation(cam1,cam2);
                if ~exist(runInfo.saveFolder)
                    mkdir(runInfo.saveFolder)
                end
                save(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat')),'mytform')
            end
            load(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat')),'mytform')
            previousDate = currentDate;
            fixed = firstFrame_cam1./max(max(firstFrame_cam1));
            unregistered = firstFrame_cam2./max(max(firstFrame_cam2));
            registered = imwarp(unregistered, mytform,'OutputView',imref2d(size(unregistered)));
            %Create White Light Image
            WL = zeros(128,128,3);
            WL(:,:,1) = registered;
            WL(:,:,2) = fixed;
            WL(:,:,3) = fixed;
            [isbrain,xform_isbrain,I,seedcenter,WLcrop,xform_WLcrop,xform_WL] = getLandMarksandMask_Zyla(WL);
            save(runInfo.saveMaskFile,'xform_WL','isbrain','I','xform_isbrain','WL','-v7.3');
            close all
        
        end
    end
end

runNum = numel(runsInfo);

for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    
    
    load(runInfo.saveMaskFile); %anmol-load savemaskfile (I don't think there's a way that the saveMaskFile will not exist if the code reaches this point)
    
    disp(['Processing ', runInfo.saveHbFile ' on ', runInfo.system])
    sessionInfo = sysInfo(runInfo.system);
    
    %Processing Raw Data
    if ~contains(runInfo.system,'EastOIS2')
        raw = readtiff(runInfo.rawFile{1});
    else
        load(fullfile(runInfo.rawFile{1}))
        if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
            numCh = size(raw_unregistered,3);
            raw_unregistered = reshape(raw_unregistered,128,128,[]);
            raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
            raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
        end
        binnedRaw_cam1 = raw_unregistered(:,:,sessionInfo.cam1Chan,:);
        clear raw_unregistered
        load(fullfile(runInfo.rawFile{2}))
        if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
            numCh = size(raw_unregistered,3);
            raw_unregistered = reshape(raw_unregistered,128,128,[]);
            raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
            raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
        end
        binnedRaw_cam2= raw_unregistered(:,:,sessionInfo.cam2Chan,:);
        clear raw_unregistered
        if strcmp(runInfo.system,'EastOIS2+laser')
            load(runInfo.saveMaskFile,'mytform')
        else
            load(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat')),'mytform')
        end
        raw  = registerCam2andCombineTwoCams(binnedRaw_cam1,binnedRaw_cam2,mytform,sessionInfo.cam1Chan,sessionInfo.cam2Chan);
        save(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run))),'raw','-v7.3')
    end
    
    raw = reshape(raw,size(raw,1),size(raw,2),runInfo.numCh,[]);
    
    % Remove dark  frames
    if ~isempty(runInfo.darkFramesInd)
        runInfo.darkFramesInd(runInfo.darkFramesInd == runInfo.invalidFramesInd) = [];
        darkFrame = squeeze(mean(raw(:,:,:,runInfo.darkFramesInd),4,'omitnan'));
        raw = double(raw) - double(repmat(darkFrame,1,1,1,size(raw,4)));
        raw(:,:,:,1:runInfo.darkFramesInd(end))=[];
    else
        raw(:,:,:,runInfo.invalidFramesInd) = [];%invalidFramesInd default is 1
    end
    clear darkFrame
    
    %QC raw data.
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
    raw = single(raw);
    qcRawFig = qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames,runInfo.system);
    savefig(qcRawFig,runInfo.saveRawQCFig);
    saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
    close(qcRawFig);
   
    %Detrending
    for i=1: size(raw,3)
        raw(:,:,i,:)=temporalDetrend(raw(:,:,i,:),isbrain); %?!fix?!
    end
    %OPTICAL PROP AND SPECTROSCOPY
    %HB
    [op, E] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.hbChInd}});
    datahb = procOIS_xw(raw(:,:,runInfo.hbChInd,:),op.dpf,E,isbrain); %where is isbrain made?
    datahb = smoothImage(datahb,runInfo.gbox,runInfo.gsigma);
    save(runInfo.saveHbFile,'datahb','op','E','runInfo','-v7.3')
    
    
    %Fluoro (calcium)
    if ~isempty(runInfo.fluorChInd)
        [op_in, E_in] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.fluorChInd}});
        [op_out, E_out] = getHbOpticalProperties_new(runInfo.fluorFiles);
        dpIn = op_in.dpf/2;
        dpOut = op_out.dpf/2;
        
        datafluor = procFluor(squeeze(raw(:,:,runInfo.fluorChInd,:)),mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan'));
        datafluor = smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
        %Fluoro-Correction
        if  strcmp('EastOIS1_Fluor',runInfo.system) %gcamp correction
            datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
        elseif contains(runInfo.system,'EastOIS2') %jRGECGO1a correction
            datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,1,1);
        end
        save(runInfo.saveFluorFile,'datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','runInfo','-v7.3')
        clear datafluor 
    end
    
    %FAD
    if ~isempty(runInfo.FADChInd)
        [op_inFAD, E_inFAD] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.FADChInd}});
        [op_outFAD, E_outFAD] = getHbOpticalProperties_new(runInfo.FADFiles);
        dpIn = op_inFAD.dpf/2;
        dpOut = op_outFAD.dpf/2;
        
        dataFAD = procFluor(squeeze(raw(:,:,runInfo.FADChInd,:)),mean(raw(:,:,runInfo.FADChInd,:),4,'omitnan'));
        dataFAD = smoothImage(dataFAD,runInfo.gbox,runInfo.gsigma);
        dataFAD = affineTransform(dataFAD,I);
        clear raw
        %FAD-Correction
        dataFADCorr = correctHb_differentBeta(dataFAD,datahb,[E_inFAD(1) E_outFAD(1)],[E_inFAD(2) E_outFAD(2)],dpIn,dpOut,1,1);
        dataFADCorr = smoothImage(dataFADCorr,runInfo.gbox,runInfo.gsigma);
        
        save(runInfo.saveFADFile,'dataFADCorr','op_inFAD', 'E_inFAD', 'op_outFAD', 'E_outFAD','runInfo','-v7.3')
        clear dataFAD 
    end
    
    clear rawTime  isbrain
    
    %Laser Frame
    
    
    
    %Pre-FC Process:
    load(runInfo.saveMaskFile,'isbrain')
    if ~isempty(runInfo.fluorChInd)
        data_full = nan(size(datahb,1),size(datahb,2),size(datahb,4),4);
    elseif ~isempty(runInfo.FADChInd)
        data_full = nan(size(datahb,1),size(datahb,2),size(datahb,4),5);
    else
        data_full = nan(size(datahb,1),size(datahb,2),size(datahb,4),3);
    end
    %Shape Data
    data_full(:,:,:,1)=squeeze(datahb(:,:,1,:));
    data_full(:,:,:,2)=squeeze(datahb(:,:,2,:));
    data_full(:,:,:,3)=squeeze(datahb(:,:,1,:))+squeeze(datahb(:,:,2,:));
    if ~isempty(runInfo.fluorChInd)
        data_full(:,:,:,4) = datafluorCorr;
    end
    if ~isempty(runInfo.FADChInd)
        data_full(:,:,:,5) = dataFADCorr;
    end    
    
    if ~isempty(runInfo.FADChInd)
        peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimStartTime:runInfo.stimEndTime,...
            runInfo.stimStartTime:runInfo.stimEndTime};%%
    elseif ~isempty(runInfo.fluorChInd)
        peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimStartTime:runInfo.stimEndTime};
    else
        peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
            runInfo.stimEndTime-1:runInfo.stimEndTime+1};
    end
    
    stimBlockSize=round(runInfo.blockLen*runInfo.samplingRate);
    R=mod(size(data_full,3),stimBlockSize);
    
    if R~=0
        pad=stimBlockSize-R;
        disp(['** Non integer number of blocks presented. Padded with ' , num2str(pad), ' zeros **'])
        data_full(:,:,end:end+pad,:)=0;
        runInfo.appendedZeros=pad;
    end
    
    numBlocks = round(size(data_full,3)/(runInfo.blockLen*runInfo.samplingRate));%what if not integer
    
    % GSR function takes concatonated data
    data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],length(runInfo.Contrasts));
    % gsr
    for ii = size(data_full,4)
        data_full(:,:,:,ii) = gsr(squeeze(data_full(:,:,:,ii)),isbrain);
    end
    
    data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,size(data_full,4));
    %Baseline Subtract
    isbrain_matrix = repmat(isbrain,1,1,size(data_full,3),1,1);
    for ii = 1:numBlocks
        for jj = length(runInfo.Contrasts)
            meanFrame = squeeze(mean(data_full(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
            data_full(:,:,:,ii,jj) = data_full(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data_full,3),1,1);
            data_full(:,:,:,ii,jj) = data_full(:,:,:,ii,jj).*isbrain_matrix;
        end
    end
    clear isbrain_matrix meanFrame
    %Reshape
    data_full = reshape(data_full,size(data_full,1),size(data_full,2),[],numBlocks,length(runInfo.Contrasts));
    %Create pres maps
    
    
    fh= generateBlockMap(data_full,runInfo.Contrasts,runInfo,numBlocks,peakTimeRange,isbrain);
    %save
    sgtitle([runInfo.saveFilePrefix(17:end),'GSR']) %anmol - suptitle to sgtitle
    saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak');
    saveas(gcf,strcat(saveName,'.fig'))
    saveas(gcf,strcat(saveName,'.png'))
    close all
    
    
    
    disp(['Done Processing ', runInfo.saveHbFile ' on ', runInfo.system])
    
end
toc

%% Averaging
