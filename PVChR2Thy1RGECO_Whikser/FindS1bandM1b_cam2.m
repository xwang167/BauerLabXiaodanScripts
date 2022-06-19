tic
Fluor_Blocks = nan(512,512,15);
NumDarkFrames = 80;

rawdatafolder = 'D:\XW\220610\220610-N27M753-WSOnly-stim1-cam2' ;
for ii = 1:15
    % Fluor one block index
    Fluor_ind_baseline = (NumDarkFrames+(ii-1)*60*20*4+3):4:(NumDarkFrames+(ii-1)*60*20*4+5*20*4-1);
    Fluor_ind_on = ((NumDarkFrames+(ii-1)*60*20*4+5*20*4+3):4:(NumDarkFrames+(ii-1)*60*20*4+5*20*4)+ 5*20*4-1);
         
    Fluor_baseline = nan(512,512,100);
    for jj = 1:100
        Fluor_baseline(:,:,jj) = readOneFrame_Zyla_NoBinning(rawdatafolder,Fluor_ind_baseline(jj));
    end
    Fluor_baseline = mean(Fluor_baseline,3);
    
    Fluor_on = nan(512,512,100);
    for kk = 1:100
        Fluor_on(:,:,kk) = readOneFrame_Zyla_NoBinning(rawdatafolder,Fluor_ind_on(kk));
    end
    Fluor_on = mean(Fluor_on,3);   
    Fluor_Blocks(:,:,ii) = Fluor_on-Fluor_baseline;
    clear kk jj
end

Fluor_Blocks = mean(Fluor_Blocks,3);

imagesc(Fluor_Blocks)
axis image off
peakMap = Fluor_Blocks;

[ROI_S1b] = findStimROIMask_xw(peakMap,512,512); 
ROI_S1b = imgaussfilt(double(ROI_S1b),4);
stats = regionprops(logical(ROI_S1b));
Centroid_S1b = stats.Centroid;
x_S1b = Centroid_S1b(1);
y_S1b = Centroid_S1b(2);

[ROI_M1b] = findStimROIMask_xw(peakMap,512,512); 
ROI_M1b = imgaussfilt(double(ROI_M1b),4);
stats = regionprops(ROI_M1b);
Centroid_M1b = stats.Centroid;
x_M1b = Centroid_M1b(1);
y_M1b = Centroid_M1b(2);
ROI_M1b(ROI_M1b<1)=0;

figure
imagesc(Fluor_baseline)
disp('Click Anterior Midline Suture Landmark .');
[I.OF(1), I.OF(2)]=ginput(1);
disp('Click Lambda.');
[I.tent(1), I.tent(2)]=ginput(1);

P = [x_S1b;y_S1b];
Coeffitients = polyfit([I.OF(1) I.tent(1)],[I.OF(2) I.tent(2)],1);
m = Coeffitients(1);
n = Coeffitients(2);
Md = zeros(2,1);
Md(1) = (P(1)+m*P(2)-m*n)/(m^2+1);
Md(2) = m*Md(1)+n;
S = 2*Md-P;

toc



