import mouse.*
excelFile='V:\CTREM\CTREM.xlsx';
excelRows=[2:11,17:22,27:63];

a=0;
b=0;
c=0;
d=0;
e=0;
f=0;
% for excelRow = excelRows
%     disp(num2str(excelRow))
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{9}; mouseName = string(mouseName);%2
%     saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
%     sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
%     sessionInfo.darkFrameNum = excelRaw{16};%15
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{13};%5;
%     mask_newDir_new = saveDir;
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{15};%7
%     Group=excelRaw{8};
%     mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
%     processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
%     
%     if strcmp(Group,'GP5.5(+)Trem2(WT)')
%         a=a+1;
%         load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
%         TremWT_R_AllPix_hb(:,:,a)=R_AllPix_hb_mouse;
%     end
%     clearvars R_AllPix_hb_mouse R_AllPix_fluor_mouse
% end
% TremWT_R_AllPix_hb = nanmean(TremWT_R_AllPix_hb,3);
% 
% for excelRow = excelRows
%     disp(num2str(excelRow))
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{9}; mouseName = string(mouseName);%2
%     saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
%     sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
%     sessionInfo.darkFrameNum = excelRaw{16};%15
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{13};%5;
%     mask_newDir_new = saveDir;
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{15};%7
%     Group=excelRaw{8};
%     mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
%     processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
%     
%     if strcmp(Group,'GP5.5(+)Trem2(het)')
%         b=b+1;
%         load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
%         TremHet_R_AllPix_hb(:,:,b)=R_AllPix_hb_mouse;
%     end
%     clearvars R_AllPix_hb_mouse R_AllPix_fluor_mouse
% end
% TremHet_R_AllPix_hb = nanmean(TremHet_R_AllPix_hb,3);
% 
% 
% for excelRow = excelRows
%     disp(num2str(excelRow))
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{9}; mouseName = string(mouseName);%2
%     saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
%     sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
%     sessionInfo.darkFrameNum = excelRaw{16};%15
%     sessionInfo.mouseType = excelRaw{17};
%     systemType =excelRaw{13};%5;
%     mask_newDir_new = saveDir;
%     sessionInfo.framerate = excelRaw{7};
%     systemInfo.numLEDs = 4;
%     fs = excelRaw{15};%7
%     Group=excelRaw{8};
%     mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
%     load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
%     processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
% 
%     
%     if strcmp(Group,'GP5.5(+)Trem2(KO)')
%         c=c+1;
%         load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
%         TremKO_R_AllPix_hb(:,:,c)=R_AllPix_hb_mouse;
%     end
%     clearvars R_AllPix_hb_mouse R_AllPix_fluor_mouse
% end
% TremKO_R_AllPix_hb = nanmean(TremKO_R_AllPix_hb,3);

for excelRow = excelRows
    disp(num2str(excelRow))
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    Group=excelRaw{8};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
        TremWT5XFAD_R_AllPix_hb(:,:,d)=R_AllPix_hb_mouse;
        
    end
    clearvars R_AllPix_hb_mouse R_AllPix_fluor_mouse
end
TremWT5XFAD_R_AllPix_hb = nanmean(TremWT5XFAD_R_AllPix_hb,3);

for excelRow = excelRows
    disp(num2str(excelRow))
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    Group=excelRaw{8};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
    
    if strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        e=e+1;
        load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
        TremHet5XFAD_R_AllPix_hb(:,:,e)=R_AllPix_hb_mouse;
        
    end
    clearvars R_AllPix_hb_mouse R_AllPix_fluor_mouse
end
TremHet5XFAD_R_AllPix_hb = nanmean(TremHet5XFAD_R_AllPix_hb,3);


for excelRow = excelRows
    disp(num2str(excelRow))
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.darkFrameNum = excelRaw{16};%15
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    sessionInfo.framerate = excelRaw{7};
    systemInfo.numLEDs = 4;
    fs = excelRaw{15};%7
    Group=excelRaw{8};
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');

    if strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        load(fullfile(saveDir,processedName_dataHb_mouse),'R_AllPix_hb_mouse')
        TremKO5XFAD_R_AllPix_hb(:,:,f)=R_AllPix_hb_mouse;
    end
    clearvars R_AllPix_hb_mouse R_AllPix_fluor_mouse
end
TremKO5XFAD_R_AllPix_hb = nanmean(TremKO5XFAD_R_AllPix_hb,3);

