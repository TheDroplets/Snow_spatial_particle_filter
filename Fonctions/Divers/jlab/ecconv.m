function[varargout]=ecconv(varargin)
%ECCONV  Convert between eccentricty measures.
%  
%   Y=ECCONV(X,STR) converts the eccentricity measure X into eccentricity
%   measure Y as specified by the string STR. 
%  
%   STR is of the form 'in2out' where the names 'in' and 'out' may be any 
%   of the following
%  
%      'ecc'       The eccentricity (epsilon) 
%      'ell'       The ellipticity (b/a)
%      'lam'       The ellipse parameter (lambda)
%      'nu'        The eccentricity angle (nu)
%      'rot'       The rotary ratio (alpha)
% 
%   where "a" and "b" are the semi-major and semi-minor axes respective. 
%   For example, ECC=ECCONV(LAMBDA,'lam2ecc') converts the ellipse 
%   parameter LAMBDA into eccentricity ECC.  
%   ____________________________________________________________________
%
%   Rotation direction 
%
%   Note that b>0 denotes mathematically positive rotation, while b<0 
%   denotes mathematically negative rotation.  Similarly the sign of 
%   all other eccentricity measures denotes the direction of rotation.
%   This behavior does not apply to purely circular (zero eccentricity) 
%   signals.
%   ____________________________________________________________________
%
%   Definitions
%
%   The eccentricity measures are defined in terms of the semi-major 
%   and semi-minor axes as 
%
%       ecc = sgn(b) * sqrt(1 - b^2/a^2)
%       ell = b/a
%       lam = sgn(b) (a^2 - b^2) / (a^2 + b^2) 
%       nu  = asin( b / sqrt(a^2 + b^2))
%       rot = sgn(b) * (a - abs(b))/(a + abs(b))
%
%   For further details, see Lilly and Gascard (2006).
%   ____________________________________________________________________
%
%   See also ELLCONV, ELLDIFF, TRANSCONV. 
%
%   Usage:   lam=ecconv(b./a,'ell2lam');
%            ecc=ecconv(lam,'lam2ecc');
%
%   'ecconv --t' runs a test.
%   'ecconv --f' generates a sample figure.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details        
 
    
if strcmp(varargin{1}, '--t')
  ecconv_test,return
end
if strcmp(varargin{1}, '--f')
  ecconv_fig,return
end
  
if nargin==2
  x=varargin{1};
  str=varargin{2};
  ecconv_checkstr(str);
  sizex=size(x);
  x=x(:);
  eval(['y=' str '(x);'])
  y=reshape(y,sizex); 
  varargout{1}=y;
elseif nargin==3
  x1=varargin{1};
  x2=varargin{2};
  str=varargin{3};
  ecconv_checkstr(str);
  eval(['[y1,y2]=' str '(x1,x2);'])
  varargout{1}=y1;
  varargout{2}=y2;
end

function[]=ecconv_checkstr(str)
ii=findstr(str,'2');
if isempty(ii)
  error(['STR should be of the form ''ecc2lam''.'])
end
str1=str(1:ii-1);
str2=str(ii+1:end);

if ~aresame(str1,'nu')&~aresame(str1,'ecc')&~aresame(str1,'lam')&~ ...
      aresame(str1,'rot')&~aresame(str1,'ell')
  error(['Input parameter name ' str1 ' is not supported.'])
end
if ~aresame(str2,'nu')&~aresame(str2,'ecc')&~aresame(str2,'lam')&~ ...
      aresame(str2,'rot')&~aresame(str2,'ell')
  error(['Output parameter name ' str2 ' is not supported.'])
end

function[nu]=ell2nu(ell)
nu=atan(ell);
function[ell]=nu2ell(nu)
ell=tan(nu);
function[ecc]=ell2ecc(ell)
ecc=nu2ecc(ell2nu(ell));
function[ell]=ecc2ell(ecc)
ell=nu2ell(ecc2nu(ecc));
function[rot]=ell2rot(ell)
rot=nu2rot(ell2nu(ell));
function[ell]=rot2ell(rot)
ell=nu2ell(rot2nu(rot));
function[lam]=ell2lam(ell)
lam=nu2lam(ell2nu(ell));
function[ell]=lam2ell(lam)
ell=nu2ell(lam2nu(lam));

function[ecc]=nu2ecc(nu)
ecc=sign(nu).*sqrt(1-squared(tan(nu)));
vindexinto(ecc,1,find(nu==0),1);
vindexinto(ecc,0,find(abs(nu)==pi/4),1);

function[nu]=ecc2nu(ecc)
nu=sign(ecc).*atan(sqrt(1-squared(ecc)));
vindexinto(nu,pi/4,find(ecc==0),1);

function[lambda]=nu2lam(nu)
lambda=sign(nu).*cos(2*nu);
vindexinto(lambda,1,find(nu==0),1);
vindexinto(lambda,0,find(abs(nu)==pi/4),1);

function[nu]=lam2nu(lambda)
nu=sign(lambda).*atan(sqrt(frac(1-abs(lambda),1+abs(lambda))));
vindexinto(nu,pi/4,find(lambda==0),1);

function[alpha]=nu2rot(nu)
alpha=sign(nu).*frac(1-abs(tan(nu)),1+abs(tan(nu)));
vindexinto(alpha,1,find(nu==0),1);
vindexinto(alpha,0,find(abs(nu)==pi/4),1);

function[nu]=rot2nu(alpha)
nu=sign(alpha).*atan(frac(1-abs(alpha),1+abs(alpha)));
vindexinto(nu,pi/4,find(alpha==0),1);

function[ecc]=lam2ecc(lambda)
ecc=sign(lambda).*sqrt(frac(2*abs(lambda),1+abs(lambda)));
vindexinto(ecc,0,find(lambda==0),1);

function[lambda]=ecc2lam(ecc)
lambda=sign(ecc).*frac(squared(ecc),2-squared(ecc));
vindexinto(lambda,0,find(ecc==0),1);

function[alpha]=lam2rot(lambda)
alpha=nu2rot(lam2nu(lambda));
vindexinto(alpha,0,find(lambda==0),1);

function[lambda]=rot2lam(alpha)
lambda=nu2lam(rot2nu(alpha));
vindexinto(lambda,0,find(alpha==0),1);

function[alpha]=ecc2rot(ecc)
alpha=nu2rot(ecc2nu(ecc));
vindexinto(alpha,0,find(ecc==0),1);

function[ecc]=rot2ecc(alpha)
ecc=nu2ecc(rot2nu(alpha));
vindexinto(ecc,0,find(alpha==0),1);
  
function[x]=rot2rot(x)
function[x]=nu2nu(x)
function[x]=ecc2ecc(x)
function[x]=lam2lam(x)
function[x]=ell2ell(x)

 
%/********************************************************
function[]=ecconv_test
str{1}='nu';
str{2}='ecc';
str{3}='lam';
str{4}='rot';
str{5}='ell';

x=rand(100,1)*2-1;
x(end+1,1)=1;  %Add an exact one
x(end+1,1)=0;  %Add an exact zero

clear y z x2 bool

%Turn lambda into all others
for i=1:length(str)
  y(:,i)=ecconv(x,['lam2' str{i}]);
end

%Turn all others into everything else
for i=1:length(str)
  for j=1:length(str)
     z(:,i,j)=ecconv(y(:,i),[str{i} '2' str{j}]);
  end
end

%Turn everything back into lambda
for i=1:length(str)
  for j=1:length(str)
     x2(:,i,j)=ecconv(z(:,i,j),[str{j} '2lam']);
  end
end

for i=1:size(x2,2)
  for j=1:size(x2,2)
    bool(i,j)=aresame(squeeze(x2(:,i,j)),x,1e-14);
  end
end

reporttest('ECCONV', allall(bool))
%\********************************************************


function[]=ecconv_fig

lambda=[0:.001:1]';

ecc=ecconv(lambda,'lam2ecc');
alpha=ecconv(lambda,'lam2rot');
ecc1=sqrt(2)*sqrt(lambda);
alpha1=lambda/2;

plot(lambda,[ecc,alpha,ecc1,alpha1]);
linestyle k 2k k-- 2k--
axis([0 1 0 1]),axis square 
text(0.4,0.7,'\epsilon')
text(0.7,0.5,'\alpha')
title('Eccentricity measures')
xlabel('Ellipse parameter \lambda')
ylabel('Eccentricity \epsilon or rotary ratio \alpha')
set(gcf,'paperposition', [2 2 3.5 3.5])
xtick(.1),ytick(.1),fixlabels(-1)
fontsize 14 14 14 14
%fontsize jpofigure
%cd_figures
%print -deps eccenparams.eps
%plot(ecc,[lambda ecc,alpha,ecc1,alpha1]);


function[kappa,lambda]=ab2kl(a,b)
kappa=frac(1,sqrt(2))*sqrt(squared(a)+squared(b));
lambda=sign(b).*frac(squared(a)-squared(b),squared(a)+squared(b));

function[kappa,nu]=ab2kn(a,b)
kappa=frac(1,sqrt(2))*sqrt(squared(a)+squared(b));
nu=atan(frac(b,a));

function[a,b]=kn2ab(kappa,nu)
a=cos(nu).*kappa*sqrt(2);
b=sin(nu).*kappa*sqrt(2);

function[a,b]=kl2ab(kappa,lambda)
a=kappa.*sqrt(1+abs(lambda));
b=sign(lambda).*kappa.*sqrt(1-abs(lambda));

function[nu]=ab2nu(a,b)
nu=atan(frac(b,a));

