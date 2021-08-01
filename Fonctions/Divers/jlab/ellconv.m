function[o1,o2,o3,o4]=ellconv(i1,i2,i3,i4,i5)
% ELLCONV  Converts between time-varying ellipse representations.
%
%   [Y1,Y2,Y3,Y4]=ELLCONV(X1,X2,X3,X4,STR) converts a time-varying ellipse
%   from one representation to another, as specified by the string STR.  
%
%   STR is of the form 'in2out' where the names 'in' and 'out' may be any 
%   of the following
%  
%       Name    Arguments            Description
%       +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%         'xy'  [X,Y,PHIX,PHIY]      X and Y component form   
%         'pn'  [P,N,PHIP,PHIN]      Positively / negatively rotating form
%         'ab'  [A,B,THETA,PHI]      Semi-major / semi-minor axis form  
%  
%   thus [X,Y,PHIX,PHIY]=ELLCONV(A,B,THETA,PHI,'ab2xy') converts from 
%   semi-major / semi-minor axis form to X/Y component form. 
%  
%   More specifically, a time-varying ellipse in a complex-valued time 
%   series is represented in one of three ways
%   
%         'xy'  Z = X COS(PHIX) + i Y * COS(PHIY)  
%         'pn'  Z = P EXP(i PHIP) + i N EXP(-i PHIN) 
%         'ab'  Z = EXP(i THETA) [A COS(PHI) + i B * SIN(PHI)] 
%
%   where 'i' is the square root of negative one.  For additional details,
%   see Lilly and Gascard (2006).  
%   _____________________________________________________________________
%
%   Ridge conversion
%
%   ELLCONV also converts a wavelet transform along a wavelet ridge into
%   one of the ellipse forms listed above, as follows:   
%
%   [...]=ELLCONV(WX,WY,'xy2--') converts to the ellipse form specifed by 
%    '--' from WX and WY, the complex-valued analytic wavelet transforms 
%   of the X and Y time series components along a ridge.
%  
%   [...]=ELLCONV(WP,WN,'pn2--') similarly converts from WP and WN, the 
%   complex-valued analytic and anti-anaytic wavelets, respectively, of a 
%   complex-valued time series Z=X+iY.  
%
%   The wavelet transform pairs WX and WY, and WP and WN, are defined in
%   Lilly and Gascard (2006) and are implemented by TRANSCONV.
%   _____________________________________________________________________
%
%   See also ECCONV, ELLDIFF.
%  
%   Usage:  [a,b,theta,phi]=ellconv(U,V,phiu,phiv,'xy2ab');
%           [P,N,phip,phin]=ellconv(U,V,phiu,phiv,'xy2pn'); 
%           [a,b,theta,phi]=ellconv(wu,wv,'xy2ab');
%
%   'ellconv --t' runs some tests
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    

%         'kl'  [KAP,LAM,THETA,PHI]  Kappa / Lambda form
%         'kl'  Z = KAP EXP(i THETA)     

if strcmp(i1,'--t')
  ellconv_test;return
end

if nargin==5
   str=i5;
elseif nargin==3
   str=i3;
end

ellconv_checkstr(str);

if nargin==5
   eval(['[o1,o2,o3,o4]=ellconv_' str '(i1,i2,i3,i4);'])
elseif nargin==3
   eval(['[o1,o2,o3,o4]=ellconv_' str '(i1,i2);'])
end

function[]=ellconv_checkstr(str)
ii=findstr(str,'2');
if isempty(ii)
  error(['STR should be of the form ''xy2pn''.'])
end
str1=str(1:ii-1);
str2=str(ii+1:end);

if ~aresame(str1,'ab')&~aresame(str1,'pn')&~aresame(str1,'xy')
  error(['Input parameter name ' str1 ' is not supported.'])
end
if ~aresame(str2,'ab')&~aresame(str2,'pn')&~aresame(str2,'xy')
  error(['Output parameter name ' str2 ' is not supported.'])
end
 

function[X,Y,phix,phiy]=ellconv_xy2xy(X,Y,phix,phiy)
%Sort out input arguments  
if nargin==2  
   wu=X;
   wv=Y;
   X=abs(wu);
   Y=abs(wv);
   phix=angle(wu);
   phiy=angle(wv);
end
phix=unwrangle(phix);
phiy=unwrangle(phiy);

function[P,N,phip,phin]=ellconv_pn2pn(P,N,phip,phin)  
%Sort out input arguments
if nargin==2  
   wp=P;
   wn=N;
   P=abs(wp)*sqrt(2);
   N=abs(wn)*sqrt(2);
   phip=angle(wp);
   phin=-angle(wn);
end
phip=unwrangle(phip);
phin=unwrangle(phin);

function[A,B,theta,phi]=ellconv_ab2ab(A,B,theta,phi)
phi=unwrangle(phi);
theta=unwrangle(theta);
%Do nothing
  
function[A,B,theta,phi]=ellconv_xy2ab(X,Y,phix,phiy)
if nargin==2
  [X,Y,phix,phiy]=ellconv_xy2xy(X,Y);
end
[P,N,phip,phin]=ellconv_xy2pn(X,Y,phix,phiy);
[A,B,theta,phi]=ellconv_pn2ab(P,N,phip,phin);

function[X,Y,phix,phiy]=ellconv_ab2xy(A,B,theta,phi)
[P,N,phip,phin]=ellconv_ab2pn(A,B,theta,phi);
[X,Y,phix,phiy]=ellconv_pn2xy(P,N,phip,phin);

function[P,N,phip,phin]=ellconv_ab2pn(A,B,theta,phi)  
P=frac(A+B,2);
N=frac(A-B,2);

phip=unwrangle(phi+theta);
phin=unwrangle(phi-theta);

function[A,B,theta,phi]=ellconv_pn2ab(P,N,phip,phin)  
if nargin==2
  [P,N,phip,phin]=ellconv_pn2pn(P,N);
end

A=P+N;
B=P-N;

theta=unwrangle(phip/2-phin/2);
phi=  unwrangle(phip/2+phin/2);

function[X,Y,phix,phiy]=ellconv_pn2xy(P,N,phip,phin)
if nargin==2
  [P,N,phip,phin]=ellconv_pn2pn(P,N);
end

theta=unwrangle(phip/2-phin/2);
phi=  unwrangle(phip/2+phin/2);

X=sqrt(squared(P)+squared(N)+2.*P.*N.*cos(2*theta));
Y=sqrt(squared(P)+squared(N)-2.*P.*N.*cos(2*theta));

phixprime=imlog(P.*rot(theta)+N.*rot(-theta));
phiyprime=imlog(P.*rot(theta)-N.*rot(-theta))-pi/2;

phix=unwrangle(phi+phixprime);
phiy=unwrangle(phi+phiyprime);

function[P,N,phip,phin]=ellconv_xy2pn(X,Y,phix,phiy)
if nargin==2
  [X,Y,phix,phiy]=ellconv_xy2xy(X,Y);
end

phia=(phix+phiy+pi/2)/2;
phid=(phix-phiy-pi/2)/2;

P=frac(1,2)*sqrt(squared(X)+squared(Y)+2.*X.*Y.*cos(2*phid));
N=frac(1,2)*sqrt(squared(X)+squared(Y)-2.*X.*Y.*cos(2*phid));

phip=unwrangle(phia+imlog(X.*rot(phid)+Y.*rot(-phid)));
phin=unwrangle(phia+imlog(X.*rot(phid)-Y.*rot(-phid)));

function[]=ellconv_test

L=1000;
Xo=abs(randn(L,1));
Yo=abs(randn(L,1));
phixo=2*pi*rand(L,1);
phiyo=2*pi*rand(L,1);

tol=1e-6;

%XY to AB and back
[a,b,theta,phi]=ellconv(Xo,Yo,phixo,phiyo,'xy2ab');
[X,Y,phix,phiy]=ellconv(a,b,theta,phi,'ab2xy');
mat=[X Y angle(rot(phix)) angle(rot(phiy))];

mato=[Xo Yo angle(rot(phixo)) angle(rot(phiyo))];
bool(1)=aresame(mat,mato,tol);

%XY to PN and back
[P,N,phip,phin]=ellconv(Xo,Yo,phixo,phiyo,'xy2pn');
[X,Y,phix,phiy]=ellconv(P,N,phip,phin,'pn2xy');
mat=[X Y angle(rot(phix)) angle(rot(phiy))];

mato=[Xo Yo angle(rot(phixo)) angle(rot(phiyo))];
bool(2)=aresame(mat,mato,tol);
                 
%XY to AB to PN and back
[a,b,theta,phi]=ellconv(Xo,Yo,phixo,phiyo,'xy2ab');
[P,N,phip,phin]=ellconv(a,b,theta,phi,'ab2pn');
[a,b,theta,phi]=ellconv(P,N,phip,phin,'pn2ab');
[X,Y,phix,phiy]=ellconv(a,b,theta,phi,'ab2xy');

mato=[Xo Yo angle(rot(phixo)) angle(rot(phiyo))];
bool(3)=aresame(mat,mato,tol);

%XY to PN to AB and back
[P,N,phip,phin]=ellconv(Xo,Yo,phixo,phiyo,'xy2pn');
[a,b,theta,phi]=ellconv(P,N,phip,phin,'pn2ab');
[P,N,phip,phin]=ellconv(a,b,theta,phi,'ab2pn');
[X,Y,phix,phiy]=ellconv(P,N,phip,phin,'pn2xy');

mato=[Xo Yo angle(rot(phixo)) angle(rot(phiyo))];
bool(4)=aresame(mat,mato,tol);

reporttest('ELLCONV four-parameter conversions', all(bool)); 

clear bool

%XY to XY 
[X,Y,phix,phiy]=ellconv(Xo.*rot(phixo),Yo.*rot(phiyo),'xy2xy');

mato=[Xo Yo angle(rot(phixo)) angle(rot(phiyo))];
bool(1)=aresame(mat,mato,tol);

%XY to PN to PN and back 
[X,Y,phix,phiy]=ellconv(Xo.*rot(phixo),Yo.*rot(phiyo),'xy2xy');
[P,N,phip,phin]=ellconv(Xo,Yo,phixo,phiyo,'xy2pn');
[P,N,phip,phin]=ellconv(P.*rot(phip)/sqrt(2),N.*rot(phin)/sqrt(2),'pn2pn');
[X,Y,phix,phiy]=ellconv(P,N,phip,phin,'pn2xy');

mato=[Xo Yo angle(rot(phixo)) angle(rot(phiyo))];
bool(2)=aresame(mat,mato,tol);

reporttest('ELLCONV two-parameter conversions', all(bool)); 
