function[varargout]=vswap(varargin)
%VSWAP(X,A,B) replaces A with B in numeric array X
%
%   VSWAP(X,A,B) replaces A with B in numeric array X.  A and B may be
%   numbers, NAN, INF, or NAN+SQRT(-1)*NAN.
%
%   [Y1,Y2,...YN]=VSWAP(X1,X2,...XN,A,B) also works.
%
%   VSWAP(X1,X2,...XN,A,B); with no output arguments overwrites the 
%   original input variables.    
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details  

if strcmp(varargin{1}, '--t')
  vswap_test,return
end
 
  
a=varargin{end-1};
b=varargin{end};

for i=1:length(varargin)-2
  x=varargin{i};
  varargout{i}=swapnum1(x,a,b);
end

eval(to_overwrite(nargin-2))  


function[x]=swapnum1(x,a,b)
    
    
if isfinite(a)
  index=find(x==a);
else
  if isnan(a)
    index=find(isnan(x));
  elseif isinf(a)
    index=find(isinf(x));
  elseif isnan(real(a))&isnan(imag(a))
    index=find(isnan(real(x))&isnan(imag(x)));
  end
end

if ~isempty(index)
  x(index)=b;
end

function[]=vswap_test
x=[1:10];
ans1=[2 2:10];
reporttest('VSWAP num case', aresame(vswap(x,1,2),ans1))

x=[nan 1:10];
ans1=[0:10];
reporttest('VSWAP nan case', aresame(vswap(x,nan,0),ans1))
