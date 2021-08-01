function h=hermpoly(t,n)
% HERMPOLY  Hermite polynomials.
%
%   H=HERMPOLY(T,N) generates the first N orthonormal Hermite
%   polynomials on a time axis specfied by the column vector T.
%
%   Note that H(:,1) is the 'zeroth' order Hermite polynomial, etc.
%
%   See also HERMFUN and HERMEIG
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 F. Rekibi and J. M. Lilly 
%                         --- type 'help jlab_license' for details  

% 07.09.04  JML fixed output size bug for N=1 
  
if strcmp(t,'--t')
  hermpoly_test;return
end

if (size(t,1)==1)
	t=t';	% t vecteur colonne
end

h=zeros(length(t),n);

h(:,1)=ones(size(t,1),1);

if n>1
	h(:,2)=2.*t;
	if n>=2
		for i=3:n
			h(:,i)=2.*t.*h(:,i-1)-2.*(i-2).*h(:,i-2);
		end
	end
end
   
function[]=hermpoly_test
t=[-2:.01:2]';
n=5;
h=hermpoly(t,n);
h2(:,1)=1 +0*t;%H0
h2(:,2)=2.*t;     %H1
h2(:,3)=4*t.^2-2;     %H2
h2(:,4)=8.*t.^3-12.*t;   %H3
h2(:,5)=16.*t.^4-48.*t.^2+12;   %H4

tol=1e-10;
b=aresame(h,h2,tol);
reporttest('HERMPOLY Hermites 0-4 match analytic expressions',b);

%figure,plot(t,h)  
%Does not match figure at 
%     http://mathworld.wolfram.com/HermitePolynomial.html
%although equations do.  Probably they have normalized.
