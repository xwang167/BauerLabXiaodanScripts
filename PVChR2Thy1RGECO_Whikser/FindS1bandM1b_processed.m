
runInfo = parseRuns('X:\PVChR2-Thy1RGECO\PVChR2-Thy1RGECO_OptoWhisker.xlsx',28);
load(runInfo.saveMaskFile,'I');
peakMap = peakMaps(:,:,2,4);

% check if activiation area inside of the right functional parcel
figure
imagesc(peakMap,[-0.014 0.014])
hold on
load('D:\OIS_Process\Paxinos\AtlasandIsbrain.mat','AtlasSeedsFilled')
AtlasSeedsFilled = round(InvAffine(I,AtlasSeedsFilled, 'New'));
ROI_S1b = AtlasSeedsFilled==9;
contour(ROI_S1b)
hold on
ROI_M1b = AtlasSeedsFilled==4;
contour(ROI_M1b)
colormap jet
axis image off

% find the centroid of activation area
peakMap_mouseSpace = InvAffine(I,peakMap, 'New');
figure
imagesc(peakMap_mouseSpace,[-0.014 0.014])

% find centroid for S1b
disp('click for S1b')
[ROI_S1b] = findStimROIMask_xw(peakMap_mouseSpace,128,128); 
ROI_S1b = imgaussfilt(double(ROI_S1b),4);
ROI_S1b=ROI_S1b>.75*max(max(ROI_S1b));
stats = regionprops(logical(ROI_S1b));
Centroid_S1b = stats.Centroid;
x_S1b = Centroid_S1b(1);
y_S1b = Centroid_S1b(2);
hold on
contour(ROI_S1b,'w')
hold on
scatter(x_S1b,y_S1b,'w')
x_S1b_1024 = x_S1b*8-4;
y_S1b_1024 = 1024-(y_S1b*8-4);

% find centroid for M1b
disp('click for M1b')
[ROI_M1b] = findStimROIMask_xw(peakMap_mouseSpace,128,128); 
ROI_M1b = imgaussfilt(double(ROI_M1b),4);
ROI_M1b=ROI_M1b>.75*max(max(ROI_M1b));
stats = regionprops(ROI_M1b);
Centroid_M1b = stats.Centroid;
x_M1b = Centroid_M1b(1);
y_M1b = Centroid_M1b(2);
hold on
contour(ROI_M1b,'k')
hold on
scatter(x_M1b,y_M1b,'k')
x_M1b_1024 = x_M1b*8-4;
y_M1b_1024 = 1024-(y_M1b*8-4);

%Find centorid for S1b on the right hemisphere
P = [x_S1b;y_S1b];
Coeffitients = polyfit([I.OF(1) I.tent(1)],[I.OF(2) I.tent(2)],1);
m = Coeffitients(1);
n = Coeffitients(2);
Md = zeros(2,1);
Md(1) = (P(1)+m*P(2)-m*n)/(m^2+1);
Md(2) = m*Md(1)+n;
S = 2*Md-P;
hold on
scatter(S(1),S(2),'m')
x_S1bR_1024 = S(1)*8-4;
y_S1bR_1024 = 1024-(S(2)*8-4);

