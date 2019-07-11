%
clear all;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end


numSeeds = 14;
Rs_oxy_ISA_mice = zeros(numSeeds,numSeeds,numMice);
Rs_gcampCorr_ISA_mice = zeros(numSeeds,numSeeds,numMice);
Rs_oxy_Delta_mice = zeros(numSeeds,numSeeds,numMice);
gcampCorr_Delta_mice = zeros(numSeeds,numSeeds,numMice);


R_oxy_ISA_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
R_gcampCorr_ISA_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
R_oxy_Delta_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
R_gcampCorr_Delta_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
cat_mouseName =[];
numMice = 5;
ii = 1;
for excelRow= []
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    if strcmp(char(sessionType),'fc')
        
        recDate = excelRaw{1}; recDate = string(recDate);
        mouseName = excelRaw{2}; mouseName = string(mouseName);
        saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
        cat_mouseName = strcat(cat_mouseName,recDate,"-",mouseName, "  ");
        SpecificMouseName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend");
        
        load(fullfile(saveDir,strcat(SpecificMouseName,"_FCMap_EachMouse.mat")),'R_oxy_ISA_runs', 'Rs_oxy_ISA_runs','R_gcampCorr_ISA_runs', 'Rs_gcampCorr_ISA_runs','R_oxy_Delta_runs', 'Rs_oxy_Delta_runs','R_gcampCorr_Delta_runs', 'Rs_gcampCorr_Delta_runs', '-append');
        Rs_oxy_ISA_mice (:,:,ii)= Rs_oxy_ISA_runs;
        Rs_gcampCorr_ISA_mice (:,:,ii)= Rs_gcampCorr_ISA_runs;
        Rs_oxy_Delta_mice (:,:,ii)= Rs_oxy_Delta_runs;
        gcampCorr_Delta_mice (:,:,ii)= gcampCorr_Delta_runs;
        
        R_oxy_ISA_mice(:,:,:,ii)=  R_oxy_ISA_runs;
        R_gcampCorr_ISA_mice(:,:,:,ii)= R_gcampCorr_ISA_runs;
        R_oxy_Delta_mice(:,:,:,ii)= R_oxy_Delta_runs;
        R_gcampCorr_Delta_mice(:,:,:,ii)= R_gcampCorr_Delta_runs;
        ii= ii+1;
    end
end

Rs_oxy_ISA_mice=mean( Rs_oxy_ISA_mice,3);
Rs_gcampCorr_ISA_mice=mean( Rs_gcampCorr_ISA_mice,3);
Rs_oxy_Delta_mice=mean( Rs_oxy_Delta_mice,3);
gcampCorr_Delta_mice=mean( gcampCorr_Delta_mice,3);

R_oxy_ISA_mice=mean(R_oxy_ISA_mice,4);
R_gcampCorr_ISA_mice=mean(R_gcampCorr_ISA_mice,4);
R_oxy_Delta_mice=mean(R_oxy_Delta_mice,4);
R_gcampCorr_Delta_mice=mean(R_gcampCorr_Delta_mice,4);










seednames={'Olf','Fr','Cg','M','SS','RS','V'};
refseeds=GetReferenceSeeds;
refseeds = refseeds(1:14,:);
sides={'L','R'};

mm=10;
mpp=mm/info.nVx;
seedradmm=0.25;
seedradpix=seedradmm/mpp;

numseeds=numel(seednames);
numsides=numel(sides);
P=burnseeds(refseeds,seedradpix,xform_isbrain);
figure;
for s=1:numseeds
    
    OE=0;
    if mod(s,2)==0
        OE=0.26;
    else
        OE=0.1;
    end
    
    subplot('position', [OE (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_ISA_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',6)
    
    p1 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_ISA_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',6)
    hold off;
    
end
colorbar
set(p1,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);

for s=1:numseeds
    
    if mod(s,2)==0
        OE=0.26;
    else
        OE=0.1;
    end
    
    subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_gcampCorr_ISA_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',6)
    
    p2 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_gcampCorr_ISA_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',6)
    hold off;
    
end

colorbar
set(p2,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);





for s=1:numseeds
    
    OE=0;
    if mod(s,2)==0
        OE=0.26;
    else
        OE=0.1;
    end
    
    subplot('position', [OE (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_Delta_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',6)
    
    p3 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_Delta_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',6)
    hold off;
    
end
colorbar
set(p3,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);

for s=1:numseeds
    
    OE=0;
    if mod(s,2)==0
        OE=0.26;
    else
        OE=0.1;
    end
    
    subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_gcampCorr_Delta_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',6)
    
    p4 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_gcampCorr_Delta_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',6)
    hold off;
    
end

colorbar
set(p4,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);







annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(cat_mouseName,'FC Map'),'FontWeight','bold');
annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);

annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA_mice",'FontWeight','bold','Color',[1 0 0]);
annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta_mice",'FontWeight','bold','Color',[0 1 0]);

output= strcat(fullfile(saveDir,SpecificMouseName),'_FCMap_EachMouse.jpg');
orient portrait
print ('-djpeg', '-r300', output);

figure('visible', 'on');
close all

subplot(2,2,1)
imagesc(Rs_oxy_ISA_mice,[-1 1])
colorbar
subplot(2,2,2)
imagesc(Rs_gcampCorr_ISA_mice,[-1 1])
subplot(2,2,3)
imagesc(Rs_oxy_Delta_mice,[-1 1])
subplot(2,2,4)
imagesc(Rs_gcampCorr_Delta_mice,[-1 1])


annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(cat_mouseName,'FC matrix'),'FontWeight','bold');
annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);

annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA_mice",'FontWeight','bold','Color',[1 0 0]);
annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta_mice",'FontWeight','bold','Color',[0 1 0]);

output= strcat(fullfile(saveDir,SpecificMouseName),'_FCMatrix_EachMouse.jpg');
orient portrait
print ('-djpeg', '-r300', output);

figure('visible', 'on');
close all



save(strcat(strcat(fullfile(saveDir,SpecificMouseName),"_FCMap_EachMouse.mat"),'R_oxy_ISA_mice', 'Rs_oxy_ISA_mice','R_gcampCorr_ISA_mice', 'Rs_gcampCorr_ISA_mice','R_oxy_Delta_mice', 'Rs_oxy_Delta_mice','R_gcampCorr_Delta_mice', 'Rs_gcampCorr_Delta_mice', '-append');
clear  R_oxy_ISA_mice    Rs_oxy_ISA_mice   R_gcampCorr_ISA_mice    Rs_gcampCorr_ISA_mice   R_oxy_Delta_mice    Rs_oxy_Delta_mice   R_gcampCorr_Delta_mice    Rs_gcampCorr_Delta_mice


