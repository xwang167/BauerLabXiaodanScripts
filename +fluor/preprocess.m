function [time,data,rawData] = preprocess(time,raw,systemInfo,sessionInfo,affineMarkers,varargin)
%preprocess Preprocesses data
%   Input:
%       time = 1D vector specifying time points
%       raw = 4D data
%       systemInfo = system information
%       sessionInfo = session information
%       affineMarkers = markers for affine transformation (output of
%       getLandmarksAndMask)
%       darkFrame (parameter) = 3D data containing dark frame. If this is
%       not given darkFrameInd is used to calculate darkFrame from raw
%       data.
%       darkFrameInd (parameter) = either boolean or double vector
%       containing information of frame indices that are used to get dark
%       frames. The data pertaining to these indices are also removed from
%       the output.
%   Output:
%       time = 1D vector of time points
%       data = preprocessed 4D data
%       rawData = preprocessed 4D data without affine transform

import mouse.*

p = inputParser;
addParameter(p,'darkFrameInd',[]);
addParameter(p,'darkFrame',[],@isnumeric);
parse(p,varargin{:});

darkFrameInd = p.Results.darkFrameInd;
darkFrame = p.Results.darkFrame;

%% get dark frames and subtract it from the data

% boolean for whether raw data should be used for dark frames
useDataForDarkFrames = false;
if isempty(darkFrame)
    useDataForDarkFrames = true; % raw data should be used
end

if useDataForDarkFrames
    if isempty(darkFrameInd)
        disp('preprocess: no darkFrameInd given, so darkFrame is defined to be zeros');
        darkFrame = zeros(size(raw,1),size(raw,2),size(raw,3));
    else
        darkFrame = preprocess.getDarkFrame(raw,darkFrameInd);
    end
end

% subtract darkframe from rest of the data
rawData = raw - repmat(darkFrame,1,1,1,size(raw,4));

%% remove bad frames

badFrameInd = false(1,size(raw,4));
badFrameInd(darkFrameInd) = true;
badFrameInd(systemInfo.invalidFrameInd) = true;

% get rid of bad frames
rawData(:,:,:,badFrameInd) = [];
time(badFrameInd) = [];

%% smooth image

rawData = preprocess.smoothImage(rawData,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data

%% detrend raw

rawData = preprocess.detrend(rawData,sessionInfo.detrendTemporally,sessionInfo.detrendSpatially);

%% affine transform

data = preprocess.affineTransform(rawData,affineMarkers);
end