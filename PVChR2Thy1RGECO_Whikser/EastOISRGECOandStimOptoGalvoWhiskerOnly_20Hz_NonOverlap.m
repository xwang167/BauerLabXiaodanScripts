function EastOISRGECOandStimOptoGalvoWhiskerOnly_20Hz_NonOverlap(ST, OptoStim)
%DaqReset
%% Scanning Variables
numLED=4;                        % number of channels (LED num + opto laser)
SG_Off=0.2;%-4; % Shutter Galvo Off (to beam block)
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
addAnalogOutputChannel(s, 'Dev1', 'ao1', 'Voltage'); % stim

%% Adaptive Control Matrix
%Assumes 473nm Notch
DarkFrameTime=1;
LEDtime=round([100 3 4 PW*Sr]); %Bright, Green, Red, Laser
readOutTime = 51;%minimum is 49
clearTime = 24;%29
SpF_Green = 100;%minimum is 48+49
SpF_Red = 100;%max(100,LEDtime(3)+2+readOutTime);
SpF_Fluor = LEDtime(1)+clearTime+readOutTime;
SpF_Laser = LEDtime(4)+clearTime+readOutTime;
SpF = [SpF_Green SpF_Red SpF_Fluor SpF_Laser];

DataVec=zeros(2*sum(SpF),size(s.Channels,2));
CCDVec = zeros(2*sum(SpF),1);
CCDVec(1:SpF(1)-readOutTime,1) = 1;% Green Frame
CCDVec(SpF(1)+1:SpF(1)+SpF(2)-readOutTime,1) = 1; % Red Frame
CCDVec(sum(SpF(1:2))+1:sum(SpF(1:2))+SpF(3)-readOutTime,1) = 1; % Fluor Channel
CCDVec(sum(SpF)+1:end,1) = CCDVec(1:sum(SpF),1);

GreenVec = zeros(2*sum(SpF),1);
GreenVec(round((SpF(1)-readOutTime)/2-LEDtime(2)/2):round((SpF(1)-readOutTime)/2+LEDtime(2)/2),1) = 1;% Green OIS
GreenVec(sum(SpF(1:2))+round((SpF(3)-readOutTime)/2-LEDtime(1)/2):sum(SpF(1:2))+round((SpF(3)-readOutTime)/2+LEDtime(1)/2),1) = 1;% Green Bright
GreenVec(sum(SpF)+1:end,1) = GreenVec(1:sum(SpF),1);


RedVec = zeros(2*sum(SpF),1);
RedVec(SpF(1)+round((SpF(2)-readOutTime)/2-LEDtime(3)/2):SpF(1)+round((SpF(2)-readOutTime)/2+LEDtime(3)/2),1) = 1;% Red OIS
RedVec(sum(SpF)+1:end,1) = RedVec(1:sum(SpF),1);

LaserVec = ones(2*sum(SpF),1)*SG_Off;
LaserVec(sum(SpF(1:3))+round((SpF(4)-readOutTime)/2-LEDtime(4)/2):sum(SpF(1:3))+round((SpF(4)-readOutTime)/2+LEDtime(4)/2),1) = 1;% Laser
LaserVec(sum(SpF)+1:end,1) = LaserVec(1:sum(SpF),1);

DataVec(:,1) = CCDVec;
DataVec(:,2) = GreenVec;
DataVec(:,3) = RedVec;
DataVec(:,4) = LaserVec;



DataVec(:,1:3)=outV*DataVec(:,1:3);
DataVecGalvoOff=DataVec;
DataVecGalvoOff(:,7)=0;
DataVecGalvoOff(:,4)=SG_Off;


DataVecGalvoOn=DataVec;
DataVecGalvoOn(:,4)= SG_Off;
DataVecGalvoOn(:,7)= outV;



%% Stimulus Variables

switch OptoStim
    case 'Test'     % This condition stimulates constantly in blocks of 60 seconds.
        BL1 = 0;
        Dur=60;
        BL2=60-(BL1+Dur);
        DataVecTotal= repmat(DataVecGalvoOn,round(Dur*Sr/(2*sum(SpF))),1);%repmat(DataVecGalvoOn,round(Dur*Sr/(numLED*SpF)),1);xw 211127
        Repeats=ST/Dur;
        DataVecTotal=repmat(DataVecTotal,Repeats,1);
        
    case 'On'               % Use for stimulating in a block design
        BL1=5;              % Baseline time (stimulus off)
        Dur=5;              % Stimulus duration time (stimulus on) %xw change from 3 to 5
        BL2=30-(BL1+Dur);   % Baseline  time (stimulus off)%Xiaodan Wang
        
        DataVecOff1=repmat(DataVecGalvoOff,round(BL1*Sr/(2*sum(SpF))),1);
        DataVecOn=repmat(DataVecGalvoOn,round(Dur*Sr/(2*sum(SpF))),1);
        DataVecOff2=repmat(DataVecGalvoOff,round(BL2*Sr/(2*sum(SpF))),1);
        
        DataVecTotal=cat(1, DataVecOff1, DataVecOn, DataVecOff2);
        Repeats=ST/(BL1+Dur+BL2);
        DataVecTotal=repmat(DataVecTotal,Repeats,1);
        frames_block = round(BL1*Sr/(sum(SpF)))+round(Dur*Sr/(sum(SpF)))+round(BL2*Sr/(sum(SpF)));
        disp(['Frames for each block are ', num2str(frames_block)])%Xiaodan
        disp(['Frames for baseline of each block are ',num2str(round(BL1*Sr/(sum(SpF))))]);%Xiaodan
        
    case 'Off'              % No Stimuli
        BL=60;
        DataVecTotal=repmat(DataVecGalvoOff,round(BL*Sr/(2*sum(SpF))),1);
        Repeats=ST/BL;
        DataVecTotal=repmat(DataVecTotal,Repeats,1);
end

%% to TTL Voltage
DarkFrames=DataVecGalvoOff(1:sum(SpF),:);
DarkFrames(:,2:3)=0;
DarkFrames2=repmat(DarkFrames,round(DarkFrameTime*Sr/sum(SpF)),1);
DataVecTotal = cat(1,DarkFrames2,DataVecTotal); %ADAM

numtrig=size(find(DataVecTotal(:,1)==0),1)/readOutTime;
%DataVecTotal(end,1) = outV; Needed for overlap mode;
%% Begin Scanning

disp(['Set camera to record ',num2str(numtrig),' frames.'])
disp('Press ENTER when ready to start flashing sequence.')

disp(['Frame rate of scan =  ',num2str(Sr./sum(SpF)),' fps per LED.'])
pause
disp('Playing encoding sequence.')

queueOutputData(s, DataVecTotal);
startForeground(s);
release(s);

%% End scan


%turn off lights
DataVec3=zeros(sum(SpF),size(s.Channels,2));
DataVec3(:,4)=SG_Off;
queueOutputData(s, DataVec3);
startForeground(s);
release(s);
end