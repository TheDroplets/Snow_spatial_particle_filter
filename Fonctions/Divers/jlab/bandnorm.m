function[w]=bandnorm(w,fs)
%BANDNORM  Applies a bandpass normalization to a wavelet matrix.
%
%   PSI=BANDNORM(W,F) for a cell array of wavelets PSI having central
%   frequencies F, applies a 'bandpass' normalization. The wavelets are
%   assumed to initially have a unit energy normalization.
%  
%   Specifically, the wavelets are rescaled by (scale)^(-1) instead of
%   (scale)^(-1/2).  Addition, the wavelets are divided by a constant
%   such that the maximum magnitude of the Fourier transform of the
%   shortest wavelet equals 2.  Together these imply that the wavelet 
%   transform of a real-valued unit-amplitude sinusoid has a maximum 
%   amplitude of unity.  
%
%   Usage: psi=bandnorm(psi,f);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2005 J.M. Lilly --- type 'help jlab_license' for details        

for i=1:size(w,2)
   w(:,i,:)=w(:,i,:).*sqrt(fs(i));
end

W=fft(fftshift(w(:,1,1)));
fi=[0:size(w,1)-1]./size(w,1);
[mtemp,index]=min(abs(fi-fs(1)));
cn1=2./abs(W(index,1));
w=w.*cn1;

