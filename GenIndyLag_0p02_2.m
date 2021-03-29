import mouse.*

excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";


% 
% % 
excelRows = [181,183,185,228,232,236]; %[195 202 204 230 234 240];%[181,183,185,228,232,236];%321:327;

runs = 1:3;

load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
load('D:\OIS_Process\noVasculaturemask.mat')


for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{7};
    %mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    %load(fullfile(mask_newDir,mask_newName), 'xform_isbrain')
    %save(fullfile(mask_newDir_new,mask_newName_new),'xform_isbrain')
    maskName = strcat(recDate,'-',mouseName,'-LandmarksAndmask','.mat');
    load(fullfile(saveDir,maskName),'xform_isbrain')
    for n = runs
        visName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n));
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        disp('loading processed data')

% % 
        if strcmp(sessionType,'fc')
            if strcmp(sessionInfo.mouseType,'jrgeco1a')
                load(fullfile(saveDir, processedName),'lagTimeTrial_HbTCalcium','lagAmpTrial_HbTCalcium',...
                    'lagTimeTrial_FADCalcium', 'lagAmpTrial_FADCalcium',...
                   'lagTimeTrial_HbTFAD', 'lagAmpTrial_HbTFAD')
                  edgeLen =1;
                tZone = 4;
                corrThr = 0;
                validRange = - edgeLen: round(tZone*fs);
                tLim = [0 1.5];
                tLim_FAD = [0 0.3];
                rLim = [-1 1];
                disp(strcat('Lag analysis on ', recDate, '', mouseName, ' run#', num2str(n)))
%
                                figure;
                                colormap jet;
                                subplot(2,3,1); imagesc(lagTimeTrial_HbTCalcium,tLim); axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,2); imagesc(lagTimeTrial_FADCalcium,tLim_FAD);axis image off;h = colorbar;ylabel(h,'t(s)');title('Calcium FAD ');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,3); imagesc(lagTimeTrial_HbTFAD,[0 1.5]);axis image off;h = colorbar;ylabel(h,'t(s)');title('FAD HbT');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                              
                                subplot(2,3,4); imagesc(lagAmpTrial_HbTCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,5); imagesc(lagAmpTrial_FADCalcium,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                subplot(2,3,6); imagesc(lagAmpTrial_HbTFAD,rLim);axis image off;h = colorbar;ylabel(h,'r');hold on;imagesc(xform_WL,'AlphaData',1-mask_new);
                                suptitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n)))
                                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag.png')));
                                saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_Lag.fig')));
                                close all

           end
            close all
        end
    end
end
