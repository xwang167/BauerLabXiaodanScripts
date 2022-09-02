close all
figure
 imagesc(peakMaps(:,:,4),'AlphaData',xform_isbrain_intersect);
 caxis([-1.2 1.2])
axis image off
colorbar
colormap(mycolormap)
hold on
 scatter(25.7,80.5,300,'filled','h','b')

figure
 imagesc(peakMaps(:,:,1),'AlphaData',xform_isbrain_intersect);
 caxis([-2.3 2.3])
axis image off
colorbar
colormap(HbO)


figure
 imagesc(peakMaps(:,:,2),'AlphaData',xform_isbrain_intersect);
 caxis([-0.43 0.43])
axis image off
colorbar
colormap(HbR)


figure
 imagesc(peakMaps(:,:,2)+peakMaps(:,:,1),'AlphaData',xform_isbrain_intersect);
 caxis([-2.3 2.3])
axis image off
colorbar
colormap(HbT)

peakMap_ROI = peakMaps(:,:,4);
   
        [x1,y1] = ginput(1);
        
        [x2,y2] = ginput(1);
        
        [X,Y] = meshgrid(1:128,1:128);
        
        radius = sqrt((x1-x2)^2+(y1-y2)^2);
        
        ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
        
        max_ROI = prctile(peakMap_ROI(ROI),99);
        
        temp = peakMap_ROI.*ROI;
        
        ROI = temp>0.75*max_ROI;