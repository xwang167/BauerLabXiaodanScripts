% GCAMP_EEG_EMG_Sleep_PreProcessing
%
% This script is designed to take GCAMP data that has already been
% processed by WorkingGCaMPWrapper or Lindsey's GitHub5 and do the following
%
% #1 Import the the scoring from lab chart and score within each file a
% variable called 'scoringindex_file' which is the scoring index for that
% file
%
% #2 Break the GCAMP data up into 10 second chunks
%
% #3 Break the EEG/EMG data up into 10 second chunks
%
% #4.1 Pulls out EEG and EMG epochs for training, testing, validation in a
% deep learning model outside this workflow (i.e. AccuSleep)
%
% #4.2 Compare human vs machine learning scoring imported from outside the
% workflow
%
% #5 Create an -fft file using mtspecgramc
% 
% #6 Adds scoring to -fft file
%
% #7 Plot the FFT spectra and topoplots for each inividual file for each
% behavioral state
%
% #8 Concatenates the FFT spectra of each indicidual file into the entire
% recording

%Change history
%9/26/20 added radiometic\ to line 60, to be taken away later


clear all;
close all;

database='C:\MatlabScripts\Landsness\GDVS.xlsx';

excelfiles=[ 345]; %246 201 203 225 227 229 244 246 250 260 271 303 304 305 307 309]; 201 203 225 227 229 244 246 250 260 271 303 304 305
fs_gcamp=16.81; %downsampled by a factor of 2 to save space
Fs_emg=1000;

tStart = tic; 
for i=1:length(excelfiles)
    line=excelfiles(i);
    [~, ~, raw]=xlsread(database,1, ['A',num2str(line),':L',num2str(line)]);
    
    date=num2str(raw{1});
    msd=raw{2};
    rawloc=raw{3};
    eegloc=raw{11};
    
    if isnan(eegloc)
        emglocation=[];
    else
        emglocation=[rawloc, date, '\', eegloc, '.mat'];
    end
    
    if isnumeric(msd)
        msd=num2str(msd);
    end
    
    if ischar(raw{10})==1
        runs=str2num(raw{10});
    else
        runs=raw{10};
    end
    ROIloc=raw{9};
    ScoringFile=raw{12};
    
    gcamp_filename_root=[rawloc, date, '\',date, '-', msd, '-unfdatagcamp']; %use this one for Fs=16.8
    maskfile= [rawloc, date, '\',date, '-', msd, '-LandmarksandMask'];
    github_filename_root=[rawloc, date, '\',date, '-', msd]; %use this one for Fs=16.8
    BoxG5_filemname_root=['C:\Users\landsness\Box\MachineLearning\', date ,'\',date, '-G5\',date, '-', msd];
    AccusleepFilename=['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\ScoringAligned_EEG_all\', date, '-', msd];
    Accusleeplabelname=['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date,'\', msd, '_labels'];
    

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   #1 - Import Scoring from LabChart and plots the hypnogram
    [scoringNdx,timeNdx]=importLabChartScoring([rawloc, date, '\' ScoringFile]);
    plotHypnogram(scoringNdx,gcamp_filename_root);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%   #2  - Break the continuous gcamp data into 10 second chunks (128x128x168xnum_epochs). (168 = 10 seconds of frames)
%     CreateGSRfileFromContrasts2(github_filename_root,runs,scoringNdx, timeNdx) %uses Lindsey processed data already undergone GSR where the data is in a variable called 'contrasts2'

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%   #3  - Break the continuous EEG and EMG data into 10 second chunks  128x128x 10seconds x num_epochs to align with each gcamp fc file
%     EEGfile=[rawloc, date, '\', msd, '_EEG']; load(EEGfile); EEG_data=EEG; clear EEG;
%     EMGfile=[rawloc, date, '\', msd, '_EMG']; load(EMGfile); EMG_data=EMG; clear EMG;
%     appendEEG_G5(github_filename_root, runs, scoringNdx, timeNdx,EEG_data)
%     appendEMG_G5(github_filename_root, runs, scoringNdx, timeNdx,EMG_data)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%   #4.1  - OPTIONAL: will open EEG files that contain 'dataEEG' and 'scoringindex_file' andextract only the epochs specified in epochlist.
%         This is usually used when you are pulling out a subset of
%         training, testing and validation epochs for deep learning outside
%         of this workflow (i.e. AccuSleep)

      %%%%%% These are based on on pulling out whole fc files (to keep the data continuous
%     extractEEG_EMG_labels_epochs(AccusleepFilename, ['C:\Users\landsness\Box\MachineLearning\Mouse_Check\config12\', date,  '_train_fnames'], runs, ['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\', msd], 'train')
%     extractEEG_EMG_labels_epochs(AccusleepFilename, ['C:\Users\landsness\Box\MachineLearning\Mouse_Check\config12\', date,  '_val_fnames'], runs, ['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\', msd], 'validation')
%     extractEEG_EMG_labels_epochs(AccusleepFilename, ['C:\Users\landsness\Box\MachineLearning\Mouse_Check\config12\', date,  '_test_fnames'], runs, ['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\', msd], 'test')


      %%%%%% These are based on randomly pulling out epochs
%     extractEEG_EMG_labels_epochs(AccusleepFilename, ['C:\Users\landsness\Box\MachineLearning\Mouse_Check\raw_filelist\train_list\', date,  '_trainlist'], runs, ['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\', msd], 'train')
%     extractEEG_EMG_labels_epochs(AccusleepFilename, ['C:\Users\landsness\Box\MachineLearning\Mouse_Check\raw_filelist\valid_list\', date,  '_validlist'], runs, ['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\', msd], 'validation')
%     extractEEG_EMG_labels_epochs(AccusleepFilename, ['C:\Users\landsness\Box\MachineLearning\Mouse_Check\raw_filelist\test_list\', date,  '_testlist'], runs, ['C:\Users\landsness\Box\MachineLearning\AccuSleep\Data\' , date, '\', msd], 'test')



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   #4.2  OPTIONAL: Compare human vs machine scoring.  Only use if needed
    % [human_scored, machine_scored]=getClassificationResults('C:\Users\landsness\Box\MachineLearning\Poster\classification-results\results', runs);
    % replace_ndx=find(human_scored==2);%make all the indexes with a '2' actually a '3' to be consistent with the scoring labeling
    % human_scored(replace_ndx)=3; clear replace_ndx;
    % replace_ndx=find(machine_scored==2);
    % machine_scored(replace_ndx)=3; clear replace_ndx;
    % plotHypnogram(human_scored,[gcamp_filename_root 'Human artifacts excluded']);
    % plotHypnogram(machine_scored,[gcamp_filename_root 'machine artifacts excluded']);
    

   
    % DEBUGING ONLY:
    % checkScoringIndexG5_Accusleep(BoxG5_filemname_root, runs, scoringNdx, timeNdx,Accusleeplabelname) 
    % [me, g5]=CompareMyGitHub5(gcamp_filename_root, github_filename_root, runs);
    % epochs_toy=[1,3; 1,6; 2,45; 2,66; 3,90; 3,93];
    % getEEGEpochs(github_filename_root, runs, scoringNdx, EEG, 1000, epochs_toy)
    
    %%%%%%%%%  End Section 1.1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     clear scorinsgNdx timeNdx



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    #5 -  Create FFT using one the three prescibed options 
%   calculateGCAMPmtspecgramc(gcamp_filename_root, runs, fs_gcamp,'.mat'); % This is the traditional way off of using continuous data processed using WorkingGCAMP6_Wrapper, where the data is GSR'd and then fft calculated

    calculateGCAMPmtspecgramcGitHub5v2(github_filename_root, runs,fs_gcamp,'.mat'); %Uses Lindsey's Gihub5 processed data (128x128x168xnumepochs -aligned for Xiaohoi, temporarily makes it continuous to make the fft,but then saves it as a 128x128 x 257 x numepochs 

    % OBSOLETE
%   % calculateGCAMPmtspecgramcGitHub5(github_filename_root, runs, fs_gcamp, '.mat'); %OBSOLETE this calculates off 128x128xnumframes Lindsey processed Github5 data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    #6 - Add Scoring to the FFT file

    % AddScoringToFFT(gcamp_filename_root, runs, scoringNdx, timeNdx); % Working WorkingGCAMP6_Wrapper data
    
    % OBSOLETE: AddScoringToFFTGitHub5(github_filename_root, runs,scoringNdx,timeNdx); %GitHub5 processed data YOU DON'T NEED TO DO THIS BECAUSE IT WAS LINED UP IN STEP 2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   #7 Plot the FFT spectra, hypnograms, delta time course and topoplots for each inividual file for each
%   behavioral state or for the entire recording
    disp('Plotting FFT spectra, hypnograms, delta time course, and topoplots');
    for z=1:length(runs)
%         plotSpectraIndivdualFile([rawloc, date, '\',date, '-', msd,'-unfdatagcamp-fc' num2str(runs(z)) '-fft'], 1e-6) % Working WorkingGCAMP6_Wrapper data

        plotSpectraIndivdualFileGitHub5([rawloc, date, '\',date, '-',msd, '-fc' num2str(runs(z)) '-fftGitHub5'], 1e-6) %GitHub5 processed data
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   #8 Concatenates the FFT spectra of each indicidual file into the entire
%   night

%   plotSpectraWholeRecording([gcamp_filename_root '-fc'], runs, 5e-7,5e-5, 4e-7,1.5) % Working WorkingGCAMP6_Wrapper data
    plotSpectraWholeRecordingGitHub5([github_filename_root '-fc'], runs, 5e-7, 5e-5, 4e-7, 1.5) %GitHub5 processed data

%         plotSpectraWholeRecording_Interval([gcamp_filename_root '-fc'], runs, 4.9e-7, 1e-4, 4e-7,[201,229],[13,30],[289:296]); %4.9e-7 for 3710, 1.5e-6 for 3710

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   #9 Concatenates the FFT spectra of each indicidual file into a file
%   with no topoplots
%     getSpectraWholeRecordingGitHub5([github_filename_root '-fc'], runs)
    
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   #10 Add the artifacts back into the y_predicted from the machine learning
   [y_predict, y_true]= addArtifactsBackToPredicted([rawloc, date, '\',date, '-', msd,'-fc_allnightGitHub5'], 'C:\Users\landsness\Box\MachineLearning\Manuscript\test_data\200128_config14_fc1.mat', 0);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   #11 Add the artifacts back into the y_predicted
ConfusionMatrixTopoplot_Spectra(y_true, y_predict, [github_filename_root '-fc' 'Spectra_allnight'], [rawloc, date, '\'], [date, '-', msd, 'TopoConfusionMatrix'])
 
tEnd = toc(tStart)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extra code not part of the work flow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

