function[]=makefigs_olsef(str)
%MAKEFIGS_OLSEF  Makes some figures for Lilly et. al (2003), Prog. O.
%
%   MAKEFIGS_OLSEF  Makes selected figures for 
%
%       J. M. Lilly, P. B. Rhines, F. Schott, K. Lavender, 
%           J. Lazier, U. Send, and E. D'Asaro (2003)
%         "Observations of the Labrador Sea eddy field"
%           Progress in Oceanography (59) 75--176
%
%   Only figures numbers 11, 12, and 13 are currently made.
%
%   Type 'makefigs_olsef' at the matlab prompt to make all figures
%   for this and print them as .eps files into the current directory.
%
%   Note that the WAVELAB package is required for some figures.
%
%   Type 'makefigs_olsef noprint' to supress printing to .eps files.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        

if nargin==0
  str='print';
end

%/********************************************************
%Figure 11
slepenvwave --f
if strcmp(str,'print')
   print -depsc olsef_figure11.eps 
end
%\********************************************************  
  
%/********************************************************
%Figure 12
figure
ro=10;
vo=-10;
eta=-sqrt(-1)*5+[-200:.1:200]';
[x,psi]=rankineeddy(eta,ro,vo);
t=real(eta);

ao=logspace(1.2,3.5,40)';
[w,fs,W]=slepenvwave(ao,2/3,2);
w=bandnorm(w,fs);

ye=wavetrans(x,real(w))/2;
yo=wavetrans(x,imag(w))/2;

subplot(411)
uvplot(real(eta),x),hold on,plot(real(eta),abs(x))
linestyle G2 2k-- k
xlim([-50 50]),ylim([-12 12])
title('Wavelet transform of Rankine vortex')
ytick([-10:5:10])
subplot(412)
jcontour(t,1./fs,abs(ye),[0:.25:10],[0:1:10],'E-','2K-','nolabels');
subplot(413)
jcontour(t,1./fs,abs(yo),[0:.25:10],[0:1:10],'E-','2K-','nolabels');
subplot(414)
jcontour(t,1./fs,sqrt(abs(ye).^2+abs(yo).^2),[0:.25:10],[0:1:10],'E-','2K-','nolabels');
for i=1:4
  subplot(4,1,i),vlines([-8.7 8.7] ,'E--'),hlines(0,'E--')
end
for i=2:4
  subplot(4,1,i)
  xlim([-50 50]),flipy,ylim([50 2200]),ylog,
  ytick(10.^[2 2.5 3 3.5])
  set(gca,'yticklabel',['1.0';'1.5';'2.0';'2.5'])
  ylabel('Log_{10} scale (km)')
end
packrows(4,1)

if strcmp(str,'print')
   print -depsc olsef_figure12.eps 
end
%\********************************************************

  
 
 
%/********************************************************
%Fig. 13
figure
ao=logspace(1.2,3.6,40)';
[w,fs,W]=slepenvwave(ao,2/3,2);
w=bandnorm(w,fs);
load bravo94
clear x
x(:,1)=bravo.rcm.cv(:,3);
x(:,2)=bravo.rcm.cv(:,6);
t=yf2num(bravo.rcm.yearf)-datenum(1994,1,1);
xo=vfilt(x,24);
%t=t(1:4000);

ye=wavetrans(x(:,1),real(w),'zeros                                                                                                                                  ;
yo=wavetrans(x(:,1),imag(w),'zeros')./2;


subplot(411)
uvplot(t,abs(xo))
linestyle k k--
xlim([147 230]),ylim([0 33])
title('Wavelet transform of 1994 eddies')
ylabel('Speed (cm s^{-1})')
ytick([0:10:30])
subplot(412)
jcontour(t,1./fs,abs(ye),[1.5:2:10],5.5,'E-','2K-','nolabels');
subplot(413)
jcontour(t,1./fs,abs(yo),[1.5:2:10],5.5,'E-','2K-','nolabels');
subplot(414)
jcontour(t,1./fs,sqrt(abs(ye).^2+abs(yo).^2),[1.5:2:10],5.5,'E-','2K-','nolabels');
for i=2:4
  subplot(4,1,i)
  axis([147 230 12 2500]),flipy,ylog
  ytick(10.^[1.5 2 2.5 3 3.5])
  set(gca,'yticklabel',['0.5';'1.0';'1.5';'2.0';'2.5'])
  ylabel('Log_{10} scale (km)')
end
packrows(4,1)
disp('Note incorrect labelling values quoted in Lilly et al. 2003')
 
T=sqrt(abs(ye).^2+abs(yo).^2);

% Color version
% C=abs(ye);
% S=abs(yo);
% 
% h=wavespecplot(t,abs(xo),1./fs,C,S,T,1/2);
% axes(h(1)),
% linestyle k k--
% xlim([147 230]),ylim([0 33])
% title('Wavelet transform of 1994 eddies')
% ylabel('Speed (cm s^{-1})')
% for i=2:4
%     axes(h(i))
%     axis([147 230 12 2400])
%     ytick(10.^[2 2.5 3 3.5])
%     set(gca,'yticklabel',['1.0';'1.5';'2.0';'2.5'])
%     ylabel('Log_{10} scale (km)')
% end
[im,jm,nm]=modmax(T,2);
tm=0*jm;fm=0*jm;
tm(find(~isnan(im)))=t(im(find(~isnan(im))));
fm(find(~isnan(jm)))=fs(jm(find(~isnan(jm))));

h=plot(tm,1./fm,'c');
linestyle(h,'D')
if strcmp(str,'print')
   print -depsc olsef_figure13.eps 
end
%\********************************************************

