% frequency = {'0p02','0p04','0p08','0p16','0p32','0p64','1p28'};
% upmask = logical(triu(ones(2262),1));
% 
% 
% load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_fcMatrix_mice_noGSR.mat',...
%     'FCMatrix_FAD_0p02_mice', 'FCMatrix_FAD_0p04_mice', 'FCMatrix_FAD_0p08_mice', ...
%     'FCMatrix_FAD_0p16_mice', 'FCMatrix_FAD_0p32_mice', 'FCMatrix_FAD_0p64_mice', ...
%     'FCMatrix_FAD_1p28_mice')
% FCMatrix_FAD_0p02_mice_awake =FCMatrix_FAD_0p02_mice;
% FCMatrix_FAD_0p04_mice_awake =FCMatrix_FAD_0p04_mice;
% FCMatrix_FAD_0p08_mice_awake =FCMatrix_FAD_0p08_mice;
% FCMatrix_FAD_0p16_mice_awake =FCMatrix_FAD_0p16_mice;
% FCMatrix_FAD_0p32_mice_awake =FCMatrix_FAD_0p32_mice;
% FCMatrix_FAD_0p64_mice_awake =FCMatrix_FAD_0p64_mice;
% FCMatrix_FAD_1p28_mice_awake =FCMatrix_FAD_1p28_mice;
% SpatialCorrelation_FAD_awake = nan(7);
% 
% for ii = 1:7
%     for jj = 1:7
%        eval(strcat('SpatialCorrelation_FAD_awake(ii,jj) = corr(FCMatrix_FAD_',frequency{ii},...
%            '_mice_awake(upmask),FCMatrix_FAD_',frequency{jj},'_mice_awake(upmask),',char(39),...
%            'Type',char(39),',',char(39),'Spearman',char(39),');'))
%     end
% end
% 
% 
% 
% load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_fcMatrix_mice_noGSR.mat', 'FCMatrix_FAD_0p02_mice', 'FCMatrix_FAD_0p04_mice', 'FCMatrix_FAD_0p08_mice', 'FCMatrix_FAD_0p16_mice', 'FCMatrix_FAD_0p32_mice', 'FCMatrix_FAD_0p64_mice', 'FCMatrix_FAD_1p28_mice')
% SpatialCorrelation_FAD_anes = nan(7);
% 
% for ii = 1:7
%     for jj = 1:7
%        eval(strcat('SpatialCorrelation_FAD_anes(ii,jj) = corr(FCMatrix_FAD_',frequency{ii},...
%            '_mice(upmask),FCMatrix_FAD_',frequency{jj},'_mice(upmask),',char(39),...
%            'Type',char(39),',',char(39),'Spearman',char(39),');'))
%     end
% end
% 
% 
% SpatialCorrelation_FAD_awake_anes = nan(7);
% for ii = 1:7
%     for jj = 1:7
%        eval(strcat('SpatialCorrelation_FAD_awake_anes(ii,jj) = corr(FCMatrix_FAD_',frequency{ii},...
%            '_mice(upmask),FCMatrix_FAD_',frequency{jj},'_mice_awake(upmask),',char(39),...
%            'Type',char(39),',',char(39),'Spearman',char(39),');'))
%     end
% end
% 
% save('L:\RGECO\cat\spatialCorrelation.mat','SpatialCorrelation_FAD_anes','SpatialCorrelation_FAD_awake','SpatialCorrelation_FAD_awake_anes','-append')
% 


frequency = {'0p02','0p04','0p08','0p16','0p32','0p64','1p28'};
upmask = logical(triu(ones(2262),1));


load('191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc_fcMatrix_mice.mat',...
    'FCMatrix_FAD_0p02_mice', 'FCMatrix_FAD_0p04_mice', 'FCMatrix_FAD_0p08_mice', ...
    'FCMatrix_FAD_0p16_mice', 'FCMatrix_FAD_0p32_mice', 'FCMatrix_FAD_0p64_mice', ...
    'FCMatrix_FAD_1p28_mice')
FCMatrix_FAD_0p02_mice_awake =FCMatrix_FAD_0p02_mice;
FCMatrix_FAD_0p04_mice_awake =FCMatrix_FAD_0p04_mice;
FCMatrix_FAD_0p08_mice_awake =FCMatrix_FAD_0p08_mice;
FCMatrix_FAD_0p16_mice_awake =FCMatrix_FAD_0p16_mice;
FCMatrix_FAD_0p32_mice_awake =FCMatrix_FAD_0p32_mice;
FCMatrix_FAD_0p64_mice_awake =FCMatrix_FAD_0p64_mice;
FCMatrix_FAD_1p28_mice_awake =FCMatrix_FAD_1p28_mice;
SpatialCorrelation_FAD_awake = nan(7);

for ii = 1:7
    for jj = 1:7
       eval(strcat('SpatialCorrelation_FAD_awake_GSR(ii,jj) = corr(FCMatrix_FAD_',frequency{ii},...
           '_mice_awake(upmask),FCMatrix_FAD_',frequency{jj},'_mice_awake(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end



load('191030--R5M2286-anes-R5M2285-anes-R5M2288-anes-R6M2460-anes-R6M1-anes-R6M2497-anes-fc_fcMatrix_mice.mat', 'FCMatrix_FAD_0p02_mice', 'FCMatrix_FAD_0p04_mice', 'FCMatrix_FAD_0p08_mice', 'FCMatrix_FAD_0p16_mice', 'FCMatrix_FAD_0p32_mice', 'FCMatrix_FAD_0p64_mice', 'FCMatrix_FAD_1p28_mice')
SpatialCorrelation_FAD_anes = nan(7);

for ii = 1:7
    for jj = 1:7
       eval(strcat('SpatialCorrelation_FAD_anes_GSR(ii,jj) = corr(FCMatrix_FAD_',frequency{ii},...
           '_mice(upmask),FCMatrix_FAD_',frequency{jj},'_mice(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end


SpatialCorrelation_FAD_awake_anes = nan(7);
for ii = 1:7
    for jj = 1:7
       eval(strcat('SpatialCorrelation_FAD_awake_anes_GSR(ii,jj) = corr(FCMatrix_FAD_',frequency{ii},...
           '_mice(upmask),FCMatrix_FAD_',frequency{jj},'_mice_awake(upmask),',char(39),...
           'Type',char(39),',',char(39),'Spearman',char(39),');'))
    end
end

save('L:\RGECO\cat\spatialCorrelation.mat','SpatialCorrelation_FAD_anes_GSR','SpatialCorrelation_FAD_awake_GSR','SpatialCorrelation_FAD_awake_anes_GSR','-append')