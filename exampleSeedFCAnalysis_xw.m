function exampleSeedFCAnalysis_xw(excelFile,rows,varargin)
% this function gives an example of how processed data is analyzed. Here we
% will show seed-based functional connectivity analysis.
% The excel file uses the format Annie uses, which has one mouse data per
% row and minimal amount of information about sampling rate and other
% parameters. Thus, some of these parameters are assumed and hardcoded
% here.
%
% Inputs:
%   excelFile = character array of the excel file to be read
%   rows = which rows in the excel file should be read and processed?
%   fRange (optional) = frequency range to be considered for fc

if numel(varargin) > 0
    fRange = varargin{1};
else
    fRange = [0.009 0.08];
end
fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];
fStr(strfind(fStr,'.')) = 'p';

runsInfo = parseTiffRuns(excelFile,rows);
if isempty(runsInfo)
    runsInfo = parseDatRuns(excelFile,rows);
end

%% preprocess and process

% get seeds
disp('get seeds');
paramPath = what('bauerParams');
seedsData = load(fullfile(paramPath.path,'seeds16.mat'));
seedNames = seedsData.seedNames;
seedNum = size(seedsData.seedCenter,1);
stdMask = load(fullfile(paramPath.path,'stdMask.mat'));

% get seed FC each run
seedFCMapCat = {};
seedFCMapMouse = {};
seedFCCat = [];
seedFCMouse = [];
runInd = 0;
runNum = numel(runsInfo);
currentExcelRow = runsInfo(1).excelRow;
for runInfo = runsInfo(2) % for each run
    runInd = 2;
    disp(['Trial # ' num2str(runInd) '/' num2str(runNum)]);
    
    saveFileSeedFC = [runInfo.saveFilePrefix,'-seedFC-',fStr,'.mat'];
    
    if exist(saveFileSeedFC)
        disp('loading premade seed fc data.');
        load(saveFileSeedFC);
    else
        fileDataHb = runInfo.saveHbFile;
        fileDataFluor = runInfo.saveFluorFile;
        fileDataCBF = runInfo.saveCbfFile;
        
        disp('loading data');
        data = {}; mask = {}; fs = [];
        hbData = load(fileDataHb);
        data{1} = squeeze(hbData.xform_datahb(:,:,1,:));
        data{2} = squeeze(hbData.xform_datahb(:,:,2,:));
        data{3} = squeeze(sum(hbData.xform_datahb,3));
        fs(1) = 1/(hbData.hbTime(2) - hbData.hbTime(1)); fs(2:3) = fs(1);
        mask{1} = hbData.xform_isbrain; mask{2} = mask{1}; mask{3} = mask{2};
        contrastName = {'HbO','HbR','HbT'};
        
        if ~isempty(runInfo.fluorChInd) % if there are fluor channels
            fluorData = load(fileDataFluor);
            data{end+1} = squeeze(fluorData.xform_datafluorCorr);
            fs(end+1) = 1/(fluorData.fluorTime(2) - fluorData.fluorTime(1));
            mask{end+1} = mask{1};
            contrastName(end+1) = {'Fluor'};
        end
        if ~isempty(runInfo.speckleChInd) % if there are fluor channels
            cbfData = load(fileDataCBF);
            data{end+1} = squeeze(cbfData.xform_cbf);
            fs(end+1) = 1/(cbfData.cbfTime(2) - cbfData.cbfTime(1));
            mask{end+1} = cbfData.xform_isbrain;
            contrastName(end+1) = {'CBF'};
        end
        
        % calculate seed fc and make figures
        [fh, seedCenter, seedRadius, seedFCMap, seedFC] = runSeedFC(data,mask,fs,runInfo,contrastName,fRange);
        
        % save each figure
        for contrastInd = 1:numel(data)
            saveFigSeedFC = [runInfo.saveFilePrefix,'-seedFC-',fStr,'-',contrastName{contrastInd}];
            saveas(fh(contrastInd),[saveFigSeedFC '.png']);
            close(fh(contrastInd));
        end
        
        % save seed fc data
        saveFileSeedFC = [runInfo.saveFilePrefix,'-seedFC-',fStr,'.mat'];
        save(saveFileSeedFC,'contrastName','seedCenter','seedRadius','seedFCMap','seedFC','-v7.3');
        
    end
    
    if currentExcelRow == runInfo.excelRow
        % concatenate this run's seed fc data
        seedFC = atanh(seedFC);
        for contrast = 1:numel(seedFCMap)
            seedFCMap{contrast} = atanh(seedFCMap{contrast});
            if numel(seedFCMapMouse) < contrast
                seedFCMapMouse{contrast} = [];
            end
            seedFCMapMouse{contrast} = cat(4,seedFCMapMouse{contrast},seedFCMap{contrast});
        end
        seedFCMouse = cat(4,seedFCMouse,seedFC);
    end
    if currentExcelRow ~= runInfo.excelRow || runInd == numel(runsInfo)
        % concatenate this mouse's seed fc data
        for contrast = 1:numel(seedFCMap)
            if numel(seedFCMapCat) < contrast
                seedFCMapCat{contrast} = [];
            end
            seedFCMapCat{contrast} = cat(4,seedFCMapCat{contrast},nanmean(seedFCMapMouse{contrast},4));
            seedFCMapMouse{contrast} = [];
        end
        seedFCCat = cat(4,seedFCCat,nanmean(seedFCMouse,4));
        currentExcelRow = runInfo.excelRow;
    end
end

% get the average across runs
for contrast = 1:numel(seedFCMapCat)
    seedFCMapCat{contrast} = nanmean(seedFCMapCat{contrast},4);
    seedFCMapCat{contrast} = tanh(seedFCMapCat{contrast});
    seedFCMapCat{contrast}(isnan(seedFCMapCat{contrast})) = 0;
    seedFCMapCat{contrast}(isinf(seedFCMapCat{contrast})) = 0;
end
seedFCCat = nanmean(seedFCCat,4);
seedFCCat = tanh(seedFCCat);
seedFCCat(isnan(seedFCCat)) = 0;
seedFCCat(isnan(seedFCCat)) = 0;

% plot
disp('plot')
saveFolder = fileparts(runsInfo(1).saveFolder);
[~,excelName] = fileparts(excelFile);
saveFigNamePrefix = fullfile(saveFolder,strcat(excelName, '-seedFC-rows', ...
    num2str(min(rows)), '~', num2str(max(rows)), '-', fStr));

for contrast = 1:numel(seedFCMapCat)
    % get the data
    speciesMat = seedFCMapCat{contrast};
    
    % get the mask
    cMask = stdMask.isbrain;
    cMask = repmat(cMask,size(speciesMat,1)/size(cMask,1));
    
    % plot seed fc
    f1 = mouse.expSpecific.plotSeedFC([],[],speciesMat,seedFCCat(:,:,contrast),seedCenter{contrast},...
        seedRadius(contrast),seedNames,cMask);
    
    % add the title
    titleAxesHandle=axes('position',[0 0 1 0.95]);
    t = title(titleAxesHandle,[contrastName{contrast} ' FC ' fStr 'Hz']);
    set(titleAxesHandle,'visible','off');
    set(t,'visible','on');
    pause(0.1);
    
    % save fig
    saveFigName = strcat(saveFigNamePrefix, '-', contrastName{contrast});
    savefig(f1,saveFigName);
    saveas(f1,strcat(saveFigName, '.png'));
    close(f1);
end

save(strcat(saveFigNamePrefix,'.mat'),'seedFCCat','seedFCMapCat')

end