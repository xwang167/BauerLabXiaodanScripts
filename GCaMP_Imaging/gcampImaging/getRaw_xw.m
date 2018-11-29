% saves raw data at lower frequency for me to work with
% usually runs saveHbAndFluor afterwards

clear all;close all;clc
%% params
databaseFile = 'D:\GCaMP\GCaMP_awake.xlsx';
% databaseFile = 'D:\data\NewProbeSample.xlsx';
excelInd = 2;  % rows from Excel Database
saveDir = 'D:\data';
numLED = 4;

%% for each mouse get data and analyze
for n = excelInd
    disp(['Excel row # ' num2str(n) '/' num2str(max(excelInd))]);
    
    % read from database
    [~, ~, raw]=xlsread(databaseFile,1, ['A',num2str(n),':G',num2str(n)]);
    % get relevant values from database
    recDate=num2str(raw{1});
    mouse=raw{2};
    rawdatadir=raw{3};
    saveloc=raw{4};
    system=raw{5};
    sessionType = eval(raw{6});
    rawLoc = fullfile(rawdatadir, recDate);
    saveDirMouse = fullfile(saveDir,recDate);
    if ~isfolder(saveDirMouse)
        mkdir(saveDirMouse);
    end
    
    saveFile = fullfile(saveDirMouse,[recDate '-' mouse]);
    
    %% get Hb
    disp('  get raw');
    
    % find relevant files
%     [preFileName,postFileName] = getFileNames_Probe(rawdatadir,recDate,mouse); % this depends on which probe data you look at
%     [preFileName,fileName] = getFileNames_SalineProbe(databaseFile,recDate,mouse); % this depends on which probe data you look at
    
    info = mouseAnalysis.expSpecific.session2procInfo_xw(sessionType); % getting meta info from session type
    info.framerate = raw{7};
    fs = info.framerate;
    
    % find the number of run
    
    % for each run
    for run = 1:3
        % some code to find the file name of the run
        fileName = strcat(rawLoc,'\',recDate, '-', mouse,'-', string(sessionType), num2str(run),'.tif');
     
        % get the matrix from tiff
        rawFile =  mouseAnalysis.expSpecific.loadTiffRaw(fileName,numLED);
        timeFile = 0:size(rawFile,4)-1;
        timeFile = timeFile./info.framerate;
        
        rawFile(:,:,:,1) = [];
        timeFile(1) = [];
        
        rawFile = double(rawFile);
        
        saveFileRun = strcat(saveFile,'-', sessionType, num2str(run), '-raw','.mat');
        save(string(saveFileRun),'rawFile','timeFile','fs','-v7.3');
    end
end
