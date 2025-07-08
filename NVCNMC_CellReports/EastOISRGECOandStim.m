function EastOISRGECOandStim(ST,Stim)

%% LED Settings
TExp=0.01;
FR=1/TExp;

%% AO control
outV=5;     % output trigger height (volts)
Sr=10000;   % sampling rate

s = daq.createSession('ni');
s.Rate = Sr;
Ar = s.Rate;

addAnalogOutputChannel(s, 'Dev1', 'ao0', 'Voltage');%Zyla #1,2
addAnalogOutputChannel(s, 'Dev1', 'ao2', 'Voltage');%M470
addAnalogOutputChannel(s, 'Dev1', 'ao3', 'Voltage');%M530
addAnalogOutputChannel(s, 'Dev1', 'ao4', 'Voltage');%TL625
addAnalogOutputChannel(s, 'Dev1', 'ao5', 'Voltage');%Stim

numChannels = size(s.Channels,2);
stimChannel=numChannels;

%% LED Settings
SpF=floor(Ar/FR); % Samples per frame
LED_SpF=[SpF SpF SpF SpF]; %Camera exposure length

LED_time=[90 90 2 3]; %LED duty cycle
LED_num=size(LED_time,2);
scalfac=sum(LED_SpF)/(LED_num*SpF);
DarkFrameTime=1;

%% Control Matrix
for n=1:LED_num
    
    if LED_time(n)>=LED_SpF(n)
        error(['LED_', num2str(n), ' duration greater than camera exposure time.']);
    end
    DataVec_LED=zeros(ceil(LED_SpF(n)), LED_num);
    if n<3
        DataVec_LED(LED_SpF(n),1)=outV;
        if LED_time(n)~=0
            DataVec_LED(floor((LED_SpF(n)/2)-LED_time(n)/2):floor(LED_SpF(n)/2+LED_time(n)/2),n+1)=outV; % LED Triggers
        end
        DataVec{n,1}=DataVec_LED;
    else
        
        DataVec_LED(LED_SpF(n),1)=outV;
        if LED_time(n)~=0
            DataVec_LED(floor((LED_SpF(n)/2)-LED_time(n)/2):floor(LED_SpF(n)/2+LED_time(n)/2),n)=outV; % LED Triggers
        end
        DataVec{n,1}=DataVec_LED;
    end

end

DataVec2=cell2mat(DataVec); 
assignin('base','DataVec2', DataVec2);
[time] = size(DataVec2,1);

%% Stimulus Settings
switch Stim
        
    case 'On'           % Use for stimulating in a block design
        BL1=5;          % Baseline time (stimulus off)
        Dur=1;         % Stimulus duration time (stimulus on), doesnt matter as long as block length is longer than box' duration of being on
        BL2=30-(BL1+Dur);
 
    case 'Off'              % No Stimuli
        BL1=60;
        Dur=0;
        BL2=0;
 end

DataVecStim=DataVec2;
DataVecStim(:,stimChannel)=outV;
DataVecNoStim=DataVec2;
DataVecNoStim(:,stimChannel)=0;

%% Concatenate Everything Together
DataVecOff1=repmat(DataVecNoStim,round(BL1*Sr/(LED_num*SpF*scalfac)),1);
DataVecOn=repmat(DataVecStim,round(Dur*Sr/(LED_num*SpF*scalfac)),1);
DataVecOff2=repmat(DataVecNoStim,round(BL2*Sr/(LED_num*SpF*scalfac)),1);

DataVecTotal=cat(1, DataVecOff1, DataVecOn, DataVecOff2);
assignin('base','DataVecTotal', DataVecTotal);
Repeats=single(round(ST/(BL1+Dur+BL2)));
assignin('base','Repeats',Repeats); 
DataVecTotal=repmat(DataVecTotal,Repeats,1);

DarkFrames=DataVec2;
DarkFrames(:,2:numChannels)=0;
DarkFrames2=repmat(DarkFrames,round(DarkFrameTime*Sr/(LED_num*SpF*scalfac)),1);
assignin('base','DarkFrames2',DarkFrames2); 
assignin('base','DarkFrames',DarkFrames); 

DataVecTotal2 = cat(1,DarkFrames2,DataVecTotal); %ADAM
DataVecTotal2(1,1)=outV; %for triggering first frame


%NumTrig=find(DataVecTotal2(:,1)==0)/2;

NumTrig=find(DataVecTotal2(:,1)>0.5*outV);

%% Begin Scanning

WP=ST+1; %amount of time to wait before stopping analog out
disp(['Set camera to record ',num2str(size(NumTrig,1)-1),' frames.'])
disp(['DarkFrame/Channel = ' num2str(DarkFrameTime*Sr./time)])
disp(['If create WL, set camera to record' 32 num2str(DarkFrameTime*Sr./time*LED_num+8) 32 'frames'])
disp(['Frame rate of scan =  ',num2str(Sr./sum(SpF)),' fps per LED.'])
disp('Press ENTER when ready to start flashing sequence.')
pause
disp('Playing encoding sequence.')
assignin('base','DataVecTotal2',DataVecTotal2); 

queueOutputData(s, DataVecTotal2);
startForeground(s);

%% End scan

DataVec=zeros(Sr,size(s.Channels,2));
DataVec(:,1:size(s.Channels,2))=0;
queueOutputData(s, DataVec);
startForeground(s);
fclose('all');
beep on; beep;
end