%% Average bilateral maps and t-test
if isunix
    working_folder='~/jdlab';
elseif ispc
    working_folder='Z:\';
end


%database='Z:\Rachel\Rachel_fcOIS\MattMasterList2.xlsx';
%saveloc='Z:\Rachel\Rachel_fcOIS\SSRI_Analysis\';
%rawdataloc='Z:\Rachel\Rachel_fcOIS\'; % Location of raw data
database=fullfile(working_folder,'Rachel','MattMasterListtemp.xlsx');
saveloc=fullfile(working_folder,'Rachel','Rachel_fcOIS');
rawdataloc=fullfile(working_folder,'Rachel','Rachel_fcOIS'); % Location of raw data

regtype={'Whole'};

excelfiles=[3:8,11:18,37];  % Rows from Excel Database

Group1Ind=1;
Group2Ind=1;

isbrainall=ones(128,128);

for excel=excelfiles;
    excel
    [~, ~, raw]=xlsread(database,1, ['A',num2str(excel),':D',num2str(excel)]);
    
    Date=num2str(raw{1});
    Mouse=raw{2};
    GoodRuns=str2num(raw{3});
    Group=raw{4};
    file=fullfile(saveloc,Date,[Date, '-' Mouse]);
    %load([file, '-LandmarksandMask.mat'], 'xform_isbrain');
    load([file,'-fc1-Affine_GSR_NewDetrend_is.mat'], 'isbrain2');
    xform_isbrain=isbrain2;
    isbrainall=isbrainall.*xform_isbrain;
    
    for run=GoodRuns
        tempBilat=struct2cell(load([file,'-fc', num2str(run),'-Affine_GSR_NewDetrend_is.mat'], ['BiCorIm_', Mouse]));
        %tempBilat=struct2cell(load([file,'-fc', num2str(run), '-datahb.mat'], ['BiCorIm_', Mouse]));
        tempBilat=tempBilat{1,1};
        if strcmp(Group, 'Group1');
            Group1Bilats(:,:,Group1Ind)=tempBilat;
            Group1Ind=Group1Ind+1;
        elseif strcmp(Group, 'Group2');
            Group2Bilats(:,:,Group2Ind)=tempBilat;
            Group2Ind=Group2Ind+1;
        end
    end
end

for i=1:size(Group1Bilats, 3);
    Group1Bilats(:,:,i)=Group1Bilats(:,:,i).*isbrainall;
end
for i=1:size(Group2Bilats, 3);
    Group2Bilats(:,:,i)=Group2Bilats(:,:,i).*isbrainall;
end
    
%% T Test between groups    

% Skip this for now, probably
% 
Grp1Avg(:,:,1)=mean(Group1Bilats(:,:,1:4), 3);
Grp1Avg(:,:,2)=mean(Group1Bilats(:,:,5:7), 3);
Grp1Avg(:,:,3)=mean(Group1Bilats(:,:,8:10), 3);
Grp1Avg(:,:,4)=mean(Group1Bilats(:,:,11:14), 3);
Grp1Avg(:,:,5)=mean(Group1Bilats(:,:,15:18), 3);
Grp1Avg(:,:,6)=mean(Group1Bilats(:,:,19:21), 3);
Grp1Avg(:,:,7)=mean(Group1Bilats(:,:,22:27), 3);
Grp1Avg(:,:,8)=mean(Group1Bilats(:,:,28:31), 3);
Grp1Avg(:,:,9)=mean(Group1Bilats(:,:,32:36), 3);
% Grp1Avg(:,:,10)=mean(Group1Bilats(:,:,41:45), 3);
% Grp1Avg(:,:,11)=mean(Group1Bilats(:,:,46:50), 3);
% Grp1Avg(:,:,12)=mean(Group1Bilats(:,:,51:55), 3);
% Grp1Avg(:,:,13)=mean(Group1Bilats(:,:,56:61), 3);
% Grp1Avg(:,:,14)=mean(Group1Bilats(:,:,62:67), 3);

% Grp1Avg(:,:,1)=mean(Group1Bilats(:,:,31:34), 3);
% Grp1Avg(:,:,2)=mean(Group1Bilats(:,:,35:40), 3);
% Grp1Avg(:,:,3)=mean(Group1Bilats(:,:,41:45), 3);
% Grp1Avg(:,:,4)=mean(Group1Bilats(:,:,46:50), 3);
% Grp1Avg(:,:,5)=mean(Group1Bilats(:,:,51:55), 3);
% Grp1Avg(:,:,6)=mean(Group1Bilats(:,:,56:61), 3);
% Grp1Avg(:,:,7)=mean(Group1Bilats(:,:,62:67), 3);

Grp2Avg(:,:,1)=mean(Group2Bilats(:,:,1:6), 3);
Grp2Avg(:,:,2)=mean(Group2Bilats(:,:,7:8), 3);
Grp2Avg(:,:,3)=mean(Group2Bilats(:,:,9:12), 3);
Grp2Avg(:,:,4)=mean(Group2Bilats(:,:,13:14), 3);
Grp2Avg(:,:,5)=mean(Group2Bilats(:,:,15:18), 3);
Grp2Avg(:,:,6)=mean(Group2Bilats(:,:,19:21), 3);
Grp2Avg(:,:,7)=mean(Group2Bilats(:,:,22:24), 3);
% Grp2Avg(:,:,8)=mean(Group2Bilats(:,:,32:35), 3);
% Grp2Avg(:,:,9)=mean(Group2Bilats(:,:,36:41), 3);
% Grp2Avg(:,:,10)=mean(Group2Bilats(:,:,42:44), 3);
% Grp2Avg(:,:,11)=mean(Group2Bilats(:,:,45:50), 3);
% Grp2Avg(:,:,12)=mean(Group2Bilats(:,:,51:56), 3);
% Grp2Avg(:,:,13)=mean(Group2Bilats(:,:,57:62), 3);
% Grp2Avg(:,:,14)=mean(Group2Bilats(:,:,63:66), 3);
% Grp2Avg(:,:,15)=mean(Group2Bilats(:,:,67:72), 3);
% Grp2Avg(:,:,16)=mean(Group2Bilats(:,:,73:78), 3);
% Grp2Avg(:,:,17)=mean(Group2Bilats(:,:,79:84), 3);

% Grp2Avg(:,:,1)=mean(Group2Bilats(:,:,36:41), 3);
% Grp2Avg(:,:,2)=mean(Group2Bilats(:,:,42:44), 3);
% Grp2Avg(:,:,3)=mean(Group2Bilats(:,:,45:50), 3);
% Grp2Avg(:,:,4)=mean(Group2Bilats(:,:,51:56), 3);
% Grp2Avg(:,:,5)=mean(Group2Bilats(:,:,57:62), 3);
% Grp2Avg(:,:,6)=mean(Group2Bilats(:,:,63:66), 3);
% Grp2Avg(:,:,7)=mean(Group2Bilats(:,:,67:72), 3);
% Grp2Avg(:,:,8)=mean(Group2Bilats(:,:,73:78), 3);
% Grp2Avg(:,:,9)=mean(Group2Bilats(:,:,79:84), 3);

save([saveloc, 'GCAMPSSRIbilatgroups.mat'],'Group1Bilats', 'Group2Bilats', 'Grp1Avg', 'Grp2Avg');

[hRuns, pRuns]=ttest2(Group1Bilats, Group2Bilats, 0.05, 'both', 'unequal', 3); % for t-test between all runs %3/29 changed from 0.05 to 0.1
[hMice, pMice]=ttest2(Grp1Avg, Grp2Avg, 0.001, 'both', 'unequal', 3); % t-test after averaging within mice %3/29 changed from 0.05 to 0.1

hRuns(isnan(hRuns))=0;
hMice(isnan(hMice))=0;

pMapRuns=log10(hRuns.*pRuns);
pMapMice=log10(hMice.*pMice);

pMapRuns(isnan(pMapRuns))=0;
pMapMice(isnan(pMapMice))=0;
pMapRuns(isinf(pMapRuns))=0;
pMapMice(isinf(pMapMice))=0;

% Matt addition
if ~exist('xform_WL', 'var');
    load('Z:\Rachel\Rachel_fcOIS\SSRI_Analysis\160405\160405-SSRI14_3-LandmarksandMask.mat', 'xform_WL')
end
% end matt addition
    
Im2Runs=overlaymouse(pMapRuns,xform_WL, hRuns, 'parula',min(pMapRuns(:)),0); %changed isbrain from WL
imagesc(Im2Runs);
Im2Mice=overlaymouse(pMapMice,xform_WL, hMice, 'parula',min(pMapMice(:)),0);
figure; imagesc(Im2Mice); axis image; axis off; colorbar; colormap parula; caxis([0 0.1])