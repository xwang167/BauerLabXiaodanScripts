function CreateGSRfileFromContrasts2(gcamp_filename_root,runs, scoringNdx, scoringTime)
%loads the gitHub5 processed data (all_contrasts2) and saves
%124x128 x 10sec x epoch that is aligned to scoring
running_time=0;
cumalitivetime=0;

for n=1:length(runs)
    
    display(['loading ' gcamp_filename_root '-fc' num2str(runs(n)) '-Affine_GSR_BroadBand'])
    load([gcamp_filename_root '-fc' num2str(runs(n)) '-Affine_GSR_BroadBand'])
    gcamp6corr=squeeze(all_contrasts2(:,:,1,:));
    xform_mask=isbrain2;
    
    thisFileFrameCount=size(gcamp6corr,3); %find out how many frames are in the processed file
    
    thisFiletotalframes=20.75+thisFileFrameCount;
    
    thisFiletotaltime=thisFiletotalframes/16.8067;
    
    %create an index that tells you exactly what index of gcamp6corr matches to
    %the actual recording time.
    t_gcamp6corr=[];
    for i=1: thisFileFrameCount
        t_gcamp6corr(i)=i*(1/16.8067)+cumalitivetime-(1/16.8067)+(10/16.8067);
    end
    
    
    
    %find all 10 second epochs by labchart scoring that is within this file
    t_index_thisfile=find(cell2mat(scoringTime)>cumalitivetime & cell2mat(scoringTime)<cumalitivetime+thisFiletotaltime);
    times_thisfile=cell2mat(scoringTime(t_index_thisfile(2:end-1)));
    
    data=[];
    scoringindex_file=[];
    %then go through and find the gcamp6corr indexes that match times_thisfile
    for i=1:length(times_thisfile)
        [m,index_gcampfile]=min(abs(t_gcamp6corr-times_thisfile(i)));
        
        %then go +/- 5 seconds around this index_gcampfile
        Tensecframes=[index_gcampfile-83:index_gcampfile+84];
        data(:,:,:,i)=squeeze(gcamp6corr(:,:,Tensecframes));
        
        %get the scoring
        scoringindex_file(i)=scoringNdx(find(times_thisfile(i)==cell2mat(scoringTime)));
        
    end
    
    
    
    cumalitivetime=cumalitivetime+thisFiletotaltime
     save([gcamp_filename_root '-fc' num2str(runs(n)) '-GSR_G5'], 'scoringindex_file', 'xform_mask', 'data', '-v7.3');
     clear data scoringindex_file all_contrasts2 gcamp6corr thisFileFrameCount thisFiletotalframes t_gcamp6corr
    
end


%%
% %first create the timestamps for the GitHub5 processed files
% timefile=16129.75/16.81; %actual length of file in seconds
% 
% filestart=[]; filestart(1)=0;
% fileend=[]; fileend(1)=timefile;
% for i =2:11
%    filestart(i)=filestart(i-1)+timefile + (1/16.8);
%    fileend(i)=filestart(i)+timefile -1/16.8;
%     
% end
% filestart(12)=fileend(11)+1/16.81;
% fileend(12)=filestart(12)+(16051/4)/16.81;
% 
% processdfilestart=filestart-(1 - (10/16.81));
% % processdfileend=processdfilestart+950;
% 
%     
% processdfileend=[];
% running_frame_count=0;
% epoch_count=2;
% runningTime=0;
% for n=1:length(runs)
%     %first count how many seconds have occurred prior to this file
%    
%     
%     display(['loading ' gcamp_filename_root '-fc' num2str(runs(n)) '-fftGitHub5'])
%     load([gcamp_filename_root '-fc' num2str(runs(n)) '-Affine_GSR_BroadBand'])
%     gcamp6corr=squeeze(all_contrasts2(:,:,1,:));
%     xform_mask=isbrain2;
%     
%     thisFileFrameCount=size(gcamp6corr,3);
%     running_frame_count=running_frame_count+thisFileFrameCount;
% 
%     processdfileend(n)=processdfilestart(n)+thisFileFrameCount/16.81;
%    
%  
% x=[0:1/16.81:((thisFileFrameCount+20.75)/16.81)-1/16.81];
%     
% epoch=[]; %normally this would be the epochs
% for k=1:97
%    epoch(k,:)=[((k-1)*168)+1; k*168];
%    
% end
% 
% %except they started 10 frames late
% epochlate=epoch-10;
% 
% 
% 
%     
%     if n==1
%         runningTime=0;
%     end
%     
%     
%     
%     
%        num10secEpochs=floor((size(gcamp6corr,3)/16.81)/10);
%     
%     scoringindex_file=[];
%     for z=1:num10secEpochs
%         
%         if z==1
%             current_epoch_time=processdfilestart(n)+5;
%         else
%             current_epoch_time=current_epoch_time+10;
%         end
%     
%        
%               %find the closest epoch in scoringTime to the current_epochs_time
%        [c index] = min(abs(cell2mat(scoringTime)-current_epoch_time));
%        scoringindex_file=[scoringindex_file scoringNdx(index)];       
%        
%     end
%     
% %     runningTime=length(gcamp_Indiv_avg)/16.81 + runningTime; 
%     
% %     numFFTepochs=size(FFTdata_rs,4);
% %     
% %     scoringindex_file=scoringNdx(epoch_count:epoch_count+size(FFTdata_rs,4)-1);
% %     
% %     epoch_count=epoch_count+size(FFTdata_rs,4);
% 
% 
%     save([gcamp_filename_root '-fc' num2str(runs(n)) '-GSR_G5'], 'scoringindex_file', 'xform_mask', 'gcamp6corr', '-v7.3');
% %     save([gcamp_filename_root '-fc' num2str(runs(n))], 'scoringindex_file', '-append');
% %     save([gcamp_filename_root '-fc_GSR' num2str(runs(n))], 'scoringindex_file', '-append');
%     clear scoringindex_file gcamp6corr
% 
% end

disp('Finished adding Scoring to FFT');
