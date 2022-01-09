excelFile='Y:\CTREM\CTREM_new.xlsx';
excelRows=[2:11,17:22,27:66];  % Rows from Excell Database
% % % for ii = [2:11,17:22,27:63]
% % %     examplefcmaperalFCAnalysis(excelFileName,ii,[0.009 0.08])
% % %     examplefcmaperalFCAnalysis(excelFileName,ii,[0.4 4])
% % % end
% %
% %
% %
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



paramPath = what('bauerParams');
stdMask = load(fullfile(paramPath.path,'stdMask.mat'));
mask = stdMask.isbrain.*symisbrainall;

a=0;
b=0;
c=0;
d=0;
e=0;
f=0;
g=0;
h=0;
i=0;
k=0;
l=0;
m=0;


for n=excelRows;
    
    [~, ~, raw]=xlsread(excelFile,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    Group=raw{8};
    sex = raw{3};
    directory='Y:\CTREM\Mouse level averages';
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=['CTREM-seedFC-rows',num2str(n),'~',num2str(n),'-0p009-0p08.mat'];
    if ~exist(file,'file')
        file=['CTREM_new-seedFC-rows',num2str(n),'~',num2str(n),'-0p009-0p08.mat'];
    end
    load(file);
    tempISAfc=zeros(128,128,16,4);
    tempISAR = atanh(seedFCCat);
    for ii = 1:4
        tempISAfc(:,:,:,ii) = atanh(cell2mat(seedFCMapCat(1,ii)));
    end
    

    
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        if strcmp(sex,'Female')
            a=a+1;
            TremWT_ISA_R_female(:,:,:,a)=tempISAR;
            TremWT_ISA_fcmap_female(:,:,:,:,a)=tempISAfc;
        else
            b=b+1;
            TremWT_ISA_R_male(:,:,:,b)=tempISAR;
            TremWT_ISA_fcmap_male(:,:,:,:,b)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        if strcmp(sex,'Female')
            c=c+1;
            TremHet_ISA_R_female(:,:,:,c)=tempISAR;
            TremHet_ISA_fcmap_female(:,:,:,:,c)=tempISAfc;
        else
            d=d+1;
            TremHet_ISA_R_male(:,:,:,d)=tempISAR;
            TremHet_ISA_fcmap_male(:,:,:,:,d)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        if strcmp(sex,'Female')
            e=e+1;
            TremKO_ISA_R_female(:,:,:,e)=tempISAR;
            TremKO_ISA_fcmap_female(:,:,:,:,e)=tempISAfc;
        else
            f=f+1;
            TremKO_ISA_R_male(:,:,:,f)=tempISAR;
            TremKO_ISA_fcmap_male(:,:,:,:,f)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        if strcmp(sex,'Female')
            g=g+1;
            TremWT5XFAD_ISA_R_female(:,:,:,g)=tempISAR;
            TremWT5XFAD_ISA_fcmap_female(:,:,:,:,g)=tempISAfc;
        else
            h=h+1;
            TremWT5XFAD_ISA_R_male(:,:,:,h)=tempISAR;
            TremWT5XFAD_ISA_fcmap_male(:,:,:,:,h)=tempISAfc;
        end
        
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        if strcmp(sex,'Female')
            i=i+1;
            TremHet5XFAD_ISA_R_female(:,:,:,i)=tempISAR;
            TremHet5XFAD_ISA_fcmap_female(:,:,:,:,i)=tempISAfc;
        else
            k=k+1;
            TremHet5XFAD_ISA_R_male(:,:,:,k)=tempISAR;
            TremHet5XFAD_ISA_fcmap_male(:,:,:,:,k)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        if strcmp(sex,'Female')
            l=l+1;
            TremKO5XFAD_ISA_R_female(:,:,:,l)=tempISAR;
            TremKO5XFAD_ISA_fcmap_female(:,:,:,:,l)=tempISAfc;
        else
            m=m+1;
            TremKO5XFAD_ISA_R_male(:,:,:,m)=tempISAR;
            TremKO5XFAD_ISA_fcmap_male(:,:,:,:,m)=tempISAfc;
        end
        
        
    end
    clear seedFCCat seedFCMapCat
    clear tempISAR tempISAfc
    
end
Names=whos;
for n=1:size(Names,1)
    if numel(Names(n).size)==4
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),4);
        eval([newname '=temp;'])
        clear newname temp
        
    elseif numel(Names(n).size)==5
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),5);
        eval([newname '=temp;'])
        clear newname temp
    end    
end

% symisbrainall=zeros(128);
% symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
% symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
% symisbrainall=uint8(symisbrainall);
% symisbrainall=single(symisbrainall);

clear location name tempfc tempR tempfcMap junk n trash Time ...
    xform_isbrain file dir date saveloc raw database directory excelfiles





