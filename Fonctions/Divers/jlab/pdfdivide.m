function[fz]=pdfdivide(xi,yi,fx,fy,zi);
%PDFDIVIDE  Probability distribution from dividing two random variables.
%
%   YN=PDFDIVIDE(XI,YI,FX,FY,ZI) given two probability distribution
%   functions FX and FY, defined over XI and YI, returns the pdf FZ
%   corresponding to Z=X/Y over values ZI.
%
%   For a discussion of the algorithm, see Papoulis (1991), page 138.
%  
%   'pdfdivide --f' generates a sample figure
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details    
  
  
if strcmp(xi,'--f')
    pdfdivide_fig;
    return
end
  
dx=xi(2)-xi(1);

vcolon(xi,yi,fx,fy);
zi=conj(zi(:)');


ym=yi*[1+0*zi];
%fxm=fx*[1+0*zi];
fym=fy*[1+0*zi];
zm=[1+0*yi]*zi;
zym=zm.*ym;

fxmi=vinterp(xi,fx,zym);
mat=abs(ym).*fxmi.*fym;
fz=vsum(mat*dx,1)';

dz=zi(2)-zi(1);
fz=fz./vsum(fz*dz,1);
[mu,sigma]=pdfprops(zi',fz);

function[]=pdfdivide_fig
  
%test with cauchy
dx=0.1;
dy=0.05;
s1=1;
s2=2;
xi=[-10:dx:10];
yi=[-10:dy:10];

fx=simplepdf(xi,0,s1,'gaussian');
fy=simplepdf(yi,0,s2,'gaussian');

fz0=s1.*s2./pi./(s2.^2.*xi.^2+s1.^2);
fz0=fz0./vsum(fz0*dx,1);
fz=pdfdivide(xi,yi,fx,fy,xi);

figure,plot(xi,fz),hold on,plot(xi,fx)
plot(yi,fy)
linestyle default
title('RV with green pdf divided by RV with red pdf equals RV with blue pdf')
text(4,0.4,'Green and red are Gaussian')
text(4,0.35,'Blue is Cauchy')
text(4,0.30,'Dots are from a random trial')

x1=randn(100000,1)*s1;
y1=randn(100000,1)*s2;
[fz1,n]=hist(x1./y1,[-10:.1:10]);
plot(n,fz1/10000,'.')

% %plot(xi,fz0,'r')

% plot(xi,fz,'r+')
%   
% dx=0.1;
% dy=0.05;
% s1=1;
% s2=2;
% xi=[-10:dx:10];
% yi=[-10:dy:10];
% fz(:,1)=pdfdivide(xi,xi,fx,fx,xi);
% fz(:,2)=pdfdivide(xi,yi,fx,fy,xi);
% figure,plot(fz)
% 
% fz(:,1)=pdfdivide(yi,xi,fy,fx,xi);
% fz(:,2)=pdfdivide(yi,yi,fy,fy,xi);




