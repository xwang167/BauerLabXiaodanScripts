function [input_gsr, gsR, gsL, datahb2]=gsr_stroke2_xw(input,isbrain,meth,isbrain2, signal1)

% Performs multiple types of signal regression depending on input.
% datahb are the oxy and deoxy hemoglobin data in each pixel over time,
% Meth is a string denoting the type of regression to perform:
% Whole: whole brain ("global") signal regression
% Each: regresses the left hemisphere signal from the left hemisphere and the right hemisphere signal from the right hemisphere.
% Both: regresses the right and left hemisphere signals from the whole brain simultaneously.
% Mask: regresses two signals, each defined by a region mask, isbrain and isbrain2.
% isbrain is a binary mask for all pixels labeld as brain for "Whole", "Each",..
% or "Both" regression types OR is a mask defining 1 of 2 regions for
% "Mask" regression
% isbrain2 is a binary mask defining the second region for "Mask" regression


% (c) 2009 Washington University in St. Louis
% All Right Reserved
%
% Licensed under the Apache License, Version 2.0 (the "License");
% You may not use this file except in compliance with the License.
% A copy of the License is available is with the distribution and can also
% be found at:
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE, OR THAT THE USE OF THE SOFTWARD WILL NOT INFRINGE ANY PATENT
% COPYRIGHT, TRADEMARK, OR OTHER PROPRIETARY RIGHTS ARE DISCLAIMED. IN NO
% EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
% OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

if ~exist('isbrain2'); isbrain2=''; end
if ~exist('signal1'); signal1=''; end


isbrain1=isbrain;

[nVy, nVx, T]=size(input);

switch meth
    
    case'Whole'
        
        datahb=reshape(datahb,nVx*nVy,hb,T);
        gs=squeeze(mean(datahb(isbrain==1,:,:),1));
        [datahb2, Rgs]=regcorr(datahb,gs);
        datahb2=reshape(datahb2,nVy, nVx, hb, T);
        Oxy_gsr=squeeze(datahb2(:,:,1,:));
        input_gsr=squeeze(datahb2(:,:,2,:));
        gsR=gs;
        gsL=gs;
        
    case 'Each' %regresses the left hemisphere signal from the left hemisphere and the right hemisphere signal from the right hemisphere.
        
        isbrainL=zeros(nVy,round(nVx/2));
        isbrainL(:,1:round(nVx/2))=isbrain(:,1:round(nVx/2));
        isbrainR=zeros(nVy,round(nVx/2));
        isbrainR(:,1:round(nVx/2))=isbrain(:,round(nVx/2)+1:nVx);
        
        inputR=input(:,round(nVx/2)+1:nVx,:);
        inputR=reshape(inputR,[],1,T);
        gsR=squeeze(mean(inputR(isbrainR==1,1,:),1));
        [inputR2]=regcorr(inputR,gsR);
        inputR2=reshape(inputR2,nVy,[],T);
        
        inputL=input(:,1:round(nVx/2),:);
        inputL=reshape(inputL,[],1,T);
        gsL=squeeze(mean(inputL(isbrainL==1,1,:),1));
        [inputL2]=regcorr(inputL,gsL);
        inputL2=reshape(inputL2,nVy,round(nVx/2),T);
     
        
        input_gsr(:,1:round(nVx/2),:)=squeeze(inputL2(:,:,:));
        input_gsr(:,round(nVx/2)+1:nVx,:)=squeeze(inputR2(:,:,:));
        
    case 'Both' %regresses the left hemisphere signal from both hemispheres simultaneously, same for right.
        
        isbrainL=zeros(nVy,round(nVx/2));
        isbrainL(:,1:round(nVx/2))=isbrain(:,1:round(nVx/2));
        isbrainR=zeros(nVy,round(nVx/2));
        isbrainR(:,1:round(nVx/2))=isbrain(:,round(nVx/2)+1:end);
        
        
        datahbR=datahb(:,round(nVx/2)+1:nVx,:,:);
        datahbR=reshape(datahbR,[],hb,T);
        gsR=squeeze(mean(datahbR(isbrainR==1,:,:),1));
        
        datahbL=datahb(:,1:round(nVx/2),:,:);
        datahbL=reshape(datahbL,[],hb,T);
        gsL=squeeze(mean(datahbL(isbrainL==1,:,:),1));
        
        [datahb2]=regcorr2(datahb,gsR, gsL);
        datahb2=reshape(datahb2,nVy,nVx,hb,T);
        
        Oxy_gsr=squeeze(datahb2(:,:,1,:));
        input_gsr=squeeze(datahb2(:,:,2,:));
        
    case 'Mask' %regresses 2 signals definied by 2 masks (isbrain1 and isbrain2) and regresses them simultaneously
        
        datahb=reshape(datahb,[],hb,T);
        gsL=squeeze(mean(datahb(isbrain2==1,:,:),1));
        gsR=squeeze(mean(datahb(isbrain1==1,:,:),1));
        
        [datahb2]=regcorr2(datahb,gsR, gsL);
        datahb2=reshape(datahb2,nVy,nVx,hb,T);
        
        Oxy_gsr=squeeze(datahb2(:,:,1,:));
        input_gsr=squeeze(datahb2(:,:,2,:));
        
    case 'Mask2'
        
        datahb=reshape(datahb,[],hb,T);
        gsR=squeeze(mean(datahb(isbrain2==1,:,:),1));
        gsL=gsR;
        [datahb2]=regcorr(datahb,gsR);
        datahb2=reshape(datahb2,nVy,nVx,hb,T);
        
        Oxy_gsr=squeeze(datahb2(:,:,1,:));
        input_gsr=squeeze(datahb2(:,:,2,:));
        
    case 'None'
        
        gsR=0;
        gsL=0;
        
        Oxy_gsr=squeeze(datahb(:,:,1,:));
        input_gsr=squeeze(datahb(:,:,2,:));
        
        
    case 'GSRSignal'
        
        datahb=reshape(datahb,[],hb,T);
        %gsR=squeeze(mean(datahb(isbrain1==1,:,:),1));
        gs1=signal1;
        
        [datahb2]=regcorr(datahb,gs1);
        datahb2=reshape(datahb2,nVy,nVx,hb,T);
        
        Oxy_gsr=squeeze(datahb2(:,:,1,:));
        input_gsr=squeeze(datahb2(:,:,2,:));
        
        
        
    case 'Partial'
        
        datahb=reshape(datahb,[],hb,T);
        gsR=squeeze(mean(datahb(isbrain1==1,:,:),1));  %GSR
        [datahb2]=regcorr(datahb, gsR);
        
        gsL=squeeze(mean(datahb2(isbrain2==1,:,:),1));    %Residual signal from masked area after GSR
        
        [datahb3]=regcorr2(datahb,gsR, gsL); %Now regress both signals from original (non regressed datahb)
        datahb3=reshape(datahb3,nVy,nVx,hb,T);
        
        Oxy_gsr=squeeze(datahb3(:,:,1,:));
        input_gsr=squeeze(datahb3(:,:,2,:));
        
end

end