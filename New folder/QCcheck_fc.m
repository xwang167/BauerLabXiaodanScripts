function QCcheck_fc(oxy,deoxy,total,fluorCorr,fluorName,xform_isbrain,framerate,saveDir,visName,isGSR)
info.nVy = 128;
info.nVx =128;
T1 =  length(oxy);
hz2=linspace(0,framerate,T1);

refseeds=GetReferenceSeeds;
refseeds = refseeds(1:14,:);
mm=10;
mpp=mm/info.nVx;
seedradmm=0.25;
seedradpix=seedradmm/mpp;

for n=1:2:size(refseeds,1)-1;
    if xform_isbrain(refseeds(n,2),refseeds(n,1))==1 && xform_isbrain(refseeds(n+1,2),refseeds(n+1,1))==1;  %%remove 129- on y coordinate for newer data sets
        SeedsUsed(n,:)=refseeds(n,:);
        SeedsUsed(n+1,:)=refseeds(n+1,:);
    else
        SeedsUsed(n,:)=[NaN, NaN];
        SeedsUsed(n+1,:)=[NaN, NaN];
    end
end
P=burnseeds(SeedsUsed,seedradpix,xform_isbrain);          % make a mask of seed locations
length_seeds=size(SeedsUsed,1);                           %reorder so bilateral connectivity values are on the off-diagonal
map=[(1:2:length_seeds-1) (2:2:length_seeds)];


sessionInfo.bandtype_ISA = {"ISA",0.009,0.08};
sessionInfo.bandtype_Delta = {"Delta",0.4,4};

traceSpecies = {'oxy',[fluorName,'Corr'],'deoxy','total'};
traceColor = {'r', 'g','b','k'};
bandTypes = {'ISA','Delta'};

ibi=find(xform_isbrain==1);


subplot_Index = 1;


for ii = 1:length(traceSpecies)
    data2 = genvarname(traceSpecies{ii});
    if ii ==2
        eval([data2 '= fluorCorr;'])
    end
    eval([data2 '(isnan(' data2 ')) = 0;']);
    if ii<3
        
        for jj = 1:length(bandTypes)
            
            
            dataBandpass = genvarname([traceSpecies{ii} bandTypes{jj}]);
            disp(['filtering ', traceSpecies{ii}, ' with ', bandTypes{jj}])
         eval([dataBandpass '=mouse.freq.filterData(double(',data2,'),sessionInfo.bandtype_',bandTypes{jj},'{2},sessionInfo.bandtype_',bandTypes{jj},'{3},framerate);']);
          
%             eval([dataBandpass '=highpass(double(',data2,'),sessionInfo.bandtype_',bandTypes{jj},'{2},framerate);']);
%            eval([dataBandpass '=lowpass(double(',dataBandpass,'),sessionInfo.bandtype_',bandTypes{jj},'{3},framerate);']);
             eval([dataBandpass,'(isnan(',dataBandpass,'))= 0;']);
            
            if isGSR
            disp('gsr');
            eval([dataBandpass, '= mouse.process.gsr(',dataBandpass,',xform_isbrain);']);
            end
            eval([dataBandpass, '=', dataBandpass,'.*xform_isbrain;']);
            eval([dataBandpass,'(isnan(',dataBandpass,')) = 0;']);
            eval([dataBandpass,'=reshape(',dataBandpass,',info.nVy*info.nVx,[]);']);
            
            disp('Calculating R Rs')
            eval(['strace=P2strace(P,',dataBandpass,', SeedsUsed);']);              % strace is each seeds trace resulting from averaging the pixels within a seed region
            fcMap = genvarname(['R_',traceSpecies{ii},'_',bandTypes{jj}]);
            eval([fcMap ' = strace2R(strace,' dataBandpass ', info.nVx, info.nVy); ']);                % R is the functional connectivity maps: normalize rows in time, dot product of those rows with strce
            eval(['R_AP = makeRs(' dataBandpass ',strace); ']);                     % R_AP is a matrix of the seed-to-seed fc values
            clear dataBandpass
            idx=find(isnan(SeedsUsed(:,1)));
            eval([fcMap,'(:,:,idx)=0;']);
            R_AP(idx, idx)=0;
            fcMatrix = genvarname(['Rs_' traceSpecies{ii} '_',bandTypes{jj}]);
            eval([fcMatrix '= single(R_AP(map, map)); ']);
            clear strace R_AP
            
            
            disp('Calculating power map');
            powerMap = genvarname([traceSpecies{ii} '_' bandTypes{jj} '_powerMap']);
            eval([powerMap '= zeros(info.nVy,info.nVx);'])
            %             for kk = 1:info.nVy
            %                 for ll=1:info.nVx
            %                     eval(['fdata_temp = abs(fft(' data2 '(kk,ll,:)));']);
            %                     fdata_temp = fdata_temp./mean(fdata_temp);
            %                     %%% range for Delta and ISA
            %                     eval([powerMap '(kk,ll) = sum(fdata_temp(startLoc_' bandTypes{jj} ': endLoc_' ,bandTypes{jj} '))/(endLoc_' bandTypes{jj} '-startLoc_' bandTypes{jj} ');']);
            %                 end
            %             end
            
            eval(['data = reshape(' data2 ',info.nVy*info.nVy,[]);'])
            data = data';
            [Pxx,hz] = pwelch(data,[],[],[],framerate);
            
            [~,startLoc_ISA]=min(abs(hz-sessionInfo.bandtype_ISA {2}));
            [~,startLoc_Delta]=min(abs(hz-sessionInfo.bandtype_Delta {2}));
            [~,endLoc_ISA]=min(abs(hz-sessionInfo.bandtype_ISA {3}));
            [~,endLoc_Delta]=min(abs(hz-sessionInfo.bandtype_Delta {3}));
            
            Pxx = Pxx';
            Pxx = reshape(Pxx,info.nVy,info.nVx,[]);
            
            for kk = 1:info.nVy
                for ll=1:info.nVx
                    eval([powerMap '(kk,ll) = (hz(2)-hz(1))*sum(Pxx(kk,ll,(startLoc_' bandTypes{jj} ': endLoc_' ,bandTypes{jj} ...
                        ')/(sessionInfo.bandtype_' bandTypes{jj} '(3)-sessionInfo.bandtype_' bandTypes{jj} '(2)));']);
                end
            end
            
            load('D:\OIS_Process\noVasculatureMask.mat')
            figure(1)
            subplot(2,2,subplot_Index)
            mask = xform_isbrain.*(double(leftMask)+double(rightMask));
            mask(mask==0)=NaN;
            eval([powerMap '=' powerMap '.*mask;']);
            
            colormap jet
            eval(['imagesc(log10(abs(' powerMap ')))'])
            cb = colorbar();
            cb.Ruler.MinorTick = 'on';
            if ii == 1
                ylabel(cb,'log10(M^2)','FontSize',12)
            elseif ii==2
                ylabel(cb,'log10((\DeltaF/F)^2)','FontSize',12)
            end
            axis image off
            title([ traceSpecies{ii} bandTypes{jj} ])
            subplot_Index = subplot_Index+1;
            if exist(strcat(fullfile(saveDir,visName),".mat"))
                eval(['save(strcat(fullfile(saveDir,visName),".mat"),' char(39) fcMatrix char(39) ',' char(39) fcMap char(39) ','  char(39) powerMap char(39) ',' char(39) '-append' char(39) ');'])
            else
                eval(['save(strcat(fullfile(saveDir,visName),".mat"),' char(39) fcMatrix char(39) ',' char(39) fcMap char(39) ','  char(39) powerMap char(39)  ');'])
                
            end
        end
        
        save(strcat(fullfile(saveDir,visName),".mat"),'hz','T1','-append')
        eval([data2, '=', data2,'.*xform_isbrain;']);
        eval([data2,'(isnan(',data2,')) = 0;']);
        eval([data2,'(isinf(',data2,')) = 0;']);
        eval(['data3= mouse.process.gsr(',data2,',xform_isbrain);']);
        data3=reshape(data3,info.nVy*info.nVx,[]);
        strace=P2strace(P,data3, SeedsUsed);    % strace is each seeds trace resulting from averaging the pixels within a seed region
        fcMap = genvarname(['R_',traceSpecies{ii}]);
        eval([fcMap ' = strace2R(strace, data3 , info.nVx, info.nVy); ']);                % R is the functional connectivity maps: normalize rows in time, dot product of those rows with strce
        R_AP = makeRs(data3 ,strace);                    % R_AP is a matrix of the seed-to-seed fc values
        idx=find(isnan(SeedsUsed(:,1)));
        eval([fcMap,'(:,:,idx)=0;']);
        R_AP(idx, idx)=0;
        fcMatrix = genvarname(['Rs_' traceSpecies{ii}]);
        eval([fcMatrix '= single(R_AP(map, map)); ']);
        clear strace R_AP
        
        
    end
    
    disp('Calculating power curve')
    eval([data2 '= single(reshape(' data2 ',info.nVy*info.nVx,[]));']);
    eval(['mdata = squeeze(mean(' data2 '(ibi,:),1));']);
    
    powerCurve = genvarname(['powerdata_' traceSpecies{ii}]);
   
    
    [mPxx,hz] = pwelch(mdata',[],[],[],framerate);
    mPxx = mPxx';
    eval([powerCurve '= mPxx;'])
    
    figure(2)
    subplot('position', [0.12 0.12 0.6 0.7])
    if ii==2
        yyaxis left
        set(gca, 'YScale', 'log')
        ylabel('G6((\DeltaF/F)^2/Hz)')
        eval(['ylim([-inf 1.1*max(' powerCurve ')])'])
    else
        yyaxis right
        ylabel('Hb(M^2/Hz)')
    end
    hz = hz';
    
     eval(['p' num2str(ii) '= loglog(hz,' powerCurve ',traceColor{ii});']);
    eval(['save(strcat(fullfile(saveDir,visName),".mat"),' char(39) powerCurve char(39) ',' char(39) '-append' char(39)  ',' char(39) 'hz' char(39) ');'])
    hold on
    

      figure(3)
         fftCurve = genvarname(['fdata_' traceSpecies{ii}]);
                fdata = abs(fft(mdata));
         eval([fftCurve '= fdata./mean(fdata);']);
    subplot('position', [0.12 0.12 0.6 0.7])
    if ii==2
        hold on
        yyaxis left
        set(gca, 'YScale', 'log')
        ylabel('G6(\DeltaF/F)')
        eval(['ylim([-inf 1.1*max(' fftCurve ')])'])
    else
        yyaxis right
        ylabel('Hb(M)')
    end
   
    

    eval(['p' num2str(ii) '= loglog(hz2(1:ceil(T1/2)),' fftCurve '(1:ceil(T1/2)),traceColor{ii});']);
    xlim([10^-2,10])
 eval(['save(strcat(fullfile(saveDir,visName),".mat"),' char(39) fftCurve char(39) ',' char(39) '-append' char(39)  ',' char(39) 'hz2' char(39) ');'])
    hold on

    
end

figure(1);
saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerMap.jpg'))));

figure(2)
legend(traceSpecies{2},'HbO_2','HbR','Total')
xlabel('Frequency (Hz)')
title(strcat(visName,'  Power Density Spectrum '),'fontsize',14);
ytickformat('%.1f');
saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCpowerCurve.jpg'))));

figure(3)
legend(traceSpecies{2},'HbO_2','HbR','Total','Location','southwest')
xlabel('Frequency (Hz)')

title(strcat(visName,'  Normalized fft '),'fontsize',14);
ytickformat('%.1f');
saveas(gcf,(fullfile(saveDir,strcat(visName,'_FCfftCurve.jpg'))));
    
if isGSR
    visName = strcat(visName,'_GSR');
else
    
    visName = strcat(visName,'_NoGSR');
end

if strcmp(fluorName, 'gcamp6f')
    QCcheck_fcVis_v1(refseeds,R_oxy_ISA, Rs_oxy_ISA,R_gcamp6fCorr_ISA,Rs_gcamp6fCorr_ISA, fluorName,'ISA',saveDir,visName,false)
    QCcheck_fcVis_v1(refseeds,R_oxy_Delta, Rs_oxy_Delta,R_gcamp6fCorr_Delta, Rs_gcamp6fCorr_Delta, fluorName,'Delta',saveDir,visName,false)
    QCcheck_fcVis_v1(refseeds,R_oxy, Rs_oxy,R_gcamp6fCorr, Rs_gcamp6fCorr, fluorName,'Whole',saveDir,visName,false)
    
elseif strcmp(fluorName, 'jrgeco1a')
    QCcheck_fcVis_v1(refseeds,R_oxy_ISA, Rs_oxy_ISA,R_jrgeco1aCorr_ISA,Rs_jrgeco1aCorr_ISA, fluorName,'ISA',saveDir,visName,false)
    QCcheck_fcVis_v1(refseeds,R_oxy_Delta, Rs_oxy_Delta,R_jrgeco1aCorr_Delta, Rs_jrgeco1aCorr_Delta, fluorName,'Delta',saveDir,visName,false)
end



