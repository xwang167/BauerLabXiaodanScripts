function ViewGalvoSeedsPaxinosAtlas_xw

% Allows you to visualize your seeds locations (in atlas coordinates) on the Paxinos atlas.  

[Seeds, L]=GalvoSeeds_PaxinosSpace_xw; %Make seeds
[brain]=PaxinosSmooth(1); %Make Paxinos Atlas

F=fieldnames(Seeds.R); 
numf=numel(F);

%plot seeds
for f=1:numf
    N=F{f};
    hold on; 
    plot(Seeds.R.(N)(1),Seeds.R.(N)(2),'ko','MarkerFaceColor','k')
    plot(Seeds.L.(N)(1),Seeds.L.(N)(2),'ko','MarkerFaceColor','k')
end