function[h1,h2]=patchhandles(axh)
%PATCHHANDES  Finds all patch handles from a given set of axes.
%
%   H=PATCHHANDLES returns handles to all lines associated with the
%   current axes.
%	 
%   H=PATCHHANDLES(AX) returns handles to all lines associated with
%   the set of axes whose handle is AX.
%
%   See also LINEHANDLES, AXESHANDLES
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if nargin==0
   axh=gca;
end
h=get(axh,'children');
bool=0*h;
for j=1:length(h)
    if strcmp(get(h(j),'type'),'patch')
       bool(j)=1;
    end
end
index1=find(bool);
index2=find(~bool);

h1=h(index1);     
h2=h(index2);     
