function [w,W]=morlwave(N,fs,m)
%MORLWAVE  Morlet wavelet.   
%  
%   PSI=MORLWAVE(N,F,M) returns the complex-valued Morlet wavelet of
%   length N, concentrated at *cyclic* frequency F, and having M 
%   periods between the two inflection points of the Gaussian envelope.
%  
%   If F is a scalar, PSI is a column vector of length M.  If F is an
%   array, PSI is a matrix of size M x LENGTH(F), with the columns in  
%   order of decreasing frequency.
%
%   Note that the wavelets are centered at the midpoint in time, row 
%   number ROUND(SIZE(PSI,1)/2).
%
%   [PSI,PSIF]=MORLWAVE(N,F,M) also returns a size SIZE(PSI) matrix 
%   PSIF which is the frequency-domain version of the wavelets.
%
%   Usage: psi=morlwave(n,f,m);
%          [psi,psif]=morlwave(n,f,m);  
%
%   'morlwave --t' runs a test
%   'morlwave --f' generates a sample figure
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2005 F. Rekibi and J. M. Lilly 
%                         --- type 'help jlab_license' for details  

% 02.09.04  JML fixed sample figure
  
if strcmp(N,'--t')
    morlwave_test;return
end

if strcmp(N,'--f')
    morlwave_fig;return
end

%/********************************************************
%Enforce convention of high frequencies first
fs=fs(:);
if length(fs)>1
  if fs(2)-fs(1)>0
    fs=flipud(fs);
  end
end
%\********************************************************


for i=1:length(fs)
 [w(:,i),t,sigma(1,i)]= morlwave1(N,fs(i),m);
end

wshifted=0*w;
for i=1:size(w,2)
  wshifted(:,i)=fftshift(w(:,i));
end
W=fft(wshifted);

%---------------------------------------------------------------

function  [w,t,sigma]=morlwave1(N,fs,m)
sigma=m./(sqrt(2).*fs); 
t=[1:N]';   % Choose dt = 1
t=t-mean(t);

env=exp(-2.*((t.*fs).^2)./m.^2);
w1=env.*rot(2.*pi.*fs.*t);
w=w1-frac(mean(w1),mean(env)).*env;
%w=w1.*exp(-exp(-(2.*pi.*fs).^2/2));
c1=(sum(abs(w).^2)^(1/2)); 
w=w./c1; 


%---------------------------------------------------------------

function []= morlwave_test
  
N=200; % nombre de points
m=1/2;
fs=flipud(logspace(log10(10./N),log10(60./N),10)');   %change to log space
[w,W]=morlwave(N,fs,m);
t=1:length(w);
t=t-mean(t);

tol=1e-10;

b=aresame(mean(w,1),0*w(1,:),tol);
reporttest('MORLWAVE zero mean',b)

b=aresame(sum(abs(w).^2,1),1+0*w(1,:),tol);
reporttest('MORLWAVE unit energy',b)


function []= morlwave_fig
N=200; % nombre de points
m=2;
fs=flipud(logspace(log10(6./N),log10(60./N),10)');   %change to log space
[w,W]=morlwave(N,fs,m);
t=1:length(w);
t=t-mean(t);

f=[0:N-1]'./N;
index=find(f>1/2);
f(index)=f(index)-1;

figure,
subplot(221)
plot(t,abs(w))
title('Modulus of Morlet wavelets in time')

subplot(222)
plot(f,abs(W)),vlines(fs)
title('Modulus of Morlet wavelets in frequency')

subplot(223)
for i=1:size(w,2)
  t1=t.*fs(i);
  plot(t1,real(w(:,i))./max(abs(w(:,i))),'b.'),hold on
  plot(t1,imag(w(:,i))./max(abs(w(:,i))),'g.'),hold on
end
axis([-3.5 3.5 -1 1])
title('Stretched and rescaled Morlet wavelets')

i=5;
subplot(2,2,4)
uvplot(t,w(:,i)),hold on,
plot(t,abs(w(:,i)),'r');
dw=diff(abs(w(:,i)));
index=find(dw==max(dw)|dw==min(dw));
vlines(t(index),'k--')
title(['Morlet wavelet with m=' int2str(m)])
axis([-40 40 -.4 .4])

if 0
  plotdwv(w,'Morlet');
end




