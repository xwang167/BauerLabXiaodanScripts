Calcium_barrel_delay = circshift(Calcium_barrel,25);
figure
plot((1:3000)/25,Calcium_barrel)
hold on
plot((1:3000)/25,Calcium_barrel_delay)
Calcium_barrel_before = circshift(Calcium_barrel,-25);
hold on
plot((1:3000)/25,Calcium_barrel_before)
legend('Original','Delayed','Before')
xlabel('Time(s)')
ylabel('\DeltaF/F%')
title('Calcium Signal')

Pxy_originalDelayed = cpsd(Calcium_barrel,Calcium_barrel_delay,[],[],[],25);
Pxy_originalDelayed_magnitude = abs(Pxy_originalDelayed);
Pxy_originalDelayed_angle = unwrap(angle(Pxy_originalDelayed));

Pxy_originalBefore = cpsd(Calcium_barrel,Calcium_barrel_before,[],[],[],25);
Pxy_originalBefore_magnitude = abs(Pxy_originalBefore);
Pxy_originalBefore_angle = unwrap(angle(Pxy_originalBefore));

figure
subplot(2,3,1)
loglog(hz,Pxy_originalDelayed_magnitude)
grid on
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
title('Magnitude(Original and Delayed)')
grid on

subplot(2,3,2)
semilogx(hz,Pxy_originalDelayed_angle)
plot(hz,Pxy_originalDelayed_angle)
title('Phase(Original and Delayed)')
grid on

subplot(2,3,3)
semilogx(hz,Pxy_originalDelayed_angle)
title('Phase(Original and Delayed)')
grid on

subplot(2,3,4)
loglog(hz,Pxy_originalBefore_magnitude)
grid on
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
title('Magnitude(Original and Before)')
grid on

subplot(2,3,5)
plot(hz,Pxy_originalBefore_angle)
title('Phase(Original and Before)')
grid on

subplot(2,3,6)
semilogx(hz,Pxy_originalBefore_angle)
title('Phase(Original and Before)')
grid on


figure
plot((1:3000)/25,Calcium_barrel,'m')
hold on
plot((1:3000)/25,FAD_barrel*4,'g')
hold on
plot((1:3000)/25,HbT_barrel,'k')
legend('Calcium','FAD*4','HbT')
xlabel('Time(s)')
ylabel('\DeltaF/F% or \Delta\muM')

Pxy_originalBefore = cpsd(Calcium_barrel,Calcium_barrel_before,[],[],[],25);
Pxy_originalBefore_magnitude = abs(Pxy_originalBefore);
Pxy_originalBefore_angle = unwrap(angle(Pxy_originalBefore));

[Pxx_HbT,hz1] = pwelch(HbT_barrel,    [],[],[],samplingRate);
Pxx_FAD       = pwelch(FAD_barrel,    [],[],[],samplingRate);
Pxx_Calcium   = pwelch(Calcium_barrel,[],[],[],samplingRate);

[Pxy_CalciumFAD,hz] = cpsd(Calcium_barrel,FAD_barrel,[],[],[],samplingRate);
Pxy_CalciumHbT     = cpsd(Calcium_barrel,HbT_barrel,[],[],[],samplingRate);
Pxy_FADHbT         = cpsd(FAD_barrel,    HbT_barrel,[],[],[],samplingRate);

C_CalciumFAD = abs(Pxy_CalciumFAD).^2./Pxx_Calcium./Pxx_FAD;
C_CalciumHbT = abs(Pxy_CalciumHbT).^2./Pxx_Calcium./Pxx_HbT;
C_FADHbT     = abs(Pxy_FADHbT).^2./Pxx_FAD./Pxx_HbT;

figure
subplot(2,3,1)
plot(hz,C_CalciumFAD,'k')
xlabel('Frequency(Hz)')
ylabel('Coherence')
grid on
title('Calcium FAD')

subplot(2,3,2)
plot(hz,C_CalciumHbT,'k')
xlabel('Frequency(Hz)')
ylabel('Coherence')
grid on
title('Calcium HbT')

subplot(2,3,3)
plot(hz,C_FADHbT,'k')
xlabel('Frequency(Hz)')
ylabel('Coherence')
grid on
title('FAD HbT')

subplot(2,3,4)
semilogx(hz,C_CalciumFAD,'k')
xlabel('Frequency(Hz)')
ylabel('Coherence')
grid on
title('Calcium FAD')

subplot(2,3,5)
semilogx(hz,C_CalciumHbT,'k')
xlabel('Frequency(Hz)')
ylabel('Coherence')
grid on
title('Calcium HbT')

subplot(2,3,6)
semilogx(hz,C_FADHbT,'k')
xlabel('Frequency(Hz)')
ylabel('Coherence')
grid on
title('FAD HbT')


Pxy_CalciumFAD_magnitude = abs(Pxy_CalciumFAD);
Pxy_FADHbT_magnitude     = abs(Pxy_FADHbT     );
Pxy_CalciumHbT_magnitude = abs(Pxy_CalciumHbT);

Pxy_CalciumFAD_angle = unwrap(angle(Pxy_CalciumFAD),[],2);
Pxy_FADHbT_angle     = unwrap(angle(Pxy_FADHbT    ),[],2);
Pxy_CalciumHbT_angle = unwrap(angle(Pxy_CalciumHbT),[],2);
figure
subplot(3,3,1)
loglog(hz,Pxy_CalciumFAD_magnitude,'k')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
grid on
title('Calcium HbT Magnitude')
xlim([0.0244 12.5])

subplot(3,3,2)
plot(hz,Pxy_CalciumFAD_angle,'k')
xlabel('Frequency(Hz)')
ylabel('Phase')
grid on
title('Calcium HbT Phase')
xlim([0 12.5])

subplot(3,3,3)
semilogx(hz,Pxy_CalciumFAD_angle,'k')
xlabel('Frequency(Hz)')
ylabel('Phase')
grid on
title('Calcium HbT Phase')
xlim([0.0244 12.5])

subplot(3,3,4)
loglog(hz,Pxy_CalciumHbT_magnitude,'k')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
grid on
title('Calcium FAD Magnitude')
xlim([0.0244 12.5])

subplot(3,3,5)
plot(hz,Pxy_CalciumHbT_angle,'k')
xlabel('Frequency(Hz)')
ylabel('Phase')
grid on
title('Calcium FAD Phase')
xlim([0 12.5])

subplot(3,3,6)
semilogx(hz,Pxy_CalciumHbT_angle,'k')
xlabel('Frequency(Hz)')
ylabel('Phase')
grid on
title('Calcium FAD Phase')
xlim([0.0244 12.5])

subplot(3,3,7)
loglog(hz,Pxy_FADHbT_magnitude,'k')
xlabel('Frequency(Hz)')
ylabel('(\DeltaF/F)^2/Hz')
grid on
title('FAD HbT Magnitude')
xlim([0.0244 12.5])

subplot(3,3,8)
plot(hz,Pxy_FADHbT_angle,'k')
xlabel('Frequency(Hz)')
ylabel('Phase')
grid on
title('FAD HbT Phase') 
xlim([0 12.5])
ylim([-4 4])

subplot(3,3,9)
semilogx(hz,Pxy_FADHbT_angle,'k')
xlabel('Frequency(Hz)')
ylabel('Phase')
grid on
title('FAD HbT Phase') 
xlim([0.0244 12.5])
ylim([-4 4])
sgtitle('2-min data for an awake mouse')
sgtitle('Coherence for 2-min data of one awake mouse')