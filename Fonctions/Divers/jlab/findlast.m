function[a]=findlast(bool)
%FINDLAST  Finds the last incidence of X==1; returns 0 if all false.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details  

if isempty(bool)
  error('Argument cannot be empty');
end

temp=find(bool);
if ~isempty(temp)
   a=max(temp);
else 
   a=0;
end   
   
