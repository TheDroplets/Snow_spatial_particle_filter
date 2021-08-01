function[d,u1,v1,u2,v2]=msvd(mmat,index)
%MSVD  Singular value decomposition for polarization analysis.
%
%   MSVD computes the singular value decomposition for multiple-
%   transform polarization analysis at all or selected frequencies.
%
%   [D,U1,V1]=MSVD(W) computes the singular value decomposition of 
%   sub-matrices of the eigentransform W.
%
%   The input matrix W is an M x K x N matrix where 
%          M is the number of transforms (frequencies or scales)
%          K is the number of eigentransforms (tapers or wavelets)
%          N is the number of dataset components
%   The output is
%	  D  --  M x MIN(K,N) matrix of singular values
%	 U1  --  M x K matrix of first left singular vectors
%	 V1  --  M x N matrix of first right singular vectors
%
%   The left singular vectors U1 are the eigenvectors of the spectral
%   matrix, while the right singular vectors V1 are the eigenvectors of 
%   the "structure matrix".  Note that these definitions of the left and 
%   right singular vectors use the convention of Lilly and Olhede (2005) 
%   and not of Park et al. (1987), who use a transposed version of W.
%
%   W may optionally be of size M1 x M2 x K x N, in which case the
%   output arguments are all three-dimensional matrices with M1 rows and
%   M2 columns.
%
%   [D,U1,V1]=MSVD(W,INDEX) for three-dimensional W optionally 
%   performs the SVD only at the rows of MMAT indicated by INDEX.  The 
%   output arguments then all have LENGTH(INDEX) rows rather than M.
%	
%  Usage:  [d,u1,v1]=msvd(w);
%          [d,u1,v1]=msvd(w,index);
%          [d,u1,v1,u2,v2]=msvd(w,index);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1993--2005 J.M. Lilly --- type 'help jlab_license' for details        


ndmmat=3;
if ndims(mmat)==4
  ndmmat=4;
  Mold=size(mmat,1);
  Nold=size(mmat,2);
  mmat=reshape(mmat,Mold*Nold,size(mmat,3),size(mmat,4));
end

if nargin==1
  index=1:size(mmat,1);
end

M=length(index);
K=size(mmat,2);
N=size(mmat,3);

d=zeros(min(N,K),M);
u1=zeros(K,M);
v1=zeros(N,M);

if nargout>3
  u2=zeros(K,M);
  v2=zeros(N,M);
end

for i=1:M
%	disp('Performing SVD (f,t).')
   if(res(i/1000))==0,i,end
   %note--for some reason SVD is much faster than SVDS
   mmattemp=squeeze(mmat(index(i),:,:));
   [utemp tempd vtemp]=svd(mmattemp,0);
   d(:,i)=diag(tempd);
   u1(:,i)=utemp(:,1);
   v1(:,i)=vtemp(:,1);
   u2(:,i)=utemp(:,2);
   v2(:,i)=vtemp(:,2);
end

d=permute(d,[2 1]);
u1=permute(u1,[2 1]);
v1=permute(v1,[2 1]);
u2=permute(u2,[2 1]);
v2=permute(v2,[2 1]);
if ndmmat==4;
  d=reshape(d,Mold,Nold,size(d,2),size(d,3));
  u1=reshape(u1,Mold,Nold,size(u1,2),size(u1,3));
  u2=reshape(u2,Mold,Nold,size(u2,2),size(u2,3));
  v1=reshape(v1,Mold,Nold,size(v1,2),size(v1,3));
  v2=reshape(v2,Mold,Nold,size(v2,2),size(v2,3));
end


