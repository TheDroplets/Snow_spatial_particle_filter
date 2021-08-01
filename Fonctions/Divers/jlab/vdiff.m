function[varargout]=vdiff(varargin)
%VDIFF	Length-preserving first central difference.
%
%   DX=VDIFF(X) differentiates the columns of X using the first central   
%   difference; DX is the same size as X.                                 
%                                                                        
%   DX=VDIFF(X,DIM) performs the first central difference along 
%   dimension DIM.
%  
%   DXDT=VDIFF(X,DIM,DT) optionally uses scalar timestep DT to approximate
%   a time derivative, i.e. DXDT equals DX divided by DT.
%
%   [D1,D2,...DN]=VDIFF(X1,X2,...XN,DIM,[DT]) for multiple input variables 
%   also works. 
%
%   VDIFF(X1,X2,...DIM,[DT]); with no output arguments overwrites the
%   original input variables.
%                                                      
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2005 J.M. Lilly --- type 'help jlab_license' for details    
  
%   I am so irritated by diff

 
if strcmp(varargin{1}, '--t')
  vdiff_test,return
end

na=nargin;
n=varargin{end};
dt=1;

if length(n)==1
   if length(varargin{end-1})==1
       dt=varargin{end};
       n=varargin{end-1};
       na=na-2;
   else
       na=na-1;
   end
else
   n=1;
end

for i=1:na
  varargout{i}=vdiff1(varargin{i},n)./dt;
end

if nargin>1
  eval(to_overwrite(na))
end

function[y]=vdiff1(x,n)
  	  
y=vshift(x,1,n)/2-vshift(x,-1,n)/2;
y=vnan(y,1,n);
y=vnan(y,size(y,n),n);


function[]=vdiff_test

y1=[1:4]';
y2=2*[1:4]';
[x1,x2]=vdiff(y1,y2);
bool=aresame(x1,[nan 1 1 nan]').*aresame(x2,2*[nan 1 1 nan]');
reporttest('VDIFF', bool)
vdiff(y1,y2);
bool=aresame(y1,[nan 1 1 nan]').*aresame(y2,2*[nan 1 1 nan]');
reporttest('VDIFF output overwrite', bool)

dt=pi;
y1=[1:4]';
y2=2*[1:4]';
[x1,x2]=vdiff(y1,y2,1,pi);
bool=aresame(x1,[nan 1 1 nan]'./dt).*aresame(x2,2*[nan 1 1 nan]'./dt,1e-10);
reporttest('VDIFF with non-unit time step', bool)
