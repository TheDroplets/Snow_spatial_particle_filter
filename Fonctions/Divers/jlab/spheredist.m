function[d]=spheredist(lat1,lon1,lat2,lon2,R)
%SPHEREDIST  Computes great circle distances on a sphere.
%
%   D=SPHEREDIST(LAT1,LON1,LAT2,LON2) computes arc length along a great
%   circle from the point with latitude and longitude coordinates LAT1 
%   and LON1 to the point LAT2 and LON2. 
%
%   The Earth is approximated as a sphere of radius RADEARTH.
%
%   D=SPHEREDIST(LAT,LON,LATO,LONO,R) optionally uses a sphere of 
%   radius R, in kilometers.
%
%   'spheredist --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details    

if strcmp(lat1, '--t')
  spheredist_test,return
end

if nargin==4
   R=radearth;
end

%  From http://mathworld.wolfram.com/GreatCircle.html

if ~aresame(size(lat1),size(lon1))
   error('LAT1 and LON1 must be the same size.')
end
if ~aresame(size(lat2),size(lon2))
   error('LAT2 and LON2 must be the same size.')
end
if (~aresame(size(lat1),size(lat2))&(~isscal(lat1)&~isscal(lat2)))
   error('LAT1 and LON1 must be the same size as LAT1 and LON1, or one pair must be scalars.')
end

c=2*pi/360;
lat1=lat1*c;
lat2=lat2*c;
lon1=lon1*c;
lon2=lon2*c;

d=R.*acos(cos(lat1).*cos(lat2).*cos(lon1-lon2)+sin(lat1).*sin(lat2));


function[]=spheredist_test

try
    s=which('sw_dist');
    
    N=1000;
    tol=1;  %1 km
    
    
    lat1=180*rand(N,1)-90;    
    lon1=360*rand(N,1);   
    lat2=lat1+randn(N,1)-.5;       
    lon2=lon1+randn(N,1)-.5;
        
    %Note that SW_DIST compares badly for large displacements 
    %lat2=180*rand(N,1)-90;    
    %lon2=360*rand(N,1);
 
    
    d1=spheredist(lat1,lon1,lat2,lon2);
    d2=0*lat1;
    for i=1:length(lat1)
        d2(i)=sw_dist([lat1(i) lat2(i)],[lon1(i) lon2(i)],'km');
    end
    b=aresame(d1,d2,tol);
    reporttest('SPHEREDIST versus SW_DIST for small displacements',b)
    
catch
    disp('SPHEREDIST test not run because SW_DIST not found.')
end


