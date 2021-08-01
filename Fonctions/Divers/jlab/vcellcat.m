function[varargout]=vcellcat(varargin)
%VCELLCAT  Concatenates cell arrays of column vectors.
%
%   Y=VCELLCAT(X), where X is a cell array containing column vectors
%   of arbitrary length, concatenates all the column vectors together
%   and return the result in column vector Y.
%  
%   [Y1,Y2,...YN]=VCELLCAT(X1,X2,...XN) concatenates each of the cell
%   arrays Xi into the respective column vector Yi.
%
%   VCELLCAT(X1,X2,...XN); with no output arguments overwrites the
%   original input variables.  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(varargin{1},'--t')  
   vcellcat_test;return
end
   
for i=1:nargin
    x=varargin{i};
    L=sum(lengthcells(x));
    a=1;b=length(x{1});
    y=zeros(L,1);
    for j=1:length(x)
       y(a:b)=x{j};
       if j<length(x)
	 a=b+1;
         b=a+length(x{j+1})-1;
       end
    end
    varargout{i}=y;
end

eval(to_overwrite(nargin));

function[]=vcellcat_test
x{1}=[1 1]';
x{2}=3;
x{3}=[2 2 2]';
y=x;
z=[1 1 3 2 2 2]';
vcellcat(x,y);
reporttest('VCELLCAT', aresame(x,z)&aresame(y,z))
