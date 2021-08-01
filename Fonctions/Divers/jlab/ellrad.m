function[ri,rbar,rm]=ellrad(a,b,phi)
%ELLRAD  Average and instantaneous ellipse radius. 
%
%   [RI,RA,RM]=ELLRAD(A,B,PHI) where A and B are the semi-major and
%   semi-minor axes of a time-varying ellipse, and PHI is its time-
%   varying phase, returns quantities related to the ellipse 'radius',
%   i.e. the distance from the ellipse curve to the origin:
%
%       RI    Instantaneous distance from the origin
%       RBAR  Period-averaged distance from the origin
%       RM    Geometric-mean radius
%  
%   See Lilly and Gascard (2006) for details.
%
%   See also ELLVEL, ELLCONV, ELLDIFF.
%
%   Usage:  [ri,rbar,rm]=ellrad(a,b,phi);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    
  

kappa=frac(1,sqrt(2))*sqrt(squared(a)+squared(b));

lambda=abs(ecconv(b./a,'ell2lam'));
ecc=ecconv(lambda,'lam2ecc');
[K,E]=ellipke(ecc.^2);

rbar=frac(2*kappa,pi).*sqrt(1+lambda).*E;
ri=kappa.*sqrt(1+lambda.*cos(2*phi));
rm=sqrt(a.*abs(b));

%   ra=kappa.*(1-lambda.^2/16);
%   RA is obtained from a power series expansion in terms of the
%   eccentricity parameter lambda. 