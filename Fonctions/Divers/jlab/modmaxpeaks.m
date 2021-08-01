function[varargout]=modmaxpeaks(varargin)
%MODMAXPEAKS Locates peaks of wavelet transform modulus maxima lines.
%
%   [IX,JX,YX]=MODMAXPEAKS(IM,JM,YM,CHI) where IM and JM are the time- and
%   scale- indices, respectively, into a wavelet modulus maxima line,  and 
%   YM is the corresponding transform modulus, locates isolated peaks along 
%   the maxima lines whose amplitude YM exceeds CHI.  IX, JX, and YX are 
%   then time index, scale index, and transform modulus of the these peaks.  
%  
%   [IX,JX,YX]=MODMAXPEAKS(IM,JM,YM,CHI,JMIN) limits the search for peaks to  
%   modulus maxima points with scale numbers JM exceeding or equal to JMIN.
%
%   [IX,JX,YX]=MODMAXPEAKS(IM,JM,YM,CHI,[JMIN JMAX]) limits the search to  
%   points with scale numbers JM such that JMIN <= JM <= JMAX.
% 
%   IM, JM, and YM are output by MODMAX.
%
%   [IX,JX,YX,AX,... ZX]=MODMAXPEAKS(IM,JM,YM,AM,... ZM,...) where AM 
%   through ZM are matrices of the same size as IM,JM, and YM, also returns 
%   the values of these matrices at the peaks.
%  
%   Usage: [ix,jx,yx]=modmaxpeaks(im,jm,ym,chi);
%          [ix,jx,yx]=modmaxpeaks(im,jm,ym,chi,[jmin jmax]);
%          [ix,jx,yx,tx,ax]=modmaxpeaks(im,jm,ym,tm,am,chi,[jmin jmax]);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1999, 2004 J.M. Lilly --- type 'help jlab_license' for details        
 
cutoff2=-inf;
	  
Tr=varargin{3};
jr=varargin{2};

jmin=2;
jmax=size(Tr,1)-1;
na=nargin;

if length(varargin{end})==1
    if length(varargin{end-1})==1
         cutoff=varargin{end-1};
	 jmin=varargin{end};
         na=na-2;
    else
         cutoff=varargin{end};
	 na=na-1;
    end
elseif length(varargin{end})==2
    cutoff=varargin{end-1};  
    jmin=varargin{end}(1);
    jmax=varargin{end}(2);     
    na=na-2;
end

tol=0.00001;
boolmat=zeros(size(Tr));

for j=1:size(Tr,2)
    bool=0;
    for i=jmin:jmax

	if Tr(i,j)>=Tr(i-1,j)+tol&Tr(i,j)>=Tr(i+1,j)+tol
	   if Tr(i,j)-min(Tr(find(~isnan(Tr(1:i,j))),j))>cutoff2
   	      bool=1;
	      boolmat(i,j)=1;
           end
        end
    end
end

index=find(Tr<cutoff);
if ~isempty(index)
  boolmat(index)=0;
end
index=find(boolmat);
if ~isempty(index)
    for i=1:na
       varargout{i}=varargin{i}(index);
    end
else
    for i=1:na 
       varargout{i}=[];
    end
end
