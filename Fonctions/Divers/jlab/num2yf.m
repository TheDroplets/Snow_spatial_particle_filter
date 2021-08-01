function[yf]=num2yf(num)
%NUM2YF  Convert date in 'datenum' format to 'year.fraction' format.
%  
%  NUM2YF(NUM) where NUM is an array of dates in Matlab's 'datenum'
%  format returns the array in 'year.fraction' format.
%  
%  See also YF2NUM, DATENUM, DATEVEC
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1998, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(num, '--t')
  yf2num('--t'),return
end  

index=find(isnan(num));
if ~isempty(index)
  num(index)=0;
end
 
[y,mo,d,h,mi,s] = datevec(num);

%Number of days in this year?
nd=datenum(y,12,31)-datenum(y-1,12,31);


na=datenum(y,mo,d,h,mi,s)-datenum(y-1,12,31)-1;
%The minus one is because for Jan 1, I add nothing to year.fraction

yf=y+na./nd;

if ~isempty(index)
  yf(index)=nan;
end

  
  
