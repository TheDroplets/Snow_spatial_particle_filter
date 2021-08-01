function[z]=ellipseplot(varargin)
%ELLIPSEPLOT Plot ellipses.
%
%   ELLIPSEPLOT(A,B,TH,X,AR) plots an ellipse of major axis A, minor
%   axis B, and orientation TH at complex-valued location X, rescaled
%   by aspect ratio AR for plotting purposes.
%
%   AR is optional and defaults to 1. 
%
%   Also, X is optional and defaults to 0+sqrt(-1)*0.  
%
%   Multliple ellipses are plotted if A, B, TH, and X, are arrays of the
%   same size. If A, B, and TH are arrays but X is not, X is used as a
%   complex-valued offset in between ellipses, beginning at 0.   
%
%   ELLIPSEPLOT(A,B,TH, ... ,'phase',PHI) optionally draws a small line, 
%   like a clock hand, to indicate the ellipse phase PHI.
%
%   ELLIPSEPLOT(A,B,TH, ... ,'axis') alternatively draws the major axis.   
%
%   Usage: ellipseplot(a,b,th)
%          ellipseplot(a,b,th,x)
%          ellipseplot(a,b,th,x,ar)
%          ellipseplot(a,b,th,x,'axis')
%          ellipseplot(a,b,th,x,ar,'phase',phi)
%
%   'ellipseplot --f' generates a sample figure.
%   ______________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        

a=varargin{1};

if strcmp(a,'--f')
  ellipseplot_fig;return
end

%/********************************************************
%Sort out input arguments
b=varargin{2};
th=varargin{3};
ar=1;
x=zeros(size(a));
phi=zeros(size(a));

na=length(varargin);

baxis=0;
if isstr(varargin{end})
  if strcmp(varargin{end},'axis')
      na=na-1;
      baxis=1;
      varargin=varargin(1:end-1);
  end
elseif isstr(varargin{end-1})
  if strcmp(varargin{end-1},'phase')
      phi=varargin{end};
      na=na-2;
  end
end


if na>3
  x=varargin{4};
end

if na>4
  ar=varargin{5};
  if length(ar)>1
    error('The aspect ratio AR must have unit length')
  end
end
%\********************************************************


%/********************************************************
%make things the right size
a=a(:);
b=b(:);
th=th(:);
x=x(:);

N=max([length(a),length(th),length(x)]);


if length(x)==1 & N>1
    x=exp(sqrt(-1)*angle(x)).*conj([0:abs(x):(N-1)*abs(x)]');    
end

%\********************************************************

z1=[0:.1:2*pi+.1]';
z1=exp(sqrt(-1)*z1);
 
if ~allall(phi==0)
  z1=[0+sqrt(-1)*0;z1];
end

if baxis
  z1=[-1+sqrt(-1)*0;0+sqrt(-1)*0;z1];
end

x=osum(0*z1,x);
z=osum(z1,0*th);
z=circ2ell(z,a,b,th,phi,ar)+x;


z=plot(z,'k');

if nargout==0
  clear z
end

function[z]=circ2ell(z,a,b,th,phi,ar)
%CIRC2ELL  Converts a complex-valued circle into an ellipse.
%
%   ZP=CIRC2ELL(Z,A,B,TH,PHI) where Z is a complex-valued time series,
%   performs a combined phase-lag, stretching, and rotation of Z.  
%  
%   If Z is a circle expressed as a complex-valued time series,
%   e.g. as output by PHASECIRCLE, TH and PHI are angles in radians,
%   and A and B are real-valued weighting factors, CIRC2ELL transforms
%   Z into an ellipse specified by ZP.
%  
%   This ellipse has major axis A and minor axis B, with the major
%   axis oriented at angle TH measured counterclockwise with respect
%   to the positive real axis.  If the phase at temporal midpoint of Z
%   is zero, than the ellipse has phase PHI at the midpoint.
%
%   The input arguments TH, A, B, and PHI may each be scalars or arrays
%   of the same size as Z.
%
%   ZP=CIRC2ELL(... AR) optionally rescales the ellipse by aspect ratio
%   AR for plotting purposes.
%
%   See Lilly (2005) for algorithm details.
%
%   See also ELLIPSEPLOT, PHASECIRCLE
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        


  
%   Use with PHASECIRCLE to plot polarization ellipses.
%
%   As an example,
%
%       w=slepwave(2.5,3,1,1,8/1024,8/1024);
%       w=w(:,1)/max(abs(w(:,1)));
%       z=circ2ell(phasecircle(0),pi/6,3,2,pi/4) ;
%       w=circ2ell(w,pi/6,3,2,pi/4); 
%       plot(z),hold on,plot(w),linestyle two,axis equal
%
%   creates a simplified version of Figure 5 of Lilly (2004).

  
  
if nargin==5
  ar=1;
end

rz=real(z);
iz=imag(z);

if isscal(a)
  a=a+0*z(1,:);
end

if isscal(b)
  b=b+0*z(1,:);
end

if isscal(th)
  th=th+0*z(1,:);
end

if isscal(phi)
  phi=phi+0*z(1,:);
end


for i=1:size(z,2)
  [rz(:,i),iz(:,i)]=vectmult(jmat(phi(i)),rz(:,i),iz(:,i));
  rz(:,i)=rz(:,i).*a(i);
  iz(:,i)=iz(:,i).*b(i);
  [rz(:,i),iz(:,i)]=vectmult(jmat(th(i)),rz(:,i),iz(:,i));
end

z=rz+sqrt(-1).*iz;

if ar~=1
  z=real(z)+ar.*sqrt(-1)*imag(z);
end



function[]=ellipseplot_fig

a=ones(10,1);
b=[1:10]'./10;
th=linspace(0,pi,10)';
x=linspace(0,1,10)'*20;
ellipseplot(a,b,th,x)
title('Counterclockwise rotating ellipse becoming circle')
set(gca,'dataaspectratio',[1 1 1])
