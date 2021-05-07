close all;clear all;clc;
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat')
saveDir_cat = 'L:\RGECO\cat';
name_awake = '191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat';
name_anes = '191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc';

load(fullfile(saveDir_cat, name_awake),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice')

R_jrgeco1aCorr_ISA_mice_awake = R_jrgeco1aCorr_ISA_mice;
R_FADCorr_ISA_mice_awake = R_FADCorr_ISA_mice;
R_total_ISA_mice_awake = R_total_ISA_mice;


R_jrgeco1aCorr_Delta_mice_awake = R_jrgeco1aCorr_Delta_mice;
R_FADCorr_Delta_mice_awake = R_FADCorr_Delta_mice;
R_total_Delta_mice_awake = R_total_Delta_mice;

load(fullfile(saveDir_cat, name_anes),'R_total_ISA_mice','R_jrgeco1aCorr_ISA_mice','R_FADCorr_ISA_mice',...
    'R_total_Delta_mice','R_jrgeco1aCorr_Delta_mice','R_FADCorr_Delta_mice')


R_jrgeco1aCorr_ISA_mice_anes = R_jrgeco1aCorr_ISA_mice;
R_FADCorr_ISA_mice_anes = R_FADCorr_ISA_mice;
R_total_ISA_mice_anes = R_total_ISA_mice;


R_jrgeco1aCorr_Delta_mice_anes = R_jrgeco1aCorr_Delta_mice;
R_FADCorr_Delta_mice_anes = R_FADCorr_Delta_mice;
R_total_Delta_mice_anes = R_total_Delta_mice;

CingL_jrgeco1aCorr_ISA_awake = R_jrgeco1aCorr_ISA_mice_awake(:,:,5);
CingL_jrgeco1aCorr_ISA_awake(CingL_jrgeco1aCorr_ISA_awake>0.5) = 1;
CingL_jrgeco1aCorr_ISA_awake(CingL_jrgeco1aCorr_ISA_awake<0.5) = 0;
CingL_jrgeco1aCorr_ISA_awake(isnan(CingL_jrgeco1aCorr_ISA_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(CingL_jrgeco1aCorr_ISA_awake));
axis image off

CingL_jrgeco1aCorr_ISA_anes = R_jrgeco1aCorr_ISA_mice_anes(:,:,5);
CingL_jrgeco1aCorr_ISA_anes(CingL_jrgeco1aCorr_ISA_anes>0.5) = 1;
CingL_jrgeco1aCorr_ISA_anes(CingL_jrgeco1aCorr_ISA_anes<0.5) = 0;
CingL_jrgeco1aCorr_ISA_anes(isnan(CingL_jrgeco1aCorr_ISA_anes)) = 0;

similarity_CingL_jrgeco1aCorr_ISA_awake_anes = dice(CingL_jrgeco1aCorr_ISA_awake,...
    CingL_jrgeco1aCorr_ISA_anes);

CingL_FADCorr_ISA_awake = R_FADCorr_ISA_mice_awake(:,:,5);
CingL_FADCorr_ISA_awake(CingL_FADCorr_ISA_awake>0.5) = 1;
CingL_FADCorr_ISA_awake(CingL_FADCorr_ISA_awake<0.5) = 0;
CingL_FADCorr_ISA_awake(isnan(CingL_FADCorr_ISA_awake)) = 0;
similarity_CingL_FADCorr_ISA_awake_awake = dice(CingL_jrgeco1aCorr_ISA_awake,...
    CingL_FADCorr_ISA_awake);

CingL_FADCorr_ISA_anes = R_FADCorr_ISA_mice_anes(:,:,5);
CingL_FADCorr_ISA_anes(CingL_FADCorr_ISA_anes>0.5) = 1;
CingL_FADCorr_ISA_anes(CingL_FADCorr_ISA_anes<0.5) = 0;
CingL_FADCorr_ISA_anes(isnan(CingL_FADCorr_ISA_anes)) = 0;
similarity_CingL_FADCorr_ISA_anes_anes = dice(CingL_jrgeco1aCorr_ISA_awake,...
    CingL_FADCorr_ISA_anes);

CingL_total_ISA_awake = R_total_ISA_mice_awake(:,:,5);
CingL_total_ISA_awake(CingL_total_ISA_awake>0.5) = 1;
CingL_total_ISA_awake(CingL_total_ISA_awake<0.5) = 0;
CingL_total_ISA_awake(isnan(CingL_total_ISA_awake)) = 0;
similarity_CingL_total_ISA_awake_awake = dice(CingL_jrgeco1aCorr_ISA_awake,...
    CingL_total_ISA_awake);

CingL_total_ISA_anes = R_total_ISA_mice_anes(:,:,5);
CingL_total_ISA_anes(CingL_total_ISA_anes>0.5) = 1;
CingL_total_ISA_anes(CingL_total_ISA_anes<0.5) = 0;
CingL_total_ISA_anes(isnan(CingL_total_ISA_anes)) = 0;
similarity_CingL_total_ISA_anes_anes = dice(CingL_jrgeco1aCorr_ISA_awake,...
    CingL_total_ISA_anes);



ML_jrgeco1aCorr_ISA_awake = R_jrgeco1aCorr_ISA_mice_awake(:,:,3);
ML_jrgeco1aCorr_ISA_awake(ML_jrgeco1aCorr_ISA_awake>0.5) = 1;
ML_jrgeco1aCorr_ISA_awake(ML_jrgeco1aCorr_ISA_awake<0.5) = 0;
ML_jrgeco1aCorr_ISA_awake(isnan(ML_jrgeco1aCorr_ISA_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(ML_jrgeco1aCorr_ISA_awake));
axis image off

ML_jrgeco1aCorr_ISA_anes = R_jrgeco1aCorr_ISA_mice_anes(:,:,3);
ML_jrgeco1aCorr_ISA_anes(ML_jrgeco1aCorr_ISA_anes>0.5) = 1;
ML_jrgeco1aCorr_ISA_anes(ML_jrgeco1aCorr_ISA_anes<0.5) = 0;
ML_jrgeco1aCorr_ISA_anes(isnan(ML_jrgeco1aCorr_ISA_anes)) = 0;

similarity_ML_jrgeco1aCorr_ISA_awake_anes = dice(ML_jrgeco1aCorr_ISA_awake,...
    ML_jrgeco1aCorr_ISA_anes);

ML_FADCorr_ISA_awake = R_FADCorr_ISA_mice_awake(:,:,3);
ML_FADCorr_ISA_awake(ML_FADCorr_ISA_awake>0.5) = 1;
ML_FADCorr_ISA_awake(ML_FADCorr_ISA_awake<0.5) = 0;
ML_FADCorr_ISA_awake(isnan(ML_FADCorr_ISA_awake)) = 0;
similarity_ML_FADCorr_ISA_awake_awake = dice(ML_jrgeco1aCorr_ISA_awake,...
    ML_FADCorr_ISA_awake);

ML_FADCorr_ISA_anes = R_FADCorr_ISA_mice_anes(:,:,3);
ML_FADCorr_ISA_anes(ML_FADCorr_ISA_anes>0.5) = 1;
ML_FADCorr_ISA_anes(ML_FADCorr_ISA_anes<0.5) = 0;
ML_FADCorr_ISA_anes(isnan(ML_FADCorr_ISA_anes)) = 0;
similarity_ML_FADCorr_ISA_anes_anes = dice(ML_jrgeco1aCorr_ISA_awake,...
    ML_FADCorr_ISA_anes);

ML_total_ISA_awake = R_total_ISA_mice_awake(:,:,3);
ML_total_ISA_awake(ML_total_ISA_awake>0.5) = 1;
ML_total_ISA_awake(ML_total_ISA_awake<0.5) = 0;
ML_total_ISA_awake(isnan(ML_total_ISA_awake)) = 0;
similarity_ML_total_ISA_awake_awake = dice(ML_jrgeco1aCorr_ISA_awake,...
    ML_total_ISA_awake);

ML_total_ISA_anes = R_total_ISA_mice_anes(:,:,3);
ML_total_ISA_anes(ML_total_ISA_anes>0.5) = 1;
ML_total_ISA_anes(ML_total_ISA_anes<0.5) = 0;
ML_total_ISA_anes(isnan(ML_total_ISA_anes)) = 0;
similarity_ML_total_ISA_anes_anes = dice(ML_jrgeco1aCorr_ISA_awake,...
    ML_total_ISA_anes);



SSL_jrgeco1aCorr_ISA_awake = R_jrgeco1aCorr_ISA_mice_awake(:,:,7);
SSL_jrgeco1aCorr_ISA_awake(SSL_jrgeco1aCorr_ISA_awake>0.5) = 1;
SSL_jrgeco1aCorr_ISA_awake(SSL_jrgeco1aCorr_ISA_awake<0.5) = 0;
SSL_jrgeco1aCorr_ISA_awake(isnan(SSL_jrgeco1aCorr_ISA_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(SSL_jrgeco1aCorr_ISA_awake));
axis image off

SSL_jrgeco1aCorr_ISA_anes = R_jrgeco1aCorr_ISA_mice_anes(:,:,7);
SSL_jrgeco1aCorr_ISA_anes(SSL_jrgeco1aCorr_ISA_anes>0.5) = 1;
SSL_jrgeco1aCorr_ISA_anes(SSL_jrgeco1aCorr_ISA_anes<0.5) = 0;
SSL_jrgeco1aCorr_ISA_anes(isnan(SSL_jrgeco1aCorr_ISA_anes)) = 0;

similarity_SSL_jrgeco1aCorr_ISA_awake_anes = dice(SSL_jrgeco1aCorr_ISA_awake,...
    SSL_jrgeco1aCorr_ISA_anes);

SSL_FADCorr_ISA_awake = R_FADCorr_ISA_mice_awake(:,:,7);
SSL_FADCorr_ISA_awake(SSL_FADCorr_ISA_awake>0.5) = 1;
SSL_FADCorr_ISA_awake(SSL_FADCorr_ISA_awake<0.5) = 0;
SSL_FADCorr_ISA_awake(isnan(SSL_FADCorr_ISA_awake)) = 0;
similarity_SSL_FADCorr_ISA_awake_awake = dice(SSL_jrgeco1aCorr_ISA_awake,...
    SSL_FADCorr_ISA_awake);

SSL_FADCorr_ISA_anes = R_FADCorr_ISA_mice_anes(:,:,7);
SSL_FADCorr_ISA_anes(SSL_FADCorr_ISA_anes>0.5) = 1;
SSL_FADCorr_ISA_anes(SSL_FADCorr_ISA_anes<0.5) = 0;
SSL_FADCorr_ISA_anes(isnan(SSL_FADCorr_ISA_anes)) = 0;
similarity_SSL_FADCorr_ISA_anes_anes = dice(SSL_jrgeco1aCorr_ISA_awake,...
    SSL_FADCorr_ISA_anes);

SSL_total_ISA_awake = R_total_ISA_mice_awake(:,:,7);
SSL_total_ISA_awake(SSL_total_ISA_awake>0.5) = 1;
SSL_total_ISA_awake(SSL_total_ISA_awake<0.5) = 0;
SSL_total_ISA_awake(isnan(SSL_total_ISA_awake)) = 0;
similarity_SSL_total_ISA_awake_awake = dice(SSL_jrgeco1aCorr_ISA_awake,...
    SSL_total_ISA_awake);

SSL_total_ISA_anes = R_total_ISA_mice_anes(:,:,7);
SSL_total_ISA_anes(SSL_total_ISA_anes>0.5) = 1;
SSL_total_ISA_anes(SSL_total_ISA_anes<0.5) = 0;
SSL_total_ISA_anes(isnan(SSL_total_ISA_anes)) = 0;
similarity_SSL_total_ISA_anes_anes = dice(SSL_jrgeco1aCorr_ISA_awake,...
    SSL_total_ISA_anes);



RSL_jrgeco1aCorr_ISA_awake = R_jrgeco1aCorr_ISA_mice_awake(:,:,11);
RSL_jrgeco1aCorr_ISA_awake(RSL_jrgeco1aCorr_ISA_awake>0.5) = 1;
RSL_jrgeco1aCorr_ISA_awake(RSL_jrgeco1aCorr_ISA_awake<0.5) = 0;
RSL_jrgeco1aCorr_ISA_awake(isnan(RSL_jrgeco1aCorr_ISA_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(RSL_jrgeco1aCorr_ISA_awake));
axis image off

RSL_jrgeco1aCorr_ISA_anes = R_jrgeco1aCorr_ISA_mice_anes(:,:,11);
RSL_jrgeco1aCorr_ISA_anes(RSL_jrgeco1aCorr_ISA_anes>0.5) = 1;
RSL_jrgeco1aCorr_ISA_anes(RSL_jrgeco1aCorr_ISA_anes<0.5) = 0;
RSL_jrgeco1aCorr_ISA_anes(isnan(RSL_jrgeco1aCorr_ISA_anes)) = 0;

similarity_RSL_jrgeco1aCorr_ISA_awake_anes = dice(RSL_jrgeco1aCorr_ISA_awake,...
    RSL_jrgeco1aCorr_ISA_anes);

RSL_FADCorr_ISA_awake = R_FADCorr_ISA_mice_awake(:,:,11);
RSL_FADCorr_ISA_awake(RSL_FADCorr_ISA_awake>0.5) = 1;
RSL_FADCorr_ISA_awake(RSL_FADCorr_ISA_awake<0.5) = 0;
RSL_FADCorr_ISA_awake(isnan(RSL_FADCorr_ISA_awake)) = 0;
similarity_RSL_FADCorr_ISA_awake_awake = dice(RSL_jrgeco1aCorr_ISA_awake,...
    RSL_FADCorr_ISA_awake);

RSL_FADCorr_ISA_anes = R_FADCorr_ISA_mice_anes(:,:,11);
RSL_FADCorr_ISA_anes(RSL_FADCorr_ISA_anes>0.5) = 1;
RSL_FADCorr_ISA_anes(RSL_FADCorr_ISA_anes<0.5) = 0;
RSL_FADCorr_ISA_anes(isnan(RSL_FADCorr_ISA_anes)) = 0;
similarity_RSL_FADCorr_ISA_anes_anes = dice(RSL_jrgeco1aCorr_ISA_awake,...
    RSL_FADCorr_ISA_anes);

RSL_total_ISA_awake = R_total_ISA_mice_awake(:,:,11);
RSL_total_ISA_awake(RSL_total_ISA_awake>0.5) = 1;
RSL_total_ISA_awake(RSL_total_ISA_awake<0.5) = 0;
RSL_total_ISA_awake(isnan(RSL_total_ISA_awake)) = 0;
similarity_RSL_total_ISA_awake_awake = dice(RSL_jrgeco1aCorr_ISA_awake,...
    RSL_total_ISA_awake);

RSL_total_ISA_anes = R_total_ISA_mice_anes(:,:,11);
RSL_total_ISA_anes(RSL_total_ISA_anes>0.5) = 1;
RSL_total_ISA_anes(RSL_total_ISA_anes<0.5) = 0;
RSL_total_ISA_anes(isnan(RSL_total_ISA_anes)) = 0;
similarity_RSL_total_ISA_anes_anes = dice(RSL_jrgeco1aCorr_ISA_awake,...
    RSL_total_ISA_anes);


PL_jrgeco1aCorr_ISA_awake = R_jrgeco1aCorr_ISA_mice_awake(:,:,9);
PL_jrgeco1aCorr_ISA_awake(PL_jrgeco1aCorr_ISA_awake>0.5) = 1;
PL_jrgeco1aCorr_ISA_awake(PL_jrgeco1aCorr_ISA_awake<0.5) = 0;
PL_jrgeco1aCorr_ISA_awake(isnan(PL_jrgeco1aCorr_ISA_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(PL_jrgeco1aCorr_ISA_awake));
axis image off

PL_jrgeco1aCorr_ISA_anes = R_jrgeco1aCorr_ISA_mice_anes(:,:,9);
PL_jrgeco1aCorr_ISA_anes(PL_jrgeco1aCorr_ISA_anes>0.5) = 1;
PL_jrgeco1aCorr_ISA_anes(PL_jrgeco1aCorr_ISA_anes<0.5) = 0;
PL_jrgeco1aCorr_ISA_anes(isnan(PL_jrgeco1aCorr_ISA_anes)) = 0;
similarity_PL_jrgeco1aCorr_ISA_awake_anes = dice(PL_jrgeco1aCorr_ISA_awake,...
    PL_jrgeco1aCorr_ISA_anes);

PL_FADCorr_ISA_awake = R_FADCorr_ISA_mice_awake(:,:,9);
PL_FADCorr_ISA_awake(PL_FADCorr_ISA_awake>0.5) = 1;
PL_FADCorr_ISA_awake(PL_FADCorr_ISA_awake<0.5) = 0;
PL_FADCorr_ISA_awake(isnan(PL_FADCorr_ISA_awake)) = 0;
similarity_PL_FADCorr_ISA_awake_awake = dice(PL_jrgeco1aCorr_ISA_awake,...
    PL_FADCorr_ISA_awake);

PL_FADCorr_ISA_anes = R_FADCorr_ISA_mice_anes(:,:,9);
PL_FADCorr_ISA_anes(PL_FADCorr_ISA_anes>0.5) = 1;
PL_FADCorr_ISA_anes(PL_FADCorr_ISA_anes<0.5) = 0;
PL_FADCorr_ISA_anes(isnan(PL_FADCorr_ISA_anes)) = 0;
similarity_PL_FADCorr_ISA_anes_anes = dice(PL_jrgeco1aCorr_ISA_awake,...
    PL_FADCorr_ISA_anes);

PL_total_ISA_awake = R_total_ISA_mice_awake(:,:,9);
PL_total_ISA_awake(PL_total_ISA_awake>0.5) = 1;
PL_total_ISA_awake(PL_total_ISA_awake<0.5) = 0;
PL_total_ISA_awake(isnan(PL_total_ISA_awake)) = 0;
similarity_PL_total_ISA_awake_awake = dice(PL_jrgeco1aCorr_ISA_awake,...
    PL_total_ISA_awake);

PL_total_ISA_anes = R_total_ISA_mice_anes(:,:,9);
PL_total_ISA_anes(PL_total_ISA_anes>0.5) = 1;
PL_total_ISA_anes(PL_total_ISA_anes<0.5) = 0;
PL_total_ISA_anes(isnan(PL_total_ISA_anes)) = 0;
similarity_PL_total_ISA_anes_anes = dice(PL_jrgeco1aCorr_ISA_awake,...
    PL_total_ISA_anes);


VL_jrgeco1aCorr_ISA_awake = R_jrgeco1aCorr_ISA_mice_awake(:,:,15);
VL_jrgeco1aCorr_ISA_awake(VL_jrgeco1aCorr_ISA_awake>0.5) = 1;
VL_jrgeco1aCorr_ISA_awake(VL_jrgeco1aCorr_ISA_awake<0.5) = 0;
VL_jrgeco1aCorr_ISA_awake(isnan(VL_jrgeco1aCorr_ISA_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(VL_jrgeco1aCorr_ISA_awake));
axis image off

VL_jrgeco1aCorr_ISA_anes = R_jrgeco1aCorr_ISA_mice_anes(:,:,15);
VL_jrgeco1aCorr_ISA_anes(VL_jrgeco1aCorr_ISA_anes>0.5) = 1;
VL_jrgeco1aCorr_ISA_anes(VL_jrgeco1aCorr_ISA_anes<0.5) = 0;
VL_jrgeco1aCorr_ISA_anes(isnan(VL_jrgeco1aCorr_ISA_anes)) = 0;

similarity_VL_jrgeco1aCorr_ISA_awake_anes = dice(VL_jrgeco1aCorr_ISA_awake,...
    VL_jrgeco1aCorr_ISA_anes);

VL_FADCorr_ISA_awake = R_FADCorr_ISA_mice_awake(:,:,15);
VL_FADCorr_ISA_awake(VL_FADCorr_ISA_awake>0.5) = 1;
VL_FADCorr_ISA_awake(VL_FADCorr_ISA_awake<0.5) = 0;
VL_FADCorr_ISA_awake(isnan(VL_FADCorr_ISA_awake)) = 0;
similarity_VL_FADCorr_ISA_awake_awake = dice(VL_jrgeco1aCorr_ISA_awake,...
    VL_FADCorr_ISA_awake);

VL_FADCorr_ISA_anes = R_FADCorr_ISA_mice_anes(:,:,15);
VL_FADCorr_ISA_anes(VL_FADCorr_ISA_anes>0.5) = 1;
VL_FADCorr_ISA_anes(VL_FADCorr_ISA_anes<0.5) = 0;
VL_FADCorr_ISA_anes(isnan(VL_FADCorr_ISA_anes)) = 0;
similarity_VL_FADCorr_ISA_anes_anes = dice(VL_jrgeco1aCorr_ISA_awake,...
    VL_FADCorr_ISA_anes);

VL_total_ISA_awake = R_total_ISA_mice_awake(:,:,15);
VL_total_ISA_awake(VL_total_ISA_awake>0.5) = 1;
VL_total_ISA_awake(VL_total_ISA_awake<0.5) = 0;
VL_total_ISA_awake(isnan(VL_total_ISA_awake)) = 0;
similarity_VL_total_ISA_awake_awake = dice(VL_jrgeco1aCorr_ISA_awake,...
    VL_total_ISA_awake);

VL_total_ISA_anes = R_total_ISA_mice_anes(:,:,15);
VL_total_ISA_anes(VL_total_ISA_anes>0.5) = 1;
VL_total_ISA_anes(VL_total_ISA_anes<0.5) = 0;
VL_total_ISA_anes(isnan(VL_total_ISA_anes)) = 0;
similarity_VL_total_ISA_anes_anes = dice(VL_jrgeco1aCorr_ISA_awake,...
    VL_total_ISA_anes);







CingL_jrgeco1aCorr_Delta_awake = R_jrgeco1aCorr_Delta_mice_awake(:,:,5);
CingL_jrgeco1aCorr_Delta_awake(CingL_jrgeco1aCorr_Delta_awake>0.5) = 1;
CingL_jrgeco1aCorr_Delta_awake(CingL_jrgeco1aCorr_Delta_awake<0.5) = 0;
CingL_jrgeco1aCorr_Delta_awake(isnan(CingL_jrgeco1aCorr_Delta_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(CingL_jrgeco1aCorr_Delta_awake));
axis image off

CingL_jrgeco1aCorr_Delta_anes = R_jrgeco1aCorr_Delta_mice_anes(:,:,5);
CingL_jrgeco1aCorr_Delta_anes(CingL_jrgeco1aCorr_Delta_anes>0.5) = 1;
CingL_jrgeco1aCorr_Delta_anes(CingL_jrgeco1aCorr_Delta_anes<0.5) = 0;
CingL_jrgeco1aCorr_Delta_anes(isnan(CingL_jrgeco1aCorr_Delta_anes)) = 0;

similarity_CingL_jrgeco1aCorr_Delta_awake_anes = dice(CingL_jrgeco1aCorr_Delta_awake,...
    CingL_jrgeco1aCorr_Delta_anes);

CingL_FADCorr_Delta_awake = R_FADCorr_Delta_mice_awake(:,:,5);
CingL_FADCorr_Delta_awake(CingL_FADCorr_Delta_awake>0.5) = 1;
CingL_FADCorr_Delta_awake(CingL_FADCorr_Delta_awake<0.5) = 0;
CingL_FADCorr_Delta_awake(isnan(CingL_FADCorr_Delta_awake)) = 0;
similarity_CingL_FADCorr_Delta_awake_awake = dice(CingL_jrgeco1aCorr_Delta_awake,...
    CingL_FADCorr_Delta_awake);

CingL_FADCorr_Delta_anes = R_FADCorr_Delta_mice_anes(:,:,5);
CingL_FADCorr_Delta_anes(CingL_FADCorr_Delta_anes>0.5) = 1;
CingL_FADCorr_Delta_anes(CingL_FADCorr_Delta_anes<0.5) = 0;
CingL_FADCorr_Delta_anes(isnan(CingL_FADCorr_Delta_anes)) = 0;
similarity_CingL_FADCorr_Delta_anes_anes = dice(CingL_jrgeco1aCorr_Delta_awake,...
    CingL_FADCorr_Delta_anes);

CingL_total_Delta_awake = R_total_Delta_mice_awake(:,:,5);
CingL_total_Delta_awake(CingL_total_Delta_awake>0.5) = 1;
CingL_total_Delta_awake(CingL_total_Delta_awake<0.5) = 0;
CingL_total_Delta_awake(isnan(CingL_total_Delta_awake)) = 0;
similarity_CingL_total_Delta_awake_awake = dice(CingL_jrgeco1aCorr_Delta_awake,...
    CingL_total_Delta_awake);

CingL_total_Delta_anes = R_total_Delta_mice_anes(:,:,5);
CingL_total_Delta_anes(CingL_total_Delta_anes>0.5) = 1;
CingL_total_Delta_anes(CingL_total_Delta_anes<0.5) = 0;
CingL_total_Delta_anes(isnan(CingL_total_Delta_anes)) = 0;
similarity_CingL_total_Delta_anes_anes = dice(CingL_jrgeco1aCorr_Delta_awake,...
    CingL_total_Delta_anes);



ML_jrgeco1aCorr_Delta_awake = R_jrgeco1aCorr_Delta_mice_awake(:,:,3);
ML_jrgeco1aCorr_Delta_awake(ML_jrgeco1aCorr_Delta_awake>0.5) = 1;
ML_jrgeco1aCorr_Delta_awake(ML_jrgeco1aCorr_Delta_awake<0.5) = 0;
ML_jrgeco1aCorr_Delta_awake(isnan(ML_jrgeco1aCorr_Delta_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(ML_jrgeco1aCorr_Delta_awake));
axis image off

ML_jrgeco1aCorr_Delta_anes = R_jrgeco1aCorr_Delta_mice_anes(:,:,3);
ML_jrgeco1aCorr_Delta_anes(ML_jrgeco1aCorr_Delta_anes>0.5) = 1;
ML_jrgeco1aCorr_Delta_anes(ML_jrgeco1aCorr_Delta_anes<0.5) = 0;
ML_jrgeco1aCorr_Delta_anes(isnan(ML_jrgeco1aCorr_Delta_anes)) = 0;
similarity_ML_jrgeco1aCorr_Delta_awake_anes = dice(ML_jrgeco1aCorr_Delta_awake,...
    ML_jrgeco1aCorr_Delta_anes);

ML_FADCorr_Delta_awake = R_FADCorr_Delta_mice_awake(:,:,3);
ML_FADCorr_Delta_awake(ML_FADCorr_Delta_awake>0.5) = 1;
ML_FADCorr_Delta_awake(ML_FADCorr_Delta_awake<0.5) = 0;
ML_FADCorr_Delta_awake(isnan(ML_FADCorr_Delta_awake)) = 0;
similarity_ML_FADCorr_Delta_awake_awake = dice(ML_jrgeco1aCorr_Delta_awake,...
    ML_FADCorr_Delta_awake);

ML_FADCorr_Delta_anes = R_FADCorr_Delta_mice_anes(:,:,3);
ML_FADCorr_Delta_anes(ML_FADCorr_Delta_anes>0.5) = 1;
ML_FADCorr_Delta_anes(ML_FADCorr_Delta_anes<0.5) = 0;
ML_FADCorr_Delta_anes(isnan(ML_FADCorr_Delta_anes)) = 0;
similarity_ML_FADCorr_Delta_anes_anes = dice(ML_jrgeco1aCorr_Delta_awake,...
    ML_FADCorr_Delta_anes);

ML_total_Delta_awake = R_total_Delta_mice_awake(:,:,3);
ML_total_Delta_awake(ML_total_Delta_awake>0.5) = 1;
ML_total_Delta_awake(ML_total_Delta_awake<0.5) = 0;
ML_total_Delta_awake(isnan(ML_total_Delta_awake)) = 0;
similarity_ML_total_Delta_awake_awake = dice(ML_jrgeco1aCorr_Delta_awake,...
    ML_total_Delta_awake);

ML_total_Delta_anes = R_total_Delta_mice_anes(:,:,3);
ML_total_Delta_anes(ML_total_Delta_anes>0.5) = 1;
ML_total_Delta_anes(ML_total_Delta_anes<0.5) = 0;
ML_total_Delta_anes(isnan(ML_total_Delta_anes)) = 0;
similarity_ML_total_Delta_anes_anes = dice(ML_jrgeco1aCorr_Delta_awake,...
    ML_total_Delta_anes);



SSL_jrgeco1aCorr_Delta_awake = R_jrgeco1aCorr_Delta_mice_awake(:,:,7);
SSL_jrgeco1aCorr_Delta_awake(SSL_jrgeco1aCorr_Delta_awake>0.5) = 1;
SSL_jrgeco1aCorr_Delta_awake(SSL_jrgeco1aCorr_Delta_awake<0.5) = 0;
SSL_jrgeco1aCorr_Delta_awake(isnan(SSL_jrgeco1aCorr_Delta_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(SSL_jrgeco1aCorr_Delta_awake));
axis image off

SSL_jrgeco1aCorr_Delta_anes = R_jrgeco1aCorr_Delta_mice_anes(:,:,7);
SSL_jrgeco1aCorr_Delta_anes(SSL_jrgeco1aCorr_Delta_anes>0.5) = 1;
SSL_jrgeco1aCorr_Delta_anes(SSL_jrgeco1aCorr_Delta_anes<0.5) = 0;
SSL_jrgeco1aCorr_Delta_anes(isnan(SSL_jrgeco1aCorr_Delta_anes)) = 0;
similarity_SSL_jrgeco1aCorr_Delta_awake_anes = dice(SSL_jrgeco1aCorr_Delta_awake,...
    SSL_jrgeco1aCorr_Delta_anes);

SSL_FADCorr_Delta_awake = R_FADCorr_Delta_mice_awake(:,:,7);
SSL_FADCorr_Delta_awake(SSL_FADCorr_Delta_awake>0.5) = 1;
SSL_FADCorr_Delta_awake(SSL_FADCorr_Delta_awake<0.5) = 0;
SSL_FADCorr_Delta_awake(isnan(SSL_FADCorr_Delta_awake)) = 0;
similarity_SSL_FADCorr_Delta_awake_awake = dice(SSL_jrgeco1aCorr_Delta_awake,...
    SSL_FADCorr_Delta_awake);

SSL_FADCorr_Delta_anes = R_FADCorr_Delta_mice_anes(:,:,7);
SSL_FADCorr_Delta_anes(SSL_FADCorr_Delta_anes>0.5) = 1;
SSL_FADCorr_Delta_anes(SSL_FADCorr_Delta_anes<0.5) = 0;
SSL_FADCorr_Delta_anes(isnan(SSL_FADCorr_Delta_anes)) = 0;
similarity_SSL_FADCorr_Delta_anes_anes = dice(SSL_jrgeco1aCorr_Delta_awake,...
    SSL_FADCorr_Delta_anes);

SSL_total_Delta_awake = R_total_Delta_mice_awake(:,:,7);
SSL_total_Delta_awake(SSL_total_Delta_awake>0.5) = 1;
SSL_total_Delta_awake(SSL_total_Delta_awake<0.5) = 0;
SSL_total_Delta_awake(isnan(SSL_total_Delta_awake)) = 0;
similarity_SSL_total_Delta_awake_awake = dice(SSL_jrgeco1aCorr_Delta_awake,...
    SSL_total_Delta_awake);

SSL_total_Delta_anes = R_total_Delta_mice_anes(:,:,7);
SSL_total_Delta_anes(SSL_total_Delta_anes>0.5) = 1;
SSL_total_Delta_anes(SSL_total_Delta_anes<0.5) = 0;
SSL_total_Delta_anes(isnan(SSL_total_Delta_anes)) = 0;
similarity_SSL_total_Delta_anes_anes = dice(SSL_jrgeco1aCorr_Delta_awake,...
    SSL_total_Delta_anes);



RSL_jrgeco1aCorr_Delta_awake = R_jrgeco1aCorr_Delta_mice_awake(:,:,11);
RSL_jrgeco1aCorr_Delta_awake(RSL_jrgeco1aCorr_Delta_awake>0.5) = 1;
RSL_jrgeco1aCorr_Delta_awake(RSL_jrgeco1aCorr_Delta_awake<0.5) = 0;
RSL_jrgeco1aCorr_Delta_awake(isnan(RSL_jrgeco1aCorr_Delta_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(RSL_jrgeco1aCorr_Delta_awake));
axis image off

RSL_jrgeco1aCorr_Delta_anes = R_jrgeco1aCorr_Delta_mice_anes(:,:,11);
RSL_jrgeco1aCorr_Delta_anes(RSL_jrgeco1aCorr_Delta_anes>0.5) = 1;
RSL_jrgeco1aCorr_Delta_anes(RSL_jrgeco1aCorr_Delta_anes<0.5) = 0;
RSL_jrgeco1aCorr_Delta_anes(isnan(RSL_jrgeco1aCorr_Delta_anes)) = 0;

similarity_RSL_jrgeco1aCorr_Delta_awake_anes = dice(RSL_jrgeco1aCorr_Delta_awake,...
    RSL_jrgeco1aCorr_Delta_anes);

RSL_FADCorr_Delta_awake = R_FADCorr_Delta_mice_awake(:,:,11);
RSL_FADCorr_Delta_awake(RSL_FADCorr_Delta_awake>0.5) = 1;
RSL_FADCorr_Delta_awake(RSL_FADCorr_Delta_awake<0.5) = 0;
RSL_FADCorr_Delta_awake(isnan(RSL_FADCorr_Delta_awake)) = 0;
similarity_RSL_FADCorr_Delta_awake_awake = dice(RSL_jrgeco1aCorr_Delta_awake,...
    RSL_FADCorr_Delta_awake);

RSL_FADCorr_Delta_anes = R_FADCorr_Delta_mice_anes(:,:,11);
RSL_FADCorr_Delta_anes(RSL_FADCorr_Delta_anes>0.5) = 1;
RSL_FADCorr_Delta_anes(RSL_FADCorr_Delta_anes<0.5) = 0;
RSL_FADCorr_Delta_anes(isnan(RSL_FADCorr_Delta_anes)) = 0;
similarity_RSL_FADCorr_Delta_anes_anes = dice(RSL_jrgeco1aCorr_Delta_awake,...
    RSL_FADCorr_Delta_anes);

RSL_total_Delta_awake = R_total_Delta_mice_awake(:,:,11);
RSL_total_Delta_awake(RSL_total_Delta_awake>0.5) = 1;
RSL_total_Delta_awake(RSL_total_Delta_awake<0.5) = 0;
RSL_total_Delta_awake(isnan(RSL_total_Delta_awake)) = 0;
similarity_RSL_total_Delta_awake_awake = dice(RSL_jrgeco1aCorr_Delta_awake,...
    RSL_total_Delta_awake);

RSL_total_Delta_anes = R_total_Delta_mice_anes(:,:,11);
RSL_total_Delta_anes(RSL_total_Delta_anes>0.5) = 1;
RSL_total_Delta_anes(RSL_total_Delta_anes<0.5) = 0;
RSL_total_Delta_anes(isnan(RSL_total_Delta_anes)) = 0;
similarity_RSL_total_Delta_anes_anes = dice(RSL_jrgeco1aCorr_Delta_awake,...
    RSL_total_Delta_anes);


PL_jrgeco1aCorr_Delta_awake = R_jrgeco1aCorr_Delta_mice_awake(:,:,9);
PL_jrgeco1aCorr_Delta_awake(PL_jrgeco1aCorr_Delta_awake>0.5) = 1;
PL_jrgeco1aCorr_Delta_awake(PL_jrgeco1aCorr_Delta_awake<0.5) = 0;
PL_jrgeco1aCorr_Delta_awake(isnan(PL_jrgeco1aCorr_Delta_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(PL_jrgeco1aCorr_Delta_awake));
axis image off

PL_jrgeco1aCorr_Delta_anes = R_jrgeco1aCorr_Delta_mice_anes(:,:,9);
PL_jrgeco1aCorr_Delta_anes(PL_jrgeco1aCorr_Delta_anes>0.5) = 1;
PL_jrgeco1aCorr_Delta_anes(PL_jrgeco1aCorr_Delta_anes<0.5) = 0;
PL_jrgeco1aCorr_Delta_anes(isnan(PL_jrgeco1aCorr_Delta_anes)) = 0;
similarity_PL_jrgeco1aCorr_Delta_awake_anes = dice(PL_jrgeco1aCorr_Delta_awake,...
    PL_jrgeco1aCorr_Delta_anes);

PL_FADCorr_Delta_awake = R_FADCorr_Delta_mice_awake(:,:,9);
PL_FADCorr_Delta_awake(PL_FADCorr_Delta_awake>0.5) = 1;
PL_FADCorr_Delta_awake(PL_FADCorr_Delta_awake<0.5) = 0;
PL_FADCorr_Delta_awake(isnan(PL_FADCorr_Delta_awake)) = 0;
similarity_PL_FADCorr_Delta_awake_awake = dice(PL_jrgeco1aCorr_Delta_awake,...
    PL_FADCorr_Delta_awake);

PL_FADCorr_Delta_anes = R_FADCorr_Delta_mice_anes(:,:,9);
PL_FADCorr_Delta_anes(PL_FADCorr_Delta_anes>0.5) = 1;
PL_FADCorr_Delta_anes(PL_FADCorr_Delta_anes<0.5) = 0;
PL_FADCorr_Delta_anes(isnan(PL_FADCorr_Delta_anes)) = 0;
similarity_PL_FADCorr_Delta_anes_anes = dice(PL_jrgeco1aCorr_Delta_awake,...
    PL_FADCorr_Delta_anes);

PL_total_Delta_awake = R_total_Delta_mice_awake(:,:,9);
PL_total_Delta_awake(PL_total_Delta_awake>0.5) = 1;
PL_total_Delta_awake(PL_total_Delta_awake<0.5) = 0;
PL_total_Delta_awake(isnan(PL_total_Delta_awake)) = 0;
similarity_PL_total_Delta_awake_awake = dice(PL_jrgeco1aCorr_Delta_awake,...
    PL_total_Delta_awake);

PL_total_Delta_anes = R_total_Delta_mice_anes(:,:,9);
PL_total_Delta_anes(PL_total_Delta_anes>0.5) = 1;
PL_total_Delta_anes(PL_total_Delta_anes<0.5) = 0;
PL_total_Delta_anes(isnan(PL_total_Delta_anes)) = 0;
similarity_PL_total_Delta_anes_anes = dice(PL_jrgeco1aCorr_Delta_awake,...
    PL_total_Delta_anes);


VL_jrgeco1aCorr_Delta_awake = R_jrgeco1aCorr_Delta_mice_awake(:,:,15);
VL_jrgeco1aCorr_Delta_awake(VL_jrgeco1aCorr_Delta_awake>0.5) = 1;
VL_jrgeco1aCorr_Delta_awake(VL_jrgeco1aCorr_Delta_awake<0.5) = 0;
VL_jrgeco1aCorr_Delta_awake(isnan(VL_jrgeco1aCorr_Delta_awake)) = 0;

figure
imagesc(xform_WL,'AlphaData',1-logical(VL_jrgeco1aCorr_Delta_awake));
axis image off

VL_jrgeco1aCorr_Delta_anes = R_jrgeco1aCorr_Delta_mice_anes(:,:,15);
VL_jrgeco1aCorr_Delta_anes(VL_jrgeco1aCorr_Delta_anes>0.5) = 1;
VL_jrgeco1aCorr_Delta_anes(VL_jrgeco1aCorr_Delta_anes<0.5) = 0;
VL_jrgeco1aCorr_Delta_anes(isnan(VL_jrgeco1aCorr_Delta_anes)) = 0;
similarity_VL_jrgeco1aCorr_Delta_awake_anes = dice(VL_jrgeco1aCorr_Delta_awake,...
    VL_jrgeco1aCorr_Delta_anes);

VL_FADCorr_Delta_awake = R_FADCorr_Delta_mice_awake(:,:,15);
VL_FADCorr_Delta_awake(VL_FADCorr_Delta_awake>0.5) = 1;
VL_FADCorr_Delta_awake(VL_FADCorr_Delta_awake<0.5) = 0;
VL_FADCorr_Delta_awake(isnan(VL_FADCorr_Delta_awake)) = 0;
similarity_VL_FADCorr_Delta_awake_awake = dice(VL_jrgeco1aCorr_Delta_awake,...
    VL_FADCorr_Delta_awake);

VL_FADCorr_Delta_anes = R_FADCorr_Delta_mice_anes(:,:,15);
VL_FADCorr_Delta_anes(VL_FADCorr_Delta_anes>0.5) = 1;
VL_FADCorr_Delta_anes(VL_FADCorr_Delta_anes<0.5) = 0;
VL_FADCorr_Delta_anes(isnan(VL_FADCorr_Delta_anes)) = 0;
similarity_VL_FADCorr_Delta_anes_anes = dice(VL_jrgeco1aCorr_Delta_awake,...
    VL_FADCorr_Delta_anes);

VL_total_Delta_awake = R_total_Delta_mice_awake(:,:,15);
VL_total_Delta_awake(VL_total_Delta_awake>0.5) = 1;
VL_total_Delta_awake(VL_total_Delta_awake<0.5) = 0;
VL_total_Delta_awake(isnan(VL_total_Delta_awake)) = 0;
similarity_VL_total_Delta_awake_awake = dice(VL_jrgeco1aCorr_Delta_awake,...
    VL_total_Delta_awake);

VL_total_Delta_anes = R_total_Delta_mice_anes(:,:,15);
VL_total_Delta_anes(VL_total_Delta_anes>0.5) = 1;
VL_total_Delta_anes(VL_total_Delta_anes<0.5) = 0;
VL_total_Delta_anes(isnan(VL_total_Delta_anes)) = 0;
similarity_VL_total_Delta_anes_anes = dice(VL_jrgeco1aCorr_Delta_awake,...
    VL_total_Delta_anes);







