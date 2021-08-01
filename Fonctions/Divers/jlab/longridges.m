function[varargout]=longridges(varargin)
%LONGRIDGES  Removes ridge lines of length than a specified length
%
%   [NR,IR,JR]=LONGRIDGES(NR,IR,JR,L) 
%   [NR,IR,JR,AR,...ZR]=LONGRIDGES(NR,IR,JR,AR,...ZR,L) 
  
na=nargin-1;
id=varargin{1};
ii=varargin{2};
jj=varargin{3};
Nl=varargin{end};

if length(Nl)==1
   Nl=Nl+0*[1:max(jj)];
end
Nl=Nl(:);

if na>3
  x=varargin(4:na);
end
%Remove lines of less than a certain length
%/********************************************************
bdone=0;
while ~bdone
%  length(id)
  len=blocklen(id);

  index=find(len>=Nl(jj));
  if length(index)==length(id)
    bdone=1;
  else
    vindex(id,ii,jj,index,1);
    for i=1:length(x)
       x{i}=vindex(x{i},index,1);
    end
    if ~isempty(id)
       id=blocknum(ii,1);
    else
      bdone=1;
    end 
  end
end
varargout{1}=id;
varargout{2}=ii;
varargout{3}=jj;
if na>3
  varargout(4:na)=x;
end
%\********************************************************

%eval(to_overwrite(na));
