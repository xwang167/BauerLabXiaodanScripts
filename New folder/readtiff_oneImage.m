function data=readtiff_oneImage(filename,frameIndex)
info = imfinfo(filename);

fid=fopen(filename);
fseek(fid,info(1).Offset+(info(1,1).StripOffsets(1)-info(1,1).Offset+2*info(1).Height*info(1).Width)*(frameIndex-1)+info(1,1).StripOffsets(1)-info(1,1).Offset,'bof'); % the 8 is info(1).Offset
tempdata=fread(fid,info(1).Height*info(1).Width,'uint16');   
data = rot90((reshape(tempdata,info(1).Height,info(1).Width)),-1);
fclose(fid);

