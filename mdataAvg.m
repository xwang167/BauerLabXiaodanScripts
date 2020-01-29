import mouse.*
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";

excelRows = 286:288;%[229,231,233,235];%203,2
mdata_mice = zeros(1,3);
runs = 1;
ii = 1;
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    mdata_mouse = zeros(1,6);
    for n = runs
        rawName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'.mat');
        load(fullfile(saveDir,rawName),'mdata')
        mdata_mouse(n) = mean(squeeze(mdata(2,:)));
           
    end
    mdata_mouse = mean(mdata_mouse);
    mdata_mice(ii) = mdata_mouse;
    ii = ii+1;
    
end
mdata_mice = mean(mdata_mice);