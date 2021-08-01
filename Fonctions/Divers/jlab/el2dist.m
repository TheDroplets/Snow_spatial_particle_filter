function[d]=el2dist(el,ro,R)
%EL2DIST Converts beam elevation angle into distance to surface.
%
%   D=EL2DIST(EL,RO) where RO is a satellite elevation above the surface
%   of the earth, and EL is the beam elevation angle in degrees, returns 
%   the distance D along the beam to the surface of the Earth.  
% 
%   The elevation angle is defined as the angle between the beam and the
%   nadir line.  The Earth is approximated as a sphere of radius RADEARTH.
%
%   D=EL2DIST(EL,RO,R) optionally uses a sphere of radius R, in kilometers.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details    

if strcmp(el, '--t')
  el2dist_test,return
end

if nargin==2
   R=radearth;
end

if (~aresame(size(el),size(ro)))&(~isscal(el)&~isscal(ro))
   error('EL and RO must be the same size, or one must be a scalar.')
end
if ~isscal(R)
   error('R must be a scalar.')
end

c=2*pi/360;
el=el*c;

[rp,d]=quadform(1,-2*cos(el).*(ro+R),2*R*ro+ro.^2);
%The larger root is the distance to the far side of the earth
index=find(d<0);
if ~isempty(index)
    d(index)=nan;
end


function[]=el2dist_test

%reporttest('el2dist',bool);

