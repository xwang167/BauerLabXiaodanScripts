%load data
load('X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\220702\220702-N26M761-WhiskerOnly-stim1-dataFluor.mat', 'xform_datafluorCorr')
load('X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\220702\220702-N26M761-WhiskerOnly-stim1-dataHb.mat', 'xform_datahb','runInfo')
load('X:\PVChR2-Thy1RGECO\PVChR2_Thy1RGECO_sensorimotor\220702\220702-N26M761-WhiskerOnly-LandmarksAndMask.mat', 'xform_isbrain')
xform_isbrain = logical(xform_isbrain);


% convert unit
calcium = xform_datafluorCorr*100;
HbO = xform_datahb(:,:,1,:)*10^6;
HbR = xform_datahb(:,:,2,:)*10^6;
HbT = squeeze(HbO + HbR);
%clear HbO HbR xform_datahb xform_datafluorCorr

% temporal filter
calcium_filter = filterData(calcium,0.01,5,runInfo.samplingRate); 
HbT_filter = filterData(HbT,0.01,5,runInfo.samplingRate);

% reshape
calcium = reshape(calcium,128*128,600,10);
HbT =  reshape(HbT,128*128,600,10);

%% generate time trace
calcium_filter = reshape(calcium_filter,128*128,600,10);
HbT_filter =  reshape(HbT_filter,128*128,600,10);

% Time trace inside of barrel cortex
load('D:\OIS_Process\atlas.mat')
ROI_barrel = AtlasSeeds == 9;

calcium_barrel = squeeze(mean(calcium(ROI_barrel(:),:,:),1));
HbT_barrel = squeeze(mean(HbT(ROI_barrel(:),:,:),1));

calcium_filter_barrel = squeeze(mean(calcium_filter(ROI_barrel(:),:,:),1));
HbT_filter_barrel = squeeze(mean(HbT_filter(ROI_barrel(:),:,:),1));

% Block averaged time trace
calcium_barrel_avg = mean(calcium_barrel,2);
HbT_barrel_avg = mean(HbT_barrel,2);

calcium_filter_barrel_avg = mean(calcium_filter_barrel,2);
HbT_filter_barrel_avg = mean(HbT_filter_barrel,2);

% save('X:\ToJonah\Timetrace.mat','calcium_barrel_avg','HbT_barrel_avg','calcium_filter_barrel_avg','HbT_filter_barrel_avg','runInfo')
%% fft
% pres level
calcium_barrel_fft = fft(calcium_barrel);
HbT_barrel_fft = fft(HbT_barrel);

calcium_filter_barrel_fft = fft(calcium_filter_barrel);
HbT_filter_barrel_fft = fft(HbT_filter_barrel);

calcium_barrel_difference = calcium_filter_barrel-calcium_barrel;
HbT_barrel_difference = HbT_filter_barrel-HbT_barrel;

calcium_barrel_difference_fft = fft(calcium_barrel_difference);
HbT_barrel_difference_fft = fft(HbT_barrel_difference);


% run level
calcium_barrel_avg_fft = fft(calcium_barrel_avg);
HbT_barrel_avg_fft = fft(HbT_barrel_avg);

calcium_filter_barrel_avg_fft = fft(calcium_filter_barrel_avg);
HbT_filter_barrel_avg_fft = fft(HbT_filter_barrel_avg);

calcium_barrel_avg_difference = calcium_filter_barrel_avg-calcium_barrel_avg;
HbT_barrel_avg_difference = HbT_filter_barrel_avg-HbT_barrel_avg;

calcium_barrel_avg_difference_fft = fft(calcium_barrel_avg_difference);
HbT_barrel_avg_difference_fft = fft(HbT_barrel_avg_difference);

T1 = length(calcium_barrel);
hz = linspace(0,runInfo.samplingRate,T1);

% Calcium Figure
%filter
figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_fft(1:ceil(T1/2),2)),'k')
title('Calcium, No filter, Pres #2')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_fft(1:ceil(T1/2),3)),'k')
title('Calcium, No filter, Pres #3')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_fft(1:ceil(T1/2),4)),'k')
title('Calcium, No filter, Pres #4')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_avg_fft(1:ceil(T1/2))),'k')
title('Calcium, No filter, avg')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

%no filter
figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_filter_barrel_fft(1:ceil(T1/2),2)),'k')
title('Calcium, filtered, Pres #2')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_filter_barrel_fft(1:ceil(T1/2),3)),'k')
title('Calcium, filtered, Pres #3')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_filter_barrel_fft(1:ceil(T1/2),4)),'k')
title('Calcium, filtered, Pres #4')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_filter_barrel_avg_fft(1:ceil(T1/2))),'k')
title('Calcium, filtered, avg')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

% difference
figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_difference_fft(1:ceil(T1/2),2)),'k')
title('Calcium, filter-no filter, Pres #2')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_difference_fft(1:ceil(T1/2),3)),'k')
title('Calcium, filter-no filter, Pres #3')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_difference_fft(1:ceil(T1/2),4)),'k')
title('Calcium, filter-no filter, Pres #4')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')

figure
semilogy(hz(1:ceil(T1/2)),abs(calcium_barrel_avg_difference_fft(1:ceil(T1/2))),'k')
title('Calcium, filter-no filter, avg')
xlabel('Frequency(Hz)')
ylabel('Log(\DeltaF/F%)')
% fft(difference)-difference(fft)
figure
plot(hz(1:ceil(T1/2)),calcium_barrel_avg_fft(1:ceil(T1/2)),'k')
title('Calcium, No filter, avg')
xlabel('Frequency(Hz)')
ylabel('\DeltaF/F%')
figure
plot(hz(1:ceil(T1/2)),calcium_barrel_difference_fft(1:ceil(T1/2),2)-(calcium_filter_barrel_fft(1:ceil(T1/2),2)-calcium_barrel_fft(1:ceil(T1/2),2)),'k')
title('Calcium, fft(difference)-difference(fft), Pres #2')
xlabel('Frequency(Hz)')
ylabel('\DeltaF/F%')
figure
plot(hz(1:ceil(T1/2)),calcium_barrel_difference_fft(1:ceil(T1/2),3)-(calcium_filter_barrel_fft(1:ceil(T1/2),3)-calcium_barrel_fft(1:ceil(T1/2),3)),'k')
title('Calcium, fft(difference)-difference(fft), Pres #3')
xlabel('Frequency(Hz)')
ylabel('\DeltaF/F%')

figure
plot(hz(1:ceil(T1/2)),calcium_barrel_difference_fft(1:ceil(T1/2),4)-(calcium_filter_barrel_fft(1:ceil(T1/2),4)-calcium_barrel_fft(1:ceil(T1/2),4)),'k')
title('Calcium, fft(difference)-difference(fft), Pres #4')
xlabel('Frequency(Hz)')
ylabel('\DeltaF/F%')

figure
plot(hz(1:ceil(T1/2)),calcium_barrel_avg_difference_fft(1:ceil(T1/2))-(calcium_filter_barrel_avg_fft(1:ceil(T1/2))-calcium_barrel_avg_fft(1:ceil(T1/2))),'k')
title('Calcium, fft(difference)-difference(fft), avg')
xlabel('Frequency(Hz)')
ylabel('\DeltaF/F%')

%HbT
%filter
figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_fft(1:ceil(T1/2),2)),'k')
title('HbT, No filter, Pres #2')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_fft(1:ceil(T1/2),3)),'k')
title('HbT, No filter, Pres #3')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_fft(1:ceil(T1/2),4)),'k')
title('HbT, No filter, Pres #4')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_avg_fft(1:ceil(T1/2))),'k')
title('HbT, No filter, avg')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

%no filter
figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_filter_barrel_fft(1:ceil(T1/2),2)),'k')
title('HbT, filtered, Pres #2')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_filter_barrel_fft(1:ceil(T1/2),3)),'k')
title('HbT, filtered, Pres #3')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_filter_barrel_fft(1:ceil(T1/2),4)),'k')
title('HbT, filtered, Pres #4')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_filter_barrel_avg_fft(1:ceil(T1/2))),'k')
title('HbT, filtered, avg')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

% difference
figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_difference_fft(1:ceil(T1/2),2)),'k')
title('HbT, filter-no filter, Pres #2')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_difference_fft(1:ceil(T1/2),3)),'k')
title('HbT, filter-no filter, Pres #3')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_difference_fft(1:ceil(T1/2),4)),'k')
title('HbT, filter-no filter, Pres #4')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')

figure
semilogy(hz(1:ceil(T1/2)),abs(HbT_barrel_avg_difference_fft(1:ceil(T1/2))),'k')
title('HbT, filter-no filter, avg')
xlabel('Frequency(Hz)')
ylabel('Log(\Delta\muM)')
% fft(difference)-difference(fft)
figure
plot(hz(1:ceil(T1/2)),HbT_barrel_avg_fft(1:ceil(T1/2)),'k')
title('HbT, No filter, avg')
xlabel('Frequency(Hz)')
ylabel('\Delta\muM')
figure
plot(hz(1:ceil(T1/2)),HbT_barrel_difference_fft(1:ceil(T1/2),2)-(HbT_filter_barrel_fft(1:ceil(T1/2),2)-HbT_barrel_fft(1:ceil(T1/2),2)),'k')
title('HbT, fft(difference)-difference(fft), Pres #2')
xlabel('Frequency(Hz)')
ylabel('\Delta\muM')
figure
plot(hz(1:ceil(T1/2)),HbT_barrel_difference_fft(1:ceil(T1/2),3)-(HbT_filter_barrel_fft(1:ceil(T1/2),3)-HbT_barrel_fft(1:ceil(T1/2),3)),'k')
title('HbT, fft(difference)-difference(fft), Pres #3')
xlabel('Frequency(Hz)')
ylabel('\Delta\muM')

figure
plot(hz(1:ceil(T1/2)),HbT_barrel_difference_fft(1:ceil(T1/2),4)-(HbT_filter_barrel_fft(1:ceil(T1/2),4)-HbT_barrel_fft(1:ceil(T1/2),4)),'k')
title('HbT, fft(difference)-difference(fft), Pres #4')
xlabel('Frequency(Hz)')
ylabel('\Delta\muM')

figure
plot(hz(1:ceil(T1/2)),HbT_barrel_avg_difference_fft(1:ceil(T1/2))-(HbT_filter_barrel_avg_fft(1:ceil(T1/2))-HbT_barrel_avg_fft(1:ceil(T1/2))),'k')
title('HbT, fft(difference)-difference(fft), avg')
xlabel('Frequency(Hz)')
ylabel('\Delta\muM')




%% Topography analysis
calcium = reshape(calcium,128,128,[],10);
HbT = reshape(HbT,128,128,[],10);

calcium_pre = squeeze(mean(calcium(:,:,1:100,:),3));
HbT_pre = squeeze(mean(HbT(:,:,1:100,:),3));

calcium_pre_avg = mean(calcium_pre,3);
HbT_pre_avg = mean(HbT_pre,3);

calcium_post = squeeze(mean(calcium(:,:,round((0.6+5)*20:(5+2.6)*20),:),3));
HbT_post = squeeze(mean(HbT(:,:,round((5+2)*20:(5+4)*20),:),3));

calcium_post_avg = mean(calcium_post,3);
HbT_post_avg = mean(HbT_post,3);

calcium_std = squeeze(std(calcium(:,:,1:100,:),0,3));
HbT_std = squeeze(std(HbT(:,:,1:100,:),0,3));

calcium_contrast = (calcium_post-calcium_pre)./calcium_std;
HbT_contrast = (HbT_post-HbT_pre)./HbT_std;


calcium_contrast_avg = mean(calcium_contrast,3);
HbT_contrast_avg = mean(HbT_contrast,3);

% calcium, no filter
figure;
for ii=1:12
    subplot(3,4,ii)
    if ii < 4
        imagesc(calcium_pre(:,:,ii+1),'AlphaData',xform_isbrain)
        title(['Pres #' num2str(ii+1)])
        c = colorbar;
        c.Label.String = '\DeltaF/F%';
    elseif ii < 8 && ii > 4
        imagesc(calcium_post(:,:,ii-3),'AlphaData',xform_isbrain)
                c = colorbar;
        c.Label.String = '\DeltaF/F%';
     
    elseif ii > 8 && ii < 12
        imagesc(calcium_contrast(:,:,ii-7),'AlphaData',xform_isbrain)
        c = colorbar;
    elseif ii == 4
        imagesc(calcium_pre_avg,'AlphaData',xform_isbrain)
        title('Averaged')
        c = colorbar;
        c.Label.String = '\DeltaF/F%';
    elseif ii == 8
        imagesc(calcium_post_avg,'AlphaData',xform_isbrain)
        c = colorbar;
        c.Label.String = '\DeltaF/F%';
    elseif ii == 12
        imagesc(calcium_contrast_avg,'AlphaData',xform_isbrain)
        c = colorbar;
    end
    axis image off
    mycolormap = customcolormap_preset('red-white-blue');
    colormap(mycolormap)
    caxis([-6 6]);    
end
sgtitle('Calcium, not filtered')

% HbT, no filter
figure;
for ii=1:12
    subplot(3,4,ii)
    if ii < 4
        imagesc(HbT_pre(:,:,ii+1),'AlphaData',xform_isbrain)
        title(['Pres #' num2str(ii+1)])
        c = colorbar;
        c.Label.String = '\Delta\muM';
    elseif ii < 8 && ii > 4
        imagesc(HbT_post(:,:,ii-3),'AlphaData',xform_isbrain)
                c = colorbar;
        c.Label.String = '\Delta\muM';
     
    elseif ii > 8 && ii < 12
        imagesc(HbT_contrast(:,:,ii-7),'AlphaData',xform_isbrain)
        c = colorbar;
    elseif ii == 4
        imagesc(HbT_pre_avg,'AlphaData',xform_isbrain)
        title('Averaged')
        c = colorbar;
        c.Label.String = '\Delta\muM';
    elseif ii == 8
        imagesc(HbT_post_avg,'AlphaData',xform_isbrain)
        c = colorbar;
        c.Label.String = '\Delta\muM';
    elseif ii == 12
        imagesc(HbT_contrast_avg,'AlphaData',xform_isbrain)
        c = colorbar;
    end
    axis image off
    mycolormap = customcolormap_preset('red-white-blue');
    colormap(mycolormap)
    caxis([-6 6]);    
end
sgtitle('HbT, not filtered')

calcium_filter = reshape(calcium_filter,128,128,[],10);
HbT_filter = reshape(HbT_filter,128,128,[],10);

calcium_filter_pre = squeeze(mean(calcium_filter(:,:,1:100,:),3));
HbT_filter_pre = squeeze(mean(HbT_filter(:,:,1:100,:),3));

calcium_filter_pre_avg = mean(calcium_filter_pre,3);
HbT_filter_pre_avg = mean(HbT_filter_pre,3);

calcium_filter_post = squeeze(mean(calcium_filter(:,:,round((0.6+5)*20:(5+2.6)*20),:),3));
HbT_filter_post = squeeze(mean(HbT_filter(:,:,round((5+2)*20:(5+4)*20),:),3));

calcium_filter_post_avg = mean(calcium_filter_post,3);
HbT_filter_post_avg = mean(HbT_filter_post,3);

calcium_filter_std = squeeze(std(calcium_filter(:,:,1:100,:),0,3));
HbT_filter_std = squeeze(std(HbT_filter(:,:,1:100,:),0,3));

calcium_filter_contrast = (calcium_filter_post-calcium_filter_pre)./calcium_filter_std;
HbT_filter_contrast = (HbT_filter_post-HbT_filter_pre)./HbT_filter_std;


calcium_filter_contrast_avg = mean(calcium_filter_contrast,3);
HbT_filter_contrast_avg = mean(HbT_filter_contrast,3);

% calcium, filtered
figure;
for ii=1:12
    subplot(3,4,ii)
    if ii < 4
        imagesc(calcium_filter_pre(:,:,ii+1),'AlphaData',xform_isbrain)
        title(['Pres #' num2str(ii+1)])
        c = colorbar;
        c.Label.String = '\DeltaF/F%';
    elseif ii < 8 && ii > 4
        imagesc(calcium_filter_post(:,:,ii-3),'AlphaData',xform_isbrain)
                c = colorbar;
        c.Label.String = '\DeltaF/F%';
     
    elseif ii > 8 && ii < 12
        imagesc(calcium_filter_contrast(:,:,ii-7),'AlphaData',xform_isbrain)
        c = colorbar;
    elseif ii == 4
        imagesc(calcium_filter_pre_avg,'AlphaData',xform_isbrain)
        title('Averaged')
        c = colorbar;
        c.Label.String = '\DeltaF/F%';
    elseif ii == 8
        imagesc(calcium_filter_post_avg,'AlphaData',xform_isbrain)
        c = colorbar;
        c.Label.String = '\DeltaF/F%';
    elseif ii == 12
        imagesc(calcium_filter_contrast_avg,'AlphaData',xform_isbrain)
        c = colorbar;
    end
    axis image off
    mycolormap = customcolormap_preset('red-white-blue');
    colormap(mycolormap)
    caxis([-6 6]);    
end
sgtitle('Calcium, filtered')

% HbT, filtered
figure;
for ii=1:12
    subplot(3,4,ii)
    if ii < 4
        imagesc(HbT_filter_pre(:,:,ii+1),'AlphaData',xform_isbrain)
        title(['Pres #' num2str(ii+1)])
        c = colorbar;
        c.Label.String = '\Delta\muM';
    elseif ii < 8 && ii > 4
        imagesc(HbT_filter_post(:,:,ii-3),'AlphaData',xform_isbrain)
                c = colorbar;
        c.Label.String = '\Delta\muM';
     
    elseif ii > 8 && ii < 12
        imagesc(HbT_filter_contrast(:,:,ii-7),'AlphaData',xform_isbrain)
        c = colorbar;
    elseif ii == 4
        imagesc(HbT_filter_pre_avg,'AlphaData',xform_isbrain)
        title('Averaged')
        c = colorbar;
        c.Label.String = '\Delta\muM';
    elseif ii == 8
        imagesc(HbT_filter_post_avg,'AlphaData',xform_isbrain)
        c = colorbar;
        c.Label.String = '\Delta\muM';
    elseif ii == 12
        imagesc(HbT_filter_contrast_avg,'AlphaData',xform_isbrain)
        c = colorbar;
    end
    axis image off
    mycolormap = customcolormap_preset('red-white-blue');
    colormap(mycolormap)
    caxis([-6 6]);    
end
sgtitle('HbT, filtered')