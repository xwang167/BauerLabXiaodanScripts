function [datafluor, datafluorCorr,op_in, E_in, op_out, E_out] = procFluorCorr(filename,sessionInfo,datahb)
[raw]=readtiff(filename);
muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
datafluor = squeeze(raw(:,:,sessionInfo.fluorSpecies,:));
datafluor = mouse.expSpecific.procFluor(datafluor,baselineValues(:,:,sessionInfo.fluorSpecies));
[op_in, E_in] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.fluorSpecies)));
[op_out, E_out] = getHbOpticalProperties_xw(muspFcn,fullfile(fluorDir,sessionInfo.fluorEmissionFile));

dpIn = op_in.dpf/2;
dpOut = op_out.dpf/2;

datafluorCorr = correctHb_differentBeta(datafluor,datahb,[E_in(1) E_out(1)],[E_in(2) E_out(2)],dpIn,dpOut,0.7,0.8);
datafluorCorr = process.smoothImage(datafluorCorr,systemInfo.gbox,systemInfo.gsigma);
datafluor = process.smoothImage(datafluor,systemInfo.gbox,systemInfo.gsigma);