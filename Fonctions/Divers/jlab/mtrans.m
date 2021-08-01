function[mmat]=mtrans(varargin)
% MTRANS  Multitaper "eigentransform" computation.
%    
%   Q=MTRANS(X,PSI) returns the multitaper "eigentransform" matrix for 
%   use in multitaper spectral estimates or eigenspectral SVD analysis.                 
%
%       X  --  M x N matrix containing N length M time series
%     PSI  --  M x K matrix of K data tapers
%       W  --  [M/2] x K x  N eigentransfrom matrix (for real X)
%              [M/2] x K x 2N eigentransfrom matrix (for complex X)
%
%   In the above, [M/2] means M/2 if M is even, and (M-1)/2 is M is odd.
%
%   If X is real-valued, W is a matrix containing 'one-sided' transforms,
%   i.e. SUM(ABS(X).^2,2) is an estimate of the one-sided spectrum, 
%   which sums to the variance.
%
%   If X is complex-valued, W contains the counterclockwise rotary 
%   eigentransforms in odd "pages" -- W(:,:,KK) with KK=1:2:2*N -- and 
%   the clockwise rotary eigentransforms in even pages 2:2:2*N. 
%  
%   W=MTRANS(X,Y,PSI) where X and Y are both real matrices of the same
%   size also works.  W is again [M/2] x K x 2N, and has the 
%   eigentransforms of X in odd pages and those of Y in even pages. 
%  
%   See also: SLEPTAP, HERMFUN, MSPEC, MSVD.
%
%   Usage:  w=mtrans(x,psi);  
%           w=mtrans(x,y,psi);    
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000-2005 J.M. Lilly --- type 'help jlab_license' for details        
  
%Sort out input arguments
x=varargin{1};
y=[];
if nargin==2
  psi=varargin{2};
elseif nargin==3
  y=varargin{2};
  psi=varargin{3};
end

mmatx=mtrans1(x,psi);
if ~isempty(y)
      mmaty=mtrans1(y,psi);
end

%Make sure that negative transform has zero frequency for first entry
%Odd and even length data are different
M=length([0:1/size(x,1):1/2-1./size(x,1)]);
index1=1:M;
if iseven(size(x,1))
  index2=[1 2*M:-1:M+2];
elseif isodd(size(x,1))
  index2=[1 2*M+1:-1:M+3];
end

if isreal(x)  %For real-valued time series 
   %Make one-sided
   if isempty(y)
      mmat=sqrt(2)*mmatx(index1,:,:);
   else  %Cross-spectra
      mmatx=sqrt(2)*mmatx(index1,:,:);
      mmaty=sqrt(2)*mmaty(index1,:,:);
       
      mmat=zeros(size(mmatx,1),size(mmatx,2),2*size(mmatx,3));
      mmat(:,:,1:2:end)=mmatx;
      mmat(:,:,2:2:end)=mmaty;
   end
else %For complex-valued time series 
   mmatp=mmatx(index1,:,:);
   mmatn=mmatx(index2,:,:);
   mmat=zeros(size(mmatp,1),size(mmatp,2),2*size(mmatp,3));
   mmat(:,:,1:2:end)=mmatp;
   mmat(:,:,2:2:end)=mmatn;
end

function[mmat]=mtrans1(x,psi)

K=size(psi,2);
mmat=zeros(size(x,1),K,size(x,2));
for i=1:size(psi,2)
%    disp(['Computing eigenspectrum # ',int2str(i)])
    psimat=osum(psi(:,i),0*x(1,:)');
    mmat(:,i,:)=fft(psimat.*x);
end

