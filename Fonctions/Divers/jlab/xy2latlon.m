function[lat,lon]=xy2latlon(varargin)
% XY2LATLON  Converts Cartesian coordinates into latitude and longitude.
%
%   [LAT,LON]=XY2LATLON(X,Y,LATC,LONC) converts (X,Y) position
%   with units of kilometers, assuming a Cartesian expansion about 
%   the point (LATC,LONC), into latitude and logitude.  
%
%   [LAT,LON]=LATLON2XY(CX,LATC,LONC) with three input arguments
%   assumes that CX specifies the location as a complex-valued
%   quantity CX=X+SQRT(-1)*Y.
%
%   Longitudes are defined to be within the interval [-180, 180].
%  
%   Usage:  [lat,lon]=xy2latlon(x,y,latc,lonc);
%           [lat,lon]=xy2latlon(cx,latc,lonc);
%
%   'xy2latlon --t' runs a test. 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(varargin{1}, '--t')
  xy2latlon_test,return
end
  
if nargin==3
   x=real(varargin{1});
   y=imag(varargin{1});
   latc=varargin{2};
   lonc=varargin{3};
elseif nargin==4
   x=varargin{1};
   y=varargin{2};
   latc=varargin{3};
   lonc=varargin{4};
end

alon=2*pi/360*radearth*cos(latc*2*pi/360);
alat=2*pi/360*radearth;

lat=y./(alat)+latc;
lon=x./(alon)+lonc;

index=find(lon>180);
vindexinto(lon,lon(index)-360,index,1);
index=find(lon<-180);
vindexinto(lon,lon(index)+360,index,1);


function[]=xy2latlon_test

latc=44;
lonc=0;
N=100;

x=randn(N,1)*5;
y=randn(N,1)*5;
[lat,lon]=xy2latlon(x,y,latc,lonc);
[x2,y2]=latlon2xy(lat,lon,latc,lonc);

tol=1e-12;
bool=aresame(x2,x,tol).*aresame(y2,y,tol);
reporttest('XY2LATLON / LATLON2XY conversion', bool)

latc=-44;
lonc=180;
N=100;

x=randn(N,1)*5;
y=randn(N,1)*5;
[lat,lon]=xy2latlon(x,y,latc,lonc);
[x2,y2]=latlon2xy(lat,lon,latc,lonc);

tol=1e-10;
bool(2)=aresame(x2,x,tol).*aresame(y2,y,tol);
reporttest('XY2LATLON / LATLON2XY conversion at 180', bool)
