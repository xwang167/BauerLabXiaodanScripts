poolobj = gcp('nocreate'); % If no pool, do not create new one.
numcores = feature('numcores');
if isempty(poolobj)
    parpool('local',numcores-1);
end
%% Get Run and System Info
% excelFile="C:\Users\xiaodanwang\Documents\GitHub\BauerLab\MATLAB\examples\Code Modification\exampleTiffOIS+Gcamp.xlsx";
% excelRows=[15];  % Rows from Excell Database
excelFile = "X:\XW\CodeModification\CodeModification.xlsx";
excelRows = [6];
fRange_ISA = [0.01 0.08];
fRange_delta = [0.5 4];
runsInfo = parseRuns(excelFile,excelRows);
[row,start_ind_mouse,numruns_per_mouse]=unique({runsInfo.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
runNum=start_ind_mouse';



%% Get Masks and WL
previousDate = [];
for runInd=runNum %for each mouse
    
    runInfo=runsInfo(runInd);
    currentDate = runInfo.recDate;
    
    if  ~strcmp('EastOIS2',runInfo.system)
        
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
            if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
                numCh = size(raw_unregistered,3);
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
            end
            firstFrame_cam1  = squeeze(raw_unregistered(:,:,2,runInfo.darkFramesInd(end)+1));
            clear raw_unregistered
            load(fullfile(runInfo.rawFile{2}))
            if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
                numCh = size(raw_unregistered,3);
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
            end
            firstFrame_cam2  = squeeze(raw_unregistered(:,:,4,runInfo.darkFramesInd(end)+1));
            clear raw_unregistered
            
            if ~strcmp(previousDate,currentDate)
                [mytform,fixed_cam1,registered_cam2] = getTransformation(firstFrame_cam1,firstFrame_cam2);
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
        end
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

runNum = numel(runsInfo);

for runInd = 1:runNum
    clearvars -except runsInfo runNum runInd fRange_ISA fRange_delta
    runInfo=runsInfo(runInd);
    
    %If is this already processed
    if exist(runInfo.saveHbFile,'file')
        disp([runInfo.saveHbFile,' Already processed'])
        load(runInfo.saveHbFile,'xform_datahb')
        load(runInfo.saveMaskFile,'xform_isbrain')
        if ~isempty(runInfo.fluorChInd)
            load(runInfo.saveFluorFile,'xform_datafluorCorr')
        end
        if ~isempty(runInfo.FADChInd)
            load(runInfo.saveFluorFile,'xform_dataFADCorr')
        end
    else
        disp(['Processing ', runInfo.saveHbFile ' on ', runInfo.system])
        sessionInfo = sysInfo(runInfo.system);
        
        %Processing Raw Data
        if ~strcmp('EastOIS2', runInfo.system)
            raw = readtiff(runInfo.rawFile{1});
        else
            load(fullfile(runInfo.rawFile{1}))
            if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
                numCh = size(raw_unregistered,3);
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
            end
            binnedRaw_cam1 = raw_unregistered(:,:,[1,2],:);
            clear raw_unregistered
            load(fullfile(runInfo.rawFile{2}))
            if sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end)),'all')/sum(raw_unregistered(:,:,1,runInfo.darkFramesInd(end-1)),'all')>5
                numCh = size(raw_unregistered,3);
                raw_unregistered = reshape(raw_unregistered,128,128,[]);
                raw_unregistered(:,:,2:end) = raw_unregistered(:,:,1:end-1);
                raw_unregistered = reshape(raw_unregistered,128,128,numCh,[]);
            end
            binnedRaw_cam2= raw_unregistered(:,:,[3,4],:);
            clear raw_unregistered
            load(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-tform.mat')),'mytform')
            raw  = registerCam2andCombineTwoCams(binnedRaw_cam1,binnedRaw_cam2,mytform);
            save(fullfile(runInfo.saveFolder,strcat(runInfo.recDate,'-',runInfo.mouseName,'-',runInfo.session,num2str(runInfo.run))),'raw','-v7.3') %why are we saving these?
        end
        
        raw = reshape(raw,size(raw,1),size(raw,2),runInfo.numCh,[]);
        
        % Remove dark  frames
        if ~isempty(runInfo.darkFramesInd)
            runInfo.darkFramesInd(runInfo.darkFramesInd == runInfo.invalidFramesInd) = [];
            darkFrame = squeeze(mean(raw(:,:,:,runInfo.darkFramesInd),4,'omitnan'));
            raw = double(raw) - double(repmat(darkFrame,1,1,1,size(raw,4)));
            raw(:,:,:,1:length(runInfo.darkFramesInd))=[];
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
        
        if ~strcmp('EastOIS2', runInfo.system)
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
        end
        %Detrending
        parfor i=1: size(raw,3)
            raw(:,:,i,:)=temporalDetrend(raw(:,:,i,:),isbrain);
        end
        %OPTICAL PROP AND SPECTROSCOPY
        %HB
        load('X:\XW\CodeModification\Annie_OpticalProperty.mat')
        datahb = procOIS_filterFirst(raw(:,:,runInfo.hbChInd,:),op.dpf,E,isbrain); %where is xform_isbrain made?
        datahb = smoothImage(datahb,runInfo.gbox,runInfo.gsigma);
        xform_datahb = affineTransform(datahb,I);
        save(runInfo.saveHbFile,'xform_datahb','op','E','runInfo','-v7.3')
        
        %Fluoro (calcium)
        if ~isempty(runInfo.fluorChInd)
            [op_in, E_in] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.fluorChInd}});
            [op_out, E_out] = getHbOpticalProperties_new(runInfo.fluorFiles);
            dpIn = op_in.dpf/2;
            dpOut = op_out.dpf/2;
            
            datafluor = procFluor(squeeze(raw(:,:,runInfo.fluorChInd,:)),mean(raw(:,:,runInfo.fluorChInd,:),4,'omitnan'));
            datafluor = smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
            xform_datafluor = affineTransform(datafluor,I);
            %Fluoro-Correction
            if  strcmp('EastOIS1_Fluor',runInfo.system) %gcamp correction
                datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
            elseif strcmp('EastOIS2',runInfo.system) %jRGECGO1a correction
                datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,1,1);
            end
            datafluorCorr = smoothImage(datafluorCorr,runInfo.gbox,runInfo.gsigma);
            xform_datafluorCorr=affineTransform(datafluorCorr,I);
            save(runInfo.saveFluorFile,'xform_datafluor','xform_datafluorCorr','op_in', 'E_in', 'op_out', 'E_out','runInfo','-v7.3')
            clear datafluor datafluorCorr xform_datafluor
        end
        
        %FAD
        if ~isempty(runInfo.FADChInd)
            [op_inFAD, E_inFAD] = getHbOpticalProperties_new({runInfo.lightSourceFiles{runInfo.FADChInd}});
            [op_outFAD, E_outFAD] = getHbOpticalProperties_new(runInfo.FADFiles);
            dpIn = op_inFAD.dpf/2;
            dpOut = op_outFAD.dpf/2;
            
            dataFAD = procFluor(squeeze(raw(:,:,runInfo.FADChInd,:)),mean(raw(:,:,runInfo.FADChInd,:),4,'omitnan'));
            dataFAD = smoothImage(dataFAD,runInfo.gbox,runInfo.gsigma);
            xform_dataFAD = affineTransform(dataFAD,I);
            clear raw
            %FAD-Correction
            dataFADCorr = correctHb_differentBeta(dataFAD,datahb,[E_inFAD(1) E_outFAD(1)],[E_inFAD(2) E_outFAD(2)],dpIn,dpOut,1,1);
            dataFADCorr = smoothImage(dataFADCorr,runInfo.gbox,runInfo.gsigma);
            xform_dataFADCorr=affineTransform(dataFADCorr,I);
            save(runInfo.saveFADFile,'xform_dataFAD','xform_dataFADCorr','op_inFAD', 'E_inFAD', 'op_outFAD', 'E_outFAD','runInfo','-v7.3')
            clear dataFAD xform_dataFAD dataFADCorr
        end
        
        clear datahb rawTime  isbrain
    end
    
    %Pre-FC Process:
    if runInfo.session =="fc"
        %Initialize
        if ~isempty(runInfo.fluorChInd)
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),3);
        elseif ~isempty(runInfo.FADChInd)
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),4);
        else
            data_full = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),2);
        end
        %Shape Data
        data_full(:,:,:,1)=squeeze(xform_datahb(:,:,1,:));
        data_full(:,:,:,2)=squeeze(xform_datahb(:,:,2,:));
        data_full(:,:,:,3)=squeeze(xform_datahb(:,:,1,:))+squeeze(xform_datahb(:,:,2,:));
        if ~isempty(runInfo.fluorChInd)
            data_full(:,:,:,4) = xform_datafluorCorr;
        elseif ~isempty(runInfo.FADChInd)
            data_full(:,:,:,5) = xform_dataFADCorr;
        end
        
        clear  xform_datafluorCorr xform_datahb xform_dataFADCorr
        
        %Filter
        data_isa= nan(size(data_full));
        data_delta= nan(size(data_full));
        parfor ii=1:size(data_full,4)
            data_isa(:,:,:,ii)=filterData(data_full(:,:,:,ii),fRange_ISA(1),fRange_ISA(2),runInfo.samplingRate);
            data_delta(:,:,:,ii)=filterData(data_full(:,:,:,ii),fRange_delta(1),fRange_delta(2),runInfo.samplingRate);
        end
        clear data_full
        
        %GSR
        parfor  ii=1:size(data_isa,4)
            data_isa(:,:,:,ii) = gsr(squeeze(data_isa(:,:,:,ii)),xform_isbrain);
            data_delta(:,:,:,ii) = gsr(squeeze(data_delta(:,:,:,ii)),xform_isbrain);
        end
        
        
        %QC FC
        %ISA
        fStr = [num2str(fRange_ISA(1)) '-' num2str(fRange_ISA(2))];
        fStr(strfind(fStr,'.')) = 'p';
        ContFig2Save= {'HbO','HbT'};
        [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap]...
            = qcFC(data_isa,xform_isbrain,runInfo.Contrasts,runInfo,fRange_ISA,ContFig2Save);
        
        for contrastInd = 1:numel(ContFig2Save)
            saveFCQCFigName = [runInfo.saveFCQCFig '-' ContFig2Save{contrastInd} '-' fStr ];
            saveas(fh(contrastInd),[saveFCQCFigName '.png']);
            close(fh(contrastInd));
        end
        
        %Saving
        contrastName = runInfo.Contrasts;
        saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
        save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
        saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
        save(saveBilateralFCName,'contrastName','bilatFCMap','xform_isbrain','-v7.3');
        
        
        %Delta Band
        if ~isempty(runInfo.fluorChInd)
            
            fStr = [num2str(fRange_delta(1)) '-' num2str(fRange_delta(2))];
            fStr(strfind(fStr,'.')) = 'p';
            ContFig2Save= {'Calcium'};
            if ~isempty(runInfo.FADChInd)
                ContFig2Save= {'Calcium','FAD'};
            end
            clear fh
            if ~strcmp(runInfo.system,'EastOIS1')
                [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap]...
                    = qcFC(data_delta,xform_isbrain,runInfo.Contrasts,runInfo,fRange_delta,ContFig2Save);
                
                for contrastInd = 1:numel(ContFig2Save)
                    saveFCQCFigName = [runInfo.saveFCQCFig '-' ContFig2Save{contrastInd} '-' fStr ];
                    saveas(fh(contrastInd),[saveFCQCFigName '.png']);
                    close(fh(contrastInd));
                end
            end
            %Saving
            saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
            save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
            saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
            save(saveBilateralFCName,'contrastName','bilatFCMap','xform_isbrain','-v7.3');
        end
        
        
        
        
    elseif runInfo.session =="stim"
        load(runInfo.saveMaskFile,'xform_isbrain')
        if ~isempty(runInfo.FADChInd)
            peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimStartTime:runInfo.stimEndTime,...
                runInfo.stimStartTime:runInfo.stimEndTime};%%
        end
        if ~isempty(runInfo.fluorChInd)
            peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimStartTime:runInfo.stimEndTime};
        else
            peakTimeRange = {runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1,...
                runInfo.stimEndTime-1:runInfo.stimEndTime+1};
        end
%         
%         range = nan(1,length(runInfo.Contrasts));
%         range(1) = 2;%7.5;%3;%15;
%         range(2) = 1; %2.5;%1%7;
%         range(3) = 2;%5;%2;%8;
%         if ~isempty(runInfo.fluorChInd)
%             range(4) = 0.8;
%         end
%         if ~isempty(runInfo.FADChInd)
%             range(5) = 0.6;
%         end
        data = nan(size(xform_datahb,1),size(xform_datahb,2),size(xform_datahb,4),length(runInfo.Contrasts));
        data(:,:,:,1) = squeeze(xform_datahb(:,:,1,:))*10^6;
        data(:,:,:,2) = squeeze(xform_datahb(:,:,2,:))*10^6;
        clear xform_datahb
        data(:,:,:,3) = data(:,:,:,1) + data(:,:,:,2);
        if ~isempty(runInfo.fluorChInd)
            data(:,:,:,4) = xform_datafluorCorr*100;
            clear xform_datafluorCorr
        end
        if ~isempty(runInfo.FADChInd)
            data(:,:,:,5) = xform_dataFADCorr*100;
            clear xform_dataFADCorr
        end
        
        numBlocks = size(data,3)/(runInfo.blockLen*runInfo.samplingRate);%what if not integer
        
        % GSR function takes concatonated data
        data = reshape(data,size(data,1),size(data,2),[],length(runInfo.Contrasts));
        % gsr
        for ii = size(data,4)
            data(:,:,:,ii) = gsr(squeeze(data(:,:,:,ii)),xform_isbrain);
        end
        data = reshape(data,size(data,1),size(data,2),[],numBlocks,size(data,4));
        %Baseline Subtract
        xform_isbrain_matrix = repmat(xform_isbrain,1,1,size(data,3),1,1);
        for ii = 1:numBlocks
            for jj = length(runInfo.Contrasts)
                meanFrame = squeeze(mean(data(:,:,1:runInfo.stimStartTime*runInfo.samplingRate,ii,jj),3));
                data(:,:,:,ii,jj) = data(:,:,:,ii,jj) - repmat(meanFrame,1,1,size(data,3),1,1);
                data(:,:,:,ii,jj) = data(:,:,:,ii,jj).*xform_isbrain_matrix;
            end
        end
        clear xform_isbrain_matrix meanFrame
        %Reshape
        data = reshape(data,size(data,1),size(data,2),[],numBlocks,length(runInfo.Contrasts));
        %Create pres maps
        
        
        fh= generateBlockMap(data,runInfo.Contrasts,runInfo,numBlocks,peakTimeRange);
        %save
        suptitle([runInfo.saveFilePrefix(17:end),'GSR'])
        saveName = strcat(runInfo.saveFilePrefix,'_GSR_BlockPeak');
        saveas(gcf,strcat(saveName,'.fig'))
        saveas(gcf,strcat(saveName,'.png'))
        close all
        
        
    end
    disp(['Done Processing ', runInfo.saveHbFile ' on ', runInfo.system])
    
end





%% Averaging
