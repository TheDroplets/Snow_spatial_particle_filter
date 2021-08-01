function[v1,v2]=vectmult(i1,i2,i3,i4)
%VECTMULT  Matrix multiplication for arrays of two-vectors. 
%
%   [Y1,Y2]=VECTMULT(M,X1,X2) where MAT is a 2x2 matrix and X1 and X2
%   are length K column vectors, returns Y1 and Y2 which result from
%   the matrix multiplication of [X1(k); X2(k)] with MAT, i.e.
%
%    [Y1(k); Y2(k)] = M * [X1(k); X2(k)].
%
%   [Y1,Y2]=VECTMULT(M,N,X1,X2) forms the widely linear product
%  
%    [Y1(k); Y2(k)] = M * [X1(k); X2(k)] + N * CONJ([X1(k); X2(k)])
%
%   where N is also a 2x2 matrix.
%  
%   VECTMULT also works if the input matrices M and N are size 2x2xK.
%  
%   Y=VECTMULT(M,X) or Y=VECTMULT(M,N,X) where X is an array of size
%   2x1xK, similarly returns an array Y of the same size as X whose
%   elements result from the matrix multiplications discussed above.
%
%   Usage: y=vectmult(m,x);  
%         [y1,y2]=vectmult(m,x1,x2);
%         y=vectmult(m,n,x);  
%         [y1,y2]=vectmult(m,n,x1,x2);  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

  
%x=jmat1(theta);    

if strcmp(i1,'--t')
  vectmult_test;return
end

mat2=[];
breshape=0;

if nargin==2
  breshape=1;
  mat1=i1;
  u1=i2(1,:,:);
  u2=i2(2,:,:);
elseif nargin==3
  mat1=i1;
  if size(i2,1)==2&size(i2,2)==2
    mat2=i2;
    breshape=1;
    u1=i3(1,:,:);
    u2=i3(2,:,:);
  else
    u1=i2;
    u2=i3;
  end
elseif nargin==4
  mat1=i1;
  mat2=i2;
  u1=i3;
  u2=i4;
end
sizeu=size(u1);
u1=u1(:);
u2=u2(:);

%/********************************************************
%linear portion
[v1,v2]=vectmult1(mat1,u1,u2);

%widely linear portion, if requested
if ~isempty(mat2)
  [v1b,v2b]=vectmult1(mat2,conj(u1),conj(u2));
  v1=v1+v1b;
  v2=v2+v2b;
end
%\********************************************************

if breshape
  v1=[reshape(v1,[1 1 length(v1)]);reshape(v2,[1 1 length(v2)])];
end
v1=reshape(v1,sizeu);
v2=reshape(v2,sizeu);


function[v1,v2]=vectmult1(mat,u1,u2);

m1=mat(1,1,:);
m2=mat(1,2,:);
m3=mat(2,1,:);
m4=mat(2,2,:);

m1=m1(:);
m2=m2(:);
m3=m3(:);
m4=m4(:);

v1=m1.*u1+m2.*u2;
v2=m3.*u1+m4.*u2;

function[]=vectmult_test
tol=1e-10;
M=100;
th=rand(M,1)*2*pi;

xo=randn(2,1,M);
xo1=squeeze(xo(1,:,:));
xo2=squeeze(xo(2,:,:));

xf=vectmult(jmat(th),xo);
[xf1,xf2]=vectmult(jmat(th),xo1,xo2);

xfo=0*xo;
for i=1:M
  xfo(:,:,i)=jmat(th(i))*xo(:,:,i);
end
b(1)=aresame(xfo,xf,tol);
b(2)=aresame(squeeze(xfo(1,:,:)),xf1,tol)&aresame(squeeze(xfo(2,:,:)),xf2,tol);

reporttest('VECTMULT linear 3-d vector format',b(1))
reporttest('VECTMULT linear vector component format',b(2))

xf=vectmult(jmat(th),kmat(th),xo);
[xf1,xf2]=vectmult(jmat(th),kmat(th),xo1,xo2);

xfo=0*xo;
for i=1:M
  xfo(:,:,i)=jmat(th(i))*xo(:,:,i)+kmat(th(i))*conj(xo(:,:,i));
end
b(1)=aresame(xfo,xf,tol);
b(2)=aresame(squeeze(xfo(1,:,:)),xf1,tol)&aresame(squeeze(xfo(2,:,:)),xf2,tol);

reporttest('VECTMULT widely linear 3-d vector format',b(1))
reporttest('VECTMULT widely linear vector component format',b(2))



