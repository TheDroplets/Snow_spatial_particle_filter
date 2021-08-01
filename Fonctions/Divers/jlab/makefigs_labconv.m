function[]=makefigs_labconv(str)
%MAKEFIGS_LABCONV  Makes some figures for Lilly et. al (1999), JPO.
%
%   MAKEFIGS_LABCONV  Makes selected figures for 
%
%       J. M. Lilly, P. B. Rhines, M. Visbeck,  R. Davis, 
%       J. R. N. Lazier, F. Schott, and D. Farmer (1999)
%        "Observing deep convection in the Labrador Sea 
%                     during winter 1994/95"
%       Journal of Physical Oceanography (29) 2065--2098     
%
%   Only figures number 8, 13, and part of 24 are made.
%
%   Type 'makefigs_labconv' at the matlab prompt to make all figures
%   for this and print them as .eps files into the current directory.
%
%   Type 'makefigs_labconv noprint' to supress printing to .eps files.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        
    

if nargin==0
  str='print';
end
  

%/********************************************************
load bravo94;

th1=bravo.rcm.th;
depths1=bravo.rcm.depths;
p1=bravo.rcm.p;

th2=bravo.cat.th;
depths2=bravo.cat.depths;
p2=bravo.cat.p;

depths=[depths1 depths2];
p=[p1 p2];
th=[th1 th2];

[depths,index]=sort(depths);
p=p(:,index);th=th(:,index);

p=p(:,1:end-1);th=th(:,1:end-1);depths=depths(1:end-1);

yearf=bravo.rcm.yearf;
yearf=osum(yearf,0*p(1,:)');

p=p./1000;

ci=[2.6:.05:3.3];
fth=vfilt(th,24);
fp=vfilt(p,24);
index=find(fth<2.6);fth(index)=2.6;

figure,contourf(yearf,p,fth,ci);
flipy,hold on,nocontours
ylim([0 2.7]),grid on,outticks
plot(yearf,fp,'w')
fixlabels([0 -1])
timelabel(yearf(:,1),'month')
xlabel('Month 1994--1995')
ylabel('Pressure (1000 dbar) \approx Depth (km)')
title('Bravo mooring potential temperature')
h=colorbar;axes(h);ytick([2.6:.1:3.3])

fontsize poster
orient landscape
set(gcf,'paperposition',[1 1 9 5]) 
if strcmp(str,'print')
   print -depsc bravo94theta.eps 
end
%!gv  bravo94theta.eps  &
%\********************************************************


%/********************************************************
load labconv_hydro
use labconv1
figure
plot(s,th),linestyle D,hold on

use labconv2
h=plot(s,th,'k');linestyle(h(1),'2k');

use labconv3
plot(s,th,'k--')

[q,h,qstar,sstar,thstar,sbar,thbar]=heatstorage(s,th,p,0);
index=1:10:length(sstar);
plot(sstar(index),thstar(index),'k*')
plot(sstar,thstar,':')
xlabel('Salinity')
ylabel('Theta')
title('June 1994--June 1995 T/S Scatter plot')

axis([34.46 34.94 1.1 5.1])
denscont(0,.07,.14,'G--')
xtick([34.45:.05:35])


fontsize jpofigure
orient portrait
if strcmp(str,'print')
  print -depsc labsea94mix.eps 
end
%!gv labsea94mix.eps  &
%\********************************************************



%/********************************************************
load bravo94
use bravo.rcm
cv=vfilt(cv,100);
figure
stickvect(yearf,180,cv,300,-30);
timelabel(yearf,'month');

fontsize jpofigure
orient tall
if strcmp(str,'print')
  print -depsc stickvect94.eps 
end
%!gv stickvect94.eps  &
%\********************************************************
