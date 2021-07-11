database='C:\Users\Adam\Box\Colonna data SOS\ColonnaGCAMPtest.xlsx';
excelfiles=[2:27];  % Rows from Excell Database

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    directory=['C:\Users\Adam\Box\Colonna data SOS\AvgBilat\'];
%         
    if ~exist(directory)
        mkdir(directory);
    end
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    
    if ~isnan(raw{7})
        if ischar(raw{7})
            Runs=str2num(char(raw{7}));
        else
            Runs=raw{7};
        end
    end
    
    tempDeltaMap=[];
    
    for m=Runs
%         load([Date,'-', Mouse,'-fc',num2str(m),'-seedFC-0p009-0p08.mat'], 'seedFC', 'seedFCMap');
%         tempISAMap=cat(4,tempISAMap,atanh(seedFC));
%         temp=seedFCMap;
%         seedFCMap2=zeros(128,128,16,4);
%         for ii=1:4
%             seedFCMap2(:,:,:,ii)=cell2mat(seedFCMap(1,ii));
%         end
%         tempISAMap=cat(5,tempISAMap, atanh(seedFCMap2));
        
        load([Date,'-', Mouse,'-fc',num2str(m),'-bilateralFC-0p4-4.mat'], 'bilateralFCMap');
        temp=bilateralFCMap;
        bilateralFCMap2=zeros(128,128,4);
        for ii=1:4
            bilateralFCMap2(:,:,ii)=cell2mat(bilateralFCMap(1,ii));
        end
        tempDeltaMap=cat(4,tempDeltaMap, atanh(bilateralFCMap2));
    end
    
    %MeanISAMap=mean(tempISAMap,4);
    MeanDeltaMap=mean(tempDeltaMap,4);
    
    %v = genvarname([Mouse,'_MeanISAMap']);
    x = genvarname([Mouse,'_MeanDeltaBilatMap']);
    
    %eval([v '=MeanISAMap;']);
    eval([x '=MeanDeltaMap;']);    
    
    save([directory, Date, '-', Mouse, '-AvgBilat.mat'],[Mouse,'_MeanDeltaBilatMap'])
    clearvars -except database excelfiles n
end






