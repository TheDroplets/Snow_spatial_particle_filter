function[]=reporttest(str,bool)
%REPORTTEST  Reports the result of an m-file function auto-test
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2003, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if bool
    disp([str ' test: passed'])
else  
    disp([str ' test: FAILED'])
end
