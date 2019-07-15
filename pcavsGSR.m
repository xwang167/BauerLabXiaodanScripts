dataFile = 'J:\ProcessedData_3\GCaMP\190527\190527-G11M4-awake-stim1_processed.mat';
maskFile = 'J:\ProcessedData_3\GCaMP\190527\190527-G11M4-awake-LandmarksandMask.mat';
load(maskFile,'xform_isbrain')
load(dataFile,'xform_datahb');
data = squeeze(xform_datahb(:,:,1,2:end));
dataGSR = mouse.process.gsr(data,xform_isbrain);

time = linspace(0,300,size(xform_datahb,4)-1);
mask = logical(xform_isbrain);
dataGSR(~mask) = nan;

data = reshape(data,[],size(data,3));

data = data(mask,:);
gs = sum(data,1);


[coeff,score,latent,tsquared,explained,mu] = pca(data);
 
% The coeff variable contains coefficients for each principal component 
% (each principal component is a column). We can see the coeff to see what sort 
% of time course explains the most variance amongst the time courses.

figure;
subplot(3,1,1); plot(time,coeff(:,1)); title('PC1');
subplot(3,1,2); plot(time,coeff(:,2)); title('PC2');
subplot(3,1,3); plot(time,gs);title('Global Siginal')


disp(explained(1:2))


figure('Position',[100 100 700 300]);
subplot(1,2,1);
s = nan(128); s(mask) = score(:,1);
imagesc(s,[-max(abs(s(:))) max(abs(s(:)))]); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('PC1 coordinates')
subplot(1,2,2);
s = nan(128); s(mask) = score(:,2);
imagesc(s,[-max(abs(s(:))) max(abs(s(:)))]); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('PC2 coordinates')


pc1likeData = score(:,1)*coeff(:,1)';
dataNoPC1 = data - pc1likeData;


data2 = nan(128*128,size(data,2));
data2(mask,:) = data;
data2 = reshape(data2,128,128,[]);
data = data2;


data2 = nan(128*128,size(dataNoPC1,2));
data2(mask,:) = dataNoPC1;
data2 = reshape(data2,128,128,[]);
dataNoPC1 = data2;

figure;
title('somatosensory')
plot(time,squeeze(data(79,79,:))); hold on;
plot(time,squeeze(dataNoPC1(79,79,:)));hold on;
plot(time,squeeze(dataGSR(79,79,:)))
legend('original','dataNoPC1','dataGSR')

figure;
title('medial vasculature')
plot(time,squeeze(data(64,64,:))); hold on;
plot(time,squeeze(dataNoPC1(64,64,:)));hold on;
plot(time,squeeze(dataGSR(64,64,:)));
legend('original','dataNoPC1','dataGSR')

vid = VideoWriter('D:\Weekly Update\PCAvsGSR.avi');
vid.FrameRate = 1;
open(vid)
f = figure('Position',[100 100 900 300]);
for i = 5:5:5559
    subplot(2,3,1); imagesc(data(:,:,i),[-14 14]*1E-6); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('original')
    subplot(2,3,2); imagesc(dataNoPC1(:,:,i),[-12 12]*1E-6); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('no pc1')
    subplot(2,3,3); imagesc(data(:,:,i)-dataNoPC1(:,:,i),[-5 5]*1E-6); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('difference')
        subplot(2,3,4); imagesc(data(:,:,i),[-14 14]*1E-6); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('original')
    subplot(2,3,5); imagesc(dataGSR(:,:,i),[-3 3]*1E-6); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('GSR')
    subplot(2,3,6); imagesc(data(:,:,i)-dataGSR(:,:,i),[-8 8]*1E-6); axis(gca,'square'); xticks([]); yticks([]); colorbar; title('difference')
    set(f,'Visible','on')
    writeVideo(vid,getframe(gcf))
end
close(vid)