database='G:\OISProjects\CulverLab\Stroke\OptoStroke.xlsx';
excelfiles=[154:182];  % Rows from Excell Database

load('G:\OISProjects\CulverLab\Stroke\ControlSymisbrainall.mat', 'symisbrainall')
[SeedsUsed]=CalcRasterSeedsUsed(symisbrainall);

type='Whole';

for n=excelfiles;
    
    [~, ~, raw]=xlsread(database,1, ['A',num2str(n),':K',num2str(n)]);
    Date=num2str(raw{1});
    Mouse=raw{2};
    saveloc=raw{4};
    directory=[saveloc, Date, '\'];
    cd(directory)
    
    disp(['Loading ', Mouse, ' n= ' , num2str(n)])
    
    if exist([directory, Date,'-', Mouse,'-fc-cat.mat'])
        
        load([Date,'-',Mouse, '-fc-cat.mat'], 'xform_datahb', 'files');
        
        [nVy, nXx, hb, ~]=size(xform_datahb);
        xform_datahb=reshape(xform_datahb,nVy, nXx, hb,[], numel(files));        
        R_AllPix=zeros(size(SeedsUsed,1), size(SeedsUsed,1), numel(files));
        
        tic
        disp('Calculating Correlation Matrix for All Pixels')
        
        for f=1:numel(files)
            disp(['Run #: ', num2str(f)])
            [tempR]=fcManySeed_fast(xform_datahb(:,:,:,:,f), symisbrainall, type);
            tempR=real(atanh(tempR));            
            tempR(tempR==Inf)=0;
            R_AllPix(:,:,f)=tempR;
        end
        
        MeanR_AllPix=mean(R_AllPix,3);        
        w = genvarname(['MeanR_AllPix_',Mouse, '_',type]);        
        eval([w '=MeanR_AllPix;']);
        toc        
        
        save([directory,Date,'-',Mouse,'-fc-cat.mat'],['MeanR_AllPix_',Mouse, '_',type], '-append');
        
    end
    
    clearvars -except SeedsUsed symisbrainall database excelfiles type
end