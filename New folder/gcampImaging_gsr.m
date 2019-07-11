function [raw, time, xform_hb, xform_gcamp, xform_gcampCorr, isbrain, xform_isbrain, markers] ...
    = gcampImaging(tiffFileName, systemInfo, sessionInfo, varargin)
%gcampImaging Processes tiff file to output hemoglobin data, gcamp, and
%corrected gcamp data
%   Input:
%       tiffFileName = tiff file name. A string array. Should include the
%       directory as well. If multiple string is given, then the function
%       assumes that second file is a continuation of first file.
%       systemInfo = information about the imaging system used, such as
%       which channels are rgb, and which LED files to use
%       sessionInfo = information about the session, including sampling
%       rate of data and lowpass highpass filtering options.
%       mask (optional) = brain mask, logical array. If mask isn't given, then a GUI
%       opens that user interacts with to make the mask. (needs to be
%       provided with markers)
%       markers (optional) = brain markers (needs to be provided with
%       isbrain)
%       ledDir (parameter) = directory of where the led spectrum text files are
%       extCoeffDir (parameter) = directory of where hb extinction coefficients are 
%   Output:
%       xform_hb
%       xform_gcamp
%       xform_gcampCorr
%       isbrain
%       xform_isbrain
%       markers
%   Example:
%       [raw, time, xform_hb, xform_gcamp, xform_gcampCorr, isbrain, xform_isbrain, markers] ...
%           = gcampImaging(tiffFileName, systemInfo, sessionInfo, 'ledDir', "C:\Repositories\GitHub\BauerLab\MATLAB\parameters\+bauerParams\ledSpectra")

if ~isstring(tiffFileName)
    error('Input tiff file names have to be string array');
end

p = inputParser;
pkgDir = what('bauerParams');
addParameter(p,'ledDir',string(fullfile(pkgDir.path,'ledSpectra')),@isstring);
addParameter(p,'extCoeffDir',string(pkgDir.path),@isstring);
addOptional(p,'mask',[],@islogical);
addOptional(p,'markers',[],@isstruct);
parse(p,varargin{:});

if isempty(p.Results.mask)
    getMask = true;
else
    getMask = false;
    isbrain = p.Results.mask;
    markers = p.Results.markers;
end

ledDir = p.Results.ledDir;
extCoeffDir = p.Results.extCoeffDir;

% gcamp specific parameters
speciesNum = systemInfo.numLEDs;
hbSpecies = 2:4; % which LED channels are for hemoglobin?
gcampSpecies = 1; % which LED channels are for gcamp?
blueWavelength = 458; % nm
greenWavelength = 512; % nm
bluePath = 5.6E-4; % m
greenPath = 5.7E-4; % m

bandpassFluor = true;

extCoeffFile = fullfile(extCoeffDir,"prahl_extinct_coef.txt");

%% load tif file and convert it to mat file

disp('load tif file');

freqIn = sessionInfo.framerate; % sampling rate
freqOut = sessionInfo.freqout;

if freqOut == freqIn
    raw = mouse.preprocess.loadTiffRawMultiple(tiffFileName,speciesNum);
    time = 0:size(raw,4) - 1;
    time = time./freqIn;
    
else
    disp(['  downsample from ' num2str(freqIn) ' Hz to ' num2str(freqOut) ' Hz']);
    
    [time,raw] = mouse.preprocess.loadTiffResample(tiffFileName,speciesNum,freqIn,freqOut);
end

fs = freqOut;

% get rid of first frame since it is usually nonsensical
raw(:,:,:,1) = [];
time(1) = [];

%% make mask

if getMask % only if the mask has to be gotten
    rgbInd = systemInfo.rgb;
    WL = squeeze(raw(:,:,rgbInd,1)); % makes nxnx3 array for white light image
    
    % get landmarks and save mask file
    [isbrain, markers] = mouse.expSpecific.getLandMarksandMask(WL);
end

%% process raw

raw = gcamp.procRaw(raw);

%% get hemoglobin data

disp('get hemoglobin data');

for ind = 1:numel(systemInfo.LEDFiles)
    systemInfo.LEDFiles(ind) = fullfile(ledDir,systemInfo.LEDFiles(ind));
end

highpassFreq = sessionInfo.highpass;
lowpassFreq = sessionInfo.lowpass;
bandpassFreq = [highpassFreq lowpassFreq];

[hbData, ~, ~]= ...
    mouse.preprocess.procOIS(raw(:,:,hbSpecies,:), fs, bandpassFreq, ...
    systemInfo.LEDFiles(hbSpecies), extCoeffFile, isbrain);
% hbData is in unit of mole/L

xform_hb = mouse.expSpecific.transformHb(hbData, markers);

%% get gcamp data

disp('get gcamp data');

gcampData = raw(:,:,gcampSpecies,:);
gcampData = mouse.expSpecific.procFluor(gcampData,fs,bandpassFreq,bandpassFluor); % detrending occurs

xform_gcamp = mouse.expSpecific.transformHb(gcampData, markers);

%% correct gcamp for hemoglobin

[lambda, extCoeff] = mouse.expSpecific.getHbExtCoeff(extCoeffFile);

blueLambdaInd = find(lambda == blueWavelength);
greenLambdaInd = find(lambda == greenWavelength);

hbOAbsCoeff = extCoeff([blueLambdaInd greenLambdaInd],1);
hbRAbsCoeff = extCoeff([blueLambdaInd greenLambdaInd],2);

xform_gcampCorr = mouse.physics.correctHb(xform_gcamp,xform_hb,...
    hbOAbsCoeff,hbRAbsCoeff,bluePath,greenPath);

xform_isbrain = mouse.expSpecific.transformHb(isbrain, markers);


%% gsr

xform_hb = mouse.preprocess.gsr(xform_hb,xform_isbrain);
xform_gcamp = mouse.preprocess.gsr(xform_gcamp,xform_isbrain);
xform_gcampCorr = mouse.preprocess.gsr(xform_gcampCorr,xform_isbrain);

end

