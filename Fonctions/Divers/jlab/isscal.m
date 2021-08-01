function[b]=isscal(x);
%ISSCAL   Tests whether the argument is a scalar
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details
b=all(size(x)==1);
