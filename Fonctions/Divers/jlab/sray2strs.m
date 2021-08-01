function[y]=sray2strs(x)
%SRAY2STRS  Converts a string array w/ returns into a cell array of strings.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details      

y=[];

index=find(real(x)==10);
  
if ~isempty(index)
  x(index)=',';
  y=list2strs(deblank(x));
end

y=packstrs(y);





%Make sure I don't have a comma followed by nothing at the end
if 0
  if ~isempty(index)
  if index(end)==length(x)
    index=index(1:end-1);
    x=x(1:end-1);
  end
end

if ~isempty(index)
  if length(deblank(x(index(end)+1:end)))==0
    index=index(1:end-1);
    x=x(1:end-1);
  end
end
end
