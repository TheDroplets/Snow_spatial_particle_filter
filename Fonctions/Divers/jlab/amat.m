function[a]=amat(N,dt)
%AMAT  Mean-taking matrix
%
%   A=AMAT(N) returns a matrix an NxN matrix A such that the matrix
%   multiplication M=A*X for X another NxN matrix returns a matrix M,
%   all the evelements of which are equal to the mean of X.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  

if nargin==1
  dt=1;
end

f=fmat(N,dt);

sgnom=zeros(N,1);
sgnom(1)=1;

d=diag(sgnom);

a=f'*d*f;


if 0
  h=zeros(N,N);

if iseven(N)
   t=[-(N-2)/2:N/2]';
elseif isodd(N)
   t=[-(N-1)/2:(N-1)/2]';
end

index=[1:length(h(:))]';
[ii,jj]=ind2sub(size(h),index);

h(index)=frac(dt,pi).*frac(1,t(ii)-t(jj));

index=find(~isfinite(h));
h(index)=0;
end




