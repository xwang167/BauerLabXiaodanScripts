clear ;close all;clc
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
samplingRate =25;
load('AtlasandIsbrain.mat','AtlasSeeds')
mask_barrel = AtlasSeeds==9;
for excelRow = [181,183,185,228,232,236, 202,195,204,230,234,240];
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if ~exist(strcat(saveDir,'\Barrel_CPSD'),'dir')
        mkdir(strcat(saveDir,'\Barrel_CPSD'))
    end
    for n = 1:3
        disp(strcat(mouseName,', run#',num2str(n)))
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed.mat');
        load(fullfile(saveDir,processedName),'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr','xform_isbrain')
        HbT =     squeeze(xform_datahb(:,:,1,:)+xform_datahb(:,:,2,:))*10^6;% convert to muM
        clear xform_datahb
        FAD =     squeeze(xform_FADCorr)                              *100; % convert to DeltaF/F%
        clear xform_FADCorr
        Calcium = squeeze(xform_jrgeco1aCorr)                         *100; % convert to DeltaF/F%
        clear xform_jrgeco1aCorr
        % Pad to full 10 min
        HbT    (:,:,end+1) = HbT    (:,:,end);
        FAD    (:,:,end+1) = FAD    (:,:,end);
        Calcium(:,:,end+1) = Calcium(:,:,end);
        % Reshape into 2 min
        HbT     = reshape(HbT,    128,128,120*samplingRate,[]);
        FAD     = reshape(FAD,    128,128,120*samplingRate,[]);
        Calcium = reshape(Calcium,128,128,120*samplingRate,[]);

        % Initialize
        Pxx_HbT     = zeros(513,5);
        Pxx_FAD     = zeros(513,5);
        Pxx_Calcium = zeros(513,5);

        Pxy_CalciumFAD = zeros(513,5);
        Pxy_CalciumHbT = zeros(513,5);
        Pxy_FADHbT     = zeros(513,5);
        for ii = 1:5
            % reshape
            HbT_barrel     = reshape(HbT    (:,:,:,ii),128*128,[]);
            FAD_barrel     = reshape(FAD    (:,:,:,ii),128*128,[]);
            Calcium_barrel = reshape(Calcium(:,:,:,ii),128*128,[]);

            % Barrel only
            HbT_barrel     = mean(HbT_barrel    (mask_barrel(:),:));
            FAD_barrel     = mean(FAD_barrel    (mask_barrel(:),:));
            Calcium_barrel = mean(Calcium_barrel(mask_barrel(:),:));

            % Calculate PSD
            [Pxx_HbT(:,ii),hz1] = pwelch(HbT_barrel,    [],[],[],samplingRate);
            Pxx_FAD(:,ii)      = pwelch(FAD_barrel,    [],[],[],samplingRate);
            Pxx_Calcium(:,ii)  = pwelch(Calcium_barrel,[],[],[],samplingRate);

            % Calculate CPSD
            [Pxy_CalciumFAD(:,ii),hz] = cpsd(Calcium_barrel,FAD_barrel,[],[],[],samplingRate);
            Pxy_CalciumHbT(:,ii)     = cpsd(Calcium_barrel,HbT_barrel,[],[],[],samplingRate);
            Pxy_FADHbT    (:,ii)     = cpsd(FAD_barrel,    HbT_barrel,[],[],[],samplingRate);
            
            Pxy_CalciumFAD_magnitude(:,ii) = abs(Pxy_CalciumFAD(:,ii));
            Pxy_FADHbT_magnitude    (:,ii) = abs(Pxy_FADHbT(:,ii));
            Pxy_CalciumHbT_magnitude(:,ii) = abs(Pxy_CalciumHbT(:,ii));

            Pxy_CalciumFAD_angle(:,ii) = atan2(imag(Pxy_CalciumFAD(:,ii)),real(Pxy_CalciumFAD(:,ii)));
            Pxy_FADHbT_angle    (:,ii) = atan2(imag(Pxy_FADHbT    (:,ii)),real(Pxy_FADHbT    (:,ii)));
            Pxy_CalciumHbT_angle(:,ii) = atan2(imag(Pxy_CalciumHbT(:,ii)),real(Pxy_CalciumHbT(:,ii)));

        end
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
        plot_distribution_prctile(hz,Pxy_CalciumFAD_magnitude','Color',[1 0 0])
        set(gca, 'XScale', 'log')
        set(gca, 'YScale', 'log')
        title('Calcium and FAD CPSD Magnitude')
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,5)
        plot_distribution_prctile(hz,Pxy_CalciumHbT_magnitude','Color',[1 0 0])
        set(gca, 'XScale', 'log')
        set(gca, 'YScale', 'log')
        title('Calcium and HbT CPSD Magnitude')
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,6)
        plot_distribution_prctile(hz,Pxy_FADHbT_magnitude','Color',[1 0 0])
        set(gca, 'XScale', 'log')
        set(gca, 'YScale', 'log')
        title('FAD and HbT CPSD Magnitude')
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,7)
        plot_distribution_prctile(hz,Pxy_CalciumFAD_angle','Color',[0 0 1])
        set(gca, 'XScale', 'log')
        title('Calcium and FAD CPSD Magnitude')
        xlabel('Frequency(Hz)')
        ylabel('Phase')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,8)
        plot_distribution_prctile(hz,Pxy_CalciumHbT_angle','Color',[0 0 1])
        set(gca, 'XScale', 'log')
        title('Calcium and HbT CPSD Magnitude')
        xlabel('Frequency(Hz)')
        ylabel('Phase')
        xlim([hz(1),samplingRate/2])
        grid on

        subplot(3,3,9)
        plot_distribution_prctile(hz,Pxy_FADHbT_angle','Color',[0 0 1])
        set(gca, 'XScale', 'log')
        title('FAD and HbT CPSD Magnitude')
        xlabel('Frequency(Hz)')
        ylabel('Phase')
        xlim([hz(1),samplingRate/2])
        grid on

        sgtitle(strcat('Welch Cross Power Spectral Density Estimate, ',mouseName,' Run #',num2str(n)))
        saveName =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Barrel-CPSD'));
        saveas(gcf,strcat(saveName,'.fig'))
        saveas(gcf,strcat(saveName,'.png'))
        close all

        clear Calcium FAD HbT
        save(strcat(saveName,'.mat'),'hz','Pxx_HbT','Pxx_FAD','Pxx_Calcium','Pxy_CalciumFAD','Pxy_CalciumHbT','Pxy_FADHbT')
    end
end

%% RGECO, Awake, Average across mice
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
excelRows = [181,183,185,228,232,236];
miceName = 'Awake RGECO';
saveDir_cat = "D:\XiaodanPaperData\cat";
CPSD_miceAverage(excelFile,excelRows,miceName,saveDir_cat,samplingRate)
CPSD_miceAverage_median(excelFile,excelRows,miceName,saveDir_cat,samplingRate)


%% RGECO, Anesthetized, Average across mice
excelFile = "X:\RGECO\DataBase_Xiaodan_3.xlsx";
excelRows = [202,195,204,230,234,240];
miceName = 'Anesthetized RGECO';
saveDir_cat = "D:\XiaodanPaperData\cat";
CPSD_miceAverage(excelFile,excelRows,miceName,saveDir_cat,samplingRate)
CPSD_miceAverage_median(excelFile,excelRows,miceName,saveDir_cat,samplingRate)



function CPSD_miceAverage(excelFile,excelRows,miceName,saveDir_cat,samplingRate)
%Initialize
Pxx_HbT_mice     = [];
Pxx_FAD_mice     = [];
Pxx_Calcium_mice = [];

Pxy_CalciumFAD_mice_magnitude = [];
Pxy_CalciumHbT_mice_magnitude = [];
Pxy_FADHbT_mice_magnitude     = [];

Pxy_CalciumFAD_mice_angle = [];
Pxy_CalciumHbT_mice_angle = [];
Pxy_FADHbT_mice_angle     = [];


for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    Pxx_HbT_mouse     = zeros(513,15);
    Pxx_FAD_mouse     = zeros(513,15);
    Pxx_Calcium_mouse = zeros(513,15);

    Pxy_CalciumFAD_mouse_magnitude = zeros(513,15);
    Pxy_CalciumHbT_mouse_magnitude = zeros(513,15);
    Pxy_FADHbT_mouse_magnitude     = zeros(513,15);

    Pxy_CalciumFAD_mouse_angle = zeros(513,15);
    Pxy_CalciumHbT_mouse_angle = zeros(513,15);
    Pxy_FADHbT_mouse_angle     = zeros(513,15);
    ind = 1;
    for n = 1:3
        % load
        saveName =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Barrel-CPSD'));
        load(strcat(saveName,'.mat'))
        for ii = 1:5
            % mice PSD
            Pxx_HbT_mouse    (:,ind) = Pxx_HbT    (:,ii);
            Pxx_FAD_mouse    (:,ind) = Pxx_FAD    (:,ii); 
            Pxx_Calcium_mouse(:,ind) = Pxx_Calcium(:,ii);
            % mice CPSD
            Pxy_CalciumFAD_mouse_magnitude(:,ind) = abs(Pxy_CalciumFAD(:,ii));
            Pxy_FADHbT_mouse_magnitude    (:,ind) = abs(Pxy_FADHbT    (:,ii));
            Pxy_CalciumHbT_mouse_magnitude(:,ind) = abs(Pxy_CalciumHbT(:,ii));

            Pxy_CalciumFAD_mouse_angle(:,ind) = angle(Pxy_CalciumFAD(:,ii));
            Pxy_FADHbT_mouse_angle    (:,ind) = angle(Pxy_FADHbT    (:,ii));
            Pxy_CalciumHbT_mouse_angle(:,ind) = angle(Pxy_CalciumHbT(:,ii));
            ind = ind+1;
        end
    end

    Pxx_Calcium_mice = cat(2,Pxx_Calcium_mice,Pxx_Calcium_mouse);
    Pxx_HbT_mice     = cat(2,Pxx_HbT_mice,    Pxx_HbT_mouse);
    Pxx_FAD_mice     = cat(2,Pxx_FAD_mice,    Pxx_FAD_mouse);
    
    Pxy_CalciumFAD_mice_magnitude = cat(2,Pxy_CalciumFAD_mice_magnitude,Pxy_CalciumFAD_mouse_magnitude);
    Pxy_CalciumHbT_mice_magnitude = cat(2,Pxy_CalciumHbT_mice_magnitude,Pxy_CalciumHbT_mouse_magnitude);
    Pxy_FADHbT_mice_magnitude     = cat(2,Pxy_FADHbT_mice_magnitude,Pxy_FADHbT_mouse_magnitude);

    Pxy_CalciumFAD_mice_angle = cat(2,Pxy_CalciumFAD_mice_angle,Pxy_CalciumFAD_mouse_angle);
    Pxy_CalciumHbT_mice_angle = cat(2,Pxy_CalciumHbT_mice_angle,Pxy_CalciumHbT_mouse_angle);
    Pxy_FADHbT_mice_angle     = cat(2,Pxy_FADHbT_mice_angle,    Pxy_FADHbT_mouse_angle);

    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(3,3,1)
    plot_distribution_prctile(hz,Pxx_Calcium_mouse','Color',[1 0 1])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('Calcium PSD','Color','m')
    xlabel('Frequency(Hz)')
    ylabel('(\DeltaF/F)^2/Hz')
    xlim([hz(1),samplingRate/2])
    grid on
    
    subplot(3,3,2)
    plot_distribution_prctile(hz,Pxx_FAD_mouse','Color',[0 0.5 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('FAD PSD','Color','g')
    xlabel('Frequency(Hz)')
    ylabel('(\DeltaF/F)^2/Hz')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,3)
    plot_distribution_prctile(hz,Pxx_HbT_mouse','Color',[0 0 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('HbT PSD','Color',[0 0 0])
    xlabel('Frequency(Hz)')
    ylabel('(\muM)^2/Hz')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,4)
    plot_distribution_prctile(hz,Pxy_CalciumFAD_mouse_magnitude','Color',[1 0 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('Calcium and FAD CPSD Magnitude')
    xlabel('Frequency(Hz)')
    ylabel('Magnitude')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,5)
    plot_distribution_prctile(hz,Pxy_CalciumHbT_mouse_magnitude','Color',[1 0 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('Calcium and HbT CPSD Magnitude')
    xlabel('Frequency(Hz)')
    ylabel('Magnitude')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,6)
    plot_distribution_prctile(hz,Pxy_FADHbT_mouse_magnitude','Color',[1 0 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('FAD and HbT CPSD Magnitude')
    xlabel('Frequency(Hz)')
    ylabel('Magnitude')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,7)
    plot_distribution_prctile(hz,Pxy_CalciumFAD_mouse_angle','Color',[0 0 1])
    set(gca, 'XScale', 'log')
    title('Calcium and FAD CPSD Angle')
    xlabel('Frequency(Hz)')
    ylabel('Phase')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,8)
    plot_distribution_prctile(hz,Pxy_CalciumHbT_mouse_angle','Color',[0 0 1])
    set(gca, 'XScale', 'log')
    title('Calcium and HbT CPSD Angle')
    xlabel('Frequency(Hz)')
    ylabel('Phase')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,9)
    plot_distribution_prctile(hz,Pxy_FADHbT_mouse_angle','Color',[0 0 1])
    set(gca, 'XScale', 'log')
    title('FAD and HbT CPSD Angle')
    xlabel('Frequency(Hz)')
    ylabel('Phase')
    xlim([hz(1),samplingRate/2])
    sgtitle(strcat(mouseName,', Welch Cross Power Spectral Density Estimate'))
    saveName_mouse =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',mouseName,'-Barrel-CPSD'));
    saveas(gcf,strcat(saveName_mouse,'.fig'))
    saveas(gcf,strcat(saveName_mouse,'.png'))
    close all    
end



figure('units','normalized','outerposition',[0 0 1 1])
subplot(3,3,1)
plot_distribution_prctile(hz,Pxx_Calcium_mice','Color',[1 0 1])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Calcium PSD','Color','m')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,2)
plot_distribution_prctile(hz,Pxx_FAD_mice','Color',[0 0.5 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('FAD PSD','Color','g')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,3)
plot_distribution_prctile(hz,Pxx_HbT_mice','Color',[0 0 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('HbT PSD','Color',[0 0 0])
xlabel('Frequency(Hz)')
ylabel('(\muM)^2/Hz')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,4)
plot_distribution_prctile(hz,Pxy_CalciumFAD_mice_magnitude','Color',[1 0 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Calcium and FAD CPSD Magnitude')
xlabel('Frequency(Hz)')
ylabel('Magnitude')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,5)
plot_distribution_prctile(hz,Pxy_CalciumHbT_mice_magnitude','Color',[1 0 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Calcium and HbT CPSD Magnitude')
xlabel('Frequency(Hz)')
ylabel('Magnitude')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,6)
plot_distribution_prctile(hz,Pxy_FADHbT_mice_magnitude','Color',[1 0 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('FAD and HbT CPSD Magnitude')
xlabel('Frequency(Hz)')
ylabel('Magnitude')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,7)
plot_distribution_prctile(hz,Pxy_CalciumFAD_mice_angle','Color',[0 0 1])
set(gca, 'XScale', 'log')
title('Calcium and FAD CPSD Angle')
xlabel('Frequency(Hz)')
ylabel('Phase')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,8)
plot_distribution_prctile(hz,Pxy_CalciumHbT_mice_angle','Color',[0 0 1])
set(gca, 'XScale', 'log')
title('Calcium and HbT CPSD Angle')
xlabel('Frequency(Hz)')
ylabel('Phase')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,9)
plot_distribution_prctile(hz,Pxy_FADHbT_mice_angle','Color',[0 0 1])
set(gca, 'XScale', 'log')
title('FAD and HbT CPSD Angle')
xlabel('Frequency(Hz)')
ylabel('Phase')
xlim([hz(1),samplingRate/2])
grid on

sgtitle(strcat(miceName,', Welch Cross Power Spectral Density Estimate'))
saveName_mice =  fullfile(saveDir_cat,'Barrel_CPSD', strcat(recDate,'-',miceName,'-Barrel-CPSD'));
saveas(gcf,strcat(saveName_mice,'.fig'))
saveas(gcf,strcat(saveName_mice,'.png'))
end


function CPSD_miceAverage_median(excelFile,excelRows,miceName,saveDir_cat,samplingRate)
%Initialize
Pxx_HbT_mice     = [];
Pxx_FAD_mice     = [];
Pxx_Calcium_mice = [];

Pxy_CalciumFAD_mice = [];
Pxy_CalciumHbT_mice = [];
Pxy_FADHbT_mice    = [];

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    Pxx_HbT_mouse     = zeros(513,15);
    Pxx_FAD_mouse     = zeros(513,15);
    Pxx_Calcium_mouse = zeros(513,15);

    Pxy_CalciumFAD_mouse = zeros(513,15);
    Pxy_CalciumHbT_mouse = zeros(513,15);
    Pxy_FADHbT_mouse     = zeros(513,15);

    ind = 1;
    for n = 1:3
        % load
        saveName =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-Barrel-CPSD'));
        load(strcat(saveName,'.mat'))
        for window = 1:5
            % mouse PSD
            Pxx_HbT_mouse    (:,ind) = Pxx_HbT    (:,window);
            Pxx_FAD_mouse    (:,ind) = Pxx_FAD    (:,window); 
            Pxx_Calcium_mouse(:,ind) = Pxx_Calcium(:,window);
            % mouse CPSD
            Pxy_CalciumFAD_mouse(:,ind) = Pxy_CalciumFAD(:,window);
            Pxy_FADHbT_mouse    (:,ind) = Pxy_FADHbT    (:,window);
            Pxy_CalciumHbT_mouse(:,ind) = Pxy_CalciumHbT(:,window);

            ind = ind+1;
        end
    end

    Pxx_Calcium_mice = cat(2,Pxx_Calcium_mice,Pxx_Calcium_mouse);
    Pxx_HbT_mice     = cat(2,Pxx_HbT_mice,    Pxx_HbT_mouse);
    Pxx_FAD_mice     = cat(2,Pxx_FAD_mice,    Pxx_FAD_mouse);
    
    Pxy_CalciumFAD_mice = cat(2,Pxy_CalciumFAD_mice,Pxy_CalciumFAD_mouse);
    Pxy_CalciumHbT_mice = cat(2,Pxy_CalciumHbT_mice,Pxy_CalciumHbT_mouse);
    Pxy_FADHbT_mice     = cat(2,Pxy_FADHbT_mice,Pxy_FADHbT_mouse);

    Pxy_CalciumFAD_mouse_magnitude = abs(median(Pxy_CalciumFAD_mouse,2));
    Pxy_CalciumHbT_mouse_magnitude = abs(median(Pxy_CalciumHbT_mouse,2));
    Pxy_FADHbT_mouse_magnitude     = abs(median(Pxy_FADHbT_mouse,    2));

    Pxy_CalciumFAD_mouse_angle = angle(median(Pxy_CalciumFAD_mouse,2));
    Pxy_CalciumHbT_mouse_angle = angle(median(Pxy_CalciumHbT_mouse,2));
    Pxy_FADHbT_mouse_angle     = angle(median(Pxy_FADHbT_mouse,    2));

    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(3,3,1)
    plot_distribution_prctile(hz,Pxx_Calcium_mouse','Color',[1 0 1])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('Calcium PSD','Color','m')
    xlabel('Frequency(Hz)')
    ylabel('(\DeltaF/F)^2/Hz')
    xlim([hz(1),samplingRate/2])
    grid on
    
    subplot(3,3,2)
    plot_distribution_prctile(hz,Pxx_FAD_mouse','Color',[0 0.5 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('FAD PSD','Color','g')
    xlabel('Frequency(Hz)')
    ylabel('(\DeltaF/F)^2/Hz')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,3)
    plot_distribution_prctile(hz,Pxx_HbT_mouse','Color',[0 0 0])
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title('HbT PSD','Color',[0 0 0])
    xlabel('Frequency(Hz)')
    ylabel('(\muM)^2/Hz')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,4)
    loglog(hz,Pxy_CalciumFAD_mouse_magnitude','Color',[1 0 0])
    title('Calcium and FAD CPSD Magnitude Median')
    xlabel('Frequency(Hz)')
    ylabel('Magnitude')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,5)
    loglog(hz,Pxy_CalciumHbT_mouse_magnitude','Color',[1 0 0])
    title('Calcium and HbT CPSD Magnitude Median')
    xlabel('Frequency(Hz)')
    ylabel('Magnitude')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,6)
    loglog(hz,Pxy_FADHbT_mouse_magnitude','Color',[1 0 0])
    title('FAD and HbT CPSD Magnitude Median')
    xlabel('Frequency(Hz)')
    ylabel('Magnitude')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,7)
    semilogx(hz,Pxy_CalciumFAD_mouse_angle','Color',[0 0 1])
    title('Calcium and FAD CPSD Angle Median')
    xlabel('Frequency(Hz)')
    ylabel('Phase')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,8)
    semilogx(hz,Pxy_CalciumHbT_mouse_angle','Color',[0 0 1])
    title('Calcium and HbT CPSD Angle Median')
    xlabel('Frequency(Hz)')
    ylabel('Phase')
    xlim([hz(1),samplingRate/2])
    grid on

    subplot(3,3,9)
    semilogx(hz,Pxy_FADHbT_mouse_angle','Color',[0 0 1])
    title('FAD and HbT CPSD Angle Median')
    xlabel('Frequency(Hz)')
    ylabel('Phase')
    xlim([hz(1),samplingRate/2])
    sgtitle(strcat(mouseName,', Welch Cross Power Spectral Density Estimate'))
    saveName_mouse =  fullfile(saveDir,'Barrel_CPSD', strcat(recDate,'-',mouseName,'-Barrel-CPSD'));
    saveas(gcf,strcat(saveName_mouse,'-median.fig'))
    saveas(gcf,strcat(saveName_mouse,'-median.png'))
    close all    
end

Pxy_CalciumFAD_mice_magnitude = abs(median(Pxy_CalciumFAD_mice,2));
Pxy_CalciumHbT_mice_magnitude = abs(median(Pxy_CalciumHbT_mice,2));
Pxy_FADHbT_mice_magnitude     = abs(median(Pxy_FADHbT_mice,    2));

Pxy_CalciumFAD_mice_angle = angle(median(Pxy_CalciumFAD_mice,2));
Pxy_CalciumHbT_mice_angle = angle(median(Pxy_CalciumHbT_mice,2));
Pxy_FADHbT_mice_angle     = angle(median(Pxy_FADHbT_mice,    2));

figure('units','normalized','outerposition',[0 0 1 1])
subplot(3,3,1)
plot_distribution_prctile(hz,Pxx_Calcium_mice','Color',[1 0 1])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Calcium PSD','Color','m')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,2)
plot_distribution_prctile(hz,Pxx_FAD_mice','Color',[0 0.5 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('FAD PSD','Color','g')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,3)
plot_distribution_prctile(hz,Pxx_HbT_mice','Color',[0 0 0])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('HbT PSD','Color',[0 0 0])
xlabel('Frequency(Hz)')
ylabel('(\muM)^2/Hz')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,4)
loglog(hz,Pxy_CalciumFAD_mice_magnitude','Color',[1 0 0])
title('Calcium and FAD CPSD Magnitude Median')
xlabel('Frequency(Hz)')
ylabel('Magnitude')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,5)
loglog(hz,Pxy_CalciumHbT_mice_magnitude','Color',[1 0 0])
title('Calcium and HbT CPSD Magnitude Median')
xlabel('Frequency(Hz)')
ylabel('Magnitude')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,6)
loglog(hz,Pxy_FADHbT_mice_magnitude','Color',[1 0 0])
title('FAD and HbT CPSD Magnitude Median')
xlabel('Frequency(Hz)')
ylabel('Magnitude')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,7)
semilogx(hz,Pxy_CalciumFAD_mice_angle','Color',[0 0 1])
title('Calcium and FAD CPSD Angle Median')
xlabel('Frequency(Hz)')
ylabel('Phase')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,8)
semilogx(hz,Pxy_CalciumHbT_mice_angle','Color',[0 0 1])
title('Calcium and HbT CPSD Angle Median')
xlabel('Frequency(Hz)')
ylabel('Phase')
xlim([hz(1),samplingRate/2])
grid on

subplot(3,3,9)
semilogx(hz,Pxy_FADHbT_mice_angle','Color',[0 0 1])
title('FAD and HbT CPSD Angle Median')
xlabel('Frequency(Hz)')
ylabel('Phase')
xlim([hz(1),samplingRate/2])
grid on

sgtitle(strcat(miceName,', Welch Cross Power Spectral Density Estimate'))
saveName_mice =  fullfile(saveDir_cat,'Barrel_CPSD', strcat(recDate,'-',miceName,'-Barrel-CPSD'));
saveas(gcf,strcat(saveName_mice,'-median.fig'))
saveas(gcf,strcat(saveName_mice,'-median.png'))

end