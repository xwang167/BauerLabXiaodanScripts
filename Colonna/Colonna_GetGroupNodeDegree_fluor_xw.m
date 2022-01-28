import mouse.*
database ='Y:\CTREM\CTREM_new.xlsx';
excelfiles =[2:11,17:22,27:66];

a=0;
b=0;
c=0;
d=0;

isbrainall=ones(128);

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':N',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{9};
    saveloc=raw{12};
    directory=[saveloc, '\', Date, '\'];
    Group=raw{8}
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    
    cd(directory)
    
    file=[Date,'-',Mouse,'-fc-dataFluor.mat'];         
        %load(file,['NDimIpsi_', Mouse], 'xform_isbrain');
        %load(file,['NDimContra_', Mouse], 'xform_isbrain');
        load(file,'NDimAll_fluor_mouse') 
        load([Date,'-',Mouse,'-LandmarksAndMask.mat'],'xform_isbrain');
        isbrainall=isbrainall.*single(xform_isbrain);
        
        
        %tempR=eval(['NDimIpsi_',Mouse]);
        %tempR=eval(['NDimContra_',Mouse]);
        tempR= NDimAll_fluor_mouse;
                
        if strcmp(Group,'GP5.5(+)Trem2(WT)')
            a=a+1;
            WT_ND(:,:,:,a)=tempR;
        elseif strcmp(Group,'GP5.5(+)Trem2(KO)')
            b=b+1;
            KO_ND(:,:,:,b)=tempR;
        elseif strcmp(Group,'GP5.5(+)Trem2(WT)5xFAD')
            c=c+1;
            WTFAD_ND(:,:,:,c)=tempR;
        elseif strcmp(Group,'GP5.5(+)Trem2(KO)5xFAD')
            d=d+1;
            KOFAD_ND(:,:,:,d)=tempR;
        end
        
        %clear(['NDimIpsi_',Mouse])
        %clear(['NDimContra_',Mouse])
     
        clear NDimAll_fluor_mouse tempfc Group Date Mouse
    
end

symisbrainall=zeros(128);
symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);

MeanWT_ND=mean(WT_ND,4);
MeanKO_ND=mean(KO_ND,4);
MeanWTFAD_ND=mean(WTFAD_ND,4);
MeanKOFAD_ND=mean(KOFAD_ND,4);

clear database excelfiles directory raw saveloc location name tempfc tempR tempfcMap junk n trash...
    xform_isbrain isbrainall file dir date a b c Treatment


pvals_KOvsWT=zeros(128,128,2);
hvals_KOvsWT=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(KO_ND(y,x,d,:), WT_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_KOvsWT(y,x,d)=p*h;
            hvals_KOvsWT(y,x,d)=h;
        end
    end
end
hvals_KOvsWT(isnan(hvals_KOvsWT))=0;
idx=hvals_KOvsWT==1;



pvals_WTvsKOFAD=zeros(128,128,2);
hvals_WTvsKOFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(WT_ND(y,x,d,:), KOFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_WTvsKOFAD(y,x,d)=p*h;
            hvals_WTvsKOFAD(y,x,d)=h;
        end
    end
end
hvals_WTvsKOFAD(isnan(hvals_WTvsKOFAD))=0;
idx=hvals_WTvsKOFAD==1;



pvals_KOvsKOFAD=zeros(128,128,2);
hvals_KOvsKOFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(KO_ND(y,x,d,:), KOFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_KOvsKOFAD(y,x,d)=p*h;
            hvals_KOvsKOFAD(y,x,d)=h;
        end
    end
end
hvals_KOvsKOFAD(isnan(hvals_KOvsKOFAD))=0;
idx=hvals_KOvsKOFAD==1;


pvals_WTFADvsWT=zeros(128,128,2);
hvals_WTFADvsWT=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(WTFAD_ND(y,x,d,:), WT_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_WTFADvsWT(y,x,d)=p*h;
            hvals_WTFADvsWT(y,x,d)=h;
        end
    end
end
hvals_WTFADvsWT(isnan(hvals_WTFADvsWT))=0;
idx=hvals_WTFADvsWT==1;

pvals_KOvsWTFAD=zeros(128,128,2);
hvals_KOvsWTFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(KO_ND(y,x,d,:), WTFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_KOvsWTFAD(y,x,d)=p*h;
            hvals_KOvsWTFAD(y,x,d)=h;
        end
    end
end
hvals_KOvsWTFAD(isnan(hvals_KOvsWTFAD))=0;
idx=hvals_KOvsWTFAD==1;

pvals_KOFADvsWTFAD=zeros(128,128,2);
hvals_KOWTFADvsWTFAD=zeros(128,128,2);

for d=1:2;
    for y=1:128;
        for x=1:128
            [h, p]=ttest2(WTFAD_ND(y,x,d,:), KOFAD_ND(y,x,d,:), 0.05, 'both', 'unequal');
            pvals_KOFADvsWTFAD(y,x,d)=p*h;
            hvals_KOFADvsWTFAD(y,x,d)=h;
        end
    end
end
hvals_KOFADvsWTFAD(isnan(hvals_KOFADvsWTFAD))=0;
idx=hvals_KOFADvsWTFAD==1;




%load('G:\OISProjects\CulverLab\Optogenetics\MeanOptoStimandRSMapsReOrder_150219.mat', 'xform_WL')
%load('D:\ProcessedData\deborah updated\Deborah_MeanfcMaps_180124.mat','xform_WL')
% load('D:\ProcessedData\Marco_Colonna\Group Average Functional Connectivity Maps and Matrices_181109.mat','xform_WL')
%load('C:\Users\Fats Waller\Desktop\Colonna Updated\190109 Updated Excel files 16 to 38\190109-Group Average Functional Connectivity Maps and Matrices.mat', 'xform_WL')
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')

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
Im2=overlaymouse(MeanKO_ND(:,:,2),xform_WL, MeanKO_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('Trem2 KO Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

subplot(3,6,4);
Im2=overlaymouse(MeanWTFAD_ND(:,:,2),xform_WL, MeanWTFAD_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('5xFAD Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

subplot(3,6,5);
Im2=overlaymouse(MeanKOFAD_ND(:,:,2),xform_WL, MeanKOFAD_ND(:,:,2),'jet',0, thresh);
imagesc(Im2,[0 thresh]);
axis image off;
title('TREM2 KO 5WTFAD Node Degree')
cb=colorbar;
set(cb,'YTick',[0 thresh])
ylabel(cb, 'Number of Connections')

%middle row

subplot(3,6,7);
Im2=overlaymouse(MeanWT_ND(:,:,2)-MeanKOFAD_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2)-MeanKOFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('WT minus Trem2 KO 5WTFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,8);
Im2=overlaymouse(MeanWT_ND(:,:,2)-MeanKO_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2)-MeanKO_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('WT minus Trem2 KO')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,9);
Im2=overlaymouse(MeanWT_ND(:,:,2)-MeanWTFAD_ND(:,:,2),xform_WL, MeanWT_ND(:,:,2)-MeanWTFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('WT minus 5WTFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,10);
Im2=overlaymouse(MeanKO_ND(:,:,2)-MeanWTFAD_ND(:,:,2),xform_WL, MeanKO_ND(:,:,2)-MeanWTFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('Trem2 KO minus 5WTFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,11);
Im2=overlaymouse(MeanKOFAD_ND(:,:,2)-MeanWTFAD_ND(:,:,2),xform_WL, MeanKOFAD_ND(:,:,2)-MeanWTFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('Trem2 KO 5WTFAD minus 5WTFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

subplot(3,6,12);
Im2=overlaymouse(MeanKO_ND(:,:,2)-MeanKOFAD_ND(:,:,2),xform_WL, MeanKO_ND(:,:,2)-MeanKOFAD_ND(:,:,2),'jet',-thresh2, thresh2);
imagesc(Im2,[-thresh2 thresh2]);
axis image off;
title('Trem2 KO minus TREM2 KO 5WTFAD')
cb=colorbar;
set(cb,'YTick',[-thresh2 0 thresh2])
ylabel(cb, 'Number of Connections')

%final row


subplot(3,6,13);
Im2=overlaymouse(-log10(pvals_WTvsKOFAD(:,:,2)),xform_WL, hvals_WTvsKOFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals WT minus Trem2 KO 5WTFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,14);
Im2=overlaymouse(-log10(pvals_KOvsWT(:,:,2)),xform_WL, hvals_KOvsWT(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals WT minus Trem2 KO','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,15);
Im2=overlaymouse(-log10(pvals_WTFADvsWT(:,:,2)),xform_WL, hvals_WTFADvsWT(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals WT minus WTFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,16);
Im2=overlaymouse(-log10(pvals_KOvsWTFAD(:,:,2)),xform_WL, hvals_KOvsWTFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals Trem2 KO minus 5WTFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,17);
Im2=overlaymouse(-log10(pvals_KOFADvsWTFAD(:,:,2)),xform_WL, hvals_KOFADvsWTFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals Trem2 KO 5WTFAD minus 5WTFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')

subplot(3,6,18);
Im2=overlaymouse(-log10(pvals_KOvsKOFAD(:,:,2)),xform_WL, hvals_KOvsKOFAD(:,:,2),'jet',1.3, 3);
imagesc(Im2,[1.3 3]);
axis image off;
title('pvals Trem2 KO minus Trem2 KO 5WTFAD','FontSize', 10)
cb=colorbar;
set(cb,'YTick',[1.3 3])
ylabel(cb, 'Pvals')





annotation('textbox',[0.05 0.95 0.925 0.05],'HorizontalAlignment','center',...
    'LineStyle','none','String',['Global Node Degree for Calcium'],...
    'FontWeight','bold','Color',[0 0 1]);
%
% savefig(f1,'globalNodeDegree.fig');
% saveas(f1,'globalNodeDegree.jpg','jpeg');