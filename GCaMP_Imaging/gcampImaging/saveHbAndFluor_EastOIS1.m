%% Assumptions made about this experiment:
% Autofluorescence is time invariant.

% processing:
%   logmean on all channels
%   obtain Hb through procOIS
%   gsr on Hb

%% params
% databaseFile = 'D:\data\NewProbeSample.xlsx';
clear all;close all;clc
databaseFile = 'D:\GCaMP\GCaMP_awake.xlsx';
excelInd = 2;  % rows from Excel Database
specDir = 'D:\OIS_Process\OIS\Spectroscopy\LED Spectra\';
ledFiles = {[specDir,'M470nm_SPF_pol.txt'],...
    [specDir,'TL530nm_pol.txt'],...
    [specDir,'East3410OIS1_TL_617_Pol.txt'],...
    [specDir,'East3410OIS1_TL_625_Pol.txt']};
hbSpecies = 2:4; % usually 2:4.
probeSpecies = 1;
numLED = numel(hbSpecies) + numel(probeSpecies);

absCoeffFile = 'C:\Repositories\GitHub\OIS\Spectroscopy\prahl_extinct_coef.txt'; % for Hb
dataDir = 'D:\data';
saveDir = 'D:\data';
useGsr = false; % are you going to use global signal regression?



if useGsr
    modification = 'GSR';
else
    modification = '';
end

%% for each mouse create mask
for n=excelInd
    %% make mask (skipped if already made)
    disp('Make mask');
    % read from database
    [~, ~, raw]=xlsread(databaseFile,1, ['A',num2str(n),':G',num2str(n)]);
    % get relevant values from database
    recDate=num2str(raw{1});hipa
    rawdatadir=raw{3};
    saveloc=raw{4};
    system=raw{5};
    sessionType=eval(raw{6});
    rawLoc=fullfile(rawdatadir, recDate);
    maskDir=fullfile(saveloc, recDate);
    
    if ~exist(maskDir)
        mkdir(maskDir);
    end
    
    D = dir(rawLoc); D(1:2) = [];
    for file = 1:numel(D)
        if ~isempty(strfind(D(file).name,'.tif')) && D(file).bytes > 16
            maskLoadFile = fullfile(D(file).folder,D(file).name);
        end
    end
    
    saveMaskFile = string(strcat(maskDir,'\',recDate,'-', mouse,'-LandmarksandMask.mat'));
    
    % get landmarks and save mask file
    wlImage = mouseAnalysis.expSpecific.getLandMarksandMask_xw(maskLoadFile, saveMaskFile, system);
    
    % save WL image
    maskPicFile = fullfile(maskDir,[recDate,'-',mouse,'-WL.tif']);
    if ~isempty(wlImage)
        imwrite(wlImage,maskPicFile,'tiff');
    end
end

%% for each mouse get data and analyze
for n = excelInd
    disp(['Excel row # ' num2str(n) '/' num2str(numel(excelInd)+1)]);
    
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
    maskDir = fullfile(saveloc, recDate);
    maskFile = fullfile(maskDir,[recDate,'-',mouse,'-LandmarksandMask.mat']);
    saveDirMouse = fullfile(saveDir,recDate);
    
    
    % get mask and info
    load(maskFile);
    isbrain = logical(isbrain);
    info = mouseAnalysis.expSpecific.session2procInfo_xw(sessionType); % getting meta info from session type
    info.framerate = raw{7};
    
    % some code to find the number of runs session type
    
    for run= 1:3
        %% get raw
        disp('Get raw');
        rawName = string(strcat(saveDirMouse,'\',[recDate '-' mouse],'-', sessionType, num2str(run), '-raw','.mat'));
        
        load(rawName);
  
        %% get Hb
        % led correction. Only fluorescence gets corrected.
        disp('Get Hb data');
        [hbData, ~, ~, ~, info]=mouseAnalysis.expSpecific.procOIS(rawFile(:,:,hbSpecies,:), info, ledFiles(hbSpecies), isbrain);
        if useGsr
            [hbData, gs, beta]=mouseAnalysis.preprocess.gsr_xw(hbData,isbrain);
        end
        xform_hb = mouseAnalysis.expSpecific.transformHb(hbData, I);
        xform_isbrain = mouseAnalysis.expSpecific.transformHb(isbrain,I);
        
        hbSize = size(xform_hb);
        xform_hb = reshape(xform_hb,hbSize(1)*hbSize(2),hbSize(3),hbSize(4));
        xform_hb(~xform_isbrain(:),:,:) = nan;
        xform_hb = reshape(xform_hb,hbSize);
        
        %% get Fluor
        disp('Get fluorescence data');
        fluor = rawFile(:,:,probeSpecies,:);
        clear rawFile
        
        fluor = mouseAnalysis.expSpecific.procFluor(fluor,info,true);
        xform_fluor = mouseAnalysis.expSpecific.transformHb(fluor, I);
        clear fluor;
        baselineFluor = mean(xform_fluor,4);
        xform_fluor = xform_fluor./repmat(baselineFluor,[1 1 1 size(xform_fluor,4)]);
        xform_fluor = xform_fluor - 1;
        
        %% save data
        disp('Saving data');
        
        t_hb = timeFile;
        t_fluor = timeFile;
        
        saveFile = string(strcat(saveDirMouse,'\',[recDate '-' mouse],'-', sessionType, num2str(run),'-datahbFluo','_', modification,'.mat'));
        save(saveFile,'xform_isbrain','xform_hb','t_hb','xform_fluor',...
            't_fluor','-v7.3');
        
        clear xform_hb xform_fluor xform_fluorRatio
        
    end
    
end
