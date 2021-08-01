%
% JSTRINGS   Strings and groups of strings
%
% Manipulations of groups of strings
%   flushleft     - Makes a blank-padded string matrix flush on the left.
%   flushright    - Makes a blank-padded string matrix flush on the right.
%   packstrs      - Removes empty entries from a cell array of strings.
%   deblankstrs   - Deblanks all elements in a cell array of strings.
%   mat2table     - Converts a matrix of numbers into a LaTeX-style table.
%   strscat       - Concatenates a cell array of strings into one long string.
%   vint2str      - Integer to string conversion for vectors.
%
% String tests 
%   allblanks     - Equals one if string argument is all blanks or empty, else zero. 
%   isassignment  - Checks if a string is a variable assignment, e.g. 'x=cos(t);'.
%   isboolean     - Checks to see is a string is a boolean expression, e.g. 'x==10'.
%   isblank       - Tests whether elements of a string are blanks.                    
%   ismname       - Tests whether a string ends in the ".m" extension; cells ok.
%   isquoted      - Checks to see if a string is quoted in a longer expression.
%   istab         - Tests whether elements of a string are tab markers.               
%
% Conversions between string representations  
%   strs2mat      - Converts a cell array of strings into a string matrix.
%   strs2list     - Converts a cell array of strings into a comma-delimited list.
%   strs2sray     - Converts a cell array of strings into a string array /w returns.
%   mat2strs      - Converts a string matrix into a cell array of strings.
%   list2strs     - Converts a comma-delimited list into a cell array of strings.
%   sray2strs     - Converts a string array w/ returns into a cell array of strings.
%
% Miscellaneous and low-level string functions
%   rmprompt      - Removes the matlab prompt ">>" from a string matrix
%   alphabetize   - Sorts a string matrix by its first column.
%   digit         - Returns the specified digit(s) of input numbers.
%   findunquoted  - Finds unquoted instances of one string inside another.
%   usefulstrings - Note on numeric representations of useful strings.
%   lengthcells   - Determines the lengths of all elements in a cell array.
%   commentlines  - Returns the comment lines from m-files.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        


