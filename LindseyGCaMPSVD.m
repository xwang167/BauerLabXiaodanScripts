 
load('M:\Lindsey GCaMP data\OldProcessing\OldProcessing\160829-Ms1Ket-fc10-Affine_GSR_BroadBand.mat', 'gcamp6all')


[u_GSR, s_GSR, v_GSR] = svd(reshape(gcamp6all(:,:,1,:),128*128,[]));
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

[R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{1})/0.01,16.81,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,'GSR, Remove SV1 ',false,xform_isbrain)

[R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{2})/0.01,16.81,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,'GSR, Remove SV1-2 ',false,xform_isbrain)

[R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{3})/0.01,16.81,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,'GSR, Remove SV1-3 ',false,xform_isbrain)

[R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{4})/0.01,16.81,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,'GSR, Remove SV1-4 ',false,xform_isbrain)

[R_gcampCorr_Delta_svd,Rs_gcampCorr_Delta_svd] = QCcheck_CalcRRs(refseeds,double(pcx_GSR{5})/0.01,16.81,xform_isbrain,[0.4,4],false);
QCcheck_fcVis(refseeds,R_gcampCorr_Delta_svd, Rs_gcampCorr_Delta_svd,'gcampCorr','g','Delta',saveDir,'GSR, Remove SV1-5 ',false,xform_isbrain)

