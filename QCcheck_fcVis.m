function QCcheck_fcVis(refseeds,R_fluor_band, Rs_fluor_band,fluorName,fluorColor,bandname,saveDir,visName,isZTransform,xform_isbrain)
load('CerebMask.mat')

mm=10;
mpp=mm/size(xform_isbrain,1);
seedradmm=0.25;
seedradpix=seedradmm/mpp;
xform_isbrain = ones(128,128);
xform_isbrain(isnan(R_fluor_band(:,:,1))) = 0;
disp('QC visualization')
seednames= {'Fr-L'  'Cing-L' 'M-L' 'SS-L' 'RS-L' 'P-L' 'V-L' 'Aud-L'...
    'Fr-R' 'Cing-R' 'M-R' 'SS-R' 'RS-R' 'P-R' 'V-R' 'Aud-R'};
% seednames = {'Fr-L' 'Fr-R' 'Cing-L' 'Cing-R' 'M-L' 'M-R' 'SS-L' 'SS-R'...
%     'RS-L' 'RS-R' 'P-L' 'P-R' 'V-L' 'V-R' 'Aud-L' 'Aud-R'};
numseeds=numel(seednames)/2;
colorMax = 1;
    if isZTransform
colorMax = 1.5;
    end


    load('GoodWL','xform_WL')

figure('units','normalized','outerposition',[0 0 0.5 1])
colormap jet
for s=1:numseeds
    
    if mod(s,2)==0
        OE=0.22;
    else
        OE=0.02;
    end

    subplot('position', [OE*2 (0.47-((round(s/2)-1)*0.15))+0.3 0.10*2 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(xform_WL_atlas), xform_isbrain,'jet',-1,1);
    imagesc(R_fluor_band(:,:,(2*(s-1)+1)),[-colorMax colorMax]); %changed 3/1/11

    hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask)
    
    hold on;
    circles(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),seedradpix,'facecolor','none');
    axis image off
    title([seednames{2*(s-1)+1}],'FontSize',10)
    %title([seednames{s},'L'],'FontSize',10)
    
    p1 = subplot('position', [(OE+0.1)*2 (0.47-((round(s/2)-1)*0.15))+0.3 0.10*2 0.12]);
    %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(xform_WL_atlas), xform_isbrain,'jet',-1,1);
     imagesc(R_fluor_band(:,:,(2*(s-1)+2)),[-colorMax colorMax]); %changed 3/1/11

        hold on
    imagesc(xform_WL,'AlphaData',1-xform_isbrain.*cerebralMask)
    hold on;
    circles(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),seedradpix,'facecolor','none');
    axis image off
    title([seednames{2*(s-1)+2}],'FontSize',10)
    %title([seednames{s},'R'],'FontSize',10)
    hold off;
    
end
h = colorbar;
if isZTransform
ylabel(h,'z','FontSize',12);
else
  ylabel(h,'r','FontSize',12);  
end

set(p1,'Position',[(OE+0.10)*2 (0.47-((round(s/2)-1)*0.15))+0.3 0.10*2 0.12]);



subplot('position', [0.3*2 0.02 0.19*2 0.27]);
imagesc(Rs_fluor_band,[-colorMax colorMax]);

axis image
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'},'Fontsize',8);
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'},'Fontsize',8);


% set(gca,'XTickLabel',{'FL' 'FR' 'CL' 'CR' 'ML' 'MR' 'SL' 'SR' 'RL' 'RR' 'PL' 'PR' 'VL' 'VR' 'AL' 'AR'},'Fontsize',8);
% set(gca,'YTickLabel',{'FL' 'FR' 'CL' 'CR' 'ML' 'MR' 'SL' 'SR' 'RL' 'RR' 'PL' 'PR' 'VL' 'VR' 'AL' 'AR'},'Fontsize',8);

title('Correlation Matrix')


annotation('textbox',[0 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName," " ,bandname, " ",'Data Visualization'),'FontWeight','bold','FontSize',15,'Interpreter','none');
annotation('textbox',[0.1*2 0.92 0.2*2 0.04],'HorizontalAlignment','center','LineStyle','none','String',fluorName,'FontWeight','bold','Color',fluorColor,'FontSize',28);


savefig(gcf,fullfile(saveDir,strcat(visName,'_',bandname,'FC_',fluorName,'.fig')))
saveas(gcf,fullfile(saveDir,strcat(visName,'_',bandname,'FC_',fluorName,'.png')))
    




