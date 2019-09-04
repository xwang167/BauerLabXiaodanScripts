function QCcheck_fcVis_twoFluor(refseeds,R_fluor1_band, Rs_fluor1_band,R_fluor2_band,Rs_fluor2_band,fluorName1,fluorName2,fluorColor1,fluorColor2,bandname,saveDir,visName,isZTransform)
disp('QC visualization')
seednames={'Olf','Fr','Cg','M','SS','RS','V'};
numseeds=numel(seednames);
    if isZTransform
R_fluor1_band = atanh(R_fluor1_band);
R_fluor2_band = atanh(R_fluor2_band);
Rs_fluor1_band = atanh(Rs_fluor1_band);
Rs_fluor2_band = atanh(Rs_fluor2_band);

end

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
    imagesc(R_fluor1_band(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p1 = subplot('position', [OE+0.1 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluor1_band(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
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
    imagesc(R_fluor2_band(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
    hold on;
    plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
    axis image off
    title([seednames{s},'L'],'FontSize',10)
    
    p2 = subplot('position', [OE+0.1+0.45 (0.47-((round(s/2)-1)*0.15))+0.3 0.10 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluor2_band(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
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
imagesc(Rs_fluor1_band,[-1 1]);

axis image
set(gca,'XTick',(1:14));
set(gca,'YTick',(1:14));
set(gca,'XTickLabel',{'OL','FL','CL','ML','SL','RL','VL','OR','FR','CR','MR','SR','RR','VR'});
set(gca,'YTickLabel',{'OL','FL','CL','ML','SL','RL','VL','OR','FR','CR','MR','SR','RR','VR'})
title('Correlation Matrix')

pFluor = subplot('position', [0.75 0.098 0.19 0.32]);

imagesc(Rs_fluor2_band,[-1 1]);

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
annotation('textbox',[0.1 0.92 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',fluorName1,'FontWeight','bold','Color',fluorColor1,'FontSize',28);

    annotation('textbox',[0.65 0.92 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',fluorName2,'FontWeight','bold','Color',fluorColor2,'FontSize',28);

savefig(gcf,fullfile(saveDir,strcat(visName,'_',bandname,'FC_',fluorName1,fluorName2,'.fig')))
saveas(gcf,fullfile(saveDir,strcat(visName,'_',bandname,'FC_',fluorName1,fluorName2,'.png')))
    




