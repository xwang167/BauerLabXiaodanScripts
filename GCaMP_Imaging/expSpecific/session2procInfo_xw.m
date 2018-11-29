function info = session2procInfo_xw(sessiontype)
%session2procInfo Making OIS preprocess info from session type
%   Input:
%       sessiontype = string showing type of session ('fc','stim')
%   Output:
%       info = struct with info such as framerate, freqout, lowpass,
%       highpass. Should be inputted into procOISData fcn

if strcmp(sessiontype,'fc')
    info.freqout=1;
    info.lowpass=0.08;
    info.highpass=0.01;
elseif strcmp(sessiontype,'stim')
    info.freqout=1;
    info.lowpass=4;
    info.highpass=0.5;
    info.stimblocksize=60;
    info.stimbaseline=5;
    info.stimduration=10;
end
end

