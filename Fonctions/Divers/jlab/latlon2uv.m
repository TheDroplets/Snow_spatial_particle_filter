function[u,v]=latlon2uv(num,lat,lon)
%LATLON2UV  Converts latitude and logitude to velocity.
%
%   [U,V]=LATLON2UV(NUM,LAT,LON) where NUM is the data in DAYNUM format and
%   LAT and LON are the latitude and longitude in degrees, outputs the
%   eastward and northward velocity components U and V in cm/s, computed
%   using the first central difference.
%
%   CV=LATLON2UV(...) with one output argument returns the complex- valued
%   velocity CV=U+SQRT(-1)*V. NANs in LAT or LON become NAN+SQRT(-1)*NAN.
%
%   It is assumed that successive (LAT,LON) coordinates are sufficiently
%   close together such that the distance between the two is given by a
%   local cartesian approximation, i.e. the influence of the curvature of
%   the earth may be neglected.
%  
%   NUM is a column vector or a matrix of the same size as LAT and LON.  LAT
%   and LON are matices having SIZE(NUM,1) rows.  U and V are the same size
%   as LAT and LON.  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
a=6371*1000*100;  %Mean radius of the earth in cm
c=frac(2*pi,360);

lat=lat.*c;
lon=lon.*c;

%lato=lato.*c;
%lono=lono.*c;

%y=(lat-lato).*a;
%x=(lon-lono).*cos(lat).*a;
y=lat.*a;
x=lon.*cos(lat).*a;

%u=vdiff(x,num*24*3600)+sqrt(-1)*vdiff(y,num*24*3600);
if size(num,2)==1
  num=osum(num,zeros(size(x,2),1));
end
  
u=vdiff(x+sqrt(-1)*y)./vdiff(num*24*3600);
index=find(isnan(real(u))|isnan(imag(u)));
if ~isempty(u)
   u(index)=nan+sqrt(-1)*nan;
end
u(end,:)=nan+sqrt(-1)*nan;

if nargout==2
  v=imag(u);
  u=real(u);
end

