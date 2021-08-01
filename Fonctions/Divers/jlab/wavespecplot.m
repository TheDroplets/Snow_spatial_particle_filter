function[h]=wavespecplot(varargin)
%WAVESPECPLOT  Plot of wavelet spectra together with time series.
%
%   WAVESPECPLOT(T,X,P,Y) where T is the time, X is a time series, and
%   the Y is wavelet transform modulus at period P, makes a two-
%   component  plot.  The upper subplot has the time series X plotted 
%   against its time axis T. The lower subplot has the transform Y 
%   plotted versus the time axis T and the frequency axis expressed 
%   in periods P.
%
%   WAVESPECPLOT(T,X,P,Y,R) optionally plots Y.^R instead of Y.
%  
%   WAVESPECPLOT(T,X,P,Y,R,CI) makes a filled contour plot with
%   contour intervals CI.  If CI is not input, then the spectrum is
%   plotted using PCOLOR, which is faster to render but slow to print.
%   For making final figures, it is better to use the contouring
%   option.
%
%   WAVESPECPLOT(T,X,P,Y1,Y2,...YN,...) makes an N+1 component plot,
%   with Y1 in the second subplot, Y2 in the third, etc.
%
%   After plotting, all subplots are packed together using PACKROWS.
%   H=WAVESPECPLOT(...) returns the handles to the subplots. 
%
%   If X is complex-valued, both the real and imaginary parts are
%   plotted in the uppermost subplot.
%
%   If the transform matrix T is complex-valued, its absolute value
%   is taken before plotting.
%
%   Usage: h=wavespecplot(t,x,p,y);
%          h=wavespecplot(t,x,p,y,r);
% 
%   'wavespecplot --t' generates a sample figure  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(varargin{1},'--t')
  wavespecplot_test;return
end

t=varargin{1};
u=varargin{2};
p=varargin{3};
p=p(:);

nspec=nargin-3;

n=1;
ci=[];

if length(varargin{end})==1
  if length(varargin{end-1})==1
     ci=varargin{end};
     n=varargin{end-1};
     nspec=nspec-2;
  else
     n=varargin{end};
     nspec=nspec-1;
  end
else
  if issing(varargin{end})
     ci=varargin{end};
     n=varargin{end-1};
     nspec=nspec-2;
  end     
end

a=min(t);
b=max(t);

if isreal(u)
  c=maxmax(u);
else
  c=max([maxmax(real(u)) maxmax(imag(u))]);
end
  
c=c*1.1;

subplot(nspec+1,1,1)
if ~isreal(u)
  uvplot(t,u);
else
  plot(t,u);
end
xlim([a,b])
ylim([-c c])
grid off
hlines(0,'k:')

for i=1:nspec
  subplot(nspec+1,1,i+1)
  T=varargin{3+i}';
  if ~isreal(T)
     T=abs(T);
  end
  T=T.^n;
  if isempty(ci)
    pcolor(t,p,T),shading interp
  else 
    contourf(t,p,T,ci),hold on
    contour(t,p,T,ci)
    caxis([min(ci) max(ci)])
  end
  xlim([a,b])
  flipy
  hold on
  set(gca,'tickdir','out')
  ylog
end
h=packrows(nspec+1,1);


function[]=wavespecplot_test

[w,wlambda,wf,wl]=slepwave(2.5,3,1,20,1/1024/2,1/4/2);
w=bandnorm(w,wf);
s=1./wf;

[x,t]=testseries(3);
y=wavetrans(x,w);

h=wavespecplot(t,x,s,abs(y));
edgeplot(wl,s,t);

%   [x,t,fx]=testseries(6);
%   fs=fliplr(logspace(log10(1/1024/2),log10(1/8),40));
%   [w,sigma,W]=morlwave(length(x),fs,2/3);
%   w=bandnorm(w,fs);
%   y=wavetrans(x,w,'zeros');
%   h=wavespecplot(t,abs(fx),1./fs,real(y),imag(y),abs(y));
%   axes(h(1)),xlim([147.2 230]),ylim([0 35])
%   for i=2:length(h)
%        axes(h(i)),axis([147.2 230 7.5 2100]),caxis([0 20])
%   end 
