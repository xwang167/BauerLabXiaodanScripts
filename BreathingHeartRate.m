load('E:\RGECO\cat\191030--R5M2285-R5M2286-R5M2288-R6M2460-awake-R6M1-awake-R6M2497-awake-fc.mat', 'hz','powerdata_deoxy_mice','powerdata_oxy_mice')

figure
subplot(121)
loglog(hz,powerdata_oxy_mice,'r-')
xlabel('Frequency(Hz)')
ylabel('Power/Frequency((\Delta\muM)^2/Hz)')
title('HbO')
subplot(122)
loglog(hz,powerdata_deoxy_mice,'b-')
xlabel('Frequency(Hz)')
ylabel('Power/Frequency((\Delta\muM)^2/Hz)')
title('HbR')

sgtitle('Awake')


