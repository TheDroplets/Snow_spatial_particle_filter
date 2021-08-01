function[varargout]=mspec(varargin)
% MSPEC  Multitaper power and cross spectra.
% 
%   MSPEC implements spectral analysis using the multitaper method.
%   Real-valued or complex-valued data may be input.  
%   ______________________________________________________________  
%
%   Power spectrum of real-valued data:
%
%   [F,S]=MSPEC(X,PSI);       --- For real-valued X
%  
%   Input:   
%       X  --  M x N matrix containing N length M time series
%     PSI  --  M x K matrix of K data tapers
% 
%   Output:
%       F  --  M/2 nonnegative frequencies
%       S  --  [M/2] x N one-sided power spectrum matrix
%                
%   Note that for real-valued X, S is the one-side spectrum, that is, 
%   its sum over F is equal to the estimated variance.  In the above,
%   [M/2] means: M/2 if M is even, and (M-1)/2 is M is odd.  
%   ______________________________________________________________  
%  
%   Cross-spectrum of real-valued data:
%
%   [F,SXX,SYY,SXY]=MSPEC(X,Y,PSI);   --- For cross-spectra
%        
%   Input:
%       X  --  M x N real matrix containing N length M time series
%       Y  --  M x N real matrix containing N length M time series
%     PSI  --  M x K matrix of K data tapers
% 
%   Output:
%       F  --  M/2 nonnegative frequencies
%     SXX  --  [M/2] x N one-sided power spectrum matrix
%     SYY  --  [M/2] x N one-sided power spectrum matrix
%     SXY  --  [M/2] x N one-sided cross spectral matrix of each
%                        column of X with corresponding column of Y          
%   ______________________________________________________________  
%  
%   Rotary spectra of complex-valued data:
%
%   [F,SPP,SNN,SPN]=MSPEC(Z,PSI);   --- For complex-valued Z
%      
%   Output:   
%      SPP  --  [M/2] x N positively rotating power spectrum matrix
%      SNN  --  [M/2] x N negatively rotating power spectrum matrix  
%      SPN  --  [M/2] x N rotary cross spectral matrix  
%
%   The spectral matrices are averages over the K eigenspectra
%   computed with each of the K tapers, as discussed in Park et al.
%   JGR 1987.
%
%   [...]=MSPEC(DELTAT,...) optionally uses time interval DELTAT in
%   computing the frequencies; the default is DELTAT=1.
%   __________________________________________________________________
%  
%   'MSPEC --t' runs some tests.
%   'MSPEC --f' generates some sample figures from Bravo mooring data.
%
%   See also: SLEPTAP, HERMFUN, MTRANS, MSVD.
%
%   Usage:  [f,s]=mspec(x,psi);     
%           [f,sp,sn]=mspec(z,psi);     
%           [f,sxx,syy,sxy]=mspec(x,y,psi); 
%           [f,spp,snn,spn]=mspec(z,psi); 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000-2006 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(varargin{1},'--t')
    mspec_test;return
end
if strcmp(varargin{1},'--f')
    mspec_fig;return
end

deltat=1;
lambda=1;
na=nargin;
if isscal(varargin{1})
  deltat=varargin{1};
  varargin=varargin(2:end);
  na=na-1;
end
  
x=varargin{1};

%/********************************************************
%Sort out input arguments
y=[];
if na==2
  psi=varargin{2};
elseif na==3
  if length(varargin{3})>1
     y=varargin{2};
     psi=varargin{3};
  else
    psi=varargin{2};
    lambda=varargin{3};
  end
elseif na==4
   y=varargin{2};
   psi=varargin{3};
   lambda=varargin{4};
end
%\********************************************************

if isreal(x)&isempty(y)
   mmatx=mtrans(x,psi);
   varargout{2}=mspec1(mmatx,deltat,lambda);
elseif ~isreal(x)&isempty(y)
   mmatx=mtrans(x,psi);
   mmatp=mmatx(:,:,1:2:end);
   mmatn=mmatx(:,:,2:2:end);
   varargout{2}=mspec1(mmatp,deltat,lambda);
   varargout{3}=mspec1(mmatn,deltat,lambda);
   varargout{4}=mcrossspec1(mmatp,mmatn,deltat,lambda);
elseif ~isempty(y)
   mmat=mtrans(x,y,psi);
   mmatx=mmat(:,:,1:2:end);
   mmaty=mmat(:,:,2:2:end);
   varargout{2}=mspec1(mmatx,deltat,lambda);
   varargout{3}=mspec1(mmaty,deltat,lambda);
   varargout{4}=mcrossspec1(mmatx,mmaty,deltat,lambda);
end

varargout{1}=(1./deltat).*[0:1/size(mmatx,1)/2:1/2-1./size(mmatx,1)/2]';

function[S]=mspec1(mmat,deltat,lambda)

eigspec=mmat.*conj(mmat);

if lambda==1
   S=deltat.*squeeze(mean(eigspec,2));
else
%   S=adaptspect(yki,lambda,std(x));
end

function[S]=mcrossspec1(mmat1,mmat2,deltat,lambda)

eigspec=mmat1.*conj(mmat2);

if lambda==1
   S=deltat.*squeeze(mean(eigspec,2));
else
%   S=adaptspect(yki,lambda,std(x));
end

function[s,dk]=adaptspect(yk,lambda,var)
%not sure adaptive method will work on a complex-valued spectrum
%Not yet supported
  
s=(abs(yk(:,1)).^2)/2+(abs(yk(:,2)).^2)/2;

sold=s*0+1000;
lambda=conj(lambda(:)');
tol=var/1000;
i=0;
while any(abs(s-sold)>tol)
	i=i+1;
        disp(['Adaptive spectral estimate iteration # ',int2str(i)])
	sold=s;
       	bk=var*(1+0*s)*(ones(size(lambda))-lambda);
	dk=(s*sqrt(lambda))./(s*lambda+bk);
	s=sum(abs((dk.*yk)).^2,2)./sum(abs(dk).^2,2);
end

function[]=mspec_test
tol=1e-10;
[x,t,xo]=testseries(6);

x=x(1:100);
[psi,lambda]=sleptap(length(x),8);
m=mtrans(x,psi);
[f,sp,sn,spn]=mspec(x,psi);
mp=m(:,:,1:2:end);mn=m(:,:,2:2:end);
reporttest('MSPEC positive rotary spectrum matches mmat, even',aresame(sp,mean(abs(mp).^2,2),tol))  
reporttest('MSPEC negative rotary spectrum matches mmat, even',aresame(sn,mean(abs(mn).^2,2),tol))  
reporttest('MSPEC rotary cross spectrum matches mmat, even',aresame(spn,mean(mp.*conj(mn),2),tol))  
m=mtrans(real(x),imag(x),psi);
[f,su,sv,suv]=mspec(real(x),imag(x),psi);
mu=m(:,:,1:2:end);mv=m(:,:,2:2:end);
reporttest('MSPEC x-spectrum matches mmat, even',aresame(su,mean(abs(mu).^2,2),tol))  
reporttest('MSPEC y-spectrum matches mmat, even',aresame(sv,mean(abs(mv).^2,2),tol))  
reporttest('MSPEC Cartesian cross spectrum matches mmat, even',aresame(suv,mean(mu.*conj(mv),2),tol))  

[mp2,mn2]=transconv(mu,mv,'uv2pn');
[mu2,mv2]=transconv(mp,mn,'pn2uv');
reporttest('MSPEC p-eigentransforms match conversion, even',aresame(mp,mp2,tol))  
reporttest('MSPEC n-eigentransforms match conversion, even',aresame(mn,mn2,tol))  
reporttest('MSPEC x-eigentransforms match conversion, even',aresame(mu,mu2,tol))  
reporttest('MSPEC y-eigentransforms match conversion, even',aresame(mv,mv2,tol))  

%Convert th and nu into actual Cartesian coordinates 
[d1r,d2r,thr,nur]=specdiag(sp,sn,spn);
[p1,n1]=vectmult(jmat(thr),cos(nur),-sqrt(-1)*sin(nur));
[u1,v1]=transconv(p1,n1,'pn2uv');
[ar,br,thr,phir,nur,ka]=normform(u1,v1);
[a,b,thr2,phir2]=ellconv(p1,n1,'pn2ab');

x=x(1:99);
[psi,lambda]=sleptap(length(x),8);
m=mtrans(x,psi);
[f,sp,sn,spn]=mspec(x,psi);
mp=m(:,:,1:2:end);mn=m(:,:,2:2:end);
reporttest('MSPEC positive rotary spectrum matches mmat, odd',aresame(sp,mean(abs(mp).^2,2),tol))  
reporttest('MSPEC negative rotary spectrum matches mmat, odd',aresame(sn,mean(abs(mn).^2,2),tol))  
reporttest('MSPEC rotary cross spectrum matches mmat, odd',aresame(spn,mean(mp.*conj(mn),2),tol))  
m=mtrans(real(x),imag(x),psi);
[f,su,sv,suv]=mspec(real(x),imag(x),psi);
mu=m(:,:,1:2:end);mv=m(:,:,2:2:end);
reporttest('MSPEC x-spectrum matches mmat, odd',aresame(su,mean(abs(mu).^2,2),tol))  
reporttest('MSPEC y-spectrum matches mmat, odd',aresame(sv,mean(abs(mv).^2,2),tol))  
reporttest('MSPEC Cartesian cross spectrum matches mmat, odd',aresame(suv,mean(mu.*conj(mv),2),tol))  

[mp2,mn2]=transconv(mu,mv,'uv2pn');
[mu2,mv2]=transconv(mp,mn,'pn2uv');
reporttest('MSPEC p-eigentransforms match conversion, odd',aresame(mp,mp2,tol))  
reporttest('MSPEC n-eigentransforms match conversion, odd',aresame(mn,mn2,tol))  
reporttest('MSPEC x-eigentransforms match conversion, odd',aresame(mu,mu2,tol))  
reporttest('MSPEC y-eigentransforms match conversion, odd',aresame(mv,mv2,tol))  


function[]=mspec_fig
load bravo94
use  bravo.rcm
x=cv;
vswap(x,nan,0);
[psi,lambda]=sleptap(length(x),16);
[f,sp,sn,spn]=mspec(x,psi);
[f,su,sv,suv]=mspec(real(x),imag(x),psi);

figure,plot(f,[sp sn]),xlog,ylog
title('Counterclockwise (blue) and clockwise (green) spectra'),
linestyle b b b b b b g g g g g g    

load bravo94
cv=bravo.rcm.cv;
vswap(cv,nan,0);
[psi,lambda]=sleptap(length(x),8);

for i=1:size(cv,2)
  [f,Suu,Suu3,Cuu]=mspec(real(cv(:,i)),real(cv(:,3)),psi);
  gammauu(:,i)=Cuu./sqrt(Suu.*Suu3);
end
figure,
plot(f,abs(gammauu)),xlog,yoffset 1
title('Coherence of u(t) at each depth vs. u(t) at #3')

% [f,Cuv]=mspec(real(cv),imag(x),psi);
% [f,Suu]=mspec(real(cv),psi);
% [f,Svv]=mspec(imag(cv),psi);
% 
% gammauv=Cuv;
% for i=1:size(Suu,2)
%   gammauv(:,i)=Cuv(:,i)./sqrt(Suu(:,i).*Svv(:,3));
% end
% figure,
% 
% 
% plot(f,abs(gammauv)),xlog,yoffset 1
% title('Cross-spectrum of u(t) at each depth vs. u(t) at #3')
% secondaxis(gca,1,1)
