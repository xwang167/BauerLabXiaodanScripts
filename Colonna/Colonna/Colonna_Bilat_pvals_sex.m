% TremHet5XFAD_Delta_R
% TremWT5XFAD_Delta_R
% TremKO5XFAD_Delta_R
% TremHet_Delta_R
% TremKO_Delta_R
% TremWT_Delta_R
load('C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\GoodWL.mat')
%% Trem WT 
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT_Delta_Bilat_female(y,x,4,:), TremWT_Delta_Bilat_male(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremWT_sex(y,x)=p;
        h_TremWT_sex(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT_Delta_Bilat_female(:,:,4);
file2=MeanTremWT_Delta_Bilat_male(:,:,4);
h=h_TremWT_sex;

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
ylabel(cb, 'Delta Corr. Coeff., z(r)')
axis image off;
title(['TremWTFemale - TremWTMale']);

output=['TremWT Remale vs Male','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem KO 
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremKO_Delta_Bilat_female(y,x,4,:), TremKO_Delta_Bilat_male(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremKO_sex(y,x)=p;
        h_TremKO_sex(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremKO_Delta_Bilat_female(:,:,4);
file2=MeanTremKO_Delta_Bilat_male(:,:,4);
h=h_TremKO_sex;

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
ylabel(cb, 'Delta Corr. Coeff., z(r)')
axis image off;
title(['TremKOFemale - TremKOMale']);

output=['TremKO Remale vs Male','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


% %% Trem Het 
% for y=1:128
%     for x=1:128
%         [h, p]=ttest2(TremHet_Delta_Bilat_female(y,x,4,:), TremHet_Delta_Bilat_male(y,x,4,:), 0.05, 'both', 'unequal');
%         p_TremHet_sex(y,x)=p;
%         h_TremHet_sex(y,x)=h;
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
% file1=MeanTremHet_Delta_Bilat_female(:,:,4);
% file2=MeanTremHet_Delta_Bilat_male(:,:,4);
% h=h_TremHet_sex;
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
% ylabel(cb, 'Delta Corr. Coeff., z(r)')
% axis image off;
% title(['TremHetFemale - TremHetMale']);
% 
% output=['TremHet Remale vs Male','.jpg'];
% orient portrait
% print ('-djpeg', '-r300', output);


%% Trem WT 5xFAD 
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremWT5XFAD_Delta_Bilat_female(y,x,4,:), TremWT5XFAD_Delta_Bilat_male(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremWT5XFAD_sex(y,x)=p;
        h_TremWT5XFAD_sex(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremWT5XFAD_Delta_Bilat_female(:,:,4);
file2=MeanTremWT5XFAD_Delta_Bilat_male(:,:,4);
h=h_TremWT5XFAD_sex;

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
ylabel(cb, 'Delta Corr. Coeff., z(r)')
axis image off;
title(['TremWT5XFADFemale - TremWT5XFADMale']);

output=['TremWT5XFAD Remale vs Male','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);
%% Trem Het 5xFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremHet5XFAD_Delta_Bilat_female(y,x,4,:), TremHet5XFAD_Delta_Bilat_male(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremHet5XFAD_sex(y,x)=p;
        h_TremHet5XFAD_sex(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremHet5XFAD_Delta_Bilat_female(:,:,4);
file2=MeanTremHet5XFAD_Delta_Bilat_male(:,:,4);
h=h_TremHet5XFAD_sex;

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
ylabel(cb, 'Delta Corr. Coeff., z(r)')
axis image off;
title(['TremHet5XFADFemale - TremHet5XFADMale']);

output=['TremHet5XFAD Remale vs Male','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);



%% Trem KO 5xFAD
for y=1:128
    for x=1:128
        [h, p]=ttest2(TremKO5XFAD_Delta_Bilat_female(y,x,4,:), TremKO5XFAD_Delta_Bilat_male(y,x,4,:), 0.05, 'both', 'unequal');
        p_TremKO5XFAD_sex(y,x)=p;
        h_TremKO5XFAD_sex(y,x)=h;
    end
end

thresh2=0.5;
idxn=symisbrainall==0;

scrsz = get(0,'ScreenSize');
figure('Color','w','Position', [50 50 1*scrsz(3)/4 1*scrsz(4)/4],'PaperUnits', 'inches', 'PaperPositionMode','auto','PaperOrientation','Landscape');
colormap jet

file1=MeanTremKO5XFAD_Delta_Bilat_female(:,:,4);
file2=MeanTremKO5XFAD_Delta_Bilat_male(:,:,4);
h=h_TremKO5XFAD_sex;

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
ylabel(cb, 'Delta Corr. Coeff., z(r)')
axis image off;
title(['TremKO5XFADFemale - TremKO5XFADMale']);

output=['TremKO5XFAD Remale vs Male','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);