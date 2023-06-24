
%%awake
FAD_ISA_awake = [0.50 0.81 0.76 0.61 0.66 0.8];
FAD_delta_awake = [0.18,0.1,0.44,0.057,0.17,0.10];

HbT_ISA_awake = [0.44 0.87 0.83 0.71 0.76 0.83];
HbT_delta_awake = [0.7,0.73,0.65,0.56,0.54];
%%anes
calcium_ISA_anes = [0.55 0.57 0.68 0.81 0.82 0.94];
calcium_delta_anes = [0.56 0.48 0.42 0.59 0.58 0.57];
FAD_ISA_anes = [0.50 0.81 0.76 0.61 0.66 0.8];
FAD_delta_anes = [0.54,0.64,0.66,0.74,0.73,0.81];
HbT_ISA_anes = [0.11 0.76 0.73 0.39 0.40 0.62];
HbT_delta_anes = [0.51 0.50 0.55 0.33 0.58 0.54];






[h, p]=ttest2(HbT_delta_awake, HbT_delta_anes, 0.05, 'both', 'unequal');

[h, p]=ttest2(HbT_ISA_anes, HbT_delta_anes, 0.05, 'both', 'unequal');


[h, p]=ttest2(FAD_ISA_anes, FAD_delta_anes, 0.05, 'both', 'unequal');

[h, p]=ttest2(calcium_ISA_anes, calcium_delta_anes, 0.05, 'both', 'unequal')

[h, p]=ttest2(calcium_delta_anes, HbT_delta_anes, 0.05, 'both', 'unequal');
[h, p]=ttest2(FAD_delta_awake, HbT_delta_awake, 0.05, 'both', 'unequal');
[h, p]=ttest2(FAD_ISA_awake, HbT_ISA_awake, 0.05, 'both', 'unequal');

 
[h, p]=ttest2(FAD_ISA_awake, HbT_ISA_awake, 0.05, 'both', 'unequal');
[h, p]=ttest2(FAD_delta_awake, FAD_delta_anes, 0.05, 'both', 'unequal');



[h, p]=ttest2(FAD_ISA_anes, HbT_ISA_anes, 0.05, 'both', 'unequal');
[h, p]=ttest2(FAD_ISA_anes, calcium_ISA_anes, 0.05, 'both', 'unequal');
[h, p]=ttest2(HbT_ISA_anes, calcium_ISA_anes, 0.05, 'both', 'unequal');

[h, p]=ttest2(HBT_ISA_awake, HbT_Delta_awake, 0.05, 'both', 'unequal');
[h, p]=ttest2(FAD_delta_awake, FAD_delta_anes, 0.05, 'both', 'unequal')