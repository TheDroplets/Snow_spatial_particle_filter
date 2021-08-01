function[inc]=el2inc(el,ro,R)
%EL2INC  Converts beam elevation angle into incidence angle.
%
%   INC=EL2INC(EL,RO) where RO is a satellite elevation above the surface
%   of the earth, and EL is the beam elevation angle in degrees, returns 
%   the beam incidence angle at the point at the surface of the Earth.  
%
%   The elevation angle is defined as the angle between the beam and the
%   nadir line.  The Earth is approximated as a sphere of radius RADEARTH.
%
%   INC=EL2INC(LAT,LON,LATO,LONO,R) optionally uses a sphere of radius R,
%   in kilometers.
%
%   'el2inc --f' generates a sample figure.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details    

if strcmp(el, '--t')
  el2inc_test,return
end

if strcmp(el, '--f')
  el2inc_fig,return
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
r1=el2dist(el,ro,R); 
el=el*c;

gamma=acos(frac(R^2+(ro+R).^2-r1.^2,2*R*(R+ro)));
%gamma is angular distance spanned to look point from center of earth

x=R*tan(gamma);
%x is length of tangent line at look point to nadir line
index=find(x<0);
if ~isempty(index)
    x(index)=nan;
end

[rp,d]=quadform(1,-2*cos(el).*r1,r1.^2-x.^2);
%d is distance from satellite to point where tangent line intersects nadir line
%The larger root is the distance to a point inside the earth
index=find(d<0);
if ~isempty(index)
    d(index)=nan;
end

theta=acos(frac(x.^2+r1.^2-d.^2,2*x.*r1));
%Theta is angle between tangent plane and look line

inc=pi/2-theta;
inc=inc/c;


function[]=el2inc_test
%   'el2inc --t' runs a test.

function[]=el2inc_fig

ro=657;
el=[0:0.5:90];
inc=el2inc(el,ro);
plot(el,inc)
xlabel('Elevation angle')
ylabel('Incidence angle')
title('Elevation and incidence angles for Aquarius satellite (ro=657 km)')
