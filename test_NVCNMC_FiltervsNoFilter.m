clear ;close all;clc

startInd = 2;
freqLow = 0.02;
calMax = 8;
hbMax  = 2.5;
FADMax = 1;
hrfMax = 0.007;
mrfMax = 0.0015;
samplingRate = 25;
freq_new     = 250;
lambda_HRF = 5e-7;
lambda_MRF = 5e-7;
t_kernel = 30;
t = (-3*freq_new :(t_kernel-3)*freq_new-1)/freq_new;
load("C:\Users\Xiaodan Wang\Documents\GitHub\BauerLabXiaodanScripts\AtlasandIsbrain_Allen.mat",'parcelnames','AtlasSeeds')

mask = AtlasSeeds;
load('E:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_jrgeco1aCorr','xform_datahb','xform_FADCorr')

% mask within brain
HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
clear xform_datahb
FAD = xform_FADCorr*100;
clear xform_FADCorr
Calcium = squeeze(xform_jrgeco1aCorr)*100; % convert to DeltaF/F%
clear xform_jrgeco1aCorr
% Pad one more frame to full 10 mins
HbT    (:,:,end+1) = HbT    (:,:,end);
FAD    (:,:,end+1) = FAD    (:,:,end);
Calcium(:,:,end+1) = Calcium(:,:,end);
% Filter 0.02-2Hz, downsample to 10 Hz
HbT_filter     = filterData(HbT,    freqLow,2,samplingRate);
FAD_filter     = filterData(FAD,    freqLow,2,samplingRate);
Calcium_filter = filterData(Calcium,freqLow,2,samplingRate);

% Reshape into 30 seconds
HbT     = reshape(HbT    ,128,128,t_kernel*samplingRate,[]);
FAD     = reshape(FAD    ,128,128,t_kernel*samplingRate,[]);
Calcium = reshape(Calcium,128,128,t_kernel*samplingRate,[]);

HbT_filter     = reshape(HbT_filter    ,128,128,t_kernel*samplingRate,[]);
FAD_filter     = reshape(FAD_filter    ,128,128,t_kernel*samplingRate,[]);
Calcium_filter = reshape(Calcium_filter,128,128,t_kernel*samplingRate,[]);

% Initialization
ii = 4;
% reshape for each window
HbT_temp     = reshape(HbT    (:,:,:,ii),128*128,[]);
FAD_temp     = reshape(FAD    (:,:,:,ii),128*128,[]);
Calcium_temp = reshape(Calcium(:,:,:,ii),128*128,[]);
clear HbT FAD Calcium

HbT_filter_temp     = reshape(HbT_filter     (:,:,:,ii),128*128,[]);
FAD_filter_temp     = reshape(FAD_filter     (:,:,:,ii),128*128,[]);
Calcium_filter_temp = reshape(Calcium_filter (:,:,:,ii),128*128,[]);
clear HbT_filter FAD_filter Calcium_filter 


% upsample to 250 Hz
HbT_resample     = resample(HbT_temp    ,freq_new,samplingRate,'Dimension',2);
FAD_resample     = resample(FAD_temp    ,freq_new,samplingRate,'Dimension',2);
Calcium_resample = resample(Calcium_temp,freq_new,samplingRate,'Dimension',2);

HbT_resample_filter     = resample(HbT_filter_temp    ,freq_new,samplingRate,'Dimension',2);
FAD_resample_filter     = resample(FAD_filter_temp    ,freq_new,samplingRate,'Dimension',2);
Calcium_resample_filter = resample(Calcium_filter_temp,freq_new,samplingRate,'Dimension',2);

%% Calculate HRF and MRF

region = 7;
% Mean signal inside of the regional mask
mask_region = zeros(128,128);
mask_region(mask == region) = 1;
mask_region = logical(mask_region);

HbT_region     = mean(HbT_resample    (mask_region(:),:));
FAD_region     = mean(FAD_resample    (mask_region(:),:));
Calcium_region = mean(Calcium_resample(mask_region(:),:));

HbT_region_filter     = mean(HbT_resample_filter    (mask_region(:),:));
FAD_region_filter     = mean(FAD_resample_filter    (mask_region(:),:));
Calcium_region_filter = mean(Calcium_resample_filter(mask_region(:),:));

% starting point to be zero
HbT_region     = tukeywin(length(HbT_region)    ,.3).*squeeze(HbT_region'    );
FAD_region     = tukeywin(length(FAD_region)    ,.3).*squeeze(FAD_region'    );
Calcium_region = tukeywin(length(Calcium_region),.3).*squeeze(Calcium_region');

HbT_region_filter     = tukeywin(length(HbT_region_filter)    ,.3).*squeeze(HbT_region_filter'    );
FAD_region_filter     = tukeywin(length(FAD_region_filter)    ,.3).*squeeze(FAD_region_filter'    );
Calcium_region_filter = tukeywin(length(Calcium_region_filter),.3).*squeeze(Calcium_region_filter');


X = convmtx(Calcium_region,length(Calcium_region));
X_filter = convmtx(Calcium_region_filter,length(Calcium_region_filter));

% make it square
X = X(1:length(Calcium_region),1:length(Calcium_region));
X_filter = X_filter(1:length(Calcium_region_filter),1:length(Calcium_region_filter));

[~,S,~]=svd(X);
[~,S_filter,~]=svd(X_filter);
% Least square deconvolution

lambda_HRF = 0.000005;
HRF= (X'*S*X+(S(1,1).^2)*lambda_HRF*eye(length(Calcium_region))) \ (X'*S*[zeros(3*freq_new,1); HbT_region(1:end-3*freq_new)]);% add 3s of zeros
MRF= (X'*S*X+(S(1,1).^2)*lambda_MRF*eye(length(Calcium_region))) \ (X'*S*[zeros(3*freq_new,1); FAD_region(1:end-3*freq_new)]);% add 3s of zeros

HRF_filter= (X_filter'*S_filter*X_filter+(S_filter(1,1).^2)*lambda_HRF*eye(length(Calcium_region_filter))) \ (X_filter'*S_filter*[zeros(3*freq_new,1); HbT_region_filter(1:end-3*freq_new)]);% add 3s of zeros
MRF_filter= (X_filter'*S_filter*X_filter+(S_filter(1,1).^2)*lambda_MRF*eye(length(Calcium_region_filter))) \ (X_filter'*S_filter*[zeros(3*freq_new,1); FAD_region_filter(1:end-3*freq_new)]);% add 3s of zeros


% Predicted HbT
HbT_pred = conv(Calcium_region,HRF);
HbT_pred = HbT_pred(1:(length(HbT_region)+3*freq_new));
r_HRF= corr(HbT_region,HbT_pred(3*freq_new+1:end));

HbT_pred_filter = conv(Calcium_region_filter,HRF_filter);
HbT_pred_filter = HbT_pred_filter(1:(length(HbT_region_filter)+3*freq_new));
r_HRF_filter= corr(HbT_region_filter,HbT_pred_filter(3*freq_new+1:end));
% Predicted FAD
FAD_pred = conv(Calcium_region,MRF);
FAD_pred = FAD_pred(1:(length(FAD_region)+3*freq_new));
r_MRF= corr(FAD_region,FAD_pred(3*freq_new+1:end));

FAD_pred_filter = conv(Calcium_region_filter,MRF_filter);
FAD_pred_filter = FAD_pred_filter(1:(length(FAD_region_filter)+3*freq_new));
r_MRF_filter = corr(FAD_region_filter,FAD_pred_filter(3*freq_new+1:end));

%% test different lambda for non filtered data
ii = 1;
for lambda = [0.1,0.01,0.001,0.0001,0.00001,0.000001,0.0000005,0.0000001]
    disp(['lambda = ',num2str(lambda)])
    HRF= (X'*S*X+(S(1,1).^2)*lambda*eye(length(Calcium_region))) \ (X'*S*[zeros(3*freq_new,1); HbT_region(1:end-3*freq_new)]);% add 3s of zeros
    MRF= (X'*S*X+(S(1,1).^2)*lambda*eye(length(Calcium_region))) \ (X'*S*[zeros(3*freq_new,1); FAD_region(1:end-3*freq_new)]);% add 3s of zeros
    HbT_pred = conv(Calcium_region,HRF);
    HbT_pred = HbT_pred(1:(length(HbT_region)+3*freq_new));
    r_HRF= corr(HbT_region,HbT_pred(3*freq_new+1:end));
    FAD_pred = conv(Calcium_region,MRF);
    FAD_pred = FAD_pred(1:(length(FAD_region)+3*freq_new));
    r_MRF= corr(FAD_region,FAD_pred(3*freq_new+1:end));
    display(['r_HRF = ',num2str(r_HRF)])
    display(['r_MRF = ',num2str(r_MRF)])    
    figure(1)
    subplot(2,4,ii)
    plot(t,HRF)
    xlabel('Time(s)')
    title(['lambda = ',num2str(lambda),',r\_HRF = ',num2str(r_HRF)])
    figure(2)
    subplot(2,4,ii)
    plot(t,MRF)
    xlabel('Time(s)')
    title(['lambda = ',num2str(lambda),',r\_MRF = ',num2str(r_MRF)])
    ii = ii+1;
end
figure(1)
sgtitle('Not Filtered Data, HRF')
figure(2)
sgtitle('Not Filtered Data, MRF')

ii = 1;
for lambda = [0.1,0.01,0.001,0.0001,0.00001,0.000001,0.0000005,0.0000001]
    disp(['lambda = ',num2str(lambda)])
    HRF_filter= (X_filter'*S_filter*X_filter+(S_filter(1,1).^2)*lambda*eye(length(Calcium_region_filter))) \ (X_filter'*S_filter*[zeros(3*freq_new,1); HbT_region_filter(1:end-3*freq_new)]);% add 3s of zeros
    MRF_filter= (X_filter'*S_filter*X_filter+(S_filter(1,1).^2)*lambda*eye(length(Calcium_region_filter))) \ (X_filter'*S_filter*[zeros(3*freq_new,1); FAD_region_filter(1:end-3*freq_new)]);% add 3s of zeros
    HbT_pred_filter = conv(Calcium_region_filter,HRF_filter);
    HbT_pred_filter = HbT_pred_filter(1:(length(HbT_region_filter)+3*freq_new));
    r_HRF_filter= corr(HbT_region_filter,HbT_pred_filter(3*freq_new+1:end));
    FAD_pred_filter = conv(Calcium_region_filter,MRF_filter);
    FAD_pred_filter = FAD_pred_filter(1:(length(FAD_region)+3*freq_new));
    r_MRF_filter= corr(FAD_region_filter,FAD_pred_filter(3*freq_new+1:end));
    display(['r_HRF = ',num2str(r_HRF_filter)])
    display(['r_MRF = ',num2str(r_MRF_filter)])    
    figure(3)
    subplot(2,4,ii)
    plot(t,HRF_filter)
    xlabel('Time(s)')
    title(['lambda = ',num2str(lambda),',r\_HRF = ',num2str(r_HRF_filter)])
    figure(4)
    subplot(2,4,ii)
    plot(t,MRF_filter)
    xlabel('Time(s)')
    title(['lambda = ',num2str(lambda),',r\_MRF = ',num2str(r_MRF_filter)])
    ii = ii+1;
end
figure(3)
sgtitle('Filtered Data, HRF')
figure(4)
sgtitle('Filtered Data, MRF')
