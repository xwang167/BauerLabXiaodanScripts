excelFile='V:\CTREM\CTREM.xlsx';
excelRows=[2:11,17:22,27:63];  % Rows from Excell Database

a=0;
b=0;
c=0;
d=0;
e=0;
f=0;

for n=excelRows;
    
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(n),':K',num2str(n)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{9}; mouseName = string(mouseName);%2
    saveDir = excelRaw{12}; saveDir = fullfile(string(saveDir),recDate);%4
    disp(['Loading ', mouseName, ' n= ' , num2str(n)])
    processedName_dataHb_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataHb','.mat');
    processedName_dataFluor_mouse = strcat(recDate,'-',mouseName,'-',sessionType,'-dataFluor','.mat');
    
    load(fullfile(saveDir,processedName_datahb_mouse),'R_AllPix_hb_mouse');
    load(fullfile(saveDir,processedName_dataFluor_mouse),'R_AllPix_fluor_mouse')
    
    tempPixPixfc_hb = atanh(R_AllPix_hb_mouse);       
    if strcmp(Group,'GP5.5(+)Trem2(WT)')
        a=a+1;
        TremWT_PixPixfc_hb(:,:,a)=tempPixPixfc_hb;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)')
        b=b+1;
        TremHet_PixPixfc_hb(:,:,b)=tempPixPixfc_hb;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
        c=c+1;
        TremKO_PixPixfc_hb(:,:,c)=tempPixPixfc_hb;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
        d=d+1;
        TremWT5XFAD_PixPixfc_hb(:,:,d)=tempPixPixfc_hb;
   
        
    elseif strcmp(Group,'GP5.5(+)Trem2(het)5xFAD')
        e=e+1;
        TremHet5XFAD_PixPixfc_hb(:,:,e)=tempPixPixfc_hb;
        
    elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
        f=f+1;
        TremKO5XFAD_PixPixfc_hb(:,:,f)=tempPixPixfc_hb;
        
    end
    clear tempPixPixfc_hb
    
end


Names=whos;
for n=1:size(Names,1)
    if numel(Names(n).size)==3
        newname=genvarname(['Mean', Names(n).name]);
        temp=mean(eval(Names(n).name),3);
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

