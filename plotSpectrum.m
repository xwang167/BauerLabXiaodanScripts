F_ex = 'FAD_excitation.txt';
G_ex = 'gcamp6f_excitation.txt';
R_ex = 'jrgeco1a_excitation.txt';

F_em = 'FAD_emission.txt';
G_em = 'gcamp6f_emission.txt';
R_em = 'jrgeco1a_emission.txt'; 

  fid=fopen(F_ex);      
  temp=textscan(fid,'%f %f','headerlines',0);
  fclose(fid);
  wavelength_F_ex = temp{1};
  spectra_F_ex = temp{2};
  
    fid=fopen(G_ex);      
  temp=textscan(fid,'%f %f','headerlines',0);
  fclose(fid);
  wavelength_G_ex = temp{1};
  spectra_G_ex = temp{2};
  
      fid=fopen(R_ex);      
  temp=textscan(fid,'%f %f','headerlines',0);
  fclose(fid);
  wavelength_R_ex = temp{1};
  spectra_R_ex = temp{2};
  figure;
  plot(wavelength_F_ex,spectra_F_ex/trapz(wavelength_F_ex,spectra_F_ex),'g')
  hold on
  plot(wavelength_G_ex,spectra_G_ex/trapz(wavelength_G_ex,spectra_G_ex),'c')
  hold on
  plot(wavelength_R_ex,spectra_R_ex/trapz(wavelength_R_ex,spectra_R_ex),'r')
  
  
  
  fid=fopen(F_em);      
  temp=textscan(fid,'%f %f','headerlines',0);
  fclose(fid);
  wavelength_F_em = temp{1};
  spectra_F_em = temp{2};
  
    fid=fopen(G_em);      
  temp=textscan(fid,'%f %f','headerlines',0);
  fclose(fid);
  wavelength_G_em = temp{1};
  spectra_G_em = temp{2};
  
      fid=fopen(R_em);      
  temp=textscan(fid,'%f %f','headerlines',0);
  fclose(fid);
  wavelength_R_em = temp{1};
  spectra_R_em = temp{2};
  figure;
  plot(wavelength_F_em,spectra_F_em/trapz(wavelength_F_em,spectra_F_em),'g')
  hold on
  plot(wavelength_G_em,spectra_G_em/trapz(wavelength_G_em,spectra_G_em),'c')
  hold on
  plot(wavelength_R_em,spectra_R_em/trapz(wavelength_R_em,spectra_R_em),'r')
