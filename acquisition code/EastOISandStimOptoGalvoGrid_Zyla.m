function [RandomPosition]=EastOISandStimOptoGalvoGrid_Xiaodan(GalvoSeedCenter, GoodSeedsidx)
% ROIS=GALVO SEED CENTER
%
% Make sure filter #1 is selected (473 notch)

%% Scanning Variables
numLED=3;                        % number of channels (LED num + opto laser)
TExp=0.01;                       % use to set frame rate, affects period of trigger pulse

GalvoSeedCenter=GalvoSeedCenter(1:2:end-1,:); %% FOR LEFT HEMI ONLY
GoodSeedsidx=GoodSeedsidx(1:2:end-1,:);

FR=round(1/TExp);              % frame rate

SG_Off=-3; % Shutter Galvo Off (to beam block)
SG_On=0; % Shutter Galvo On (to image plane)
PW=0.005;  %Laser pulse width in seconds

%% AO control
outV=5;     % output trigger height (volts)
Sr=10000;   % sampling rate
s = daq.createSession('ni');
s.Rate = Sr;
Ar = s.Rate;
addAnalogOutputChannel(s, 'Dev1', 'ao0', 'Voltage'); % CCD
addAnalogOutputChannel(s, 'Dev1', 'ao3', 'Voltage');%M530
addAnalogOutputChannel(s, 'Dev1', 'ao4', 'Voltage');%TL625
addAnalogOutputChannel(s, 'Dev1', 'ao5', 'Voltage'); % Opto Shutter
addAnalogOutputChannel(s, 'Dev1', 'ao6', 'Voltage'); % Opto Y
addAnalogOutputChannel(s, 'Dev1', 'ao7', 'Voltage'); % Opto X



%% Adaptive Control Matrix
%Assumes 473nm Notch
%LEDtime=round([70 10 30 30 PW*Sr]); %Blue, Yellow Orange, Red
LEDtime=round([3 3 PW*Sr]); %Green, Red

SpF=floor(Ar/FR);        %samples per Frame (or per LED)
clear DataVec
DataVec=zeros(numLED*SpF,size(s.Channels,2));
[time] = size(DataVec);
DataVec(:,4)=SG_Off;

for n=0:numLED-1
    DataVec((n+1)*SpF:(n+1)*SpF,1)=1;               % Camera trigger
    DataVec((1+n*SpF+round(SpF./2-LEDtime(n+1)./2)):(1+n*SpF+round(SpF./2+LEDtime(n+1)./2)),n+2)=1; % 4 LEDs +Laser
end

DataVec(:,1:3)=outV*DataVec(:,1:3);
DataVecGalvoOff=DataVec;
DataVecGalvoOff(:,4)=SG_Off;

DataVecGalvoOn=DataVec;
idx= DataVecGalvoOn(:,4)==1;
DataVecGalvoOn(idx,4)=SG_On;

%% Stimulus Variables

BL1=5;             % Baseline time (stimulus off) Used to be 5
Dur=3;             % Stimulus duration time (stimulus on) Used to be 3
BL2=17; % Used to be 17

DataVecOff1=repmat(DataVecGalvoOff,round(BL1*Sr/(numLED*SpF)),1);
DataVecOn=repmat(DataVecGalvoOn,round(Dur*Sr/(numLED*SpF)),1);
DataVecOff2=repmat(DataVecGalvoOff,round(BL2*Sr/(numLED*SpF)),1);
DataVecTotal=cat(1, DataVecOff1, DataVecOn, DataVecOff2);

%% to TTL Voltage
numtrig=size(find(DataVecTotal(:,1)>4.5),1);
numsites=sum(GoodSeedsidx);
tottrig=numtrig*numsites;

%% Begin Scanning

WP=BL1+Dur+BL2+1; %amount of time to wait before stopping analog out
disp(['Set camera to record ',num2str(tottrig),' frames.'])
disp('Press ENTER when ready to start flashing sequence.')
pause
disp('Playing encoding sequence.')

rng(1);
RandomPosition=randperm(size(GalvoSeedCenter, 1));

for n=1:size(GalvoSeedCenter, 1)
    if GoodSeedsidx(RandomPosition(n))
        DataVecTotal(:,7)= GalvoSeedCenter(RandomPosition(n),1);
        DataVecTotal(:,8)= GalvoSeedCenter(RandomPosition(n),2);
        queueOutputData(s, DataVecTotal);
        startForeground(s);
    else
        disp(['Site ', num2str(RandomPosition(n)), ' out of FOV'])
    end
end

release(s);

%% End scan

disp(['Frame rate of scan =  ',num2str(Sr./time),' fps per LED.'])

DataVec3=zeros(SpF,size(s.Channels,2));
DataVec3(:,6)=SG_Off;
queueOutputData(s, DataVec3);
startForeground(s);
release(s);

end