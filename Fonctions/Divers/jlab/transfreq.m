function[f]=transfreq(i1,i2)
% TRANSFREQ  Wavelet transform freqeuncy.
%  
%   F=TRANSFREQ(W) where W is a wavelet transform array computes the
%   *cyclic* wavelet transform frequency F using the first central 
%   difference and assuming a unit sample rate.  F has the same size 
%   as W.
%
%   F=TRANSFREQ(DT,W) instead uses timestep DT to compute the 
%   transform frequency F. 
%
%   In order that F the generally positive, in keeping with the 
%   convention of Lilly and Gascard (2006), the sign of F is chosen 
%   such that its mean value is positive.
%
%   See also WAVETRANS, RIDGEWALK.
%
%   Usage: f=transfreq(w);
%          f=transfreq(dt,w);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details        



if nargin==1
    dt=1;
    w=i1;
else
    dt=i1;
    w=i2;
end

%/***********************************************************
%Frequency
f=frac(1,2*pi*dt)*vdiff(unwrangle(imlog(w)),1);
for k=1:size(w,3)
    if vmean(vmean(f(:,:,k),1),2)<0,
       f(:,:,k)=-f(:,:,k);
    end
end
%\********************************************************
