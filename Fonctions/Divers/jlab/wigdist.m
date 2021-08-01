function[d,f]=wigdist(x,nmin,nmax,N2,s)
% WIGDIST  Wigner distribtion (alias-free).
%
%   D=WIGDIST(X,NMIN,NMAX) returns the Wigner distrution of column
%   vector X at frequencies [NMIN/N:1/N:NMAX/N] where N is LENGTH(X).
%   D is a matrix of dimension LENGTH(X) x [NMAX-NMIN+1].
%  
%   D=WIGDIST(X,NMIN,NMAX,M) first zero-pads the data to length M,
%   where M>LENGTH(X). The Wigner distrution is then computed at
%   frequencies [NMIN/M:1/M:NMAX/M].  This is to give higher frequency
%   resolution.  
%
%   WIGDIST uses the alias-free Wigner distribution algorithm given in
%   Matllat (1999), second edition, section 4.5.4.
%
%   Usage:  [d,f]=wigdist(x,nmin,nmax);
%           [d,f]=wigdist(x,nmin,nmax,m);
%
%   'wigdist --t' runs a test using two different algorithms
%   'wigdist --f' generates a sample figure
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
 


  
if strcmp(x,'--t')
   wigdist_test;return
end

if strcmp(x,'--f')
   wigdist_figure;return
end
   
x=x(:);

N=length(x);
if isodd(N)
   error('The length M of X must be even.')
end

%/********************************************************
%Zero-pad to increase frequency resolution
if nargin==4
  if isodd(N2)
    error('The new length M must be even.')
  end
   x=[zeros(N2/2-N/2,1);x;zeros(N2/2-N/2,1)];
end
%\********************************************************

N=length(x);

%Frequency vector
k=[nmin:nmax]';
f=k./N;

if nargin<5
  s=2;  %Default to fast Fourier algorithm
end

if s==1
  %Use slow but obvious algorithm
  d=wigdist_version1(x,k);
elseif s==2
  %Use fast fourier-based algorithm (default)
  d=wigdist_version2(x,k);
end

%END wigdist body

tol=1e-12;
if maxmax(abs(imag(d))<tol)
  d=real(d);
end

%/********************************************************
function[d]=wigdist_version1(x,k);
%disp('Computing Wigner distribtution, summation algorithm');
N=length(x);
M=length(k);

f=doublen(x);

%Time index
n=[0:N-1]';
freqs=k./N;

%Dummy index of summation
p=[0:2*N-1]';
p=permute(p,[3 2 1]);

%Make 3-D n index varying along columns
nmat=ndrep(M,n,2);
nmat=ndrep(2*N,nmat,3);

%Make 3-D k index varying along rows
kmat1=ndrep(N,k',1);
kmat1=ndrep(2*N,kmat1,3);

%Make 3-D p index varying along pages
pmat1=ndrep(N,p,1);
pmat1=ndrep(M,pmat1,2);

%Plus one corrects for index change
index1=2*nmat+pmat1-N+1;
index2=2*nmat-pmat1+N+1;

%Locate points in range
bool=(index1>0)&(index1<2*N+1)&(index2>0)&(index2<2*N+1);
index=find(bool);

f1=f(index1(index));
f2=f(index2(index));
kk=kmat1(index);
pp=pmat1(index);

%Map in range values into gmat
phi=-frac(2.*pi.*(2.*kk).*pp,2.*N);
gmat=zeros(N,M,2*N);
gmat(index)=f1.*conj(f2).*rot(phi);

%Sum over third dimension 
d=sum(gmat,3);
%END version 1
%\********************************************************


%/********************************************************
function[d]=wigdist_version2(x,k);
%disp('Computing Wigner distribtution, Fourier algorithm');
N=length(x);
M=length(k);

f=doublen(x);

%Time index
n=[0:N-1];

%Dummy index of summation
p=[0:2*N-1]';

%Make 2-D n index varying along rows
nmat=ndrep(2*N,n,1);

%Make 2-D p index varying along columns
pmat1=ndrep(N,p,2);

%Plus one corrects for index change
index1=2*nmat+pmat1-N+1;
index2=2*nmat-pmat1+N+1;

%Locate points in range
bool=(index1>0)&(index1<2*N+1)&(index2>0)&(index2<2*N+1);
index=find(bool);

f1=f(index1(index));
f2=f(index2(index));

%Map in range values into gmat
gmat=zeros(2*N,N);
gmat(index)=f1.*conj(f2);

%Now fft, decimate, transpose
d=fft(gmat);
d=d(2*k+1,:);  %not 2k because fft computes at deltaf=1/(2*T)
d=conj(d)';
%END version 2
%\********************************************************

function[]=wigdist_test

[x,lambda,f]=slepwave(2,2.5,1,1,.05,.05); 

[d1,f]=wigdist(x(:,1),0,20,3*length(x),1);
[d2,f]=wigdist(x(:,1),0,20,3*length(x),2);

t=1:size(d1,1);t=t-mean(t);
tol=1e-10;
b=aresame(d1,d2,tol);
reporttest('WIGDIST two different algorithms match',b);



function[]=wigdist_figure

[x,lambda,f]=slepwave(2,2.5,1,1,.05,.05); 
[d,f]=wigdist(x(:,1),1,40,5*length(x));
t=1:size(d,1);t=t-mean(t);

figure
subplot(121)
pcolor(t,log10(1./f),abs(d')),shading interp,flipy
hlines(log10(1./.05)),vlines(0)
ylabel('Log10 Scale = Log10 1/f = -Log10 f')
title('Wigdist of Slepwave 1')
axis([-30 30 1 1.7])
subplot(122)
pcolor(t,log10(1./f),log10(abs(d'))),shading interp, flipy 
caxis([-4 .2])
hlines(log10(1./.05)),vlines(0)
ylabel('Log10 Scale = Log10 1/f = -Log10 f')
title('Log10 of Wigdist of Slepwave 1')
axis([-50 50 .8 2.4])

if 0
figure
contourf(t,f,log10(abs(d')),[-10:.5:0]),hold on
contour(t,f,log10(abs(d')),[-10:.5:0])
hlines(.05),vlines(0)

figure
contourf(t,f,log10(abs(d2')),[-10:.5:0]),hold on
contour(t,f,log10(abs(d2')),[-10:.5:0])
hlines(.05),vlines(0)

figure
surf(t,log10(1./f),log10(abs(d')))
hlines(log10(1./.05)),vlines(0)


figure,
contourf(t,log10(1./f),log10(abs(d')),[-10:.5:0]),hold on
contour(t,log10(1./f),log10(abs(d')),[-10:.5:0])
hlines(log10(1./.05)),vlines(0)

figure
contourf(t,f,log10(abs(d')),[-10:.5:0]),hold on
contour(t,f,log10(abs(d')),[-10:.5:0])
hlines(.05),vlines(0)

figure
contourf(t,f,abs(d'),20),hold on
contour(t,f,abs(d'),20)
hlines(.05),vlines(0)
end
