excelFileName='V:\CTREM\CTREM.xlsx';
excelfiles=[2:11,17:22,27:63];  % Rows from Excell Database
% % for ii = [2:11,17:22,27:63]
% %     exampleBilateralFCAnalysis(excelFileName,ii,[0.009 0.08])
% %     exampleBilateralFCAnalysis(excelFileName,ii,[0.4 4])
% % end
% 
% 
% 
% WTFile = 'V:\CTREM\WT.xlsx';
%     exampleBilateralFCAnalysis(WTFile,2:15,[0.009 0.08])
% exampleBilateralFCAnalysis(WTFile,2:15,[0.4 4])
% 
% WTFADFile = 'V:\CTREM\WTFAD.xlsx';
%     exampleBilateralFCAnalysis(WTFADFile,2:14,[0.009 0.08])
% exampleBilateralFCAnalysis(WTFADFile,2:14,[0.4 4])
% 
% HETFile = 'V:\CTREM\HET.xlsx';
%     exampleBilateralFCAnalysis(HETFile,2:7,[0.009 0.08])
% exampleBilateralFCAnalysis(HETFile,2:7,[0.4 4])
% 
% HETFADFile = 'V:\CTREM\HETFAD.xlsx';
%     exampleBilateralFCAnalysis(HETFADFile,2:7,[0.009 0.08])
% exampleBilateralFCAnalysis(HETFADFile,2:7,[0.4 4])
% 
% KOFile = 'V:\CTREM\KO.xlsx';
%     exampleBilateralFCAnalysis(KOFile,2:8,[0.009 0.08])
%  exampleBilateralFCAnalysis(KOFile,2:8,[0.4 4])
% 
% KOFADFile = 'V:\CTREM\KOFAD.xlsx';
%     exampleBilateralFCAnalysis(KOFADFile,2:8,[0.009 0.08])
% exampleBilateralFCAnalysis(KOFADFile,2:8,[0.4 4])





a=0;
b=0;
c=0;
d=0;
e=0;
f=0;

for n=excelfiles;
    
    [~, ~, raw]=xlsread(excelFileName,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    Group=raw{8};
    directory=['V:\CTREM\Mouse level averages\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=['CTREM-bilateralFC-rows',num2str(n),'~',num2str(n),'-0p009-0p08.mat'];
    
    load(file);
    
   for ii = 1:4
    tempISAfc(:,:,ii) = atanh(cell2mat(bilatFCMapCat(1,ii)));
    end

        
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        TremWT_ISA_Bilat(:,:,:,a)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        b=b+1;
        TremHet_ISA_Bilat(:,:,:,b)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        c=c+1;
        TremKO_ISA_Bilat(:,:,:,c)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        TremWT5XFAD_ISA_Bilat(:,:,:,d)=tempISAfc;
   
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        e=e+1;
        TremHet5XFAD_ISA_Bilat(:,:,:,e)=tempISAfc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        TremKO5XFAD_ISA_Bilat(:,:,:,f)=tempISAfc;
        
    end
    clear tempISAR tempISAfc tempDeltaR tempDeltafc
    
end


a=0;
b=0;
c=0;
d=0;
e=0;
f=0;

for n=excelfiles;
    
    [~, ~, raw]=xlsread(excelFileName,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    Group=raw{8};
    directory=['V:\CTREM\Mouse level averages\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=['CTREM-bilateralFC-rows',num2str(n),'~',num2str(n),'-0p4-4.mat'];
    
    load(file);
    
    for ii = 1:4
    tempDeltafc(:,:,ii) = atanh(cell2mat(bilatFCMapCat(1,ii)));
    end
        
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        TremWT_Delta_Bilat(:,:,:,a)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        b=b+1;
        TremHet_Delta_Bilat(:,:,:,b)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        c=c+1;
        TremKO_Delta_Bilat(:,:,:,c)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        TremWT5XFAD_Delta_Bilat(:,:,:,d)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        e=e+1;
        TremHet5XFAD_Delta_Bilat(:,:,:,e)=tempDeltafc;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        TremKO5XFAD_Delta_Bilat(:,:,:,f)=tempDeltafc;
        
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

