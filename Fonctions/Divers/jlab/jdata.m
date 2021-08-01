%
% JDATA   Data management and manipulation
%
% Naming and renaming variables. 
%   use           - Copies structure fields into named variables in workspace.
%   make          - Create a structure containing named variables as fields.
%   catstruct     - Concatenates the (matrix) elements of two structures.
%   dat2vars      - Put the columns of a matrix into named vectors.
%
% Datasets of non-uniform length: column / matrix conversions. 
%   blocknum      - Numbers the contiguous blocks of an array.
%   blocklen      - Counts the lengths of 'blocks' in an array.
%   colbreaks     - Insert NANs into discontinuties in a vector.
%   mat2col       - Compress NAN-padded matrix data into long columns.
%   col2mat       - Expands 'column-appended' data into a matrix.
%   vcellcat      - Concatenates cell arrays of column vectors.
%
% VTOOLS: Tools for operating on multiple arrays simultaneously.
%   vadd       - Vector-matrix addition without "dimensional" hassle. 
%   vmult      - Vector-matrix multiplication without "dimensional" hassle.
%   vindex     - Indexes an N-D array along a specified dimension. 
%   vfilt      - Filtering along rows without change in length.
%   vdiff      - Length-preserving first central difference.               
%   vmoment    - Central moment over finite elements along a specfied dimension.    
%   vnd        - Number of dimensions.                                               
%   vpower     - Raises array to the specified power.                               
%   vrep       - Replicates an array along a specified dimension.                   
%   vshift     - Cycles the elements of an array along a specified dimension.       
%   vstd       - Standard deviation over finite elements along a specfied dimension.
%   vsum       - Sum over finite elements along a specified dimension.              
%   vsize      - Returns the sizes of multiple arguments.
%   vsqueeze   - Squeezes multiple input arguments simultaneously. 
%   vswap      - Swap one value for another in input arrays.
%   vcolon     - Condenses its arguments, like X(:).                           
%   vcellcat   - Concatenates cell arrays of column vectors.
%   vempty     - Initializes multiple variables to empty sets.
%   vzeros     - Initializes multiple variables to arrays of zeros.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        
