clear all;
close all;
%9/26/20 added and then removed '\radiometic' to lines 15, 134 and 135.  Will need to be taken out later 

database = 'L:\RGECO\RGECO.xlsx'; %filepath of Excel database
% database = 'F:\PracticeEEG_EMG_181204.xlsx'; %filepath of Excel database
excelfiles=[2:7]; %Rows from Excel database to actually process 113  115 114 

for line=excelfiles;
    [~, ~, raw]=xlsread(database,1, ['A',num2str(line),':K',num2str(line)]);
    Date=num2str(raw{1});
    Mouse=num2str(raw{2});
    rawdataloc=raw{3};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    EricMaskSeedsToG5([directory, Date,'-', Mouse,'-LandmarksandMask_Eric.mat'],[directory, Date,'-', Mouse,'-'])
end


