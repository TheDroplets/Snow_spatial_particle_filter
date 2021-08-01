function[y]=slidetrans(x,w,fs)
%SLIDETRANS  Sliding-window ('moving-window') Fourier transform.
%   
%   Y=SLIDETRANS(X,W,FS) computes the sliding-window Fourier transform of
%   the signal X using window W at frequencies FS. X and W are column
%   vectors.  Y is a matrix of size LENGTH(X) by LENGTH(FS).
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details  

if strcmp(x,'--f')
  slidetrans_fig;return
end
if strcmp(x,'--t')
  slidetrans_test;return
end

%if ~aresame(diag(w'*w),ones(size(w,2),1),1e-8)
%  error(['Window W is not unit energy.'])
%end

M=size(x,1);
N=size(x,2);

Mf=length(fs);
Mw=size(w,1);
K=size(w,2);

if nargin<3
  fs=[nmin-1:nmax-1]./Mw;
end
  
t=[0:M-1]';
%t=t-mean(t);
tw=[0:Mw-1]';
tw=tw-mean(tw);

%Make a wavelet
psi=zeros(Mw,Mf,K);
for j=1:Mf
  for k=1:K
    psi(:,j,k)=w(:,k).*rot(2*pi*tw*fs(j));
  end
end

%Pad psi to same length as x for passing to wavetrans
psi=[zeros(floor(M/2-Mw/2),Mf,K);psi;zeros(ceil(M/2-Mw/2),Mf,K)];

y=wavetrans(x,psi,'zeros');

for j=1:Mf
  for k=1:K
    y(:,j,k)=y(:,j,k).*rot(-2*pi*t*fs(j)) ;
  end
end
  
function[]=slidetrans_test

 N=501;
w=hermfun([-N:N]'./(N/4),1);
%w=w./sqrt(w'*w);
w=w./sum(w);
M=3001;
t=[0:M-1]';
x=rot(2*pi*t./70);
y=slidetrans(x,w,1./70);
bool(1)=aresame(angle(y(N:M-N)),0*[N:M-N]',1e-6);
bool(2)=aresame(abs(y(N:M-N)),1+0*[N:M-N]',1e-5);
reporttest('SLIDETRANS complex sinusiod',all(bool))

function[]=slidetrans_fig
  
M=3000;
t=[0:M-1]';t=t-M/2;
N=500;
w=hermfun([-N:N]'./(N/4),1);
w=w./sqrt(w'*w);
fs=[1:30]./1000;
clear x
x(1:M/2,1)=sin(2*pi*t(1:M/2)./70/3);
x(M/2:M,1)=sin(2*pi*t(M/2:M)./70);
y=slidetrans(x,w,fs);
h=wavespecplot(t,x,1./fs,abs(y),1/2);
hlines(70*3),hlines(70)


% x=testseries(6);
% N=2000;
% w=hermfun([-N:N]'./(N/4),4);
% for i=1:size(w,2)
%   w(:,i)=w(:,i)./sqrt(w(:,i)'*w(:,i));
% end
% fs=[0:0.5:30]./length(x);
% y=slidetrans(x,w,fs);
% t=[0:length(x)-1]';
% jimage(t,fs,abs(y)'),shading interp,flipy
% jimage(t,fs,mean(abs(y(:,:,1:4)),3)'),shading interp,flipy
% contourf(t,fs,abs(y)',20),nocontours,flipy
