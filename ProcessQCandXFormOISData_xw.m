clear all
database="C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

excelfiles=[181 183 185  228 232 236];  % Rows from Excell Database


for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':F',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    rawdatadir=raw{3};
    saveloc=raw{4};
    system=raw{5};
    sessiontype=eval(raw{6});
    
    rawdataloc=[rawdatadir, Date, '\'];
    directory=fullfile(saveloc, Date, '\');
    
    if ~exist(directory);
        mkdir(directory);
    end
    
    for t=1:numel(sessiontype);
        if ~exist('info', 'var')
            if strcmp(sessiontype{t},'fc')
                info.framerate=25;
                info.freqout=25;
                info.lowpass=0.08;
                info.highpass=0.009;
            elseif strcmp(sessiontype{t},'stim')
                info.framerate=29.76;
                info.freqout=1;
                info.lowpass=0.5;
                info.highpass=0.009;
                info.stimblocksize=60;
                info.stimbaseline=5;
                info.stimduration=10;
            end
        end
        ProcMultiOISFiles_xw(Date, Mouse, sessiontype{t}, directory, rawdataloc, info, system);
        cd(directory)
        TransformDatahb_xw(Date, Mouse, sessiontype{t});
        clear info
    end
end

