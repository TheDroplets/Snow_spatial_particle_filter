function[str]=to_overwrite(N)
%TO_OVERWRITE Returns a string to overwrite original arguments
%
%   STR=TO_OVERWRITE(N), when called from within an m-file which has
%   VARARGIN for the input variable, returns string which upon
%   EVAL(STR) will cause the first N input variables in the caller
%   workspace with the values contained in the first N elements of
%   VARARGOUT.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details      

str{1}=['if nargout==0'];
str{2}= '   global ZZoutput';
str{3}= '   evalin(''caller'',[''global ZZoutput''])';
str{4}=['   for i=1:' int2str(N)];
str{5}= '     if ~isempty(inputname(i))';
str{6}= '       ZZoutput=varargout{i};';
str{7}= '       assignin(''caller'',inputname(i), ZZoutput)';
str{8}= '     end';
str{9}= '   end';
str{10}='   evalin(''caller'',[''clear ZZoutput''])';
str{11}='end';

str=strs2row(str);


function[row]=strs2row(x)
%STRS2ROW  Converts a cell array of strings into a row array

M=length(x);
for i=1:M
    n(i)=length(x{i});
end
N=max(n);

row=[];

for i=1:M
    row=[row,setstr(10),x{i}]; 
end
