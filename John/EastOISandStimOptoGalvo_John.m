function EastOISandStimOptoGalvo_John(ST, OptoStim, GalvoSeedCenter)
DaqReset

% ST = 300;
% OptoStim = 'On';
% GalvoSeedCenter = [30 40];
%% Scanning Variables
numLED=5;                        % number of channels (LED num + opto laser)
TExp=0.01;                       % use to set frame rate, affects period of trigger pulse
FR=round(1/TExp);              % frame rate

SG_Off=-4; % Shutter Galvo Off (to beam block)
SG_On=0; % Shutter Galvo On (to image plane)
PW=0.005;  %Laser pulse width in seconds

%% AO control
outV=5;     % output trigger height (volts)
Sr=10000;   % sampling rate
s = daq.createSession('ni');
s.Rate = Sr;

addAnalogOutputChannel(s, 'Dev1', 'ao0', 'Voltage'); % CCD
addAnalogOutputChannel(s, 'Dev1', 'ao1', 'Voltage'); % Blue LED (TL 470)
addAnalogOutputChannel(s, 'Dev1', 'ao2', 'Voltage'); % Yellow LED (TL 590)
addAnalogOutputChannel(s, 'Dev1', 'ao3', 'Voltage'); % Orange LED (TL 617)
addAnalogOutputChannel(s, 'Dev1', 'ao4', 'Voltage'); % Red LED (TL 625)
addAnalogOutputChannel(s, 'Dev1', 'ao5', 'Voltage'); % Opto Shutter
addAnalogOutputChannel(s, 'Dev1', 'ao6', 'Voltage'); % Opto Y
addAnalogOutputChannel(s, 'Dev1', 'ao7', 'Voltage'); % Opto X

%% Adaptive Control Matrix
%Assumes 473nm Notch
LEDtime=round([
    65 45 65 40 PW*Sr]); %Blue, Yellow Orange, Red %% in the middle of 2 (aperture)


% LEDtime=round([
%     55 40 65 40 PW*Sr]); %Blue, Yellow Orange, Red (on 2.8 aperture)

SpF=Sr/FR;        %samples per Frame (or per LED)
clear DataVec
DataVec=zeros(numLED*SpF,8);
[time] = size(DataVec);
DataVec(:,6)=SG_Off;

for n=0:numLED-1
    DataVec((n+1)*SpF:(n+1)*SpF,1)=1;               % Camera trigger
    DataVec((1+n*SpF+round(SpF./2-LEDtime(n+1)./2)):(1+n*SpF+round(SpF./2+LEDtime(n+1)./2)),n+2)=1; % 4 LEDs +Laser
end

DataVec(:,1:5)=outV*DataVec(:,1:5);
DataVecGalvoOff=DataVec;
DataVecGalvoOff(:,6)=SG_Off;

DataVecGalvoOn=DataVec;
idx= DataVecGalvoOn(:,6)==1;
DataVecGalvoOn(idx,6)=SG_On;

DataVecGalvoOn(:,7)= GalvoSeedCenter(1,1);
DataVecGalvoOn(:,8)= GalvoSeedCenter(1,2);

%% Stimulus Variables

switch OptoStim
    case 'Test'     % This condition stimulates constantly in blocks of 60 seconds.
        Dur=60;
        DataVecTotal=repmat(DataVecGalvoOn,round(Dur*Sr/(numLED*SpF)),1);
        Repeats=ST/Dur;
        DataVecTotal=repmat(DataVecTotal,Repeats,1);
        
    case 'On'               % Use for stimulating in a block design
        BL1=5;              % Baseline time (stimulus off)
        Dur=5;              % Stimulus duration time (stimulus on)
        BL2=60-(BL1+Dur);   % Baseline  time (stimulus off)
        
        DataVecOff1=repmat(DataVecGalvoOff,round(BL1*Sr/(numLED*SpF)),1);
        DataVecOn=repmat(DataVecGalvoOn,round(Dur*Sr/(numLED*SpF)),1);
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
numtrig=size(find(DataVecTotal(:,1)>4.5),1);


%% Begin Scanning


disp(['Set camera to record ',num2str(numtrig),' frames.'])
disp('Press ENTER when ready to start flashing sequence.')
pause
disp('Playing encoding sequence.')

queueOutputData(s, DataVecTotal);
startForeground(s);
release(s);

%% End scan

disp(['Frame rate of scan =  ',num2str(Sr./time),' fps per LED.'])
%turn off lights
DataVec3=zeros(SpF,8);
DataVec3(:,6)=SG_Off;
queueOutputData(s, DataVec3);
startForeground(s);
release(s);
end