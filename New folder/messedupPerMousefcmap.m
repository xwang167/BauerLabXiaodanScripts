database='Z:\Rachel\MattMasterListtemp.xlsx';
saveloc='Z:\Rachel\Rachel_fcOIS\Development\';
rawdataloc='Z:\Rachel\Rachel_fcOIS\Development\'; % Location of raw data
regtype={'Whole'};

excelfiles=[41];  % Rows from Excel Database

for n=excelfiles
    
[~, ~, raw]=xlsread(database,1, ['A',num2str(n),':B',num2str(n)]);
    
    Date=num2str(raw{1});
    Mouse=raw{2};
    %str2num(char(raw{3}));
directory=[saveloc, Date, '\'];

%clear oxyCat deoxyCat gcampCat

for i=1
load([directory, Date,'-',Mouse,'-fc-cat'],'oxyCat','deoxyCat','gcampCat','WL','refseeds', 'isbrain');
        
catmode='onerun'; 
seeds=refseeds;
% WL=abs(cell2mat(struct2cell(load([run label],'WL2'))));
% isbrain=cell2mat(struct2cell(load([run label],'isbrain')));
% %seeds=cell2mat(struct2cell(load(['K:\DATA\141021\Ms3\Data\Seeds-141021-Ms3-Aff'], 'seedcenter')));
% %seeds=cell2mat(struct2cell(load(['/data/culver/data1/Lindsey/data/Anesthesia/Seeds_Lindsey_good'],'seedcenter')));
% seeds=cell2mat(struct2cell(load(['Z:\Rachel\Rachel_fcOIS\Development\' date '\' date '-' mousenum '_seeds.mat'],'seedcenter')));
% %seeds=(load([seeds],'seedcenter'));
% %assignin('base','seedstest',seeds)
 
switch catmode
 
    case 'onerun'
 oxy=mean(oxyCat,4);
deoxy=mean(deoxyCat,4);
gcamp6c=mean(gcampCat,4);       
% %rawdata=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',date,'\',mouse,'\Data\RawData-',label],'raw_fit')));
%         isbrain=cell2mat(struct2cell(isbrain));
%         
%         oxy=cell2mat(struct2cell(oxy));
%         deoxy=cell2mat(struct2cell(deoxy));
%         gcamp6all=cell2mat(struct2cell(gcamp3c));
     


%    case 'multirun'
        %rawdata=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',date,'\',mouse,'\Data\RawData-',label],'ois2')));
%        oxy=cell2mat(struct2cell(load(['K:\DATA\',date,'\',msd,'\Data\Data-',label2],'oxy2')));
%        deoxy=cell2mat(struct2cell(load(['K:\DATA\',date,'\',msd,'\Data\Data-',label2],'deoxy2')));
%        gcamp6all=cell2mat(struct2cell(load(['K:\DATA\',date,'\',msd,'\Data\Data-',label2],'gcamp6_2')));
%        seeds=cell2mat(struct2cell(load(['K:\DATA\',date,'\',msd,'\Data\Seeds-',date,'-',msd], 'seedcenter')));
        %[seeds]=MakeSeedsMouseSpace_Affine(date,mouse,label2);
%        label=label2;
        
end
 
 
oxy=real(reshape(oxy,128,128,[]));
deoxy=real(reshape(deoxy,128,128,[]));
gcamp3c=real(reshape(gcamp6c,128,128,[]));
% %gcamp6all=real(reshape(gcamp6all,128,128,2,[]));
%  
% % temp=squeeze(gcamp6all(:,:,1,:));
% % 
% % gcamp3c=temp(:,:,frames_start(epoch):frames_end(epoch+2));
%  
% %gcamp3c=temp(:,:,1:1008);
%  
% gcamp3c=squeeze(gcamp6all(:,:,1,:));
% gcamp3u=squeeze(gcamp6all(:,:,2,:));
 
seednames={'Olf','Fr','Cg','M','SS','RS','V','Au'};
sides={'R','L'};
 
mm=10;
mpp=mm/128;
seedradmm=0.25;
seedradpix=seedradmm/mpp;
 
numseeds=numel(seednames);
numsides=numel(sides);
 
%P=(burnseeds(seeds,seedradpix,isbrain));
P=fliplr(burnseeds(seeds,seedradpix,isbrain));
% assignin('base','P',P); 
straceOxy=P2strace(P,oxy); %% strace is each seeds trace resultinmg from averaging the pixels within a seed region
straceDeOxy=P2strace(P,deoxy);
%straceGCAMP3u=P2strace(P,gcamp3u);
straceGCAMP3c=P2strace(P,gcamp3c);
assignin('base','P', P)
assignin('base','straceOxy', straceOxy)
 
 
R_Oxy=strace2R(straceOxy,oxy,128,128); %% normalize  rows in time, dot product of those rows with strce
R_DeOxy=strace2R(straceDeOxy,deoxy,128,128);
%R_GCAMP3u=strace2R(straceGCAMP3u,gcamp3u,128,128);
R_GCAMP3c=strace2R(straceGCAMP3c,gcamp3c,128,128);
 
 
R_Data=cat(4, R_Oxy, R_DeOxy, R_GCAMP3c, R_GCAMP3c);%, R_FAD, R_FADc);
% % assignin('base','R_Data',R_Data)
% % assignin('base','R_GCAMP3c',R_GCAMP3c); return
 
ii=1;
 
for i=1:2:16
    straceOxy2(ii,:)=straceOxy(i,:);
    straceOxy2(ii+8,:)=straceOxy(i+1,:);
    
    straceDeOxy2(ii,:)=straceDeOxy(i,:);
    straceDeOxy2(ii+8,:)=straceDeOxy(i+1,:);
    
%     straceGCAMP3u2(ii,:)=straceGCAMP3u(i,:);
%     straceGCAMP3u2(ii+8,:)=straceGCAMP3u(i+1,:);
% %     
     straceGCAMP3c2(ii,:)=straceGCAMP3c(i,:);
     straceGCAMP3c2(ii+8,:)=straceGCAMP3c(i+1,:);
%     
    ii=ii+1;
end
 
Rs_Oxy=normr(straceOxy2)*normr(straceOxy2)';
Rs_DeOxy=normr(straceDeOxy2)*normr(straceDeOxy2)';
%Rs_GCAMP3u=normr(straceGCAMP3u2)*normr(straceGCAMP3u2)';
Rs_GCAMP3c=normr(straceGCAMP3c2)*normr(straceGCAMP3c2)';
 
label=[Date '-' Mouse];
figure('position',[0 0 1000 1200])
set(gcf, 'PaperUnits','normalized', 'PaperPosition', [0 0 1 1], 'Visible','off');
annotation('textbox',[0 0.95 0.75 0.05],'HorizontalAlignment','left','LineStyle','none','String',[label],'FontSize',12, 'FontWeight', 'bold');
 
annotation('line', 'position', [0 0.54 1 0]);
 
% R_Data=squeeze(mean(cat(5,R_Data{:}),5));
% Rs_Oxy=squeeze(mean(cat(3, Rs_Oxy{:}),3));
% Rs_DeOxy=squeeze(mean(cat(3, Rs_DeOxy{:}),3));
% Rs_GCAMP3u=squeeze(mean(cat(3, Rs_GCAMP3u{:}),3));
% Rs_GCAMP3c=squeeze(mean(cat(3, Rs_GCAMP3c{:}),3));
 
%label=[label2,'ALL--7gsmooth_sd2_4'];
 
subplot('position',[0.08 0.315 0.18 0.18])
imagesc(Rs_Oxy, [-1 1]); axis image; title('HbO_2 Correlation Map');
%imagesc(Rs_OIS, [-1 1]); axis image; title('Rest Correlation Map');
set(gca,'XTick',[1:16]);
set(gca,'YTick',[1:16]);
set(gca,'XTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
annotation('textbox',[0.1165 0.27 0.75 0.05],'LineStyle','none','String','L','FontWeight','bold');
annotation('textbox',[0.2 0.27 0.75 0.05],'LineStyle','none','String','R', 'FontWeight','bold');
annotation('textbox',[0.03 0.4 0.75 0.05],'LineStyle','none','String','L', 'FontWeight', 'bold');
annotation('textbox',[0.03 0.3325 0.75 0.05],'LineStyle','none','String','R', 'FontWeight', 'bold');
set(gca,'YTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
 
subplot('position',[0.3114 0.315 0.18 0.18])
imagesc(Rs_DeOxy, [-1 1]); axis image; title('HbR Correlation Map');
%imagesc(Rs_G, [-1 1]); axis image; title('Stim Correlation Map');
set(gca,'XTick',[1:16]);
set(gca,'YTick',[1:16]);
set(gca,'XTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
% annotation('textbox',[0.455 0.27 0.75 0.05],'LineStyle','none','String','L','FontWeight','bold');
% annotation('textbox',[0.575 0.27 0.75 0.05],'LineStyle','none','String','R', 'FontWeight','bold');
% annotation('textbox',[0.35 0.415 0.75 0.05],'LineStyle','none','String','L', 'FontWeight', 'bold');
% annotation('textbox',[0.35 0.3175 0.75 0.05],'LineStyle','none','String','R', 'FontWeight', 'bold');
set(gca,'YTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
 
% subplot('position', [0.5436 0.315 0.18 0.18]);
% imagesc(Rs_GCAMP3u, [-1 1]); axis image; title('GCAMP6 Uncorr. Correlation Map');
% % %imagesc(Rs_OIS-Rs_G, [-1 1]); axis image; title('Rest-Stim Difference Correlation Map');
% set(gca,'XTick',[1:16]);
% set(gca,'YTick',[1:16]);
% set(gca,'XTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
% % % annotation('textbox',[0.7625 0.27 0.75 0.05],'LineStyle','none','String','L','FontWeight','bold');
% % % annotation('textbox',[0.8825 0.27 0.75 0.05],'LineStyle','none','String','R', 'FontWeight','bold');
% % % annotation('textbox',[0.6575 0.415 0.75 0.05],'LineStyle','none','String','L', 'FontWeight', 'bold');
% % % annotation('textbox',[0.6575 0.3175 0.75 0.05],'LineStyle','none','String','R', 'FontWeight', 'bold');
%  set(gca,'YTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
% % 
subplot('position', [0.775 0.315 0.18 0.18]);
imagesc(Rs_GCAMP3c, [-1 1]); axis image; title('GCAMP6 Corr. Correlation Map');
%imagesc(Rs_OIS-Rs_G, [-1 1]); axis image; title('Rest-Stim Difference Correlation Map');
set(gca,'XTick',[1:16]);
set(gca,'YTick',[1:16]);
set(gca,'XTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
annotation('textbox',[0.7625 0.27 0.75 0.05],'LineStyle','none','String','L','FontWeight','bold');
annotation('textbox',[0.8825 0.27 0.75 0.05],'LineStyle','none','String','R', 'FontWeight','bold');
annotation('textbox',[0.6575 0.415 0.75 0.05],'LineStyle','none','String','L', 'FontWeight', 'bold');
annotation('textbox',[0.6575 0.3175 0.75 0.05],'LineStyle','none','String','R', 'FontWeight', 'bold');
set(gca,'YTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
 
annotation('textbox',[0.03 0.159 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','HbO_2','FontWeight','bold','FontSize',10);
annotation('textbox',[0.03 0.109 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','HbR','FontWeight','bold','FontSize',10);
% annotation('textbox',[0.03 0.0621 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','GCAMP3 Uncorr.','FontWeight','bold','FontSize',10);
% annotation('textbox',[0.03 0.016 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','GCAMP3 Corr.','FontWeight','bold','FontSize',10);
% annotation('textbox',[0.03 0.0591 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','Blue','FontWeight','bold','FontSize',10);
% annotation('textbox',[0.03 0.012 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','FAD','FontWeight','bold','FontSize',10);
%annotation('textbox',[0.03 0.0325 0.05 0.05],'HorizontalAlignment', 'right','LineStyle','none','String','Rst-Stm','FontWeight','bold','FontSize',10);
annotation('textbox',[0.0925 0.21 0.75 0.05],'LineStyle','none','String','Olfactory','FontSize',10);
annotation('textbox',[0.208 0.21 0.75 0.05],'LineStyle','none','String','Frontal','FontSize',10);
annotation('textbox',[0.3125 0.21 0.75 0.05],'LineStyle','none','String','Cingulate','FontSize',10);
annotation('textbox',[0.4335 0.21 0.75 0.05],'LineStyle','none','String','Motor','FontSize',10);
annotation('textbox',[0.510 0.21 0.75 0.05],'LineStyle','none','String','Somatosensory','FontSize',10);
annotation('textbox',[0.6290 0.21 0.75 0.05],'LineStyle','none','String','Retrosplenial','FontSize',10);
annotation('textbox',[0.75915 0.21 0.75 0.05],'LineStyle','none','String','Visual','FontSize',10);
annotation('textbox',[0.866 0.21 0.75 0.05],'LineStyle','none','String','Auditory','FontSize',10);
 
 
 
 
for d=1:4
    for s=1:16
        subplot('position',[.025+(s*0.055) .225-(d*0.05) .05 .05])
        Im2=overlaymouse(R_Data(:,:,s,d),WL, isbrain,'jet',-1,1);
        %Im2=R_Data(:,:,s,d).*isbrain;
        imagesc(Im2, [-1 1]);
        hold on;
        %plot(seeds(s,1),seeds(s,2),'k.','MarkerSize',14);
        axis image off
        if d==1 && rem(s,2)~=0
            title('L')
        elseif d==1
            title('R')
        end
        colormap jet
        hold off
    end
end
 
%mkdir([path 'FC\']);
%q
print('-dpng', '-r600', '-painters', [directory, Date,'-',Mouse,'CAT' '-FC_MapsQC']);
 
save([directory, Date,'-',Mouse,'-fc-catMaps'], 'Rs_Oxy', 'Rs_DeOxy','Rs_GCAMP3c', 'R_Data', 'seeds', 'WL', 'isbrain');
 
clear s d rawdata green redgreen blue WL isbrain straceOxy straceOxy2 straceDeOxy straceDeOxy2 straceGCAMP3c straceGCAMP3c2 oxy deoxy gcamp3c
 
end
end
%end
%end
%end
 
%% getoisdata()
function [data]=getoisdata(fileall)
 
[filepath,filename,filetype]=interppathstr(fileall);
 
if ~isempty(filetype) && ~(strcmp(filetype,'tif') || strcmp(filetype,'sif') )
    error('** procOIS() only supports the loading of .tif and .sif files **')
else
    if exist([filepath,'\',filename,'.tif'])
        data=readtiff([filepath,'\',filename,'.tif']);
    elseif exist([filepath,'\',filename,'.sif'])
        data=readsif([filepath,'\',filename,'.sif']);
    end
end
 
end
 
 
%% readtiff()
function [data]=readtiff(filename)
 
info = imfinfo(filename);
numI = numel(info);
data=zeros(info(1).Width,info(1).Height,numI,'uint16');
fid=fopen(filename);
 
fseek(fid,8,'bof');
for k = 1:numI
    fseek(fid,422,'cof');    
    tempdata=fread(fid,info(1).Width*info(1).Height,'uint16');
    data(:,:,k) = rot90((reshape(tempdata,info(1).Width,info(1).Height)),-1); %% changed 3/2/11
end
 
fclose(fid);
 
end
%% gsr_OneColor
function [datahb2]=gsr_OneColor(datahb,bimask)
 
[nVx nVy T]=size(datahb);
 
datahb=reshape(datahb,nVx*nVy,1,T);
 
gs=squeeze(mean(datahb(bimask==1,:,:),1));
[datahb2 Rgs]=regcorr(datahb,gs);
[datahb2]=reshape(squeeze(datahb2),nVx,nVy,[]);
 
end
 
%% gsr_OIS
function [Oxy_gsr DeOxy_gsr]=gsr_stroke2(datahb,bimask)
 
[nVx nVy hb T]=size(datahb);
 
datahb=reshape(datahb,nVx*nVy,hb,T);
gs=squeeze(mean(datahb(bimask==1,:,:),1));
[datahb2 Rgs]=regcorr(datahb,gs);
datahb2=reshape(datahb2,nVx, nVy, hb, T);
Oxy_gsr=squeeze(datahb2(:,:,1,:));
DeOxy_gsr=squeeze(datahb2(:,:,2,:));
        
end