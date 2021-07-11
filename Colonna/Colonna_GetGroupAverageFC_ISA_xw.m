clear all;close all;clc
database='V:\CTREM\CTREM.xlsx';
excelfiles=[2:11,17:22,27:63];  % Rows from Excell Database???34,63

% for ii = excelfiles
%     exampleSeedFCAnalysis(database,ii,[0.009 0.08])
% end



% WTFile = 'V:\CTREM\WT.xlsx';
% 
%     exampleSeedFCAnalysis(WTFile,2:15,[0.009 0.08])
% 
% WTFADFile = 'V:\CTREM\WTFAD.xlsx';
%     exampleSeedFCAnalysis(WTFADFile,2:14,[0.009 0.08])
% 
% HETFile = 'V:\CTREM\HET.xlsx';
%     exampleSeedFCAnalysis(HETFile,2:7,[0.009 0.08])
% 
% 
% HETFADFile = 'V:\CTREM\HETFAD.xlsx';
%     exampleSeedFCAnalysis(HETFADFile,2:7,[0.009 0.08])
% 
% 
% KOFile = 'V:\CTREM\KO.xlsx';
%     exampleSeedFCAnalysis(KOFile,2:8,[0.009 0.08])
% 
% 
% KOFADFile = 'V:\CTREM\KOFAD.xlsx';
%     exampleSeedFCAnalysis(KOFADFile,2:8,[0.009 0.08])


a=0;
b=0;
c=0;
d=0;
e=0;
f=0;

isbrainall=ones(128);

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{9};
    Group=raw{8};
    directory=['V:\CTREM\Mouse level averages\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=['CTREM-seedFC-rows',num2str(n),'~',num2str(n),'-0p009-0p08.mat'];
   
    load(file);
    tempISAfc=zeros(128,128,16,4);
    tempISAR = atanh(seedFCCat);
    
    for ii = 1:4
    tempISAfc(:,:,:,ii) = atanh(cell2mat(seedFCMapCat(1,ii)));
    end
    
    isbrain=zeros(128);
    isbrain(~(squeeze(tempISAfc(:,:,5,1))))=1;
    isbrainall=isbrainall.*single(isbrain);
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        TremWT_ISA_R(:,:,:,a)=tempISAR;
        TremWT_ISA_fcmap(:,:,:,:,a)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        b=b+1;
        TremHet_ISA_R(:,:,:,b)=tempISAR;
        TremHet_ISA_fcmap(:,:,:,:,b)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        c=c+1;
        TremKO_ISA_R(:,:,:,c)=tempISAR;
        TremKO_ISA_fcmap(:,:,:,:,c)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        TremWT5XFAD_ISA_R(:,:,:,d)=tempISAR;
        TremWT5XFAD_ISA_fcmap(:,:,:,:,d)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        e=e+1;
        TremHet5XFAD_ISA_R(:,:,:,e)=tempISAR;
        TremHet5XFAD_ISA_fcmap(:,:,:,:,e)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        TremKO5XFAD_ISA_R(:,:,:,f)=tempISAR;
        TremKO5XFAD_ISA_fcmap(:,:,:,:,f)=tempISAfc;
        
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

symisbrainall=zeros(128);
symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);

clear location name tempfc tempR tempfcMap junk n trash Time ...
    xform_isbrain file dir date saveloc raw database directory excelfiles



