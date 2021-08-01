function[varargout]=vzeros(varargin);
%VZEROS   Initializes multiple variables to arrays of zeros or nans.
%
%   [X1,X2, ... XN]=VZEROS(M,N)  is equivalent to
%		
%      X1=ZEROS(M,N); X2=ZEROS(M,N); .... XN=ZEROS(M,N);
%
%   thus initializing all the output variables to arrays of zeros.
%
%   [X1,X2, ... XN]=VZEROS(M,N,NAN) initializes to NANs instead.
%
%   [X1,X2, ... XN]=VZEROS(M,N,K,... P) similiarly initializes the Xi
%   to N-D arrays of zeros having size M x N x K x ... P.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information (C)
%   2004 J.M. Lilly --- type 'help jlab_license' for details
  
if nargin~=0
  if strcmp(varargin{1}, '--t')
   vzeros_test,return
  end
end

bnan=0;
if isnan(varargin{end})
   bnan=1;
   varargin=varargin(1:end-1);
end



for i=1:nargout
  if bnan
    str=['varargout{' int2str(i) '}=nan*zeros('];
  else
    str=['varargout{' int2str(i) '}=zeros('];
  end
  
  for j=1:length(varargin)
      str=[str 'varargin{' int2str(j) '},'];
  end
  str=str(1:end-1);	
  str=[str ');'];
  eval(str)
end

function[]=vzeros_test

z=zeros(5,4,2);
[x,y]=vzeros(5,4,2);
reporttest('VZEROS zeros case', all(x==z&y==z))
z=nan*zeros(5,4,2);
[x,y]=vzeros(5,4,2,nan);
vswap(x,y,z,nan,0);
reporttest('VZEROS nans case', all(x==z&y==z))
 
