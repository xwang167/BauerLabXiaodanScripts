load("X:\ToJonah\FADTimeTrace.mat")
FAD_filter = filterData_test(double(FAD'),0.02,2,25);
FAD_filter_interp = interp1(1:length(FAD),FAD_filter,linspace(1,length(FAD),length(FAD)/25*1000),'spline');
FAD_filter_interp_filter = filterData(double(FAD_filter_interp),0.02,2,1000);

FAD_filter_resample = resample(FAD_filter,1000,25);
[Pxx_filter_resample,hz_filter_resample] = pwelch(FAD_filter_resample,[],[],[],1000);
figure
loglog(hz_filter,Pxx_filter,'r')
hold on
loglog(hz_filter_interp,Pxx_filter_interp,'g')
hold on
loglog(hz_filter_resample,Pxx_filter_resample,'b')
legend('Filter','Filter, then Interp','Filter then Resample')

[Pxx_filter_interp,hz_filter_interp] = pwelch(FAD_filter_interp,[],[],[],1000);
[Pxx_filter_interp_filter_3,hz_filter_interp_filter_3] = pwelch(FAD_filter_interp_filter_3,[],[],[],1000);
[Pxx_filter_interp_filter_matlab,hz_filter_interp_filter_matlab] = pwelch(FAD_filter_interp_filter_matlab,[],[],[],1000);
figure
loglog(hz_filter_interp,Pxx_filter_interp,'r')
hold on
loglog(hz_filter_interp_filter_3,Pxx_filter_interp_filter_3,'g')
hold on
loglog(hz_filter_interp_filter_matlab,Pxx_filter_interp_filter_matlab,'b')

FAD_interp = interp1(1:length(FAD),double(FAD'),linspace(1,length(FAD),length(FAD)/25*1000),'spline');
FAD_interp_filter_matlab = filterData(FAD_interp,0.02,2,1000);
FAD_interp_filter_3 = filterData(FAD_interp,0.02,2,1000);

[Pxx_interp,hz_interp] = pwelch(FAD_interp,[],[],[],1000);
[Pxx_interp_filter_3,hz_interp_filter_3] = pwelch(FAD_interp_filter_3,[],[],[],1000);
[Pxx_interp_filter_matlab,hz_interp_filter_matlab] = pwelch(FAD_interp_filter_matlab,[],[],[],1000);


figure
loglog(hz_interp,Pxx_interp,'r')
hold on
loglog(hz_interp_filter_3,Pxx_interp_filter_3,'g')
hold on
loglog(hz_interp_filter_matlab,Pxx_interp_filter_matlab,'b')


FAD_interp = interp1(1:length(FAD),FAD',linspace(1,length(FAD),length(FAD)/25*1000),'spline');
FAD_resample = 