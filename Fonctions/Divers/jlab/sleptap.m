function[v,lambda]=sleptap(n,p,k)
%SLEPTAP  Calculate Slepian tapers.
%
%   [PSI,LAMBDA]=SLEPTAP(N,P,K) calculates the K lowest-order Slepian
%   tapers PSI of length N and time-bandwidth product P, together with
%   their eigenvalues LAMBDA. PSI is N x K and LAMBDA is K x 1.
%
%   K is optional and defaults to 2P-1.  
%   P is optional and defaults to 4.
%   
%   For N<256, SLEPTAP uses the tridiagonal method described in
%   Percival and Walden 1993.  For N>256, it first computes tapers for
%   N=256 and then spline-interpolates.
%   
%   See also MSPEC and MSVD
%
%   Usage:  [psi,lambda]=sleptap(n); 
%           [psi,lambda]=sleptap(n,p,k); 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        

%  02.09.04  JML fixed non-unit energy for interpolated tapers

if nargin==1
	p=4;
end

w=p./n;

if nargin<=2
	k=2*p-1;
end

%if n>256, interpolate
if n>256
	binterp=1;
	nnew=n;
	wnew=w;
	n=256;
	w=nnew*wnew/n;
else
	binterp=0;
end


%taper calculation using tridiagonal matrix
mat=zeros(n,n);
index=[1:n+1:n*n];
mat(index)=((n-1-2*[0:n-1])./2).^2.*cos(2*pi*w);
index2=index(1:length(index)-1)+1;
index3=index(2:length(index))-1;
mat(index2)=[1:n-1].*(n-[1:n-1])./2;
mat(index3)=[1:n-1].*(n-[1:n-1])./2;
disp(['Calculating tapers of length ',int2str(n)])
OPTIONS.disp=0;
[v,d]=eigs(mat,k,'LA',OPTIONS);



%calculate defining matrix and eigenvalues
if nargout==2
	i=[0:n-1]'*ones(1,n);
	j=i';
	A=pi*(i-j);
	index=find(A==0);
	A(index)=1;
	A=sin(2*pi*w*(i-j))./A;
	A(index)=2*w;
	%find eigenvalues
	for i=1:k
		%note unexplained matlab quirk: dividing
		%two column vectors gives you a column vector,
		%dividing two row vectors gives you a scalar
		lambda(i,1)=(A*v(:,i))'/v(:,i)';
	end
end

%interpolate
if binterp
	k=size(v,2);
	vi=zeros(nnew,k);
	disp(['Interpolating to length ',int2str(nnew)])
	for i=1:k
		vi(:,i)=sinterp(v(:,i),nnew);
	end
	v=vi;
end

%normalize
for i=1:k
	v(:,i)=v(:,i)/sqrt(v(:,i)'*v(:,i));
	if v(round(end/2),i)<0
	   v(:,i)=-v(:,i);
	end
end
 
%/***************************************************
%here's some garbage
if 0
%see how much spline-interpolated ones vary from others
xx=v(:,1);xx=xx/sqrt(xx'*xx);figure,plot(xx)
xx=diff(xx);xx=xx/sqrt(xx'*xx);hold on,plot(xx,'g')
xx=diff(xx);xx=xx/sqrt(xx'*xx);plot(xx,'r')
xx=diff(xx);xx=xx/sqrt(xx'*xx);plot(xx,'c');

for i=1:4
v(:,i)=v(:,i)/sqrt(v(:,i)'*v(:,i));
end

figure,plot(v)


l1=lambda;
v1=v;


k=4;
n=256;
w=4/n;
mat=zeros(n,n);
index=[1:n+1:n*n];
mat(index)=((n-1-2*[0:n-1])./2).^2.*cos(2*pi*w);
index2=index(1:length(index)-1)+1;
index3=index(2:length(index))-1;
mat(index2)=[1:n-1].*(n-[1:n-1])./2;
mat(index3)=[1:n-1].*(n-[1:n-1])./2;
[v,d]=eigs(mat,k);
%[d,index]=sort(diag(d));
%v=v(:,index);
%d=flipud(d);
%v=fliplr(v);
for i=1:4
v(:,i)=v(:,i)/sqrt(v(:,i)'*v(:,i));
end

A=calcdefmat(n,w);

for i=1:k
	lambda(i,1)=mean((A*v(:,i))\v(:,i));
end
v=v(:,1:k);
 
for i=1:4
	v1i(:,i)=interp1([1:100]/100',v1(:,i),[1:256]'/256,'cubic');
end
for i=1:4
v1i(:,i)=v1i(:,i)/sqrt(v1i(:,i)'*v1i(:,i));
end
end
%end garbage
%\***************************************************



function[a]=calcdefmat(n,w)
i=[0:n-1]'*ones(1,n);
j=i';
a=sin(2*pi*w*(i-j))./(pi*(i-j));
a(find(isnan(a)))=2*w;
