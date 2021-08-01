function[w,wlambda,wf,wl]=slepwave(tbp,tbcp,neigs,nfreqs,flowest,fhighest,i7,i8);%SLEPWAVE  Computes Slepian multi-wavelets
%  
%  [W,LAMBDA,F,L]=SLEPWAVE(TBP,TBCP,NE,NF,FMIN,FMAX,STR) computes the
%  Slepian multiwavelets as defined in Lilly and Park (1995) and Lilly
%  (2004), with input and output variables specified below.
%
%  Input:
%     P       Time-bandwidth product
%     PC      Time-bandcenter product
%     NE      Number of eigenvectors to compute
%     NF      Number of different frequency bands to compute
%     FMIN    Center frequency of lowest frequency band
%     FMAX    Center frequency of highest frequency band
%     [STR]   Optional string specifying type of wavelets  
%             Valid choices are 'real', 'complex', and 'analytic'.  
%             The default value is 'analytic'.
%   Output:
%     W       Wavelet matrix with NF columns and NE entries in the 
%             third dimension. The number of rows of W is equal to the 
%             length of the longest wavelet.
%     LAMBDA  A matrix of eigenvalues associated with the first NE 
%             wavelets.  LAMBDA(I,J) contains the eigenvalue associated 
%             with the (Ith) wavelet within the (jth) frequency band. 
%     F       A length NF array specifying the central frequencies.
%     L       A length NF array specifying the wavelet lengths.
%  
%  SLEPWAVE solves the optimization condition explicity up to a
%  wavelet length of 256 points, and for longer wavelets are linearly
%  interpolated from the last wavelet explicitly solved for.	
%
%  As an example,
%  
%      [x,t]=testseries(1);
%      [w,lambda,f]=slepwave(2.5,3,6,20,1./1000,1/8,'real'); 
%      w=bandnorm(w,f);
%      y=wavetrans(x,w);T=vmean(abs(y).^2,3);
%      h=wavespecplot(t,x,1./f,T);
%      colormap gray, flipmap, shading flat
%      
%  is, more or less, Fig. 5a-b of Lilly and Park (1995). 
%
%  'slepwave --f' generates some sample figures
%  
%  Usage: [w,lambda,f]=slepwave(tbp,tbcp,ne,nf,fmin,fmax);
%         [w,lambda,f,l]=slepwave(tbp,tbcp,ne,nf,fmin,fmax);
%         [w,lambda,f,l]=slepwave(tbp,tbcp,ne,nf,fmin,fmax,str);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1993, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
% Optional: [w,lambda,f,l]=slepwave(tbp,tbcp,ne,nf,fmin,fmax,fh);
% for varying the hard cutoff fh
  
if strcmp(tbp,'--f')
  slepwave_fig;return
end

fh=1/2; 
str='analytic';
if  nargin==7
  if isstr(i7)
     str=i7;
  else
      fh=i7;
  end
elseif nargin==8
  fh=i8;
  str=i7;
end
if strcmp(str,'comnlex')
  if ~iseven(neigs)
     error('Number of eigenvalues should be even with ''complex'' flag.')
  end
end

if nfreqs==1
  factor=1;
else
  factor= (fhighest /flowest) ^(1/(nfreqs-1)); 
end

%ncutoff is the longest wavelet for which the opt. cond. is solved explicity
ncutoff=256;
m=tbcp/fhighest/factor;
n=0;


%/********************************************************
%If the requested length is too long, form a shorter one first
binterpfrom=0;
if m*factor>ncutoff
  mold=m*factor;
  binterpfrom=1;
  m=ncutoff/factor;
  nfreqsold=nfreqs;
  nfreqs=1;
end
%\********************************************************


i=0;
while ((i<nfreqs)&(n<ncutoff)) | (i==0);
        i=i+1;
	
	m=m*factor;
	n=round(m);
	%if res(n/2)~=0
	%  n=n+1;
	%end
	
	fw=tbp/n;
	fc=tbcp/n;
	wf(i,1)=fc;
	
	fprintf(1,'%s %g %s\n','Computing',n,'point wavelet.');
	
	if strcmp(str,'analytic')
	  c=cmath(n,fc,fw,fh);
	elseif strcmp(str,'real')|strcmp(str,'complex')
	  c=cmat(n,fc+fw)-cmat(n,fc-fw);
        end    		
	
%	****************
	options.disp=0;
	[x,d]=eigs(c,neigs,'LM',options);
	lambdai=real(diag(d));
	[lambdai,index]=sort(lambdai);
	x=x(:,flipud(index));
	x=x(:,1:neigs);
	lambdai=flipud(lambdai);
%	******************

	if strcmp(str,'analytic')
	  for jj=1:neigs;
	     x(:,jj)=waverot(x(:,jj));
	  end
          x=wanalytic(neigs,x);
	elseif strcmp(str,'real')|strcmp(str,'complex')
	   [x,lambdai]=wswitcheo(neigs,x,lambdai);
	   if strcmp(str,'complex')
   	       x=wanalytic(neigs,x);
	   end

        end    			
	wlambda(:,i)=lambdai;
	w{i}=x;
end

%/********************************************************
%Restore values if necessary
if binterpfrom==1
  nfreqs=nfreqsold+1;
  m=mold;
end
%\********************************************************

%********************************
winterp_from=w{i};
for i=i:nfreqs-1,
        i=i+1;
	m=m*factor;
	n=round(m);
	f=tbcp/n;
	wf(i,1)=f;
	
	fprintf(1,'%s %g %s\n','Interpolating to',n,'points.');
	
	if strcmp(str,'real')|strcmp(str,'complex')
	    for ii=1:neigs,
		wtemp=sinterp(winterp_from(:,ii),n);
		w{i}(:,ii)=wtemp/sqrt(wtemp'*wtemp);
	    end
        else
      	    w{i}=ifft(fft(winterp_from),n);
	end
	%set to unit energy
	for j=1:size(w{i},2)
	    w{i}(:,j)=w{i}(:,j)./sqrt(sum(squared(abs(w{i}(:,j)))));
	end
end
%*****************************************


%Remove first wavelet if necessary
if binterpfrom==1
  w=w(2:end);
  wf=wf(2:end);
end


if strcmp(str,'complex')
   for i=1:length(w);
       w{i}=w{i}(:,1:2:end)/sqrt(2)+sqrt(-1)*w{i}(:,2:2:end)/sqrt(2);
   end	
end

M=size(w{end},1);
K=size(w{end},2);
L=length(w);
wcell=w;
w=zeros(M,L,K);
wl=zeros(L,1);

for i=1:L
    w1=wcell{i};
    M1=size(w1,1);
    index=[1:M1]'+floor((M-M1)./2);
    w(index,i,:)=w1;
    wl(i,1)=M1;
end




%/********************************************************
function[x,wlambda]=wswitcheo(neigs,x,wlambda);
%WSITCHEO Switch even and odd wavelets if necessary to get even
%wavelets in odd colums and odd wavelets in even columns; switch 
%associated wlambda values also

n=floor(size(x,1)/2);

for ii=1:2:neigs-1
	if abs(sum(x(1:n,ii)))>abs(sum(x(1:n,ii+1)))
		temp=x(:,ii);
		x(:,ii)=x(:,ii+1);
		x(:,ii+1)=temp;
		temp=wlambda(ii,1);
		wlambda(ii,1)=wlambda(ii+1,1);
		wlambda(ii+1)=temp;
	end
	if x(round(end/2),ii)<0 
	       x(:,ii)=-x(:,ii); 
	end
	if (x(round(end/2)+1,ii+1)-x(round(end/2)-1,ii+1))<0
	       x(:,ii+1)=-x(:,ii+1); 
	end
end
%\********************************************************


%/********************************************************
function[x]=wanalytic(neigs,x);
%Make sure wavelets are analytic, not anti-analytic
N=round(size(x,1)/2);

for ii=1:neigs
	if real(x(N))<0
		x(:,ii)=-x(:,ii);
	end
	X=abs(fft(x(:,ii)));
	if sum(X(1:N))<sum(X(N:end))
	   x(:,ii)=conj(x(:,ii));
	end
end
%\********************************************************



function[c]=cmat(N,fw,dt)
%CMAT C-matrix for computation of Slepian wavelets  
%
%   C=CMAT(N,FW,DT) computes the NxN C-matrix for Slepian wavelets
%   centered at zero frequency with frequency half-width FW.  The
%   sample interval DT is optional and defaults to 1.

warning off

if nargin==3
  dt=1;
end

c=zeros(N);

index=[1:length(c(:))]';
[ii,jj]=ind2sub(size(c),index);
%c(index)=exp(sqrt(-1)*2*pi.*fc.*(ii-jj)).*sin(2*pi.*fw.*(ii-jj))./(pi.*(ii-jj));
c(index)=sin(2*pi.*fw.*(ii-jj))./(pi.*(ii-jj));

index=find(ii==jj);
%c(index)=exp(sqrt(-1)*2*pi.*fc.*(ii(index)-jj(index))).*2.*fw;
c(index)=2.*fw;

warning on

function[c]=cmath(N,fc,fw,fh,dt)
%CMATH Hermetian C-matrix for analytic Slepian wavelets  
%
%   C=CMATH(N,FC,FW,FH,DT) computes the NxN C-matrix for analytic
%   Slepian wavelets centered at frequency FC with frequency
%   half-width FW and hard high frequency cutoff at FH. The sample
%   interval DT is optional and defaults to 1.
    
if nargin==4
  dt=1;
end
	
c=cmatrot(N,fc,fw);

%Set to zero below zero frequency 
mx=frac(1,2).*(eye(N)-amat(N)-sqrt(-1)*hmat(N));

c=mx*c*mx;


function[c]=cmatrot(N,fc,fw,dt)
%CMATROT Complex-valued C-matrix for computation of Slepian wavelets  

warning off

if nargin==3
  dt=1;
end

c=zeros(N);

index=[1:length(c(:))]';
[ii,jj]=ind2sub(size(c),index);
c(index)=exp(sqrt(-1)*2*pi.*fc.*(ii-jj).*dt).*sin(2*pi.*fw.*(ii-jj).*dt)./(pi.*(ii-jj).*dt);

index=find(ii==jj);
c(index)=2.*fw;

warning on


function[]=slepwave_test


if 0
[psi,lambda]=sleptap(800,1.5,1);
t=[1:size(psi,1)]';
t=t-mean(t);
psi1=psi.*rot(2.*pi.*t.*f(end));
psi1=psi1./max(abs(psi1)).*max(abs(w(:,end)));
psif=abs(fft(psi1,2.^(nextpow2(size(w,1))+1))).*sqrt(f(end));
plot(ff(:,end),psif,'g')
end

function[]=slepwave_fig

  
[w,lambda,fs]=slepwave(1.5,2,1,10,.005/2,.05); 
%[w,lambda,f]=slepwave(2,2.5,4,10,.005,.05); 

figure,
subplot(121)
for i=1:size(w,2)
  t=1:size(w,1);
  t=t-mean(t);
  t=t.*fs(i);
  plot(t,real(w(:,i))./max(abs(w(:,i))),'.'),hold on
  plot(t,imag(w(:,i))./max(abs(w(:,i))),'g.'),hold on
end
axis([-1.1 1.1 -1.1 1.1])
title('Decimation error vanishes')


subplot(122)
wf=abs(fft(w,2.^(nextpow2(size(w,1))+1)));
ff=[0:size(wf,1)-1]'./size(wf,1);
wf=wf.*oprod(1+0*ff,sqrt(fs));
ff=oprod(ff,1./fs);
plot(ff,wf),xlog,ylog
title('Fourier transforms are no longer identical')
axis([10^-3 10^3 10^-6 10^1]),hold on
ylin
axis tight



w=bandnorm(w,fs);
f=[0:length(w)-1]./length(w);
figure,
plot(f,abs(fft(w)))
vlines(fs)
xlog
title('Peak of wavelet modulus in frequency domain occurs at fs')


x=testseries(1);t=[1:length(x)]-round(length(x)/2);
[w,lambda,f]=slepwave(2.5,3,6,20,1./1000,1/8,'real');
w=bandnorm(w,f);
y=wavetrans(x,w);T1=vmean(abs(y).^2,3);

[w,lambda,f]=slepwave(2.5,3,6,20,1./1000,1/8,'complex');
w=bandnorm(w,f);
y=wavetrans(x,w);T2=vmean(abs(y).^2,3);

[w,lambda,f]=slepwave(2.5,3,3,20,1./1000,1/8,'analytic');
w=bandnorm(w,f);
y=wavetrans(x,w);T3=vmean(abs(y).^2,3);
figure
h=wavespecplot(t,x,1./f,T1,T2,T3,1/2);
axes(h(1)),title('Comparison of real, complex, and analytic versions')
