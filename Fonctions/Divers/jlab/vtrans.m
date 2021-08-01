function[varargout]=vtrans(varargin)
%VTRANS Generalized transpose of an N-D vector. 
%                                                                         
%   Y=VTRANS(X,N), where X is an array having exactly one non-singleton   
%   dimension, 'transposes' X so that the non-singleton dimension is      
%   oriented along dimension N.                                           
%                                                                         
%   When X is complex-valued, the sign of the imaginary terms in Y will   
%   be the same as in X. VTRANS is a therefore a transpose operator,      
%   generalized to multiple dimensions.                                   
%              
%   [Y1,Y2,...YN]=TRANS(X1,X2,...XN,N) also works.
%
%   VTRANS(X1,X2,...XN,N); with no output arguments overwrites the
%   original input variables.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details  
  
  
if strcmp(varargin{1}, '--t')
  vtrans_test,return
end
  
n=varargin{end};

for i=1:length(varargin)-1
  varargout{i}=vtrans1(varargin{i},n);
end

eval(to_overwrite(nargin-1))


  
function[y]=vtrans1(x,n)
L=length(x);
ndim=ndims(x);

if nargin==1
   n=1;
end

if ~issing(x)
   %if more than one dimension is non-singleton, error
   error('Input array must have only one non-singleton dimension.')
else
   str=['y=reshape(x,'];
   for i=1:n-1
       str=[str,'1,'];
   end
   if n==1
      %Reshape requires at least two size elements.
      str=[str,'L,1);'];
   else
      str=[str,'L);'];
   end   
   eval(str)
end



function[]=vtrans_test
x1=[1 2 3 4];
x2(1,1,1:4)=[1:4];   
ans1=x1';
ans2=x1';

vtrans(x1,x2,1);
reporttest('VTRANS output overwrite', aresame(x1,ans1)&aresame(x2,ans2))

