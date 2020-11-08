load('L:\RGECO\190701\190701-R5M2288-fc1_processed.mat', 'xform_datahb')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
plot((1:14999)/25,squeeze(xform_datahb(45,39,1,:)),'r')
hold on
plot((1:14999)/25,squeeze(xform_datahb(45,39,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('ML')

xform_datahb_1hz = resampledata(xform_datahb,25,1,10^-5);

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(45,39,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(45,39,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('ML')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(84,39,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(84,39,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('MR')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(18,66,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(18,66,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('SL')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(111,66,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(111,66,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('SR')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(42,88,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(42,88,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('PL')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(87,88,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(87,88,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('PR')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(34,115,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(34,115,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('VL')

figure('units','normalized','outerposition',[0.1 0.3 0.7 0.4])
plot(1:600,squeeze(xform_datahb_1hz(95,115,1,:)),'r')
hold on
plot(1:600,squeeze(xform_datahb_1hz(95,115,2,:)),'b')
xlabel('Time(s)')
ylabel('Hb(\DeltaM)')
title('VR')