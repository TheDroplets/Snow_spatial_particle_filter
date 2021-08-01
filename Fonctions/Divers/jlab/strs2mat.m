function[mat]=strs2mat(x,flag)
%STRS2MAT  Converts a cell array of strings into a string matrix.
%
%   X=STRS2MAT(X) where X is a cell array of strings will return a new
%   version of X which has all text in formatted flush on the left.
%
%   See also FLUSHRIGHT
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2003, 2004 J.M. Lilly --- type 'help jlab_license' for details      
  
%Flag prevents recursion from flushleft
if nargin==1
  flag=0;
end

if ~iscell(x)
  xtemp=x;
  clear x
  x{1}=xtemp;
end

x=packstrs(x);

M=length(x);
for i=1:M
    n(i)=length(x{i});
end
N=max(n);

mat=setstr(32*ones(M,N)); %32 <==> ' ' 

for i=1:M
    if n(i)>0
       mat(i,1:n(i))=x{i};
    end
end

if ~flag
  mat=flushleft(mat);
end

