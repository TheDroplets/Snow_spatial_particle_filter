function[varargout]=vnan(varargin)
%VNAN  Sets specified elements of multiple arrays to NANs.
%
%   Y=VNAN(X,INDEX,DIM) is equivalent to Y=X; followed by
%  
%		    1 2      DIM2     DIMS(X)
%		    | |        |         |
%                 Y(:,:, ... INDEX, ..., :)=NAN;	  
%
%   Y=VNAN(X,I1,D1,I2,D2,...IN,DN) with multiple indices I1--IN operating 
%   along multiple dimension D1--DN sets to NANs the elements at the 
%   intersection of all the subsets.  
%  
%   Example: x=[1 2 3 4 5];
%            vshift(x,+1,2)=[2 3 4 5 1]           
%            vshift(x,-1,2)=[5 1 2 3 4]           
%
%   Note shifting by N and then by -N recovers the original array. 
%
%   [Y1,Y2,...YN]=VSHIFT(X1,X2,...XN,N,DIM) also works.
%
%   VSHIFT(X1,X2,...XN,N,DIM); with no arguments overwrite the original 
%   input variables.
%
%   Y=VSHIFT(X,N,DIM,INDEX,DIM2) applies this shift selectively, only to
%   that subset of X obtained by indexing X with INDEX along DIM2, i.e.
%
%		    1 2      DIM2     DIMS(X)
%		    | |        |         |
%		  X(:,:, ... INDEX, ..., :)	
%
%   is cycled N places along dimension DIM, but the remainder of X is not. 
%   DIM and DIM2 cannot be the same.  The above extensions to multiple 
%   output varibles work in this case as well.  
%
%   See also: VINDEX  
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005 J.M. Lilly --- type 'help jlab_license' for details    
  
if strcmp(varargin{1}, '--t')
  vnan_test,return
end


%/********************************************************
%Sort out input arguments
bool=zeros(nargin,1);
for i=1:nargin
  bool(i)=isscal(varargin{i});
end
%Counting backwards from the end, looking for 'DIM' arguments
nindices=max(find(bool(end:-2:1)));
nvars=nargin-nindices*2;
%\********************************************************

varargin(nvars+1:end);
index=vnan_makeindex(size(varargin{1}),varargin(nvars+1:end));

if ~isempty(index)
  for i=1:nvars
    varargin{i}(index)=nan;
  end
end

varargout=varargin(1:nvars);
eval(to_overwrite(nvars));

if nargout==0
  clear varargout
end

function[index]=vnan_makeindex(sizex,varcell)  

ii=varcell(1:2:end);
dim=cell2mat(varcell(2:2:end));

bool=ones(sizex);

for i=[1:length(dim)]
  bool1=zeros(sizex);
  bool1=vindexinto(bool1,1,ii{i},dim(i));
  bool=bool.*bool1;
end

index=find(bool);


function[]=vnan_test
x=[1:10];
ans1=x;ans1([9 10])=nan; 
reporttest('VNAN row case', aresame(vnan(x,[9 10],2),ans1))

x=[1:10]';
ans1=x;ans1([9 10])=nan; 
reporttest('VNAN col case', aresame(vnan(x,[9 10],1),ans1))

clear x ans1
x(:,:,1)=[1 2; 3 4];
x(:,:,2)=2*[1 2; 3 4];
ans1=x;
ans1(:,1,:)=nan;
reporttest('VNAN mat case one',  aresame(vnan(x,1,2),ans1))

clear x ans1
clear x ans1
x(:,:,1)=[1 2; 3 4];
x(:,:,2)=2*[1 2; 3 4];
ans1=x;
ans1(1,1,1)=nan;ans1(1,1,2)=nan;
reporttest('VNAN mat selective case two', aresame(vnan(x,1,1,1,2),ans1))

