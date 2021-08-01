function[]=plbl(wf,units,prec,deltat)
% PLBL  Label frequency axis in terms of period.

%		(optional, default = 's').
%		

set(gca,'YTickMode','manual')
set(gca,'YTicklabelMode','manual')
if nargin<2 
     units='s';
end
if nargin<3
     prec=0;
end
if nargin<4
     deltat=1;
end

%**********************
%adjust periods for sample rate

wf=wf(:);

wf=flipud(wf);

x=2*pi./(wf./deltat);

maxwidth=length(num2str(max(x)));

periods=vint2str(x,prec,'spaces');
set(gca,'YTick',wf);
set(gca,'YTickLabel',periods);
ylabel(['Period (' units ') = 1 / f_{c}  '])
set(gca,'yminortick','off')


