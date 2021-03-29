function [Seeds, L]=Seeds_PaxinosSpace_new

%These are the atlas coordinates of our seed locations

%% Seeds (x,y), R=Right, L=Left

% polyin = polyshape(brain.LPA.poly.L);
% [x,y] = centroid(polyin);

Seeds.R.Fr=[1.3 3.3];   %Frontal
Seeds.R.Cing=[0.0500 0.9000]; %Cingulate
Seeds.R.M=[1.5 2];      %Motor
Seeds.R.SS=[3.6 -0.15];  %Somatosenory
Seeds.R.Ret=[0.5 -2.1]; %Retrosplenial
Seeds.R.P=[2.6169 -2.3712];  %Parietal
Seeds.R.V=[2.4 -4];     %Visual
Seeds.R.Aud=[4.2 -2.7]; %Auditory



Seeds.L.Fr=[-1.3 3.3];
Seeds.L.Cing=[-0.0500 0.9000];
Seeds.L.M=[-1.5 2];
Seeds.L.SS=[-3.6 -0.15];
Seeds.L.Ret=[-0.5 -2.1];
Seeds.L.P=[-2.6169 -2.3712];  %Parietal
Seeds.L.V=[-2.4 -4];
Seeds.L.Aud=[-4.2 -2.7];


L.bregma=[0 0];
L.tent=[0 -3.9];
L.of=[0 3.525];

end

