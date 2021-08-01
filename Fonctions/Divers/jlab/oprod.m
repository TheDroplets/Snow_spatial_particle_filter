function[z]=oprod(x,y)
%   OPROD  Outer product of two column vectors. 
%        OPROD(X,Y) <==> X*CONJ(Y')  (Recall ' = conjugate transpose)
%
%   See also OSUM, ODOT
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2003,2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if ~(iscol(x)|isscal(x))|~(iscol(y)|isscal(y))
  error('X and Y must both be column vectors or scalars.')
else
  z=x*conj(y');  
end

