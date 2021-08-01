function[varargout]=ridgechoose(varargin);
% RIDGECHOOSE  Extracts the largest-amplitude ridge at a given time.
%
%   [IS,JS,WS]=RIDGECHOOSE(IR,JR,WR) where IR and JR contains indices 
%   into row and column locations, respectively, of ridges along which 
%   transfrom values WR are observed, chooses only that subset of ridges
%   exhibiting the with largest absolute value of WR at a given time.  
%   __________________________________________________________________
%
%   Additional output 
%
%   [WM,WM1,WM2,..., WMN]=RIDGECHOOSE(X,IR,WR,WR1,WR2,..., WRN) also maps
%   values of the ridge properties WR1, WR2,... WRN into column vectors 
%   of the same length as X, always using WR to select among multiple
%   ridges present at the same time.
%   __________________________________________________________________
%
%   Multi-component datasets
% 
%   RIDGECHOOSE also works when SIZE(W,3)>1, that is, when X contains say
%   K different dataset components.  In this case the input format is
%   [IS,JS,KS,WS,...]=RIDGECHOOSE(IR,JR,KR,WR,... ).
%   __________________________________________________________________
%
%   See also RIDGEWALK, RIDGEINTERP.
%
%   Usage:  wm=ridgechoose(x,ir,wr);
%           [wm,wm1,wm2]=ridgechoose(x,ir,wr,wr1,wr2);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details        

ir=varargin{1};
jr=varargin{2};

if ~isreal(allall(nonnan(i3)))
    kr=1+0*ir;
    wr=varargin{3};
    na=3;
else
    kr=varargin{3};
    wr=varargin{4};
    na=4;
end


for k=1:size(ir,3)
    indexk=find(kr(1,:)==k);
    if ~isempty(indexk)
        irk=ir(:,indexk);
        jrk=jr(:,indexk);
        wrk=wr(:,indexk);
        index_islargest=find(islargest(irk(:),krk(:),wrk(:)));
        bool=zeros(size(irk));
        if ~isempty(index_islargest)
            bool(index_islargest)=1;
        end
        
    
   

%/********************************
irm=nan*zeros(length(z),1);
krm=nan*zeros(length(z),1);
wrm=nan*zeros(size(z));

indexr=sub2ind(size(z),ir,kr);
irm(ir)=ir;
krm(ir)=kr;
wrm(indexr)=wr;

varargout{1}=wrm;

for i=na+1:nargin 
  wi=varargin{i};
  vcolon(wi);
  %vindex(wi,nani,1);
  vindex(wi,index_islargest,1);

  wim=nan*zeros(size(z)); 
  wim(indexr)=wi;
  
  varargout{i-na+1}=wim;
end
%\********************************


