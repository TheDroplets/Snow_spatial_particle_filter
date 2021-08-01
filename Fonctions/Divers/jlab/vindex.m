function[varargout]=vindex(varargin);
%VINDEX  Indexes an N-D array along a specified dimension.
%
%   Y=VINDEX(X,INDEX,DIM) indexes the multidimensional array X along     
%   dimension DIM. This is equivalent to   
%		
%		    1 2       DIM     DIMS(X)
%		    | |        |         |
%		Y=X(:,:, ... INDEX, ..., :);		
%
%   where the location of INDEX is specified by DIM.
%
%   VINDEX is defined to return an empty array if INDEX is empty.
%  
%   [Y1,Y2,...YN]=VINDEX(X1,X2,...XN,INDEX,DIM) also works.
%
%   VINDEX(X1,X2,...XN,INDEX,DIM); with no output arguments overwrites 
%   the original input variables.
%
%   See also VINDEXINTO, SQUEEZE, DIMS, PERMUTE, SHIFTDIM.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details    
  
if strcmp(varargin{1}, '--t')
  vindex_test,return
end

index=varargin{end-1};
dim=varargin{end};

nvars=nargin-2;
vars=varargin(1:nvars);

%eval(to_grab_from_caller(2))  %assigns vars, varnames, nvars

for i=1:nvars
  varargout{i}=vindex1(vars{i},index,dim);
end

eval(to_overwrite(nargin-2));

%now to_overwrite uses
%varnames not inputnames ... and does not take input argument
   
function[y]=vindex1(x,index,dim)  
%You would think Matlab would provide a simpler way to do this.
str=['y=x('];
ndx=length(find(size(x)>=1));
if ~isempty(index)
  for i=1:ndx
      if i~=dim
          str=[str ':,'];
      else
  	str=[str 'index,'];
      end
  end
  str=[str(1:end-1) ');'];
  eval(str);
else
  y=[];
end

function[]=vindex_test
x1=[1 1; 2 2];
index=2;
ans1=x1(:,index);
vindex(x1,index,2);
reporttest('VINDEX col case', aresame(x1,ans1))

x1=[1 1; 2 2];
index=2;
ans1=x1(index,:);
vindex(x1,index,1);
reporttest('VINDEX row case', aresame(x1,ans1))

