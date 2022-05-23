if ~isempty(locs)
    for ll = 1:length(locs)
        if ll>length(locs)
            break
        end
        if locs(ll)+30>length(pixHemo)
            locs(ll) = [];
        else
            endInd = locs(ll)+30;
        end
        
        if locs(ll)-30<1
            locs(ll) = [];
        else
            startInd = locs(ll)-30;
        end
        peak_HbT = pixHbT(startInd:endInd);
        peak_HbO = pixHbO(startInd:endInd);
        peak_HbR = pixHbR(startInd:endInd);
        peak_calcium = pixNeural(startInd:endInd);
        
        baseline_HbT = mean(peak_HbT(1:10));
        baseline_HbO = mean(peak_HbO(1:10));
        baseline_HbR = mean(peak_HbR(1:10));
        baseline_calcium = mean(peak_calcium(1:10));
        
        peak_HbT =  peak_HbT - baseline_HbT;
        peak_HbO =  peak_HbO - baseline_HbO;
        peak_HbR =  peak_HbR - baseline_HbR;
        peak_calcium =  peak_calcium - baseline_calcium;
        
        HbT_spikes = cat(1,HbT_spikes,peak_HbT);
        HbO_spikes = cat(1,HbO_spikes,peak_HbO);
        HbR_spikes = cat(1,HbR_spikes,peak_HbR);
        calcium_spikes = cat(1,calcium_spikes,peak_calcium);
    end
end