        [powerdata_jrgeco1a,hz] = pwelch(squeeze(xform_jrgeco1a(83,22,:)),[],[],[],25);
        [powerdata_jrgeco1aCorr,hz] = pwelch(squeeze(xform_jrgeco1aCorr(83,22,:)),[],[],[],25);
        [powerdata_jrgeco1aCorr_lpf,hz] = pwelch(squeeze(xform_jrgeco1aCorr_lpf(83,22,:)),[],[],[],25);
        [powerdata_HbO,hz] = pwelch(squeeze(xform_datahb(83,22,1,:)),[],[],[],25);
        [powerdata_HbR,hz] = pwelch(squeeze(xform_datahb(83,22,2,:)),[],[],[],25);
        figure
        subplot(221)
        loglog(hz,powerdata_jrgeco1a,'r')
        hold on
        loglog(hz,powerdata_jrgeco1aCorr,'b')
        legend('Raw jRGECO1a','Corrected jRGECO1a with unfiltered xform\_datahb',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('jRGECO1a(\DeltaF/F)')
        subplot(222)
        loglog(hz,powerdata_jrgeco1a,'r')
        hold on
        loglog(hz,powerdata_jrgeco1aCorr_lpf,'k')
        legend('Raw jRGECO1a','Corrected jRGECO1a with filtered xform\_datahb',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('jRGECO1a(\DeltaF/F)')
        subplot(223)
        loglog(hz,powerdata_jrgeco1aCorr,'b')
        hold on
        loglog(hz,powerdata_jrgeco1aCorr_lpf,'k')
        legend('Corrected jRGECO1a with unfiltered xform\_datahb','Corrected jRGECO1a with filtered xform\_datahb',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('jRGECO1a(\DeltaF/F)')
        subplot(224)
        loglog(hz,powerdata_jrgeco1a,'r')
        hold on
        loglog(hz,powerdata_jrgeco1aCorr,'b')
        hold on
        loglog(hz,powerdata_jrgeco1aCorr_lpf,'k')
        hold on
        loglog(hz,powerdata_HbO,'m')
        hold on
        loglog(hz,powerdata_HbR,'c')
        legend('Raw jRGECO1a','Corrected jRGECO1a with unfiltered xform\_datahb','Corrected jRGECO1a with filtered xform\_datahb','unfiltered HbO','unfitlered HbR',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('jRGECO1a(\DeltaF/F)')
        ylim([10^-18 1])
        
        sgtitle(strcat(visName,' low pass filter datahb at 1 hz'))
        % FAD

        [powerdata_FAD,hz] = pwelch(squeeze(xform_FAD(83,22,:)),[],[],[],25);
        [powerdata_FADCorr,hz] = pwelch(squeeze(xform_FADCorr(83,22,:)),[],[],[],25);
        [powerdata_FADCorr_lpf,hz] = pwelch(squeeze(xform_FADCorr_lpf(83,22,:)),[],[],[],25);
        [powerdata_HbO,hz] = pwelch(squeeze(xform_datahb(83,22,1,:)),[],[],[],25);
        [powerdata_HbR,hz] = pwelch(squeeze(xform_datahb(83,22,2,:)),[],[],[],25);
        figure
        subplot(221)
        loglog(hz,powerdata_FAD,'r')
        hold on
        loglog(hz,powerdata_FADCorr,'b')
        legend('Raw FAD','Corrected FAD with unfiltered xform\_datahb',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('FAD(\DeltaF/F)')
        subplot(222)
        loglog(hz,powerdata_FAD,'r')
        hold on
        loglog(hz,powerdata_FADCorr_lpf,'k')
        legend('Raw FAD','Corrected FAD with filtered xform\_datahb',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('FAD(\DeltaF/F)')
        subplot(223)
        loglog(hz,powerdata_FADCorr,'b')
        hold on
        loglog(hz,powerdata_FADCorr_lpf,'k')
        legend('Corrected FAD with unfiltered xform\_datahb','Corrected FAD with filtered xform\_datahb',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('FAD(\DeltaF/F)')
        subplot(224)
        loglog(hz,powerdata_FAD,'r')
        hold on
        loglog(hz,powerdata_FADCorr,'b')
        hold on
        loglog(hz,powerdata_FADCorr_lpf,'k')
        hold on
        loglog(hz,powerdata_HbO,'m')
        hold on
        loglog(hz,powerdata_HbR,'c')
        legend('Raw FAD','Corrected FAD with unfiltered xform\_datahb','Corrected FAD with filtered xform\_datahb','unfiltered HbO','unfitlered HbR',...
            'location','southwest')
        xlim([0.01 10])
        xlabel('Frequency(Hz)')
        ylabel('FAD(\DeltaF/F)')
        ylim([10^-18 1])
        sgtitle(strcat(visName,' low pass filter datahb at 1 hz at '))

        saveas(gcf,fullfile(saveDir_lpf,strcat(visName,'_FADPowerSpectra.png')));
        saveas(gcf,fullfile(saveDir_lpf,strcat(visName,'_FCpowerMap.fig')));