function [Seeds, L]=Seeds_PaxinosSpace

%These are the atlas coordinates of our seed locations

%% Seeds (x,y), R=Right, L=Left

Seeds.R.Olf=[0.72 3.8]; %Olfactory
Seeds.R.Fr=[1.3 3.3];   %Frontal
Seeds.R.Cing=[0.3 1.8]; %Cingulate
Seeds.R.M=[1.5 2];      %Motor
Seeds.R.SS=[3.2 -0.5];  %Somatosenory
Seeds.R.Ret=[0.5 -2.1]; %Retrosplenial
Seeds.R.V=[2.4 -4];     %Visual
Seeds.R.Aud=[4.2 -2.7]; %Auditory

Seeds.L.Olf=[-0.72 3.8];
Seeds.L.Fr=[-1.3 3.3];
Seeds.L.Cing=[-0.3 1.8];
Seeds.L.M=[-1.5 2];
Seeds.L.SS=[-3.2 -0.5];
Seeds.L.Ret=[-0.5 -2.1];
Seeds.L.V=[-2.4 -4];
Seeds.L.Aud=[-4.2 -2.7];

L.bregma=[0 0];
L.tent=[0 -3.9];
L.of=[0 3.525];

end
