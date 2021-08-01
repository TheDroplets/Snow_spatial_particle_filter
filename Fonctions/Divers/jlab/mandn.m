function[M,N]=mandn(str)
%MANDN  Widely linear transformation matrices M and N
%  
%   [M,N]=MANDN(AB) returns the transformation matrices M and N
%   necessary to another transform from the (u,v) transform vector
%   to the vector specified by string AB using the widely linear   
%   formulation
%
%        w_{ab} = M w_{uv} + N conj(w_{uv})     
%
%   Valid values for STR are:
%  
%         'uv', 'eo', 'dc', 'pn', and 'x*',  
%
%   with the latter being for the 'xi / conj xi' pair.  'xy' may be
%   used as a synonym for 'uv'.  
%
%   [M,N]=MANDN(X) where X is a number from 1 to 4 also works.
%
%   Appending a minus sign to any of these strings, i.e. 'eo-', or
%   using a negative number from -1 to -4, returns the M and N
%   matrices which recover the (u,v) transform pair using the
%   inversion formula
%
%        w_{uv} = M w_{ab} + N conj(w_{ab}).       
%
%   See Lilly (2004) for details.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

  
if nargin==1
  K=1;
end

binvert=0;
if length(str)==3
  binvert=1;
  str=str(1:2);
end


if ~isstr(str)
  n=str;
  if n==1
    str='eo';
  elseif n==2
    str='dc';
  elseif n==3
    str='pn';
  elseif n==4
    str='x*';
  end
end

clear i
if strcmp(str,'dc')
%  M=frac(1,2)*[1 -1; 1 1];
%  N=frac(1,2)*[1 1; -1 1];
  M=frac(1,2)*[1 -1; -1 1];
  N=frac(1,2)*[1 1; 1 1];
elseif strcmp(str,'eo')
  M=frac(1,2)*[1 i; -i 1];
  N=frac(1,2)*[1 i; i -1];
elseif strcmp(str,'pn')
  M=frac(1,sqrt(2))*[1 i; 0 0 ];
  N=frac(1,sqrt(2))*[0 0 ; 1 i];
elseif strcmp(str,'x*')
  M=frac(1,sqrt(2))*[1 i; 1 -i];
  N=zeros(2);
elseif strcmp(str,'uv')|strcmp(str,'xy')
  M=eye(2);
  N=zeros(2);
else
  error(['STR value ' str ' is not supported.'])
end

if binvert
  M=M';
  N=conj(N');
end

%   [M,N]=MANDN(...,K) returns 3-D arrays of K copies of the
%   transformation marices, each having dimension 2 x 2 x N.
%   
%if K~=1
%  M=ndrep(K,M,3);
%  N=ndrep(K,N,3);
%end
  

