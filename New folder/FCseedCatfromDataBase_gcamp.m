database='"D:\GCaMP\GCaMP_awake.xlsx"';
excelfiles=[22];  % Rows from Excell Database

outname='cat';
regtype={'Whole'};
bandtype = '';
for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':G',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    rawdataloc=raw{3};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    cd(directory);
    
    if exist([Date,'-',Mouse, '-fc-',bandtype,'-GSR-NewTrend', outname, '.mat'])
        for r=1:numel(regtype)
            vars = whos('-file',[Date,'-',Mouse, '-fc-',bandtype,'-GSR-NewTrend', outname, '.mat']);
            if ismember(['MeanfcMaps_',Mouse, '_', regtype{r}], {vars.name})&&ismember(['MeanR_LR_',Mouse, '_', regtype{r}], {vars.name})
                disp(['FC data using regression type ', regtype{r}, ' already calculated for ', 'n = ', num2str(n), ', ', Date, '-', Mouse])
                continue
            else
                disp(['Calculating fc data for n = ' , num2str(n),', ' Mouse, '-', Date,', Regression Type: ', regtype{r}])
                load([Date,'-',Mouse, '-fc-',bandtype,'-GSR-NewTrend', outname, '.mat'])
                [fcMap, Rmat]=fcseed(xform_datahb,xform_WL, xform_isbrain, [Date, '-', Mouse], regtype{r}, refseeds);
                
                v = genvarname(['fcMap_',Mouse,'_',regtype{r}]);
                w = genvarname(['R_',Mouse,'_',regtype{r}]);
                
                eval([v '=fcMap;']);
                eval([w '=Rmat;']);
                disp(['Saving Concatenated fc data for ', Mouse, ' n = ' , num2str(n), ', Regression Type: ', regtype{r}])
                save([directory,Date,'-',Mouse, '-fc-',bandtype,'-GSR-NewTrend', outname, '.mat'], ['fcMap_',Mouse,'_',regtype{r}],['R_',Mouse,'_',regtype{r}], '-append');
                
                [nVy, nXx, hb, ~]=size(xform_datahb);
                xform_datahb=reshape(xform_datahb,nVy, nXx, hb,[], numel(files));
                
                fcMaps=zeros(nVy, nXx, size(refseeds,1), numel(files));
                R_LR=zeros(size(refseeds,1), size(refseeds,1), numel(files));
                R_AP=zeros(size(refseeds,1), size(refseeds,1), numel(files));
                
                for f=1:numel(files)
                    [tempfcmap, tempR_LR, tempR_AP]=fcseednoplot(xform_datahb(:,:,:,:,f), xform_isbrain, refseeds, regtype{r});
                    fcMaps(:,:,:,f)=tempfcmap;
                    RMats_LR(:,:,f)=tempR_LR;
                    RMats_AP(:,:,f)=tempR_AP;
                end
                
                MeanfcMaps=mean(fcMaps,4);
                MeanR_LR=mean(RMats_LR,3);
                MeanR_AP=mean(RMats_AP,3);
                
                v = genvarname(['MeanfcMaps_',Mouse,'_',regtype{r}]);
                w = genvarname(['MeanR_LR_',Mouse,'_',regtype{r}]);
                x = genvarname(['MeanR_AP_',Mouse,'_',regtype{r}]);
                
                eval([v '=MeanfcMaps;']);
                eval([w '=MeanR_LR;']);
                eval([x '=MeanR_AP;']);
                
                VisualizefcMaps(MeanfcMaps, MeanR_LR, MeanR_AP, xform_WL, xform_isbrain, refseeds, [Date, '-', Mouse, ' Average Maps Regression Type ', regtype{r}], directory);
                disp(['Saving run-averaged fc data for ', Mouse, ' n = ',num2str(n), ', Regression Type: ', regtype{r}])
                save([directory,Date,'-',Mouse, '-fc-',bandtype,'-GSR-NewTrend', outname, '.mat'], ['MeanfcMaps_',Mouse,'_',regtype{r}],['MeanR_LR_',Mouse,'_',regtype{r}],['MeanR_AP_',Mouse,'_',regtype{r}],'-append');
                
                close all
            end
        end
    else
        disp(['No concatenated data found for n = ',num2str(n), ', ' Date, '-', Mouse])
    end    
end

clear
