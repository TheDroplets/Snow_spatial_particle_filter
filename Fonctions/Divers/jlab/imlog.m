function[y]=imlog(x);
%IMLOG   IMLOG(X)=IMAG(LOG(X))
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details  
warning('off')
y=imag(log(x));
warning('on')
