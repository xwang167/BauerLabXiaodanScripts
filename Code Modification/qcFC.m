function [fh, seedFC, seedFCMap,seedCenter,seedRadius,bilatFCMap] = qcFC(data,mask,samplingRate,contrastName,runInfo,varargin)
%qcRawFig Generates figure with quality control for raw data
% Inputs:
%   data = cell array of data
%   mask = cell array of brain mask (Boolean)
%   samplingRate = array of sampling rate
%   contrastName = cell array of name of each contrast ex: 'HbT'
%   runInfo
%   fRange (optional) = frequency range (default = 0.009 ~ 0.08 Hz)
% Outputs:
%   fcFig = figure handle for fc figure
%   seedFC = seeds by seeds matrix
%   seedFCMap = y by x by seeds matrix showing fc maps for each seed
%   seedCenter = n by 2 matrix showing coordinates of seed centers
%   seedRadius

if numel(varargin) > 0
    fRange = varargin{1};
else
    fRange = [0.009 0.08];
end

fStr = [num2str(fRange(1)) '-' num2str(fRange(2))];

% get seed data
paramPath = what('bauerParams');
seedsData = load(fullfile(paramPath.path,'seeds16.mat'));
seedNames = seedsData.seedNames;
seedNum = size(seedsData.seedCenter,1);

seedFC = nan(seedNum,seedNum,size(data,4));
seedFCMap= nan(size(data,1), size(data,2),seedNum,size(data,4) );
bilatFCMap=nan(size(data,1), size(data,2),size(data,4) );


% run for each contrast

for contrast = 1:size(data,4)
    cData = squeeze(data(:,:,:,contrast));
%     cMask = mask;
%     cFs = samplingRate;
    cName = contrastName{contrast};
    
    ySize = size(cData,1);
    xSize = size(cData,2);
    
%Get seeds
    numPixY = size(cData,1); % number of pixels in y axis
    numPixX = size(cData,2);
    sizeY = runInfo.window(2)-runInfo.window(1); % size in mm in y axis
    sizeX = runInfo.window(4)-runInfo.window(3);
    seedCenter = seedsData.seedCenter;
    seedCenter(:,1) = (seedCenter(:,1) - runInfo.window(1))./sizeY; % get normalized coordinate
    seedCenter(:,2) = (seedCenter(:,2) - runInfo.window(3))./sizeX;
    seedCenter(:,1) = round(seedCenter(:,1).*numPixY); % convert to pixel coordinate
    seedCenter(:,2) = round(seedCenter(:,2).*numPixX);
    
    seedRadius = 0.25; % in mm
    seedRadius = round(seedRadius/sizeY*numPixY);
    
%Get seed maps
    seedMap = false(numPixY,numPixX,seedNum);
    for seedInd = 1:seedNum
        seedCoor = circleCoor(seedCenter(seedInd,:),seedRadius);
        seedCoor = matCoor2Ind(seedCoor,[numPixY numPixX]);
        seedBool = false(numPixY,numPixX); seedBool(seedCoor) = true;
        seedMap(:,:,seedInd) = seedBool;
    end
        
    % get seed fc
    for seedInd = 1:seedNum
        seedFCMap(:,:,seedInd,contrast) = seedFCMap_fun(cData,seedMap(:,:,seedInd));
    end
    %fc matrix
    seedFC(:,:,contrast) = seedFC_fun(cData,seedMap);
    
    % get bilateral fc
    bilatFCMap(:,:,contrast) = bilateralFC_fun(cData);

    
%plot
    fh(contrast) = figure('Position',[100 100 1200 500]);
    %seedMap and Matrix
    seedFCPos = [0.02 0.05 0.6 0.85];
        fh(contrast) = plotSeedFC(fh(contrast),seedFCPos,...
        seedFCMap(:,:,:,contrast),seedFC(:,:,contrast),...
        seedCenter, seedMap, seedRadius,seedNames,mask);
    %Bilat    
    bilatFCPos = [0.62 0.05 0.36 0.85];
    MaskMirrored = mask & fliplr(mask);
        fh(contrast) = plotFCMap(fh(contrast),bilatFCPos,...
        bilatFCMap(:,:,contrast),MaskMirrored);
    
    % plot title
    titleAxesHandle=axes('position',[0 0 1 0.95]);
    currentMouse = [runInfo.recDate, '-', runInfo.mouseName, '-', runInfo.session, char(string(runInfo.run))];
    t = title(titleAxesHandle,[currentMouse ', ' contrastName{contrast} ' FC, ' fStr 'Hz']);
    set(titleAxesHandle,'visible','off');
    set(t,'visible','on');
end
end
