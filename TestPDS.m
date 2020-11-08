load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;

 load('K:\GCaMP\190523\190523-G11M1-awake-fc1_processed.mat', 'xform_gcamp','xform_gcampCorr','xform_datahb')
 L1 = size(xform_gcamp,3);
 Fs_1 = 20;

 [gcamp_1_fft,f1] = pwelch(xform_gcamp,[],[],[],Fs_1);
 gcampCorr_1_fft = pwelch(xform_gcampCorr,[],[],[],Fs_1);
 datahb_1_fft = pwelch(xform_datahb,[],[],[],Fs_1);
 clear xform_gcamp xform_gcampCorr xform_datahb
 
  load('K:\GCaMP\190424\190424-G7M5-awake-fc1_processed.mat', 'xform_gcamp','xform_gcampCorr','xform_datahb')
   L2_1 = size(xform_gcamp,3);
 Fs_2_1 = 33;

 
 [gcamp_2_1_fft, = pwelch(xform_gcamp,[],[],[],Fs_2_1);
 gcampCorr_2_1_fft = pwelch(xform_gcampCorr,[],[],Fs_2_1);
 datahb_2_1_fft = pwelch(xform_datahb,[],[],Fs_2_1);
  clear xform_gcamp xform_gcampCorr xform_datahb
   load('K:\GCaMP\200121\200121-G38M2-Gopto3-stim1_processed.mat', 'xform_gcamp','xform_gcampCorr','xform_datahb')
    L2_2 = size(xform_gcamp,3);
     Fs_2_2 = 20;
 f2_2 = Fs_1*(0:(L2_2/2))/L2_2;
 gcamp_2_2_fft = pwelch(xform_gcamp,[],3));
 gcampCorr_2_2_fft = pwelch(xform_gcampCorr,[],3));
 datahb_2_2_fft = pwelch(xform_datahb,[],4));
    clear xform_gcamp xform_gcampCorr xform_datahb
    
  ibi = find(mask ==1);
gcampCorr_1_fft =  reshape(gcampCorr_1_fft,128*128,[]);
gcampCorr_1_fft = mean(gcampCorr_1_fft(ibi,:),1);

  
    
    gcampCorr_2_1_fft =  reshape(gcampCorr_2_1_fft,128*128,[]);
gcampCorr_2_1_fft = mean(gcampCorr_2_1_fft(ibi,:),1);


    gcampCorr_2_2_fft =  reshape(gcampCorr_2_2_fft,128*128,[]);
gcampCorr_2_2_fft = mean(gcampCorr_2_2_fft(ibi,:),1);
figure
  loglog(f1,gcampCorr_1_fft(1:L1/2+1)/gcampCorr_1_fft(4),'r')
  hold on 
loglog(f2_1,gcampCorr_2_1_fft(1:L2_1/2+1)/gcampCorr_2_1_fft(6),'g')
hold on 
loglog(f2_2,gcampCorr_2_2_fft(1:L2_2/2+1)/gcampCorr_2_2_fft(4),'b')

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'OIS1','OIS2 OneCam','OIS2 TwoCam'};
leg = legend(legendName,'location','southwest','FontSize',12);

    
  ibi = find(mask ==1);
oxy_1_fft =  reshape(squeeze(datahb_1_fft(:,:,1,:)),128*128,[]);
oxy_1_fft = mean(oxy_1_fft(ibi,:),1);
titile()
  
    
    oxy_2_1_fft =  reshape(datahb_2_1_fft(:,:,1,:),128*128,[]);
oxy_2_1_fft = mean(oxy_2_1_fft(ibi,:),1);


    oxy_2_2_fft =  reshape(datahb_2_2_fft(:,:,1,:),128*128,[]);
oxy_2_2_fft = mean(oxy_2_2_fft(ibi,:),1);
figure
  loglog(f1,oxy_1_fft(1:L1/2+1)/oxy_1_fft(4),'r')
  hold on 
loglog(f2_1,oxy_2_1_fft(1:L2_1/2+1)/oxy_2_1_fft(6),'g')
hold on 
loglog(f2_2,oxy_2_2_fft(1:L2_2/2+1)/oxy_2_2_fft(4),'b')

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'OIS1','OIS2 OneCam','OIS2 TwoCam'};
leg = legend(legendName,'location','southwest','FontSize',12);
title('Oxy')

  ibi = find(mask ==1);
deoxy_1_fft =  reshape(squeeze(datahb_1_fft(:,:,2,:)),128*128,[]);
deoxy_1_fft = mean(deoxy_1_fft(ibi,:),1);

  
    
    deoxy_2_1_fft =  reshape(datahb_2_1_fft(:,:,2,:),128*128,[]);
deoxy_2_1_fft = mean(deoxy_2_1_fft(ibi,:),1);


    deoxy_2_2_fft =  reshape(datahb_2_2_fft(:,:,2,:),128*128,[]);
deoxy_2_2_fft = mean(deoxy_2_2_fft(ibi,:),1);
figure
  loglog(f1,deoxy_1_fft(1:L1/2+1)/deoxy_1_fft(4),'r')
  hold on 
loglog(f2_1,deoxy_2_1_fft(1:L2_1/2+1)/deoxy_2_1_fft(6),'g')
hold on 
loglog(f2_2,deoxy_2_2_fft(1:L2_2/2+1)/deoxy_2_2_fft(4),'b')

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'OIS1','OIS2 OneCam','OIS2 TwoCam'};
leg = legend(legendName,'location','southwest','FontSize',12);
title('deoxy')


load('D:\RGECO\191028\191028-R6M1-awake-fc1_processed.mat', 'xform_jrgeco1aCorr','xform_jrgeco1a','xform_datahb')
 L = size(xform_jrgeco1aCorr,3);
 Fs = 25;
 f = Fs*(0:(L/2))/L;
 jrgeco1a_fft = pwelch(xform_jrgeco1a,[],3));
 jrgeco1aCorr_fft = pwelch(xform_jrgeco1aCorr,[],3));
 datahb_fft = pwelch(xform_datahb,[],4));
 clear xform_jrgeco1a xform_jrgeco1aCorr xform_datahb
jrgeco1aCorr_fft =  reshape(jrgeco1aCorr_fft,128*128,[]);
jrgeco1aCorr_fft = mean(jrgeco1aCorr_fft(ibi,:),1);

 oxy_fft =  reshape(squeeze(datahb_fft(:,:,1,:)),128*128,[]);
oxy_fft = mean(oxy_fft(ibi,:),1);

deoxy_fft =  reshape(squeeze(datahb_fft(:,:,2,:)),128*128,[]);
deoxy_fft = mean(deoxy_fft(ibi,:),1);

figure
  loglog(f,jrgeco1aCorr_fft(1:L/2+1)/jrgeco1aCorr_fft(7),'m')
  hold on 
   loglog(f,oxy_fft(1:L/2+1)/oxy_fft(7),'r')
  hold on
loglog(f,deoxy_fft(1:L/2+1)/deoxy_fft(7),'b')

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'jrgeco1aCorr','oxy','deoxy'};
leg = legend(legendName,'location','southwest','FontSize',12);
title('RGECO')
