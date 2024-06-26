excelFile = "X:\CodeModification\Stats\Radiation_Annie\RGECO.xlsx";
excelRows_group1 = 2:8;
excelRows_group2 = 9:15;
Group_directory = "X:\CodeModification\Stats\Radiation_Annie\GroupAvg";

range_name = 'ISA';

%getting excel/mouse info
excelData = readtable(excelFile);

%Get Group labels 
label_group1 = excelData{excelRows_group1(1)-1,'Group'};
label_group2 = excelData{excelRows_group2(1)-1,'Group'};

%Create group directory
if ~exist(Group_directory)
    mkdir(Group_directory)
end


runsInfo_group1 = parseRuns(excelFile,excelRows_group1);
runsInfo_group2 = parseRuns(excelFile,excelRows_group2);

[~,start_ind_mouse_group1,~]=unique({runsInfo_group1.excelRow_char}); %Note that unique only takes characters! This makes it so that we only do landmark for one of the runs!
[~,start_ind_mouse_group2,~]=unique({runsInfo_group2.excelRow_char});

mouse_ind_group1=start_ind_mouse_group1';
mouse_ind_group2=start_ind_mouse_group2';

% intersection of xform_isbrain of both groups
xform_isbrain_intersect_groups=ones(128,128);
for runInd=mouse_ind_group1 %for each mouse
    runInfo=runsInfo_group1(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain');
    xform_isbrain_intersect_groups = xform_isbrain_intersect_groups.*xform_isbrain;
end

for runInd=mouse_ind_group2 %for each mouse
    runInfo=runsInfo_group2(runInd);
    load(runInfo.saveMaskFile,'xform_isbrain');
    xform_isbrain_intersect_groups = xform_isbrain_intersect_groups.*xform_isbrain;
end

symisbrainall=zeros(128);
symisbrainall(:,1:64)=xform_isbrain_intersect_groups(:,1:64).*fliplr(xform_isbrain_intersect_groups(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));

% Bilateral maps of mice from group1
for mouse_id= 1:numel(mouse_ind_group1) %Load all of these mice
    runInfo=runsInfo_group1(mouse_ind_group1(mouse_id));
    disp(strcat('Loaded ', runInfo.mouseName, ', group:', label_group1))
    load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-avgFC_', range_name);
    load(load_name,'bilatFCMap_mouse_avg')
    bilatFCMap_group1(:,:,:,mouse_id)=atanh(bilatFCMap_mouse_avg.*symisbrainall); % Fisher z transformation
end

% Bilateral maps of mice from group2
for mouse_id= 1:numel(mouse_ind_group2) %Load all of these mice
    runInfo=runsInfo_group1(mouse_ind_group2(mouse_id));
    disp(strcat('Loaded ', runInfo.mouseName, ', group:', label_group2))
    load_name=strcat(runInfo.saveFolder ,filesep, runInfo.recDate, '-' ,runInfo.mouseName, '-avgFC_', range_name);
    load(load_name,'bilatFCMap_mouse_avg')
    bilatFCMap_group2(:,:,:,mouse_id)=atanh(bilatFCMap_mouse_avg.*symisbrainall); % Fisher z transformation
end

[h,p] = ttest2groups(bilatFCMap_group1, bilatFCMap_group2);

figure
scatter(ones(1,7),squeeze(bilatFCMap_group1(40,40,4,:)),'r');
hold on
scatter(ones(1,7)*2,squeeze(bilatFCMap_group2(40,40,4,:)),'b');