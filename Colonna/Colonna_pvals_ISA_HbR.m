% TremHet5XFAD_ISA_R
% TremWT5XFAD_ISA_R
% TremKO5XFAD_ISA_R
% TremHet_ISA_R
% TremKO_ISA_R
% TremWT_ISA_R

thresh=0.75;

%% Trem WT vs Trem WT 5XFAD
for y=1:16
    for x=1:16
        [h, p]=ttest2(TremWT_ISA_R(y,x,2,:), TremWT5XFAD_ISA_R(y,x,2,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremWT5XFAD(y,x)=p;
        h_TremWT_vs_TremWT5XFAD(y,x)=h;
    end
end

figure;
A=MeanTremWT_ISA_R(:,:,2)-MeanTremWT5XFAD_ISA_R(:,:,2);
A=A.*h_TremWT_vs_TremWT5XFAD;
A(A==Inf)=0;
idx=isnan(A(:));
A(idx)=0;
A(A==0)=-3;
A=tril(A,-1);
mask=ones(size(A));
mask=triu(mask);
A=A+mask;
imagesc(A, [-thresh thresh]);
cmap = jet(256);
cmap(1,:) = zeros(1,3);
cmap(256,:)=ones(1,3);
colormap(cmap);
cb=colorbar;
set(cb,'XTick',[-thresh 0 thresh])
xlabel(cb, 'Corr. Coeff. r')

axis image 
hold on;
for row = 0.5:1:16.5; line([0.5, 16.5], [row, row], 'Color', [1 1 1]); end
for col = 0.5:1:16.5; line([col, col], [0.5, 16.5],'Color', [1 1 1]); end
hold off;
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
rotateXLabels(gca, 45);
title('ISA band TremWT vs TremWT5XFAD', 'FontSize', 12);

output=['ISA band TremWT vs TremWT5XFAD','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem KO vs Trem KO 5XFAD

for y=1:16
    for x=1:16
        [h, p]=ttest2(TremKO_ISA_R(y,x,2,:), TremKO5XFAD_ISA_R(y,x,2,:), 0.05, 'both', 'unequal');
        p_TremKO_vs_TremKO5XFAD(y,x)=p;
        h_TremKO_vs_TremKO5XFAD(y,x)=h;
    end
end

figure;
A=MeanTremKO_ISA_R(:,:,2)-MeanTremKO5XFAD_ISA_R(:,:,2);
A=A.*h_TremKO_vs_TremKO5XFAD;
A(A==Inf)=0;
idx=isnan(A(:));
A(idx)=0;
A(A==0)=-3;
A=tril(A,-1);
mask=ones(size(A));
mask=triu(mask);
A=A+mask;
imagesc(A, [-thresh thresh]);
cmap = jet(256);
cmap(1,:) = zeros(1,3);
cmap(256,:)=ones(1,3);
colormap(cmap);
cb=colorbar;
set(cb,'XTick',[-thresh 0 thresh])
xlabel(cb, 'Corr. Coeff. r')

axis image 
hold on;
for row = 0.5:1:16.5; line([0.5, 16.5], [row, row], 'Color', [1 1 1]); end
for col = 0.5:1:16.5; line([col, col], [0.5, 16.5],'Color', [1 1 1]); end
hold off;
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
rotateXLabels(gca, 45);
title('ISA band TremKO vs TremKO5XFAD', 'FontSize', 12);

output=['ISA band TremKO vs TremKO5XFAD','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);

%% Trem Het vs Trem Het 5XFAD

for y=1:16
    for x=1:16
        [h, p]=ttest2(TremHet_ISA_R(y,x,2,:), TremHet5XFAD_ISA_R(y,x,2,:), 0.05, 'both', 'unequal');
        p_TremHet_vs_TremHet5XFAD(y,x)=p;
        h_TremHet_vs_TremHet5XFAD(y,x)=h;
    end
end

figure;
A=MeanTremHet_ISA_R(:,:,2)-MeanTremHet5XFAD_ISA_R(:,:,2);
A=A.*h_TremHet_vs_TremHet5XFAD;
A(A==Inf)=0;
idx=isnan(A(:));
A(idx)=0;
A(A==0)=-3;
A=tril(A,-1);
mask=ones(size(A));
mask=triu(mask);
A=A+mask;
imagesc(A, [-thresh thresh]);
cmap = jet(256);
cmap(1,:) = zeros(1,3);
cmap(256,:)=ones(1,3);
colormap(cmap);
cb=colorbar;
set(cb,'XTick',[-thresh 0 thresh])
xlabel(cb, 'Corr. Coeff. r')

axis image 
hold on;
for row = 0.5:1:16.5; line([0.5, 16.5], [row, row], 'Color', [1 1 1]); end
for col = 0.5:1:16.5; line([col, col], [0.5, 16.5],'Color', [1 1 1]); end
hold off;
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
rotateXLabels(gca, 45);
title('ISA band TremHet vs TremHet5XFAD', 'FontSize', 12);

output=['ISA band TremHet vs Tremhet5XFAD','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem WT 5xFAD vs Trem KO 5XFAD

for y=1:16
    for x=1:16
        [h, p]=ttest2(TremWT5XFAD_ISA_R(y,x,2,:), TremKO5XFAD_ISA_R(y,x,2,:), 0.05, 'both', 'unequal');
        p_TremWT5xFAD_vs_TremKO5XFAD(y,x)=p;
        h_TremWT5xFAD_vs_TremKO5XFAD(y,x)=h;
    end
end

figure;
A=MeanTremWT5XFAD_ISA_R(:,:,2)-MeanTremKO5XFAD_ISA_R(:,:,2);
A=A.*h_TremWT5xFAD_vs_TremKO5XFAD;
A(A==Inf)=0;
idx=isnan(A(:));
A(idx)=0;
A(A==0)=-3;
A=tril(A,-1);
mask=ones(size(A));
mask=triu(mask);
A=A+mask;
imagesc(A, [-thresh thresh]);
cmap = jet(256);
cmap(1,:) = zeros(1,3);
cmap(256,:)=ones(1,3);
colormap(cmap);
cb=colorbar;
set(cb,'XTick',[-thresh 0 thresh])
xlabel(cb, 'Corr. Coeff. r')

axis image 
hold on;
for row = 0.5:1:16.5; line([0.5, 16.5], [row, row], 'Color', [1 1 1]); end
for col = 0.5:1:16.5; line([col, col], [0.5, 16.5],'Color', [1 1 1]); end
hold off;
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
rotateXLabels(gca, 45);
title('ISA band TremWT5XFAD vs TremKO5XFAD', 'FontSize', 12);

output=['ISA band TremWT5XFAD vs TremKO5XFAD','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem Het 5xFAD vs Trem KO 5XFAD

for y=1:16
    for x=1:16
        [h, p]=ttest2(TremHet5XFAD_ISA_R(y,x,2,:), TremKO5XFAD_ISA_R(y,x,2,:), 0.05, 'both', 'unequal');
        p_TremHet5xFAD_vs_TremKO5XFAD(y,x)=p;
        h_TremHet5xFAD_vs_TremKO5XFAD(y,x)=h;
    end
end

figure;
A=MeanTremHet5XFAD_ISA_R(:,:,2)-MeanTremKO5XFAD_ISA_R(:,:,2);
A=A.*h_TremHet5xFAD_vs_TremKO5XFAD;
A(A==Inf)=0;
idx=isnan(A(:));
A(idx)=0;
A(A==0)=-3;
A=tril(A,-1);
mask=ones(size(A));
mask=triu(mask);
A=A+mask;
imagesc(A, [-thresh thresh]);
cmap = jet(256);
cmap(1,:) = zeros(1,3);
cmap(256,:)=ones(1,3);
colormap(cmap);
cb=colorbar;
set(cb,'XTick',[-thresh 0 thresh])
xlabel(cb, 'Corr. Coeff. r')

axis image 
hold on;
for row = 0.5:1:16.5; line([0.5, 16.5], [row, row], 'Color', [1 1 1]); end
for col = 0.5:1:16.5; line([col, col], [0.5, 16.5],'Color', [1 1 1]); end
hold off;
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
rotateXLabels(gca, 45);
title('ISA band TremHet5XFAD vs TremKO5XFAD', 'FontSize', 12);

output=['ISA band TremHet5XFAD vs TremKO5XFAD','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);


%% Trem WT 5xFAD vs Trem KO 5XFAD

for y=1:16
    for x=1:16
        [h, p]=ttest2(TremWT_ISA_R(y,x,2,:), TremKO_ISA_R(y,x,2,:), 0.05, 'both', 'unequal');
        p_TremWT_vs_TremKO(y,x)=p;
        h_TremWT_vs_TremKO(y,x)=h;
    end
end

figure;
A=MeanTremWT_ISA_R(:,:,2)-MeanTremKO_ISA_R(:,:,2);
A=A.*h_TremWT_vs_TremKO;
A(A==Inf)=0;
idx=isnan(A(:));
A(idx)=0;
A(A==0)=-3;
A=tril(A,-1);
mask=ones(size(A));
mask=triu(mask);
A=A+mask;
imagesc(A, [-thresh thresh]);
cmap = jet(256);
cmap(1,:) = zeros(1,3);
cmap(256,:)=ones(1,3);
colormap(cmap);
cb=colorbar;
set(cb,'XTick',[-thresh 0 thresh])
xlabel(cb, 'Corr. Coeff. r')

axis image 
hold on;
for row = 0.5:1:16.5; line([0.5, 16.5], [row, row], 'Color', [1 1 1]); end
for col = 0.5:1:16.5; line([col, col], [0.5, 16.5],'Color', [1 1 1]); end
hold off;
set(gca,'XTick',(1:16));
set(gca,'YTick',(1:16));
set(gca,'XTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
set(gca,'YTickLabel',{'FL','CL','ML','SL','RL','PL','VL','AL','FR','CR','MR','SR','RR','PR','VR','AR'})
rotateXLabels(gca, 45);
title('ISA band TremWT vs TremKO', 'FontSize', 12);

output=['ISA band TremWTvs TremKO','.jpg'];
orient portrait
print ('-djpeg', '-r300', output);

