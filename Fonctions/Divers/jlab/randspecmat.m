function[S,C]=randspecmat(m)
%RANDSPECMAT  Generates random 2x2 spectral matrices for testing
%
%   S=RANDSPECMAT generates a random 2 x 2 spectral matrix.  S is
%   Hermitian with complex-valued off-diagnonal elements, with a
%   minimum determinant of zero.
%  
%   S=RANDSPECMAT(M) generates M such matrices, with S being 2x2xM.
%
%   [S,C]=RANDSPECMAT returns both a random spectral matrix and a
%   random complementary spectral matrix.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
   
if nargin==0
  m=1;
elseif strcmp(m,'--t')
  randspecmat_test;return
end

a=randn(m,1).^2;  
b=randn(m,1).^2;  
c=(2*rand(m,1)-1+2*sqrt(-1).*rand(m,1)-sqrt(-1)).*sqrt(a.*b./2);

S=zeros(2,2,m);
S(1,1,:)=a;
S(2,2,:)=b;
S(2,1,:)=c;
S(1,2,:)=conj(c);

if nargout ==2
  a=randn(m,1).^2.*rot(rand(m,1)*2*pi);
  b=randn(m,1).^2.*rot(rand(m,1)*2*pi);
  c=randn(m,1)+sqrt(-1).*randn(m,1);

  C=zeros(2,2,m);
  C(1,1,:)=a;
  C(2,2,:)=b;
  C(2,1,:)=c;
  C(1,2,:)=conj(c);
end

function[]=randspecmat_test
%disp('Testing some forumulas for spectral matrix with circularity')
%These tests are depricated --- not working right now
  
for i=1:100
S=randspecmat(1);
dets(i)=det(S);
end

  n=100;
[S,Cmat]=randspecmat(n);
Q=imag(S(1,2,:));
Q=ndrep(2,Q,1);
Q=ndrep(2,Q,2);

C=real(S(1,2,:));
C=ndrep(2,C,1);
C=ndrep(2,C,2);

alpha=(S(1,1,:)-S(2,2,:))./(S(1,1,:)+S(2,2,:));
alpha=ndrep(2,alpha,1);
alpha=ndrep(2,alpha,2);

E=S(1,1,:)+S(2,2,:);
E=ndrep(2,E,1);
E=ndrep(2,E,2);

I=0*S;
I(1,1,:)=1;
I(2,2,:)=1;

A=1+0*S;

K=0*S;
K(1,1,:)=rot(-pi./2);
K(2,2,:)=rot(pi./2);

J=0*S;
J(1,2,:)=1;
J(2,1,:)=-1;

Seo=0*S;
Sdc=0*S;
Spn=0*S;
Sxx=0*S;

[M,N]=mandn('eo');
for i=1:n
  Seo(:,:,i)=M*S(:,:,i)*M'+N*conj(S(:,:,i))*N';
end  

[M,N]=mandn('dc');
for i=1:n
  Sdc(:,:,i)=M*S(:,:,i)*M'+N*conj(S(:,:,i))*N';
end  

[M,N]=mandn('pn');
for i=1:n
  Spn(:,:,i)=M*S(:,:,i)*M'+N*conj(S(:,:,i))*N';
end  

[M,N]=mandn('x*');
for i=1:n
  Sxx(:,:,i)=M*S(:,:,i)*M'+N*conj(S(:,:,i))*N';
end  


S2=E.*(I+sqrt(-1).*K.*alpha)./2+(A-I).*C+sqrt(-1).*Q.*J;
b(1)=aresame(S2,S,tol);

Seo2=E.*I./2+sqrt(-1).*Q.*J;
b(2)=aresame(Seo2,Seo,tol);

Sdc2=E.*I./2;
b(3)=aresame(Sdc2,Sdc,tol);

Spn2=E.*I./2+sqrt(-1).*Q.*K;
b(4)=aresame(Spn2,Spn,tol);

Sxx2=E.*(I./2+(A-I).*alpha./2) +sqrt(-1).*Q.*K +sqrt(-1).*C.*J;
b(5)=aresame(Sxx2,Sxx,tol);

reporttest('Formulas for circular spectral matrices', all(b));



n=100;
[S,C]=randspecmat(n);

[M,N]=mandn('eo');
Seo=0*S;
Suv2=0*S;
Ceo=0*S;
Cuv2=0*S;

%Forwards to Seo
for i=1:n
  Seo(:,:,i)=M*S(:,:,i)*M'+N*conj(S(:,:,i))*N'+...
                M*C(:,:,i)*N'+N*conj(C(:,:,i))*M';
  Ceo(:,:,i)=M*C(:,:,i)*conj(M)'+N*conj(C(:,:,i))*conj(N)'+...
                M*S(:,:,i)*conj(N)'+N*conj(S(:,:,i))*conj(M)';
end  

%Going backwards to Suv
M=M';
N=conj(N');

for i=1:n
  Suv2(:,:,i)=M*Seo(:,:,i)*M'+N*conj(Seo(:,:,i))*N'+...
                M*Ceo(:,:,i)*N'+N*conj(Ceo(:,:,i))*M';
  Cuv2(:,:,i)=M*Ceo(:,:,i)*conj(M)'+N*conj(Ceo(:,:,i))*conj(N)'+...
                M*Seo(:,:,i)*conj(N)'+N*conj(Seo(:,:,i))*conj(M)';
end  

clear b
b(1)=aresame(S,Suv2,tol);
b(2)=aresame(C,Cuv2,tol);


if 0
[M1,N1]=mandn('dc');  %Converts uv to dc
[M2,N2]=mandn('eo');  %Converts uv to eo

M3=[M1*M2'+N1*N2'];      %Converts eo to dc
N3=[M1*conj(N2)'+N1*conj(M2)'];

M3=M3';      %Converts dc to eo
N3=conj(N3)';

M2=M2';      %Converts eo to uv
N2=conj(N2)';

%Forwards to dc
for i=1:n
  Sdc(:,:,i)=M1*S(:,:,i)*M1'+N1*conj(S(:,:,i))*N1';
end  

%Forwards to eo
for i=1:n
  Seo(:,:,i)=M3*Sdc(:,:,i)*M3'+N3*conj(Sdc(:,:,i))*N3';
end  

%Forwards to uv
for i=1:n
  Suv2(:,:,i)=M2*Seo(:,:,i)*M2'+N2*conj(Seo(:,:,i))*N2';
end  

b(3)=aresame(S,Suv2,tol);
end
