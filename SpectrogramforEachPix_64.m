excelFile = "L:\RGECO\RGECO.xlsx";
excelRows = 2:13;

load('D:\OIS_Process\noVasculatureMask.mat')
mask = logical(leftMask+rightMask);
% mask = imresize(mask, 0.5);
ps_mouse = []; 
for excelRow = excelRows
    [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':V',num2str(excelRow)]);
    recDate = excelRaw{1}; recDate = string(recDate);
    mouseName = excelRaw{2}; mouseName = string(mouseName);
    saveDir = excelRaw{4}; saveDir = fullfile(string(saveDir),recDate);
    sessionType = excelRaw{6}; sessionType = sessionType(3:end-2);
    figure('Renderer', 'painters', 'Position', [100 100 1420 740])
    for ii = 1:3
        processedName = strcat(recDate,'-',mouseName,'-',sessionType,num2str(ii),'_processed','.mat');
        load(fullfile(saveDir,processedName),'xform_jrgeco1aCorr')
        xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
        xform_jrgeco1aCorr_resize  = nan(64,64,size(xform_jrgeco1aCorr,3));
        for mm = 1:size(squeeze(xform_jrgeco1aCorr),3)
        xform_jrgeco1aCorr_resize(:,:,mm) = imresize(xform_jrgeco1aCorr(:,:,mm),0.5);
        end
        ps_mask = [];
        tic
        for jj = 1:size(xform_jrgeco1aCorr_resize,1)
            for ll = 1:size(xform_jrgeco1aCorr_resize,1)
                  if mask(jj,ll)
                      timetrace = squeeze(xform_jrgeco1aCorr(jj,ll,:));
                      [~,f,t,ps] = spectrogram(timetrace,750,375,750,25,'yaxis');
                      ps_mask = cat(3,ps_mask,ps);
                  end
            end
        end
        toc
        ps_mask = mean(ps_mask,3);
        ps_mouse = cat(2,ps_mouse,ps_mask);
    end
    
    figure
    imagesc(10*log10(flip(ps_mouse)))
    xticks(1:19:114)    
    xticklabels({'0','5','10','15','20','25','30'})
    yticks(15.04:60.16:376)
    yticklabels(flip({'0','2','4','6','8','10','12'}))
    colormap jet
    hfig = gcf;
    hfig.CurrentAxes.CLim = [-80 -20];
    title(strcat(recDate,'-',mouseName,'-each pixel then average aross brain'))
    savefig(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-Spectrogram_eachpix','.fig')))
    saveas(gcf,fullfile(saveDir,strcat(recDate,'-',mouseName,'-',sessionType,'-Spectrogram_eachpix','.png')))
    close all
end

