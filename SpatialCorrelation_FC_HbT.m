frequency = {'0p01','0p02','0p04','0p08','0p16','0p32','0p64','1p28'};
upmask = logical(triu(ones(2262),1));


load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_fcMatrix_mice_noGSR.mat',...
    'FCMatrix_HbT_0p01_mice','FCMatrix_HbT_0p02_mice', 'FCMatrix_HbT_0p04_mice', 'FCMatrix_HbT_0p08_mice', ...
    'FCMatrix_HbT_0p16_mice', 'FCMatrix_HbT_0p32_mice', 'FCMatrix_HbT_0p64_mice','FCMatrix_HbT_1p28_mice')
FCMatrix_HbT_0p01_mice_awake =FCMatrix_HbT_0p01_mice;
FCMatrix_HbT_0p02_mice_awake =FCMatrix_HbT_0p02_mice;
FCMatrix_HbT_0p04_mice_awake =FCMatrix_HbT_0p04_mice;
FCMatrix_HbT_0p08_mice_awake =FCMatrix_HbT_0p08_mice;
FCMatrix_HbT_0p16_mice_awake =FCMatrix_HbT_0p16_mice;
FCMatrix_HbT_0p32_mice_awake =FCMatrix_HbT_0p32_mice;
FCMatrix_HbT_0p64_mice_awake =FCMatrix_HbT_0p64_mice;
FCMatrix_HbT_1p28_mice_awake =FCMatrix_HbT_1p28_mice;

SpatialCorrelation_HbT_awake = nan(8);

for ii = 1:8
    for jj = 1:8
       eval(strcat('SpatialCorrelation_HbT_awake(ii,jj) = corr(FCMatrix_HbT_',frequency{ii},...
           '_mice_awake(upmask),FCMatrix_HbT_',frequency{jj},'_mice_awake(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end



load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_fcMatrix_mice_noGSR.mat', ...
    'FCMatrix_HbT_0p01_mice','FCMatrix_HbT_0p02_mice', 'FCMatrix_HbT_0p04_mice', 'FCMatrix_HbT_0p08_mice', ...
    'FCMatrix_HbT_0p16_mice', 'FCMatrix_HbT_0p32_mice', 'FCMatrix_HbT_0p64_mice', 'FCMatrix_HbT_1p28_mice')

SpatialCorrelation_HbT_anes = nan(8);

for ii = 1:8
    for jj = 1:8
       eval(strcat('SpatialCorrelation_HbT_anes(ii,jj) = corr(FCMatrix_HbT_',frequency{ii},...
           '_mice(upmask),FCMatrix_HbT_',frequency{jj},'_mice(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end


SpatialCorrelation_HbT_awake_anes = nan(8);
for ii = 1:8
    for jj = 1:8
       eval(strcat('SpatialCorrelation_HbT_awake_anes(ii,jj) = corr(FCMatrix_HbT_',frequency{ii},...
           '_mice(upmask),FCMatrix_HbT_',frequency{jj},'_mice_awake(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end

save('L:\RGECO\cat\spatialCorrelation_0p01.mat','SpatialCorrelation_HbT_anes','SpatialCorrelation_HbT_awake','SpatialCorrelation_HbT_awake_anes','-append')



frequency = {'0p01','0p02','0p04','0p08','0p16','0p32','0p64','1p28'};
upmask = logical(triu(ones(2262),1));


load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_fcMatrix_mice.mat',...
    'FCMatrix_HbT_0p01_mice', 'FCMatrix_HbT_0p02_mice', 'FCMatrix_HbT_0p04_mice', 'FCMatrix_HbT_0p08_mice', ...
    'FCMatrix_HbT_0p16_mice', 'FCMatrix_HbT_0p32_mice', 'FCMatrix_HbT_0p64_mice', 'FCMatrix_HbT_1p28_mice')
FCMatrix_HbT_0p01_mice_awake =FCMatrix_HbT_0p01_mice;
FCMatrix_HbT_0p02_mice_awake =FCMatrix_HbT_0p02_mice;
FCMatrix_HbT_0p04_mice_awake =FCMatrix_HbT_0p04_mice;
FCMatrix_HbT_0p08_mice_awake =FCMatrix_HbT_0p08_mice;
FCMatrix_HbT_0p16_mice_awake =FCMatrix_HbT_0p16_mice;
FCMatrix_HbT_0p32_mice_awake =FCMatrix_HbT_0p32_mice;
FCMatrix_HbT_0p64_mice_awake =FCMatrix_HbT_0p64_mice;
FCMatrix_HbT_1p28_mice_awake =FCMatrix_HbT_1p28_mice;
SpatialCorrelation_HbT_awake = nan(8);

for ii = 1:8
    for jj = 1:8
       eval(strcat('SpatialCorrelation_HbT_awake_GSR(ii,jj) = corr(FCMatrix_HbT_',frequency{ii},...
           '_mice_awake(upmask),FCMatrix_HbT_',frequency{jj},'_mice_awake(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end



load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_fcMatrix_mice.mat',...
    'FCMatrix_HbT_0p01_mice','FCMatrix_HbT_0p02_mice', 'FCMatrix_HbT_0p04_mice', 'FCMatrix_HbT_0p08_mice',...
    'FCMatrix_HbT_0p16_mice', 'FCMatrix_HbT_0p32_mice', 'FCMatrix_HbT_0p64_mice', 'FCMatrix_HbT_1p28_mice')

SpatialCorrelation_HbT_anes = nan(8);

for ii = 1:8
    for jj = 1:8
       eval(strcat('SpatialCorrelation_HbT_anes_GSR(ii,jj) = corr(FCMatrix_HbT_',frequency{ii},...
           '_mice(upmask),FCMatrix_HbT_',frequency{jj},'_mice(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end


SpatialCorrelation_HbT_awake_anes = nan(8);
for ii = 1:8
    for jj = 1:8
       eval(strcat('SpatialCorrelation_HbT_awake_anes_GSR(ii,jj) = corr(FCMatrix_HbT_',frequency{ii},...
           '_mice(upmask),FCMatrix_HbT_',frequency{jj},'_mice_awake(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end

save('L:\RGECO\cat\spatialCorrelation_0p01.mat','SpatialCorrelation_HbT_anes_GSR','SpatialCorrelation_HbT_awake_GSR','SpatialCorrelation_HbT_awake_anes_GSR','-append')