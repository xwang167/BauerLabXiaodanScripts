
database="X:\CodeModification\RAT\RAT2.xlsx";
excelfiles=[6:22,24:26];  % Rows from Excell Database
a=0;
b=0;
isbrainall=ones(128);
for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':I',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    saveloc=raw{4};
    Group=raw{9};
    
    file=[saveloc, Date,'-',Mouse,'-fc-cat.mat'];    
    if exist(file)
        load(file, 'xform_isbrain');
        disp(['Loading file: ', file])
        isbrainall=isbrainall.*single(xform_isbrain);
    end
end

symisbrainall=zeros(128);
symisbrainall(:,1:64)=isbrainall(:,1:64).*fliplr(isbrainall(:,65:128));
symisbrainall(:,65:128)=fliplr(symisbrainall(:,1:64));
symisbrainall=uint8(symisbrainall);
symisbrainall=single(symisbrainall);

bilatFC_Sal = nan(128,128,10);
bilatFC_Oxy = nan(128,128,10);
for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':I',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    saveloc=raw{4};
    Group=raw{9};
    
    file=[saveloc, Date,'-',Mouse,'-fc-cat.mat'];
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    if exist(file)
        load(file,['BilatMap_',Mouse,'_Whole']);
        disp(['Loading file: ', file])
        tempR=real(atanh(eval(['BilatMap_',Mouse,'_Whole'])));        
        if strcmp(Group,'Sal') 
            a=a+1;
            bilatFC_Sal(:,:,a)=tempR.*symisbrainall;
        elseif strcmp(Group,'Oxy') 
            b=b+1;
            bilatFC_Oxy(:,:,b)=tempR.*symisbrainall;
       
        end        
        clear(['BilatMap_',Mouse,'_Whole'])
        clear Group Date Mouse
        
    else
        disp(['BilatMap_',Mouse,'_Whole ', 'does not exist'])
    end
end


[h,p] = ttest2groups(bilatFC_Sal, bilatFC_Oxy);