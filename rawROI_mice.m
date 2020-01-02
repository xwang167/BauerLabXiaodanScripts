close all;clear all;clc
import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

excelRows = [231,235,241]; 

frame1_active_mice = zeros(8,750);
frame2_active_mice = zeros(8,750);
frame3_active_mice = zeros(8,750);
ii = 1;
for excelRow = excelRows
      [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    saveDir_new = fullfile("K:\RGECO\Raw",recDate);
    framerate = excelRaw{7};
    if excelRow<237
        runs = 1:3;
    else
        runs = 1:2;
    end
    for n = runs
        output = fullfile(saveDir_new,strcat(recDate,'-',mouseName,'-stim',num2str(n),'for Raw'));
        load(strcat(output,'xform_RawROI.mat'))
        frame1_active_mice(ii,:) = frame1_active;
        frame2_active_mice(ii,:) = frame2_active;
        frame3_active_mice(ii,:) = frame3_active;
        ii = ii+1;
                
    end
end



frame1_active_avg = mean(frame1_active_mice,1);
frame2_active_avg = mean(frame2_active_mice,1);
frame3_active_avg = mean(frame3_active_mice,1);

figure
x = (1:length( frame1_active_avg))/ framerate;
plot(x,frame1_active_avg.*100,'g-');
hold on
plot(x,frame2_active_avg*100,'r-');
hold on
plot(x,frame3_active_avg*100,'m-');



xlabel('Time(s)','FontSize',12)
ylabel('\DeltaR/R(%)','FontSize',12)

%xlim([0 (length(frame1_active)/ framerate)]);
% ylim([-maxVal maxVal])
legend('green','red','Red Fluor','location','southeast')

