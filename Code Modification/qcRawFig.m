function [rawFig, hz, fdata]= qcRawFig(runInfo,time,rawSpatialAvg,representativeTime,diffF2F,diff12F,offset,system,rawStdPer)
%qcRawFig Generates figure with quality control for raw data
% Inputs:
%   time = time values in seconds
%   rawSpatialAvg = average time course of raw data over all pixels. Cell
%   array where each cell is the length of time.
%   representativeTime = time for that representative channel. Vector
%   diffF2F = sum of abs difference from frame to frame (number of time
%   frames - 1)
%   diff12F = sum of abs difference from 1st frame to frame (number of time
%   frames - 1)
%   offset = a time course specifying how much offset is present, thus
%   describing spatial movement.



rawFig = figure('Position',[100 100 1000 700]);

numCh = numel(rawSpatialAvg);
chStr = cell(1,numCh);
for ch = 1:numel(chStr)
    chStr{ch} = ['Ch ' num2str(ch)];
end

% find fs
for ch = 1:numCh
    fsTemp = diff(time{ch});
    T(ch) = fsTemp(1);
end
fs = 1./T;

%add title to subplot
mouseInfo = [runInfo.recDate, '-', runInfo.mouseName, '-', runInfo.session, char(string(runInfo.run))];
currVer = convertCharsToStrings(version('-release'));
if currVer == "2018a"
    suptitle(mouseInfo)
else
    sgtitle(mouseInfo)
end

% plot average abs time course
s1 = subplot('Position',[0.05 0.65 0.35 0.25]);

if strcmp(system, 'EastOIS1')
    Colors=[0 0 1; 0 1 0; 1 0.5 0; 1 0 0];
    TickLabels={'B', 'G', 'O', 'R'};
    legendName = {'blue LED', 'green LED', 'orange LED' 'red LED'};
else strcmp(system, 'EastOIS1_Fluor')
    Colors = [0 0 1; 0 1 0; 1 0.5 0; 1 0 0];
    TickLabels = {'B','G','O', 'R' };
    legendName = {'green fluorescence', 'green LED', 'orange LED' 'red LED'};
end


for ch = 1:numCh
    plot(s1,time{ch},rawSpatialAvg{ch},'Color',Colors(ch));
    hold on;
end
title(s1,'Raw Data');
legend(legendName);
xlabel('Time(sec)'); ylabel('Counts');

% plot average time trend
s2 = subplot('Position',[0.5 0.65 0.4 0.25]);
for ch = 1:numCh
    rawTrend{ch} = bsxfun(@rdivide,rawSpatialAvg{ch},mean(rawSpatialAvg{ch}));
    plot(s2,time{ch},rawTrend{ch},'Color',Colors(ch));
    hold on;
end
title(s2,'Normalized Raw Data');
legend(legendName);
xlabel('Time(sec)');
ylabel('Normalized Counts');

% plot std dev
s3 = subplot('Position',[0.05 0.36 0.35 0.2]);
plot(s3,rawStdPer);
hold on;
scatter(s3,1:numel(rawStdPer),rawStdPer,'filled','k');
hold off;
ylabel('% Deviation');
title(s3,'Std Deviation');
xticks(1:numCh);

% plot diff per frame
s4 = subplot('Position',[0.5 0.36 0.4 0.2]);
hold on;
xlabel('Time(sec)');
yyaxis(s4,'left');
plot(s4,representativeTime,diffF2F,'b');
ylabel({'Sum Abs Diff Frame to Frame,'; '(Counts)'},'Color','b');
yyaxis(s4,'right');
plot(s4,representativeTime,diff12F,'r');
ylabel({'Sum Abs Diff WRT First Frame,'; '(Counts)'},'Color','r');
legend('Instantaneous Change','Change Over Run');

% plot fft
s5 = subplot('Position',[0.05 0.06 0.35 0.2]);
for ch = 1:numCh
    rawTrend = double(bsxfun(@rdivide,rawSpatialAvg{ch},mean(rawSpatialAvg{ch})))';
    tNum = numel(rawTrend);
    fdata = abs(fft(-log(rawTrend)));
    hz = linspace(0,fs(ch),tNum);
    fdata = fdata(:,1:ceil(tNum/2));
    hz = hz(1:ceil(tNum/2));
    loglog(s5,hz,fdata);
    hold on;
end
title('FFT of Logmeaned Raw Data');
xlim([min(hz) max(hz)]);
% legend(chStr);
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% plot offset
s6 = subplot('Position',[0.5 0.06 0.4 0.2]);
plot(s6,representativeTime,offset); title('Absolute offset in pixels');
xlabel('Time (sec)'); ylabel('Offset (pixels)');
end

