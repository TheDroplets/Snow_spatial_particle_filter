function [fmin, fmax,fo,fw] = morsefreq(A,ga,be)
%MORSEFREQ  Minimum and maximum frequencies of Morse wavelets.
%
%   [FMIN,FMAX]=MORSEFREQ(A,GAMMA,BETA) calculates the minimum and
%   maximum frequency of the time/frequency concentration region of the
%   generalized Morse wavelets specified by area A and by parameters
%   GAMMA and BETA.
%
%   The input parameters must either be matrices of the same size, or
%   some may be matrices and the others scalars.    
%
%   [FMIN,FMAX,F0,FW]=MORSEFREQ(A,GAMMA,BETA) also outputs the central
%   frequency F0=1/2*(FMAX+FMIN) and the half-width of the region of
%   concentration FW=1/2*(FMAX-FMIN).
% 
%   MORSEFREQ uses the formula of Olhede and Walden (2002),
%   "Generalized Morse Wavelets", the first formula on page 2665.
%
%   'morsefreq --f' generates a sample figure
%
%   Usage: [fmin,fmax] = morsefreq(A,ga,be);
%          [fmin,fmax,fc,fw] = morsefreq(A,ga,be);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 F. Rekibi and J. M. Lilly 
%                         --- type 'help jlab_license' for details    
if strcmp(A,'--t')
  morsefreq_test;return
end

if strcmp(A,'--f')
  morsefreq_fig;return
end

C = morsecfun(A,ga,be);
r=(2*be+1)./ga;
coeff=gamma(r+(1./ga)).*2.^(-1./ga);
fmin=coeff./(2*pi.*gamma(r).*(C+sqrt(C.^2-1)).^(1./ga));
fmax=coeff./(2*pi.*gamma(r).*(C-sqrt(C.^2-1)).^(1./ga));

if nargout>2
  fo=frac(1,2)*(fmax+fmin);
end
if nargout>3
  fw=frac(1,2)*(fmax-fmin);
end



function[]=morsefreq_fig
be=5;
ga=2;
A=logspace(-3,3,100);;
[fmin,fmax,fc,fw] = morsefreq(A,ga,be);

figure,
plot(A,fc),xlog,hold on
plot(A,fc+fw,'r')
plot(A,fc-fw,'r')
xlabel('Area of concentration A')
ylabel('Central, minimum, and maximum frequencies')
title('Central frequency asymptotes for small A')

%c1= [1.5353    8.9527];
%c3= [1.0424    1.5783]
%A1 = morsearea(c1,1,1);
%[fmin,fmax,fo,fw] = morsefreq(A1,1,1);


C1=logspace(0,3,100)';
be1=linspace(1,10,101)';
C=osum(C1,0*be1);
be=osum(0*C1,be1);

figure
subplot(121)
[fmin,fmax,fo,fw] = morsefreq(C,2,be);
contourf(C1,be1,1./fo',20)
xlog
xlabel('Parameter C')
ylabel('Parameter \beta')
title('Central Period 1/f_o with \gamma =2')
colorbar

subplot(122)
[fmin,fmax,fo,fw] = morsefreq(C,4,be);
contourf(C1,be1,1./fo',20)
xlog
xlabel('Parameter C')
ylabel('Parameter \beta')
title('Central Period 1/f_o with \gamma =4')
colorbar
  
 
figure
subplot(121)
[fmin,fmax,fo,fw] = morsefreq(C,2,be);
contourf(C1,be1,fw',20)
xlog
xlabel('Parameter C')
ylabel('Parameter \beta')
title('Half-bandwidth f_w with \gamma =2')
colorbar

subplot(122)
[fmin,fmax,fo,fw] = morsefreq(C,4,be);
contourf(C1,be1,fw',20)
xlog
xlabel('Parameter C')
ylabel('Parameter \beta')
title('Half-bandwidth f_w with \gamma =4')
colorbar

