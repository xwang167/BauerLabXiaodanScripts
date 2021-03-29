%line profile
x = [45, 18];
y = [39, 66];
coefficients = polyfit(x, y, 1);
xFit = 4:55;
yFit = polyval(coefficients,xFit);
hold on
plot(xFit, yFit,'k')
yFit = uint16(yFit);
figure

z = nan(1,52);
for ii = 1:52
    z(ii) = R_jrgeco1aCorr_ISA_mice(yFit(ii),xFit(ii),3);
end
figure
plot(xFit,z,'m')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_FADCorr_ISA_mice(yFit(ii),xFit(ii),3);
end
hold on 
plot(xFit,z,'g')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_total_ISA_mice(yFit(ii),xFit(ii),3);
end
hold on 
plot(xFit,z,'k')

legend('RGECO','FAD','HbT','location','northwest')
title('awake ISA ML')



figure
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,3),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake ISA ML Calcium')
plot(xFit, yFit,'k')


figure
imagesc(R_FADCorr_ISA_mice(:,:,3),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake ISA ML FAD')
plot(xFit, yFit,'k')


figure
imagesc(R_total_ISA_mice(:,:,3),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake ISA ML Total')
plot(xFit, yFit,'k')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_jrgeco1aCorr_ISA_mice(yFit(ii),xFit(ii),7);
end
figure
plot(xFit,z,'m')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_FADCorr_ISA_mice(yFit(ii),xFit(ii),7);
end
hold on 
plot(xFit,z,'g')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_total_ISA_mice(yFit(ii),xFit(ii),7);
end
hold on 
plot(xFit,z,'k')

legend('RGECO','FAD','HbT','location','northwest')
title('awake ISA SL')



figure
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,7),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake ISA SL Calcium')
plot(xFit, yFit,'k')


figure
imagesc(R_FADCorr_ISA_mice(:,:,7),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake ISA SL FAD')
plot(xFit, yFit,'k')


figure
imagesc(R_total_ISA_mice(:,:,7),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake ISA SL Total')
plot(xFit, yFit,'k')





z = nan(1,52);
for ii = 1:52
    z(ii) = R_jrgeco1aCorr_Delta_mice(yFit(ii),xFit(ii),3);
end
figure
plot(xFit,z,'m')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_FADCorr_Delta_mice(yFit(ii),xFit(ii),3);
end
hold on 
plot(xFit,z,'g')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_total_Delta_mice(yFit(ii),xFit(ii),3);
end
hold on 
plot(xFit,z,'k')

legend('RGECO','FAD','HbT','location','northwest')
title('awake Delta ML')


figure
imagesc(R_jrgeco1aCorr_Delta_mice(:,:,3),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake Delta ML Calcium')
plot(xFit, yFit,'k')


figure
imagesc(R_FADCorr_Delta_mice(:,:,3),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake Delta ML FAD')
plot(xFit, yFit,'k')


figure
imagesc(R_total_Delta_mice(:,:,3),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake Delta ML Total')
plot(xFit, yFit,'k')



z = nan(1,52);
for ii = 1:52
    z(ii) = R_jrgeco1aCorr_Delta_mice(yFit(ii),xFit(ii),7);
end
figure
plot(xFit,z,'m')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_FADCorr_Delta_mice(yFit(ii),xFit(ii),7);
end
hold on 
plot(xFit,z,'g')

z = nan(1,52);
for ii = 1:52
    z(ii) = R_total_Delta_mice(yFit(ii),xFit(ii),7);
end
hold on 
plot(xFit,z,'k')

legend('RGECO','FAD','HbT','location','northwest')
title('awake Delta SL')


figure
imagesc(R_jrgeco1aCorr_Delta_mice(:,:,7),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake Delta SL Calcium')
plot(xFit, yFit,'k')


figure
imagesc(R_FADCorr_Delta_mice(:,:,7),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake Delta SL FAD')
plot(xFit, yFit,'k')


figure
imagesc(R_total_Delta_mice(:,:,7),[-1.1 1.1])
colormap jet
hold on
axis image off
title('awake Delta SL Total')
plot(xFit, yFit,'k')

