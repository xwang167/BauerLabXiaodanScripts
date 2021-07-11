function [Seeds, L]=Seeds_PaxinosSpace_xw

%These are the atlas coordinates of our seed locations

%% Seeds (x,y), R=Right, L=Left

Seeds.R.Fr=[1.3 3.3];   %Frontal
Seeds.R.M=[1.5 2];      %Motor
Seeds.R.Cing=[0.3 1.8]; %Cingulate
Seeds.R.SS=[3.6 -0.15];  %Somatosenory
Seeds.R.P=[1.75 -1.85];  %Parietal
Seeds.R.Ret=[0.5 -2.1]; %Retrosplenial
Seeds.R.Aud=[4.2 -2.7]; %Auditory
Seeds.R.V=[2.4 -4];     %Visual

   

Seeds.L.Fr=[-1.3 3.3];
Seeds.L.M=[-1.5 2];
Seeds.L.Cing=[-0.3 1.8];
Seeds.L.SS=[-3.6 -0.15];
Seeds.L.P=[-1.75 -1.85];  %Parietal
Seeds.L.Ret=[-0.5 -2.1];
Seeds.L.Aud=[-4.2 -2.7];
Seeds.L.V=[-2.4 -4];


L.bregma=[0 0];
L.tent=[0 -3.9];
L.of=[0 3.525];

end

