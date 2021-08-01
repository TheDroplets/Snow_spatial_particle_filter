function[o1,o2,o3,o4]=elldiff(varargin)
%ELLDIFF  Ellipse differentiation.
%
%   Given the properties of a time-varying elliptical signal, ELLDIFF 
%   finds the ellipse properties of the time derivative of that signal.  
% 
%   [A2,B2,TH2,PHI2]=ELLDIFF(A,B,TH,PHI) where the input arguments
%   specify a time-varying ellipse of the complex-valued time series 
%   Z=X+iY, returns the ellipse parameters for the associated time-
%   varing ellipse of the first central difference of Z.  
%
%   The input and output varibable specify an ellipse in 'semi-major / 
%   semi-minor axis' form.  See ELLCONV for details. 
%    
%   [...]=ELLDIFF(...,DT) optionally specifies a time-step of DT
%   (default=1) for the differentiation. 
%
%   [...]=ELLDIFF(...,DT,FACT) optionally multiplies the output
%   amplitudes by the scale factor FACT (default=1), e.g. for a units
%   conversion from kilometers into centimeters.
%  
%   [Y1,Y2,Y3,Y4]=ELLDIFF(X1,X2,X3,X4,STR) specifies that the ellipse
%   is represented in the format STR in both the input and the output
%   variables.  STR may be 'ab', 'xy', or 'pn'; see ELLCONV for details.  
%
%   See also ELLCONV.
% 
%   Usage:  [a2,b2,theta2,phi2]=elldiff(a,b,theta,phi);
%           [a2,b2,theta2,phi2]=elldiff(a,b,theta,phi,4*3600,1e5);
%
%   'elldiff --t' runs a test
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    

  
if strcmp(varargin{1}, '--t')
  elldiff_test,return
end

%/********************************************************
%Sort out input arguments
i1=varargin{1};
i2=varargin{2};
i3=varargin{3};
i4=varargin{4};

str='ab';
if nargin>4
  if isstr(varargin{5})
    str=varargin{5};
  end
end
elldiff_checkstr(str);
 
dt=1;
fact=1;
if length(varargin{end})==1&length(varargin{end-1})==1
  dt=varargin{end-1};
  fact=varargin{end};
elseif length(varargin{end})==1&length(varargin{end-1})~=1
  dt=varargin{end};
end

%\********************************************************

eval(['[o1,o2,o3,o4]=elldiff_' str '(i1,i2,i3,i4,dt,fact);'])


function[]=elldiff_checkstr(str)

if ~aresame(str,'ab')&~aresame(str,'pn')&~aresame(str,'xy')
  error(['Input parameter name ' str ' is not supported.'])
end


function[P2,N2,phip2,phin2]=elldiff_pn(P,N,phip,phin,dt,fact)

eps=1e-10;
vswap(P,0,eps);
vswap(N,0,eps);

P2=fact*P.*sqrt(squared(frac(1,dt)*vdiff(log(P),1))+squared(frac(1,dt)*vdiff(phip,1)));
N2=fact*N.*sqrt(squared(frac(1,dt)*vdiff(log(N),1))+squared(frac(1,dt)*vdiff(phin,1)));
phip2=unwrangle(phip+imlog(frac(1,dt)*vdiff(log(P),1)+sqrt(-1)*(frac(1,dt)*vdiff(phip,1))));
phin2=unwrangle(phin+imlog(frac(1,dt)*vdiff(log(N),1)+sqrt(-1)*(frac(1,dt)*vdiff(phin,1))));

function[A2,B2,theta2,phi2]=elldiff_ab(A,B,theta,phi,dt,fact)
[P,N,phip,phin]=ellconv(A,B,theta,phi,'ab2pn');
[P2,N2,phip2,phin2]=elldiff_pn(P,N,phip,phin,dt,fact);
[A2,B2,theta2,phi2]=ellconv(P2,N2,phip2,phin2,'pn2ab');

function[U2,V2,phiu2,phiv2]=elldiff_xy(U,V,phiu,phiv,dt,fact)
[P,N,phip,phin]=ellconv(U,V,phiu,phiv,'xy2pn');
[P2,N2,phip2,phin2]=elldiff_pn(P,N,phip,phin,dt,fact);
[U2,V2,phiu2,phiv2]=ellconv(P2,N2,phip2,phin2,'pn2xy');


function[x]=makellipse1(a,b,theta,phi)
x=rot(theta).*(a.*cos(phi)+sqrt(-1)*b.*sin(phi));


function[]=elldiff_test
a=1;
b=[0:.05:1];
phi=[0:.01:2*pi-0.01]';

clear xi1 xi2
for i=1:length(b)
   [a2,b2,th2,phi2]=elldiff(a+0*phi,b(i)+0*phi,0*phi,phi);
   xi1(:,i)=vdiff(makellipse1(a,b(i),0,phi));
   xi2(:,i)=makellipse1(a2,b2,th2,phi2);
end

%Put nans in same places
index=find(isnan(xi1)|isnan(xi2));
xi1(index)=nan;
xi2(index)=nan;

reporttest('ELLDIFF',aresame(xi1(2:end-1,:),xi2(2:end-1,:),1e-6));
