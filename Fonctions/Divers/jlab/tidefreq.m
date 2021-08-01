function[f,name]=tidefreq(str);
%TIDEFREQ  Frequencies of the eight major tidal compenents.
%
%   [F,NAME]=TIDEFREQ returns the frequencies of the eight major tidal 
%   compenents together with a string matix containing their names.
%   These are   
%        Mf O1 P1 K1 N2 M2 S2 K2
%   In order of increasing frequency.  The units are cycles per hour.
%   See Gill (1982) page 335.
%  
%   F=TIDEFREQ(STR) returns the frequency for the component named STR, 
%   if STR is a string.  F=TIDEFREQ(N) where N is a number also works.
%  
%   Usage:   [f,name]=tidefreq;
%            f=tidefreq(str);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005 J.M. Lilly --- type 'help jlab_license' for details    

name=['MfO1P1K1N2M2S2K2'];
  
p(1)=327.84;
p(2)=25.82;
p(3)=24.07;
p(4)=23.93;
p(5)=12.66;
p(6)=12.42;
p(7)=12.00;
p(8)=11.97;

f=1./p;

if nargin==1
  if ~isstr(str)
    f=f(str);
  else
    ii=findstr(name,str);
    f=f((ii-1)/2+1); 
  end
  clear name
else
  name=reshape(name,2,8)';
end
