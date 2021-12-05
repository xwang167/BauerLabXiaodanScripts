
excelRows = [181,183,185,228,232,236,195,202,204,230,234,240];
runs = 1:3;

for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    lagTimeTrial_HbTCalcium_vector_mouse = nan(length(runs),length(frequency));
    lagApmTrial_HbTCalcium_vector_mouse = nan(length(runs),length(frequency));
    lagTimeTrial_FADCalcium_vector_mouse = nan(length(runs),length(frequency));
    lagAmpTrial_FADCalcium_vector_mouse = nan(length(runs),length(frequency));
    disp(strcat('Average on ', recDate, ' ', mouseName))
    for n = runs
        saveFreqCorr = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_freqLag','.mat');
        load(fullfile(saveDir,saveFreqCorr))
        lagTimeTrial_HbTCalcium_vector_mouse(n,:) = lagTimeTrial_HbTCalcium_vector;
        lagApmTrial_HbTCalcium_vector_mouse(n,:) = lagAmpTrial_HbTCalcium_vector;
        lagTimeTrial_FADCalcium_vector_mouse(n,:) = lagTimeTrial_FADCalcium_vector;
        lagAmpTrial_FADCalcium_vector_mouse(n,:) = lagAmpTrial_FADCalcium_vector;
    end
    lagTimeTrial_HbTCalcium_vector_mouse = mean(lagTimeTrial_HbTCalcium_vector_mouse,1);
    lagApmTrial_HbTCalcium_vector_mouse = mean(lagApmTrial_HbTCalcium_vector_mouse,1);
    lagTimeTrial_FADCalcium_vector_mouse = mean(lagTimeTrial_FADCalcium_vector_mouse,1);
    lagAmpTrial_FADCalcium_vector_mouse = mean(lagAmpTrial_FADCalcium_vector_mouse,1);
    
    figure
    subplot(1,2,1)
    plot(frequency,lagTimeTrial_HbTCalcium_vector_mouse,'k')
    xlable('Frequency(Hz)')
    ylabel('Lag Time(s)')
    hold on
    plot(frequency,lagTimeTrial_FADCalcium_vector_mouse,'g')
    legend('Calcium HbT','Calcium FAD')
    
    subplot(1,2,2)
    plot(frequency,lagAmpTrial_HbTCalcium_vector_mouse,'k')
    xlable('Frequency(Hz)')
    ylabel('Correlation')
    hold on
    plot(frequency,lagAmpTrial_FADCalcium_vector_mouse,'g')
    legend('Calcium HbT','Calcium FAD')
    suptitle(strcat(recDate,'-',mouseName,'-',sessionType))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_freqLag.png')));
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',miceName,'-',sessionType,'_freqLag.fig')));
    saveFreqCorr_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_freqLag','.mat');
    if exist(fullfile(saveDir,saveFreqCorr_mouse),'file')
        save(fullfile(saveDir,saveFreqCorr_mouse),'lagTimeTrial_HbTCalcium_vector_mouse',...
            'lagApmTrial_HbTCalcium_vector_mouse', 'lagTimeTrial_FADCalcium_vector_mouse',...
            'lagAmpTrial_FADCalcium_vector_mouse','frequency','-append')
    else
        save(fullfile(saveDir,saveFreqCorr_mouse),'lagTimeTrial_HbTCalcium_vector_mouse',...
            'lagApmTrial_HbTCalcium_vector_mouse', 'lagTimeTrial_FADCalcium_vector_mouse',...
            'lagAmpTrial_FADCalcium_vector_mouse','frequency','-v7.3')
    end
    close all
end


%[195 202 204 230 234 240];

excelRows = [181,183,185,228,232,236];
lagTimeTrial_HbTCalcium_vector_mice = nan(length(excelRows),length(frequency));
lagApmTrial_HbTCalcium_vector_mice = nan(length(excelRows),length(frequency));
lagTimeTrial_FADCalcium_vector_mice = nan(length(excelRows),length(frequency));
lagAmpTrial_FADCalcium_vector_mice = nan(length(excelRows),length(frequency));
saveDir_cat = 'L:\RGECO\cat';
jj = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    saveFreqCorr_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'_freqLag','.mat');
    load(fullfile(saveDir,saveFreqCorr_mouse))
    
    lagTimeTrial_HbTCalcium_vector_mice(jj,:) = lagTimeTrial_HbTCalcium_vector_mouse;
    lagApmTrial_HbTCalcium_vector_mice(jj,:) = lagAmpTrial_HbTCalcium_vector_mouse;
    lagTimeTrial_FADCalcium_vector_mice(jj,:) = lagTimeTrial_FADCalcium_vector_mouse;
    lagAmpTrial_FADCalcium_vector_mice(jj,:) = lagAmpTrial_FADCalcium_vector_mouse;
    jj = jj+1;   
end

figure
options.handle = figure(1);
options.color_area = [0 0 0];
options.color_line = [0 0 0];
options.alpha = 0.5;
options.line_width = 2;
options.x_axis = frequency;
options.error = 'c95';
subplot(1,2,1)

plot_areaerrorbar(lagTimeTrial_HbTCalcium_vector_mice',options)
options.color_area = [0 1 0];
options.color_line = [0 1 0];
hold on
plot_areaerrorbar(lagTimeTrial_FADCalcium_vector_mice',options)
xlable('Frequency(Hz)')
ylabel('Lag Time(s)')
legend('Calcium HbT','Calcium FAD')
subplot(1,2,2)
options.color_area = [0 0 0];
options.color_line = [0 0 0];
plot_areaerrorbar(lagAmpTrial_HbTCalcium_vector_mice',options)
options.color_area = [0 1 0];
options.color_line = [0 1 0];
hold on
plot_areaerrorbar(lagAmpTrial_FADCalcium_vector_mice',options)
xlable('Frequency(Hz)')
ylabel('Lag Amplitude')
legend('Calcium HbT','Calcium FAD')
suptitle('Awake')