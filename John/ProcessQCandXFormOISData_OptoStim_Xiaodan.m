% Input the excel database directory
clear all;close all;clc
database='D:\GCaMP\GCaMP_awake.xlsx';

% Directs Matlab to look at desired rows in excel database
excelfiles=257; 

% Cycles through each row and outputs a white light image of the mouse
% brain and asks for user-input of landmarks (anterior and posterior suture
% landmarks) and brain mask (the desired part of the brain for the program
% to look at)
for n=excelfiles;
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':H',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    rawdatadir=raw{3};
    saveloc=raw{4};
    system=raw{5};
    sessiontype=eval(raw{6});    
    rawdataloc=[rawdatadir, Date, '\'];
    directory=[saveloc, Date, '\'];
    framerate=raw{7};
    
    John_GetLandMarksandMask_xw(Date, Mouse, directory, rawdataloc, system);
end

% Recruits all of the parallel processing cores in your computer 
% poolobj = gcp('nocreate'); % If no pool, do not create new one.
% if isempty(poolobj)
%     parpool('local',4) % Have to manually input the number of cores in your computer's CPU
% end

for n=excelfiles;
    % Pulls in information for each trial from the excel database 
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':H',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    rawdatadir=raw{3};
    saveloc=raw{4};
    system=raw{5};
    sessiontype=eval(raw{6});    
    rawdataloc=[rawdatadir, Date, '\'];
    directory=[saveloc, Date, '\'];
    framerate=raw{7};
    gsrornot = 1; %%NEW

    if ~exist(directory);
        mkdir(directory);
    end
      
    for t=1:numel(sessiontype);
        if ~exist('info', 'var')
            if strcmp(sessiontype{t},'fc') % for resting state data only 
                info.framerate=5; % The framerate of the recorded data (Hz) %%MAY NEED TO CHANGE
                info.freqout=1; % What frequency to downsample data too
                info.lowpass=0.08; % Low pass filter
                info.highpass=0.009; % High pass filter (filters out lower frequency signals such as heartbeat)
            elseif strcmp(sessiontype{t},'stim') % for any data with stimulation (peripheral or photo)
                info.framerate=framerate; % The framerate should be applied in the excel database
                info.freqout=1; % '' 
                info.lowpass=0.49; % ''
                info.highpass=0.009; % ''
                info.stimblocksize=60; % How long each block is (s) %% MAY NEED TO CHANGE
                info.stimbaseline=5; % Duration of the stimulation baseline a.k.a. how long before the stimulation turns on (s)
                info.stimduration=5; % Duration of the stimulation train a.k.a. how long is the stimulation on (s)
            end
        end
        ProcMultiOISFiles_Opto(Date, Mouse, sessiontype{t}, directory, rawdataloc, info, system); % Processes raw data and outputs hemoglobin data 
        OISQC_Opto(Date, Mouse, sessiontype{t}, directory, rawdataloc, info, system,0);  % gsrornot % Outputs standard visual graphs/maps         
        cd(directory)
        TransformDatahb(Date, Mouse, sessiontype{t}); % Affine transforms datahb into mouse space using user-inputted landmarks
        TransformLaserFrame(Date, Mouse, sessiontype{t}); % transforms laser frame
        John_TransformHbContrasts(Date, Mouse, saveloc, sessiontype, info, gsrornot); % (1) Affine transforms hemoglobin contrasts (Oxy, DeOxy, Total), (2) performs gsr or no gsr, (3) does baseline subtraction
        John_generateHbImageSequence(Date,Mouse,saveloc,sessiontype,[1],{'PS'}); % Generates mouse-level image sequences and peak maps
        clear info
    end
    close all
end

% Micetypes = {'PViso-1attempt2'};
% excelfiletypes = {[121:125]};
% for i = 1:length(excelfiletypes)
%     excelfiles = excelfiletypes{i};
%     name = Micetypes{i};
%     John_GenerateGroupAveragedData(excelfiles, database, name)
% end
% John_generateTimetrace(excelfiles, database,[1,4,7],{'RightWS','LeftBarrelCortexPS','PS+WS'},{'max','min','max'}) % Generates mouse-level time traces, and group-level peak Hb maps and time traces
John_generateTimetracewCNR(excelfiles, database,(1),{'PS'},{'min'})
John_GenerateMouseAveragedDatawCNR_conditions(excelfiles,database,(1),{'PS'},{'min'},0.5)
John_OptoStimQuantitativeAnalysisAllMice_Threshold_CNR(0.5);


% 
% Micetypes = {'PV-0p25mW','PV-0p5mW','PV-1mW','PV-2mW'};
% maxormin = {'min','min','min','min'};
% excelfiletypes = {[61,65,69],[62,66,70],[63,67,71],[64,68,72]};
% ROIthresh = 0.5;
% 
% for b = 1:length(Micetypes)
%     for n=excelfiletypes{b};
%         % Pulls in information for each trial from the excel database
%         [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':H',num2str(n)]);
%         Date=num2str(raw{1});
%         Mouse=raw{2};
%         rawdatadir=raw{3};
%         saveloc=raw{4};
%         system=raw{5};
%         sessiontype=eval(raw{6});
%         rawdataloc=[rawdatadir, Date, '\'];
%         directory=[saveloc, Date, '\'];
%         framerate=raw{7};
%         John_generateHbImageSequence(Date,Mouse,saveloc,sessiontype,[1],{Micetypes{b}}); % Generates mouse-level image sequences and peak maps
%     end
% end
% 
% for a = 1:length(Micetypes)
% John_generateTimetracewCNR(excelfiletypes{a}, database,[1],{Micetypes{a}},{maxormin{a}})
% John_GenerateMouseAveragedDatawCNR_conditions(excelfiletypes{a},database,[1],{Micetypes{a}},{maxormin{a}},ROIthresh)
% end

