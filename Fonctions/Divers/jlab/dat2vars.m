function[o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19]=dat2vars(data)
%DAT2VARS  Put the columns of a matrix into named vectors.
%
%   [O1,O2,O3,...]=DAT2VARS(DATA) puts the nth column of DATA into the
%   Nth output argument.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details
  

for i=1:size(data,2) 
       eval(['o',num2str(i),'=data(:,i);'])
end




