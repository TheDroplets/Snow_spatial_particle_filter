function[row]=strs2sray(x)
%STRS2SRAY  Converts a cell array of strings into a string array /w returns
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details      
  
  
if ~iscell(x)
  xtemp=x;
  clear x
  x{1}=xtemp;
end

x=packstrs(x);

row=strs2list(x);
index=find(real(row)==real(','));
if ~isempty(index)
  row(index)=setstr(10);
end
