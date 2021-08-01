function[z]=odot(x,y)
%   ODOT  "Outer" dot product of two column vectors.  
%        ODOT(X,Y) <==> CDOT( X*(1+0*Y'), (1+0*X)*Y')
%
%   See also OSUM, OPROD 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2003, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if ~(iscol(x)|isscal(x))|~(iscol(y)|isscal(y))
  error('X and Y must both be column vectors or scalars.')
else
  z=cdot(x*(1+0*y'),(1+0*x)*y');  
end

