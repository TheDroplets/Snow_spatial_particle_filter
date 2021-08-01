function[a,b,th,phi,nu,ka,ecc]=normform(varargin)
%NORMFORM  Converts a complex-valued vector into "normal form".
%
%   [A,B,TH,PHI]=NORMFORM(U), where U is a 2x1 complex-valued
%   vector, returns the parameters which put that vector into "normal
%   form" as defined by Lilly (2004)
%
%        e^(i phi) .* jmat(th) * [a ib]' = u
%
%   where A and B are real valued with A>B.  A is then the major axis
%   and B the minor axis. 
%
%   [A,B,TH,PHI,NU,KA,ECC]=NORMFORM(U) also returns the "eccentricty 
%   angle"  NU=ATAN(B./A), the ellipse energy KA=SQRT(A.^2+B.^2), and 
%   the eccentricity ECC=SQRT(1-(B/A).^2).
%    
%   [A,B,TH,PHI]=NORMFORM(U1,U2), where U1 and U2 are complex-valued 
%   M x N arrays specifying MN different complex-valued 2-vectors U, 
%   returns M x N arrays which decompose all the U.
%
%   By default, TH is distributed from -pi to pi while ABS(PHI)<PI/2.
%   NORMFORM(...,'phi') instead reverses these limits, with PHI 
%   being distributed between -pi and pi.  
%
%   'normform --t' runs some tests.
%
%   Usage:  [a,b,th,phi]=normform(u);
%           [a,b,th,phi,nu,ka,ecc]=normform(u);
%           [a,b,th,phi]=normform(u1,u2); 
%           [a,b,th,phi,nu,ka,ecc]=normform(u1,u2); 
%           [a,b,th,phi,nu,ka,ecc]=normform(u1,u2,'phi'); 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(varargin{1},'--t')
  normform_test;return
end

bphi=0;
na=nargin;
if isstr(varargin{na});
   if strcmp(varargin{na},'phi')
      bphi=1;
      na=na-1;
   end
end

if na==1
    u=varargin{1};
    u1=u(1);
    u2=u(2);
    r1=abs(u1);
    r2=abs(u2);
    phi1=angle(u1);
    phi2=angle(u2);
    dphi=angle(u1.*conj(u2));
else
    u1=varargin{1};
    u2=varargin{2};
    r1=abs(u1);
    r2=abs(u2);
    phi1=angle(u1);
    phi2=angle(u2);
    dphi=angle(u1.*conj(u2));
end    

ue=real(u1);
uo=-1*imag(u1);
ve=real(u2);
vo=-1*imag(u2);

uu=r1.^2;
vv=r2.^2;

lambda=r1.^2+r2.^2;

chi=atan(r2./r1);

rat=2.*frac(uo.*ve-ue.*vo,uu+vv);

a=frac(1,sqrt(2)).*sqrt(1+sqrt(1-rat.^2));
b=frac(1,sqrt(2)).*sqrt(1-sqrt(1-rat.^2));
th=frac(1,2).*atan(frac(2.*ue.*ve+2.*uo.*vo,uu-vv));

%a=frac(1,sqrt(2)).*sqrt(1+sqrt(1-(sin(2.*chi).*sin(dphi)).^2));
%b=frac(1,sqrt(2)).*sqrt(1-sqrt(1-(sin(2.*chi).*sin(dphi)).^2));
%th=frac(1,2).*atan(tan(2.*chi).*cos(dphi));

index=find(~isfinite(th));
if ~isempty(index)
  th(index)=0;
end

%phi=phicomp_local(r1,r2,phi1,phi2,th);
phi=phicomp_local(ue,uo,ve,vo,th);

%/********************************************************
%Adjust for theta specifies minor axis
ap=rot(-phi).*(cos(th).*u1+sin(th).*u2);
bp=rot(-phi).*(-sin(th).*u1+cos(th).*u2);
index=find(abs(ap)<abs(bp));
if ~isempty(index)
    th(index)=th(index)+pi/2;
end
th=angle(rot(th));  %to keep in between +/- pi
%phi=phicomp_local(r1,r2,phi1,phi2,th);
phi=phicomp_local(ue,uo,ve,vo,th);
%\********************************************************

%/********************************************************
%Adjust for a<0
ap=rot(-phi).*(cos(th).*u1+sin(th).*u2);
bp=rot(-phi).*(-sin(th).*u1+cos(th).*u2);
index=find(ap<0);
%figure,plot(a,abs(ap),'o')
if ~isempty(index)
    th(index)=th(index)+pi;
end
th=angle(rot(th));  %to keep in between +/- pi
%phi=phicomp_local(r1,r2,phi1,phi2,th);
phi=phicomp_local(ue,uo,ve,vo,th);
%\********************************************************

%/********************************************************
%Adjust for sign of b
bp=rot(-phi).*(-sin(th).*u1+cos(th).*u2);
b=-b.*sign(imag(bp));
%\********************************************************


nu=atan(b./a); 

%/********************************************************
%Reversal of distributions
if bphi
  index=find(abs(th)>pi/2);
  if ~isempty(index)
    phi(index)=angle(rot(phi(index)-pi));
    th(index)=angle(rot(th(index)-pi));
  end
end
%\********************************************************

a=a.*sqrt(lambda);
b=b.*sqrt(lambda); 

if nargout>4
  nu=atan(b./a);
end
if nargout>5
  ka=sqrt(a.^2+b.^2);
end
if nargout>6
  ecc=sqrt(1-(b./a).^2);
end


function[phi]=phicomp_local(ue,uo,ve,vo,th)
num=uo.*cos(th)+vo.*sin(th);
denom=ue.*cos(th)+ve.*sin(th);
phi=-atan(frac(num,denom));


%function[phi]=phicomp_local(r1,r2,phi1,phi2,th)
%num=r1.*cos(th).*sin(phi1)+r2.*sin(th).*sin(phi2);
%denom=r1.*cos(th).*cos(phi1)+r2.*sin(th).*cos(phi2);
%phi=atan(frac(num,denom));

function[]=normform_test
M=100;
beta=rand(M,1)*pi-pi/2;  
phi1=rand(M,1)*2*pi-pi;
phi2=rand(M,1)*2*pi-pi;

r1=cos(beta);
r2=sin(beta);
u1=r1.*rot(phi1); 
u2=r2.*rot(phi2);
[a,b,th,phi]=normform(u1,u2);

[a2,b2,th2,phi2]=normform(u1,u2,'phi');


for i=1:M
  vtemp=jmat(-th(i))*[u1(i);u2(i)];
  v1(i,1)=vtemp(1);
  v2(i,1)=vtemp(2);
  %These are rotated into ellipse coordinates
end

tol=1e-5;
dphi2=angle(v1.*conj(v2));
b1=aresame(abs(dphi2),pi/2+0*dphi2,tol);
b2=aresame(a,abs(v1),tol);
b3=aresame(abs(b),abs(v2),tol);
b4=abs(phi-angle(v1))<tol|abs(phi+pi-angle(v1))<tol|abs(phi-pi-angle(v1))<tol;
disp(['NORMFORM testing ' int2str(M) ' random iterations'])

reporttest('NORMFORM delta phi = +/- pi/2',b1)
reporttest('NORMFORM a = |[J(th)*v](1)|',b2)
reporttest('NORMFORM b = |[J(th)*v](2)|',b3)
reporttest('NORMFORM phi = -angle([J(th)*v](1)) + n pi',b4)

u1b=0*u1;
u2b=0*u2;

for i=1:M
   uvect=rot(phi(i))*jmat(th(i))*[a(i); -sqrt(-1).*b(i)];
   u1b(i)=uvect(1);
   u2b(i)=uvect(2);
end

b=aresame(u1,u1b,tol)&aresame(u2,u2b,tol);
reporttest('NORMFORM exact normal form correspondence',b)

num=(r2.^2).*sin(2.*phi2)+(r1.^2).*sin(2.*phi1);
denom=(r2.^2).*cos(2.*phi2)+(r1.^2).*cos(2.*phi1);
phi2=frac(1,2).*atan(frac(num,denom));
phi2=angle(rot(phi2));
b5=abs(phi-phi2)<tol|abs(phi+pi/2-phi2)<tol|abs(phi-pi/2-phi2)<tol;
%reporttest('NORMFORM phase phi vs. Park et al. (1987)',b5)

%/********************************************************
beta=rand(M,1)*pi/2;
a0=cos(beta);
b0=sin(beta);

%make sure top one is larger
index=find(b0>a0);
temp=a0(index);
a0(index)=b0(index);
b0(index)=temp;

th0=rand(M,1)*2*pi;th0=angle(rot(th0));  
phi0=(rand(M,1)*pi-pi/2);  %only defined to +/- 90

%Random rotation 
wu=cos(th0).*a0-sqrt(-1).*sin(th0).*b0;
wv=sin(th0).*a0+sqrt(-1).*cos(th0).*b0;
[a,b,th,phi]=normform(wu,wv); 
b1=aresame(a,a0,tol)&aresame(abs(b),abs(b0),tol);
b2=aresame(th,th0,tol);
reporttest('NORMFORM random rotations',b1&b2);

%Random phase shift
wu=rot(phi0).*wu;
wv=rot(phi0).*wv;
[a,b,th,phi]=normform(wu,wv); 
b1=aresame(a,a0,tol)&aresame(abs(b),abs(b0),tol);
b2=aresame(th,th0,tol);
b3=aresame(phi,phi0,tol);
reporttest('NORMFORM random rotations and phase shifts',b1&b2&b3);
%********************************************************

