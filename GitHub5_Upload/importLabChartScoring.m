function [scoringNdx, timeS]=importLabChartScoring(labchartfilename)

%labchartfilename is a matlab file that contains a num_epochs x 2 cell.
%Each row in the first column is the stage for that 10 second epoch (wake,
%artifact, NREM, REM).  This then assigns each stage a numeric value
%(0,2,1,3)to scoringNdx for each stage which will allow easier plotting of the hypnogram
%later

%7/13/20 fixed small bug with timeS

load(labchartfilename); %load the variable 'stage'

scoringN=scoring(:,1);

% size(scoring,2) <2
% for i:1:length(scoringN)
%     scoring(:,2)=timeS;
% end
timeS=5:10:length(scoringN)*10; timeS=num2cell(timeS');
scoringNdx=[];
for i=1:length(scoringN)
    if strcmp(scoringN(i), 'wake')
        scoringNdx(i)=0;
    else
    end
    
    if strcmp(scoringN(i), 'Artifact')
        scoringNdx(i)=2;
    else
    end
    
    if strcmp(scoringN(i), 'NREM')
        scoringNdx(i)=1;
        
    else
    end
    
    
    if strcmp(scoringN(i), 'REM')
        scoringNdx(i)=3;
    else
    end
end
