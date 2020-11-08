  load(fullfile(saveDir, processedName),'xform_gcampCorr','xform_gcamp')
                    sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
                    sessionInfo.bandtype_Delta = {"Delta",0.4,4};
                    total = squeeze(xform_datahb(:,:,1,:)) + squeeze(xform_datahb(:,:,2,:));
                    disp('calculate pds')
                           
[hz,powerdata_average_jrgeco1aCorr] = QCcheck_CalcPDSAverage(double(xform_jrgeco1aCorr)/0.01,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_FAD] = QCcheck_CalcPDSAverage(double(xform_FAD)/0.01,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_total] = QCcheck_CalcPDSAverage(double(total)*10^6,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_oxy] = QCcheck_CalcPDSAverage(double(xform_datahb(:,:,1,:))*10^6,sessionInfo.framerate,xform_isbrain);
                    [~,powerdata_average_deoxy] = QCcheck_CalcPDSAverage(double(xform_datahb(:,:,2,:))*10^6,sessionInfo.framerate,xform_isbrain);
                    
                    
                      nameString = fullfile(saveDir,visName);
                    figure
                    normFactor = (powerdata_average_jrgeco1aCorr(3)-powerdata_average_jrgeco1aCorr(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_jrgeco1aCorr(2);
semilogx(hz,10*log10(powerdata_average_jrgeco1aCorr/normFactor),'m-')

hold on
normFactor = (powerdata_average_FAD(3)-powerdata_average_FAD(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_FAD(2);
semilogx(hz,10*log10(powerdata_average_FAD/normFactor),'g-')

ylim([-50,5])
ylabel('dB(\DeltaF/F%)^2/Hz)')

yyaxis right
hold on
normFactor = (powerdata_average_oxy(3)-powerdata_average_oxy(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_oxy(2);
semilogx(hz,10*log10(powerdata_average_oxy/normFactor),'r-')

hold on
normFactor = (powerdata_average_deoxy(3)-powerdata_average_deoxy(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_deoxy(2);
semilogx(hz,10*log10(powerdata_average_deoxy/normFactor),'b-')

hold on
normFactor = (powerdata_average_total(3)-powerdata_average_total(2))*(0.01-hz(2))/(hz(3)-hz(2))+powerdata_average_total(2);
semilogx(hz,10*log10(powerdata_average_total/normFactor),'k-')
ylabel('dB(\muM^2/Hz)')
ylim([-50,5])

xticks([10^-2  10^-1 10^0 10])

xlabel('Frequency (Hz)')

xlim([10^-2 10])
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'FontSize',20,'FontWeight','Bold')
 grid on
 legendName = {'Corrected jrgeco1a','FAD','HbO','HbR','HbT'};
leg = legend(legendName,'location','southwest','FontSize',12);


title(visName,'fontsize',14,'Interpreter', 'none');
ytickformat('%.1f');

