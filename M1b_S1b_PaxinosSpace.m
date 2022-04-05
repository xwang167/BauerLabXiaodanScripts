function [Seeds, L]=M1b_S1b_PaxinosSpace

%These are the atlas coordinates of our seed locations

%% Seeds (x,y), R=Right, L=Left
Seeds.R.M1b = [1.1 1.4]  ;% primary motor barrel
Seeds.R.S1b = [3.2 -0.5] ; % primary somatosensory barrel

Seeds.L.M1b = [-1.1 1.4]  ;% primary motor barrel
Seeds.L.S1b = [-3.2 -0.5] ; % primary somatosensory barrel

L.bregma=[0 0];
L.tent=[0 -3.9];
L.of=[0 3.525];

end