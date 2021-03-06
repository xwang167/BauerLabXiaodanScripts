function exampleZylaTwoFluor(excelFile,rows)
%exampleZylaTwoFluor
% this function gives an example of how excel file is read, the data is
% loaded, invalid frames are removed, and processed to save hemoglobin and
% fluorescence dynamics data when only relevent frames are transferred to
% server in .mat file
% The excel file uses the format Annie uses, which has one mouse data per
% row and minimal amount of information about sampling rate and other
% parameters. Thus, some of these parameters are assumed and hardcoded
% here.
% We assume that there are 4 channels, of which 2nd channel is rgeco
% fluorescence and 3rd and 4th channel are used for hemoglobin.
% We assume that there are two cameras, of which all the data files for one
% camera is in one folder with the name format: [date]-[mouse
% name]-cam#-session#

%
% Inputs:
%   excelFile = character array of the excel file to be read
%   rows = which rows in the excel file should be read and processed?

%% parameters

%% read excel file to get information about each mouse run

runsInfo = parseMatRuns(excelFile,rows);

% provide information about the processing stream
paramPath = what('bauerParams'); % path to bauerParams module
extCoeffFile = fullfile(paramPath.path,'prahl_extinct_coef.txt');
muspFcn = @(x,y) (40*(x/500).^-1.16)'*y; % parametric equation for reduced scattering coefficient

%% run wl generation for each trial
disp('get wl image and mask');

runInd = 0;
runNum = numel(runsInfo);
numCh = 4;

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
        % reader object for camera 1
        reader1 = mouse.read.VideosReader();
        reader1.ReaderObject = mouse.read.DatVideoReader;
        reader1.BinFactor = ones(1,numCh);
        reader1.ChNum = numCh;
        reader1.DarkFrameInd = runInfo.darkFramesInd;
        reader1.InvalidInd = runInfo.invalidFramesInd;
        reader1.FreqIn = runInfo.samplingRate;
        reader1.FreqOut = runInfo.samplingRate;
        
        % reader object for camera 2
        reader2 = mouse.read.VideosReader();
        reader2.ReaderObject = mouse.read.DatVideoReader;
        reader2.BinFactor = ones(1,numCh);
        reader2.ChNum = numCh;
        reader2.DarkFrameInd = runInfo.darkFramesInd;
        reader2.InvalidInd = runInfo.invalidFramesInd;
        reader2.FreqIn = runInfo.samplingRate;
        reader2.FreqOut = runInfo.samplingRate;
        
        
        [isbrain,affineMarkers,transformMat,WL,seedcenter] = getMask(runInfo.rawFile{1},runInfo.rawFile{2},reader1);       
        if ~exist(saveFolder)
            mkdir(saveFolder);
        end
        isbrain_contour = bwperim(isbrain);
        imagesc(WL); %changed 3/1/1
        axis off
        axis image
        title(strcat(runInfo.recDate,'-',runInfo.mouseName));
        
        for f=1:size(seedcenter,1)
            hold on;
            plot(seedcenter(f,1)*size(WL,1),seedcenter(f,2)*size(WL,2),'ko','MarkerFaceColor','k')
        end
        hold on;
        plot(affineMarkers.tent(1,1)*size(WL,1),affineMarkers.tent(1,2)*size(WL,2),'ko','MarkerFaceColor','b')
        hold on;
        plot(affineMarkers.bregma(1,1)*size(WL,1),affineMarkers.bregma(1,2)*size(WL,2),'ko','MarkerFaceColor','b')
        hold on;
        plot(affineMarkers.OF(1,1)*size(WL,1),affineMarkers.OF(1,2)*size(WL,2),'ko','MarkerFaceColor','b')
        hold on;
        contour(isbrain_contour,'r')
        saveas(gcf,fullfile(saveFolder,strcat(runInfo.recDate,'-',runInfo.mouseName,'_WLandMarks.jpg')))
        close all
        save(maskFileName,'affineMarkers','transformMat','isbrain','WL','-v7.3');
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
    % reader for camera 1
    reader1 = mouse.read.VideosReader();
    reader1.ReaderObject = mouse.read.DatVideoReader;
    reader1.BinFactor = runInfo.binFactor;
    reader1.ChNum = numCh;
    reader1.DarkFrameInd = runInfo.darkFramesInd;
    reader1.InvalidInd = runInfo.invalidFramesInd;
    reader1.FreqIn = runInfo.samplingRate;
    reader1.FreqOut = runInfo.samplingRate;
    
    % reader for camera 2
    reader2 = mouse.read.VideosReader();
    reader2.ReaderObject = mouse.read.DatVideoReader;
    reader2.BinFactor = runInfo.binFactor;
    reader2.ChNum = numCh;
    reader2.DarkFrameInd = runInfo.darkFramesInd;
    reader2.InvalidInd = runInfo.invalidFramesInd;
    reader2.FreqIn = runInfo.samplingRate;
    reader2.FreqOut = runInfo.samplingRate;
    
    
    load(runInfo.rawFile{1})
    for ii = 1: size(raw_unregistered,3)
        raw1Cell{ii} = squeeze(raw_unregistered(:,:,ii,max(reader1.DarkFrameInd)+1:end));% read data from first cam
        raw1Dark{ii} = mean(squeeze(raw_unregistered(:,:,ii,reader1.DarkFrameInd)),3);
        raw1Cell{ii} =  raw1Cell{ii} -  raw1Dark{ii};
        if ~isempty(reader1.InvalidInd)
            if contains(runInfo.session,'fc')
                temp = raw1Cell{ii};
                temp(:,:,reader1.InvalidInd)=[];
                raw1Cell{ii} = temp;
            elseif contains(runInfo.session,'stim')
                temp = raw1Cell{ii};
                temp(:,:,reader1.InvalidInd)=temp(:,:,(max(reader1.InvalidInd)+1));
                raw1Cell{ii} = temp;
            end
        end
            
    end
    
    load(runInfo.rawFile{2} )
    for ii = 1: size(raw_unregistered,3) 
        raw2Cell{ii} = squeeze(raw_unregistered(:,:,ii,max(reader1.DarkFrameInd)+1:end)); % read data from second cam
        raw2Dark{ii} = mean(squeeze(raw_unregistered(:,:,ii,reader2.DarkFrameInd)),3);
        raw2Cell{ii} =  raw2Cell{ii} -  raw2Dark{ii};
        
        if ~isempty(reader2.InvalidInd)
            if contains(runInfo.session,'fc')
                temp = raw2Cell{ii};
                temp(:,:,reader2.InvalidInd)=[];
                raw2Cell{ii} = temp;
            elseif contains(runInfo.session,'stim')
                temp = raw2Cell{ii};
                temp(:,:,reader2.InvalidInd)=temp(:,:,(max(reader2.InvalidInd)+1));
                raw2Cell{ii} = temp;
            end
        end
    end
    
    rawTime = linspace(0,(size(raw2Cell{1},3)-1)/runInfo.samplingRate,size(raw2Cell{1},3)); 
 
    toc(t1);
    
    disp('transform camera 2 to camera 1');
    for chInd = 1:numel(raw2Cell)
        chData = raw2Cell{chInd};
        for frameInd = 1:size(chData,3)
            warped = imwarp(chData(:,:,frameInd),maskData.transformMat,'OutputView',imref2d([size(chData,1),size(chData,2)]));
            warped = warped(1:size(chData,1),1:size(chData,2));
            chData(:,:,frameInd) = warped;
        end
        raw2Cell{chInd} = chData;
    end
    
    disp('combine camera 1 and camera 2');
    raw = cell(numCh,1);
    raw{1} = raw1Cell{1};
    raw{2} = raw2Cell{1};
    raw{3} = raw1Cell{2};
    raw{4} = raw2Cell{2};

    
    disp('process hb');
    hbLEDFiles =  runInfo.lightSourceFiles(runInfo.hbChInd);
    hbSamplingRate = runInfo.samplingRate;
    
    % get raw data for hb
    hbRaw = [];
    for chInd = runInfo.hbChInd
        hbRaw = cat(4,hbRaw,raw{chInd});
    end
    hbRaw = permute(hbRaw,[1 2 4 3]);
    
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
    hbTime = rawTime;
    isbrainHb = mouse.math.bin(isbrain,runInfo.binFactor(runInfo.hbChInd(1)));
    isbrainHb = isbrainHb > (1-10*eps)*runInfo.binFactor(runInfo.hbChInd(1));
    
    if ~isempty(runInfo.fluorChInd) % if there are fluor channels
        disp('process fluor');
        t1 = tic;
        
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
        
        [datafluorCorr, datafluor] = fluorProc.process(...
            raw{runInfo.fluorChInd},datahb,fluorSamplingRate);
        fluorTime = rawTime;
        isbrainFluor = mouse.math.bin(isbrain,runInfo.binFactor(runInfo.fluorChInd(1)));
        isbrainFluor = isbrainFluor > (1-10*eps)*runInfo.binFactor(runInfo.fluorChInd(1));
        toc(t1);
    end
    
    if ~isempty(runInfo.speckleChInd) % if there are speckle channels
        disp('process speckle')
        t1 = tic;
        
        % instantiate SpeckleProcessor - processes raw matrix to cbf data
        spProc = mouse.process.SpeckleProcessor();
        datacbf = spProc.process(raw{runInfo.speckleChInd});
        cbfTime = rawTime;
        isbrainCbf = mouse.math.bin(isbrain,runInfo.binFactor(runInfo.speckleChInd(1)));
        isbrainCbf = isbrainCbf > (1-10*eps)*runInfo.binFactor(runInfo.speckleChInd(1));
        toc(t1);
    end
    
    disp('downsample');
    t1 = tic;
    % only retain downsampled hemoglobin and cbf
    [datahbDs, hbTimeDs] = mouse.freq.resampledata(datahb,hbTime,runInfo.samplingRateHb);
    datahb = datahbDs;
    hbTime = hbTimeDs;
    if ~isempty(runInfo.fluorChInd) % if there are speckle channels
        [datafluorDs, fluorTimeDs] = mouse.freq.resampledata(datafluor,fluorTime,runInfo.samplingRateFluor);
        datafluor = datafluorDs;
        [datafluorCorrDs] = mouse.freq.resampledata(datafluorCorr,fluorTime,runInfo.samplingRateFluor);
        datafluorCorr = datafluorCorrDs;
        fluorTime = fluorTimeDs;
    end
    if ~isempty(runInfo.speckleChInd) % if there are speckle channels
        [datacbfDs, cbfTimeDs] = mouse.freq.resampledata(datacbf,cbfTime,runInfo.samplingRateCbf);
        datacbf = datacbfDs;
        cbfTime = cbfTimeDs;
    end
    toc(t1);
    
    if runInfo.affineTransform
        disp('affine transform');
        t1 = tic;
        xform_datahb = mouse.process.affineTransform(datahb,maskData.affineMarkers);
        xform_isbrainHb = mouse.process.affineTransform(isbrainHb,maskData.affineMarkers);
        if ~isempty(runInfo.fluorChInd) % if there are fluor channels
            xform_datafluor = mouse.process.affineTransform(datafluor,maskData.affineMarkers);
            xform_datafluorCorr = mouse.process.affineTransform(datafluorCorr,maskData.affineMarkers);
            xform_isbrainFluor = mouse.process.affineTransform(isbrainFluor,maskData.affineMarkers);
        end
        if ~isempty(runInfo.speckleChInd) % if there are speckle channels
            xform_datacbf = mouse.process.affineTransform(datacbf,maskData.affineMarkers);
            xform_isbrainCbf = mouse.process.affineTransform(isbrainCbf,maskData.affineMarkers);
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
    t1 = tic;
    % make directory where data is saved if the directory does not exist
    if ~exist(runInfo.saveFolder)
        mkdir(runInfo.saveFolder);
    end
    
    if runInfo.saveRaw
        warning('off','all'); readerInfo1 = struct(reader1);
        readerInfo2 = struct(reader2); warning('on','all');
        save(runInfo.saveRawFile,'runInfo','readerInfo1','readerInfo2',...
            'rawTime','raw','-v7.3');
    end
    
    % save the processed data in hemoglobin data file
    warning('off','all'); hbProcInfo = struct(hbProc); warning('on','all');
    xform_isbrain = xform_isbrainHb;
    save(runInfo.saveHbFile,'runInfo','hbProcInfo','xform_isbrain',...
        'hbTime','xform_datahb','-v7.3');
    
    if ~isempty(runInfo.fluorChInd) % if there are fluor channels
        warning('off','all'); fluorProcInfo = struct(fluorProc); warning('on','all');
        xform_isbrain = xform_isbrainFluor;
        % save the processed fluor data in fluorescence data file
        save(runInfo.saveFluorFile,'runInfo','fluorProcInfo','xform_isbrain',...
            'fluorTime','xform_datafluor','xform_datafluorCorr','-v7.3');
    end
    
    if ~isempty(runInfo.speckleChInd) % if there are fluor channels
        warning('off','all'); spProcInfo = struct(spProc); warning('on','all');
        xform_isbrain = xform_isbrainCbf;
        % save the processed fluor data in fluorescence data file
        save(runInfo.saveCbfFile,'runInfo','spProcInfo','xform_isbrain',...
            'cbfTime','xform_datacbf','-v7.3');
    end
    toc(t1);
    
    if runInfo.qc
        disp('quality control');
        t1 = tic;
        
        % raw qc
        representativeCh = runInfo.hbChInd(1);
        qcRawFig = mouse.expSpecific.qcRaw(rawTime,raw,representativeCh);
        savefig(qcRawFig,runInfo.saveRawQCFig);
        saveas(qcRawFig,[runInfo.saveRawQCFig '.png']);
        close(qcRawFig);
        
        % make data array to give into qc functions
        data = {}; mask = {}; fs = []; time = {};
        data{1} = squeeze(datahb(:,:,1,:));
        data{2} = squeeze(datahb(:,:,2,:));
        data{3} = squeeze(sum(datahb,3));
        time{1} = hbTime; time{2} = time{1}; time{3} = time{1};
        fs(1) = 1/(hbTime(2) - hbTime(1)); fs(2:3) = fs(1);
        mask{1} = xform_isbrainHb; mask{2} = mask{1}; mask{3} = mask{2};
        contrastName = {'HbO','HbR','HbT'};
        
        if ~isempty(runInfo.fluorChInd) % if there are fluor channels
            data{end+1} = squeeze(xform_datafluorCorr);
            time{end+1} = fluorTime;
            fs(end+1) = 1/(fluorTime(2) - fluorTime(1));
            mask{end+1} = mask{1};
            contrastName(end+1) = {'Fluor'};
        end
        if ~isempty(runInfo.speckleChInd) % if there are fluor channels
            data{end+1} = squeeze(xform_datacbf);
            time{end+1} = cbfTime;
            fs(end+1) = 1/(cbfTime(2) - cbfTime(1));
            mask{end+1} = xform_isbrain;
            contrastName(end+1) = {'CBF'};
        end
        
        % make qc fc fig or qc stim fig
        if contains(runInfo.session,'fc')
            fRange = [0.009 0.08];
            fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];
            fStr(strfind(fStr,'.')) = 'p';

            [fcFig,seedFC,seedFCMap,seedCenter,seedRadius,bilateralFCMap] = ...
                mouse.expSpecific.qcFC(data,mask,fs,contrastName,runInfo);
            
            saveSeedFCName = [runInfo.saveFilePrefix '-seedFC-' fStr];
            save(saveSeedFCName,'contrastName','seedCenter','seedFC','seedFCMap','seedRadius','-v7.3');
            
            saveBilateralFCName = [runInfo.saveFilePrefix '-bilateralFC-' fStr];
            save(saveBilateralFCName,'contrastName','bilateralFCMap','mask','-v7.3');
            
            for contrastInd = 1:numel(data)
                saveFCQCFigName = [runInfo.saveFCQCFig '-' contrastName{contrastInd}];
                saveas(fcFig(contrastInd),[saveFCQCFigName '.png']);
                close(fcFig(contrastInd));
            end
        end
        if contains(runInfo.session,'stim')
            data{1} = data{1}*1000; data{2} = data{2}*1000; data{3} = data{3}*1000;
            stimFig = mouse.expSpecific.qcStim(data,time,mask,...
                runInfo.stimStartTime,runInfo.stimEndTime,...
                runInfo.blockLen,runInfo.stimRoiSeed,contrastName);
            saveas(stimFig,[runInfo.saveStimQCFig '.png']);
            close(stimFig);
        end
        toc(t1);
    end
end

end

function [isbrain,affineMarkers,transformMat,WL,seedCenter] = getMask(fileName1,...
    fileName2,reader1)
%getMask Outputs mask data from raw data
%   By providing which files to read, as well as the reader object and
%   indices of red, green, and blue LEDs, we instantiate a GUI that runs
%   shows the white light image and allows user to determine the mask.

% read raw data
badDataInd = unique([reader1.DarkFrameInd reader1.InvalidInd]);
realDataStart = max(badDataInd) + 1;

load(fileName1)
firstFrame_cam1 = raw_unregistered(:,:,2,realDataStart);
load(fileName2)
firstFrame_cam2 = raw_unregistered(:,:,2,realDataStart);
[WL, transformMat] = getTransformation(firstFrame_cam1,firstFrame_cam2);

[affineMarkers,seedCenter] = mouse.process.getLandmarks(WL);
isbrain = mouse.process.getMask(WL);
end

function fileList = getFileList(folder)
%getFileList Outputs cell array listing files in temporal order for one
%camera
%   Input: char array of the folder containing the .dat files

tempdir=dir(folder);
tempdir2=tempdir(3:end-3, 1);% exclude . .. and ini modifieddata sifx
framenums=zeros(size(tempdir2, 1), 1);
for i=1:size(tempdir2, 1)
    tempframe=tempdir2(i).name(1:10);
    tempframe=str2double(fliplr(tempframe))+1; % flip num order
    framenums(i)=tempframe;
end
[~, frameidx]=sort(framenums);
tempdir2=tempdir2(frameidx);
numFile = numel(tempdir2);
fileList = cell(numFile,1);
for i = 1:numFile
    fileList{i} = fullfile(tempdir2(i).folder,tempdir2(i).name);
end
end

function [WL, mytform] = getTransformation(firstFrame_cam1,firstFrame_cam2)
nVy = size(firstFrame_cam1,1);
nVx = size(firstFrame_cam1,2);

fixed = firstFrame_cam1./max(max(firstFrame_cam1));
unregistered = firstFrame_cam2./max(max(firstFrame_cam2));
f = msgbox(['click four pairs of points',newline,'export in movingPoints and fixedPoints',newline,'close after finish selection']);
pause(0.1)
[movingPoints,fixedPoints] = cpselect(unregistered,fixed,'Wait',true);

close(f)
mytform = fitgeotrans(movingPoints, fixedPoints, 'projective');

registered = imwarp(unregistered, mytform,'OutputView',imref2d(size(unregistered)));

WL = zeros(nVy,nVx,3);
WL(:,:,1) = registered;
WL(:,:,2) = fixed;
WL(:,:,3) = fixed;
end
