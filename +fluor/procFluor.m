function fluorData = procFluor(rawData)
%procFluor Preprocessing for fluorescence data

fluorData = double(rawData);

baseline = nanmean(fluorData,4);
fluorData = fluorData./repmat(baseline,[1 1 1 size(fluorData,4)]); % make the data ratiometric
fluorData = fluorData - 1; % make the data change from baseline (center at zero)

fluorData = single(fluorData);
end

