HbO_mice = [];
HbR_mice = [];
HbT_mice = [];
FAD_mice = [];
calcium_mice = [];
excelRows = [182,184,186,229,233,237];%[203,205,231,235,241];%182,184,186,203,   excelRows =[203 231 235 241];%,203, 231, 235, 241
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";
runs = 1:3;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    sessionInfo.darkFrameNum = excelRaw{15};
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{5};
    maskDir_new = saveDir;
    rawdataloc = excelRaw{3};
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    sessionInfo.stimblocksize = excelRaw{11};
    sessionInfo.stimbaseline=excelRaw{12};
    sessionInfo.stimduration = excelRaw{13};
    maskDir = strcat('L:\RGECO\Kenny\', recDate, '\');
    maskName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(1),'-datafluor','.mat');
    if ~exist(fullfile(maskDir,maskName),'file')
        maskDir = saveDir;
        maskName = strcat(recDate,'-',mouseName,'-LandmarksAndMask','.mat');
        
    end
    load(fullfile(maskDir,maskName), 'xform_isbrain')
    xform_isbrain = double(xform_isbrain);
    if ~isempty(find(isnan(xform_isbrain), 1))
        xform_isbrain(isnan(xform_isbrain))=0;
    end
    for n = runs
        processedName=strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'_processed','.mat');
        load(fullfile(saveDir,processedName), 'goodBlocks')
        if ~isempty(goodBlocks)
            load(fullfile(saveDir,processedName), 'xform_datahb','xform_FADCorr','xform_jrgeco1aCorr')
            
            xform_datahb = reshape(xform_datahb,128,128,2,[],10);
            xform_FADCorr = reshape(xform_FADCorr,128,128,[],10);
            xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[],10);
            HbO = squeeze(mean(xform_datahb(:,:,1,:,goodBlocks),5));
            HbR = squeeze(mean(xform_datahb(:,:,2,:,goodBlocks),5));
            clear xform_datahb
            HbT = HbO + HbR;
            FAD = squeeze(mean(xform_FADCorr(:,:,:,goodBlocks),4));
            clear xform_FADCorr
            calcium = squeeze(mean(xform_jrgeco1aCorr(:,:,:,goodBlocks),4));
            clear xform_jrgeco1aCorr
            
            HbO_mice = cat(4,HbO_mice,HbO);
            HbR_mice = cat(4,HbR_mice,HbR);
            HbT_mice = cat(4,HbT_mice,HbT);
            FAD_mice = cat(4,FAD_mice,FAD);
            calcium_mice = cat(4,calcium_mice,calcium);
            
        end
        
    end
end
HbO_mice = mean(HbO_mice,4)*10^6;
HbR_mice = mean(HbR_mice,4)*10^6;
HbT_mice = mean(HbT_mice,4)*10^6;
FAD_mice = mean(FAD_mice,4)*100;
calcium_mice = mean(calcium_mice,4)*100;

% load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
% load('D:\OIS_Process\noVasculaturemask.mat')
% figure
% imagesc(peakMap_calcium,[-0.04 0.04])
% colormap jet
% axis image off
% [X,Y] = meshgrid(1:128,1:128);
% [x1,y1] = ginput(1);
% [x2,y2] = ginput(1);
% radius = sqrt((x1-x2)^2+(y1-y2)^2);
% ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
% max_ROI = prctile(peakMap_calcium(ROI),99);
% temp = double(peakMap_calcium).*double(ROI);
% ROI = temp>max_ROI*0.75;
% hold on
% ROI_contour = bwperim(ROI);
% [~,c] = contour( ROI_contour,'r');
% c.LineWidth = 0.001;
% save('L:\ROIforGoodBlocks','ROI')
load('L:\ROIforGoodBlocks','ROI')
ibi = logical(reshape(ROI,128*128,1));
HbO_mice = reshape(HbO_mice,128*128,size(HbO_mice,3));
HbR_mice = reshape(HbR_mice,128*128,size(HbR_mice,3));
HbT_mice = reshape(HbT_mice,128*128,size(HbT_mice,3));
FAD_mice = reshape(FAD_mice,128*128,size(FAD_mice,3));
calcium_mice = reshape(calcium_mice,128*128,size(calcium_mice,3));

timetrace_HbO_mice = mean(HbO_mice(ibi,:),1);
timetrace_HbR_mice = mean(HbR_mice(ibi,:),1);
timetrace_HbT_mice = mean(HbT_mice(ibi,:),1);
timetrace_FAD_mice = mean(FAD_mice(ibi,:),1);
timetrace_calcium_mice = mean(calcium_mice(ibi,:),1);

figure
plot((1:750)/25,timetrace_calcium_mice,'m-')
hold on
plot((1:750)/25,timetrace_FAD_mice,'g-')
hold on
yyaxis right
plot((1:750)/25,timetrace_HbO_mice,'r-')
hold on
plot((1:750)/25,timetrace_HbR_mice,'b-')
hold on
plot((1:750)/25,timetrace_HbT_mice,'k-')
