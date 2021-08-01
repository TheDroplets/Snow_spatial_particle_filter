function[]=xtick(i1,i2);
%XTICK  Set locations of x-axis tick marks.
%
%   XTICK(DX) or XTICK DX where DX is a number uses DX as the interval
%   between successive x-tick marks, with the endpoints being the
%   left- and right-hand axes limits, and applies this to the current
%   axis.
%
%   XTICK(DX) where DX is an array sets the 'xtick' property of the
%   current axis to DX.
%
%   XTICK(H,DX) applies the change to axes H 
% 
%   See also YTICK
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details  

  if(nargin==1)
   h=gca;
   dx=i1;
else
   h=i1;
   dx=i2;
end


if isstr(dx)
  dx=str2num(dx);
end

if length(dx)==1
  x=get(h,'xlim');
  set(gca,'xtick',[x(1):dx:x(2)])
else
  set(gca,'xtick',dx);
end
