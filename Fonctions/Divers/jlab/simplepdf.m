function[f]=simplepdf(x,mu,sig,flag,alpha)
%SIMPLEPDF Gaussian, uniform, and Cauchy probability density functions.
%
%   F=SIMPLEPDF(X,MU,SIG,'gaussian') computes a Gaussian pdf with mean
%   MU and standard deviation SIG.
%  
%   F=SIMPLEPDF(X,MU,SIG,'boxcar') computes a uniform pdf with mean MU
%   and standard deviation SIG.
%  
%   F=SIMPLEPDF(X,MU,ALPHA,'cauchy') computes a Cauchy pdf with mean
%   MU and parameter ALPHA.
%
%   'simplepdf --f' generates a sample figure
%
%   Usage: f=simplepdf(x,mu,sig,'gaussian');
%          f=simplepdf(x,mu,sig,'boxcar');
%          f=simplepdf(x,mu,sig,'cauchy',alpha);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details    
  
warning off
  
if strcmp(x,'--f')
  simplepdf_fig;
  return
end
dx=x(2)-x(1);


if strcmp(flag,'gaussian')
  f=exp(-(x-mu).^2./2./sig.^2)./sig./sqrt(2*pi);
elseif strcmp(flag,'boxcar')
  f=0*x;
  ia=min(find(x-mu>-3.4641*sig/2))-1;
  ib=min(find(x-mu>3.4641*sig/2));
  f(ia:ib)=1;
  f=f./vsum(f*dx,1);
elseif strcmp(flag,'cauchy')
  alpha=sig;
  f=frac(alpha./pi,(x-mu).^2 + alpha.^2);
end


warning on

function[]=simplepdf_fig

x=[-100:.1:100]';
mu=25;
sig=10;
f=simplepdf(x,mu,sig,'gaussian');
%[mu2,sig2]=pdfprops(x,f);
figure,plot(x,f),vlines(mu,'r')
%a=conflimit(x,f,95);
%vlines(mu+a,'g'),vlines(mu-a,'g')
title('Gaussian with mean 25 and standard deviation 10')
