prompt = 'Does the ROI seem to be right? Y/N';
% ROI
title = {'Evaluate ROI'};
dims = [1 5];
definput = 'Y';
answer = inputdlg(prompt,title,dims,definput);
if strcmp(answer,'N')
    ROI = roipoly(AvggcampCorr_stim);
elseif strcmp(answer,'Y')
else
    msg = 'Please only input N or Y';
    error(msg)
    answer = inputdlg(prompt,title,dims,definput);
end

