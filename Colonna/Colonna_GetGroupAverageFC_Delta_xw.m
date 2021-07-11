clear all;close all;clc
database='V:\CTREM\CTREM.xlsx';
excelfiles=[2:11,17:22,27:63];  % Rows from Excell Database???34,63
% for ii = [34,63]
%     exampleSeedFCAnalysis(database,ii,[0.4 4]);
% end
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
    file=['CTREM-seedFC-rows',num2str(n),'~',num2str(n),'-0p4-4.mat'];
   
    load(file);
    tempDeltafc=zeros(128,128,16,4);
    tempDeltaR = atanh(seedFCCat);
    
    for ii = 1:4
    tempDeltafc(:,:,:,ii) = atanh(cell2mat(seedFCMapCat(1,ii)));
    end
    
    isbrain=zeros(128);
    isbrain(~(squeeze(tempDeltafc(:,:,5,1))))=1;
    isbrainall=isbrainall.*single(isbrain);
    
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        TremWT_Delta_R(:,:,:,a)=tempDeltaR;
        TremWT_Delta_fcmap(:,:,:,:,a)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        b=b+1;
        TremHet_Delta_R(:,:,:,b)=tempDeltaR;
        TremHet_Delta_fcmap(:,:,:,:,b)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        c=c+1;
        TremKO_Delta_R(:,:,:,c)=tempDeltaR;
        TremKO_Delta_fcmap(:,:,:,:,c)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        TremWT5XFAD_Delta_R(:,:,:,d)=tempDeltaR;
        TremWT5XFAD_Delta_fcmap(:,:,:,:,d)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        e=e+1;
        TremHet5XFAD_Delta_R(:,:,:,e)=tempDeltaR;
        TremHet5XFAD_Delta_fcmap(:,:,:,:,e)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        TremKO5XFAD_Delta_R(:,:,:,f)=tempDeltaR;
        TremKO5XFAD_Delta_fcmap(:,:,:,:,f)=tempDeltafc;
        
    end
    clear seedFCCat seedFCMapCat
    clear tempDeltaR tempDeltafc
    
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


