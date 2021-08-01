function[wa,wb]=transconv(wx,wy,str)
% TRANSCONV  Convert between widely linear transform pairs.
%  
%   [C,D]=TRANSCONV(A,B,STR) converts from one widely linear 
%   transform pair into another, as specified by the string STR. 
%  
%   STR is of the form 'in2out' where the names 'in' and 'out' may be 
%   any of the following
%  
%       'uv'    The Cartesion component transform pair 
%       'eo'    The even/odd transform pair  
%       'pn'    The positive and negatively rotating transform pair 
%       'x*'    The transform of a time series and of its conjugate 
%       'dc'    The downstream/crosstream transform pair 
%  
%   For example, [P,N]=TRANSCONV(U,V,'uv2pn') converts from the 
%   Cartesian transform pair to the rotary transform pair.  
%    
%   See Lilly (2005) for  details.
%
%   See also MANDN, WALPHA
%
%   Usage: [ta,tb]=transconv(tu,tv,str);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
  
str1=str(1:2);
str2=str(4:5);

sizewx=size(wx);
wx=wx(:);
wy=wy(:);

[M1,N1]=mandn([str1 '-']);
[M2,N2]=mandn(str2);

[wu,wv]=vectmult(M1,N1,wx,wy);%Convert to UV
[wa,wb]=vectmult(M2,N2,wu,wv);%Convert to output

wa=reshape(wa,sizewx);
wb=reshape(wb,sizewx);

