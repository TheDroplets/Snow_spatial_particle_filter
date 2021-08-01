function[varargout]=vfilt(varargin)
%VFILT  Filtering along rows without change in length.
%
%   Y=VFILT(X,FILTER) convolves FILTER with X along their rows and
%   crops the result Y to be the same length as X. If FILTER is a
%   number, a Hanning filter of that length is used.  
%                                                                         
%   By default, the roughly length(FILTER)/2 data points on each end
%   of Y that are contaminated by edge effects are replaced with
%   NAN's. This option may be turned off with Y=VFILT(X,FILTER,1).
%
%   [Y1,Y2,...YN]=VFILT(X1,X2,...XN,FILTER) also works.
%
%   VFILT(X1,X2,...XN,FILTER); with no output arguments overwrites the
%   original input variables.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2005 J.M. Lilly --- type 'help jlab_license' for details    
 
%if strcmp(varargin{1}, '--t')
%  vfilt_test,return
%end

narg=nargin;
bnan=1;
if aresame(varargin{end},1)|aresame(varargin{end},0)
   bnan=~varargin{end};
   varargin=varargin(1:end-1);
   narg=narg-1;
end

n=varargin{end};

for i=1:narg-1
    varargout{i}=vfilt1(varargin{i},n,bnan);
end
 
eval(to_overwrite(narg-1))

function[smooth]=vfilt1(data,filter,bnan)
if nargin==2, bnan=1;end

if length(filter)==1
	filter=hanning(filter);
    filter=filter./sum(filter);
end
%if sum(filter)~=0
%   filter=filter./sum(filter);
%end
%FILTER is    automatically normalized to sum to one.  
smooth=zeros(size(data));
a=round(length(filter)/2);
N=size(data,1);
n=length(filter);

if N<=n&bnan
  warning(['Not enough rows to filter the data with a ' int2str(n) ...
	 ' filter'])
end

if res(n/2)==0
   halfn=floor(n/2);
else 
   halfn=floor((n-1)/2);
end

for i=1:size(data,2)
	temp=conv(data(:,i),filter);
	smooth(:,i)=temp(a:a+N-1);
	if bnan
		smooth(1:halfn,i)=nan*ones(halfn,1);
		smooth(N-halfn+1:N,i)=nan*ones(halfn,1);
	end
end


