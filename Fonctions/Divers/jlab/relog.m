function[y]=relog(x);
%RELOG   RELOG(X)=REAL(LOG(X))
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details  
warning('off')
y=real(log(x));
warning('on')
