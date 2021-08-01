%
% JOCEANS   Oceanography-specific functions
%
% Date conversion 
%   yf2num     - Converts date in 'year.fraction' format to 'datenum' format.
%   num2yf     - Converts date in 'datenum' format to 'year.fraction' format.
%   mdj2num    - Converts Modified Julian Dates to 'datenum' format.
%
% Latitude and longitude conversion
%   latlon2xy  - Converts latitude and longitude into Cartesian coordinates.
%   xy2latlon  - Converts Cartesian coordinates into latitude and longitude.
%   latlon2uv  - Converts latitude and logitude to velocity.
%   spheredist - Computes great circle distances on a sphere.                     
%   sphereproj - Projects latitude and longitude onto a Cartesian tangent plane.  
%
% Plotting functions
%   stickvect  - Plots "stick vectors" for multicomponent velocity time series.
%   denscont   - Density contour overlay for oceanographic T/S plots.
%   uvplot     - Plot u and v components of velocity on the same axis.
%   provec     - Generate progressive vector diagrams (simple and fancy).
%   hodograph  - Generate hodograph plots (simple and fancy).
%   timelabel  - Put month, day, or hour labels on a time axes.
%
% Eddy modelling
%   rankineeddy  - Velocity and streamfunction for a Rankine vortex.
%   gaussianeddy - Velocity and streamfunction for a Gaussian vortex.
%   twolayereddy - Velocity and streamfunction for a 2-layer Rankine vortex.
%
% Specialized functions
%   heatstorage  - Water column heat storage from 1-D mixing.
%   tidefreq     - Frequencies of the eight major tidal compenents.
%
% Satellite altimetry
%   pf_extract - Extract alongtrack Pathfinder data from specified region.   
%   pf_params  - Load satellite parameters from Pathfinder format file.   
%   trackfill  - Despiking and filling for alongtrack satellite data.   
%   track2grid - Interpolate alongtrack satellite data onto a grid.            
%
% Basic satellite geometry                        
%   el2dist    - Converts beam elevation angle into distance to surface.          
%   el2inc     - Converts beam elevation angle into incidence angle.              
%   elaz2xy    - Converts beam angles into Cartesian coordinates in tangent plane.
%   xy2elaz    - Converts Cartesian coordinates in tangent plane into beam angles.
%
% Other
%   radearth   - The radius of the earth in kilometers.   
%   ________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        
 
 

