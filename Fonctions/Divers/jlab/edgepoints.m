function[index]=edgepoints(x,ir,jr,i4,i5)
%EDGEPOINTS  Exclude edge effect regions from ridge or modmax points. 
%  
%   EDGEPOINTS is used to remove edge-effect regions from a set of
%   wavelet ridge points or wavelet modulus maxima points.
%
%   INDEX=EDGEPOINTS(X,II,JJ,L) where X is a column vector containing
%   a data series, II and JJ are respectively indices into the
%   time-location and scale-location of certain points of the wavelet
%   tranform of X, returns an index INDEX such that the points
%   II(INDEX), JJ(INDEX) lie outside the edge-effect region.
%  
%   The edge effect region is determined as follows.  L is an array of
%   the same length as the number of frequency bands used in the
%   wavelet transform.  At the Nth frequency band, L(N) gives the
%   number of points from the edge of the time series which is taken
%   to be contaminated by edge effects.  L may also be a scalar.
%
%   The edges of the time series are taken to be the first and the
%   last non-NAN points of X.
%
%   INDEX=EDGEPOINTS(X,II,JJ,KK,L) where X a matrix containing
%   multiple data components in its columns, and KK is the index into
%   the data component number of the wavelet transform points, returns
%   INDEX such that points II(INDEX), JJ(INDEX), KK(INDEX) lie outside
%   the edge-effect regions of the respective data component.
%
%   Usage: index=edgepoints(x,ii,jj,L);
%          index=edgepoints(x,ii,jj,kk,L);  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

  
if nargin==4
  L=i4;
end
if nargin==5;
  kr=i4;
  L=i5;
end

L=L(:);
if length(L)==1
  L=L+zeros(maxmax(jr),1);
end


for i=1:size(x,2)
  a1=min(find(~isnan(x(:,i))));
  b1=max(find(~isnan(x(:,i))));
  if isempty(b1),
    b1=size(x,1);
  end
  a(:,i)=a1+L;
  b(:,i)=b1-L;
end

bool=ones(size(ir));
for i=1:size(x,2)
   index=find(kr==i&(ir<a(jr,i)|ir>b(jr,i)));
   if ~isempty(index)
     bool(index)=0;
   end
end
index=find(bool);
