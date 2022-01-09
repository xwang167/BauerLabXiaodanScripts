excelFile='Y:\CTREM\CTREM_new.xlsx';
excelRows=[2:11,17:22,27:66];  % Rows from Excell Database
% % % for ii = [2:11,17:22,27:63]
% % %     exampleBilateralFCAnalysis(excelFileName,ii,[0.009 0.08])
% % %     exampleBilateralFCAnalysis(excelFileName,ii,[0.4 4])
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
%
% WTFile = 'V:\CTREM\WT.xlsx';
%     exampleBilateralFCAnalysis_xw(WTFile,2:15,[0.009 0.08],symisbrainall)
% exampleBilateralFCAnalysis_xw(WTFile,2:15,[0.4 4],symisbrainall)
%
% WTFADFile = 'V:\CTREM\WTFAD.xlsx';
%     exampleBilateralFCAnalysis_xw(WTFADFile,2:14,[0.009 0.08],symisbrainall)
% exampleBilateralFCAnalysis_xw(WTFADFile,2:14,[0.4 4],symisbrainall)
%
% HETFile = 'V:\CTREM\HET.xlsx';
%     exampleBilateralFCAnalysis_xw(HETFile,2:7,[0.009 0.08],symisbrainall)
% exampleBilateralFCAnalysis_xw(HETFile,2:7,[0.4 4],symisbrainall)
%
% HETFADFile = 'V:\CTREM\HETFAD.xlsx';
%     exampleBilateralFCAnalysis_xw(HETFADFile,2:7,[0.009 0.08],symisbrainall)
% exampleBilateralFCAnalysis_xw(HETFADFile,2:7,[0.4 4],symisbrainall)
%
% KOFile = 'V:\CTREM\KO.xlsx';
%     exampleBilateralFCAnalysis_xw(KOFile,2:8,[0.009 0.08],symisbrainall)
%  exampleBilateralFCAnalysis_xw(KOFile,2:8,[0.4 4],symisbrainall)
%
% KOFADFile = 'V:\CTREM\KOFAD.xlsx';
%     exampleBilateralFCAnalysis_xw(KOFADFile,2:8,[0.009 0.08],symisbrainall)
% exampleBilateralFCAnalysis_xw(KOFADFile,2:8,[0.4 4],symisbrainall)



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
    file=['CTREM-bilateralFC-rows',num2str(n),'~',num2str(n),'-0p009-0p08.mat'];
    if ~exist(file,'file')
        file=['CTREM_new-bilateralFC-rows',num2str(n),'~',num2str(n),'-0p009-0p08.mat'];
    end
    load(file);
    
    for ii = 1:4
        tempISAfc(:,:,ii) = atanh(cell2mat(bilatFCMapCat(1,ii))).*mask;
    end
    
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        if strcmp(sex,'Female')
            a=a+1;
            TremWT_ISA_Bilat_female(:,:,:,a)=tempISAfc;
        else
            b=b+1;
            TremWT_ISA_Bilat_male(:,:,:,b)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        if strcmp(sex,'Female')
            c=c+1;
            TremHet_ISA_Bilat_female(:,:,:,c)=tempISAfc;
        else
            d=d+1;
            TremHet_ISA_Bilat_male(:,:,:,d)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        if strcmp(sex,'Female')
            e=e+1;
            TremKO_ISA_Bilat_female(:,:,:,e)=tempISAfc;
        else
            f=f+1;
            TremKO_ISA_Bilat_male(:,:,:,f)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        if strcmp(sex,'Female')
            g=g+1;
            TremWT5XFAD_ISA_Bilat_female(:,:,:,g)=tempISAfc;
        else
            h=h+1;
            TremWT5XFAD_ISA_Bilat_male(:,:,:,h)=tempISAfc;
        end
        
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        if strcmp(sex,'Female')
            i=i+1;
            TremHet5XFAD_ISA_Bilat_female(:,:,:,i)=tempISAfc;
        else
            k=k+1;
            TremHet5XFAD_ISA_Bilat_male(:,:,:,k)=tempISAfc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        if strcmp(sex,'Female')
            l=l+1;
            TremKO5XFAD_ISA_Bilat_female(:,:,:,l)=tempISAfc;
        else
            m=m+1;
            TremKO5XFAD_ISA_Bilat_male(:,:,:,m)=tempISAfc;
        end
        
        
    end
    clear tempISAR tempISAfc tempDeltaR tempDeltafc
    
end


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
    directory=['Y:\CTREM\Mouse level averages\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=['CTREM-bilateralFC-rows',num2str(n),'~',num2str(n),'-0p4-4.mat'];
    if ~exist(file,'file')
        file=['CTREM_new-bilateralFC-rows',num2str(n),'~',num2str(n),'-0p4-4.mat'];
    end
    load(file);
    
    for ii = 1:4
        tempDeltafc(:,:,ii) = atanh(cell2mat(bilatFCMapCat(1,ii))).*mask;
    end
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        if strcmp(sex,'Female')
            a=a+1;
            TremWT_Delta_Bilat_female(:,:,:,a)=tempDeltafc;
        else
            b=b+1;
            TremWT_Delta_Bilat_male(:,:,:,b)=tempDeltafc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        if strcmp(sex,'Female')
            c=c+1;
            TremHet_Delta_Bilat_female(:,:,:,c)=tempDeltafc;
        else
            d=d+1;
            TremHet_Delta_Bilat_male(:,:,:,d)=tempDeltafc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        if strcmp(sex,'Female')
            e=e+1;
            TremKO_Delta_Bilat_female(:,:,:,e)=tempDeltafc;
        else
            f=f+1;
            TremKO_Delta_Bilat_male(:,:,:,f)=tempDeltafc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        if strcmp(sex,'Female')
            g=g+1;
            TremWT5XFAD_Delta_Bilat_female(:,:,:,g)=tempDeltafc;
        else
            h=h+1;
            TremWT5XFAD_Delta_Bilat_male(:,:,:,h)=tempDeltafc;
        end
        
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        if strcmp(sex,'Female')
            i=i+1;
            TremHet5XFAD_Delta_Bilat_female(:,:,:,i)=tempDeltafc;
        else
            k=k+1;
            TremHet5XFAD_Delta_Bilat_male(:,:,:,k)=tempDeltafc;
        end
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        if strcmp(sex,'Female')
            l=l+1;
            TremKO5XFAD_Delta_Bilat_female(:,:,:,l)=tempDeltafc;
        else
            m=m+1;
            TremKO5XFAD_Delta_Bilat_male(:,:,:,m)=tempDeltafc;
        end
        
        
    end
    clear bilatFCMapCat
    clear tempISAR tempISAfc tempDeltaR tempDeltafc
    
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




% imagesc(MeanTremWT_Delta_Bilat(:,:,1),[-2 2])
% axis image off
% colorbar
% title('Oxy')
%
% imagesc(MeanTremWT_Delta_Bilat(:,:,4),[-2 2])
% axis image off
% colorbar
% title('Calcium')
%
% imagesc(MeanTremHet_Delta_Bilat(:,:,1),[-2 2])
% title('Oxy')
% colorbar
% axis image off
%
% imagesc(MeanTremHet_Delta_Bilat(:,:,4),[-2 2])
% axis image off
% colorbar
% title('Calcium')
%
% imagesc(MeanTremKO_Delta_Bilat(:,:,1),[-2 2])
% axis image off
% colorbar
% title('Oxy')
%
% imagesc(MeanTremKO_Delta_Bilat(:,:,4),[-2 2])
% title('Calcium')
% colorbar
% axis image off
%
% imagesc(MeanTremWT5XFAD_Delta_Bilat(:,:,1),[-2 2])
% axis image off
% colorbar
% title('Oxy')
%
% imagesc(MeanTremWT5XFAD_Delta_Bilat(:,:,4),[-2 2])
% axis image off
% colorbar
% title('Calcium')
%
% imagesc(MeanTremHet5XFAD_Delta_Bilat(:,:,1),[-2 2])
% axis image off
% colorbar
% title('Oxy')
%
% imagesc(MeanTremHet5XFAD_Delta_Bilat(:,:,4),[-2 2])
% axis image off
% colorbar
% title('Calcium')
%
% imagesc(MeanTremKO5XFAD_Delta_Bilat(:,:,1),[-2 2])
% axis image off
% colorbar
% title('Oxy')
%
% imagesc(MeanTremKO5XFAD_Delta_Bilat(:,:,4),[-2 2])
% axis image off
% colorbar
% title('Calcium')

