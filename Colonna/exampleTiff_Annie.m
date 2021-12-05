function exampleTiff_Annie(excelFile,excelRows)

% this function gives an example of how excel file is read, the data is
% loaded, invalid frames are removed, and processed to save hemoglobin and
% fluorescence dynamics data.
% The excel file uses the format Annie uses, which has one mouse data per
% row and minimal amount of information about sampling rate and other
% parameters. Thus, some of these parameters are assumed and hardcoded
% here.
%
% Inputs:
%   excelFile = character array of the excel file to be read. Ex:
%   'example.xlsx'
%   excelRows = which rows in the excel file should be read and processed?
%   Ex: 2:4

excelRows(excelRows == 1) = [];

%% read excel file to get information about each mouse run
runsInfo = parseTiffRuns(excelFile,excelRows);

% provide information about the processing stream
paramPath = what('bauerParams'); % path to bauerParams module
extCoeffFile = fullfile(paramPath.path,'prahl_extinct_coef.txt');
muspFcn = @(x,y) (40*(x/500).^-1.16)'*y; % parametric equation for reduced scattering coefficient

%% run wl generation for each trial
disp('get wl image and mask');

runInd = 0;
runNum = numel(runsInfo);
for runInfo = runsInfo % for each run
    runInd = runInd + 1;
    disp(['Trial # ' num2str(runInd) '/' num2str(runNum)]);
    
    % find the full mask file directory. This file will be checked for
    % mask. If this file does not exist, following if/else statement
    % creates the file.
    maskFileName = runInfo.saveMaskFile;
    saveFolder = runInfo.saveFolder;
    
    % create the white light image and mask file if it does not exist
    if ~exist(maskFileName)
        
        % instantiate VideosReader - reads the raw files to output matrix
        reader = mouse.read.VideosReader();
        reader.ReaderObject = mouse.read.TiffVideoReader;
        reader.BinFactor = ones(1,runInfo.numCh);
        reader.NumCh = runInfo.numCh;
        reader.DarkFrameInd = runInfo.darkFramesInd;
        reader.InvalidInd = runInfo.invalidFramesInd;
        reader.FreqIn = runInfo.samplingRate;
        reader.FreqOut = runInfo.samplingRate;
        
        [isbrain,xform_isbrain,I,WL] = getMask(runInfo.rawFile,reader,runInfo.rgbInd);
        
        if ~exist(saveFolder)
            mkdir(saveFolder);
        end
        
        save(maskFileName,'isbrain','I','xform_isbrain','WL','-v7.3');
    end
end

%% preprocess and process
disp('preprocess and process');

runInd = 0;
for runInfo = runsInfo % for each run
    runInd = runInd + 1;
    disp(['Trial # ' num2str(runInd) '/' num2str(runNum)]);
    
    % load mask
    maskData = load(runInfo.saveMaskFile);
    isbrain = maskData.isbrain;
    
    disp('read');
    t1 = tic;
    
    % instantiate VideosReader
    reader = mouse.read.VideosReader();
    reader.ReaderObject = mouse.read.TiffVideoReader; % which raw file reader should be used? (tiff, dat)
    reader.BinFactor = runInfo.binFactor;
    reader.NumCh = runInfo.numCh; % how many channels?
    reader.DarkFrameInd = runInfo.darkFramesInd; % which time frames are dark?
    reader.InvalidInd = runInfo.invalidFramesInd; % which time frames are invalid?
    reader.FreqIn = runInfo.samplingRate; % what is the sampling rate of raw data?
    reader.FreqOut = runInfo.samplingRate; % what should be the output sampling rate?
    [raw,rawTime] = reader.read(runInfo.rawFile); % read the files
    toc(t1);
    
    % perform rawQC analysis and save data
    disp('rawQC analysis...');
    droppedFrames = []; % assume no dropped frames by default
    if ~isempty(runInfo.fluorChInd)
        representativeCh = runInfo.fluorChInd;
    else
        representativeCh = runInfo.hbChInd(1);
    end
    qcRawFig = mouse.expSpecific.qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames);
    savefig(qcRawFig,runInfo.saveRawQCFig);
    saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
    close(qcRawFig);
    
    % perform check for dropped frames
    tic;
    disp('checking for dropped frames...');
    fixedData = false; % flag to see if data has been fixed yet or not
    [dfIndRaw, dfIndFixed, fixedRaw, fixedRawTime] = mouse.qc.fixDroppedFrames(runInfo,raw,rawTime,fixedData);
    toc;
    
    if isempty(dfIndRaw) % if no dropped frames, continue as normal
        disp('No dropped frames detected.');
        clear dfIndRaw dfIndFixed fixedRaw fixedRawTime;
    else
        disp(['Detected and corrected for ' num2str(length(dfIndRaw)) ' dropped frames!']);
        raw = fixedRaw;
        rawTime = fixedRawTime;
        droppedFrames = dfIndFixed;
        
        % rerun rawQC after correction
        representativeCh = runInfo.hbChInd(1);
        qcRawFig = mouse.expSpecific.qcRaw(runInfo,rawTime,raw,representativeCh,isbrain,droppedFrames);
        newQCSaveLoc = [runInfo.saveRawQCFig '_dropCorr'];
        saveas(qcRawFig,[newQCSaveLoc '.png']);
        close(qcRawFig);
        
        % check to make sure all dropped frames have been removed
        fixedData = true;
        [dfIndRaw, ~, ~, ~] = mouse.qc.fixDroppedFrames(runInfo,fixedRaw,fixedRawTime,fixedData);
        if ~isempty(dfIndRaw)
            currMouseName = [runInfo.recDate '-' runInfo.mouseName '-' runInfo.session...
                '' num2str(runInfo.run)];
            disp(['<<< Potential uncorrected dropped frames in ' currMouseName ' >>>']);
        end
        clear fixedRaw fixedRawTime;
    end
    
    disp('process hb');
    t1 = tic;
    hbLEDFiles =  runInfo.lightSourceFiles(runInfo.hbChInd);
    hbSamplingRate = runInfo.samplingRate;
    
    % get raw data for hb
    hbRaw = [];
    for chInd = runInfo.hbChInd
        hbRaw = cat(4,hbRaw,raw{chInd});
    end
    hbRaw = permute(hbRaw,[1 2 4 3]);
    hbTime = rawTime{runInfo.hbChInd(1)};
    
    % get optical properties of hemoglobin
    hbOP = mouse.physics.OpticalProperty();
    hbOP.ExtinctCoeffFile = extCoeffFile; % what is the extinction coefficient? (txt file)
    hbOP.LightSourceFiles = hbLEDFiles; % what are the light sources? (txt file)
    hbOP.Musp = muspFcn; % what is the reduced scattering coefficient? (function)
    
    % instantiate HbProcessor - processes raw matrix to hemoglobin data
    % (procOIS)
    hbProc = mouse.process.HbProcessor();
    hbProc.OpticalProperty = hbOP; % what are the hemoglobin optical properties?
    hbProc.Detrend = runInfo.detrendHb; % should we detrend hemoglobin?
    
    datahb = hbProc.process(hbRaw,hbSamplingRate);
    isbrainHb = mouse.math.bin(isbrain,runInfo.binFactor(runInfo.hbChInd(1)));
    isbrainHb = isbrainHb > (1-10*eps)*runInfo.binFactor(runInfo.hbChInd(1));
    toc(t1);
    
    if ~isempty(runInfo.fluorChInd) % if there are fluor channels
        disp('process fluor');
        t1 = tic;
        
        fluorRaw = raw{runInfo.fluorChInd};
        fluorTime = rawTime{runInfo.fluorChInd};
        
        fluorLEDFiles =  runInfo.lightSourceFiles(runInfo.fluorChInd);
        fluorSamplingRate = runInfo.samplingRate;
        
        % get optical properties of excitation light
        fluorInOP = mouse.physics.OpticalProperty();
        fluorInOP.ExtinctCoeffFile = extCoeffFile;
        fluorInOP.LightSourceFiles = fluorLEDFiles; % the LED file describing excitation light spectra
        fluorInOP.Musp = muspFcn;
        
        % get optical properties of emission light
        fluorOutOP = mouse.physics.OpticalProperty();
        fluorOutOP.ExtinctCoeffFile = extCoeffFile;
        fluorOutOP.LightSourceFiles = runInfo.fluorFiles; % the file describing emission light spectra
        fluorOutOP.Musp = muspFcn;
        
        % instantiate FluorProcessor - processes raw matrix and hemoglobin to
        % fluor
        fluorProc = mouse.process.FluorProcessor();
        fluorProc.Detrend = runInfo.detrendFluor;
        fluorProc.OpticalPropertyIn = fluorInOP;
        fluorProc.OpticalPropertyOut = fluorOutOP;
        
        dpIn = fluorProc.OpticalPropertyIn.getDiffPath;
        absCoeffIn = fluorProc.OpticalPropertyIn.getSpectraExtCoeff;
        dpOut = fluorProc.OpticalPropertyOut.getDiffPath;
        absCoeffOut = fluorProc.OpticalPropertyOut.getSpectraExtCoeff;
        dpIn = dpIn/2;
        dpOut = dpOut/2;
        
        
        
        datafluor = procFluor(squeeze(raw{runInfo.fluorChInd}),mean(raw{runInfo.fluorChInd},3,'omitnan'));
        datafluor = mouse.process.smoothImage(datafluor,runInfo.gbox,runInfo.gsigma);
        
        datafluorCorr = correctHb_differentBeta(datafluor,datahb,[absCoeffIn(1) absCoeffOut(1)],...
            [absCoeffIn(2) absCoeffOut(2)],dpIn,dpOut,0.7,0.8);
        datafluorCorr = mouse.process.smoothImage(datafluorCorr,runInfo.gbox,runInfo.gsigma);
        
        
        
        isbrainFluor = mouse.math.bin(isbrain,runInfo.binFactor(runInfo.fluorChInd(1)));
        isbrainFluor = isbrainFluor > (1-10*eps)*runInfo.binFactor(runInfo.fluorChInd(1));
        toc(t1);
    end
    
    if ~isempty(runInfo.speckleChInd) % if there are speckle channels
        disp('process speckle')
        t1 = tic;
        
        cbfRaw = raw{runInfo.speckleChInd};
        cbfTime = rawTime{runInfo.speckleChInd};
        
        % instantiate SpeckleProcessor - processes raw matrix to cbf data
        spProc = mouse.process.SpeckleProcessor();
        datacbf = spProc.process(cbfRaw);
        
        isbrainCbf = mouse.math.bin(isbrain,runInfo.binFactor(runInfo.speckleChInd(1)));
        isbrainCbf = isbrainCbf > (1-10*eps)*runInfo.binFactor(runInfo.speckleChInd(1));
        toc(t1);
    end
    %
    %     disp('downsample');
    %     t1 = tic;
    %     % only retain downsampled hemoglobin and cbf
    %     [datahbDs, hbTimeDs] = mouse.freq.resampledata(datahb,hbTime,runInfo.samplingRateHb);
    %     datahb = datahbDs;
    %     hbTime = hbTimeDs;
    %     if ~isempty(runInfo.fluorChInd) % if there are speckle channels
    %         [datafluorDs, fluorTimeDs] = mouse.freq.resampledata(datafluor,fluorTime,runInfo.samplingRateFluor);
    %         datafluor = datafluorDs;
    %         [datafluorCorrDs] = mouse.freq.resampledata(datafluorCorr,fluorTime,runInfo.samplingRateFluor);
    %         datafluorCorr = datafluorCorrDs;
    %         fluorTime = fluorTimeDs;
    %     end
    %     if ~isempty(runInfo.speckleChInd) % if there are speckle channels
    %         [datacbfDs, cbfTimeDs] = mouse.freq.resampledata(datacbf,cbfTime,runInfo.samplingRateCbf);
    %         datacbf = datacbfDs;
    %         cbfTime = cbfTimeDs;
    %     end
    %     toc(t1);
    
    if runInfo.affineTransform
        disp('affine transform');
        t1 = tic;
        xform_datahb = mouse.process.affineTransform(datahb,maskData.I);
        xform_isbrainHb = mouse.process.affineTransform(isbrainHb,maskData.I);
        if ~isempty(runInfo.fluorChInd) % if there are fluor channels
            xform_datafluor = mouse.process.affineTransform(datafluor,maskData.I);
            xform_datafluorCorr = mouse.process.affineTransform(datafluorCorr,maskData.I);
            xform_isbrainFluor = mouse.process.affineTransform(isbrainFluor,maskData.I);
        end
        if ~isempty(runInfo.speckleChInd) % if there are speckle channels
            xform_datacbf = mouse.process.affineTransform(datacbf,maskData.I);
            xform_isbrainCbf = mouse.process.affineTransform(isbrainCbf,maskData.I);
        end
        toc(t1);
    else
        disp('no affine transform done');
        xform_datahb = datahb;
        xform_isbrainHb = isbrainHb;
        if ~isempty(runInfo.fluorChInd) % if there are fluor channels
            xform_datafluor = datafluor;
            xform_datafluorCorr = datafluorCorr;
            xform_isbrainFluor = isbrainFluor;
        end
        if ~isempty(runInfo.speckleChInd) % if there are speckle channels
            xform_datacbf = datacbf;
            xform_isbrainCbf = isbrainCbf;
        end
    end
    
    disp('save processed');
    % make directory where data is saved if the directory does not exist
    if ~exist(runInfo.saveFolder)
        mkdir(runInfo.saveFolder);
    end
    
    if runInfo.saveRaw
        warning('off','all'); readerInfo = struct(reader); warning('on','all');
        save(runInfo.saveRawFile,'runInfo','readerInfo',...
            'rawTime','raw', 'droppedFrames' ,'-v7.3');
    end
    
    % save the processed data in hemoglobin data file
    warning('off','all'); hbProcInfo = struct(hbProc); warning('on','all');
    xform_isbrain = xform_isbrainHb;
    save(runInfo.saveHbFile,'runInfo','hbProcInfo','xform_isbrain',...
        'hbTime','xform_datahb', 'droppedFrames','-v7.3');
    
    if ~isempty(runInfo.fluorChInd) % if there are fluor channels
        warning('off','all'); fluorProcInfo = struct(fluorProc); warning('on','all');
        xform_isbrain = xform_isbrainFluor;
        % save the processed fluor data in fluorescence data file
        save(runInfo.saveFluorFile,'runInfo','fluorProcInfo','xform_isbrain',...
            'fluorTime','xform_datafluor','xform_datafluorCorr', 'droppedFrames','-v7.3');
    end
    
    if ~isempty(runInfo.speckleChInd) % if there are fluor channels
        warning('off','all'); spProcInfo = struct(spProc); warning('on','all');
        xform_isbrain = xform_isbrainCbf;
        % save the processed fluor data in fluorescence data file
        save(runInfo.saveCbfFile,'runInfo','spProcInfo','xform_isbrain',...
            'cbfTime','xform_datacbf', 'droppedFrames','-v7.3');
    end
    
%     if runInfo.qc
%         disp('quality control');
%         t1 = tic;
%         
%         % make data array to give into qc functions
%         data = {}; mask = {}; fs = []; time = {};
%         data{1} = squeeze(xform_datahb(:,:,1,:));
%         data{2} = squeeze(xform_datahb(:,:,2,:));
%         data{3} = squeeze(sum(xform_datahb,3));
%         time{1} = hbTime; time{2} = time{1}; time{3} = time{1};
%         fs(1) = 1/(hbTime(2) - hbTime(1)); fs(2:3) = fs(1);
%         mask{1} = xform_isbrainHb; mask{2} = mask{1}; mask{3} = mask{2};
%         contrastName = {'HbO','HbR','HbT'};
%         
%         if ~isempty(runInfo.fluorChInd) % if there are fluor channels
%             data{end+1} = squeeze(xform_datafluorCorr);
%             time{end+1} = fluorTime;
%             fs(end+1) = 1/(fluorTime(2) - fluorTime(1));
%             mask{end+1} = mask{1};
%             contrastName(end+1) = {'Fluor'};
%         end
%         if ~isempty(runInfo.speckleChInd) % if there are fluor channels
%             data{end+1} = squeeze(xform_datacbf);
%             time{end+1} = cbfTime;
%             fs(end+1) = 1/(cbfTime(2) - cbfTime(1));
%             mask{end+1} = xform_isbrain;
%             contrastName(end+1) = {'CBF'};
%         end
%         
%         % make qc fc fig or qc stim fig
%         if contains(runInfo.session,'fc')
%             fRange = [0.009 0.08]; %changed 4/29 from [0.009 0.08] in order to cover delta band instead
%             fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];
%             fStr(strfind(fStr,'.')) = 'p';
% 
%             [fcFig, seedCenter, seedRadius, seedFCMap, seedFC,bilateralFCMap] =...
%                 runSeedFCBilateral(data,mask,fs,runInfo,contrastName,fRange);
%             saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
%             save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
%             
%             saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
%             save(saveBilateralFCName,'contrastName','bilateralFCMap','mask','-v7.3');
%             
%             for contrastInd = 1:numel(data)
%                 saveFCQCFigName = [runInfo.saveFCQCFig '-' contrastName{contrastInd}];
%                 saveas(fcFig(contrastInd),[saveFCQCFigName '.png']);
%                 close(fcFig(contrastInd));
%             end
%         end
%         if contains(runInfo.session,'stim')
%             data{1} = data{1}*1000; data{2} = data{2}*1000; data{3} = data{3}*1000;
%             stimFig = mouse.expSpecific.qcStim(data,time,mask,...
%                 runInfo.stimStartTime,runInfo.stimEndTime,...
%                 runInfo.blockLen,runInfo.stimRoiSeed,contrastName);
%             saveas(stimFig,[runInfo.saveStimQCFig '.png']);
%             close(stimFig);
%         end
%         toc(t1);
%     end
end

end

function [isbrain,xform_isbrain,affineMarkers,WL] = getMask(fileNames,reader,rgbOrder)
%getMask Outputs mask data from raw data
%   By providing which files to read, as well as the reader object and
%   indices of red, green, and blue LEDs, we instantiate a GUI that runs
%   shows the white light image and allows user to determine the mask.

badDataInd = unique([reader.DarkFrameInd reader.InvalidInd]);
realDataStart = max(badDataInd) + 1;
[rawCell,~] = reader.read(fileNames,'chReadInd',1:realDataStart);
raw = [];
for chInd = 1:numel(rawCell)
    raw = cat(4,raw,rawCell{chInd});
end
raw = permute(raw,[1 2 4 3]);
raw = single(raw);
WL = mouse.process.getWL(raw,rgbOrder);
affineMarkers = mouse.process.getLandmarks(WL);
isbrain = mouse.process.getMask(WL);
xform_isbrain = mouse.process.affineTransform(isbrain,affineMarkers);
end