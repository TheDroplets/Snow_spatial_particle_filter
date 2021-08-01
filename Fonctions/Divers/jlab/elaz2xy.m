function[x,y]=elaz2xy(el,az,ro,R,lato,lono)
%ELAZ2XY  Converts beam angles into Cartesian coordinates in tangent plane.
%
%   [X,Y]=ELAZ2XY(EL,AZ,RO) converts the elevation and azimuth angles for 
%   a satellite beam into local Cartesian coordinates.  The satellite is 
%   located RO kilometers above the surface of the Earth.
%
%   The nadir point of the satellite is assumed to be at equator and the 
%   prime meridian.  X and Y are displacements in kilometers from the 
%   nadir point in a plane tangent at the radir point.  The Earth is 
%   approximated as a sphere of radius RADEARTH.
%
%   [X,Y]=ELAZ2XY(EL,AZ,RO,R) optionally uses a sphere of radius R.
%
%   'elaz2xy --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details    


if strcmp(el, '--t')
  elaz2xy_test,return
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

%if (~aresame(size(el),size(ro)))&(~isscal(el)&~isscal(ro))|(~aresame(size(az),size(ro)))&(~isscal(az)&~isscal(ro))
%   error('EL, AZ, and RO must all be the same size, or scalars.')
%end

if ~isscal(R)
   error('R must be a scalar.')
end

if nargin<=4
  [x,y]=elaz2xy_centered(el,az,ro,R);
else
  [x,y]=elaz2xy_offcenter(el,az,ro,R,lato,lono);
end


function[x,y]=elaz2xy_centered(el,az,ro,R)
c=2*pi/360;

r1=el2dist(el,ro,R); 
el=el*c;
az=az*c;

r=sin(el).*r1;
x=r.*cos(az);
y=r.*sin(az);


function[x,y]=elaz2xy_offcenter(el,az,ro,R,lato,lono);
c=2*pi/360;
lato=lato*c;
lono=lono*c;

[x,y]=elaz2xy_centered(el,az,ro,R);

lat=asin(y/R);
lon=asin(x./(R*cos(lat)));

lon=angle(rot(lon-lono));
lat=lat-lato;

x=R*cos(lat).*sin(lon);
y=R*sin(lat);

function[]=elaz2xy_test

N=100;
tol=1e-10;
x=rand(N,1)*1000-500;
y=rand(N,1)*1000-500;

ro=657;

[el,az]=xy2elaz(x,y,ro);

[x1,y1]=elaz2xy(el,az,ro);
[x2,y2]=elaz2xy(el,az,ro,radearth,0,0);

b=aresame(x1,x2,tol)&aresame(y1,y2,tol);
reporttest('ELAZ2XY centered algorithm matches non-centered for LATO and LONO both equal zero',b);


