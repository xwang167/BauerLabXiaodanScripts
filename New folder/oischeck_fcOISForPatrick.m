function oischeck_fcOISForPatrick()
 
for i=1
 
catmode='onerun';  
      
 %     x_init=qc(1).Runs;
 %     [qx, rx]=quorem(sym(x_init),sym(30));
 %     runnumx=qx+1;
      
 %     if rx==0
 %         runnumx=qx;
 %         rx=30;
 %     end
      
      %runnumx
 %     y_init=qc(2).Runs;
 %     [qy, ry]=quorem(sym(y_init),sym(30));
 %     runnumy=qy+1;
      
 %     if ry==0
 %         runnumy=qy;
 %         ry=30;
 %     end
      
      %x=(x_init*10)-10;
      %y=(y_init*10);
      %x_frames=(x*16.81);
      %y_frames=(y*16.81);
      
  %    if runnumx~=runnumy
  %        disp('frames not from same run')
  %        return
  %    end
      
%for i=1:length(qc)  
 
%i=1;
      
% date=Date;
% msd=mousenum;
 
qc=struct('Date',{'170610'},...
          'MouseDay', {'a'},...
          'MouseNum', {'GCAMPSSRI2_1'},...
          'Runs', {[1:6]});  
%     
% qc=struct('Date',{'170526','170526','170526','170526','170527','170527','170527','170527','170527','170527','170528','170528','170528','170530','170530','170610'},...
%           'MouseDay', {'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'},...
%           'MouseNum', {'GCAMPSSRI1_2','GCAMPSSRI2_2','GCAMPSSRI3_3','GCAMPSSRI4_2','GCAMPSSRI1_1','GCAMPSSRI1_4','GCAMPSSRI2_3','GCAMPSSRI3_1','GCAMPSSRI3_4','GCAMPSSRI4_3','GCAMPSSRI1_3','GCAMPSSRI2_4','GCAMPSSRI4_1','GCAMPSSRI1_5','GCAMPSSRI3_2','GCAMPSSRI2_1'},...
%           'Runs', {[1:6],[1:6],[1:6],[1:2],[1:4],[1:6],[1],[1:5],[1:5],[1:6],[1:6],[1:5],[1:6],[1:5],[1:6],[1:6]});  

% qc=struct('Date',{'170714','170714','170714','170714','170628','170628','170628','170628'},...
%           'MouseDay', {'etc','a','a','a','a','a','a','a'},...
%           'MouseNum', {'9510-1_P22','9510-2_P22','9510-5_P22','9510-7_P22','9309-1_P28','9309-2_P28','9365-2_P35','9365-4_P35'},...
%           'Runs', {[1:6],[1:4],[1:4],[1:4],[1:6],[1:5],[1:6],[1:6]}); 
% qc=struct('Date',{'170622','170628','170628','170628','170628','170701','170701','170705','170705','170707','170707','170707','170707','170708','170708','170714','170714','170714','170714','170723','170723','170730','170730','170821','170821','170821','170821','170822'},...
%           'MouseDay', {'MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAP1079','MCFAP1080','MCFAPctrl','MCFAPctrl'},...
%           'MouseNum', {'9309-2_P22','9309-1_P28','9309-2_P28','9365-2_P35','9365-4_P35','9511-5_P15','9511-10_P15','9309-1_P35','9309-2_P35','9510-1_P15','9510-2_P15','9510-5_P15','9510-7_P15','9511-2_P22','9511-5_P22','9510-1_P22','9510-2_P22','9510-5_P22','9510-7_P22','9365-2_P60','9365-4_P60','9309-1_P60','9309-2_P60','9510-1_P60','9510-2_P60','9510-3_P60','9510-5_P60','9511-2_P67'},...
%           'Runs', {[1:5],[1:6],[1:5],[1:6],[1:6],[1:3],[1:6],[1:4],[1:6],[1:6],[1:6],[1:3],[1:3],[1:4],[1:3],[1:6],[1:4],[1:4],[1:4],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6],[1:6]});  

      
      %9/13/17 ms eliminated
%    qc=struct('Date',{'151215','151215','151216','151216','151217','151217','151217'},...
%           'pms', {'Ms1','Ms2','Ms1','Ms2','Ms1','Ms2','Ms3'},...
%           'ms', {'Ms1','Ms2','Ms3','Ms4','Ms5','Ms6','Ms7'},...
%           'Runs', {[5:12],[11 12 14:18],[9:11],[1:5 7:12],[7 9],[4 5 6 8:12],[4 5 6 9 10 11]});   
 
date=qc(i).Date;
%msd=qc(i).ms;
runs=qc(i).Runs;
%pmsd=qc(i).pms;
mousenum=qc(i).MouseNum;
      path=['Z:\Rachel\Rachel_fcOIS\'];
msk=['Z:\Rachel\Rachel_fcOIS\' date '\' date '-' mousenum '_mask.tif'];      
  for n=runs  
    tif=[date '\' date '-' mousenum '-fc'  num2str(n)];
    %seeds=[path 'Data\Seeds-' date '-' pmsd];
    %load([path 'Data\Seeds-' date '-' pmsd],'seedcenter');
 %n_sym=runnumx;
 %n=double(n_sym);
 %n
 
%for q=1:30
    %q
    frames_start=[1 169 337 505 673 841 1009 1177 1345 1513 1681 1849 2017 2185 2353 2521 2689 2857 3025 3193 3361 3529 3697 3865 4033 4201 4369 4537 4705 4873];
    frames_end=[168 336 504 672 840 1008 1176 1344 1512 1680 1848 2016 2184 2352 2520 2688 2856 3024 3192 3360 3528 3696 3864 4032 4200 4368 4536 4704 4872 5039];
    
%     frames_start_init=[1:168:5039];
%     frames_end_init=[168:168:5039];
%     frames_end_init(30)=5039;
%     frames_start=frames_start_init(rx);
%     frames_end=frames_end_init(ry);
    
   % frames_start=[841 1009 1177 1345 1513 1681];
   % frames_end=[1008 1176 1344 1512 1680 1848];
    
    run=[path tif];
    %filename=['/data/culver/data1/Lindsey/data/Anesthesia/',date,'/',msd,'/',run,'.tif'];
    
label='-Affine_GSR_NewDetrend_is';
 
%rawdata=cell2mat(struct2cell(load(['E:\FAD\',num2str(date),'\',mouse,'\Data\Data-',label],'raw_fit')));
WL=abs(cell2mat(struct2cell(load([run label],'WL2'))));
%11/27 WL=cell2mat(struct2cell(load([path tif 'WL'],'WL')));
isbrain=cell2mat(struct2cell(load([run label],'isbrain2')));
%seeds=cell2mat(struct2cell(load(['K:\DATA\141021\Ms3\Data\Seeds-141021-Ms3-Aff'], 'seedcenter')));
%seeds=cell2mat(struct2cell(load(['/data/culver/data1/Lindsey/data/Anesthesia/Seeds_Lindsey_good'],'seedcenter')));
seeds=cell2mat(struct2cell(load(['Z:\Rachel\Rachel_fcOIS\' date '\' date '-' mousenum '_seeds.mat'],'seedcenter')));
%seeds=(load([seeds],'seedcenter'));
%assignin('base','seedstest',seeds)
 
switch catmode
 
    case 'onerun'
        %rawdata=cell2mat(struct2cell(load(['C:\Users\PatrickWW\Documents\DATA\',date,'\',mouse,'\Data\RawData-',label],'raw_fit')));
        isbrain=cell2mat(struct2cell(load([run label],'isbrain2')));
        
        oxy=cell2mat(struct2cell(load([run label],'oxy')));
        deoxy=cell2mat(struct2cell(load([run label],'deoxy')));
        gcamp6all=cell2mat(struct2cell(load([run label],'gcamp6all')));
        %gcamp3c=cell2mat(struct2cell(load('F:\Data\pcx12KetMs1Run9.mat','pcx')));
        %WL=abs(cell2mat(struct2cell(load(['J:\DATA\',date,'\',mouse,'\Data\',label],'WL'))));
      
   
        
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
%gcamp6all=real(reshape(gcamp6all,128,128,2,[]));
 
% temp=squeeze(gcamp6all(:,:,1,:));
% 
% gcamp3c=temp(:,:,frames_start(epoch):frames_end(epoch+2));
 
%gcamp3c=temp(:,:,1:1008);
 
gcamp3c=squeeze(gcamp6all(:,:,1,:));
gcamp3u=squeeze(gcamp6all(:,:,2,:));
 
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
straceOxy=P2strace(P,oxy); %% strace is each seeds trace resulting from averaging the pixels within a seed region
straceDeOxy=P2strace(P,deoxy);
straceGCAMP3u=P2strace(P,gcamp3u);
straceGCAMP3c=P2strace(P,gcamp3c);
assignin('base','P', P)
assignin('base','straceOxy', straceOxy)
 
 
R_Oxy=strace2R(straceOxy,oxy,128,128); %% normalize  rows in time, dot product of those rows with strce
R_DeOxy=strace2R(straceDeOxy,deoxy,128,128);
R_GCAMP3u=strace2R(straceGCAMP3u,gcamp3u,128,128);
R_GCAMP3c=strace2R(straceGCAMP3c,gcamp3c,128,128);
 
 
R_Data=cat(4, R_Oxy, R_DeOxy, R_GCAMP3u, R_GCAMP3c);%, R_FAD, R_FADc);
% assignin('base','R_Data',R_Data)
% assignin('base','R_GCAMP3c',R_GCAMP3c); return
 
ii=1;
 
for i=1:2:16
    straceOxy2(ii,:)=straceOxy(i,:);
    straceOxy2(ii+8,:)=straceOxy(i+1,:);
    
    straceDeOxy2(ii,:)=straceDeOxy(i,:);
    straceDeOxy2(ii+8,:)=straceDeOxy(i+1,:);
    
    straceGCAMP3u2(ii,:)=straceGCAMP3u(i,:);
    straceGCAMP3u2(ii+8,:)=straceGCAMP3u(i+1,:);
%     
     straceGCAMP3c2(ii,:)=straceGCAMP3c(i,:);
     straceGCAMP3c2(ii+8,:)=straceGCAMP3c(i+1,:);
%     
    ii=ii+1;
end
 
Rs_Oxy=normr(straceOxy2)*normr(straceOxy2)';
Rs_DeOxy=normr(straceDeOxy2)*normr(straceDeOxy2)';
Rs_GCAMP3u=normr(straceGCAMP3u2)*normr(straceGCAMP3u2)';
Rs_GCAMP3c=normr(straceGCAMP3c2)*normr(straceGCAMP3c2)';
 
 
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
 
subplot('position', [0.5436 0.315 0.18 0.18]);
imagesc(Rs_GCAMP3u, [-1 1]); axis image; title('GCAMP6 Uncorr. Correlation Map');
% %imagesc(Rs_OIS-Rs_G, [-1 1]); axis image; title('Rest-Stim Difference Correlation Map');
set(gca,'XTick',[1:16]);
set(gca,'YTick',[1:16]);
set(gca,'XTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
% % annotation('textbox',[0.7625 0.27 0.75 0.05],'LineStyle','none','String','L','FontWeight','bold');
% % annotation('textbox',[0.8825 0.27 0.75 0.05],'LineStyle','none','String','R', 'FontWeight','bold');
% % annotation('textbox',[0.6575 0.415 0.75 0.05],'LineStyle','none','String','L', 'FontWeight', 'bold');
% % annotation('textbox',[0.6575 0.3175 0.75 0.05],'LineStyle','none','String','R', 'FontWeight', 'bold');
 set(gca,'YTickLabel',{'O','F','C','M','S','R','V','A','O','F','C','M','S','R','V','A'});
% 
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
        %WL=abs(cell2mat(struct2cell(load([path '171107\GCAMP\171107-140404_2f_P15-fc1-Affine_GSR_NewDetrend'],'WL2')))); %added 11/27
        WL=abs(cell2mat(struct2cell(load([run label],'WL2'))));
        Im2=overlaymouse(R_Data(:,:,s,d),WL, isbrain,'jet',-1,1);
        %Im2=R_Data(:,:,s,d).*isbrain;
        imagesc(Im2, [-1 1]);
        hold on;
        plot(seeds(s,1),seeds(s,2),'k.','MarkerSize',14); %uncommented 10/29
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
print('-dpng', '-r600', '-painters', [path tif label '-FC_MapsQC']);
 
save([path tif label '-FC_DataQC'], 'Rs_Oxy', 'Rs_DeOxy','Rs_GCAMP3c', 'Rs_GCAMP3u', 'R_Data', 'seeds', 'WL', 'isbrain');
 
clear s d rawdata green redgreen blue WL isbrain straceOxy straceOxy2 straceDeOxy straceDeOxy2 straceGCAMP3c straceGCAMP3c2 oxy deoxy gcamp3c
 
end
end
end
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

