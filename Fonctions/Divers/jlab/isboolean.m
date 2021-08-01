function[bool]=isboolean(str)
%ISBOOLEAN Checks to see is a string is a boolean expression, e.g. 'x==10'
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details  


%isboolean(['x==10'])
%isboolean(['title([''Tests whether x==10''])'])
%isboolean(['x==10;                       ';'title(''Tests whether x==10''])'])

for i=1:size(str,1)
  index1=findunquoted('==',str(i,:));
  index2=findunquoted('>=',str(i,:));
  index3=findunquoted('<=',str(i,:));
  index4=findunquoted('~=',str(i,:));
  index=indexor(index1,index2,index3,index4);


  bool(i,1)=length(index);
end


