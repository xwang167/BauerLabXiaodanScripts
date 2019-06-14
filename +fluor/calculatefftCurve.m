function [fftCurve,hz] = calculatefftCurve(data2,xform_isbrain,framerate,nVy,nVx)
    ibi=find(xform_isbrain==1);
    disp('Calculating fft curve')
    data2 = single(reshape(data2 ,nVy*nVx,[]));
    mdata = squeeze(mean(data2(ibi,:),1));
    clear data2
%     fdata = abs(fft(mdata));
%     fftCurve = fdata./mean(fdata);
   [mPxx,hz] = pwelch(mdata',[],[],[],framerate);
    mPxx = mPxx';
    fftCurve = mPxx;
