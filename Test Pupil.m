load('L:\RGECO\210425\210425-dark-no-pupil-stim1.mat')
load('W:\210425\210425-dark-no-pupil-stim1-cam1.mat')
raw_unregistered =  reshape(raw_unregistered,128*128,4,[]);
blue_no_pupil = mean(raw_unregistered(:,1,:));
green_no_pupil = mean(raw_unregistered(:,2,:));
load('W:\210425\210425-dark-no-pupil-stim1-cam2.mat')
raw_unregistered =  reshape(raw_unregistered,128*128,4,[]);
mega_no_pupil = mean(raw_unregistered(:,3,:));
red_no_pupil = mean(raw_unreigsered(:,:,4,:));
Unrecognized function or variable 'raw_unreigsered'.
 
Did you mean:
red_no_pupil = mean(raw_unregistered(:,:,4,:));
figure
plot((1:6020)/20,blue_no_pupil,'b-')
Error using plot
Data cannot have more than 2 dimensions.
 
plot((1:6020)/20,squeeze(blue_no_pupil),'b-')
hold on
plot((1:6020)/20,squeeze(green_no_pupil),'g-')
hold on
plot((1:6020)/20,squeeze(mega_no_pupil),'m-')
hold on
plot((1:6020)/20,squeeze(red_no_pupil),'r-')
Error using plot
Vectors must be the same length.
 
red_no_pupil = mean(raw_unregistered(:,4,:));\
 red_no_pupil = mean(raw_unregistered(:,4,:));\
                                              ?
Error: Invalid use of operator.
 
red_no_pupil = mean(raw_unregistered(:,4,:));
hold on
plot((1:6020)/20,squeeze(red_no_pupil),'r-')
title('With Dark Frames')
load('W:\210425\210425-dark-pupil-stim1-cam1.mat')
 raw_unregistered =  reshape(raw_unregistered,128*128,4,[]);
blue_pupil = mean(raw_unregistered(:,1,:));
green_pupil = mean(raw_unregistered(:,2,:));
load('W:\210425\210425-dark-pupil-stim1-cam2.mat')
mega_pupil = mean(raw_unregistered(:,3,:));
red_pupil = mean(raw_unreigsered(:,:,4,:));
Unrecognized function or variable 'raw_unreigsered'.
 
Did you mean:
red_pupil = mean(raw_unregistered(:,4,:));
hold on
plot((1:6020)/20,squeeze(blue_pupil),'b--')
figure
plot((1:6020)/20,squeeze(blue_no_pupil),'b-')
hold on
plot((1:6020)/20,squeeze(green_no_pupil),'g-')
hold on
plot((1:6020)/20,squeeze(mega_no_pupil),'m-')
hold on
plot((1:6020)/20,squeeze(red_no_pupil),'r-')
hold on
plot((1:6020)/20,squeeze(blue_pupil),'c-')
hold on
plot((1:6020)/20,squeeze(green_no_pupil),'color',[0,0.5,0])
hold on
figure
plot((1:6020)/20,squeeze(blue_no_pupil),'b-')
hold on
plot((1:6020)/20,squeeze(green_no_pupil),'g-')
hold on
plot((1:6020)/20,squeeze(mega_no_pupil),'m-')
hold on
plot((1:6020)/20,squeeze(red_no_pupil),'r-')
hold on
plot((1:6020)/20,squeeze(blue_pupil),'c-')
plot((1:6020)/20,squeeze(green_pupil),'color',[0,0.5,0])
hold on
plot((1:6020)/20,squeeze(mega_pupil),'k-')
Error using plot
Vectors must be the same length.
 
mega_pupil = mean(raw_unregistered(:,3,:));
 raw_unregistered =  reshape(raw_unregistered,128*128,4,[]);
mega_pupil = mean(raw_unregistered(:,3,:));
red_pupil = mean(raw_unreigsered(:,:,4,:));
Unrecognized function or variable 'raw_unreigsered'.
 
Did you mean:
red_pupil = mean(raw_unregistered(:,:,4,:));
red_pupil = mean(raw_unregistered(:,4,:));
hold on
plot((1:6020)/20,squeeze(mega_pupil),'k-')
hold on
plot((1:6020)/20,squeeze(red_pupil),'color',[0.5,0,0])
legend('No Pupil FAD','No Pupil Green','No Pupil RGECO','No Pupil Red','Pupil FAD','Pupil Green','Pupil RGECO','Pupil Red')
figure
plot(blue_pupil-blue_no_pupil,'b-')
Error using plot
Data cannot have more than 2 dimensions.
 
plot(squeeze(blue_pupil-blue_no_pupil),'b-')
hold on
plot(squeeze(gree_pupil-gree_no_pupil),'g-')
Unrecognized function or variable 'gree_pupil'.
 
Did you mean:
plot(squeeze(green_pupil-green_no_pupil),'g-')
hold on
plot(squeeze(mega_pupil-mega_no_pupil),'m-')
hold on
plot(squeeze(red_pupil-red_no_pupil),'r-')
title('Pupil - No Pupil')
load('L:\RGECO\210425\210425-dark-pupil-stim1.mat')
load('L:\RGECO\210425\210425-dark-no-pupil-stim1.mat')
figure
plot(mdata_no_pupil(1,:),'b-')
hold on
plot(mdata_no_pupil(3,:),'g-')
hold on
plot(mdata_no_pupil(2,:),'m-')
hold on
plot(mdata_no_pupil(2,:),'r-')
hold on
plot(mdata_pupil(1,:),'c-')
plot(mdata_pupil(3,:),'color',[0 0.5 0])
hold on
plot(mdata_pupil(2,:),'k-')
plot(mdata_pupil(4,:),'color',[0.5 0 0])
legend('No Pupil FAD','No Pupil Green','No Pupil RGECO','No Pupil Red','Pupil FAD','Pupil Green','Pupil RGECO','Pupil Red')
figure
plot(mdata_pupil(1,:)-mdata_no_pupil(1,:),'b-')
hold on
plot(mdata_pupil(3,:)-mdata_no_pupil(3,:),'g-')
hold on
plot(mdata_pupil(2,:)-mdata_no_pupil(2,:),'m-')
hold on
plot(mdata_pupil(2,:) - mdata_no_pupil(2,:),'r-')
title('Pupil - No Pupil')
