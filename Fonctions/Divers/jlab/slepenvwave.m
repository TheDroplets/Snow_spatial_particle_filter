function [w,fs,W]=slepenvwave(ao,m,P)
%SLEPENVWAVE  Slepian-enveloped wavelet.   
%  
%   W=SLEPENVWAVE(N,M,P) returns a complex-valued Slepian-enveloped
%   wavelet of length N, concentrated at frequency F, and having M
%   periods in between the two inflection points of the Gaussian
%   envelope.  The envelope is the lowest-order discrete prolate
%   spheroidal sequency, or "Slepian taper", having a time-bandwidth
%   product of P.
%  
%   If N is a scalar, W is a column vector of length M.  If N is an
%   array, W is a matrix of size M x LENGTH(N).  Here N plays the role
%   of the usual "scale parameter" in wavelet computations.
%
%   [W,FS,WF]=SLEPENVWAVE(N,F,M) also returns a returns FS, a length L
%   array which gives the frequency of the "carrier wave" associated
%   with each wavelet, and a size SIZE(W) matrix WF which is the
%   frequency-domain version of the wavelets.
%
%   The Slepian-enveloped wavelets were described in Section 3.2.3 of
%   Lilly et al. 2003. The zero-mean condition is enforced by adding a
%   multiple mutliple of the wavelet envelope at each scale.
%
%   'slepenvwave --f' generates a sample figure, Figure 11 of Lilly et
%   al. 2003.
%
%    'slepenvwave --t' runs a test
%
%   Usage: w=slepenvwave(n,f,m);
%          [w,sigma,W]=slepenvwave(n,f,m);  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1999--2006 J. M. Lilly  --- type 'help jlab_license' for details  

%Note: frequency determination is rather crude right now

if strcmp(ao,'--t')
    slepenvwave_test;return
end

if strcmp(ao,'--f')
    slepenvwave_fig;return
end

%/********************************************************
%Enforce convention of small scales first
ao=ao(:);
if length(ao)>1
  if ao(2)-ao(1)<0
    ao=flipud(ao);
  end
end
%\********************************************************


%/********************************************************

fs=0*ao;
Lcutoff=100;
L=length(ao);

%Directly compute short wavelets 
acutoff=max(find(ao<Lcutoff));
if isempty(acutoff)
   acutoff=0;
end
if acutoff==0
   [wcell{1},fs(1)]=slepenvwave1(round(Lcutoff),m,P);
   wcell{1}=slepenvwave_adjust(wcell{1});
   w0=wcell{1};
else
   for i=1:acutoff
      [wcell{i},fs(i)]=slepenvwave1(round(ao(i)),m,P);
       wcell{i}=slepenvwave_adjust(wcell{i});
   end
   w0=wcell{acutoff};
end


%For longer wavelets, interpolate from a "base" wavelet
if acutoff~=L
  for i=acutoff+1:L
    fprintf(1,'%s %g %s\n','Interpolating to',round(ao(i)),'points.');
    wcell{i}=sinterp(w0,round(ao(i)));
    wcell{i}=slepenvwave_adjust(wcell{i});
  end
end
%\********************************************************

%/********************************************************
%Put cell array into matrix
M=max(lengthcells(wcell));
w=zeros(M,L);

for i=1:L
    w1=wcell{i};
    M1=size(w1,1);
    index=[1:M1]'+floor((M-M1)./2);
    w(index,i)=w1;
end
%\********************************************************

%/********************************************************
%Compute frequencies
if nargout>1
  W=fft(w(:,1));
  fo=[0:size(W,1)-1]./size(W,1);
  fs=zeros(size(w,2),1);
  fs(1)=fo(find(abs(W)==max(abs(W))));
  fs(2:end)=fs(1).*round(ao(1))./round(ao(2:end));
% fs=fs0.*round(max(ao))./round(ao);
end
%\********************************************************

%/********************************************************
%Fourier transform if requested
if nargout >2
  wshifted=0*w;
  for i=1:size(w,2)
     wshifted(:,i)=fftshift(w(:,i));
  end
  W=fft(wshifted);
end
%\********************************************************

%---------------------------------------------------------------

function  [w,fs]=slepenvwave1(N,m,P)

g=sleptap(N,P,1);
ddg=vdiff(vdiff(g,1),1);  %Find the inflection points
a=min(find(ddg<0));
b=max(find(ddg<0));
L=b-a+1;                  %Length of central window

t=[1:N]';   % Choose dt = 1
t=t-mean(t);

fs=m./L;

if ~isempty(L);
  w=exp(2.*pi.*i.*t.*fs).*g;
  w=slepenvwave_adjust(w);
else
  w=[];
end

function  w=slepenvwave_adjust(w)
%Adjust for zero mean and unit energy
w=w-frac(sum(w),sum(abs(w))).*abs(w);
c1=(sum(abs(w).^2)^(1/2));  
w=w./c1; 

%---------------------------------------------------------------

function []= slepenvwave_test

ao=logspace(1,2.3,40)';

[w,fs,W]=slepenvwave(ao,2/3,2);
t=1:length(w);
t=t-mean(t);

tol=1e-10;

b=aresame(mean(w,1),0*w(1,:),tol);
reporttest('SLEPENVWAVE zero mean',b)

b=aresame(sum(abs(w).^2,1),1+0*w(1,:),tol);
reporttest('SLEPENVWAVE unit energy',b)

%---------------------------------------------------------------

function []= slepenvwave_fig
ro=10;
vo=-10;
eta=-sqrt(-1)*5+[-50:.1:50]';
[v,psi]=rankineeddy(eta,ro,vo);
[w,fs,W]=slepenvwave(200,2/3,2);

figure,
subplot(211)
uvplot(real(eta),v)
linestyle k 2G
ylim([-12 12])
vlines([-8.7 8.7] ,'E--'),hlines(0,'E--')
xtick([]),ytick([])
ylabel('Eddy velocity')
title('Rankine vortex & Slepian wavelet')

subplot(212)
uvplot(w),hold on,plot(abs(w)), linestyle k F2 k2--
axis([-25 225 -.13 .13]),xlim([-55 255])
hlines(0,'E--'), vlines([74 127],'E--')
xtick([]),ytick([])
xlabel('Time or distance')
ylabel('Wavelet "velocity"')
packrows(2,1)
letterlabels(1)
  
%ao=logspace(1.2,3.2,20)';
%[w,fs,W]=slepenvwave(ao,2/3,2);
%f=[0:length(w)-1]./length(w);
%plot(f,abs(W));
%vlines(fs);
;
