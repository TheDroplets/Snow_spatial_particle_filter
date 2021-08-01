function[xhat]=waverecon(w,ao,y,n,ii,jj)
%WAVERECON  Signal reconstruction from wavelet transform.
%  
%  XHAT=WAVERECON(W,A0,N,Y,II,JJ) where W is a wavelet matrix at
%  scales A0, and Y is a wavelet transform matrix using normalization
%  across scales A0^(-N), returns the reconstucted signal XHAT which
%  results from using only the points in the transform matrix located
%  at rows II and columns JJ.  
%
%  Here II is an index into the temporal location of points within Y,
%  and JJ is an index in the scale location of these points.
%
%  Note that wavelet matrix W is specfied in time and should have the
%  same number of rows as the transform matrix Y.
%
%  If Y is the anti-analytic transform, ensure that the wavelet matrix
%  W is also anti-analytic, i.e. W is in this case the conjugate of
%  the analytic wavelet matrix.
%
%  Usage:  xhat=waverecon(w,ao,y,n,ii,jj);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(w,'--t')
  waverecon_test;return
end

index=find(~isnan(ii));
vindex(ii,jj,index,1);

%c=(abs(w').^2*[0:size(w,1)-1]')';  
%if n==1
%  c=c.*max(abs(W(:,end)));
%end

ao=ao(:);

%if all(ao<0)
%  ao=-ao;
%  w=conj(w);
%end

%da=vdiff(ao,1);  %Note da=nan when reconstructing from first or last scale
%da([1 end])=0;   %Don't reconstruct from first or last scale

%/********************************************************
if n==1
  cn=max(abs(fft(w(:,end).*(ao(end).^(1/2-n)))))./2;
  w=w.*cn;  %Bandpass normalization
end
 
if n~=1/2
  for j=1:size(w,2)
       w(:,j)=w(:,j).*(ao(j).^(n-1/2));    
  end    
end

%W=fft(fftshift(w(:,1,1)));
%fi=[0:size(W,1)-1]./size(W,1);
%[mtemp,index]=min(abs(fi-fs(1)));
%cn=1./W(index,1,1);
%w=w.*cn.*fs(1);
%for i=1:size(w,2)
%    w(:,i,:)=w(:,i,:).*cn.*fs(1)./fs(i);
%   w(:,i,:)=w(:,i,:)./fs(i)./1.134;  %Total hack
%end



%\********************************************************
%anorm=da./(ao).^(2+1/2-n);
%anorm=(ao).^(1-n);
index=sub2ind(size(y),ii,jj);
yy=y(index);

xhat=zeros(size(y(:,1)));
index0=[1:size(w,1)]-floor(size(w,1)/2)-1;

for i=1:length(ii)
   index=index0+ii(i);  
   index2=find(index>=1&index<=length(xhat));
   index=index(index2);
   xhat(index)=xhat(index)+yy(i).*w(index2,jj(i));
end
  
% [jj,sorter]=sort(jj);
% ii=sort(jj);
% index=sub2ind(size(y),ii,jj);
% yy=y(index);
% 
% [num,a,b]=blocknum(jj);
  

function[]=waverecon_test
