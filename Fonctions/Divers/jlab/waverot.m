function[w,err]=waverot(w)
%WAVEROT Rotates complex-valued wavelets.
%
%   WAVEROT(W) where W is a complex-valued analytic wavelet, rotates
%   W such that the real part is even and the imaginary part is odd.
%  
%   Also, specifies that at the midpoint of W, the real part must be
%   positive and the imaginary part must be increasing, like a sinusoid.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

if size(w,2)>size(w,1)
  error('W must be a column vector.')
end

N=1000; %use this many points to avoid huge matrices

if length(w)>N
  n=round(length(w)/N); %this is the interval to give me N points
  x=w(1:n:end);
else
  x=w;
end

phi=[0:.01:pi]';
rot=exp(sqrt(-1)*phi);

x1=oprod(x,rot);
x2=conj(oprod(flipud(x),rot));
dx=sum(abs(x2-x1));
[m,mi]=min(dx);
rot1=rot(mi);

w=w*rot1;

mid=round(length(w)/2);
if real(w(mid))<0
  w=-w;
end

if imag(w(mid+1)-w(mid))<0
  w=conj(w);
end
