function[mu,sigma,skew,kurt]=pdfprops(x,fx);
%PDFPROPS  Mean and variance associated with a probability distribution.
%
%   [MU,SIGMA]=PDFPROPS(X,FX), given a probability distribution
%   function FX over values X, returns the mean MU and the standard
%   deviation SIGMA. Each column of X must have uniform spacing.
%
%   The statistics are computed using a trapezoidal integration.
%   FX is multiplied by a constant so that it integrates to one.
%
%   [MU,SIGMA,SKEW,KURT]=PDFPROPS(X,FX) also retuns the skewness and 
%   the kurtosis, which are the third and fourth central moments, 
%   respectively normalized by the third and fourth powers of the 
%   standard deviation.  
%
%   'pdfprops --t' runs a test.
%
%   Usage:  [mu,sigma]=pdfprops(x,fx); 
%           [mu,sigma,skew,kurt]=pdfprops(x,fx);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details    
  
if strcmp(x,'--t')
    pdfprops_test;
    return
end

if isrow(x)
  x=x(:);
end
if isrow(fx)
  fx=fx(:);
end

if size(x,2)==1
   x=x*ones(size(fx(1,:)));
end

dx=x(2,:)-x(1,:);

if trapint(fx,dx)~=1
  %disp('Normalizing FX to unit area.')
  fx=fx./trapint(fx,dx);
end

for i=1:size(fx,2)
  mu(i,1)=trapint(fx(:,i).*x(:,i),dx(i));
  sigma(i,1)=sqrt(trapint((x(:,i)-mu(i,1)).^2.*fx(:,i),dx(i)));
end

%figure,plot((x-mumat).^2)
%figure,plot(fx)
%figure,plot((x-mumat).^2.*fx)
if nargout>=3
   for i=1:size(fx,2)
      skew(i,1)=trapint((x(:,i)-mu(i,1)).^3.*fx(:,i),dx(i));
   end
   skew=skew./sigma.^3;
end
if nargout==4
   for i=1:size(fx,2)
      kurt(i,1)=trapint((x(:,i)-mu(i,1)).^4.*fx(:,i),dx(i));
   end
   kurt=kurt./sigma.^4;
end


function[y]=trapint(f,dx)
%Trapezoidal integration

fa=f;
fb=vshift(fa,1,1);
fa(1)=0;
fb(1)=0;
fa(end)=0;
fb(end)=0;
y=vsum(frac(fa+fb,2),1).*dx;

function[]=pdfprops_test
x=[-30:.001:30]';

mu0=2;
sigma0=5;

f=simplepdf(x,mu0,sigma0,'gaussian');  %f=simplepdf(x,mu,sig,flag)  
[mug,sigmag,skewg,kurtg]=pdfprops(x,f);

f=simplepdf(x,mu0,sigma0,'boxcar');  %f=simplepdf(x,mu,sig,flag)  
[mu,sigma]=pdfprops(x,f);
tol=1e-3;

bool(1)=aresame(mu,mu0,tol).*aresame(sigma,sigma0,tol);
bool(2)=aresame(mug,mu0,tol).*aresame(sigmag,sigma0,tol);
bool(3)=aresame(skewg,0,tol).*aresame(kurtg,3,tol);

reporttest('PDFPROPS with uniform pdf', bool(1));
reporttest('PDFPROPS with Gaussian pdf', bool(2));
reporttest('PDFPROPS Gaussian skewness=0, kurtosis=3', bool(3));

% %/********************************************************
% x=[-10:.001:10]';
% f=simplepdf(x,0,2,'gaussian');
% f(end/2:end)=2*f(end/2:end);
% f(1:end/2)=0;
% f=f./sum(f)./0.001;
% plot(x,cumsum(f*.001))
% %********************************************************
