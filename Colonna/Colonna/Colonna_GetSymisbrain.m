database='Y:\CTREM\CTREM_new.xlsx';
excelfiles=[2:27];  % Rows from Excell Database

isbrainall=ones(128);

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    Group=raw{8};
    directory=['C:\Users\Adam\Box\Colonna data SOS\AvgFC\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    file=[Date,'-',Mouse,'-AvgFC.mat'];
    
    load(file);    
    tempISAfc=eval([Mouse,'_MeanISAMap']);
    
    isbrain=zeros(128);
    isbrain(~isnan(squeeze(tempISAfc(:,:,5,1))))=1;
    isbrainall=isbrainall.*isbrain;
    
    clear([Mouse,'_MeanISAMatrix'],[Mouse,'_MeanISAMap'],[Mouse,'_MeanDeltaMatrix'],[Mouse,'_MeanDeltaMap'])
    clear tempISAfc 
    
end

symisbrainall=zeros(128);
symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);

clear location name tempfc tempR tempfcMap junk n trash Time ...
    xform_isbrain file dir date saveloc raw database directory excelfiles


