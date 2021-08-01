function handles=jarrow(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)
%   JARROW   Adds an arrow to a plot.
%
%   ho=jarrow(sp,yp,headlength,headangle,linewidth,colour,linestyle)
%             - will create an arrow object on the current axis
%
%   jarrow(hi,sp,yp,headlength,headangle,linewidth,colour,linestyle)
%             - will edit an existing jarrow object on the current axis
%
%   ho         - a 2x1 vector of handles of newly created arrow object
%                (h(1)=handle of arrow line, h(2)=handle of arrow head)
%   hi         - a handle of an arrow object (can be either the handle of
%                line or the arrow head)
%   sp         - start point (=[x y])
%   fp         - finish point (=[x y])
%   headlength - length of arrow head (inches)
%                (optional param, default 0.085)
%   headangle  - angle of arrow head
%                (optional param, default=pi/6)
%   linewidth  - width of main body of arrow 
%                (optional param, default=0.5)
%   colour     - colour of arrow
%                (optional param, default [1 1 1]
%   linestyle  - linestyle of arrow line
%                (optional param, default "-")
% 
%   Calling JARROW with no params uses "ginput" to enter coordinates
%
%   For example, to create an arrow
%
%         h=jarrow([3 3],[4 4],0.2,pi/10,2,[1 1 0],'-');
%
%    To reposition an arrow
%  
%         arrow(h(1),[4 4],[5 5])
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1996 R.S. Oldaker --- type 'help jlab_license' for details        
  
% Author R. S. Oldaker May 16 1996 
  
% Note: I have been unable to track down R. S.  Oldaker in order to ask
% his permission to include his m-file in this collection.  If you
% happen to know his whereabouts, please ask him to contact me at
% software@jmlilly.net.
  
if nargin==0 edit=0; end

if nargin>=1
% this means its a handle
   if length(arg1)==1
      handles(1)=arg1(1);
      ud=get(handles(1),'userdata');
      handles(2)=abs(ud(2,2));
      sp=arg2;
      fp=arg3;
      headlength=arg4;
      headangle=arg5;
      linewidth=arg6;
      colour=arg7;
      linestyle=arg8;
      edit=1;
   else
      edit=0;
   end
end

if edit==0
   if nargin<7 
      linestyle='-';
   else
      linestyle=arg7;
   end
   if nargin<6
      colour='w';
   else
      colour=arg6;
   end
   if nargin<5
      linewidth=0.5;
   else
      linewidth=arg5;
   end
   if nargin<4
      headangle=pi/6;        % angle in rads
   else
      headangle=arg4;
   end
   if nargin<3
      headlength=0.085;  % length of tip
   else
      headlength=arg3;
   end
   if nargin<1
      disp('Enter start point of arrow');
      [sp(1),sp(2)]=ginput(1);
   else
      sp=arg1;
   end
   if nargin<2
      disp('Enter finish point of arrow');
      [fp(1),fp(2)]=ginput(1);
   else
      fp=arg2;
   end
end


% get axis limits and the size of the axis in inches
xlim=get(gca,'xlim');
ylim=get(gca,'ylim');
cunits=get(gca,'units');
set(gca,'units','inches');
pos=get(gca,'position');
set(gca,'units',cunits);

% Conversion factors from user units to inches
mx=pos(3)/(xlim(2)-xlim(1));
my=pos(4)/(ylim(2)-ylim(1));

% x and y points of line
xl=[sp(1) fp(1)];
yl=[sp(2) fp(2)];

% get axis limits and the size of the axis in inches
xlim=get(gca,'xlim');
ylim=get(gca,'ylim');
cunits=get(gca,'units');
set(gca,'units','inches');
pos=get(gca,'position');
set(gca,'units',cunits);

% Conversion factors from user units to inches
mx=pos(3)/(xlim(2)-xlim(1));
my=pos(4)/(ylim(2)-ylim(1));

% Convert to inches
xlin=(xl-xlim(1))*mx;
ylin=(yl-ylim(1))*my;

% Now work out arrow head points
alpha=atan2(ylin(2)-ylin(1),xlin(2)-xlin(1));

xah=zeros(1,3); yah=zeros(1,3);
xadd1=headlength*cos(alpha);
yadd1=headlength*sin(alpha);
xadd2=headlength*sin(headangle)*sin(alpha);
yadd2=headlength*sin(headangle)*cos(alpha);
xah(1)=xlin(2);
xah(2)=xlin(2)+xadd2-xadd1;
xah(3)=xlin(2)-xadd2-xadd1;

yah(1)=ylin(2);
yah(2)=ylin(2)-yadd2-yadd1;
yah(3)=ylin(2)+yadd2-yadd1;

xlin(2)=xlin(2)-xadd1;
ylin(2)=ylin(2)-yadd1;

% convert back to user coords
xah=xah/mx+xlim(1);
yah=yah/my+ylim(1);
xl=xlin/mx+xlim(1);
yl=ylin/my+ylim(1);

% draw line
if edit==0
   handles(1)=line(xl,yl,'linestyle',linestyle,'color',colour,'clipping','off','linewidth',linewidth);
% and arrow head
   handles(2)=patch(xah,yah,colour,...
	'clipping','off',...
	'edgecolor','none');
else
   set(handles(1),'xdata',xl,'ydata',yl,...
		'linestyle',linestyle,...
		'color',colour,...
		'linewidth',linewidth);
   set(handles(2),'xdata',xah,'ydata',yah,...
		'facecolor',colour);
end
% set handle of arrow head and arrow line into the userdata

if 0
  ud='arrow';
ud=[ud;zeros(2,length(ud))];
ud(2,1)=handles(1);
ud(2,2)=handles(2);
ud(3,1)=headlength;
ud(3,2)=headangle;
ud=setstr(ud);
set(handles(1),'userdata',ud);
set(handles(2),'userdata',ud);
end

return
%end
