function[]= fixlabels(arg1,arg2)
%FIXLABELS  Specify precision of axes labels.
%
%   FIXLABELS(PREC) rewrites the X and Y axis labels of the current
%   axes to precision PREC.  PREC denotes the tenths place of the
%   highest-precision digit, so PREC=-2 includes the hundredths place.
%
%   Unlike standard matlab labelling, FIXLABELS uses zeros instead of
%   blank spaces to the right of the decimal point.
%
%   FIXLABELS([XPREC,YPREC]) uses different precision for the X and Y
%   axes (note brackets in the function call).
%
%   FIXLABELS(H,PREC) rewrites the labels of axes H.  H may also be a
%   vector of axes handles, in which case PREC may either be a scalar
%   or a vector PREC=[X1PREC Y1PREC X2PREC ...] .
%
%   FIXLABELS with no arguments rewrites all X and Y axis labels of
%   the current figure to the default (current) precision for that
%   axis, but using zeros instead of blank spaces to the right of the
%   decimal point.
%
%   Note: make sure the tickmarks are where you want them in the
%   hardcopy before calling FIXLABELS (since it sets the 'TICKMODE'
%   and 'TICKLABELMODE' properties to 'MANUAL').
%
%   See also: VINT2STR, DIGIT
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 1999, 2004 J.M. Lilly --- type 'help jlab_license' for details  

%	Note unexplained Matlab quirk-- setting YTICKLABELMODE
%	to MANUAL sometimes causes uppermost label to be invisible.

h1=gca;
bprec=0;
if nargin==0
	h=findallaxes(gcf);
elseif nargin==1
	if ishandle(arg1)
		h=arg1;
	else
		h=gca;
		prec=arg1;
		bprec=1;
	end
elseif nargin==2
	h=arg1;
	prec=arg2;
	bprec=1;
	if all(size(prec)>1)
		prec=prec';
		prec=prec(:);
	end
end

if bprec
	if length(prec)==1
		prec=prec*ones(length(h)*2,1);
	end
end

for i=1:length(h)
	axes(h(i));
	xtick=[get(gca,'xtick')]';
	ytick=[get(gca,'ytick')]';

	%find precision used by current labels assuming a decimal point
	nx=size(get(gca,'xticklabel'),2);
	ny=size(get(gca,'yticklabel'),2);
	
	if ~isempty(xtick)
		if ~bprec
			if all(xtick==floor(xtick))
				%no decimal point
				xlab=vint2str(xtick,'spaces');
			else	
				%minus signs are difficult
				if any(xtick<0)
					nd=floor(log10(max(abs(xtick))))+1;
					if nd<1, nd=1;end
					nx1=nd+2-nx;	
				else
					nd=floor(log10(max(xtick)))+1;
					if nd<1, nd=1;end
					nx1=nd+1-nx;	
				end
				xlab=vint2str(xtick,nx1,'spaces');
			end
		else
			xlab=vint2str(xtick,prec(2*i-1),'spaces');
		end
		xlab=flushleft(xlab);
		set(gca,'xtickmode','manual')
		set(gca,'xticklabelmode','manual')
		set(gca,'xticklabel',xlab)
end
	if ~isempty(ytick)
		if ~bprec
			if all(ytick==floor(ytick))
				%no decimal point
				ylab=vint2str(ytick,'spaces');
			else
				%minus signs are difficult
				if any(ytick<0)
					nd=floor(log10(max(abs(ytick))))+1;
					if nd<1, nd=1;end
					ny1=nd+2-ny;	
				else
					nd=floor(log10(max(ytick)))+1;
					if nd<1, nd=1;end
					ny1=nd+1-ny;	
				end
				ylab=vint2str(ytick,ny1,'spaces');
			end
		else
			ylab=vint2str(ytick,prec(2*i),'spaces');
		end
       		ylab=flushleft(ylab);
		set(gca,'ytickmode','manual')
		set(gca,'yticklabelmode','manual')
		set(gca,'yticklabel',ylab)
	end
end

axes(h1)


function[h]=findallaxes(fignum)
%FINDALLAXES    Returns handles to all axes children.
%       FINDALLAXES returns a vector of handles to all axes childen
%       regardless of which figure is their parent.
%
%       FINDALLAXES(FIGNUM) returns a vector of handles to axes
%       children of Figure FIGNUM. 
%
%       See also ALLCHILD, FINDALL

%       Author: J.M. Lilly, 1/15/98


if nargin==1
        h=get(fignum,'children');
else
        h=[];
        for i=1:length(get(0,'children'))
                h=[h;get(i,'children')];
        end
end
bool=zeros(size(h));
for i=1:length(h)
        if strcmp(get(h(i),'type'),'axes')
                bool(i)=1;
        end
end
h=h(find(bool)); 
function[stro]=vint2str(x,arg2,arg3)
%VINT2STR Integer to string conversion for vectors.
%       S = INT2STR(X)  converts the X, a vector of integers, into 
%	a string representation.  
%
%	S = INT2STR(X,PREC) specifies the precision of the output.
%	PREC denotes the tenths place of the highest-precision digit,
%	so PREC=-2 includes the hundredth place.  Training digits
%	are rounded off.
%
%	VINT2STR by default will fill in empty values with zeros, e.g. 
%		VINT2STR([1;100])=['001';'100'].
%	VINT2STR(X,'spaces') fills in empty values with spaces instead:
%		VINT2STR([1;100])=['  1';'100']
%
%	See also DIGIT.

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
     	

function[xdigit]=digit(x,n,flag,flag2)
%DIGIT  Returns the specified digit(s) of input numbers.
%	DIGIT(X,N) returns the Nth digit(s) of X.  N=0 returns the
%	ones digit, N=1 the tens digit, N=-1 the tenths digit, etc.  
%	X may be either a number or a vector, as may N.  If X is a 
%	column (row) vector and length(N)>1, the N(1)th, N(2)th, ...  
%	digits are put in the 1st, 2nd, ... columns (rows) of the 
%	output, e.g. DIGIT([123;456],[2 1])=[12;45];
%	
%	DIGIT(X,N,FLAG) determines whether the output are strings
%	(FLAG='str', the default) or numbers (FLAG='num').  
%
%	For string output, DIGIT(..., FLAG2) where FLAG2='spaces' 
%	gives empty digits filled with spaces ('  1'), while 
%	FLAG2='zeros' (the default) gives empty digits filled with
%	zeros ('001').
%
%	See also VINT2STR.
nin=n;
xin=x;

btrans=0;
if size(x,1)==1&size(x,2)>1
	x=x';
	btrans=1;
end

bstring=1;
bspace=0;
if nargin==3
	if flag(1:3)=='str'
		bstring=1;
	elseif flag(1:3)=='num'
		bstring=0;
	elseif flag(1:3)=='spa'
		bspace=1;
	elseif flag(1:3)=='zer'
		bspace=0;
	end
end

if nargin==4
	if flag2(1:3)=='str'
		bstring=1;
	elseif flag2(1:3)=='num'
		bstring=0;
	elseif flag2(1:3)=='spa'
		bspace=1;
	elseif flag2(1:3)=='zer'
		bspace=0;
	end
end

for i=1:length(nin)
	n=nin(i);
	x=row2col(xin);

	if n<1
		a=-n;
		x=x*10^a;
		n=0;
	end

	x=floor(x./(10^(n)));
	if bstring
		xdigit(:,i)=[int2str(x-floor(x./(10))*10)]';
		if bspace&n~=0
			iii=[find(xin<10^n)]';
			if ~isempty(iii)
				xdigit(iii,i)=setstr(32+0*iii);
			end
		end
	else
		xdigit(:,i)=(x-floor(x./(10))*10);
	end
end

if btrans
	xdigit=xdigit';
end

function[col]=row2col(row)
%ROW2COL  Given any vector, returns it as a column vector.
 
if size(row,2)>size(row,1)
        if ~isstr(row)
                col=conj(row');
        else 
                col=row';
        end
else
        col=row;
end
