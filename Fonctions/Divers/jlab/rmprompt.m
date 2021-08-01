function[str]=rmprompt(str)
%RMPROMPT  Removes the matlab prompt ">>" from a string matrix
% 
%   RMPROMPT(STR) where STR is string array or matrix removes all
%   instances of ">>" in the string and replaces them with blanks.
%   Leading blanks are then removed using FLUSHLEFT.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        

b1=real(str(1:end-1))==real('>');
b2=real(str(2:end))==real('>');
index=find(b1.*b2);
str(index)=' ';
str=flushleft(str);
