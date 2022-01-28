% TremHet5XFAD_ISA_R
% TremWT5XFAD_ISA_R
% TremKO5XFAD_ISA_R
% TremHet_ISA_R
% TremKO_ISA_R
% TremWT_ISA_R
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat')
%% Trem WT vs Trem WT 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_ISA_Bilat(y,x,1,:), TremWT5XFAD_ISA_Bilat(y,x,1,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremWT5XFAD(y,x)=p;
        h_TremWT_vs_TremWT5XFAD(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_ISA_Bilat(:,:,1);
file2=MeanTremWT5XFAD_ISA_Bilat(:,:,1);
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
set(cb,'YTick',[-0.5 0 0.5])
ylabel(cb, 'ISA Corr. Coeff., z(r)')
axis image off;
title(['TremWT - TremWT5XFAD']);

output=['TremWT vs TremWT5XFAD Bilat','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);




%% Trem WT vs Trem KO 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_ISA_Bilat(y,x,1,:), TremKO5XFAD_ISA_Bilat(y,x,1,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremWT5XFAD(y,x)=p;
        h_TremWT_vs_TremWT5XFAD(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_ISA_Bilat(:,:,1);
file2=MeanTremWT5XFAD_ISA_Bilat(:,:,1);
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
set(cb,'YTick',[-0.5 0 0.5])
ylabel(cb, 'ISA Corr. Coeff., z(r)')
axis image off;
title(['TremWT - TremKO5XFAD']);

output=['TremWT vs TremWT5XFAD Bilat','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);





%% Trem KO vs Trem KO 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremKO_ISA_Bilat(y,x,1,:), TremKO5XFAD_ISA_Bilat(y,x,1,:), 0.05, 'both', 'unequal');
        p_TremKO_vs_TremKO5XFAD(y,x)=p;
        h_TremKO_vs_TremKO5XFAD(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremKO_ISA_Bilat(:,:,1);
file2=MeanTremKO5XFAD_ISA_Bilat(:,:,1);
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
set(cb,'YTick',[-0.5 0 0.5])
ylabel(cb, 'ISA Corr. Coeff., z(r)')
axis image off;
title(['TremKO - TremKO5XFAD']);

output=['TremKO vs TremKO5XFAD Bilat','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);




%% Trem KO vs Trem WT 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremKO_ISA_Bilat(y,x,1,:), TremWT_ISA_Bilat(y,x,1,:), 0.05, 'both', 'unequal');
        p_TremKO_vs_TremKO5XFAD(y,x)=p;
        h_TremKO_vs_TremKO5XFAD(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremKO_ISA_Bilat(:,:,1);
file2=MeanTremKO5XFAD_ISA_Bilat(:,:,1);
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
set(cb,'YTick',[-0.5 0 0.5])
ylabel(cb, 'ISA Corr. Coeff., z(r)')
axis image off;
title(['TremKO - TremWT5XFAD']);

output=['TremKO vs TremWT5XFAD Bilat','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);




% 
% %% Trem Het vs Trem Het 5XFAD
% for y=1:128
%     for x=1:128
%         [h, p]=ttest2(TremHet_ISA_Bilat(y,x,4,:), TremHet5XFAD_ISA_Bilat(y,x,4,:), 0.05, 'both', 'unequal');
%         p_TremHet_vs_TremHet5XFAD(y,x)=p;
%         h_TremHet_vs_TremHet5XFAD(y,x)=h;
%     end
% end
% 
% thresh2=0.5;
% %symisbrainall = 1-symisbrainall;
% idxn=symisbrainall==0;
% 
% scrsz = get(0,'ScreenSize');
% figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
% colormap jet
% 
% file1=MeanTremHet_ISA_Bilat(:,:,4);
% file2=MeanTremHet5XFAD_ISA_Bilat(:,:,4);
% h=h_TremHet_vs_TremHet5XFAD;
% 
% file1(isnan(file1))=1;
% file2(isnan(file2))=1;
% h(isnan(h))=0;
% 
% Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
% Im2=reshape(Im2,128*128,3);
% Im2(idxn,:)=1;
% Im2=reshape(Im2,128,128,3);
% imagesc(Im2,  [-thresh2 thresh2]);
% cb=colorbar;
% set(cb,'YTick',[-0.5 0 0.5])
% ylabel(cb, 'ISA Corr. Coeff., z(r)')
% axis image off;
% title(['TremHet - TremHet5XFAD']);
% 
% output=['TremHet vs TremHet5XFAD Bilat','.jpg'];
% orient portrait
% print ('-djpeg', '-r300', output);
% 
% 
%% Trem WT 5xFAD vs Trem KO 5XFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT5XFAD_ISA_Bilat(y,x,1,:), TremKO5XFAD_ISA_Bilat(y,x,1,:), 0.05, 'both', 'unequal');
        p_TremWT5XFAD_vs_TremWT5XFAD(y,x)=p;
        h_TremWT5XFAD_vs_TremWT5XFAD(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT5XFAD_ISA_Bilat(:,:,1);
file2=MeanTremKO5XFAD_ISA_Bilat(:,:,1);
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
set(cb,'YTick',[-0.5 0 0.5])
ylabel(cb, 'ISA Corr. Coeff., z(r)')
axis image off;
title(['TremWT5XFAD - TremKO5XFAD']);

output=['TremWT5XFAD vs TremKO5XFAD Bilat','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);

% %% Trem Het 5xFAD vs Trem KO 5XFAD
% for y=1:128
%     for x=1:128
%         [h, p]=ttest2(TremHet5XFAD_ISA_Bilat(y,x,4,:), TremKO5XFAD_ISA_Bilat(y,x,4,:), 0.05, 'both', 'unequal');
%         p_TremHet5XFAD_vs_TremKO5XFAD(y,x)=p;
%         h_TremHet5XFAD_vs_TremKO5XFAD(y,x)=h;
%     end
% end
% 
% thresh2=0.5;
% idxn=symisbrainall==0;
% 
% scrsz = get(0,'ScreenSize');
% figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
% colormap jet
% 
% file1=MeanTremHet5XFAD_ISA_Bilat(:,:,4);
% file2=MeanTremKO5XFAD_ISA_Bilat(:,:,4);
% h=h_TremHet5XFAD_vs_TremKO5XFAD;
% 
% file1(isnan(file1))=1;
% file2(isnan(file2))=1;
% h(isnan(h))=0;
% 
% Im2=overlaymouse((file1-file2).*h, xform_WL, h,'jet', -thresh2, thresh2);
% Im2=reshape(Im2,128*128,3);
% Im2(idxn,:)=1;
% Im2=reshape(Im2,128,128,3);
% imagesc(Im2,  [-thresh2 thresh2]);
% cb=colorbar;
% set(cb,'YTick',[-0.5 0 0.5])
% ylabel(cb, 'ISA Corr. Coeff., z(r)')
% axis image off;
% title(['TremHet5XFAD - TremKO5XFAD']);
% 
% output=['TremHet5XFAD vs TremKO5XFAD Bilat','.jpg'];
% orient portrait
% print ('-djpeg', '-r300', output);



%% Trem WT vs Trem KO
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_ISA_Bilat(y,x,1,:), TremKO_ISA_Bilat(y,x,1,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremWT(y,x)=p;
        h_TremWT_vs_TremWT(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_ISA_Bilat(:,:,1);
file2=MeanTremKO_ISA_Bilat(:,:,1);
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
set(cb,'YTick',[-0.5 0 0.5])
ylabel(cb, 'ISA Corr. Coeff., z(r)')
axis image off;
title(['TremWT - TremKO']);

output=['TremWT vs TremKO Bilat','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);