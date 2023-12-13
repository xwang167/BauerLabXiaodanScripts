import mouse.*
sessionInfo.fluorEmissionFile = "jrgeco1a_emission.txt";

sessionInfo.FADEmissionFile = "fad_emission.txt";
systemInfo.LEDFiles = [
    "TwoCam_Mightex470_BP_Pol.txt",...
    "TwoCam_Mightex525_BP_Pol.txt",...
    "TwoCam_Mightex525_BP_Pol_500-580.txt", ...
    "TwoCam_TL625_Pol_Longer593.txt"];
muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
sessionInfo.FADspecies = 1;
sessionInfo.fluorSpecies = 2;
pkgDir = what('bauerParams');
fluorDir = fullfile(pkgDir.path,'probeSpectra');
[op_in_FAD, E_in_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.FADspecies)));
[op_out_FAD, E_out_FAD] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.FADEmissionFile));

[op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
[op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));

% awake
load('X:\RGECO\Data\190627-R5M2285-fc1_processed.mat', 'xform_FAD', 'xform_jrgeco1a','xform_datahb')
xform_FAD_awake = xform_FAD;
clear xform_FAD
xform_jrgeco1a_awake = xform_jrgeco1a;
clear xform_jrgeco1a
xform_datahb_awake = xform_datahb;
clear xform_datahb

dpIn_FAD = op_in_FAD.dpf/2;
dpOut_FAD = op_out_FAD.dpf/2;

xform_FADCorr_awake = mouse.physics.correctHb(xform_FAD_awake,xform_datahb_awake,...
    [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);

dpIn = op_in.dpf/2;
dpOut = op_out.dpf/2;

xform_jrgeco1aCorr_awake = mouse.physics.correctHb(xform_jrgeco1a_awake,xform_datahb_awake,...
    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
xform_datahb_awake(isnan(xform_datahb_awake)) = 0;
xform_datahb_awake_lpf = lowpass(xform_datahb_awake,1,25);
xform_jrgeco1aCorr_awake_lpf = mouse.physics.correctHb(xform_jrgeco1a_awake,xform_datahb_awake_lpf,...
    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);
[Pxx_jrgeco1a_awake,hz] = pwelch(squeeze(xform_jrgeco1a_awake(83,22,:)),[],[],[],25);
[Pxx_jrgeco1aCorr_awake,hz] = pwelch(squeeze(xform_jrgeco1aCorr_awake(83,22,:)),[],[],[],25);
[Pxx_jrgeco1aCorr_awake_lpf,hz] = pwelch(squeeze(xform_jrgeco1aCorr_awake_lpf(83,22,:)),[],[],[],25);
[Pxx_HbO_awake,hz] = pwelch(squeeze(xform_datahb_awake(83,22,1,:)),[],[],[],25);
[Pxx_HbR_awake,hz] = pwelch(squeeze(xform_datahb_awake(83,22,2,:)),[],[],[],25);
figure
subplot(221)
loglog(hz,Pxx_jrgeco1a_awake,'r')
hold on
loglog(hz,Pxx_jrgeco1aCorr_awake,'b')
legend('Raw jRGECO1a','Corrected jRGECO1a with unfiltered xform\_datahb',...
    'location','southwest')
xlim([0.01 10])
xlabel('Frequency(Hz)')
ylabel('jRGECO1a(\DeltaF/F)')
subplot(222)
loglog(hz,Pxx_jrgeco1a_awake,'r')
hold on
loglog(hz,Pxx_jrgeco1aCorr_awake_lpf,'k')
legend('Raw jRGECO1a','Corrected jRGECO1a with filtered xform\_datahb',...
    'location','southwest')
xlim([0.01 10])
xlabel('Frequency(Hz)')
ylabel('jRGECO1a(\DeltaF/F)')
subplot(223)
loglog(hz,Pxx_jrgeco1aCorr_awake,'b')
hold on
loglog(hz,Pxx_jrgeco1aCorr_awake_lpf,'k')
legend('Corrected jRGECO1a with unfiltered xform\_datahb','Corrected jRGECO1a with filtered xform\_datahb',...
    'location','southwest')
xlim([0.01 10])
xlabel('Frequency(Hz)')
ylabel('jRGECO1a(\DeltaF/F)')
subplot(224)
loglog(hz,Pxx_jrgeco1a_awake,'r')
hold on
loglog(hz,Pxx_jrgeco1aCorr_awake,'b')
hold on
loglog(hz,Pxx_jrgeco1aCorr_awake_lpf,'k')
hold on
loglog(hz,Pxx_HbO_awake,'m')
hold on
loglog(hz,Pxx_HbR_awake,'c')
legend('Raw jRGECO1a','Corrected jRGECO1a with unfiltered xform\_datahb','Corrected jRGECO1a with filtered xform\_datahb','unfiltered HbO','unfitlered HbR',...
    'location','southwest')
xlim([0.01 10])
xlabel('Frequency(Hz)')
ylabel('jRGECO1a(\DeltaF/F)')
ylim([10^-18 1])
% anesthetized
load('X:\RGECO\Data\190707-R5M2286-anes-fc1_processed.mat', 'xform_FAD', 'xform_datahb', 'xform_jrgeco1a')
xform_FAD_anes = xform_FAD;
clear xform_FAD
xform_jrgeco1a_anes = xform_jrgeco1a;
clear xform_jrgeco1a
xform_datahb_anes = xform_datahb;
clear xform_datahb
xform_FADCorr_anes = mouse.physics.correctHb(xform_FAD_anes,xform_datahb_anes,...
    [E_in_FAD(1) E_out_FAD(1)],[E_in_FAD(2) E_out_FAD(2)],dpIn_FAD,dpOut_FAD);

xform_jrgeco1aCorr_anes = mouse.physics.correctHb(xform_jrgeco1a_anes,xform_datahb_anes,...
    [E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut);

%% Powermap+fc
sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
sessionInfo.bandtype_Delta = {"Delta",0.4,4};
refseeds=GetReferenceSeeds;
sessionInfo.framerate = 25;
load('190627-R5M2285-fc1-dataFluor.mat', 'xform_isbrain')
saveDir = "X:\RGECO\Data\"
visName = "190627-R5M2285-fc1";
% power map for correction with filtered datahb ISA
jrgeco1aCorr_ISA_powerMap_awake_lpf = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_awake_lpf)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
FADCorr_ISA_powerMap_awake_lpf      = QCcheck_CalcPowerMap(double(xform_FADCorr_awake_lpf)/0.01,     sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);

QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_awake_lpf,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOCorrISA_FilteredCorrection'))
QCcheck_powerMapVis(FADCorr_ISA_powerMap_awake_lpf,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADCorrISA_FilteredCorrection'))

% fc for correction with filtered datahb ISA
[R_jrgeco1aCorr_ISA_awake_lpf,Rs_jrgeco1aCorr_ISA_awake_lpf] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_awake_lpf)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
[R_FADCorr_ISA_awake_lpf,Rs_FADCorr_ISA_awake_lpf]           = QCcheck_CalcRRs(refseeds,double(xform_FADCorr_awake_lpf)/0.01,     sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);

QCcheck_fcVis(refseeds,R_jrgeco1aCorr_ISA_awake_lpf, Rs_jrgeco1aCorr_ISA_awake_lpf,'jrgeco1aCorr','m','ISA',saveDir,visName,false,xform_isbrain)
QCcheck_fcVis(refseeds,R_FADCorr_ISA, Rs_FADCorr_ISA,'FADCorr','g','ISA',saveDir,visName,false,xform_isbrain)

% powermap for correction with unfiltered datahb ISA
jrgeco1aCorr_ISA_powerMap_awake = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_awake)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);
FADCorr_ISA_powerMap_awake     = QCcheck_CalcPowerMap(double(xform_FADCorr_awake)/0.01,     sessionInfo.framerate,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}]);

QCcheck_powerMapVis(jrgeco1aCorr_ISA_powerMap_awake,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOCorrISA_NoFilteredCorrection'))
QCcheck_powerMapVis(FADCorr_ISA_powerMap_awake,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADCorrISA_NoFilteredCorrection'))

% fc for correction with unfiltered datahb ISA
[R_jrgeco1aCorr_ISA_awake,Rs_jrgeco1aCorr_ISA_awake] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_awake)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);
[R_FADCorr_ISA_awake,Rs_FADCorr_ISA_awake]           = QCcheck_CalcRRs(refseeds,double(xform_FADCorr_awake)/0.01,     sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_ISA{2},sessionInfo.bandtype_ISA{3}],true);

% power map for correction with filtered datahb Delta
jrgeco1aCorr_Delta_powerMap_awake_lpf = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_awake_lpf)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
FADCorr_Delta_powerMap_awake_lpf      = QCcheck_CalcPowerMap(double(xform_FADCorr_awake_lpf)/0.01,     sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);

QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_awake_lpf,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOCorrDelta_FilteredCorrection'))
QCcheck_powerMapVis(FADCorr_Delta_powerMap_awake_lpf,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADCorrDelta_FilteredCorrection'))

% fc for correction with filtered datahb Delta
[R_jrgeco1aCorr_Delta_awake_lpf,Rs_jrgeco1aCorr_Delta_awake_lpf] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_awake_lpf)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
[R_FADCorr_Delta_awake_lpf,Rs_FADCorr_Delta_awake_lpf]           = QCcheck_CalcRRs(refseeds,double(xform_FADCorr_awake_lpf)/0.01,     sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);

% powermap for correction with unfiltered datahb Delta
jrgeco1aCorr_Delta_powerMap_awake = QCcheck_CalcPowerMap(double(xform_jrgeco1aCorr_awake)/0.01,sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);
FADCorr_Delta_powerMap_awake     = QCcheck_CalcPowerMap(double(xform_FADCorr_awake)/0.01,     sessionInfo.framerate,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}]);

QCcheck_powerMapVis(jrgeco1aCorr_Delta_powerMap_awake,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_RGECOCorrDelta_NoFilteredCorrection'))
QCcheck_powerMapVis(FADCorr_Delta_powerMap_awake,xform_isbrain,'(\DeltaF/F%)',saveDir,strcat(visName, '_FADCorrDelta_NoFilteredCorrection'))

% fc for correction with unfiltered datahb Delta
[R_jrgeco1aCorr_Delta_awake,Rs_jrgeco1aCorr_Delta_awake] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_awake)/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);
[R_FADCorr_Delta_awake,Rs_FADCorr_Delta_awake]           = QCcheck_CalcRRs(refseeds,double(xform_FADCorr_awake)/0.01,     sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],true);



%% NVC+NMC