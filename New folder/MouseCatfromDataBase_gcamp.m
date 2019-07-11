clear all;
close all;
clc;
excelFile="D:\GCaMP\GCaMP_awake.xlsx";
outname='cat';
isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end

info.nVy = 128;
info.nVx = 128;

%% block average plot
numMice = 4;
cat_gcampCorr_runs_blockAvg_active=  zeros(numMice,707);
cat_gcampRaw_runs_blockAvg_active=  zeros(numMice,707);
cat_green_runs_blockAvg_active=  zeros(numMice,707);
cat_oxy_runs_blockAvg_active =  zeros(numMice,707);
cat_deoxy_runs_blockAvg_active = zeros(numMice,707);
cat_total_runs_blockAvg_active = zeros(numMice,707);
ii = 1;
cat_mouseName = [];
for excelRow= [17 19]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    cat_mouseName = strcat(cat_mouseName,recDate,"-",mouseName, "  ");
    processedDataFileName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend",'_BlockAverage.mat');
    load(strcat(fullfile(saveDir,processedDataFileName)))
    
    
    if excelRow == 2
        gcampCorr_runs_blockAvg_active = resample(gcampCorr_runs_blockAvg_active,7,5);
        gcampRaw_runs_blockAvg_active = resample(gcampRaw_runs_blockAvg_active,7,5);
        green_runs_blockAvg_active = resample(green_runs_blockAvg_active,7,5);
        oxy_runs_blockAvg_active = resample(oxy_runs_blockAvg_active,7,5);
        deoxy_runs_blockAvg_active = resample(deoxy_runs_blockAvg_active,7,5);
        total_runs_blockAvg_active = resample(total_runs_blockAvg_active,7,5);
        
        gcampCorr_runs_blockAvg_active(end+1) = 0;
        gcampRaw_runs_blockAvg_active(end+1) = 0;
        green_runs_blockAvg_active(end+1) = 0;
        oxy_runs_blockAvg_active(end+1) = 0;
        deoxy_runs_blockAvg_active(end+1) = 0;
        total_runs_blockAvg_active(end+1) = 0;
        
    end
    
    
    cat_gcampCorr_runs_blockAvg_active(ii,:)=  gcampCorr_runs_blockAvg_active;
    cat_gcampRaw_runs_blockAvg_active(ii,:)=  gcampRaw_runs_blockAvg_active;
    cat_green_runs_blockAvg_active(ii,:)=  green_runs_blockAvg_active;
    cat_oxy_runs_blockAvg_active(ii,:)=  oxy_runs_blockAvg_active;
    cat_deoxy_runs_blockAvg_active(ii,:) = deoxy_runs_blockAvg_active;
    cat_total_runs_blockAvg_active(ii,:) = total_runs_blockAvg_active;
    ii = ii+1;
end

gcampCorr_mice_blockAvg_active=  mean(cat_gcampCorr_runs_blockAvg_active);
gcampRaw_mice_blockAvg_active=  mean(cat_gcampRaw_runs_blockAvg_active);
green_mice_blockAvg_active=  mean(cat_green_runs_blockAvg_active);
oxy_mice_blockAvg_active=  mean(cat_oxy_runs_blockAvg_active);
deoxy_mice_blockAvg_active = mean(cat_deoxy_runs_blockAvg_active);
total_mice_blockAvg_active = mean(cat_total_runs_blockAvg_active);
sessionInfo.framerate = excelRaw{7};

sessionInfo.stimblocksize = excelRaw{8};
sessionInfo.stimbaseline = excelRaw{9};
sessionInfo.stimduration = excelRaw{10};
sessionInfo.stimFrequency = excelRaw{12};
x = (1:sessionInfo.stimblocksize).*(30/sessionInfo.stimblocksize);
plotedit on

subplot('position',[0.55,0.2,0.4,0.6])
yyaxis left
p1 = plot(x(1:472),gcampCorr_mice_blockAvg_active(1:472),'k');
ylim([-0.02 0.04])


hold on
yyaxis right
p2 = plot(x(1:472),oxy_mice_blockAvg_active(1:472),'r');
ylim([-2e-5 4e-5])
hold on
yyaxis right
ylabel('HBO_2,HbR(\DeltaM)','FontSize',8)
p3 = plot(x(1:472),deoxy_mice_blockAvg_active(1:472),'b');
ylim([-2e-5 4e-5]);
xlim([0 20]);
p4 = plot(x(1:472),total_mice_blockAvg_active(1:472),'y');
yyaxis left;
ylabel('GCaMP6f(\DeltaF/F)','FontSize',6);


hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[-0.02 0.04]);
    hold on
end
legend([p2 p3 p4 p1 ],'HbO_2','HbR','HbTotal','G6f(corr.)','FontSize',6);
xlabel('Time(s)','FontSize',6)
xt = get(gca, 'XTick');
set(gca, 'FontSize',6)


subplot('position',[0.07,0.2,0.4,0.6])
p4 = plot(x(1:472),gcampCorr_mice_blockAvg_active(1:472),'k');
ylim([-0.04 0.04])
xlim([0 20]);

hold on
p5=plot(x(1:472),gcampRaw_mice_blockAvg_active(1:472),'Color',[0 0.6 0]);
ylabel('GCaMP6f(\DeltaF/F)','FontSize',8)
hold on
p6=plot(x(1:472),green_mice_blockAvg_active(1:472),'g');
y2 = get(gca,'ylim');
hold on
for i  = 0:(5/(sessionInfo.stimduration*sessionInfo.stimFrequency)):sessionInfo.stimduration*sessionInfo.stimFrequency*(5/(sessionInfo.stimduration*sessionInfo.stimFrequency))
    line([sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i sessionInfo.stimbaseline*(30/sessionInfo.stimblocksize)+i],[-0.04 0.04]);
    hold on
end

legend([p6 p5 p4 ],'512nm','G6f(raw)','G6f(corr.)','FontSize',6);
xlabel('Time(s)','FontSize',8)

xt = get(gca, 'XTick');
set(gca, 'FontSize',6)
annotation('textbox',[0 0.95 1 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat('Block Average for ',cat_mouseName),'FontWeight','bold','Color',[1 0 0],'FontSize',8);

output=fullfile('J:\ProcessedData\GCaMP\CatData','BlockAvg_AllMice_Vis.jpg');
orient portrait
print ('-djpeg', '-r1000',output);
figure('visible', 'on');




isGsr = true;
if isGsr == true
    isGsrname = '-GSR';
else
    isGsrname = '';
end
info.nVy = 128;
info.nVx = 128;
ii = 1;
numMice = 4;
AvgOxy_endStim_mice = zeros(info.nVy,info.nVx,numMice);
AvgDeOxy_endStim_mice = zeros(info.nVy,info.nVx,numMice);
AvgTotal_endStim_mice = zeros(info.nVy,info.nVx,numMice);
Avggcamp_endStim_mice = zeros(info.nVy,info.nVx,numMice);
AvggcampCorr_endStim_mice = zeros(info.nVy,info.nVx,numMice);
numPres = 10;
gcamp_endStim_mice = zeros(info.nVy,info.nVx, numPres,numMice);
gcampCorr_endStim_mice = zeros(info.nVy,info.nVx, numPres,numMice);
oxy_endStim_mice = zeros(info.nVy,info.nVx, numPres,numMice);
deoxy_endStim_mice = zeros(info.nVy,info.nVx, numPres,numMice);
total_endStim_mice = zeros(info.nVy,info.nVx, numPres,numMice);

cat_mouseName = [];
for excelRow= [17 19]
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
    
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    
    
    
    
    
    cat_mouseName = strcat(cat_mouseName,recDate,"-",mouseName, "  ");
    processedDataFileName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend","_StimMap_EachMouse.mat");
    load(fullfile(saveDir,processedDataFileName))
    AvgOxy_endStim_mice (:,:,ii)= AvgOxy_endStim_runs;
    AvgDeOxy_endStim_mice (:,:,ii)= AvgDeOxy_endStim_runs;
    AvgTotal_endStim_mice (:,:,ii)= AvgTotal_endStim_runs;
    Avggcamp_endStim_mice (:,:,ii)= Avggcamp_endStim_runs;
    AvggcampCorr_endStim_mice (:,:,ii)= AvggcampCorr_endStim_runs;
    
    gcamp_endStim_mice(:,:,:,ii)=  gcamp_endStim_runs;
    gcampCorr_endStim_mice(:,:,:,ii)= gcampCorr_endStim_runs;
    oxy_endStim_mice(:,:,:,ii)= oxy_endStim_runs;
    deoxy_endStim_mice(:,:,:,ii)= deoxy_endStim_runs;
    total_endStim_mice(:,:,:,ii)= total_endStim_runs;
    
    ii = ii+1;
    
end


AvgOxy_endStim_mice=mean( AvgOxy_endStim_mice,3);
AvgDeOxy_endStim_mice=mean( AvgDeOxy_endStim_mice,3);
AvgTotal_endStim_mice=mean( AvgTotal_endStim_mice,3);
Avggcamp_endStim_mice=mean( Avggcamp_endStim_mice,3);
AvggcampCorr_endStim_mice=mean( AvggcampCorr_endStim_mice,3);
gcamp_endStim_mice=mean(gcamp_endStim_mice,4);
gcampCorr_endStim_mice=mean(gcampCorr_endStim_mice,4);
oxy_endStim_mice=mean(oxy_endStim_mice,4);
deoxy_endStim_mice=mean(deoxy_endStim_mice,4);
total_endStim_mice=mean(total_endStim_mice,4);

save(fullfile('J:\ProcessedData\GCaMP\CatData','StimMap_AllMice.mat'),'AvgOxy_endStim_mice', 'AvgDeOxy_endStim_mice', 'AvgTotal_endStim_mice','Avggcamp_endStim_mice','AvggcampCorr_endStim_mice','gcamp_endStim_mice','gcampCorr_endStim_mice','oxy_endStim_mice','deoxy_endStim_mice','total_endStim_mice');






for b=1:numPres
    p = subplot('position', [0.015+(b-1)*0.095 0.8 0.095 0.095]);
    imagesc(gcamp_endStim_mice(:,:,b), [-0.95*max(max(gcamp_endStim_mice(:,:,b))) 0.95*max(max(gcamp_endStim_mice(:,:,b)))]);
    
    if b == numPres
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.8 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('GcampRaw')
    end
    title(['Pres ', num2str(b)]);
    
end


for b=1:numPres
    p = subplot('position', [0.015+(b-1)*0.095 0.65 0.095 0.095]);
    imagesc(gcampCorr_endStim_mice(:,:,b), [-0.95*max(max(gcampCorr_endStim_mice(:,:,b))) 0.95*max(max(gcampCorr_endStim_mice(:,:,b)))]);
    if b == numPres
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.65 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('GcampCorr')
    end
    title(['Pres ', num2str(b)]);
    
end


for b=1:numPres
    p = subplot('position', [0.015+(b-1)*0.095 0.5 0.095 0.095]);
    imagesc(oxy_endStim_mice(:,:,b), [-0.95*max(max(oxy_endStim_mice(:,:,b))) 0.95*max(max(oxy_endStim_mice(:,:,b)))]);
    if b == numPres
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.5 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b == 1
        ylabel('Oxy')
    end
    title(['Pres ', num2str(b)]);
end


for b=1:numPres
    p = subplot('position', [0.015+(b-1)*0.095 0.35 0.095 0.095]);
    imagesc(deoxy_endStim_mice(:,:,b),[-0.95*max(max(deoxy_endStim_mice(:,:,b))) 0.95*max(max(deoxy_endStim_mice(:,:,b)))]);
    if b == numPres
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.35 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('DeOxy')
    end
    title(['Pres ', num2str(b)]);
end




for b=1:numPres
    p = subplot('position', [0.015+(b-1)*0.095 0.2 0.095 0.095]);
    imagesc(total_endStim_mice(:,:,b), [-0.95*max(max(total_endStim_mice(:,:,b))) 0.95*max(max(total_endStim_mice(:,:,b)))]);
    if b == numPres
        colorbar
        set(p,'Position',[0.015+(b-1)*0.095 0.2 0.095 0.095]);
    end
    axis image;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if b==1
        ylabel('Total')
    end
    title(['Pres ', num2str(b)]);
end



p = subplot('position', [0.015 0.05 0.095 0.095]);
imagesc(Avggcamp_endStim_mice, [-0.95*max(max(Avggcamp_endStim_mice)) 0.95*max(max(Avggcamp_endStim_mice))]);
colorbar
set(p,'Position',[0.015 0.05 0.095 0.095]);
axis image off
title('Avg Gcamp')



p = subplot('position', [0.165 0.05 0.095 0.095]);
imagesc(AvggcampCorr_endStim_mice, [-0.95*max(max(AvggcampCorr_endStim_mice)) 0.95*max(max(AvggcampCorr_endStim_mice))]);
colorbar
set(p,'Position',[0.165 0.05 0.095 0.095]);
axis image off
title('Avg GcampCorr')



p = subplot('position', [0.315 0.05 0.095 0.095]);
imagesc(AvgOxy_endStim_mice, [-0.95*max(max(AvgOxy_endStim_mice)) 0.95*max(max(AvgOxy_endStim_mice))]);
colorbar
set(p,'Position',[0.315 0.05 0.095 0.095]);
axis image off
title('Avg Oxy')

p = subplot('position', [0.465 0.05 0.095 0.095]);
imagesc(AvgDeOxy_endStim_mice, [-0.95*max(max(AvgDeOxy_endStim_mice)) 0.95*max(max(AvgDeOxy_endStim_mice))]);
colorbar
set(p,'Position',[0.465 0.05 0.095 0.095]);
axis image off
title('Avg Deoxy')


p = subplot('position', [0.615 0.05 0.095 0.095]);
imagesc(AvgTotal_endStim_mice, [-0.95*max(max(AvgTotal_endStim_mice)) 0.95*max(max(AvgTotal_endStim_mice))]);
colorbar
set(p,'Position',[0.615 0.05 0.095 0.095]);
axis image off
title('Avg Total')

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(cat_mouseName,'Processed Data Visualization'),'FontWeight','bold','Color',[1 0 0]);

output= fullfile('J:\ProcessedData\GCaMP\CatData','StimMap_AllMice.jpg');
orient portrait
print ('-djpeg', '-r300', output);

figure('visible', 'on');
close all





% %% FC
% %
% clear all;
% excelFile = "D:\GCaMP\GCaMP_awake.xlsx";%Xiaodan
% isGsr = true;
% if isGsr == true
%     isGsrname = '-GSR';
% else
%     isGsrname = '';
% end
% info.nVy = 128;
% info.nVx = 128;
% ii = 1;
% numMice = 4;
% cat_mouseName = [];
% numSeeds = 14;
% Rs_oxy_ISA_mice = zeros(numSeeds,numSeeds,numMice);
% Rs_gcampCorr_ISA_mice = zeros(numSeeds,numSeeds,numMice);
% Rs_oxy_Delta_mice = zeros(numSeeds,numSeeds,numMice);
% Rs_gcampCorr_Delta_mice = zeros(numSeeds,numSeeds,numMice);
% 
% 
% R_oxy_ISA_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
% R_gcampCorr_ISA_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
% R_oxy_Delta_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
% R_gcampCorr_Delta_mice = zeros(info.nVy,info.nVx, numSeeds,numMice);
% for excelRow= [3 5 7 8 10]
%     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':N',num2str(excelRow)]);
%     
%     recDate = excelRaw{1}; recDate = string(recDate);
%     mouseName = excelRaw{2}; mouseName = string(mouseName);
%     saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
%     sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
%     
%     
%     
%     
%     
%     cat_mouseName = strcat(cat_mouseName,recDate,"-",mouseName, "  ");
%     processedDataFileName = strcat(recDate,"-",mouseName,"-",isGsrname,"-Detrend","_FCMap_EachMouse.mat");
%     load(fullfile(saveDir,processedDataFileName))
%     Rs_oxy_ISA_mice (:,:,ii)= Rs_oxy_ISA_runs;
%     Rs_gcampCorr_ISA_mice (:,:,ii)= Rs_gcampCorr_ISA_runs;
%     Rs_oxy_Delta_mice (:,:,ii)= Rs_oxy_Delta_runs;
%     Rs_gcampCorr_Delta_mice (:,:,ii)= Rs_gcampCorr_Delta_runs;
%     
%     R_oxy_ISA_mice(:,:,:,ii)=  R_oxy_ISA_runs;
%     R_gcampCorr_ISA_mice(:,:,:,ii)= R_gcampCorr_ISA_runs;
%     R_oxy_Delta_mice(:,:,:,ii)= R_oxy_Delta_runs;
%     R_gcampCorr_Delta_mice(:,:,:,ii)= R_gcampCorr_Delta_runs;
%     ii = ii+1;
% end
% 
% 
% 
% 
% 
% Rs_oxy_ISA_mice=mean( Rs_oxy_ISA_mice,3);
% Rs_gcampCorr_ISA_mice=mean( Rs_gcampCorr_ISA_mice,3);
% Rs_oxy_Delta_mice=mean( Rs_oxy_Delta_mice,3);
% Rs_gcampCorr_Delta_mice=mean( Rs_gcampCorr_Delta_mice,3);
% 
% R_oxy_ISA_mice=mean(R_oxy_ISA_mice,4);
% R_gcampCorr_ISA_mice=mean(R_gcampCorr_ISA_mice,4);
% R_oxy_Delta_mice=mean(R_oxy_Delta_mice,4);
% R_gcampCorr_Delta_mice=mean(R_gcampCorr_Delta_mice,4);
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% seednames={'Olf','Fr','Cg','M','SS','RS','V'};
% refseeds=GetReferenceSeeds;
% refseeds = refseeds(1:14,:);
% sides={'L','R'};
% 
% mm=10;
% mpp=mm/info.nVx;
% seedradmm=0.25;
% seedradpix=seedradmm/mpp;
% 
% numseeds=numel(seednames);
% numsides=numel(sides);
% P=burnseeds(refseeds,seedradpix,xform_isbrain);
% figure;
% for s=1:numseeds
%     
%     OE=0;
%     if mod(s,2)==0
%         OE=0.26;
%     else
%         OE=0.1;
%     end
%     
%     subplot('position', [OE (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_oxy_ISA_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%     axis image off
%     title([seednames{s},'R'],'FontSize',6)
%     
%     p1 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_oxy_ISA_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%     axis image off
%     title([seednames{s},'L'],'FontSize',6)
%     hold off;
%     
% end
% colorbar
% set(p1,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
% 
% for s=1:numseeds
%     
%     if mod(s,2)==0
%         OE=0.26;
%     else
%         OE=0.1;
%     end
%     
%     subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_gcampCorr_ISA_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%     axis image off
%     title([seednames{s},'R'],'FontSize',6)
%     
%     p2 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_gcampCorr_ISA_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%     axis image off
%     title([seednames{s},'L'],'FontSize',6)
%     hold off;
%     
% end
% 
% colorbar
% set(p2,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
% 
% 
% 
% 
% 
% for s=1:numseeds
%     
%     OE=0;
%     if mod(s,2)==0
%         OE=0.26;
%     else
%         OE=0.1;
%     end
%     
%     subplot('position', [OE (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_oxy_Delta_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%     axis image off
%     title([seednames{s},'R'],'FontSize',6)
%     
%     p3 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_oxy_Delta_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%     axis image off
%     title([seednames{s},'L'],'FontSize',6)
%     hold off;
%     
% end
% colorbar
% set(p3,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
% 
% for s=1:numseeds
%     
%     OE=0;
%     if mod(s,2)==0
%         OE=0.26;
%     else
%         OE=0.1;
%     end
%     
%     subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_gcampCorr_Delta_mice(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
%     axis image off
%     title([seednames{s},'R'],'FontSize',6)
%     
%     p4 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
%     %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
%     imagesc(R_gcampCorr_Delta_mice(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
%     hold on;
%     plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
%     axis image off
%     title([seednames{s},'L'],'FontSize',6)
%     hold off;
%     
% end
% 
% colorbar
% set(p4,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
% 
% 
% 
% 
% 
% 
% 
% annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(cat_mouseName,' FC Map'),'FontWeight','bold');
% annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
% annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
% 
% annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
% annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
% 
% output= fullfile('J:\ProcessedData\GCaMP\CatData',"FCMap_AllMice.jpg");
% orient portrait
% print ('-djpeg', '-r300', output);
% 
% figure('visible', 'on');
% close all
% 
% subplot(2,2,1)
% imagesc(Rs_oxy_ISA_mice,[-1 1])
% colorbar
% subplot(2,2,2)
% imagesc(Rs_gcampCorr_ISA_mice,[-1 1])
% colorbar
% subplot(2,2,3)
% imagesc(Rs_oxy_Delta_mice,[-1 1])
% colorbar
% subplot(2,2,4)
% imagesc(Rs_gcampCorr_Delta_mice,[-1 1])
% colorbar
% 
% 
% annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(cat_mouseName,' FC matrix'),'FontWeight','bold');
% annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
% annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
% 
% annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
% annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
% 
% output= fullfile('J:\ProcessedData\GCaMP\CatData',"_FCMatrix_AllMice.jpg");
% orient portrait
% print ('-djpeg', '-r300', output);
% 
% figure('visible', 'on');
% close all
% 
% save(fullfile('J:\ProcessedData\GCaMP\CatData',"_FC_AllMice.mat"),'R_oxy_ISA_mice', 'Rs_oxy_ISA_mice','R_gcampCorr_ISA_mice', 'Rs_gcampCorr_ISA_mice','R_oxy_Delta_mice', 'Rs_oxy_Delta_mice','R_gcampCorr_Delta_mice', 'Rs_gcampCorr_Delta_mice','xform_isbrain');
% 
% 

            


 