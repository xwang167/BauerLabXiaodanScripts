% TremHet5XFAD_Delta_R
% TremWT5XFAD_Delta_R
% TremKO5XFAD_Delta_R
% TremHet_Delta_R
% TremKO_Delta_R
% TremWT_Delta_R
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat')
%% Trem WT vs Trem WT 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_Delta_Power(y,x,4,:), TremWT5XFAD_Delta_Power(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremWT5XFAD(y,x)=p;
        h_TremWT_vs_TremWT5XFAD(y,x)=h;
    end
end

thresh2=1.5*10^(-4);
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_Delta_Power(:,:,4);
file2=MeanTremWT5XFAD_Delta_Power(:,:,4);
h=h_TremWT_vs_TremWT5XFAD;

file1(isnan(file1))=1;
file2(isnan(file2))=1;
h(isnan(h))=0;

Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
Im2=reshape(Im2,128*128,3);
Im2(idxn,:)=1;
Im2=reshape(Im2,128,128,3);
imagesc(Im2,  [-thresh2 thresh2]);
cb=colorbar;
set(cb,'YTick',[-1.5*10^(-4) 0 1.5*10^(-4)])
ylabel(cb, 'Power Difference (\DeltaF/F)')
axis image off;
title(['TremWT - TremWT5XFAD Calcium Delta PowerMap']);

output=['TremWT vs TremWT5XFAD Calcium Delta PowerMap','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem KO vs Trem KO 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremKO_Delta_Power(y,x,4,:), TremKO5XFAD_Delta_Power(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremKO_vs_TremKO5XFAD(y,x)=p;
        h_TremKO_vs_TremKO5XFAD(y,x)=h;
    end
end

thresh2=1.5*10^(-4);
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremKO_Delta_Power(:,:,4);
file2=MeanTremKO5XFAD_Delta_Power(:,:,4);
h=h_TremKO_vs_TremKO5XFAD;

file1(isnan(file1))=1;
file2(isnan(file2))=1;
h(isnan(h))=0;

Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
Im2=reshape(Im2,128*128,3);
Im2(idxn,:)=1;
Im2=reshape(Im2,128,128,3);
imagesc(Im2,  [-thresh2 thresh2]);
cb=colorbar;
set(cb,'YTick',[-1.5*10^(-4) 0 1.5*10^(-4)])
ylabel(cb, 'Power Difference (\DeltaF/F)')
axis image off;
title(['TremKO - TremKO5XFAD Calcium Delta PowerMap']);

output=['TremKO vs TremKO5XFAD Calcium Delta PowerMap','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);



%% Trem WT 5xFAD vs Trem KO 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT5XFAD_Delta_Power(y,x,4,:), TremKO5XFAD_Delta_Power(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremWT5XFAD_vs_TremWT5XFAD(y,x)=p;
        h_TremWT5XFAD_vs_TremWT5XFAD(y,x)=h;
    end
end

thresh2=1.5*10^(-4);
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT5XFAD_Delta_Power(:,:,4);
file2=MeanTremKO5XFAD_Delta_Power(:,:,4);
h=h_TremWT5XFAD_vs_TremWT5XFAD;

file1(isnan(file1))=1;
file2(isnan(file2))=1;
h(isnan(h))=0;

Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
Im2=reshape(Im2,128*128,3);
Im2(idxn,:)=1;
Im2=reshape(Im2,128,128,3);
imagesc(Im2,  [-thresh2 thresh2]);
cb=colorbar;
set(cb,'YTick',[-1.5*10^(-4) 0 1.5*10^(-4)])
ylabel(cb, 'Power Difference (\DeltaF/F)')
axis image off;
title(['TremWT5XFAD - TremKO5XFAD Calcium Delta PowerMap']);

output=['TremWT5XFAD vs TremKO5XFAD Calcium Delta PowerMap','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);




%% Trem WT vs Trem KO
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_Delta_Power(y,x,4,:), TremKO_Delta_Power(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremWT(y,x)=p;
        h_TremWT_vs_TremWT(y,x)=h;
    end
end

thresh2=1.5*10^(-4);
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_Delta_Power(:,:,4);
file2=MeanTremKO_Delta_Power(:,:,4);
h=h_TremWT_vs_TremWT;

file1(isnan(file1))=1;
file2(isnan(file2))=1;
h(isnan(h))=0;

Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
Im2=reshape(Im2,128*128,3);
Im2(idxn,:)=1;
Im2=reshape(Im2,128,128,3);
imagesc(Im2,  [-thresh2 thresh2]);
cb=colorbar;
set(cb,'YTick',[-1.5*10^(-4) 0 1.5*10^(-4)])
ylabel(cb, 'Power Difference (\DeltaF/F)')
axis image off;
title(['TremWT - TremKO Calcium Delta PowerMap']);

output=['TremWT vs TremKO Calcium Delta PowerMap','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem WT vs Trem KO 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_Delta_Power(y,x,4,:), TremKO5XFAD_Delta_Power(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremKO5XFAD(y,x)=p;
        h_TremWT_vs_TremKO5XFAD(y,x)=h;
    end
end

thresh2=1.5*10^(-4);
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_Delta_Power(:,:,4);
file2=MeanTremKO5XFAD_Delta_Power(:,:,4);
h=h_TremWT_vs_TremKO5XFAD;

file1(isnan(file1))=1;
file2(isnan(file2))=1;
h(isnan(h))=0;

Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
Im2=reshape(Im2,128*128,3);
Im2(idxn,:)=1;
Im2=reshape(Im2,128,128,3);
imagesc(Im2,  [-thresh2 thresh2]);
cb=colorbar;
set(cb,'YTick',[-1.5*10^(-4) 0 1.5*10^(-4)])
ylabel(cb, 'Power Difference (\DeltaF/F)')
axis image off;
title(['TremWT - TremKO5XFAD Calcium Delta PowerMap']);

output=['TremWT vs TremKO5XFAD Calcium Delta PowerMap','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem KO vs Trem WT 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremKO_Delta_Power(y,x,4,:), TremWT5XFAD_Delta_Power(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremKO_vs_TremWT5XFAD(y,x)=p;
        h_TremKO_vs_TremWT5XFAD(y,x)=h;
    end
end

thresh2=1.5*10^(-4);
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremKO_Delta_Power(:,:,4);
file2=MeanTremWT5XFAD_Delta_Power(:,:,4);
h=h_TremKO_vs_TremWT5XFAD;

file1(isnan(file1))=1;
file2(isnan(file2))=1;
h(isnan(h))=0;

Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
Im2=reshape(Im2,128*128,3);
Im2(idxn,:)=1;
Im2=reshape(Im2,128,128,3);
imagesc(Im2,  [-thresh2 thresh2]);
cb=colorbar;
set(cb,'YTick',[-1.5*10^(-4) 0 1.5*10^(-4)])
ylabel(cb, 'Power Difference (\DeltaF/F)')
axis image off;
title(['TremKO - TremWT5XFAD Calcium Delta PowerMap']);

output=['TremKO vs TremWT5XFAD Calcium Delta PowerMap','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);

