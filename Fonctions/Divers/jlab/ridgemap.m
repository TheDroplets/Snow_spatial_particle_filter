function[wm,fm]=ridgemap(struct,i2,i3);
% RIDGEMAP  Map wavelet ridge properties onto original time series.
%
%   [WM,FM]=RIDGEMAP(STRUCT) where STRUCT is a ridge structure as
%   output by RIDGEWALK, maps the ridge transform values into an 
%   array WM and the ridge frequencies into an array FM.  
%
%   WM and FM both have the same number of rows and columns as the 
%   original dataset, with each "page" corresponding to a different
%   ridge.  Thus, SIZE(WM,3) and SIZE(FM,3) equal the maximum number
%   of different ridges occurring at any dataset component.
%
%   If there occurs only one ridge at each data set components, then 
%   WM and FM are the same size as the original data matrix.
%   _________________________________________________________________
%
%   Collapsing
%
%   RIDGEMAP(STRUCT,'collapse') optionally collapses WM and FM 
%   along the third dimension, so that WM and FM are the same size as
%   the original dataset.  This is useful if there exists at most one
%   ridge at each time, for example, if STRONGRIDGE has been used.
%   _________________________________________________________________
%
%   See also RIDGEWALK, RIDGEINTERP, STRONGRIDGE.
%
%   Usage:  [wm,fm]=ridgemap(struct);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details        


use struct

str='all';
dt=1;
if nargin==2;
    if isstr(i2)
        str=i2;
    else
        dt=i2;
    end
end
if nargin==3;  
    str=i3;
    dt=i2;
end

kn=kr(1,:);
for k=minmin(kr):maxmax(kr)
  index=find(kn==k|isnan(kn));
  if ~isempty(index)
     nridges(k)=length(index);
  end
end
maxk=maxmax(nridges);

wm=nan*zeros(size(w,1),size(w,3),maxk);
fm=nan*zeros(size(w,1),size(w,3),maxk);

%Keep track of how many ridges at each data component
nk=zeros(size(w,3),1);

for i=1:size(ir,2)
    index=find(isfinite(ir(:,i)));
    if ~isempty(index)
         %Add one to number of ridges at this data component
         nk(kn(i))=nk(kn(i))+1;
         wm(ir(index,i),kn(i),nk(kn(i)))=wr(index,i);
         fm(ir(index,i),kn(i),nk(kn(i)))=fr(index,i)./dt;
    end
end
%\********************************

if strcmp(str(1:3),'col')
    wm=vsum(wm,3);
    fm=vsum(fm,3);
end




