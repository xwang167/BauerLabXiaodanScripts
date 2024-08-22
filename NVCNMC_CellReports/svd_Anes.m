info.nVx = 128;
info.nVy = 128;
load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')
load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
% %  xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
% %  [xform_jrgeco1aCorr_GSR,gs,~] = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
% %   [hz,powerdata_jrgeco1aCorr_GSR] = QCcheck_CalcPDS(real(double(xform_jrgeco1aCorr_GSR))/0.01,25,mask);
% %
% %   xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128*128,size(xform_jrgeco1aCorr_GSR,3));
% xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,[]);
% xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
% xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
% [u s v] = svd(xform_jrgeco1aCorr); %where u*s*v'=gcamp6


for k = 1:4
    pcu = u(:,k);
    pcs = s(k,k);
    pcv = v(:,k);
    us =mtimes(pcu,pcs);
    A = mtimes(us,pcv.');
    pc{k} = reshape(A,info.nVx,info.nVy,size(A,2));
    xu=u(:,(k+1):end);
    xs=s((k+1):end,(k+1):end);
    xv=v(:,(k+1):end);
    xus=mtimes(xu,xs);
    X=mtimes(xus,xv.');
    pcx{k} = reshape(X,info.nVx,info.nVy,size(X,2));
end

% [hz,powerdata_jrgeco1aCorr_GSR_svd_4pc] = QCcheck_CalcPDS(real(double(pcx{4}))/0.01,25,mask);
%
%
refseeds=GetReferenceSeeds_xw;
saveDir = 'L:\RGECO\190710\';
visName = '190710-R5M2285-anes-fc1-SVD-DeltaFC';
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{5})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove PC5',false,xform_isbrain)

[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{6})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove PC6',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{7})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove PC7',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{8})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove PC8',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{9})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove PC9',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{10})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove PC10',false,xform_isbrain)




[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{1})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{2})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-2 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{3})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-3 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{4})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-4 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{5})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-5 GSR',false,xform_isbrain)


[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{6})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-6 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{7})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-7 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{8})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-8 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{9})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-9 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{10})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-10 GSR',false,xform_isbrain)
%
%
%
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128*128,size(xform_jrgeco1aCorr,3));
xform_jrgeco1aCorr(isnan(xform_jrgeco1aCorr)) = 0;
xform_jrgeco1aCorr(isinf(xform_jrgeco1aCorr)) = 0;
info.nVx = 128;
info.nVy = 128;
%
[u s v] = svd(xform_jrgeco1aCorr); %where u*s*v'=gcamp6

for k = 1:10
    pcu = u(:,k);
    pcs = s(k,k);
    pcv = v(:,k);
    us =mtimes(pcu,pcs);
    A = mtimes(us,pcv.');
    pc{k} = reshape(A,info.nVx,info.nVy,size(A,2));
    xu=u(:,(k+1):end);
    xs=s((k+1):end,(k+1):end);
    xv=v(:,(k+1):end);
    xus=mtimes(xu,xs);
    X=mtimes(xus,xv.');
    pcx{k} = reshape(X,info.nVx,info.nVy,size(X,2));
end

[hz,powerdata_jrgeco1aCorr_svd_pc4] = QCcheck_CalcPDS(real(double(pcx{4}))/0.01,25,mask);


refseeds=GetReferenceSeeds_xw;
saveDir = 'L:\RGECO\190710\';
visName = '190710-R5M2285-anes-fc1-SVD-DeltaFC';
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{10})/0.01,25,xform_isbrain,[0.7,3],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,visName,false,xform_isbrain)
xform_jrgeco1aCorr = reshape(xform_jrgeco1aCorr,128,128,[]);
for ii  = 1:5999
    subplot(1,2,1);imagesc(pcx{3}(:,:,ii),[-0.025 0.025]);
    subplot(1,2,2);imagesc(xform_jrgeco1aCorr(:,:,ii),[-0.1 0.1])
    pause
end


[Pxx_1,hz] = pwelch(v(:,1),[],[],[],25);
[Pxx_2,hz] = pwelch(v(:,2),[],[],[],25);
[Pxx_3,hz] = pwelch(v(:,3),[],[],[],25);
[Pxx_4,hz] = pwelch(v(:,5),[],[],[],25);
[Pxx_5,hz] = pwelch(v(:,5),[],[],[],25);
[Pxx_6,hz] = pwelch(v(:,6),[],[],[],25);
[Pxx_7,hz] = pwelch(v(:,7),[],[],[],25);
[Pxx_8,hz] = pwelch(v(:,8),[],[],[],25);
[Pxx_9,hz] = pwelch(v(:,9),[],[],[],25);
[Pxx_10,hz] = pwelch(v(:,10),[],[],[],25);










load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')


xform_jrgeco1aCorr = squeeze(xform_jrgeco1aCorr);
[xform_jrgeco1aCorr_GSR,gs,~] = mouse.process.gsr(xform_jrgeco1aCorr,xform_isbrain);
xform_jrgeco1aCorr_GSR = reshape(xform_jrgeco1aCorr_GSR,128*128,[]);
ibi = reshape(xform_isbrain,128*128,1);
gs_gsr =  mean(xform_jrgeco1aCorr_GSR(ibi,:),1);
clear xform_jrgeco1aCorr

[u_GSR s_GSR v_GSR] = svd(reshape(xform_jrgeco1aCorr_GSR,128*128,[]));
info.nVx = 128;
info.nVy = 128;
for k = 1:10
    pcu_GSR = u_GSR(:,k);
    pcs_GSR = s_GSR(k,k);
    pcv_GSR = v_GSR(:,k);
    us_GSR =mtimes(pcu_GSR,pcs_GSR);
    A_GSR = mtimes(us_GSR,pcv_GSR.');
    pc_GSR{k} = reshape(A_GSR,info.nVx,info.nVy,size(A_GSR,2));
    xu_GSR=u_GSR(:,(k+1):end);
    xs_GSR=s_GSR((k+1):end,(k+1):end);
    xv_GSR=v_GSR(:,(k+1):end);
    xus_GSR=mtimes(xu_GSR,xs_GSR);
    X_GSR=mtimes(xus_GSR,xv_GSR.');
    pcx_GSR{k} = reshape(X_GSR,info.nVx,info.nVy,size(X_GSR,2));
end

[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{1})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{2})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-2 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{3})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-3 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{4})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-4 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{5})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-5 ',false,xform_isbrain)


[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{6})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-6 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{7})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-7 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{8})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-8 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{9})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-9 ',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{10})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'GSR, Remove SV1-10 ',false,xform_isbrain)


[R_jrgeco1aCorr_Delta_nogsr,Rs_jrgeco1aCorr_Delta_nogsr] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr)/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_nogsr, Rs_jrgeco1aCorr_Delta_nogsr,'jrgeco1aCorr','m','Delta',saveDir,'No GSR',false,xform_isbrain)


[R_jrgeco1aCorr_Delta_gsr,Rs_jrgeco1aCorr_Delta_gsr] = QCcheck_CalcRRs(refseeds,double(xform_jrgeco1aCorr_GSR)/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_gsr, Rs_jrgeco1aCorr_Delta_gsr,'jrgeco1aCorr','m','Delta',saveDir,'With GSR',false,xform_isbrain)






load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_FADCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')
refseeds=GetReferenceSeeds_xw;
saveDir = 'L:\RGECO\190710\';
xform_FADCorr = reshape(xform_FADCorr,128*128,size(xform_FADCorr,3));
xform_FADCorr(isnan(xform_FADCorr)) = 0;
xform_FADCorr(isinf(xform_FADCorr)) = 0;
info.nVx = 128;
info.nVy = 128;
%
[u s v] = svd(xform_FADCorr); %where u*s*v'=gcamp6

for k = 1:10
    pcu = u(:,k);
    pcs = s(k,k);
    pcv = v(:,k);
    us =mtimes(pcu,pcs);
    A = mtimes(us,pcv.');
    pc{k} = reshape(A,info.nVx,info.nVy,size(A,2));
    xu=u(:,(k+1):end);
    xs=s((k+1):end,(k+1):end);
    xv=v(:,(k+1):end);
    xus=mtimes(xu,xs);
    X=mtimes(xus,xv.');
    pcx{k} = reshape(X,info.nVx,info.nVy,size(X,2));
end

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{1})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{2})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-2 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{3})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-3 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{4})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-4 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{5})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-5 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{6})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-6 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{7})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-7 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{8})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-8 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{9})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-9 removal',false,xform_isbrain)

[R_FADCorr_Delta,Rs_FADCorr_Delta] = QCcheck_CalcRRs(refseeds,double(pcx{10})/0.01,sessionInfo.framerate,xform_isbrain,[sessionInfo.bandtype_Delta{2},sessionInfo.bandtype_Delta{3}],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta, Rs_FADCorr_Delta,'FADCorr','g','Delta',saveDir,'SVD only SV1-10 removal',false,xform_isbrain)



[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{1})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'Remove SV1 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{2})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'Remove SV1-2 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{3})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'Remove SV1-3 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{4})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'Remove SV1-4 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{5})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'Remove SV1-5 GSR',false,xform_isbrain)


[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{6})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-6 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{7})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-7 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{8})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-8 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{9})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-9 GSR',false,xform_isbrain)
[R_jrgeco1aCorr_Delta_svd,Rs_jrgeco1aCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx{10})/0.01,25,xform_isbrain,[0.4,4],true);
QCcheck_fcVis(refseeds,R_jrgeco1aCorr_Delta_svd, Rs_jrgeco1aCorr_Delta_svd,'jrgeco1aCorr','m','Delta',saveDir,'Remove SV1-10 GSR',false,xform_isbrain)
%




xform_FADCorr = reshape(xform_FADCorr,128,128,[]);
[xform_FADCorr_GSR,gs,~] = mouse.process.gsr(xform_FADCorr,xform_isbrain);
dataBandpass =mouse.freq.filterData(double(squeeze(xform_FADCorr_GSR(:,:,1,:))),0.7,3,25);
xform_FADCorr_GSR = reshape(dataBandpass,128*128,[]);
clear xform_FADCorr

[u_GSR s_GSR v_GSR] = svd(reshape(xform_FADCorr_GSR,128*128,[]));
info.nVx = 128;
info.nVy = 128;
for k = 1:5
    pcu_GSR = u_GSR(:,k);
    pcs_GSR = s_GSR(k,k);
    pcv_GSR = v_GSR(:,k);
    us_GSR =mtimes(pcu_GSR,pcs_GSR);
    A_GSR = mtimes(us_GSR,pcv_GSR.');
    pc_GSR{k} = reshape(A_GSR,info.nVx,info.nVy,size(A_GSR,2));
    xu_GSR=u_GSR(:,(k+1):end);
    xs_GSR=s_GSR((k+1):end,(k+1):end);
    xv_GSR=v_GSR(:,(k+1):end);
    xus_GSR=mtimes(xu_GSR,xs_GSR);
    X_GSR=mtimes(xus_GSR,xv_GSR.');
    pcx_GSR{k} = reshape(X_GSR,info.nVx,info.nVy,size(X_GSR,2));
end

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{1})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{2})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-2 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{3})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-3 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{4})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-4 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{5})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-5 ',false,xform_isbrain)


[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{6})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-6 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{7})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-7 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{8})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-8 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{9})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-9 ',false,xform_isbrain)

[R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{10})/0.01,25,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,'GSR, Remove SV1-10 ',false,xform_isbrain)


mouseNames = {'160829-Ms1Ket','160908-Ms2Ket','160907-Ms4Ket','160907-Ms5Ket','160901-Ms6Ket'};
R_mice = zeros(128,128,16,5);
Rs_mice = zeros(16,16,5);

for ii  = 1:5
    saveDir = 'M:\Lindsey GCaMP data\OldProcessing\OldProcessing\';
    load(fullfile(saveDir,strcat(mouseNames{ii},'-fc10-Affine_GSR_BroadBand.mat')), 'gcamp6all')
    dataBandpass =mouse.freq.filterData(double(squeeze(gcamp6all(:,:,1,:))),0.7,3,16.81);
    [u_GSR, s_GSR, v_GSR] = svd(reshape(dataBandpass,128*128,[]));
    info.nVx = 128;
    info.nVy = 128;
    for k = 3
        pcu_GSR = u_GSR(:,k);
        pcs_GSR = s_GSR(k,k);
        pcv_GSR = v_GSR(:,k);
        us_GSR =mtimes(pcu_GSR,pcs_GSR);
        A_GSR = mtimes(us_GSR,pcv_GSR.');
        pc_GSR{k} = reshape(A_GSR,info.nVx,info.nVy,size(A_GSR,2));
        xu_GSR=u_GSR(:,(k+1):end);
        xs_GSR=s_GSR((k+1):end,(k+1):end);
        xv_GSR=v_GSR(:,(k+1):end);
        xus_GSR=mtimes(xu_GSR,xs_GSR);
        X_GSR=mtimes(xus_GSR,xv_GSR.');
        pcx_GSR{k} = reshape(X_GSR,info.nVx,info.nVy,size(X_GSR,2));
    end
    
    
    refseeds=GetReferenceSeeds_xw;
    xform_isbrain = ones(128,128);
    [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{3})/0.01,xform_isbrain,false);
    QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,strcat(mouseNames{ii},' ','GSR, Filter then Remove SV3 '),false,xform_isbrain)
    close all
    R_mice(:,:,:,ii) = atanh(R_gcampCorr_Delta_svd);
    Rs_mice(:,:,ii) = atanh(Rs_gcampCorr_Delta_svd);
end
R_mice = mean(R_mice,4);
Rs_mice = mean(Rs_mice,3);
QCcheck_fcVis(refseeds,R_mice, Rs_mice,'gcampCorr','g','Delta',saveDir,'Averaged across mice GSR, Filter then Remove SV3 ',true,xform_isbrain)
   

%% 

[hz,powerdata_gcampCorr_GSR] = QCcheck_CalcPDS(real(double(pcx_GSR{3}))/0.01,25,mask);
%% 

load('L:\GCaMP\190523\190523-G11M1-awake-fc1_processed.mat','xform_gcampCorr')
load('L:\GCaMP\190523\190523-G11M1-awake-LandmarksandMask.mat','xform_isbrain')
xform_gcampCorr_awake = xform_gcampCorr;
clear xform_gcampCorr
xform_gcampCorr_awake(isinf(xform_gcampCorr_awake)) = 0;
xform_gcampCorr_awake(isnan(xform_gcampCorr_awake)) = 0;
xform_gcampCorr_awake = mouse.process.gsr(xform_gcampCorr_awake,xform_isbrain);
xform_gcampCorr_awake = mouse.freq.filterData(double(xform_gcampCorr_awake),0.7,3,20);

load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
[hz_awake,powerdata_gcampCorr_awake] = QCcheck_CalcPDS(real(double(xform_gcampCorr_awake))/0.01,20,mask);
[hz_anes,powerdata_gcampCorr_anes] = QCcheck_CalcPDS(real(double(dataBandpass))/0.01,16.81,mask);
[hz_rmv,powerdata_gcampCorr_rmv] = QCcheck_CalcPDS(real(double(pcx_GSR{3}))/0.01,16.81,mask);

figure
semilogy(hz_awake,powerdata_gcampCorr_awake-interp1(hz_awake,powerdata_gcampCorr_awake,0.7)+0.01);
hold on
semilogy(hz_anes,powerdata_gcampCorr_anes-interp1(hz_anes,powerdata_gcampCorr_anes,0.7)+0.01);
hold on
semilogy(hz_rmv,powerdata_gcampCorr_rmv-interp1(hz_rmv,powerdata_gcampCorr_rmv,0.7)+0.01);
xlim([0.7 3])
legend('Awake','Anes','Removal of First 3 PC')
title('Power Spectral Density')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F%)^@/Hz')
mouseNames = {'160829-Ms1Ket','160908-Ms2Ket','160907-Ms4Ket','160907-Ms5Ket','160901-Ms6Ket'};
R_mice = zeros(128,128,16,5);
Rs_mice = zeros(16,16,5);

for ii  = 1
    saveDir = 'M:\Lindsey GCaMP data\OldProcessing\OldProcessing\';
    load(fullfile(saveDir,strcat(mouseNames{ii},'-fc10-Affine_GSR_BroadBand.mat')), 'gcamp6all')
    dataBandpass =mouse.freq.filterData(double(squeeze(gcamp6all(:,:,1,:))),0.7,3,16.81);
    [u_GSR, s_GSR, v_GSR] = svd(reshape(dataBandpass,128*128,[]));
    info.nVx = 128;
    info.nVy = 128;
    for k = 3
        pcu_GSR = u_GSR(:,k);
        pcs_GSR = s_GSR(k,k);
        pcv_GSR = v_GSR(:,k);
        us_GSR =mtimes(pcu_GSR,pcs_GSR);
        A_GSR = mtimes(us_GSR,pcv_GSR.');
        pc_GSR{k} = reshape(A_GSR,info.nVx,info.nVy,size(A_GSR,2));
        xu_GSR=u_GSR(:,(k+1):end);
        xs_GSR=s_GSR((k+1):end,(k+1):end);
        xv_GSR=v_GSR(:,(k+1):end);
        xus_GSR=mtimes(xu_GSR,xs_GSR);
        X_GSR=mtimes(xus_GSR,xv_GSR.');
        pcx_GSR{k} = reshape(X_GSR,info.nVx,info.nVy,size(X_GSR,2));
    end
    
    
    refseeds=GetReferenceSeeds_xw;
    xform_isbrain = ones(128,128);
    [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{3})/0.01,xform_isbrain,false);
    QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,strcat(mouseNames{ii},' ','GSR, Filter then Remove SV3 '),false,xform_isbrain)
    close all
    R_mice(:,:,:,ii) = atanh(R_gcampCorr_Delta_svd);
    Rs_mice(:,:,ii) = atanh(Rs_gcampCorr_Delta_svd);
end
R_mice = mean(R_mice,4);
Rs_mice = mean(Rs_mice,3);
QCcheck_fcVis(refseeds,R_mice, Rs_mice,'gcampCorr','g','Delta',saveDir,'Averaged across mice GSR, Filter then Remove SV3 ',true,xform_isbrain)
   

%% 

[hz,powerdata_gcampCorr_GSR] = QCcheck_CalcPDS(real(double(pcx_GSR{3}))/0.01,25,mask);
%% 
[Pxx_1,hz] = pwelch(v_GSR(:,1),[],[],[],25);
[Pxx_2,hz] = pwelch(v_GSR(:,2),[],[],[],25);
[Pxx_3,hz] = pwelch(v_GSR(:,3),[],[],[],25);
[Pxx_4,hz] = pwelch(v_GSR(:,4),[],[],[],25);
figure
loglog(hz,Pxx_1)
hold on
loglog(hz,Pxx_2)
hold on
loglog(hz,Pxx_3)
hold on
loglog(hz,Pxx_4)
legend('v1','v2','v3','v4')



info.nVx = 128;
info.nVy = 128;
load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_jrgeco1aCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')
saveDir = 'L:\RGECO\190710\';
[xform_jrgeco1aCorr_GSR,gs,~] = mouse.process.gsr(reshape(xform_jrgeco1aCorr,128,128,[]),xform_isbrain);
dataBandpass =mouse.freq.filterData(double(squeeze(xform_jrgeco1aCorr_GSR)),0.7,3,25);
[u_GSR s_GSR v_GSR] = svd(reshape(dataBandpass,128*128,[]));

for k = 6:10
    pcu_GSR = u_GSR(:,k);
    pcs_GSR = s_GSR(k,k);
    pcv_GSR = v_GSR(:,k);
    us_GSR =mtimes(pcu_GSR,pcs_GSR);
    A_GSR = mtimes(us_GSR,pcv_GSR.');
    pc_GSR{k} = reshape(A_GSR,info.nVx,info.nVy,size(A_GSR,2));
    xu_GSR=u_GSR(:,(k+1):end);
    xs_GSR=s_GSR((k+1):end,(k+1):end);
    xv_GSR=v_GSR(:,(k+1):end);
    xus_GSR=mtimes(xu_GSR,xs_GSR);
    X_GSR=mtimes(xus_GSR,xv_GSR.');
    pcx_GSR{k} = reshape(X_GSR,info.nVx,info.nVy,size(X_GSR,2));
end

 refseeds=GetReferenceSeeds_xw;

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{1})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV1 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{2})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV2 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{3})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV3 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{4})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV4 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{5})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV5 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{6})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV6 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{7})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV7 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{8})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV8 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{9})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV9 '),false,xform_isbrain)

 [R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{10})/0.01,xform_isbrain,false);
 QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'RGECOCorr','m','Delta',saveDir,strcat('R5M2285-anes',' ','GSR, Filter then Remove SV10 '),false,xform_isbrain)

 [Pxx_1,hz] = pwelch(v_GSR(:,1),[],[],[],25);
[Pxx_2,hz] = pwelch(v_GSR(:,2),[],[],[],25);
[Pxx_3,hz] = pwelch(v_GSR(:,3),[],[],[],25);
[Pxx_4,hz] = pwelch(v_GSR(:,4),[],[],[],25);
[Pxx_5,hz] = pwelch(v_GSR(:,4),[],[],[],25);
 [Pxx_6,hz] = pwelch(v_GSR(:,1),[],[],[],25);
[Pxx_7,hz] = pwelch(v_GSR(:,2),[],[],[],25);
[Pxx_8,hz] = pwelch(v_GSR(:,3),[],[],[],25);
[Pxx_9,hz] = pwelch(v_GSR(:,4),[],[],[],25);
[Pxx_10,hz] = pwelch(v_GSR(:,4),[],[],[],25);
figure
loglog(hz,Pxx_1)
hold on
loglog(hz,Pxx_2)
hold on
loglog(hz,Pxx_3)
hold on
loglog(hz,Pxx_4)
hold on
loglog(hz,Pxx_5)
hold on
loglog(hz,Pxx_6)
hold on
loglog(hz,Pxx_7)
hold on
loglog(hz,Pxx_8)
hold on
loglog(hz,Pxx_9)
hold on
loglog(hz,Pxx_10)
legend('v1','v2','v3','v4','v5','v6','v7','v8','v9','v10')
 


load('L:\RGECO\190627\190627-R5M2285-fc1_processed.mat','xform_FADCorr')
load('L:\RGECO\Kenny\190627\190627-R5M2285-LandmarksandMask.mat','xform_isbrain')
xform_FADCorr_awake = xform_FADCorr;
clear xform_FADCorr
xform_FADCorr_awake(isinf(xform_FADCorr_awake)) = 0;
xform_FADCorr_awake(isnan(xform_FADCorr_awake)) = 0;
xform_FADCorr_awake = mouse.process.gsr(xform_FADCorr_awake,xform_isbrain);
xform_FADCorr_awake = mouse.freq.filterData(double(xform_FADCorr_awake),0.7,3,20);


load('L:\RGECO\190710\190710-R5M2285-anes-fc1_processed.mat', 'xform_FADCorr')
load('L:\RGECO\Kenny\190710\190710-R5M2285-anes-fc1-datafluor.mat', 'xform_isbrain')

    saveDir = 'L:\RGECO\190710\';
xform_FADCorr(isinf(xform_FADCorr)) = 0;
xform_FADCorr(isnan(xform_FADCorr)) = 0;
    dataBandpass =mouse.freq.filterData(double(xform_FADCorr),0.7,3,25);
    [u_GSR, s_GSR, v_GSR] = svd(reshape(dataBandpass,128*128,[]));
    info.nVx = 128;
    info.nVy = 128;
    for k = 3
        pcu_GSR = u_GSR(:,k);
        pcs_GSR = s_GSR(k,k);
        pcv_GSR = v_GSR(:,k);
        us_GSR =mtimes(pcu_GSR,pcs_GSR);
        A_GSR = mtimes(us_GSR,pcv_GSR.');
        pc_GSR{k} = reshape(A_GSR,info.nVx,info.nVy,size(A_GSR,2));
        xu_GSR=u_GSR(:,(k+1):end);
        xs_GSR=s_GSR((k+1):end,(k+1):end);
        xv_GSR=v_GSR(:,(k+1):end);
        xus_GSR=mtimes(xu_GSR,xs_GSR);
        X_GSR=mtimes(xus_GSR,xv_GSR.');
        pcx_GSR{k} = reshape(X_GSR,info.nVx,info.nVy,size(X_GSR,2));
    end
    refseeds=GetReferenceSeeds_xw;
    xform_isbrain = ones(128,128);
    [R_FADCorr_Delta_svd,Rs_FADCorr_Delta_svd] = QCcheck_CalcRRs_NoFilter(refseeds,double(pcx_GSR{3})/0.01,xform_isbrain,false);
    QCcheck_fcVis(refseeds,R_FADCorr_Delta_svd, Rs_FADCorr_Delta_svd,'FADCorr','g','Delta',saveDir,strcat('R5M2285-anes GSR, Filter then Remove SV1-3 '),false,xform_isbrain)
    close all


load('D:\OIS_Process\noVasculatureMask.mat')
mask = leftMask+rightMask;
[hz_awake,powerdata_FADCorr_awake] = QCcheck_CalcPDS(real(double(xform_FADCorr_awake))/0.01,20,mask);
[hz_anes,powerdata_FADCorr_anes] = QCcheck_CalcPDS(real(double(dataBandpass))/0.01,16.81,mask);
[hz_rmv,powerdata_FADCorr_rmv] = QCcheck_CalcPDS(real(double(pcx_GSR{3}))/0.01,16.81,mask);

figure
semilogy(hz_awake,powerdata_FADCorr_awake-interp1(hz_awake,powerdata_FADCorr_awake,0.7)+0.01);
hold on
semilogy(hz_anes,powerdata_FADCorr_anes-interp1(hz_anes,powerdata_FADCorr_anes,0.7)+0.01);
hold on
semilogy(hz_rmv,powerdata_FADCorr_rmv-interp1(hz_rmv,powerdata_FADCorr_rmv,0.7)+0.01);
xlim([0.7 3])
legend('Awake','Anes','Removal of First 3 PC')
title('Corrected FAD Power Spectral Density')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F%)^@/Hz')



