function[x,X]=morsewave(N,K,ga,be,fs);
% MORSEWAVE  Generalized Morse wavelets of Olhede and Walden (2002).
%
%   PSI=MORSEWAVE(N,K,GAMMA,BETA,F) returns an N x K column vector PSI 
%   which contains time-domain versions of the first K generalized Morse
%   wavelets specified by GAMMA and BETA, concentrated at frequency F.
%
%   The frequency F is specfically the *cyclic* frequency at which the 
%   Fourier transform of thelowest-order (K=1) wavelet has its maximum
%   amplitude, assuming a unit sample rate.  If F has length L, PSI is 
%   of size N x L x K, with the columns in order of decreasing frequency.
%
%   Note that the wavelets are centered at the midpoint in time, row 
%   number ROUND(SIZE(PSI,1)/2).
%  
%   [PSI,PSIF]=MORSEWAVE(...) optionally returns a frequency-domain
%   version PSIF of the wavelets, in a matrix of size SIZE(PSI).
%
%   Generalized Morse wavelets are described in Olhede and Walden
%   (2002), "Generalized Morse Wavelets", IEEE Trans. Sig. Proc., v50,
%   2661--2670.
%
%   Usage: psi=morsewave(N,K,ga,be,f);
%          [psi,psif]=morsewave(N,K,ga,be,f);
%
%   'morsewave --t' runs a test
%   'morsewave --f' generates a sample figure
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2005 F. Rekibi and J.M. Lilly 
%                         --- type 'help jlab_license' for details  
  
%Depricated 
%   [W,FS]=MORSEWAVE(...) also returns FS, a length L array.  At each
%   scale, FS gives the frequency at which the absolute value of the
%   lowest-order wavelet of is a maximum.
  
if strcmp(N,'--t')
  morsewave_test;return
end
if strcmp(N,'--f')
  morsewave_fig;return
end

if nargin<5
  fs=1;
end

%/********************************************************
%Enforce convention of small scales first
fs=fs(:);
if length(fs)>1
  if fs(1)-fs(2)<0
    fs=flipud(fs);
  end
end
%\********************************************************

for n=1:length(fs)
    [X(:,:,n),x(:,:,n)]=morsewave1(N,K,ga,be,fs(n));
end

if 0
  %Find frequency from peak in amplitude
  fo=[0:size(X,1)-1]./size(X,1);
  f=zeros(size(X,3),1);
  f(1)=fo(find(abs(X(:,1,1))==max(abs(X(:,1,1)))));
  f(2:end)=f(1).*so(1)./so(2:end);
else  
  %Find frequency from phase
  xtrunc=zeros(size(x));   %Avoid very small noise values when finding frequency
  index=find(abs(x)>1e-10);
  xtrunc(index)=x(index);
  f=squeeze(max(vdiff(unwrap(angle(xtrunc))),[],1)./2/pi)';
  if isvector(f)
    f=row2col(f);
  end
end



if size(x,3)>1
  x=permute(x,[1 3 2]);
  if nargout==2
    X=permute(X,[1 3 2]);
  end
end


function[X,x]=morsewave1(N,K,ga,be,fs);
deltat=1;

fo=(be/ga).^(1/ga)/(2*pi);
om=2*pi*linspace(0,1-1./N,N)'.*fo/fs;  

r=(2*be+1)./ga;
c=r-1;

index=[1:round(N/2)];

L=0*om;
for k=0:K-1
  A=(pi*ga*(2.^r)*gamma(k+1)/gamma(k+r)).^(1/2);
  L(index)=laguerre(2*om(index).^ga,k,c);
  X(:,k+1)=sqrt(2)*A.*sqrt(fo./fs).*(om.^be).*exp(-om.^ga).*L;
  Xr(:,k+1)= X(:,k+1).*rot(om*(N+1)/2*(fs/fo));  %ensures wavelets are centered  
end

%  See Olhede and Walden, "Noise reduction in directional signals
%  using multiple Morse wavelets", IEEE Trans. Bio. Eng., v50, 51--57.
%  The equation at the top right of page 56 is equivalent to the
%  preceding expressions. Morse wavelets are defined in the frequency  
%  domain, and so not interpolated in the time domain in the same way
%  as other continuous wavelets.

 x=ifft(Xr);
 for i=1:size(x,2)
    if real(x(round(end/2),i))<0
      x(:,i)=-x(:,i);
      X(:,i)=-X(:,i);
    end
 end

function[]=morsewave_test
fs=flipud(1./logspace(log10(5),log10(40))'); 
N=1023;
w=morsewave(N,1,2,4,fs);
bool=0*fs;
for i=1:size(w,2)
   bool(i)=max(abs(w(:,i)))==abs(w(N/2+1/2,i));
end
reporttest('MORSEWAVE centered for odd N',all(bool))

N=1024;
w=morsewave(N,1,2,4,fs);
bool=0*fs;
for i=1:size(w,2)
   bool(i)=max(abs(w(:,i)))==abs(w(N/2,i))|max(abs(w(:,i)))==abs(w(N/2+1,i));
end
reporttest('MORSEWAVE centered for even N',all(bool))

function[]=morsewave_fig

N=256*4;

be=5;
ga=2;
K=3;
fs=1/8/4;

[x,X]=morsewave(N,K,ga,be,fs);
%[fmin,fmax,fc,fw] = morsefreq(1/10000,ga,be);
%fc=fc./ao;

f=[0:1:N-1]'./N;

figure
t=[1:length(x)]'-length(x)/2;
ax=[-60 60 -maxmax(abs(x))*1.05 maxmax(abs(x))*1.05];
subplot 321
  uvplot(t,x(:,1));axis(ax)
  title('Morse wavelets, time domain')
subplot 323
  uvplot(t,x(:,2));axis(ax)
subplot 325
  uvplot(t,x(:,3));axis(ax)

ax=[0 120./N -maxmax(abs(X))*1.05 maxmax(abs(X))*1.05];
subplot 322
  plot(f,abs(X(:,1))),axis(ax),vlines(fs);
title('Morse wavelets, frequency domain')
subplot 324
  plot(f,abs(X(:,2))),axis(ax),vlines(fs);
subplot 326
  plot(f,abs(X(:,3))),axis(ax),vlines(fs);

