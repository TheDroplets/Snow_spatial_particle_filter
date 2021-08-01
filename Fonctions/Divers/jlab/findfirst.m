function[a]=findfirst(bool)
%FINDFIRST  Finds the first incidence of X==1; returns LENGTH(X) if all false.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details  

if isempty(bool)
  error('Argument cannot be empty');
end

temp=find(bool);
if ~isempty(temp)
   a=min(temp);
else 
   a=length(bool);
end   
   
