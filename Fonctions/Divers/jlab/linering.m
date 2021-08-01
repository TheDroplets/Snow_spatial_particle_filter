function[]=linering(i1)
%LINERING  Moves lines through the current line style order.  
%
%   LINERING works like a moveable highlighter, picking out a group of
%   lines from the current plot.  This is accomplished by moving the
%   line handles by a specified amount with respect to the current
%   line style, color, and width order.
%
%   Different subplots in the current figure may be locked together,
%   highlighting comparable groups of lines.
%	
%   LINERING(N), where N is a *real* integer, moves all line handles
%   in the current axes N steps forward (or backward for N<0) with
%   respect to the current style order.  When N is an *imaginary*
%   integer, LINERING moves the imag(N)th line to the first position
%   with respect to the current style order.
%
%   LINERING N also works, where N is an number (not a variable whose
%   value is a number).
%
%   LINERING with no arguments is the same as LINERING(1), and returns
%   the lines to their original styles.
%   
%   LINERING LOCK and LINERING UNLOCK lock and unlock all axes in the
%   current figure.  When LOCK is on, calls to LINERING or LINESTYLE
%   are applied to all lines in the current figure.
%
%   See also LINESTYLE
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  



%if no arguments, assume we want to return to the original configureation
if nargin==0
   i1=sqrt(-1);
end

%if string aruments, lock or unlock current figure	
if isstr(i1)
   if isempty(str2num(i1))
      if strcmp(i1,'lock')
	 linestyle lock
	 updaterings;
         return
      end
      if strcmp(i1,'unlock')
	 linestyle unlock
         return
      end
   end
end

   %check to see if current figures axes are locked
 locked=0;
 if isappdata(gcf,'linestylelock')
    if getappdata(gcf,'linestylelock')
	 locked=1;	
    end 
 end
 if ~locked
    lineringapply(i1);
 else
    h=axeshandles(gcf);	
    for i=1:length(h)
	  axes(h(i))
	  lineringapply(i1);
    end
 end


function[]=lineringapply(n)

[h1 h2]=linehandles;
N=length(h1);

if isstr(n)
  n=str2num(n);
end

nold=1;
if isappdata(gca,'lineringpointer')
     nold=getappdata(gca,'lineringpointer');
end
if isempty(nold)
     nold=1;
end


index=[];
if isreal(n)
   index=cycle([1:N]',n);
   nnew=nold+n;	
   while nnew<=0
	nnew=nnew+N;
   end
   while nnew>N
	nnew=nnew-N;
   end
   setappdata(gca,'lineringpointer',nnew)
else
   n=imag(n);
   index=cycle([1:N]',-nold);
   index=cycle(index,n);	
while n<=0
	n=n+N;
   end
   while n>N
	n=n-N;
   end
   setappdata(gca,'lineringpointer',n)
end

if ~isempty(index)
    xx=get(h1,{'color','linestyle','linewidth'});
    set(h1,{'color','linestyle','linewidth'},xx(index,:));
end


function[out,n]=cycle(in,n)
N=length(in);

while n<=0
   n=N+n;
end
while n>N
   n=n-N;
end

if n>0
       index=[n+1:N 1:n];
else	  
       index=[N-n:N 1:N-n-1];
end
out=in(index);


function[]=updaterings

num=1;
if isappdata(gca,'lineringpointer')
   num=getappdata(gca,'lineringpointer');
end

h=gca;
hall=axeshandles(gcf);

for i=1:length(hall)
    if h~=hall(i)
	 axes(hall(i))
	 linering(num*sqrt(-1))
    end
end
axes(h)

