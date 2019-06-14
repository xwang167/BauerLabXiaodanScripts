function output = pipelineSingleTrial(metaData)

%[~, ~, excelLabels]=xlsread(excelFile,1, '1:1');
%[~, ~, excelRaw]=xlsread(excelFile,1, [num2str(excelRow),':',num2str(excelRow)]);

%% import packages

import mouse.*

%% read the excel file to get the list of file names

rawFileName = metaData.rawFile;

%% get system or session information.

systemInfo = expSpecific.sysInfo(metaData.systemType);

sessionInfo = expSpecific.sesInfo(metaData.sessionType);
sessionInfo.freqout = 2; % downsample to 2 Hz

% define which frames are dark
darkFrameInd = [];

%% get raw

speciesNum = systemInfo.numLEDs;
raw = read.readRaw(rawFileName,speciesNum,systemInfo.readFcn);
time = 1:size(raw,4); time = time./sessionInfo.framerate;

%% get WL image, landmarks, and mask

rgbOrder = systemInfo.rgb;
wl = preprocess.getWL(raw,darkFrameInd,rgbOrder);
[isbrain, affineMarkers] = preprocess.getLandmarksAndMask(wl);

%% preprocess

[time,data] = fluor.preprocess(time,raw,systemInfo,sessionInfo,affineMarkers,'darkFrameInd',darkFrameInd);
xform_isbrain = preprocess.affineTransform(isbrain,affineMarkers);

%% process

[datahb,dataFluor,dataFluorCorr] = fluor.process(data,systemInfo,sessionInfo,xform_isbrain);

output.time = time;
output.datahb = datahb;
output.dataFluor = dataFluor;
output.dataFluorCor = dataFluorCorr;

end