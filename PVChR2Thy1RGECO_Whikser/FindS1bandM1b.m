Green_Blocks = nan(1024,1024,15);
Fluor_Blocks = nan(1024,1024,15);
NumDarkFrames = 60;

rawdatafolder = ;
for ii = 1:15
    % Green one block index
    Green_ind_baseline = (NumDarkFrames+(ii-1)*60*20+1):3:(NumDarkFrames+(ii-1)*60*20+5*20*3-2);% first 5s baseline
    Green_ind_on = ((NumDarkFrames+(ii-1)*60*20+1):3:(NumDarkFrames+(ii-1)*60*20+5*20*3-2))+ 5*20*3;% 5s when stimulus is on
    % Fluor one block index
    Fluor_ind_baseline = (NumDarkFrames+(ii-1)*60*20+3):3:(NumDarkFrames+(ii-1)*60*20+5*20*3);
    Fluor_ind_on = ((NumDarkFrames+(ii-1)*60*20+3):3:(NumDarkFrames+(ii-1)*60*20+5*20*3))+5*20*3;
    
    Green_baseline = nan(1024,1024,100);
    for jj = 1:100
        Green_baseline(:,:,jj) = readOneFrame_Zyla_NoBinning(rawdatafolder,Green_ind_baseline(jj));
    end
    Green_baseline = mean(Green_baseline,3);
    
    Green_on = nan(1024,1024,100);
    for jj = 1:100
        Green_on(:,:,jj) = readOneFrame_Zyla_NoBinning(rawdatafolder,Green_ind_on(jj));
    end
    Green_on = mean(Green_on,3);
    
    Green_Blocks(:,:,ii) = Green_on-Green_baseline;
    
    Fluor_baseline = nan(1024,1024,100);
    for jj = 1:100
        Fluor_baseline(:,:,jj) = readOneFrame_Zyla_NoBinning(rawdatafolder,Fluor_ind_baseline(jj));
    end
    Fluor_baseline = mean(Fluor_baseline,3);
    
    Fluor_on = nan(1024,1024,100);
    for jj = 1:100
        Fluor_on(:,:,jj) = readOneFrame_Zyla_NoBinning(rawdatafolder,Fluor_ind_on(jj));
    end
    Fluor_on = mean(Fluor_on,3);
    
    Fluor_Blocks(:,:,ii) = Fluor_on-Fluor_baseline;
    
end

Green_Blocks = mean(Green_Blocks,3);
Fluor_Blocks = mean(Fluor_Blocks,3);

subplot(1,2,1)
imagesc(Green_Blocks)
axis image off
subplot(1,2,2)
imagesc(Fluor_Blocks)
axis image off
peakMap = nan(1024,1024,2);
peakMap(:,:,1) = Green_Blocks;
peakMap(:,:,2) = Fluor_Blocks;

[ROI_S1b, StimCh_S1b] = findStimROIMask_xw(peakMap,1024,1024); 
[x_S1b,y_S1b] = centroid(ROI_S1b);

[ROI_M1b, StimCh_M1b] = findStimROIMask_xw(peakMap,1024,1024); 
[x_M1b,y_M1b] = centroid(ROI_M1b);
[x,y] = centroid(polyin);
