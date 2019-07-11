database='Z:\Rachel\MattMasterListtemp.xlsx';
saveloc='Z:\Rachel\Rachel_fcOIS\';
rawdataloc='Z:\Rachel\Rachel_fcOIS\'; % Location of raw data
regtype={'Whole'};

excelfiles=[10:18,37];  % Rows from Excell Database


for excel=excelfiles;
    [~, ~, raw]=xlsread(database,1, ['A',num2str(excel),':B',num2str(excel)]);
    
    Date=num2str(raw{1});
    Mouse=raw{2};
    file=[saveloc,Date, '\', Date, '-' Mouse];
    
    load([file,'-fc1-Affine_GSR_NewDetrend_is.mat'], 'isbrain2');
    xform_isbrain=isbrain2;
    
    n=1; %code assumes the first run is labeled as "1"
    
    while 1
        
        loopfile=[file,'-fc', num2str(n),'-Affine_GSR_NewDetrend_is.mat'];
        if ~exist(loopfile,'file');
            n=n+1;
            loopfile=[file,'-fc', num2str(n),'-Affine_GSR_NewDetrend_is.mat'];
            if ~exist(loopfile,'file');
                break
            end
        end
        
        vars = whos('-file',loopfile);
        
        %if ismember('R_LR', {vars.name})&& ismember(['BiCorIm_',Mouse], {vars.name})
        if ismember(['BiCorIm_',Mouse], {vars.name})
        %if ismember(['BiCorIm2_',Mouse], {vars.name})
            
            
            disp([loopfile,' Bilateral Connectivity Map and Matrix Already Calculated'])
            n=n+1;
        else
            tic
            load(loopfile, 'oxy', 'deoxy'); %after loopfile 'xform_datahb' originally, change 1/9/17
            disp(['Calculating Bilateral Connectivity Map ', loopfile])
            od(:,:,1,:)=oxy; %addition 1/9/18
            od(:,:,2,:)=deoxy;
            xform_datahb=real(od);
            [SeedsUsed]=CalcRasterSeedsUsed(xform_isbrain);
            [R_LR]=fcManySeed(xform_datahb, SeedsUsed, xform_isbrain, 'Whole');
            BiCorIm=CalcBilateral(R_LR, SeedsUsed);
            
            w = genvarname(['BiCorIm_',Mouse]);
            eval([w '=BiCorIm;']);
            
            %         v = genvarname(['R_LR_Whole_',Mouse]);
            %         eval([v '=R_LR;']);
            
            %save(loopfile, ['R_LR_Whole_',Mouse], ['BiCorIm_',Mouse], '-append');
            save(loopfile, ['BiCorIm_',Mouse], 'SeedsUsed', '-append');
            
            
            figure;
            imagesc(BiCorIm, [-1 1]);
            colorbar
            axis image;
            axis off;
            title([Mouse,' Bilateral Connectivity'])
            
            output=[file,'-fc', num2str(n),'_BilatMap.jpg'];
            orient portrait
            print ('-djpeg', '-r300', output);
            toc
            n=n+1;
        end
    end
    
end