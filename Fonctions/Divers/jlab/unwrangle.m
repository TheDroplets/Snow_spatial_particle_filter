function[y]=unwrangle(x);
%UNWRANGLE   UNWRANGLE(X)=UNWRAP(ANGLE(EXP(SQRT(-1)*X)))
%
%   UNWRANGLE unwraps the input angle, first setting the angle to be
%   between -pi and pi, leading to better performance than UNWRAP alone.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details  
y=unwrap(angle(rot(x)));