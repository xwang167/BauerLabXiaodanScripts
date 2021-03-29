function info = sysInfo(systemType)
%session2procInfo Making OIS preprocess info from session type
%   Input:
%       sessiontype = char array showing type of systemtype ('fcOIS1','fcOIS2')
%   Output:
%       info = struct with info such as rgb indices
%           rgb = 1x3 vector specifying indices for red, green, and blue
%           numLEDs = number of leds
%           LEDFiles = string array containing name of text files showing
%           LED spectra
%           readFcn = function handle for reading from raw file (tiff, dat)
%           invalidFrameInd = any temporal frame index that should be
%           removed prior to processing (these are any indices that are not
%           dark frames yet still need to be removed)
%           gbox = gaussian filter box size for smoothing image
%           gsigma = gaussian filter sigma for smoothing image

if strcmp(systemType,'EastOIS1')
    info.rgb = [4 2 1];
    info.numLEDs = 4;
    info.binFactor = [1 1 1 1];
    info.LEDFiles = {'East3410OIS1_TL_470_Pol.txt', ...
        'East3410OIS1_TL_590_Pol.txt', ...
        'East3410OIS1_TL_617_Pol.txt', ...
        'East3410OIS1_TL_625_Pol.txt'};
    info.fluorFiles = {};
    info.chHb = 1:4;
    info.chFluor = [];
    info.chSpeckle = [];
    info.numInvalidFrames = 1;
    info.validThr = [1 16382];% remove
    info.gbox = 5;
    info.gsigma = 1.2;
elseif strcmp(systemType,'EastOIS1+laser')
    info.rgb = [4 2 1];
    info.numLEDs = 5;
    info.binFactor = [1 1 1 1 1];
    info.LEDFiles = {'East3410OIS1_TL_470_Pol.txt', ...
        'East3410OIS1_TL_590_Pol.txt', ...
        'East3410OIS1_TL_617_Pol.txt', ...
        'East3410OIS1_TL_625_Pol.txt'};
    info.fluorFiles = {};
    info.chHb = 1:4;
    info.chFluor = [];
    info.chSpeckle = [];
    info.numInvalidFrames = 1;
    info.validThr = [1 16382];
    info.gbox = 5;
    info.gsigma = 1.2;
elseif strcmp(systemType,'EastOIS1+fluor+speckle')
    info.rgb = [4 2 NaN];
    info.numLEDs = 5;
    info.binFactor = [4 4 4 4 1];
    info.LEDFiles = {'M470nm_SPF_pol.txt',...
        'TL_530nm_515LPF_Pol.txt', ...
        'East3410OIS1_TL_617_Pol.txt',...
        'East3410OIS1_TL_625_Pol.txt'};
    info.fluorFiles = {'gcamp6f_emission.txt'};
    info.chHb = 2:4;
    info.chFluor = 1;
    info.chSpeckle = 5;
    info.numInvalidFrames = 1;
    info.validThr = [1 16382];
    info.gbox = 5;
    info.gsigma = 1.2;
elseif strcmp(systemType,'EastOIS1_Fluor')
    info.rgb = [4 2 NaN];
    info.numLEDs = 4;
    info.binFactor = [1 1 1 1];
    info.LEDFiles = {'M470nm_SPF_pol.txt', ...
        'TL_530nm_515LPF_Pol.txt', ...
        'East3410OIS1_TL_617_Pol.txt', ...
        'East3410OIS1_TL_625_Pol.txt'};
    info.fluorFiles = {'gcamp6f_emission.txt'};
    info.chHb = 2:4;
    info.chFluor = 1;
    info.chSpeckle = [];
    info.numInvalidFrames = 1;
    info.validThr = [1 16382];
    info.gbox = 5;
    info.gsigma = 1.2;
elseif strcmp(systemType,'EastOIS2')
    info.rgb = [4 3 NaN];
    info.numLEDs = 4;
    info.binFactor = [4 4 4 4];
    info.LEDFiles = {'TwoCam_Mightex470_BP_Pol.txt', ...
        'TwoCam_Mightex525_BP_Pol.txt', ...
        'TwoCam_Mightex525_BP_Pol.txt', ...
        'TwoCam_TL625_Pol.txt'};
    info.fluorFiles = {'jrgeco1a_emission.txt'};
    info.chHb = 3:4;
    info.chFluor = 2;
    info.chSpeckle = [];
    info.numInvalidFrames = 1;
    info.validThr = [1 inf];
    info.gbox = 5;
    info.gsigma = 1.2;
end

paramPath = what('bauerParams'); % path to bauerParams module
sourceSpectraLoc = fullfile(paramPath.path,'ledSpectra'); % path to led spectra text files
for ledInd = 1:numel(info.LEDFiles)
    info.LEDFiles{ledInd} = fullfile(sourceSpectraLoc,info.LEDFiles{ledInd});
end
fluorSpectraLoc = fullfile(paramPath.path,'probeSpectra'); % path to fluor spectra text files
for chInd = 1:numel(info.fluorFiles)
    info.fluorFiles{chInd} = fullfile(fluorSpectraLoc,info.fluorFiles{chInd});
end
end

