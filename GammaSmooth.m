load('L:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\190627\190627-R5M2285-fc1_processed.mat', 'xform_datahb')
load('L:\RGECO\Kenny\190627\190627-R5M2285-fc1-dataFluor.mat', 'xform_isbrain')
load('D:\OIS_Process\noVasculatureMask.mat','mask_new')
%change unit to DeltamuM, DeltaF/F%
HbT = squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;
clear xform_datahb
calcium = xform_jrgeco1aCorr*100;
clear xform_jrgeco1aCorr
mask_new_matrix = repmat(mask_new,1,1,size(calcium,3));
calcium = calcium.*mask_new_matrix;
HbT = HbT.*mask_new_matrix;
calcium(calcium == 0) = nan;
HbT(HbT==0) = nan;

%Smooth
gBox = 20;
gSigma = 10;
T = nan(128,128,5);
W = nan(128,128,5);
A = nan(128,128,5);
r = nan(128,128,5);
r2 = nan(128,128,5);
objective_vals = nan(128,128,5);
HbT_smooth = smoothImage(HbT,gBox,gSigma);
calcium_smooth = smoothImage(calcium,gBox,gSigma);

OGsize=size(calcium_smooth);
disp('filtering')
%Filtering
onlyBrain=find(xform_isbrain==1);

calcium_smooth = filterData(double(calcium_smooth),0.02,2,25);
calcium_smooth = reshape(calcium_smooth,OGsize(1)*OGsize(2),[]);
calcium_smooth = resample(calcium_smooth',5,25)';

HbT_smooth = filterData(double(HbT_smooth),0.02,2,25);% a 0.02-Hz high-pass filter (HPF) to remove slow drifts, as well as a 2-Hz low-pass filter (LPF) to reduce physiological noise
HbT_smooth = reshape(HbT_smooth,OGsize(1)*OGsize(2),[]);
HbT_smooth = resample(HbT_smooth',5,25)';

calcium_smooth = reshape(calcium_smooth,OGsize(1),OGsize(2),[]);
HbT_smooth = reshape(HbT_smooth,OGsize(1),OGsize(2),[]);

%setting things up
time_epoch=30;
t= [0:1/25:time_epoch]; %30 seconds7
t=linspace(0,time_epoch,time_epoch*25 *(5/25));%% force it to be 5 hz
%% Gamma
for ii = 1:5;
    tic
    [T(:,:,ii),W(:,:,ii),A(:,:,ii),r(:,:,ii),r2(:,:,ii),~,objective_vals(:,:,ii)] = ...
        GammaFit(calcium_smooth(:,:,(ii-1)*120*5+1:ii*120*5),HbT_smooth(:,:,(ii-1)*120*5+1:ii*120*5),t,mask_new);
    time_taken=toc
end

for ii = 1:5
    figure
    subplot(2,3,1)
    imagesc(T(:,:,ii),[0,2])
    colorbar
    axis image off
    colormap jet
    title('T(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,2)
    imagesc(W(:,:,ii),[0 3])
    colorbar
    axis image off
    colormap jet
    title('W(s)')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,3)
    imagesc(A(:,:,ii),[0 0.2])
    colorbar
    axis image off
    colormap jet
    title('A')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,4)
    imagesc(r(:,:,ii),[-1 1])
    colorbar
    axis image off
    colormap jet
    title('r')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,5)
    imagesc(r2(:,:,ii),[0 1])
    colorbar
    axis image off
    colormap jet
    title('R^2')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    
    subplot(2,3,6)
    imagesc(objective_vals(:,:,ii),[100 500])
    colorbar
    axis image off
    colormap jet
    title('Objective Vals')
    hold on;
    imagesc(xform_WL,'AlphaData',1-mask);
    set(gca,'FontSize',14,'FontWeight','Bold')
    sgtitle(strcat(num2str((ii-1)*2),' to ',num2str(ii*2),' mins', ' gbox = 20, gsig = 10'))
end


%% average across 10 mins
T_mean = nanmean(T,3);
W_mean = nanmean(W,3);
A_mean = nanmean(A,3);
r_mean = nanmean(r,3);
r2_mean = nanmean(r2,3);
objective_vals_mean = nanmean(objective_vals,3);


figure
subplot(2,3,1)
imagesc(T_mean,[0,2])
colorbar
axis image off
colormap jet
title('T(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,2)
imagesc(W_mean,[0 3])
colorbar
axis image off
colormap jet
title('W(s)')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,3)
imagesc(A_mean,[0 0.2])
colorbar
axis image off
colormap jet
title('A')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,4)
imagesc(r_mean,[-1 1])
colorbar
axis image off
colormap jet
title('r')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,5)
imagesc(r2_mean,[0 1])
colorbar
axis image off
colormap jet
title('R^2')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')

subplot(2,3,6)
imagesc(objective_vals_mean,[100 500])
colorbar
axis image off
colormap jet
title('Objective Vals')
hold on;
imagesc(xform_WL,'AlphaData',1-mask);
set(gca,'FontSize',14,'FontWeight','Bold')
sgtitle('10 mins, gbox = 20, gsig = 10')

close all
for ii = 50:58
    figure('units','normalized','outerposition',[0 0 1 0.5])
    subplot(1,2,1)
    imagesc(T(:,:,1))
    axis image off
    hold on 
    scatter(26,ii,'white','filled')
    title(strcat('T = ',num2str(T(ii,26,1)),'s'))
    
    subplot(1,2,2)
    plot((1:600)/5,squeeze(calcium_smooth(ii,26,1:600)),'m-')
    hold on
    plot((1:600)/5,squeeze(HbT_smooth(ii,26,1:600)),'k-')
    hold on
    plot((1:600)/5,squeeze(hemoPred(ii,26,1:600)),'g-')    
    legend('jRGECO1a','HbT actual','HbT Pred')
    xlabel('Time(s)')
    ylabel('\DeltaF/F% or \Delta\muM')
    ylim([-3 6])
end

options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
 pixHemo = squeeze(HbT_smooth(52,26,1:120*5))';
    pixNeural = squeeze(calcium_smooth(52,26,1:120*5))';
    he = HemodynamicsError(t,pixNeural,pixHemo);
           fcn = @(param)he.fcn(param);
            [x,pixHrfParam,objective_val,exitflag,outputs] = evalc('fminsearchbnd(fcn,[0.62,1.8,0.12],[0.2,0.3,0.05],[2,3,1],options)'); %T, W, A -- guess, lower bound, upper bound
            pixelHrf = hrfGamma(t,pixHrfParam(1),pixHrfParam(2),pixHrfParam(3)); % %T, W, A
 