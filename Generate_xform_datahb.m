%         disp('loading  Non GRS data')
%
%        load(fullfile(saveDir,processedName_mouse),...
%              'xform_datahb_mouse_NoGSR','xform_jrgeco1a_mouse_NoGSR','xform_jrgeco1aCorr_mouse_NoGSR','xform_red_mouse_NoGSR','xform_FAD_mouse_NoGSR','xform_FADCorr_mouse_NoGSR','xform_green_mouse_NoGSR')
excelRows = [182,184,186,229,233,237];
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
nVx = 128;
nVy = 128;

xform_datahb_mice_NoGSR = [];
xform_isbrain_mice = ones(nVx ,nVy);
isbrain_mice = ones(nVx ,nVy);
for excelRow = excelRows
    
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':U',num2str(excelRow)]);
    
    rawdataloc = excelRaw{3};
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    info.nVx = 128;
    info.nVy = 128;
    sessionInfo.miceType = excelRaw{17};
    systemType =excelRaw{5};
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    sessionInfo.stimFrequency = excelRaw{16};
    sessionInfo.framerate = excelRaw{7};
    info.freqout=1;
    xform_datahb_mouse_NoGSR = [];
    for run = 1:3
        
        %     xform_= ones(128,128);
        processedName_mouse = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        
        
        disp('loading  Non GRS data')
        
        load(fullfile(saveDir,processedName_mouse),...
            'xform_datahb')
        xform_datahb = reshape(xform_datahb,128,128,2,750,10);
        xform_datahb_mouse_NoGSR = cat(5,xform_datahb_mouse_NoGSR,xform_datahb);
        clear xform_datahb
    end
    xform_datahb_mouse_NoGSR = mean(xform_datahb_mouse_NoGSR,5);
    xform_datahb_mice_NoGSR = cat(5,xform_datahb_mice_NoGSR,xform_datahb_mouse_NoGSR);
end
xform_datahb_mice_NoGSR = mean(xform_datahb_mice_NoGSR,5);
save('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-stim_processed_mice.mat','xform_datahb_mice_NoGSR','-append')

%
% %
%