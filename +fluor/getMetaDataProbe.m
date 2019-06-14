function [preMetaData,postMetaData] = getMetaDataProbe(excelLabels,excelRaw)
%getMetaDataProbe From the excel data, outputs a struct array containing
%information about one trial involving probe imaging. This would work for
%specific format in SalineProbe.xlsx
%   Inputs:
%       excelLabels = labels of each column in the excel file. This is such
%       that even if there is some shifting of columns via addition of more
%       data, this function would work. This should be the first row of the
%       excel file. excelLabels would be a 1xn cell array.
%       excelRaw = data of one row in the excel file. Each row should
%       pertain to a trial. excelRaw would be a 1xn cell array.
%   Outputs:
%       preMetaData = meta data for pre-probe
%       postMetaData = meta data for post-probe
%           metaData is a struct.
%               rawFile is a string array containing the raw file paths.
%               rawFileCamera is a numeric array containing information
%               about which file pertains to what camera. If there are two
%               cameras recording simultaneously, then rawFileCamera may be
%               [1 2 1 2 1 2] with 3 files per camera.
%               saveFile is a string containing path to which the data
%               should be saved.
%               systemType is a string describing which imaging system has
%               been used.
%               sessionType is a string describing the session used for the
%               imaging trial.
%
%               ex) metaData = 
%               rawFile: [1×2 string]
%               rawFileCamera: [1 1]
%               saveFile: "D:\data\180813\180813-ProbeW3M1-processed-Post.tif"
%               systemType: 'fcOIS2_Fluor'
%               sessionType: '6-nbdg'

excelLabels = string(excelLabels);

date = excelRaw{strcmp(excelLabels,"Date")};
mouse = excelRaw{strcmp(excelLabels,"Mouse")};
rawDataLocation = excelRaw{strcmp(excelLabels,"Raw Data Location")};
saveLocation = excelRaw{strcmp(excelLabels,"Save Location")};
systemType = excelRaw{strcmp(excelLabels,"System")};
sessionType = excelRaw{strcmp(excelLabels,"Session Type")};

filePrefix = strcat(string(date),"-",string(mouse));

% get file path of pre files
preFileName = strcat(filePrefix,"-Pre.tif");
preDataPath = fullfile(rawDataLocation,string(date),preFileName);
preSaveFileName = strcat(filePrefix,"-processed-Pre.tif");
preDataSavePath = fullfile(saveLocation,string(date),preSaveFileName);

% get file path of post files
D = dir(fullfile(rawDataLocation,string(date))); D(1:2) = [];
isPostFile = false(numel(D),1);
for dInd = 1:numel(D)
    if strfind(D(dInd).name,strcat(filePrefix,"-Post")) & D(dInd).bytes > 8000
        isPostFile(dInd) = true;
    end
end
isPostFile = find(isPostFile);

for i = 1:numel(isPostFile)
    postDataPath(i) = string(fullfile(rawDataLocation,string(date),D(isPostFile(i)).name));
end
postSaveFileName = strcat(filePrefix,"-processed-Post.tif");
postDataSavePath = fullfile(saveLocation,string(date),postSaveFileName);

% create the meta data

preMetaData.rawFile = preDataPath;
preMetaData.rawFileCamera = 1;
preMetaData.saveFile = preDataSavePath;
preMetaData.systemType = systemType;
preMetaData.sessionType = sessionType;

postMetaData.rawFile = postDataPath;
postMetaData.rawFileCamera = ones(1,numel(postDataPath));
postMetaData.saveFile = postDataSavePath;
postMetaData.systemType = systemType;
postMetaData.sessionType = sessionType;
end

