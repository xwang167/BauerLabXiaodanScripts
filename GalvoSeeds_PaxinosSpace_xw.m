function [Seeds, L]=GalvoSeeds_PaxinosSpace_xw

%These are the atlas coordinates of our seed locations

%% Seeds (x,y), R=Right, L=Left

Seeds.R.Fr=[1.3 3.1];           %Frontal
Seeds.R.Cing=[0.3 1.8];         %Cingulate
Seeds.R.M=[1.1 1.1];            %Motor
Seeds.R.SS=[2.65 -0.5];         %Somatosenory
Seeds.R.P1=[1.45 -1.95];        %Parietal 1
Seeds.R.Ret=[0.5 -2.1];         %Retrosplenial
Seeds.R.P2=[2.8 -2.3];          %Parietal 2
Seeds.R.V=[2.4 -4];             %Visual
Seeds.R.Barrel = [3.2 -0.5];    %Barrel

Seeds.L.Fr=[-1.3 3.1];
Seeds.L.Cing=[-0.3 1.8];
Seeds.L.M=[-1.1 1.1];
Seeds.L.SS=[-2.65 -0.5];
Seeds.L.P1=[-1.45 -1.95];     %Parietal 2
Seeds.L.Ret=[-0.5 -2.1];
Seeds.L.P2=[-2.8 -2.3];     %Parietal 1
Seeds.L.V=[-2.4 -4];
Seeds.L.Barrel = [-3.2 -0.5];    %Barrel
L.bregma=[0 0];
L.tent=[0 -3.9];
L.of=[0 3.525];

end