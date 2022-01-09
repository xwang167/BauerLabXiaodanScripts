function [spectraAllMice,runFreq,speciesList]=examplePowerAnalysis_ISA(excelFile, rows)
% This function will generate power analysis plots for user specified data.
% A pwelch test is used to generate the power spectra.
%
% Inputs:
%   excelFile: character array containing the location of the excel file to
%   be read
%   rows: the specific rows in the excel file that should be processed
%   fRange: bands over which to compute the power maps (specified by the
%   user via a input menu)

%% acquire user inputs

fRange = [0.009 0.08];
% store freq range as string for naming output file
fStr = {};
[elements, ~] = size(fRange);
for ind=1:elements
    currRange = [num2str(fRange(ind,1)) '-' num2str(fRange(ind,2))];
    currRange(strfind(currRange,'.')) = 'p';
    fStr = [fStr; currRange];
end

% parse the runs listed in excel file
runsInfo = parseTiffRuns(excelFile,rows);
if isempty(runsInfo)
    runsInfo = parseDatRuns(excelFile,rows);
end

%% preprocess

% read in data
paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'noVasculatureMask.mat'));
meanMask = stdMask.leftMask | stdMask.rightMask;

runInd = 0;
runNum = numel(runsInfo);
disp([num2str(runNum) ' run(s) detected.']);
currentExcelRow = runsInfo(1).excelRow;

freqMouse = {};
spectraMouse = {};
meanSpectraMouse = {};
freqAllMice = {};
spectraAllMice = {};
meanSpectraAllMice = {};
runInfoAllMice = {};

%% process each run
for runInfo = runsInfo
    runInd = runInd + 1;
    disp(['----- Trial ' num2str(runInd) '/' num2str(runNum) ' -----']);
    
    % initialize variable names for save files
    currentTrialName = [runInfo.recDate, '-', runInfo.mouseName, '-', runInfo.session,...
        num2str(runInfo.run)];
    mouseRunInfo = [runInfo.recDate, '-', runInfo.mouseName, '-', runInfo.session];
    savePowerInfo = [runInfo.saveFolder, '\PowerAnalysis'];
    if ~exist(savePowerInfo, 'dir')
        mkdir(savePowerInfo)
    end
    saveFilePowerData = [savePowerInfo, '\', currentTrialName, '-powerData.mat'];

    % check to see if data already exists
    if exist(saveFilePowerData, 'file')
        disp('Loading saved power analysis data...');
        tic; % how long it takes to load data
        load(saveFilePowerData, 'mouseRunInfo','speciesList','runFreq','runSpectra',...
            'runMeanSpectra', 'sessionType');
        toc % how long it takes to load data
    else
        fileDataHb = runInfo.saveHbFile;
        fileDataFluor = runInfo.saveFluorFile;
        % insert other species here
        
        disp('Loading data...');
        tic; % measure time it takes to load data
        
        loadDataHb = load(fileDataHb);
        loadDataFluor = load(fileDataFluor);
        
        %store HB and Fluor data along with brain mask
        dataHb = loadDataHb.xform_datahb;
        dataFluorCorr = loadDataFluor.xform_datafluorCorr;
        mask = loadDataHb.xform_isbrain;
        fs = runInfo.samplingRate;
        
        %seperate into O, R, T
        dataO = squeeze(dataHb(:,:,1,:));
        dataR = squeeze(dataHb(:,:,2,:));
        dataT = squeeze(sum(loadDataHb.xform_datahb,3));
        data = {dataO, dataR, dataT, dataFluorCorr};
        
        toc% measure time it takes to load data
        
        speciesList = ["HbO", "HbR", "HbT", "FluorCorr"]; % don't hard code this
        
        % process the various species and get their spectra
        disp(['Computing power spectra for ' num2str(length(speciesList)) ' species...'])
        runFreq = {};
        runSpectra = {};
        runMeanSpectra = {};
               
        tic; % measure time it takes to process
        for ind=1:length(speciesList)            
            speciesData = data{ind};
            speciesDataReshaped = reshape(speciesData,[],size(speciesData,3)); % pix by time
            [spectra,freq] = pwelch(speciesDataReshaped',[],[],[],fs);
            spectra = spectra';
            spectra = reshape(spectra,size(speciesData,1),size(speciesData,2),[]);
            runFreq = [runFreq, freq];
            runSpectra = [runSpectra, spectra];
                       
            %log before taking mean (to normalize)
            spectraLog = log(spectra);
            spectraLogVector = reshape(spectraLog,16384,[]);
            maskVector = reshape(mask,numel(mask),1);
            %apply the mask to spectra
            spectraLogMask = spectraLogVector(maskVector,:);
            %take mean of first dimension
            meanSpectraLog = mean(spectraLogMask,1);
            meanSpectra = exp(meanSpectraLog);
            runMeanSpectra = [runMeanSpectra, meanSpectra];            
        end
        toc% measure time it takes to process
        
        % perhaps make this it's own script
        disp('Plotting figures and saving results/data...')
        
        tic; % time it takes to plot and save
        [spectraFigure, mapFigure] = plotPower(fRange,runFreq,runSpectra,runMeanSpectra,...
            meanMask,speciesList,currentTrialName);
 
        % save figures/data
        saveSpectraFig = [savePowerInfo '\' currentTrialName '-powerSpectra'];
        saveas(spectraFigure, [saveSpectraFig '.png']);
        close(spectraFigure);
        
        for saveInd = 1:numel(mapFigure)
            saveMapFigure = [savePowerInfo '\' currentTrialName '-powerMap-' fStr{saveInd}];
            saveas(mapFigure(saveInd), [saveMapFigure '.png']);
            close(mapFigure(saveInd));
        end
        
        % save data from current run
        sessionType = runInfo.session;
        save(saveFilePowerData, 'mouseRunInfo','speciesList','runFreq','runSpectra',...
            'runMeanSpectra','sessionType','-v7.3');
        toc % % time it takes to plot and save
        
    end
 
%% Average all of the runs for each mouse

    % as long as we're in the same excel row and we haven't reached the end
    % of the runs, store the freq and spectra into respective matrices  
    if runInd == numel(runsInfo)
        lastRunInMouse = true;
    elseif currentExcelRow ~= runsInfo(runInd+1).excelRow
        lastRunInMouse = true;
    else
        lastRunInMouse = false;
    end
    
    if lastRunInMouse
        % add last data to mouse vectors
        freqMouse = [freqMouse; runFreq];
        spectraMouse = [spectraMouse; runSpectra];
        meanSpectraMouse = [meanSpectraMouse; runMeanSpectra];
        
        disp(['----- Average computations for ' mouseRunInfo ' -----']);
        spectraMouseAvg = {};  
        meanSpectraMouseAvg = {};
        storeSpectraLogSum = 0;
        storeMeanSpectraLogSum = 0;
        [numRuns, numSpecies] = size(freqMouse);

            %sum and average the spectra for each of the species
            tic; % how long it takes to compute and plot avg power
            disp('Computing and plotting average power...');
            for ind=1:numSpecies
                for ind2=1:numRuns
                    % take log before summing and computing avg
                    storeSpectraLogSum = storeSpectraLogSum + log(spectraMouse{ind2, ind});
                    % also average meanSpectraMouse
                    storeMeanSpectraLogSum = storeMeanSpectraLogSum +...
                        log(meanSpectraMouse{ind2, ind});
                end
                spectraLogAvg = storeSpectraLogSum/numRuns;
                meanSpectraLogAvg = storeMeanSpectraLogSum/numRuns;
                % convert back from log
                spectraMouseAvg = [spectraMouseAvg exp(spectraLogAvg)];
                meanSpectraMouseAvg = [meanSpectraMouseAvg exp(meanSpectraLogAvg)];
                storeSpectraLogSum = 0;
                storeMeanSpectraLogSum = 0;
            end

            % plot mouse average figures
            currentTrialName = [mouseRunInfo '-avg'];
            freqMouseAvg = freqMouse(1,:);
            [mouseAvgSpectraFig, mouseAvgMapFigure] = plotPower(fRange,freqMouseAvg,...
                spectraMouseAvg,meanSpectraMouseAvg,meanMask,speciesList,currentTrialName);
            toc % how long it takes to compute and plot avg power
            
            % save figures/data
            tic; % how long it takes to save average plots/data
            disp('Saving average power plots and data...');
            saveAvgSpectraFig = [savePowerInfo '\' mouseRunInfo '-powerSpectraAVG'];
            saveas(mouseAvgSpectraFig, [saveAvgSpectraFig '.png']);
            close(mouseAvgSpectraFig);

            for saveInd = 1:numel(mouseAvgMapFigure)
                saveAvgMapFigure = [savePowerInfo '\' mouseRunInfo '-powerMapAVG-' fStr{saveInd}];
                saveas(mouseAvgMapFigure(saveInd), [saveAvgMapFigure '.png']);
                close(mouseAvgMapFigure(saveInd));
            end
            
            freqAllMice = [freqAllMice; freqMouseAvg];
            spectraAllMice = [spectraAllMice; spectraMouseAvg];
            meanSpectraAllMice = [meanSpectraAllMice; meanSpectraMouseAvg];
            runInfoAllMice = [runInfoAllMice; mouseRunInfo];
            
            % clear variables before next run
            freqMouse = {};
            spectraMouse = {};
            meanSpectraMouse = {};
            
            if runInd ~= numel(runsInfo)
                currentExcelRow = runsInfo(runInd+1).excelRow;
            end
            toc % how long it takes to save average plots/data
             
    else
        freqMouse = [freqMouse; runFreq];
        spectraMouse = [spectraMouse; runSpectra];
        meanSpectraMouse = [meanSpectraMouse; runMeanSpectra];
    end                
end

%% Average across mice

% compute and plot averages across mice if more than one mouse is present
[numMice, numSpecies] = size(spectraAllMice);

if numMice > 1
    storeSpectraLogSum = 0;
    storeMeanSpectraLogSum = 0;
    spectraAllMiceAvg = {};
    meanSpectraAllMiceAvg = {};

    disp(['----- Average computations across ' num2str(numMice) ' unique mice -----']);
    tic; % how long it takes to compute and plot avg power across mice
    disp('Computing and plotting average power...');
    for ind=1:numSpecies
        for ind2=1:numMice
            % take log before summing and computing avg
            storeSpectraLogSum = storeSpectraLogSum + log(spectraAllMice{ind2, ind});
            storeMeanSpectraLogSum = storeMeanSpectraLogSum + log(meanSpectraAllMice{ind2, ind});
        end
        spectraLogAvg = storeSpectraLogSum/numMice;
        meanSpectraLogAvg = storeMeanSpectraLogSum/numMice;
        % convert back from log
        spectraAllMiceAvg = [spectraAllMiceAvg exp(spectraLogAvg)]; 
        meanSpectraAllMiceAvg = [meanSpectraAllMiceAvg exp(meanSpectraLogAvg)];
        storeSpectraLogSum = 0;
        storeMeanSpectraLogSum = 0;
    end

    % plot mouse average figures
    [~,excelName] = fileparts(excelFile);
    currentTrialName = [excelName '-rows' num2str(min(rows)) '~' num2str(max(rows))];
    freqAllMouseAvg = freqAllMice(1,:);
    [mouseAvgSpectraFig, mouseAvgMapFigure] = plotPower(fRange,freqAllMouseAvg,...
        spectraAllMiceAvg,meanSpectraAllMiceAvg,meanMask,speciesList,currentTrialName);
    toc % how long it takes to compute and plot avg power

    % save figures/data
    tic; % how long it takes to save average plots/data
    disp('Saving average power figures...');

    saveAcrossMousePowerInfo = [savePowerInfo '\AvgAcrossMice'];
    if ~exist(saveAcrossMousePowerInfo, 'dir')
            mkdir(saveAcrossMousePowerInfo)
    end

    saveAvgSpectraFig = [saveAcrossMousePowerInfo '\' currentTrialName '-powerSpectraAVG'];
    savefig(mouseAvgSpectraFig, saveAvgSpectraFig);
    saveas(mouseAvgSpectraFig, [saveAvgSpectraFig '.png']);
    close(mouseAvgSpectraFig);

    for saveInd = 1:numel(mouseAvgMapFigure)
        saveAvgMapFigure = [saveAcrossMousePowerInfo '\' currentTrialName '-powerMapAVG-'...
            fStr{saveInd}];
        savefig(mouseAvgMapFigure(saveInd), saveAvgMapFigure);
        saveas(mouseAvgMapFigure(saveInd), [saveAvgMapFigure '.png']);
        close(mouseAvgMapFigure(saveInd));
    end

    toc % how long it takes to save average plots/data
end

end