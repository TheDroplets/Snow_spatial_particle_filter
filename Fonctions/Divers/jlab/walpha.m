function[auv,aeo,adc,apn]=walpha(wu,wv)
% WALPHA  Widely linear transform anisotropy parameters.
%
%   [AUV,AEO,ADC,APN]=WALPHA(WU,WV) where WU and WV are the U and V
%   widely linear transforms for a complex-valued time series, returns
%   the anisotropy parameters AUV, AEO, ADC, and APN defined as
%
%        AUV = (|WP|^2 - |WN|^2)./(|WP|^2 + |WN|^2)
%
%   and so forth.  See Lilly (2005) for details.
%
%   See also TRANSCONV.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2005 J.M. Lilly --- type 'help jlab_license' for details        

auv=frac(abs(wu).^2-abs(wv).^2,abs(wu).^2+abs(wv).^2);

[wa,wb]=wconvert(wu,wv,'pn');
apn=frac(abs(wa).^2-abs(wb).^2,abs(wa).^2+abs(wb).^2);
  
[wa,wb]=wconvert(wu,wv,'eo');
aeo=frac(abs(wa).^2-abs(wb).^2,abs(wa).^2+abs(wb).^2);

[wa,wb]=wconvert(wu,wv,'dc');
adc=frac(abs(wa).^2-abs(wb).^2,abs(wa).^2+abs(wb).^2);

