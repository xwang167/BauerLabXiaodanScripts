function [affineMarkers, seedCenter] = getLandmarks(WL)
% This function calculates the locations of the predefinded seeds in atlas
% space and maps them to mouse space. "seedCenter" contains the locations
% of the seeds in mouse space, and "affineMarkers" contains the landmark locations
% from OIS repository
%
% Input:
%   WL = white light image = n x n x 3
% Output:
%   affineMarkers = struct including locations of markers (bregma, tent,
%   OF)
%   seedCenter = where the seeds are located (y,x coordinates)

%% GetLandmarks for mouse
wlFig = figure;
wlAx = axes(wlFig);
image(wlAx,WL)
axis image;

disp('Click Anterior Midline Suture Landmark (anterior region with cross shape).');
[x, y]=ginput(1);
x = x./size(WL,2);
y = y./size(WL,1);

OF(1)=x;
OF(2)=y;

disp('Click Lambda (posterior region where three lines join).');
[x, y]=ginput(1);
x = x./size(WL,2);
y = y./size(WL,1);

T(1) = x;
T(2) = y;

%% Get Seeds according to Atlas Space
[Seeds, L]=Seeds_PaxinosSpace;  % Normal 16 seed map

%% Transform atlas seeds to mouse space
adist=norm(L.of-L.tent);    %Paxinos Space
idist=norm(OF-T);           %Mouse Space

aa=atan2(L.of(1)-L.tent(1),L.of(2)-L.tent(2));  %Angle in Paxinos Space
ia=atan2(OF(1)-T(1),OF(2)-T(2));                %Angle in Mouse Space
da=ia-aa;                           %Mouse-Paxinos

pixmm=idist/adist;                  %Mouse/Pax
R=[cos(da) -sin(da) ; sin(da) cos(da)];

affineMarkers.bregma=pixmm*(L.bregma*R);
affineMarkers.tent=pixmm*(L.tent*R);
affineMarkers.OF=pixmm*(L.of*R);

t=T-affineMarkers.tent;             %translation=mouse-Paxinos

affineMarkers.bregma=affineMarkers.bregma+t;
affineMarkers.tent=affineMarkers.tent+t;
affineMarkers.OF=affineMarkers.OF+t;

seedNames=fieldnames(Seeds.R);
numSeeds=numel(seedNames);

for seedInd = 1:numSeeds
    N = seedNames{seedInd};
    affineMarkers.Seeds.R.(N) = pixmm*Seeds.R.(N)*R+affineMarkers.bregma;
    affineMarkers.Seeds.L.(N) = pixmm*Seeds.L.(N)*R+affineMarkers.bregma;
end

seedCenter = zeros(2*numSeeds,2);

for seedInd = 0:numSeeds-1
    N = seedNames{seedInd+1};
    seedCenter(2*(seedInd+1)-1,1) = affineMarkers.Seeds.R.(N)(1);
    seedCenter(2*(seedInd+1)-1,2) = affineMarkers.Seeds.R.(N)(2);
    seedCenter(2*(seedInd+1),1) = affineMarkers.Seeds.L.(N)(1);
    seedCenter(2*(seedInd+1),2) = affineMarkers.Seeds.L.(N)(2);
    
end

close(wlFig);

end