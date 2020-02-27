function John_CreateNiceWL(reducebrightness)
    load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\John\BestWL.mat','xform_WLcrop');
    mask = xform_WLcrop(:,:,1)~=0;
    xform_WLcrop = xform_WLcrop./reducebrightness;
    imagesc(xform_WLcrop,'AlphaData',mask);
    axis square
%     axis off
end