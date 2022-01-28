database='D:\Bice\Imaging Datasheets\Marco_Colonna.xlsx';
excelfiles=[16:43];  % Rows from Excell Database


type='Whole';
a=0;
b=0;
c=0;
d=0;

isbrainall=ones(128);

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    Group=raw{8};
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])

    cd(directory)
    
    file=[Date,'-',Mouse,'-fc-cat.mat'];    
    if exist([directory, Date,'-', Mouse,'-fc-cat.mat'])
        
       %load(file,['NDimIpsi_', Mouse], 'xform_isbrain');
       %load(file,['NDimContra_', Mouse], 'xform_isbrain');
       load(file,['NodeDeg_', Mouse], 'xform_isbrain');
        isbrainall=isbrainall.*single(xform_isbrain);
        
          
       %tempR=eval(['NDimIpsi_',Mouse]);
       %tempR=eval(['NDimContra_',Mouse]);
       tempR=eval(['NodeDeg_',Mouse]); 
        
        
    if strcmp(Group,'WT')
        a=a+1;
        WT_ND(:,:,:,a)=tempR;
    elseif strcmp(Group,'TREM')
        b=b+1;
        tremneg_ND(:,:,:,b)=tempR;
    elseif strcmp(Group,'TREMXFAD')
        c=c+1;
        TREMXFAD_ND(:,:,:,c)=tempR;
    elseif strcmp(Group,'XFAD')
        d=d+1;
        XFAD_ND(:,:,:,d)=tempR;
    end
    
        %clear(['NDimIpsi_',Mouse])
        %clear(['NDimContra_',Mouse])
        clear(['NodeDeg_',Mouse])
        clear tempfc Group Date Mouse
    end
end;

symisbrainall=zeros(128);
symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);

MeanWT_ND=mean(WT_ND,4);
Meantremneg_ND=mean(tremneg_ND,4);
MeanTREMXFAD_ND=mean(TREMXFAD_ND,4);
MeanXFAD_ND=mean(XFAD_ND,4);

clear database excelfiles directory raw saveloc location name tempfc tempR tempfcMap junk n trash...
    xform_isbrain isbrainall file dir date a b c Treatment


pvals_tremnegvsWT=zeros(128,128,2);
hvals_tremnegvsWT=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(tremneg_ND(y,x,d,:), WT_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_tremnegvsWT(y,x,d)=p*h;
            hvals_tremnegvsWT(y,x,d)=h;
        end
    end
end
hvals_tremnegvsWT(isnan(hvals_tremnegvsWT))=0;
idx=hvals_tremnegvsWT==1;



pvals_WTvsTREMXFAD=zeros(128,128,2);
hvals_WTvsTREMXFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(WT_ND(y,x,d,:), TREMXFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_WTvsTREMXFAD(y,x,d)=p*h;
            hvals_WTvsTREMXFAD(y,x,d)=h;
        end
    end
end
hvals_WTvsTREMXFAD(isnan(hvals_WTvsTREMXFAD))=0;
idx=hvals_WTvsTREMXFAD==1;



pvals_tremnegvsTREMXFAD=zeros(128,128,2);
hvals_tremnegvsTREMXFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(tremneg_ND(y,x,d,:), TREMXFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_tremnegvsTREMXFAD(y,x,d)=p*h;
            hvals_tremnegvsTREMXFAD(y,x,d)=h;
        end
    end
end
hvals_tremnegvsTREMXFAD(isnan(hvals_tremnegvsTREMXFAD))=0;
idx=hvals_tremnegvsTREMXFAD==1;


pvals_XFADvsWT=zeros(128,128,2);
hvals_XFADvsWT=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(XFAD_ND(y,x,d,:), WT_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_XFADvsWT(y,x,d)=p*h;
            hvals_XFADvsWT(y,x,d)=h;
        end
    end
end
hvals_XFADvsWT(isnan(hvals_XFADvsWT))=0;
idx=hvals_XFADvsWT==1;

pvals_tremnegvsXFAD=zeros(128,128,2);
hvals_tremnegvsXFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(tremneg_ND(y,x,d,:), XFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_tremnegvsXFAD(y,x,d)=p*h;
            hvals_tremnegvsXFAD(y,x,d)=h;
        end
    end
end
hvals_tremnegvsXFAD(isnan(hvals_tremnegvsXFAD))=0;
idx=hvals_tremnegvsXFAD==1;

pvals_tremnegXFADvsXFAD=zeros(128,128,2);
hvals_tremnegXFADvsXFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(XFAD_ND(y,x,d,:), TREMXFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_tremnegXFADvsXFAD(y,x,d)=p*h;
            hvals_tremnegXFADvsXFAD(y,x,d)=h;
        end
    end
end
hvals_tremnegXFADvsXFAD(isnan(hvals_tremnegXFADvsXFAD))=0;
idx=hvals_tremnegXFADvsXFAD==1;




%load('G:\OISProjects\CulverLab\Optogenetics\MeanOptoStimandRSMapsReOrder_150219.mat', 'xform_WL')
%load('D:\ProcessedData\deborah updated\Deborah_MeanfcMaps_180124.mat','xform_WL')
% load('D:\ProcessedData\Marco_Colonna\Group Average Functional Connectivity Maps and Matrices_181109.mat','xform_WL')
%load('C:\Users\Fats Waller\Desktop\Colonna Updated\190109 Updated Excel files 16 to 38\190109-Group Average Functional Connectivity Maps and Matrices.mat', 'xform_WL')
load('D:\ProcessedData\Colonna Data Processed 190416\GroupAverageMatrices.mat', 'xform_WL')

thresh=2000;
% thresh=900;
thresh2=900;
% thresh2=700;

% figure('Units','inches','Position',[7 3 10 8]);
f1 = figure('Position',[1 1 1920 1080]);

%top row
subplot(3,6,2);
Im2=overlaymouse(MeanWT_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('WT Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

subplot(3,6,3);
Im2=overlaymouse(Meantremneg_ND(:,:,2),xform_WL, Meantremneg_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('Trem2 KO Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

subplot(3,6,4);
Im2=overlaymouse(MeanXFAD_ND(:,:,2),xform_WL, MeanXFAD_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('5xFAD Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

subplot(3,6,5);
Im2=overlaymouse(MeanTREMXFAD_ND(:,:,2),xform_WL, MeanTREMXFAD_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('TREM2 KO 5xFAD Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

%middle row

subplot(3,6,7);
Im2=overlaymouse(MeanWT_ND(:,:,2)-MeanTREMXFAD_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2)-MeanTREMXFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('WT minus Trem2 KO 5xFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,8);
Im2=overlaymouse(MeanWT_ND(:,:,2)-Meantremneg_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2)-Meantremneg_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('WT minus Trem2 KO')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,9);
Im2=overlaymouse(MeanWT_ND(:,:,2)-MeanXFAD_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2)-MeanXFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('WT minus 5xFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,10);
Im2=overlaymouse(Meantremneg_ND(:,:,2)-MeanXFAD_ND(:,:,2),xform_WL, Meantremneg_ND(:,:,2)-MeanXFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('Trem2 KO minus 5xFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,11);
Im2=overlaymouse(MeanTREMXFAD_ND(:,:,2)-MeanXFAD_ND(:,:,2),xform_WL, MeanTREMXFAD_ND(:,:,2)-MeanXFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('Trem2 KO 5xFAD minus 5xFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,12);
Im2=overlaymouse(Meantremneg_ND(:,:,2)-MeanTREMXFAD_ND(:,:,2),xform_WL, Meantremneg_ND(:,:,2)-MeanTREMXFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('Trem2 KO minus TREM2 KO 5xFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

%final row


subplot(3,6,13);
Im2=overlaymouse(-log10(pvals_WTvsTREMXFAD(:,:,2)),xform_WL, hvals_WTvsTREMXFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals WT minus Trem2 KO 5xFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,14);
Im2=overlaymouse(-log10(pvals_tremnegvsWT(:,:,2)),xform_WL, hvals_tremnegvsWT(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals WT minus Trem2 KO','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,15);
Im2=overlaymouse(-log10(pvals_XFADvsWT(:,:,2)),xform_WL, hvals_XFADvsWT(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals WT minus XFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,16);
Im2=overlaymouse(-log10(pvals_tremnegvsXFAD(:,:,2)),xform_WL, hvals_tremnegvsXFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals Trem2 KO minus 5xFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,17);
Im2=overlaymouse(-log10(pvals_tremnegXFADvsXFAD(:,:,2)),xform_WL, hvals_tremnegXFADvsXFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals Trem2 KO 5xFAD minus 5xFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,18);
Im2=overlaymouse(-log10(pvals_tremnegvsTREMXFAD(:,:,2)),xform_WL, hvals_tremnegvsTREMXFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals Trem2 KO minus Trem2 KO 5xFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')





annotation('textbox',[0.05 0.95 0.925 0.05],'HorizontalAlignment','center',...
    'LineStyle','none','String',['Global Node Degree'],...
    'FontWeight','bold','Color',[0 0 1]);
% 
% savefig(f1,'globalNodeDegree.fig');
% saveas(f1,'globalNodeDegree.jpg','jpeg');