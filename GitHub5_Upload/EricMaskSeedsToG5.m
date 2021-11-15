function EricMaskSeedsToG5(maskfile,outname_base)
load(maskfile, 'I', 'seedcenter', 'xform_mask');

isbrain=xform_mask;
save([outname_base 'mask.mat'], 'isbrain');

seedcenter_ms=seedcenter;
save([outname_base 'seeds.mat'], 'seedcenter_ms', 'I');