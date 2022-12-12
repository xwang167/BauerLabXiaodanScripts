samplingRate = 25;
freq = 250;
%load
load('190710-R5M2285-anes-fc2_processed.mat', 'xform_FADCorr')
load('190710-R5M2285-anes-fc2_processed.mat', 'xform_jrgeco1aCorr')
load('190710-R5M2285-anes-fc2_processed.mat', 'xform_isbrain')
load('C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\noVasculatureMask.mat','mask_new');
mask = mask_new.*xform_isbrain;

%Convert to percentage change
Calcium = xform_jrgeco1aCorr*100;
clear xform_jrgeco1aCorr
% make it full 10 min
Calcium(:,:,end+1) = Calcium(:,:,end);
FAD = xform_FADCorr*100;
clear xform_FADCorr
% make it full 10 min 
FAD(:,:,end+1) = FAD(:,:,end);
% makes pixels outside of mask to be 0
mask_matrix = repmat(mask,1,1,size(Calcium,3));
FAD = FAD.*mask_matrix;
Calcium = Calcium.*mask_matrix;

%Smooth
gBox = 20;
gSigma = 10;
FAD_smooth = smoothImage(FAD,gBox,gSigma);
Calcium_smooth = smoothImage(Calcium,gBox,gSigma);

%Filter
FAD_smooth_filter = filterData(FAD_smooth,0.01,5,samplingRate);
Calcium_smooth_filter = filterData(Calcium_smooth,0.01,5,samplingRate);

% Resample
FAD_smooth_filter_resample = resample(FAD_smooth_filter,freq,samplingRate,'Dimension',3);
Calcium_smooth_filter_resample = resample(Calcium_smooth_filter,freq,samplingRate,'Dimension',3);

% Filter again
FAD_smooth_filter_resample_filter = filterData(FAD_smooth_filter_resample,0.01,5,samplingRate);
Calcium_smooth_filter_resample_filter = filterData(Calcium_smooth_filter_resample,0.01,5,samplingRate);
