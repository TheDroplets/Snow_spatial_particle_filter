function[xhat,yhat]=ridgerecon(w,y,ii,jj,kk)
%RIDGERECON  Signal reconstruction along wavelet transform ridges.
%  
%   XHAT=RIDGERECON(W,Y,IR,JR) where W is a wavelet matrix and Y is a
%   wavelet transform matrix, returns the reconstucted signal XHAT
%   which results from using only the points in the transform matrix
%   located at rows IR and columns JR.   XHAT is real-valued.
%
%   The wavelet matrix W must have BANDNORM normalization, and the
%   transform matrix Y is assumed to have been formed using this W.
%   The wavelet matrix W is specfied in time and should have the same
%   number of rows as the transform matrix Y.
%
%   Here IR is an index into the temporal location of points within Y,
%   and JR is an index in the scale location of these points. 
%  
%   If IR and JR are column vectors, XHAT is a column vector with the 
%   same number of rows as Y.  If IR and JR are matrices of the same 
%   size, then XHAT has SIZE(II,2) columns, with the reconstruction 
%   from ridge points in each column of IR and JR in the corresponding 
%   column of XHAT.
%
%   Note that the ridge reconstruction algorithm performs sigificantly 
%   better when both the data length (which sets the transform matrix 
%   length) and the wavelet length are even.  Consequently, a warning 
%   is issued if this is not the case.
%
%   XHAT=RIDGERECON(W,Y,IR,JR,KR) where KR is the same size as IR and JR, 
%   and Y is now three-dimensional, uses the KRth "page" of YR in 
%   forming the reconstruction of each ridge point.  This is useful for
%   multivariate datasets. 
%
%   [XHAT,YHAT]=RIDGERECON(...) reconstructs two real-valued signal
%   components from a single ridge.  Y is in this case the positively
%   positively or negatively rotating transform of a complex-valued time
%   series.  If Y the negatively rotating (anti-analytic) transform, 
%   ensure that the wavelet matrix W is also anti-analytic, i.e. W is 
%   in this case the conjugate of the analytic wavelet matrix.
%  
%   Usage:  xhat=ridgerecon(w,y,ir,jr);
%           [xhat,yhat]=ridgerecon(w,y,ir,jr);
%           xhat=ridgerecon(w,y,ir,jr,kr);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(w,'--t')
  waverecon_test;return
end


if iseven(size(w,1))
    warning(['For better performance, wavelet matrix should have an odd number of rows.'])
end
if iseven(size(y,1))
    warning(['For better performance, transform matrix should have an odd number of rows.'])
end

w=w./2;

xhat=zeros(size(y,1),size(ii,2));
if nargin==4
  kk=1+0*ii;
end

for i=1:size(ii,2) 
  xhat(:,i)=ridgerecon1(w,y,ii(:,i),jj(:,i),kk(:,i));
end

%Adapt for one ridge of a complex-valued time series
if nargout==2
  xhat=xhat./sqrt(2);
  yhat=imag(xhat);
end
xhat=real(xhat);

function[xhat]=ridgerecon1(w,y,ii,jj,kk)

index=find(~isnan(ii)&~isnan(jj));
[ii,jj,kk]=vindex(ii,jj,kk,index,1);

index=sub2ind(size(y),ii,jj,kk);
yy=y(index);

xhat=zeros(size(y(:,1))); 
if iseven(size(w,1))
    index0=[1:size(w,1)]-size(w,1)/2;
elseif isodd(size(w,1))
    index0=[1:size(w,1)]-floor(size(w,1)/2)-1;
end

for i=1:length(ii)
   index=index0+ii(i);  
   index2=find(index>=1&index<=length(xhat));
   index=index(index2);
   xhat(index)=xhat(index)+yy(i).*w(index2,jj(i));
end


function[]=waverecon_test

%Testing local reconstruction
N=1000;
ga=2;
K=1;
be=5;a=logspace(log10(1),log10(50),30);
[w,fs,W]=morsewave(N,K,ga,be,a);
w=bandnorm(w,fs);

clear maxs
for i=1:size(w,2)
  t=[1:N]';
  cv=cos(2*pi.*t.*fs(i));
  yp=wavetrans(cv,w);
  
  ir=[1:length(cv)]';jr=i+0*ir;
  xhat=real(ridgerecon(w,yp,ir,jr));
  yp2=wavetrans(xhat,w);

%  index=find(abs(yp)==maxmax(abs(yp)));
%  [ir,jr]=ind2sub(size(yp),index);
%  ir=round(mean(t));jr=i;
%  xhat=real(ridgerecon(w,fs,yp,ir,jr));
%  yp3=wavetrans(xhat,w);
  
  maxs(i,1)=maxmax(abs(yp));
  maxs(i,2)=maxmax(abs(yp2));
%  maxs(i,3)=maxmax(abs(yp3));
end

tol=1e-2;
b(1)=aresame(maxs(:,1),1+0*maxs(:,1),tol);
b(2)=aresame(maxs(:,2),1+0*maxs(:,2),tol);
reporttest('BANDNORM gives maximum amplitude of one', b(1))
reporttest('RIDGERECON gives maximum amplitude of one', b(2))


