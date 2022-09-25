

%% same T/2 ratio
y =  mouse.math.hrfGamma(t,0.69,1.2,0.1);
% [~,max_loc] = max(y);
% t(max_loc)
% A = find(y(max_loc:end)<0.0001);
A = find(y>0.0001);
t1 = t(A(1):A(end));
y1 = y(A(1):A(end));

y =  mouse.math.hrfGamma(t,0.69*2,1.2*2,0.1);
A = find(y>0.0001);
t2 = t(A(1):A(end));
y2 = y(A(1):A(end));


y =  mouse.math.hrfGamma(t,0.69*3,1.2*3,0.1);
A = find(y>0.0001);
t3 = t(A(1):A(end));
y3 = y(A(1):A(end));


y =  mouse.math.hrfGamma(t,0.69*4,1.2*4,0.1);
A = find(y>0.0001);
t4 = t(A(1):A(end));
y4 = y(A(1):A(end));



skewness(y1)
skewness(y2)
skewness(y3)
skewness(y4)
figure
plot(t1,y1)
hold on
plot(t2,y2)
hold on
plot(t3,y3)
hold on
plot(t4,y4)
title('Same T/W ratio, same skewness = 0.92')
legend('T,W,A = 0.69,1.2,0.1','T,W,A = 0.69*2,1.2*2,0.1','T,W,A = 0.69*3,1.2*3,0.1','T,W,A = 0.69*4,1.2*4,0.1')

%% different T
y =  mouse.math.hrfGamma(t,0.69*0.25,1.2,0.1);
% [~,max_loc] = max(y);
% t(max_loc)
% A = find(y(max_loc:end)<0.0001);
A = find(y>0.0001);
t1 = t(A(1):A(end));
y1 = y(A(1):A(end));

y =  mouse.math.hrfGamma(t,0.69*0.5,1.2,0.1);
A = find(y>0.0001);
t2 = t(A(1):A(end));
y2 = y(A(1):A(end));


y =  mouse.math.hrfGamma(t,0.69,1.2,0.1);
A = find(y>0.0001);
t3 = t(A(1):A(end));
y3 = y(A(1):A(end));


y =  mouse.math.hrfGamma(t,0.69*2,1.2,0.1);
A = find(y>0.0001);
t4 = t(A(1):A(end));
y4 = y(A(1):A(end));

y =  mouse.math.hrfGamma(t,0.69*4,1.2,0.1);
A = find(y>0.0001);
t5 = t(A(1):A(end));
y5 = y(A(1):A(end));




skewness(y1)
skewness(y2)
skewness(y3)
skewness(y4)
skewness(y5)

figure
plot(t1,y1)
hold on
plot(t2,y2)
hold on
plot(t3,y3)
hold on
plot(t4,y4)
hold on
plot(t5,y5)
title('Different T, Same W')
 legend('T,W,A = 0.69*0.25,1.2,0.1','T,W,A = 0.69*0.50,1.2,0.1','T,W,A = 0.69*1.00,1.2,0.1','T,W,A = 0.69*2.00,1.2,0.1','T,W,A = 0.69*4.00,1.2,0.1')



%% different W
y =  mouse.math.hrfGamma(t,0.69,1.2*0.25,0.1);
% [~,max_loc] = max(y);
% t(max_loc)
% A = find(y(max_loc:end)<0.0001);
A = find(y>0.0001);
t1 = t(A(1):A(end));
y1 = y(A(1):A(end));

y =  mouse.math.hrfGamma(t,0.69,1.2*0.5,0.1);
A = find(y>0.0001);
t2 = t(A(1):A(end));
y2 = y(A(1):A(end));


y =  mouse.math.hrfGamma(t,0.69,1.2,0.1);
A = find(y>0.0001);
t3 = t(A(1):A(end));
y3 = y(A(1):A(end));


y =  mouse.math.hrfGamma(t,0.69,1.2*2,0.1);
A = find(y>0.0001);
t4 = t(A(1):A(end));
y4 = y(A(1):A(end));

y =  mouse.math.hrfGamma(t,0.69,1.2*4,0.1);
A = find(y>0.0001);
t5 = t(A(1):A(end));
y5 = y(A(1):A(end));




skewness(y1)
skewness(y2)
skewness(y3)
skewness(y4)
skewness(y5)

figure
plot(t1,y1)
hold on
plot(t2,y2)
hold on
plot(t3,y3)
hold on
plot(t4,y4)
hold on
plot(t5,y5)
title('Different W, Same T')
 legend('T,W,A = 0.69,1.2*0.25,0.1','T,W,A = 0.69,1.2*0.5,0.1','T,W,A = 0.69,1.2*1.0,0.1','T,W,A = 0.69,1.2*2.0,0.1','T,W,A = 0.69,1.2*4.0,0.1')