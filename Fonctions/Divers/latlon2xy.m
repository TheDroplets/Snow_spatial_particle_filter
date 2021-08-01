function[varargout]=latlon2xy(lat,lon,latc,lonc)
% LATLON2XY  Converts latitude and longitude into Cartesian coordinates.
%
%   [X,Y]=LATLON2XY(LAT,LON,LATC,LONC) converts (LAT,LON) with units
%   of degrees into (X,Y) with units of kilometers using a Cartesian
%   expansion about the point (LATC,LONC).
%
%   CX=LATLON2XY(LAT,LON,LATC,LONC) with one output argument returns 
%   the location as a complex-valued quantity X+SQRT(-1)*Y. NANs in
%   LAT or LON become NAN+SQRT(-1)*NAN.
%
%   LATC and LONC are optional and default to the mean values of LAT 
%   and LON respectively.  [..., LATC,LONC]=LATLON2XY(LAT,LON) then 
%   returns the computed values.  
%
%   LON and LONC may each either be specified on the interval
%   [-180, 180] or on the interval [0, 360].
%
%   Usage:  [x,y]=latlon2xy(lat,lon,latc,lonc);
%           cx=latlon2xy(lat,lon,latc,lonc);
%
%   'latlon2xy --t' runs a test 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2005 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(lat, '--t')
  xy2latlon('--t'),return
end
  
if nargin<3
   lonc=vmean(lon(:),1);
   latc=vmean(lat(:),1);
end
alon=2*pi/360*radearth*cos(latc*2*pi/360);
alat=2*pi/360*radearth;

%Account for possibliliity of  greater than 180 degree
%difference between LON and LONC

dlon=angle(rot(2*pi/360*(lon-lonc)))*360/2/pi;
xlon=dlon.*alon;

xlat=(lat-latc)*alat;

if nargout==1|nargout==3
  xlat=xlon+sqrt(-1)*xlat;
  index=find(isnan(real(xlat))|isnan(imag(xlat)));
  if ~isempty(index)
     xlat(index)=nan+sqrt(-1)*nan;
  end
  varargout{1}=xlat;
  varargout{2}=latc;
  varargout{3}=lonc;
else
  varargout{1}=xlon;
  varargout{2}=xlat;  
  varargout{3}=latc;
  varargout{4}=lonc;
end

