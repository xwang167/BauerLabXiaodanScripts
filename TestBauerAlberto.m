figure
plot(tt,(ydHbO_uM-mean(ydHbO_uM(1:125)))*1e6,'LineWidth',1.5,'color','r'), 
hold on
plot(tt,(ydHbR_uM-mean(ydHbR_uM(1:125)))*1e6,'LineWidth',1.5,'color','b'), 
hold on
plot(tt,(ydHbT_uM-mean(ydHbT_uM(1:125)))*1e6,'LineWidth',1.5,'color','k'), 


plot((1:750)/25,HbO_Bauer-mean(HbO_Bauer(1:125)),'LineWidth',1.5,'color','m')
hold on
plot((1:750)/25,HbR_Bauer-mean(HbR_Bauer(1:125)),'LineWidth',1.5,'color','c')
hold on
plot((1:750)/25,HbT_Bauer-mean(HbT_Bauer(1:125)),'LineWidth',1.5,'color','g')

legend('Alberto HbO','Alberto HbR','Alberto HbT', 'Bauer HbO','Bauer HbR','Bauer HbT')
axis tight, grid on, set(gca,'FontSize',12),


figure

plot((1:750)/25,(ydHbO_uM-mean(ydHbO_uM(1:125)))*1e6-(HbO_Bauer-mean(HbO_Bauer(1:125)))','LineWidth',1.5,'color','r')
hold on
plot((1:750)/25,(ydHbR_uM-mean(ydHbR_uM(1:125)))*1e6-(HbR_Bauer-mean(HbR_Bauer(1:125)))','LineWidth',1.5,'color','b')
hold on
plot((1:750)/25,(ydHbT_uM-mean(ydHbT_uM(1:125)))*1e6-(HbT_Bauer-mean(HbT_Bauer(1:125)))','LineWidth',1.5,'color','k')


figure

plot((1:750)/25,ydHbO_uM*1e6./HbO_Bauer','LineWidth',1.5,'color','r')
hold on
plot((1:750)/25,ydHbR_uM*1e6./HbR_Bauer','LineWidth',1.5,'color','b')
hold on
plot((1:750)/25,ydHbT_uM*1e6./HbT_Bauer','LineWidth',1.5,'color','k')