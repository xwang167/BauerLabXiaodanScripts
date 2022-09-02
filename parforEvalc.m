function [a, b,c,d,e] =parforEvalc(t,Hb,cal)
options=optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolX',1e-8,'TolF',1e-8);
he = HemodynamicsError(t,Hb,cal);  %total to Clacium
fcn = @(param)he.fcn(param);
[a, b,c,d,e]= evalc('fminunc(fcn,[0.62,1.8,0.12],options)'); %T, W, A -- guess, lower bound, upper bound

end