function[T]=wavetrans(varargin)
%WAVETRANS  Wavelet transform.
%
%   W=WAVETRANS(X,PSI) computes the wavelet transform W of a dataset X
%   using wavelet maxtrix PSI. X is a column vector, and the columns of
%   PSI are frequency-domain wavelets at different scales.
%
%   X and PSI may both contain multiple components, in which case
%   PSI(:,:,k) specifies the kth wavelet and X(:,n) specifies the nth
%   data component.  If there are K wavelets at L frequencies and M
%   data points in N data vectors, W is of size M x L x K x N.  Note
%   that W is squeezed to remove singleton dimensions.
%   ___________________________________________________________________
%
%   Boundary conditions
%
%   W=WAVETRANS(..., STR), where STR is a string, optionally specifies
%   the boundary condition to be imposed at the edges of the time
%   series.  Valid options for STR are 
%
%         STR = 'periodic' for periodic boundary conditions 
%         STR = 'zeros' for zero-padding beyond the endpoints 
%         STR = 'mirror' for reflecting the time series at both ends
%
%   The default value of STR is 'periodic', which means endpoints of
%   the time series are implicitly joined to make a periodic signal.
%   All boundary conditions take into account potential blocks of 
%   missing data, marked by NaNs, at beginning and end of each column.  
%   ___________________________________________________________________
%
%   Missing data
%
%   The data X may contain blocks of NANs at the beginning and/or end
%   of each column, marking the absence of data.  In this case only
%   the data series is taken to correspond to the block of finite data
%   values, and the boundary conditions are applied accordingly. The
%   corresponding portions of the transform matrix W are then also set
%   to NANs. No NANs may occur in the interior of the data series.
%   ___________________________________________________________________
%
%   Detrending
%
%   Note that the data X is detrended before transforming.  This
%   feature is suppressed by WAVETRANS(...,[STR], 'nodetrend').
%   ___________________________________________________________________
%
%   See also RIDGEWALK, WAVESPECPLOT.
%
%   Usage:  w=wavetrans(x,psi);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004-2006 J.M. Lilly --- type 'help jlab_license' for details        


  
if strcmp(varargin{1},'--t')
  wavetrans_test;return
end

x=varargin{1};
w=varargin{2};

bdetrend=1;
str='periodic';

if isstr(varargin{end})
  if strcmp(varargin{end}(1:3),'nod')
     bdetrend=0;
     if isstr(varargin{end-1})
        str=varargin{end-1};
     end  
  else
     str=varargin{end};
  end
end

x0=x;
M0=size(x0,1);
x=wavetrans_dataprep(x0,str,bdetrend);

%figure,plot(x),yoffset 10

M=size(x,1);
N=size(x,2);

K=size(w,3);
L=size(w,2);
if size(w,1)>M&strcmp(str,'periodic')  
  error(['Data length must exceed wavelet matrix length.'])
elseif size(w,1)>M
  error(['Data length must exceed one-third wavelet matrix length.'])
end

%/********************************************************
%Generate a frequency-domain wavelet matrix of same size as data
if size(w,1)<M   %Some subtlety here for even/odd or odd/even
   wnew=zeros(M,L,K);
   index=[1:size(w,1)]'+floor((M-size(w,1))./2);
   wnew(index,:,:)=w;
   w=wnew;
end

%size(w)
%w=reshape(w,M,L,K);
W=fft(w);
%size(w)

f=linspace(0,1-1./M,M)';
f=ndrep(L,f,2);
f=ndrep(K,f,3);

%size(W),size(f)
W=W.*rot(-2*pi*f*(M+1)/2); %ensures wavelets are centered
W=reshape(W,M,L,K);
%\********************************************************

X=fft(x);
T=zeros(M0,L,K,N);

for k=1:K
  for n=1:N;
     Xmat=osum(X(:,n),zeros(L,1));
     Ttemp=ifft(Xmat.*W(:,:,k));
     if M0~=M
         index=M0+1:M0*2;
     else 
         index=[1:M0];
     end
     T(:,:,k,n)=Ttemp(index,:);
  end
end

T=squeeze(T);

%/********************************************************
%Set missing data to NANs
for i=1:size(x,2)
  index=find(isnan(x0(:,i)));
  if~isempty(index)
    Ttemp=T(:,:,i);
    Ttemp(index,:)=nan;
    T(:,:,i)=Ttemp;
  end
end
%\********************************************************

    
function[]=wavetrans_test

ao=logspace(log10(5),log10(40));
x=zeros(2^10-1,1);t=[1:length(x)]';
[w,f]=morsewave(length(x),1,2,4,ao);
x(2^9,1)=1;
y=wavetrans(x,w);
clear maxi
for i=1:size(y,2);
  maxi(i)=find(abs(y(:,i))==max(abs(y(:,i))));
end
b(1)=max(abs(maxi-2^9)<=1);
reporttest('WAVETRANS Morsewave transform has peak at delta-function',b(1))

[w,lambda,f]=slepwave(2,2.5,1,10,.01,.05); 

x=zeros(2^10,1);t=[1:length(x)]';
x(2^9,1)=1;
y=wavetrans(x,w);
clear maxi
for i=1:size(y,2);
  maxi(i)=find(abs(y(:,i))==max(abs(y(:,i))));
end
b(1)=max(abs(maxi-2^9)<=1);
reporttest('WAVETRANS Slepian transform has peak at delta-function',b(1))


function[y]=wavetrans_dataprep(x,str,bdetrend)
%Prepare data by applying boundary condition

for i=1:size(x,2)
  ai=min(find(~isnan(x(:,i))));
  bi=max(find(~isnan(x(:,i))));
  if isempty(ai)&isempty(bi)
    error(['Data column ', int2str(i), ' contains no finite values.'])
  elseif any(~isfinite(x(ai:bi,i)))
    error(['Data contains interior NANs or INFs in column ', int2str(i), '.'])
  else
    a(i)=ai;
    b(i)=bi;
  end
end

M=size(x,1);
N=size(x,2);
y=zeros(3*M,N);

for i=1:size(x,2)
   index{i}=a(i):b(i);
   indexy{i}=[M+a(i)-length(index{i}):M+2*length(index{i})+a(i)-1];
   xi=x(index{i},i);

   if bdetrend
       xi=detrend(xi);
   end
   
   if strcmp(str,'zeros')
       yi=[0*xi;xi;0*xi];
   elseif strcmp(str,'mirror')
       yi=[flipud(xi);xi;flipud(xi)];
   elseif strcmp(str,'periodic')
       yi=[xi;xi;xi];
   else 
       error(['Transform option STR = ''',str,''' is not supported.']);
   end   
   y(indexy{i},i)=yi;
end

y=vswap(y,nan,0);


