function [hz, powerdata] = QCcheck_CalcPDS_raw(data,framerate,isbrain,I)
nVy = size(data,1);
nVx = size(data,2);
load('D:\OIS_Process\noVasculatureMask.mat')
if I.bregma<1
I.bregma = 128*I.bregma;
I.tent = 128*I.tent;
I.OF = 128*I.OF;
end
leftMask = InvAffine(I,leftMask);
rightMask = InvAffine(I,rightMask);
mask = logical(isbrain.*(double(leftMask)+double(rightMask)));
ibi = find(mask ==1);
data(isnan(data)) = 0;
data(isinf(data)) = 0;
data = transpose(reshape(data,nVx*nVy,[]));
[Pxx,hz] = pwelch(data,[],[],[],framerate);
Pxx = Pxx';

powerdata = mean(Pxx(ibi,:),1);