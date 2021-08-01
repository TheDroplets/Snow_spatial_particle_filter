function[y]=matmult(m,x,n,str)
%MATMULT  Matrix multiplication for arrays of 2 x 2 matrices. 
%
%   Y=MATMULT(M,X,N) where M and X are 2 x 2 matrices, returns
%  
%      Y=M*X*N
%
%   which is the usual definition of the matrix mutliplication.
%
%   MATMULT also works if the input matrices are of size 2x2xK, in
%   which case the matrix multiplication is carried out for each of
%   the K matrices.  Y is then of size 2x2xK.
%
%   MATMULT works if some of the matrices are 2x2 and some are 2x2xK.
%
%   In order to ensure returing real-valued quantities when it is 
%   appropriate, MATMULT strips the imaginary parts if their
%   magnitudes fall below a threshold value of 1e-12.
%
%   'matmult --t' runs a test.
%
%   Usage: y=matmult(m,x,n); 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(m, '--t')
  matmult_test,return
end

if nargin<4
  str='fast';
end

if strcmp(str(1:3),'slo')
  y=matmult_slow(m,x,n);
elseif strcmp(str(1:3),'fas')
  y=matmult_fast(m,x,n);
end

for i=1:2
  for j=1:2
     if maxmax(abs(imag(y(i,j,:)))<1e-12)
        y(i,j,:)=real(y(i,j,:));
     end
  end
end


function[y]=matmult_slow(m,x,n)
y=zeros(size(m));
K=max([size(x,3),size(m,3),size(n,3)]);
if size(x,3)==1
  x=ndrep(K,x,3);
end
  if size(m,3)==1
  m=ndrep(K,m,3);
end
if size(n,3)==1
  n=ndrep(K,n,3);
end

for i=1:K
  y(:,:,i)=m(:,:,i)*x(:,:,i)*(n(:,:,i));
end


function[z]=matmult_fast(m,x,n)

n11=n(1,1,:);
n22=n(2,2,:);
n12=n(1,2,:);
n21=n(2,1,:);

m11=m(1,1,:);
m22=m(2,2,:);
m12=m(1,2,:);
m21=m(2,1,:);

x11=x(1,1,:);
x22=x(2,2,:);
x12=x(1,2,:);
x21=x(2,1,:);

y11=x11.*n11+x12.*n21;
y12=x11.*n12+x12.*n22;
y21=x21.*n11+x22.*n21;
y22=x21.*n12+x22.*n22;

z11=m11.*y11+m12.*y21;
z12=m11.*y12+m12.*y22;
z21=m21.*y11+m22.*y21;
z22=m21.*y12+m22.*y22;


z(1,1,:)=z11;
z(2,2,:)=z22;
z(1,2,:)=z12;
z(2,1,:)=z21;

function[]=matmult_test

N=100;
s=rand(2,2,N)+sqrt(-1)*rand(2,2,N);
m=rand(2,2,N)+sqrt(-1)*rand(2,2,N);
n=rand(2,2,N)+sqrt(-1)*rand(2,2,N);

tic;s1=matmult(m,s,n,'slow');et1=toc;
tic;s2=matmult(m,s,n,'fast');et2=toc;
reporttest('MATMULT fast and slow algorithms match',aresame(s1,s2,1e-12)) 
disp(['MATMULT fast algorithm was ' num2str(et1./et2,3) ' times faster than slow version'])
