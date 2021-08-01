function[y]=anatrans(x);
%ANATRANS  Analytic part of signal.
%
%   Y=ANATRANS(X) returns the analytic part of the column vector X.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
     
y=frac(1,2)*(x+sqrt(-1)*hiltrans(x));
