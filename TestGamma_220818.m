%% Any charateristics of time trace related to low T?
for xInd = 1:size(HbT_filter,2)
    for yInd = 1:size(HbT_filter,1)
        if mask(yInd,xInd)
            pixHemo = squeeze(HbT_filter(yInd,xInd,:))'*10^6;
            pixNeural = squeeze(Calcium_filter(yInd,xInd,:))'*100;
            if T1(yInd,xInd) <0.02 && (T1(yInd,xInd) >0.01 || T1(yInd,xInd)==0.01)
                figure(1)
                hold on
                plot((1:3000)/5,pixHemo)
                figure(2)
                hold on
                plot((1:3000)/5,pixNeural)
            end
            
             if T1(yInd,xInd) >0.6 && T1(yInd,xInd) <1.1
                figure(3)
                hold on
                plot((1:3000)/5,pixHemo)
                figure(4)
                hold on
                plot((1:3000)/5,pixNeural)
            end
                
        end
    end
end
figure(1)
title('HbT, 0.01=<T<0.02')
figure(2)
title('Calcium, 0.01 =< T < 0.02')

figure(3)
title('HbT, 0.6<T<1.1')
figure(4)
title('Calcium, 0.6<T<1.1')

