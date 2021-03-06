function[y]=mdj2num(x)
%MDJ2NUM  Converts Modified Julian Dates to DATENUM format.
%  
%   MDJ2NUM(D) converts the Modified Julian Date D to Matlab's DATENUM
%   format.  Modified Julian Dates are used in the Pathfinder satellite
%   datasets.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
%See R. Ray, Pathfinder homepage 
  
if strcmp(x,'--t')
  mdj2num_test;return
end


y=x+datenum('17-Nov-1858');  %On this data, the MJD = 0


function[]=mdj2num_test
% 30 Jan 1980 = MJD 44268; from table by R. Ray
  
n1=mjd2num(44268);
n2=datenum('30-Jan-1980');
reporttest('MDJ2NUM 30-Jan-1980', n1==n2);
