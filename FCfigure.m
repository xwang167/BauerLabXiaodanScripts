 close all                 
                    for n = [5,7,9,11,13]
                    
figure
colormap jet
imagesc(R_jrgeco1aCorr_ISA_mice(:,:,n),[-1.1 1.1])

hold on
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL','xform_WL')
 imagesc(xform_WL,'AlphaData',1-mask)
  hold on;
 circles(refseeds(n,1),refseeds(n,2),seedradpix,'facecolor','none','linewidth',6);
axis image off
                    end