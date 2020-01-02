function [DataVecTotal] = EastOISandStimOptoGalvo_GR(ST, OptoStim, GalvoSeedCenter)
DaqReset
%% Scanning Variables
numLED=3;                        % number of channels (LED num + opto laser)
TExp=0.0167;                       % use to set frame rate, affects period of trigger pulse
FR=round(1/TExp);              % frame rate

SG_Off=-3; % Shutter Galvo Off (to beam block)
SG_On=0; % Shutter Galvo On (to image plane)
PW=0.005;  %Laser pulse width in seconds

%% AO control
outV=5;     % output trigger height (volts)
Sr=10000;   % sampling rate
s = daq.createSession('ni');
s.Rate = Sr;

addAnalogOutputChannel(s, 'Dev1', 'ao0', 'Voltage'); % CCD
addAnalogOutputChannel(s, 'Dev1', 'ao3', 'Voltage'); % Green LED (TL 530)
addAnalogOutputChannel(s, 'Dev1', 'ao4', 'Voltage'); % Red LED (TL 625)nes
addAnalogOutputChannel(s, 'Dev1', 'ao5', 'Voltage'); % Opto Shutter
addAnalogOutputChannel(s, 'Dev1', 'ao6', 'Voltage'); % Opto Y
addAnalogOutputChannel(s, 'Dev1', 'ao7', 'Voltage'); % Opto X

%% Adaptive Control Matrix
%Assumes 473nm Notch
LEDtime=round([2 3 PW*Sr]); %Green, Red

SpF=floor(Sr/FR);        %samples per Frame (or per LED)
clear DataVec
DataVec=zeros(numLED*SpF,size(s.Channels,2));
[time] = size(DataVec);
DataVec(:,4)=SG_Off;
scalfac=1; %John
for n=0:numLED-1
    DataVec((n+1)*SpF:(n+1)*SpF,1)=1;               % Camera trigger
    DataVec((1+n*SpF+round(SpF./2-LEDtime(n+1)./2)):(1+n*SpF+round(SpF./2+LEDtime(n+1)./2)),n+2)=1; % 2 LEDs +Laser
  
end

DataVec(:,1:3)=outV*DataVec(:,1:3);
DataVecGalvoOff=DataVec;
DataVecGalvoOff(:,4)=SG_Off;

DataVecGalvoOn=DataVec;
idx= DataVecGalvoOn(:,4)==1;
DataVecGalvoOn(idx,4)=SG_On;

DataVecGalvoOn(:,5)= GalvoSeedCenter(1,1);
DataVecGalvoOn(:,6)= GalvoSeedCenter(1,2);

%% Stimulus Variables

switch OptoStim
    case 'Test'     % This condition stimulates constantly in blocks of 60 seconds.
        BL1 = 0;
        Dur=60;
        BL2=60-(BL1+Dur);
        DataVecTotal=repmat(DataVecGalvoOn,round(Dur*Sr/(numLED*SpF)),1);
        Repeats=ST/Dur;
        DataVecTotal=repmat(DataVecTotal,Repeats,1);
        
    case 'On'               % Use for stimulating in a block design
        BL1=5;              % Baseline time (stimulus off)
        Dur=5;              % Stimulus duration time (stimulus on)
        BL2=30-(BL1+Dur);   % Baseline  time (stimulus off)%Xiaodan Wang
        
        DataVecOff1=repmat(DataVecGalvoOff,round(BL1*Sr/(numLED*SpF)),1);
        DataVecOn=repmat(DataVecGalvoOn,round(BL1*Sr/(numLED*SpF)),1);
        DataVecOff2=repmat(DataVecGalvoOff,round(BL2*Sr/(numLED*SpF)),1);
        
        DataVecTotal=cat(1, DataVecOff1, DataVecOn, DataVecOff2);
        Repeats=ST/(BL1+Dur+BL2);
        DataVecTotal=repmat(DataVecTotal,Repeats,1);

    case 'Off'              % No Stimuli
        BL=60;
        DataVecTotal=repmat(DataVecGalvoOff,round(BL*Sr/(numLED*SpF)),1);
        Repeats=ST/BL;
        DataVecTotal=repmat(DataVecTotal,Repeats,1);        
end

%% to TTL Voltage
 DataVecTotal(1,1) = outV;%Xiaodan
numtrig=size(find(DataVecTotal(:,1)>4.5),1);

%% Begin Scanning

disp(['Set camera to record ',num2str(numtrig),' frames.'])
disp('Press ENTER when ready to start flashing sequence.')
frames_block = round(BL1*Sr/(numLED*SpF))+round(BL1*Sr/(numLED*SpF))+round(BL2*Sr/(numLED*SpF));
disp(['Frames for each block are ', num2str(frames_block)])%Xiaodan
disp(['Frames for baseline of each block are ',num2str(round(BL1*Sr/(numLED*SpF)))]);%Xiaodan

pause
disp('Playing encoding sequence.')

queueOutputData(s, DataVecTotal);
startForeground(s);
release(s);

%% End scan

disp(['Frame rate of scan =  ',num2str(Sr./time),' fps per LED.'])
%turn off lights
DataVec3=zeros(SpF,size(s.Channels,2));
DataVec3(:,4)=SG_Off;
queueOutputData(s, DataVec3);
startForeground(s);
release(s);
end