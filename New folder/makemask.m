function makemask()%qc)

            qc=struct('Date',{'171215'},...
          'MouseDay', {'a'},...
          'MouseNum', {'OIS2Ms1'},...
          'Runs', {[1:6]});   

for i=1:length(qc)
    
    date=qc(i).Date;
    mousenum=qc(i).MouseNum;
    %msd=qc(i).ms;

fcrun=['Z:\Rachel\Rachel_fcOIS\OIS2\' date '\' date '-' mousenum '-stim1'];
    greenframe=double(imread([fcrun,'.tif'],6));
    greenframeall(:,:,1)=greenframe./max(greenframe(:));
    greenframeall(:,:,2)=greenframe./max(greenframe(:));
    greenframeall(:,:,3)=greenframe./max(greenframe(:));

%greenframe=imread(['/data/culver/data1/Lindsey/data/Anesthesia/',date,'/',msd,'/',run,'.tif'],6);
mask=double(roipoly(greenframeall));
imwrite(mask,['Z:\Rachel\Rachel_fcOIS\OIS2\' date '\' date '-' mousenum '_mask.tif'],'tif');

end
