function[el,az]=xy2elaz(x,y,ro,R,lato,lono)
%XY2ELAZ  Converts Cartesian coordinates in tangent plane into beam angles.
%
%   [EL,AZ]=XY2ELAZ(X,Y,RO) converts local Cartesian coordinates into 
%   elevation and azimuth angles for a satellite beam.  The satellite is 
%   located RO kilometers above the surface of the Earth.
%
%   The nadir point of the satellite is assumed to be at equator and the 
%   prime meridian.  X and Y are displacements in kilometers from the 
%   nadir point in a plane tangent at the radir point.  The Earth is 
%   approximated as a sphere of radius RADEARTH.
%
%   [EL,AZ]=XY2ELAZ(X,Y,RO,R) optionally uses a sphere of radius R.
%
%   'xy2elaz --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details    


if strcmp(x, '--t')
  xy2elaz_test,return
end

if nargin<=2
   ro=r;
end
if nargin<=3
   R=radearth;
end
if nargin<=4
   lato=0;
   lono=0;
end


%if (~aresame(size(x),size(ro)))&(~isscal(x)&~isscal(ro))|(~aresame(size(y),size(ro)))&(~isscal(y)&~isscal(ro))
%   error('X, Y, and RO must all be the same size, or scalars.')
%end

if ~isscal(R)
   error('R must be a scalar.')
end


if nargin<=4
  [el,az]=xy2elaz_centered(x,y,ro,R);
else
  [el,az]=xy2elaz_offcenter(x,y,ro,R,lato,lono);
end


function[el,az]=xy2elaz_centered(x,y,ro,R)
c=2*pi/360;
r=sqrt(x.^2+y.^2);
gamma=asin(r./R);
%gamma is angular distance spanned to look point from center of earth

r1=sqrt(R^2+(R+ro).^2-2*R*cos(gamma).*(R+ro));
%r1 is distance along the look line to the surface of the earth

el=acos(frac(r1.^2+(R+ro).^2-R^2,2*r1.*(R+ro)));
az=imlog(x+sqrt(-1)*y);  %four-quadrant inverse tangent function

el=el/c;
az=az/c;


function[el,az]=xy2elaz_offcenter(x,y,ro,R,lato,lono);
c=2*pi/360;

lato=lato*c;
lono=lono*c; 

lat=asin(y/R);
lon=asin(x./(R*cos(lat)));

lat=angle(rot(lat+lato));
lon=lon+lono;


x=R*cos(lat).*sin(lon);
y=R*sin(lat);

[el,az]=xy2elaz_centered(x,y,ro,R);

function[]=xy2elaz_test

N=100;
tol=1e-5;
x=rand(N,1)*1000-500;
y=rand(N,1)*1000-500;

ro=657;

[el,az]=xy2elaz(x,y,ro);
[x2,y2]=elaz2xy(el,az,ro);


b=aresame(x,x2,tol)&aresame(y,y2,tol);
reporttest('XY2ELAZ inverts ELAZ2XY for scalar RO',b);

ro=657+rand(N,1)*100-50;

[el,az]=xy2elaz(x,y,ro);
[x2,y2]=elaz2xy(el,az,ro);

b=aresame(x,x2,tol)&aresame(y,y2,tol);
reporttest('XY2ELAZ inverts ELAZ2XY for array RO',b);


[el1,az1]=xy2elaz(x,y,ro);
[el2,az2]=xy2elaz(x,y,ro,radearth,0,0);

b=aresame(el1,el2,tol)&aresame(az1,az2,tol);
reporttest('XY2ELAZ centered algorithm matches non-centered for LATO and LONO both equal zero',b);


