function[s]=lengthcells(x,n)
%LENGTHCELLS Determines the lengths of all elements in a cell array
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
for i=1:length(x)
  s(i,1)=length(x{i});
end

%  if ~isempty(n)
%    s(i,1)=size(x{i},n);
%  else
%    s(i,:)=size(x{i});
%  end
