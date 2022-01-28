import mouse.*
excelFile='Y:\CTREM\CTREM_new.xlsx';
excelRows=[2:11,17:22,27:66];

a=0;
b=0;
c=0;
d=0;
e=0;
f=0;
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
    processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        load(fullfile(saveDir,processedName_dataFluor_mouse),'NDim_fluor')
        TremWT_NDim_fluor(:,:,a)=NDim_fluor(:,:,1);
    end
    clearvars NDim_fluor
end

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
%     processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
%     
%     if strcmp(Group,'GP5.5(+)Trem2(het)')
%         b=b+1;
%         load(fullfile(saveDir,processedName_dataFluor_mouse),'NDim_fluor')
%         TremHet_NDim_fluor(:,:,b)=NDim_fluor(:,:,1);
%     end
%     clearvars NDim_fluor
% end



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
    processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    
    if strcmp(Group,'GP5.5(+)Trem2(KO)')
        c=c+1;
        load(fullfile(saveDir,processedName_dataFluor_mouse),'NDim_fluor')  
        TremKO_NDim_fluor(:,:,c)=NDim_fluor(:,:,1);
    end
    clearvars NDim_fluor
end

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
    processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        load(fullfile(saveDir,processedName_dataFluor_mouse),'NDim_fluor')
        TremWT5XFAD_NDim_fluor(:,:,d)=NDim_fluor(:,:,1);
        
    end
    clearvars NDim_fluor
end


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
%     processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
%     
%     if strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
%         e=e+1;
%         load(fullfile(saveDir,processedName_dataFluor_mouse),'NDim_fluor')
%         TremHet5XFAD_NDim_fluor(:,:,e)=NDim_fluor(:,:,1);
%         
%     end
%     clearvars NDim_fluor
% end



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
    processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    
    if strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        load(fullfile(saveDir,processedName_dataFluor_mouse),'NDim_fluor')
        TremKO5XFAD_NDim_fluor(:,:,f)=NDim_fluor(:,:,1);
    end
    clearvars NDim_fluor
end





