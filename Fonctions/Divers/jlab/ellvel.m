function[vi,vphi,vbar,vm]=ellvel(a,b,theta,phi,dt,fact)
% ELLVEL  Average and instantaneous ellipse velocities. 
%
%   [VI,VPHI,VBAR,VM]=ELLVEL(A,B,THETA,PHI) where A and B are the semi- 
%   major and semi-minor axes of a time-varying ellipse, THETA is its
%   time-varying orientation, and PHI is its time-varying phase, returns
%   quantities related to the ellipse "velocity":
%  
%       VI    Instantaneous speed
%       VPHI  Instantaneous azimuthal velocity 
%       VBAR  Period-averaged speed 
%       VM    Geometric mean velocity 
%
%   Note that all these quantities are defined to be positive when the
%   ellipse is orbited in the mathematically positive (counterclockwise) 
%   sense, and negative when the ellipse is orbited in the mathematically 
%   negative sense.
%   
%   ELLVEL(...,DT) optionally uses DT as the data sample rate, with a 
%   default value of DT=1.
%
%   ELLVEL(...,DT,FACT) optionally converts the physical units of velocity
%   through a multiplication by FACT, with a default value of FACT=1.  For 
%   example, FACT=1e5 converts kilometers into centimeters.
%   
%   See Lilly and Gascard (2006) for details.
%
%   See also ELLRAD, ELLCONV, ELLDIFF.
%
%   Usage:  [vi,vphi,vbar,vm]=ellvel(a,b,theta,phi,dt,fact);
%
%   'ellvel --f' generates a sample figure
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    

  
if strcmp(a, '--f')
  ellvel_fig,return
end

if nargin==4
   dt=1;
   fact=1;
end
if nargin==5
   fact=1;
end

kappa=sqrt(frac(a.^2+b.^2,2));
lambda=abs(ecconv(b./a,'ell2lam'));  
omphi=vdiff(phi,1)/dt*fact;

[a2,b2,theta2,phi2]=elldiff(a,b,theta,phi,dt,fact);
[vi,vbar,vm]=ellrad(a2,b2,phi2);

vi=vi.*sign(b);
vm=vm.*sign(b);
vbar=vbar.*sign(b);

z=rot(theta).*(a.*cos(phi)+sqrt(-1).*b.*sin(phi));

omphi=frac(1,dt)*vdiff(unwrap(angle(z)),1);
vphi=fact*ellrad(a,b,phi).*omphi;

%These are equivalent methods
%zprime=rot(theta2).*(a2.*cos(phi2)+sqrt(-1).*b2.*sin(phi2));
%vphi=imag(rot(-angle(z)).*zprime);


function[]=ellvel_fig
lambda=[0:.001:1]';
nu=ecconv(lambda,'lam2nu');
a=cos(nu);b=sin(nu);
phi=[1:length(lambda)]'/10;
theta=0*lambda;
kappa=sqrt(frac(a.^2+b.^2,2));

[vi,vphi,vbar,vm]=ellvel(a,b,theta,phi);

plot(lambda,[vbar,vm]./maxmax([vbar(:);vm(:)]));
linestyle k 2k 
e=[.2486 .967];
axis([0 1 0 1]),axis square 
vlines(e.^2./(2-e.^2),'k-')
axis([0 1 0.5 1]),axis square 
title('Velocity measures')
xlabel('Ellipse parameter \lambda')
ylabel('Mean velocity measures')
set(gcf,'paperposition', [2 2 3.5 3.5])
xtick(.1),ytick(.1),fixlabels(-1)
text(0.75,0.93,'V_{Bar}')
text(0.55,0.83,'V_M') 
fontsize 14 14 14 14
%fontsize jpofigure
%cd_figures
%print -depsc ellipsemeans.eps


