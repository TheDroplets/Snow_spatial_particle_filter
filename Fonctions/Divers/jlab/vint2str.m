function[stro]=vint2str(x,arg2,arg3)
%VINT2STR Integer to string conversion for vectors.
%
%   S = VINT2STR(X) converts the X, a vector of integers, into a string   
%   representation.                                                       
%                                                                         
%   S = VINT2STR(X,PREC) specifies the precision of the output. PREC      
%   denotes the tenths place of the highest-precision digit, so PREC=-2   
%   includes the hundredth place. Training digits are rounded off.        
%
%   VINT2STR by default will fill in empty values with zeros, e.g. 
%	VINT2STR([1;100])=['001';'100'].
%   VINT2STR(X,'spaces') fills in empty values with spaces instead:
%	VINT2STR([1;100])=['  1';'100']
%
%   See also DIGIT.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details    
  

iminus=find(x<0);
x=abs(x);

%add a small number to prevent roundoff error
x=x+1e-10;

n=floor(log10(max(x)));
if n>0
	prec=0;
else
	n=0;
	prec=n-3;
end
str=[];

if nargin>1
	if isstr(arg2)
		str=arg2;
	else
	   	prec=arg2;
	end
end
if nargin>2
	if isstr(arg2)
		str=arg2;
		prec=arg3;
	else
		str=arg3;
	   	prec=arg2;
	end
end


n=n:-1:prec;

x=round(x./10^prec)*10^prec;
if isempty(str)
	stro=digit(x,n,'str');
else
	stro=digit(x,n,'str',str);
end

if any(n(1:end-1)==0)
	i=find(n==0);
	stro(:,[1:i,i+2:end+1])=stro;
	stro(:,i+1)=setstr(46)*[1+0*stro(:,1)];
end

%account for minus signs
if ~isempty(iminus)
     newcol=32+0*stro(:,1);
     newcol=setstr(newcol);
     stro=[newcol stro];
     for i=1:length(iminus)
   	   maxb=max(findstr(stro(iminus(i),:),' '));
	   stro(iminus(i),maxb)='-';
     end
end 	
     	
