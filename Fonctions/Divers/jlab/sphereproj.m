function[x,y]=sphereproj(lat,lon,lato,lono,R)
%SPHEREPROJ  Projects latitude and longitude onto a Cartesian tangent plane.
%
%   [X,Y]=SPHEREPROJ(LAT,LON,LATO,LONO) projects latitude and longitude
%   coordinates LAT and LON onto a Cartesian plane tangent at the point
%   LATO and LONO.  
%
%   X and Y are the Cartesian coordinates in kilometers from the tangent 
%   point.  The Earth is approximated as a sphere of radius RADEARTH.
%
%   [X,Y]=SPHEREPROJ(LAT,LON,LATO,LONO,R) optionally uses a sphere of 
%   radius R, in kilometers.
%
%   'sphereproj --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details    


if strcmp(lat, '--t')
  sphereproj_test,return
end

if strcmp(lat, '--f')
  sphereproj_fig,return
end

if nargin<=3
   lato=0;
   lono=0;
end
  
if nargin<=5
   R=radearth;
end


c=2*pi/360;

lat=c*lat;
lon=c*lon;
lato=c*lato;
lono=c*lono;

if isscal(lato)&~isscalar(lono)
    lato=lato+0*lono;
end
if isscal(lono)&~isscalar(lato)
    lono=lono+0*lato;
end

x=zeros(size(lat,1),size(lat,2),length(lato));
y=zeros(size(lat,1),size(lat,2),length(lato));


for kk=1:length(lato)
  x(:,:,kk)=R*cos(lat).*sin(lon-lono(kk));
  y(:,:,kk)=-R*cos(lat).*sin(lato(kk)).*cos(lon-lono(kk))+R.*cos(lato(kk)).*sin(lat);
end

function[]=sphereproj_test

N=100;
tol=1e-4;
c=2*pi/360;

lat=2*pi*rand(N,1)-pi;
lon=pi*rand(N,1)-pi/2;

lat=(1/c)*lat/1000;
lon=(1/c)*lon/1000;

[x,y]=sphereproj(lat,lon,0,0);
[x2,y2]=latlon2xy(lat,lon,0,0);

b=aresame(x,x2,tol)&aresame(y,y2,tol);
reporttest('SPHEREPROJ matches LATLON2XY for small LAT and LON about zero',b);


tol=0.05;
lato=2*pi*rand(N,1)-pi;
lono=pi*rand(N,1)-pi/2;

lato=(1/c)*lato;
lono=(1/c)*lono;

clear x y

for i=1:length(lato)
    [x(i,1),y(i,1)]=sphereproj(lat(i)+lato(i),lon(i)+lono(i),lato(i),lono(i));
end

[x2,y2]=latlon2xy(lat+lato,lon+lono,lato,lono);

b=aresame(x,x2,tol)&aresame(y,y2,tol);
reporttest('SPHEREPROJ matches LATLON2XY for small LAT and LON perturbations',b);


function[]=sphereproj_fig
%   'sphereproj --f' generates a sample figure.



