function [data2, R]=regcorr(data,hem)

[data, Sin, Sout]=datacondition(data,2); % reshape to meas x color x time
[hem, Hin, Hout]=datacondition(hem,2); % reshape to color x time

% check compatibility
if Hout(end)~=Sout(end)
    error('** Your data and regressor do not have the same time length: perhaps check your Resampling Tolerance Flag **')
end

if numel(Sout)==3 % normal case
    L=Sout(1);
    C=Sout(2);
    T=Sout(3);
    
    data2=zeros(T,C,L);
    R=zeros(L,C);
    
    for c=1:C
        temp=squeeze(data(:,c,:))'; % get single color/contrast time x voxel
        g=hem(c,:)'; % regressor/noise signal in correct orientation time x 1
        gp=pinv(g); % pseudoinverse for least-square regression 1 x time
        beta=gp*temp; % regression coefficient 1 x voxel
        data2(:,c,:)=temp-g*beta; % linear regression
        R(:,c)=normRow(g')*normCol(temp); % correlation coefficient
    end
    data2=permute(data2,[3 2 1]); % switch dimensions back to correct order
    R=reshape(R,Sin(1:(end-1))); % reshape to original size (minus time)
    
elseif numel(Sout)==2 % special case of one data trace
    C=Sout(1);
    T=Sout(2);

    data2=zeros(C,T);
    R=zeros(1,C);
    
    for c=1:C
        temp=squeeze(data(c,:))';
        
        g=hem(c,:)';
        gp=pinv(g);
        beta=gp*temp;
        
        data2(c,:)=temp-g*beta;
        
        R(c)=normRow(g')*normCol(temp);
    end
    
end

data2=reshape(data2,Sin); % reshape to original shape

end