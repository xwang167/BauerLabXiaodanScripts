excelFile='Y:\CTREM\CTREM_new.xlsx';
excelRows=[2:11,17:22,27:66];  % Rows from Excell Database

symisbrainall = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    sessionType = excelRaw{14}; sessionType = sessionType(3:end-2);%6
    sessionInfo.mouseType = excelRaw{17};
    systemType =excelRaw{13};%5;
    mask_newDir_new = saveDir;
    mask_newName = strcat(recDate,'-',mouseName,'-',sessionType,'1-datahb','.mat');
    load(fullfile(mask_newDir_new,mask_newName),'xform_isbrain')
    symisbrainall = symisbrainall.*xform_isbrain;
end
symisbrainall = symisbrainall & fliplr(symisbrainall);
% 



paramPath = what('bauerParams');
load('D:\OIS_Process\noVasculaturemask.mat')

mask = (leftMask+rightMask)*symisbrainall;

a=0;
b=0;
c=0;
d=0;


for n=excelRows;
    
    [~, ~, raw]=xlsread(excelFile,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{9};
    Group=raw{8};
    directory=['Y:\CTREM\',Date];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=[Date,'-',Mouse,'-avgPower.mat'];
    load(file,'power_map_mouse_avg');
    
   for ii = 1:4
    tempFullpower(:,:,ii) = squeeze(power_map_mouse_avg(:,:,1,ii)).*mask;   
    tempISApower(:,:,ii) = squeeze(power_map_mouse_avg(:,:,2,ii)).*mask;
    tempDeltapower(:,:,ii) = squeeze(power_map_mouse_avg(:,:,3,ii)).*mask;
    end

        
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        TremWT_Full_Power(:,:,:,a)=tempFullpower;
        TremWT_ISA_Power(:,:,:,a)=tempISApower;
        TremWT_Delta_Power(:,:,:,a)=tempDeltapower;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        b=b+1;
        TremKO_Full_Power(:,:,:,b)=tempFullpower;
        TremKO_ISA_Power(:,:,:,b)=tempISApower;
        TremKO_Delta_Power(:,:,:,b)=tempDeltapower;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        c=c+1;
        TremWT5XFAD_Full_Power(:,:,:,c)=tempFullpower;
        TremWT5XFAD_ISA_Power(:,:,:,c)=tempISApower;
        TremWT5XFAD_Delta_Power(:,:,:,c)=tempDeltapower;
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        d=d+1;
        TremKO5XFAD_Full_Power(:,:,:,d)=tempFullpower;
        TremKO5XFAD_ISA_Power(:,:,:,d)=tempISApower;
        TremKO5XFAD_Delta_Power(:,:,:,d)=tempDeltapower;
        
    end
    clear tempFullpower tempISApower tempDeltapower power_map_mouse_avg
    
end


Names=whos;
for n=1:size(Names,1)
    if numel(Names(n).size)==4
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),4);
        eval([newname '=temp;'])
        clear newname temp
    end
end

clear location name tempfc tempR tempfcMap junk n trash Time ...
    xform_isbrain file dir date saveloc raw database directory excelfiles




