function [datahb,op,E] = procOISData_xw(filename, sessionType, sessionInfo,muspFcn)
pkgDir = what('bauerParams');
muspFcn = @(x,y) (40*(x/500).^-1.16)'*y;
  raw = readtiff(filename);
        
         [op, E] = getHbOpticalProperties_xw(muspFcn,fullfile(pkgDir.path,'ledSpectra',systemInfo.LEDFiles(sessionInfo.hbSpecies)));
        
       BaselineFunction  = @(x) mean(x,numel(size(x)));

                baselineValues = BaselineFunction(raw);
          
                datahb = mouse.process.procOIS(raw(:,:,sessionInfo.hbSpecies,:),baselineValues(:,:,sessionInfo.hbSpecies),op.dpf,E);%% not package
                datahb = process.smoothImage(datahb,systemInfo.gbox,systemInfo.gsigma); % spatially smooth data
    
end
%% readtiff()
function [data]=readtiff(filename)

info = imfinfo(filename);
numI = numel(info);
data=zeros(info(1).Height,info(1).Width,numI,'uint16');
fid=fopen(filename);
fseek(fid,info(1).Offset,'bof');

for k = 1:numI
    fseek(fid,[info(1,1).StripOffsets(1)-info(1).Offset],'cof');
    tempdata=fread(fid,info(1).Height*info(1).Width,'uint16');
    data(:,:,k) = rot90((reshape(tempdata,info(1).Height,info(1).Width)),-1);
end

fclose(fid);

end
