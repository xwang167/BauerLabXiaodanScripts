function QCcheck_fcVis_v1(refseeds,R_oxy_band, Rs_oxy_band,R_fluorCorr_band,Rs_fluorCorr_band,fluorName,bandname,saveDir,visName,isZTransform)
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
    imagesc(R_oxy_band(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p1 = subplot('position', [OE+0.1 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_oxy_band(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end
h = colorbar;
if isZTransform
ylabel(h,'z','FontSize',12);
else
  ylabel(h,'r','FontSize',12);  
end
set(p1,'Position',[OE+0.10 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);

for s=1:numseeds
    
    if mod(s,2)==0
        OE=0.25;
    else
        OE=0.05;
    end
    
    subplot('position', [OE+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluorCorr_band(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p2 = subplot('position', [OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluorCorr_band(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
    axis image off
    title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end




h = colorbar;
if isZTransform
ylabel(h,'z','FontSize',12);
else
  ylabel(h,'r','FontSize',12);  
end
set(p2,'Position',[OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);



subplot('position', [0.27 0.1 0.19 0.32]);
imagesc(Rs_oxy_band,[-1 1]);

axis image
set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','FL','CL','ML','SL','RL','VL','OR','FR','CR','MR','SR','RR','VR'});
set(gca,'YTickLabel',{'OL','FL','CL','ML','SL','RL','VL','OR','FR','CR','MR','SR','RR','VR'})
title('Correlation Matrix')

pFluor = subplot('position', [0.75 0.098 0.19 0.32]);

imagesc(Rs_fluorCorr_band,[-1 1]);

axis image 


set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','FL','CL','ML','SL','RL','VL','OR','FR','CR','MR','SR','RR','VR'});
set(gca,'YTickLabel',{'OL','FL','CL','ML','SL','RL','VL','OR','FR','CR','MR','SR','RR','VR'})
title('Correlation Matrix')
h = colorbar;
if isZTransform
ylabel(h,'z','FontSize',12);
else
  ylabel(h,'r','FontSize',12);  
end
set(pFluor, 'Position', [0.75 0.098 0.19 0.32])
annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName," " ,bandname, " ",'Data Visualization'),'FontWeight','bold','FontSize',28,'Interpreter','none');
annotation('textbox',[0.1 0.92 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0],'FontSize',28);

if strcmp(fluorName,'gcamp6f')
    annotation('textbox',[0.65 0.92 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',strcat(fluorName,'Corr'),'FontWeight','bold','Color',[0 1 0],'FontSize',28);
elseif strcmp(fluorName,'jrgeco1a')
    annotation('textbox',[0.65 0.92 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',strcat(fluorName,'Corr'),'FontWeight','bold','Color',[1 0 0],'FontSize',28);
end
savefig(strcat(fullfile(saveDir,visName),'_',bandname,'FC'))
    
output= strcat(fullfile(saveDir,visName),'_',bandname,'FC.jpg');

orient portrait
print ('-djpeg', '-r300', output);



