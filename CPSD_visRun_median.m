       clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
samplingRate =25;
load('AtlasandIsbrain.mat','AtlasSeeds')
mask_barrel = AtlasSeeds==9;
for excelRow = [181,183,185,228,232,236, 202,195,204,230,234,240];
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    miceName = excelRaw{2}; miceName = string(miceName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\Barrel_CPSD'),'dir')
        mkdir(strcat(saveDir,'\Barrel_CPSD'))
    end
    for n = 1:3
        disp(strcat(miceName,', run#',num2str(n)))
        saveName =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',miceName,'-',sessionType,num2str(n),'-Barrel-CPSD'));
        load(strcat(saveName,'.mat'),'hz','Pxx_HbT','Pxx_FAD','Pxx_Calcium','Pxy_CalciumFAD','Pxy_CalciumHbT','Pxy_FADHbT')
        

        % Calculate CPSD
        Pxy_CalciumFAD_magnitude = abs(median(Pxy_CalciumFAD,2));
        Pxy_FADHbT_magnitude     = abs(median(Pxy_FADHbT,2));
        Pxy_CalciumHbT_magnitude = abs(median(Pxy_CalciumHbT,2));

        Pxy_CalciumFAD_angle = angle(median(Pxy_CalciumFAD,2));
        Pxy_FADHbT_angle     = angle(median(Pxy_FADHbT,2));
        Pxy_CalciumHbT_angle = angle(median(Pxy_CalciumHbT,2));

        % Visualization of magnitude and phase
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,3,1)
        plot_distribution_prctile(hz,Pxx_Calcium','Color',[1 0 1])
        set(gca, 'XScale', 'log')
        set(gca, 'YScale', 'log')
        title('Calcium PSD','Color','m')
        xlabel('Frequency(Hz)')
        ylabel('(\DeltaF/F)^2/Hz')
        xlim([hz(1),samplingRate/2])
        grid on
        

        subplot(3,3,2)
        plot_distribution_prctile(hz,Pxx_FAD','Color',[0 0.5 0])
        set(gca, 'XScale', 'log')
        set(gca, 'YScale', 'log')
        title('FAD PSD','Color','g')
        xlabel('Frequency(Hz)')
        ylabel('(\DeltaF/F)^2/Hz')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,3)
        plot_distribution_prctile(hz,Pxx_HbT','Color',[0 0 0])
        set(gca, 'XScale', 'log')
        set(gca, 'YScale', 'log')
        title('HbT PSD','Color',[0 0 0])
        xlabel('Frequency(Hz)')
        ylabel('(\muM)^2/Hz')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,4)
        loglog(hz,Pxy_CalciumFAD_magnitude','Color',[1 0 0])
        title('Calcium and FAD CPSD Magnitude Median')
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,5)
        loglog(hz,Pxy_CalciumHbT_magnitude','Color',[1 0 0])
        title('Calcium and HbT CPSD Magnitude Median')
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,6)
        loglog(hz,Pxy_FADHbT_magnitude','Color',[1 0 0])
        title('FAD and HbT CPSD Magnitude Median')
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,7)
        semilogx(hz,Pxy_CalciumFAD_angle','Color',[0 0 1])
        title('Calcium and FAD CPSD Angle Median')
        xlabel('Frequency(Hz)')
        ylabel('Phase')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,8)
        semilogx(hz,Pxy_CalciumHbT_angle','Color',[0 0 1])
        title('Calcium and HbT CPSD Angle Median')
        xlabel('Frequency(Hz)')
        ylabel('Phase')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,9)
        semilogx(hz,Pxy_FADHbT_angle','Color',[0 0 1])
        title('FAD and HbT CPSD Angle Median')
        xlabel('Frequency(Hz)')
        ylabel('Phase')
        xlim([hz(1),samplingRate/2])
        grid on

        sgtitle(strcat('Welch Cross Power Spectral Density Estimate, ',miceName,' Run #',num2str(n)))

        saveas(gcf,strcat(saveName,'-median.fig'))
        saveas(gcf,strcat(saveName,'-median.png'))
        close all
    end
end

