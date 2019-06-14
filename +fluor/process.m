function [dataHb,dataFluor,dataFluorCorr] = process(data,systemInfo,sessionInfo,mask)
%process Processes preprocessed data to hemoglobin as well as fluorescence
%data

pkgDir = what('bauerParams');
ledDir = string(fullfile(pkgDir.path,'ledSpectra'));
extCoeffDir = string(pkgDir.path);
probeDir = string(fullfile(pkgDir.path,'probeSpectra'));

extCoeffPath = fullfile(extCoeffDir,sessionInfo.extCoeffFile);

pathIn = systemInfo.pathIn;
pathOut = systemInfo.pathOut;

%% get hemoglobin data

hbSpecies = sessionInfo.hbSpecies;

for ind = 1:numel(systemInfo.LEDFiles)
    systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
end

[dataHb, ~, ~]= ...
    mouse.preprocess.procOIS(data(:,:,hbSpecies,:),...
    systemInfo.LEDFiles(hbSpecies),mask);
% datahb is in unit of mole/L

%% get fluor data

fluorSpecies = sessionInfo.probeSpecies;

dataFluor = data(:,:,fluorSpecies,:);
dataFluor = fluor.procFluor(dataFluor); % detrending occurs

%% get corrected fluor data

dataFluorCorr = zeros(size(dataFluor));
for fluorInd = 1:numel(fluorSpecies)
    % get led spectra
    
%         [lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(extCoeffPath);
%         blueLambdaInd = find(lambda == 454);
%         greenLambdaInd = find(lambda == 512);
%     
%         hbOExtCoeff = extCoeff([blueLambdaInd greenLambdaInd],1);
%         hbRExtCoeff = extCoeff([blueLambdaInd greenLambdaInd],2);
%     
%             dataFluorCorr(:,:,fluorInd,:) = mouse.physics.correctHb(dataFluor,dataHb,...
%             hbOExtCoeff,hbRExtCoeff,pathIn(fluorInd),pathOut(fluorInd));
    
    % current problem: dpf factors calculated are quite a bit off from the
    % values that work. We currently use value of 0.056 cm, but the values
    % from getHbOpticalProperties is 0.19 cm, leading to overcorrection.
    
    inputSpectraFile = systemInfo.LEDFiles(fluorSpecies(fluorInd));
    probeEmissionFile = fullfile(probeDir,sessionInfo.probeEmissionFile(fluorInd));
    [opIn, absCoeffIn] = bauerParams.getHbOpticalProperties(inputSpectraFile,extCoeffPath);
    [opOut, absCoeffOut] = bauerParams.getHbOpticalProperties(probeEmissionFile,extCoeffPath);
    
    dataFluorCorr(:,:,fluorInd,:) = mouse.physics.correctHb(dataFluor,dataHb,...
        [absCoeffIn(1) absCoeffOut(1)],[absCoeffIn(2) absCoeffOut(2)],pathIn(fluorInd),pathOut(fluorInd));
%         dataFluorCorr(:,:,fluorInd,:) = mouse.physics.correctHb(dataFluor,dataHb,...
%             [absCoeffIn(1) absCoeffOut(1)],[absCoeffIn(2) absCoeffOut(2)],opIn.dpf,opOut.dpf);
end
end

