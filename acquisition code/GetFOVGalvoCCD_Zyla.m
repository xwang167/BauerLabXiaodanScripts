
%% Turn camera on video mode to see laser spots
%% Coords to 0,0

s = daq.createSession('ni');

addAnalogOutputChannel(s, 'Dev1', 'ao5', 'Voltage');% Opto Shutter
addAnalogOutputChannel(s, 'Dev1', 'ao6', 'Voltage');% Opto Y
addAnalogOutputChannel(s, 'Dev1', 'ao7', 'Voltage');% Opto X

queueOutputData(s, [0  0.20  -0.13 ]);
startForeground(s);
release(s);

%% Coordinates in Y, X directions (Y is anterior-poterior, X is left-right)

%Y= 128 - CCDPix#/8 + 1;  Note:for 4x4 binning, Pixel numbers in Solis are
%over a range (e.g. 509 to 512). CCDPix# above is largest value in range
%(1024 in this case)

% Y Coord Cheat Sheet:
%1024 = 1      8 = 128
%1016 = 2      16 = 127
%1008 = 3     24 = 126
%1000 = 4     32 = 125
%992 = 5     40 = 124
%984 = 6     48 = 123
%976 = 7     56 = 122
%968 = 8     64 = 121
%960 = 9     72 = 120
%952 = 10    80 = 119
%944 = 11    88 = 118

% [Y X 1]
CCDPoints=...
[7 123 1;...  
 6 9 1;...
123 7 1;...
124 121 1];

GalvoPoints=...
[-0.20  0.13 1;...right top
 -0.13  -0.23 1;...left top
0.20  -0.13 1;...left bottom
0.13  0.23 1];...right bottom

% GalvoPoints_Zyla = [0 -0.21 0.18;...; %left bottom
%     [0 -0.176 -0.22];%left top
%      [0 0.21 -0.185]
%      [0 0.175 0.215]%right top


% CCDPoints=...
% [4 4 1;...  
% 6 124 1;...
% 125 3 1;...
% 125 123 1];
% 
% GalvoPoints=...
% [0.05 .005 1;...
% -1.1 -.01 1;...
% -.01 0.52 1;...
% -1.16 0.51 1];


%%(Y,X) %Y = 128-CCDpix/4 +1; X=CCDPix/4
%%Points are in the following order: upper left, upper right, lower left
%%lower right


