function QCcheck_fcVis(refseeds,R_oxy_ISA, Rs_oxy_ISA,R_fluorCorr_ISA,Rs_fluorCorr_ISA, R_oxy_Delta, Rs_oxy_Delta,R_fluorCorr_Delta, Rs_fluorCorr_Delta,fluorName,saveDir,visName)
disp('QC visualization')
seednames={'Olf','Fr','Cg','M','SS','RS','V'};
numseeds=numel(seednames);

figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
for s=1:numseeds
    

    if mod(s,2)==0
        OE=0.22;
    else
        OE=0.02;
    end
    
    subplot('position', [OE (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p1 = subplot('position', [OE+0.1 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end
colorbar
set(p1,'Position',[OE+0.10 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);

for s=1:numseeds
    
    if mod(s,2)==0
        OE=0.25;
    else
        OE=0.05;
    end
    
    subplot('position', [OE+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluorCorr_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p2 = subplot('position', [OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluorCorr_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end




colorbar
set(p2,'Position',[OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);



subplot('position', [0.22 0.1 0.24 0.3]);
imagesc(Rs_oxy_ISA,[-1 1]);

axis image
set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'});
set(gca,'YTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'})
title('Correlation Matrix')

subplot('position', [0.75 0.098 0.19 0.32]);

imagesc(Rs_fluorCorr_ISA,[-1 1]);

axis image 


set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'});
set(gca,'YTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'})
title('Correlation Matrix')
colorbar;

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName,' ISA Data Visualization'),'FontWeight','bold','FontSize',18);
annotation('textbox',[0.15 0.9 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0],'FontSize',14);
annotation('textbox',[0.65 0.9 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',strcat(fluorName,'Corr'),'FontWeight','bold','Color',[0 1 0],'FontSize',14);

output= strcat(fullfile(saveDir,visName),'_ISAFC.jpg');
orient portrait
print ('-djpeg', '-r300', output);

figure('units','normalized','outerposition',[0 0 1 1])
colormap jet
for s=1:numseeds
    

    if mod(s,2)==0
        OE=0.22;
    else
        OE=0.02;
    end
    
    subplot('position', [OE (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p1 = subplot('position', [OE+0.1 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end
colorbar
set(p1,'Position',[OE+0.10 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);

for s=1:numseeds
    
    if mod(s,2)==0
        OE=0.25;
    else
        OE=0.05;
    end
    
    subplot('position', [OE+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluorCorr_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p2 = subplot('position', [OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluorCorr_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end




colorbar
set(p2,'Position',[OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);



subplot('position', [0.22 0.1 0.24 0.3]);
imagesc(Rs_oxy_Delta,[-1 1]);

axis image
set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'});
set(gca,'YTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'})
title('Correlation Matrix')

subplot('position', [0.75 0.098 0.19 0.32]);

imagesc(Rs_fluorCorr_Delta,[-1 1]);

axis image 


set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'});
set(gca,'YTickLabel',{'OL','OR','FL','FR','CL','CR','ML','MR','SL','SR','RL','RR','VL','VR'})
title('Correlation Matrix')
colorbar;

annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName,' Delta Data Visualization'),'FontWeight','bold','FontSize',18);
annotation('textbox',[0.15 0.9 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0],'FontSize',14);
annotation('textbox',[0.65 0.9 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',strcat(fluorName,'Corr'),'FontWeight','bold','Color',[0 1 0],'FontSize',14);

output= strcat(fullfile(saveDir,visName),'_DeltaFC.jpg');
orient portrait
print ('-djpeg', '-r300', output);

