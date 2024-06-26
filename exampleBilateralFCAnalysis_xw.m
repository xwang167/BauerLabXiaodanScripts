function exampleBilateralFCAnalysis_xw(excelFile,rows,fRange,cMask_all)
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

fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];
fStr(strfind(fStr,'.')) = 'p';

runsInfo = parseTiffRuns(excelFile,rows);
if isempty(runsInfo)
    runsInfo = parseDatRuns(excelFile,rows);
end

%% preprocess and process

% get standard mask
paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'stdMask.mat'));
cMask_all = cMask_all.*stdMask.isbrain;

% get seed FC each run
bilatFCMapCat = {};
bilatFCMapMouse = {};
bilateralFCMap = {};
runInd = 0; 
runNum = numel(runsInfo);
currentExcelRow = runsInfo(1).excelRow;
for runInfo = runsInfo % for each run
    runInd = runInd + 1;
    disp(['Trial # ' num2str(runInd) '/' num2str(runNum)]);
    
    saveFileSeedFC = [runInfo.saveFilePrefix,'-bilateralFC-',fStr,'.mat'];
    
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
        
        % save each figure
        for contrastInd = 1:numel(data)
            cData = data{contrastInd};
            cMask = mask{contrastInd};
            cFs = fs(contrastInd);
            cName = contrastName{contrastInd};
            
            % prepare data
            cData = mouse.process.gsr(cData,cMask); % gsr
            cData = mouse.freq.filterData(cData,fRange(1),fRange(2),cFs);
            
            % get bilateral fc
            bilateralFCMap{contrastInd} = mouse.conn.bilateralFC(cData);
            
            % plot
            fh(contrastInd) = mouse.expSpecific.plotFCMap([],[],...
                bilateralFCMap{contrastInd},cMaskMirrored);
            
            % plot title
            titleAxesHandle=axes('position',[0 0 1 0.9]);
            t = title(titleAxesHandle,[cName ' FC, ' fStr 'Hz']);
            set(titleAxesHandle,'visible','off');
            set(t,'visible','on');
            pause(0.1);
            
            saveFigSeedFC = [runInfo.saveFilePrefix,'-bilateralFC-',fStr,'-',cName];
            saveas(fh(contrastInd),[saveFigSeedFC '.png']);
            close(fh(contrastInd));
        end
        
        % save seed fc data
        saveFileSeedFC = [runInfo.saveFilePrefix,'-bilateralFC-',fStr,'.mat'];
        save(saveFileSeedFC,'contrastName','bilateralFCMap','mask','-v7.3');
        
    end
    
    if currentExcelRow == runInfo.excelRow
        % concatenate this run's seed fc data
        for contrast = 1:numel(bilateralFCMap)
            bilateralFCMap{contrast} = atanh(bilateralFCMap{contrast});
            if numel(bilatFCMapMouse) < contrast
                bilatFCMapMouse{contrast} = [];
            end
            bilatFCMapMouse{contrast} = cat(3,bilatFCMapMouse{contrast},bilateralFCMap{contrast});
        end
    end
    if currentExcelRow ~= runInfo.excelRow || runInd == numel(runsInfo)
        % concatenate this mouse's seed fc data
        for contrast = 1:numel(bilateralFCMap)
            if numel(bilatFCMapCat) < contrast
                bilatFCMapCat{contrast} = [];
            end
            bilatFCMapCat{contrast} = cat(3,bilatFCMapCat{contrast},nanmean(bilatFCMapMouse{contrast},3));
            bilatFCMapMouse{contrast} = [];
        end
        currentExcelRow = runInfo.excelRow;
    end
end

% get the average across runs
for contrast = 1:numel(bilatFCMapCat)
    bilatFCMapCat{contrast} = nanmean(bilatFCMapCat{contrast},3);
    bilatFCMapCat{contrast} = tanh(bilatFCMapCat{contrast});
    bilatFCMapCat{contrast}(isnan(bilatFCMapCat{contrast})) = 0;
    bilatFCMapCat{contrast}(isinf(bilatFCMapCat{contrast})) = 0;
end

% plot
disp('plot')
saveFolder = fileparts(runsInfo(1).saveFolder);
[~,excelName] = fileparts(excelFile);
saveFigNamePrefix = fullfile(saveFolder,[excelName '-bilateralFC-rows' ...
    num2str(min(rows)) '~' num2str(max(rows)) '-' fStr]);

for contrast = 1:numel(bilatFCMapCat)
    % get the data
    speciesMat = bilatFCMapCat{contrast};
    
    % get the mask
    mask = zeros(128,128);
    mask(1:128,1:63) = 1;
    cMask = stdMask.isbrain.*cMask_all.*mask;
    cMask = repmat(cMask,size(speciesMat,1)/size(cMask,1));
    
    % plot
    f1 = plotFCMap_xw([],[],...
        speciesMat,cMask);
    
    % plot title
    titleAxesHandle=axes('position',[0 0 1 0.9]);
    t = title(titleAxesHandle,[contrastName{contrast} ' FC, ' fStr 'Hz']);
    set(titleAxesHandle,'visible','off');
    set(t,'visible','on');
    pause(0.1);
    
    % save fig
    saveFigName = [saveFigNamePrefix '-' contrastName{contrast}];
    savefig(f1,saveFigName);
    saveas(f1,[saveFigName '.png']);
    close(f1);
end
save(strcat(saveFigNamePrefix,'.mat'),'bilatFCMapCat')
end