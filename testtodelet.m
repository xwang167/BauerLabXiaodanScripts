for excelRows = 2:4
    runsInfo = parseRuns_xw(excelFile,excelRows);
    runInfo = runsInfo(1);
    totalSubFileNum = length(runInfo.rawFile)/2;
    load(strcat(runInfo.saveFilePrefix(1:end-6),'-seedLocation.mat'),'seedLocation_mouse','seedLocation_mouse_R')
    load(runInfo.saveMaskFile,'GoodSeedsidx')
    gridEvokeTimeTrace_jRGECO1a_L = nan(runInfo.samplingRate*runInfo.blockLen,160);
    gridEvokeTimeTrace_jRGECO1a_R = nan(runInfo.samplingRate*runInfo.blockLen,160);
    
    jj = 1;
    for ii = 1:totalSubFileNum
        load(strcat(runInfo.saveFilePrefix(1:end-6),'_',num2str(ii),'-avgCalciumMovie.mat'),'AvgMovie_jRGECO1a')
        AvgMovie_jRGECO1a = reshape(AvgMovie_jRGECO1a,128,128,runInfo.samplingRate*runInfo.blockLen,[]);
        numBlock = size(AvgMovie_jRGECO1a,4);
        kk = 1;
        while kk < numBlock+1
            if GoodSeedsidx(m(jj)) == 1        
                x1 = seedLocation_mouse(2,m(jj));
                y1 = seedLocation_mouse(1,m(jj));
                [X,Y] = meshgrid(1:128,1:128);
                radius = 3;
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
                ROI = ROI(:);
                movie_jRGECO1a = reshape(movie_jRGECO1a,[],size(movie_jRGECO1a,3));
                gridEvokeTimeTrace_jRGECO1a_L(:,m(jj)) = squeeze(mean(movie_jRGECO1a(ROI,:)));  
                               
                x1 = seedLocation_mouse_R(2,m(jj));
                y1 = seedLocation_mouse_R(1,m(jj));
                [X,Y] = meshgrid(1:128,1:128);
                radius = 3;
                ROI = sqrt((X-x1).^2+(Y-y1).^2)<radius;
                movie_jRGECO1a = AvgMovie_jRGECO1a(:,:,:,kk);
                ROI = ROI(:);
                movie_jRGECO1a = reshape(movie_jRGECO1a,[],size(movie_jRGECO1a,3));
                gridEvokeTimeTrace_jRGECO1a_R(:,m(jj)) = squeeze(mean(movie_jRGECO1a(ROI,:)));       
                kk = kk+1;
            end
            jj = jj+1;
        end       
    end
    gridEvokeTimeTrace_jRGECO1a_valid_L = gridEvokeTimeTrace_jRGECO1a_L;
    gridEvokeTimeTrace_jRGECO1a_valid_L(:,logical(1-GoodSeedsidx_new_mice)) = [];
    gridEvokeTimeTrace_jRGECO1a_valid_L_sorted = gridEvokeTimeTrace_jRGECO1a_valid_L(:,I);
    
    gridEvokeTimeTrace_jRGECO1a_valid_R = gridEvokeTimeTrace_jRGECO1a_R;
    gridEvokeTimeTrace_jRGECO1a_valid_R(:,logical(1-GoodSeedsidx_new_mice)) = [];
    gridEvokeTimeTrace_jRGECO1a_valid_R_sorted = gridEvokeTimeTrace_jRGECO1a_valid_R(:,I);
    save(strcat(runInfo.saveFilePrefix(1:end-6),'-evokeTimeTrace-Calcium.mat'),...
        'gridEvokeTimeTrace_jRGECO1a_L','gridEvokeTimeTrace_jRGECO1a_valid_L','gridEvokeTimeTrace_jRGECO1a_valid_L_sorted',...
    'gridEvokeTimeTrace_jRGECO1a_R','gridEvokeTimeTrace_jRGECO1a_valid_R','gridEvokeTimeTrace_jRGECO1a_valid_R_sorted')
end
