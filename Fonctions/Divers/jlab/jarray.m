%
% JARRAY   Basic array and mathematical functions 
%
% Array tools
%   oprod         - Outer product of two column vectors. 
%   odot          - "Outer" dot product of two column vectors.  
%   osum          - "Outer" sum of two column vectors.
%   offset        - Offsets matrix rows or columns.
%   row2col       - Given any vector, returns it as a column vector.
%   col2row       - Given any vector, returns it as a row vector.
%   nonnan        - Return all non-NAN elements of an array.
%   vectmult      - Matrix multiplication for arrays of two-vectors. 
%   matmult       - Matrix multiplication for arrays of 2 x 2 matrices. 
%
% Multidimensional (N-D) array tools
%   nd            - Number of the last nonsingleton dimension.
%   nnsd          - Number of nonsingleton dimensions.
%   ndtrans       - Generalized transpose of a potentially multidimensional vector.
%   ndrep         - Replicates an array along a specified dimension.
%   ndindex       - Indexes a multidimensional array along a specified dimension
%
% Array tests
%   aresame       - Tests whether two N-D arrays are the same.
%   iscol         - Tests whether the argument is a column vector.
%   isrow         - Tests whether the argument is a row vector.
%   iseven        - Tests whether the elements of an array are even.
%   isodd         - Tests whether the elements of an array are odd.
%   ismat         - Tests whether the argument is a 2-D matrix; false for scalars.
%   isscal        - Tests whether the argument is a scalar.
%   issing        - Tests whether the argument is a singleton array.
%   issquare      - Tests whether the argument is a square matrix.
%   islargest     - True for the largest-magnitude element at each index location.
%
% Indexing (subscripting), interpolation, and smoothing
%   indexor       - Finds the union of multiple indices.
%   indexand      - Finds the intersection of multiple indices.
%   vinterp       - Matrix-matrix 1-D interpolation.
%   fillbad       - Linearly interpolate over bad data points. 
%   smartsmooth   - Fast light smoothing for large matrices.
%   twodhist      - Two-dimensional histgram.
%
% Boolean expressions, sets, and slabs
%   findlast      - Finds the last incidence of X==1; returns 0 if all false.
%   findfirst     - Finds the first incidence of X==1; returns LENGTH(X) if all false.
%   subset        - Extract subset of A given B.  
%   lookup        - Locate elements of one array within another.
%   ismemb        - Tests whether the elements of an array are members of a set.
%   iscompat      - Tests whether an array's size is "compatible" with another's.
%   numslabs      - Counts the number of 'slabs' of one array relative to another.
%
% Wavenumber gridding tools
%   wavegrid      - Makes a complex-valued valued (x+iy) grid.
%   iswavegrid    - Tests whether a matrix is in WAVEGRID format. 
%   k2sub         - Convert a complex-valued wavenumber into an I,J subscript pair.
%   sub2k         - Convert an I,J subscript pair into a wavenumber.
%
% Mathematical aliases
%   oneover       - Returns reciprocal of argument.
%   frac          - Make fraction: FRAC(A,B)=A./B
%   twopi         - Raise (2 pi) to the specified power.
%   res           - Residual after flooring:  RES(X)=X-FLOOR(X)
%   squared       - Squares its argument:  SQUARED(X)=X.^2
%   cdot          - Dot product:  CDOT(A,B)=REAL(A.*CONJ(B))
%   rot           - Complex-valued rotation:  ROT(X)=EXP(SQRT(-1)*X)
%   quadform      - Implements the quadratic formula.
%   allall        - ALLALL(X)=ALL(X(:))
%   maxmax        - MAXMAX(X)=MAX(X(:))
%   minmin        - MINMIN(X)=MIN(X(:))
%   anyany        - ANYANY(X)=ALL(X(:))
%   sumsum        - SUMSUM(X)=SUM(X(:))
%   relog         - RELOG(X)=REAL(LOG(X))
%   imlog         - IMLOG(X)=IMAG(LOG(X))
%   unwrangle     - UNWRANGLE(X)=UNWRAP(ANGLE(EXP(SQRT(-1)*X)))
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        
