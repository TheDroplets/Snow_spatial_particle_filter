function[]=ellipsetests
%ELLIPSETESTS  Run tests on ellipse code.
%
%   ELLIPSETESTS runs a suite of tests on the wavelet ellipse and
%   polarization algorithms using the equations presented in Lilly
%   (2004).
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
%/********************************************************
disp('Ellipse Section 2 tests')

N=10;
th=rand(1,1,N)*2*pi;
tol=1e-10;

costh=ndrep(2,cos(th),2);
costh=ndrep(2,costh,1);  

sinth=ndrep(2,sin(th),2);
sinth=ndrep(2,sinth,1);  

rotth=ndrep(2,rot(th),2);  
rotth=ndrep(2,rotth,1);  

piN=pi+0*th;

wu=randn(N,1)+sqrt(-1)*randn(N,1);
wv=randn(N,1)+sqrt(-1)*randn(N,1);
c=sqrt(abs(wu).^2+abs(wv).^2);
wu=wu./c;
wv=wv./c;


wu2=randn(N,1)+sqrt(-1)*randn(N,1);
wv2=randn(N,1)+sqrt(-1)*randn(N,1);
c=sqrt(abs(wu2).^2+abs(wv2).^2);
wu2=wu2./c;
wv2=wv2./c;

ii=13;
m1=jmat(th);
m2=jmat(-th);
m3=diagmat(2*cos(th));
reporttest(['Ellipse equation # ' int2str(ii)],aresame(m1+m2,m3,tol))

ii=ii+1;
m3=0*m3;
m3(1,2,:)=-2*sin(th);
m3(2,1,:)=2*sin(th);
reporttest(['Ellipse equation # ' int2str(ii)],aresame(m1-m2,m3,tol))

ii=ii+1;
T=tmat;
reporttest(['Ellipse equation # ' int2str(ii)],aresame(eye(2),T*T',tol))

ii=ii+2;
b=aresame(rot(pi/4)*eye(2),T*T*T,tol);
reporttest(['Ellipse equation # ' int2str(ii)],b)

ii=ii+2;
m1=jmat(th);
for i=1:N
  m2(:,:,i)=tmat'*kmat(th(i))*tmat;
end
reporttest(['Ellipse equation # ' int2str(ii)],aresame(m1,m2,tol))

ii=ii+2;
m1=costh.*imat(N)+sqrt(-1).*sinth.*dmat(N);
m2=matmult(kmat(-pi/4),jmat(th),kmat(pi/4));
m3=matmult(kmat(pi/4),jmat(-th),kmat(-pi/4));
m4=matmult(tmat,kmat(th),tmat');

b1=aresame(m1,m2,tol);
b2=aresame(m1,m3,tol);
b3=aresame(m1,m4,tol);
reporttest(['Ellipse equation # ' int2str(ii)],all([b1 b2 b2]))
%\********************************************************

%/********************************************************
disp('Ellipse Section 3 tests')

for j=1:4
  [m,n]=mandn(j);

  x1=m'*m+conj(n'*n);
  x2=m'*n+conj(n'*m);
  x3=m*m'+n*n';
  x4=m*conj(n)'+n*conj(m)';
  
  b1=aresame(x1,eye(2),tol);
  b2=aresame(x2,0*x2,tol);
  b3=aresame(x3,eye(2),tol);
  b4=aresame(x4,0*x4,tol);
end
ii=60;reporttest(['Ellipse equation # ' int2str(ii)],b1)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b2)
ii=ii+2;reporttest(['Ellipse equation # ' int2str(ii)],b3)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b4)

clear b1 b2
for j=1:4
  [m,n]=mandn(j);

  amat1=matmult(m,jmat(th),m')+matmult(n,jmat(th),n'); 
  bmat1=matmult(m,jmat(th),conj(n'))+matmult(n,jmat(th),conj(m)'); 

  api2=m*jmat(pi/2)*m'+n*jmat(pi/2)*n';  
  api2=ndrep(N,api2,3);
  
  bpi2=m*jmat(pi/2)*conj(n')+n*jmat(pi/2)*conj(m');  
  bpi2=ndrep(N,bpi2,3);
  
  amat2=costh.*imat(N)+sinth.*api2;
  bmat2=sinth.*bpi2;
  
  b1(j,1)=aresame(amat1,amat2,tol);
  b2(j,1)=aresame(bmat1,bmat2,tol);
%  b3(j,1)=aresame(bmat1,0*bmat1,tol)
end
ii=72;reporttest(['Ellipse equation # ' int2str(ii)],all(b1))
ii=ii+2;reporttest(['Ellipse equation # ' int2str(ii)],all(b2))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],all(b3))

clear b


str{1}='uv2eo';
str{2}='uv2dc';
str{3}='uv2pn';
str{4}='uv2x*';


for j=1:4
  [wa,wb]=transconv(wu,wv,str{j});
  [wup,wvp]=vectmult(jmat(th),wu,wv);
  [wa1,wb1]=transconv(wup,wvp,str{j});
  
  
  m1=zeros(2,2,N);
  m2=zeros(2,2,N);
  switch j
   case 1
     m1=imat(N).*rotth;
   case 2
     m1=imat(N).*costh;
     m2=jmat(piN/2).*sinth;
   case 3
     m1=imat(N).*rotth;
   case 4
     m1=kmat(th);
  end
  [wa2,wb2]=vectmult(m1,m2,wa,wb);
  b(j)=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
end
ii=75;
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(1))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(2))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(4))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(3))

clear b
for j=1:4
  [wa,wb]=transconv(wu,wv,str{j});
  [wup,wvp]=vectmult(rotth.*imat(N),wu,wv);
  [wa1,wb1]=transconv(wup,wvp,str{j});
    
  m1=zeros(2,2,N);
  m2=zeros(2,2,N);
  switch j
   case 1
     m1=jmat(th);
   case 2
     m1=costh.*imat(N)-sqrt(-1)*sinth.*dmat(N);
   case 3
     m1=kmat(th);
   case 4
     m1=rotth.*imat(N);     
  end
  [wa2,wb2]=vectmult(m1,m2,wa,wb);
  b(j)=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
end
ii=ii+2;reporttest(['Ellipse equation # ' int2str(ii)],b(1))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(2))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(4))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(3))


clear b
for j=1:4
  [wa,wb]=transconv(wu,wv,str{j});
  [wup,wvp]=vectmult(kmat(th),wu,wv);
  [wa1,wb1]=transconv(wup,wvp,str{j});
  
  m1=zeros(2,2,N);
  m2=zeros(2,2,N);
  switch j
   case 1
     m1=costh.*imat(N);
     m2=sinth.*jmat(piN./2);
   case 2
     m1=costh.*imat(N);
     m2=-1*sqrt(-1)*sinth.*jmat(piN./2);
   case 3
     m1=costh.*imat(N);
     m2=-1*sqrt(-1)*sinth.*jmat(piN./2); 
   case 4
     m1=costh.*imat(N)+sqrt(-1)*sinth.*dmat(N);
  end
  [wa2,wb2]=vectmult(m1,m2,wa,wb);
  b(j)=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
end
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(1))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(2))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(4))
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b(3))


clear b
for j=1:4
  [wa,wb]=transconv(wu,wv,str{j});
  [wa2,wb2]=transconv(wu2,wv2,str{j});
  
  tr1=abs(wu).^2+abs(wv).^2+abs(wu2).^2+abs(wv2).^2;
  tr2=abs(wa).^2+abs(wb).^2+abs(wa2).^2+abs(wb2).^2;
  
  b(j)=aresame(tr1,tr2,tol);
end
ii=124;reporttest(['Ellipse equation # ' int2str(ii)],b)
%\********************************************************



%/********************************************************
disp('Ellipse Section 4 tests')

%DC phase shifts
%/******************
[wd,wc]=transconv(wu,wv,'uv2dc');
[wd,wc]=vectmult(rotth.*imat(N),wd,wc);
[wa1,wb1]=transconv(wd,wc,'dc2uv');
[wa2,wb2]=vectmult(imat(N).*costh-sqrt(-1)*sinth.*dmat(N),wu,wv);
b=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
ii=116;reporttest(['Ellipse equation # ' int2str(ii)],b)


[a,b,theta,phi,nu,ka,ecc]=normform(wu,wv); 
phi=permute(phi,[2 3 1]);
rotphi=ndrep(2,rot(phi),1);
rotphi=ndrep(2,rotphi,2);

m1=costh.*rotphi.*jmat(theta);
m2=-1*sqrt(-1).*sinth.*rotphi.*jmat(-theta+pi/2);
[wa2,wb2]=vectmult(m1,m2,a,-sqrt(-1).*b);
b1=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b1)

%unrotate
[wu2,wv2]=vectmult(jmat(-theta),wu,wv);
[wd,wc]=transconv(wu2,wv2,'uv2dc');
[wd,wc]=vectmult(rotth.*imat(N),wd,wc);
[wa1,wb1]=transconv(wd,wc,'dc2uv');

nu=atan(b./a);
nu=permute(nu,[2 3 1]);

[wa2,wb2]=vectmult(rotphi.*imat(N),cos(nu+th),-sqrt(-1).*sin(nu+th));

b1=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],b1)
%\******************

%DC phase lags
%/******************
[wd,wc]=transconv(wu,wv,'uv2dc');
[wd,wc]=vectmult(kmat(th),wd,wc);
[wa1,wb1]=transconv(wd,wc,'dc2uv');
[wa2,wb2]=vectmult(imat(N).*costh,-1*sqrt(-1)*sinth.*jmat(piN/2),wu,wv);
bool=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
ii=119;reporttest(['Ellipse equation # ' int2str(ii)],bool)

%unrotate
[wu2,wv2]=vectmult(conj(rotphi).*imat(N),wu,wv);
[wd,wc]=transconv(wu2,wv2,'uv2dc');
[wd,wc]=vectmult(kmat(th),wd,wc);
[wa1,wb1]=transconv(wd,wc,'dc2uv');

nu=atan(b./a);
nu=permute(nu,[2 3 1]);

[wa2,wb2]=vectmult(jmat(theta),cos(nu+th),-sqrt(-1).*sin(nu+th));

bool=aresame(wa1,wa2,tol)&aresame(wb1,wb2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool)
%\******************
%\********************************************************

% %/********************************************************
% disp('Section 4.4 Tests')
% N1=1000;
% u=randn(N1,1);
% v=randn(N1,1);
% cv=u+sqrt(-1)*v;
% t=[1:length(cv)]';
% tol=1e-10;
% 
% ga=2;
% K=1;
% be=5;a=logspace(log10(1),log10(30),20);
% [w,fs,W]=morsewave(length(cv),K,ga,be,a);
% w=bandnorm(w,fs);
% yu=wavetrans(u,w);
% yv=wavetrans(v,w);
% %h=wavespecplot(t,cv,a,abs(yu),abs(yv),1/2);
% 
% rw=2*real(w);
% rw=real(fft(W));
% %figure,uvplot(rw);
% 
% u2=anatrans(u);
% v2=anatrans(v);
% yu2=wavetrans(u2,rw);
% yv2=wavetrans(v2,rw);
% 
% %figure,plot(abs(yu)),hold on,plot(abs(yu2),'r')
% %h=wavespecplot(t,cv,a,abs(yu2),abs(yv2),1/2);
% 
% e2=cv./2;
% o2=hiltrans(e2);
% ye2=wavetrans(e2,rw);
% yo2=wavetrans(o2,rw);
% [ye,yo]=wconvert(yu,yv,'eo');
% %figure,plot(abs(ye)),hold on,plot(abs(ye2),'r')
% 
% d2=u/2-sqrt(-1)*hiltrans(v)/2;
% c2=v/2-sqrt(-1)*hiltrans(u)/2;
% yd2=wavetrans(d2,rw);
% yc2=wavetrans(c2,rw);
% [yd,yc]=wconvert(yu,yv,'dc');
% %figure,plot(abs(yd)),hold on,plot(abs(yd2),'r')
% 
% p2=anatrans(cv)/sqrt(2);
% n2=conj(anatrans(conj(cv)))/sqrt(2);
% yp2=wavetrans(p2,rw);
% yn2=wavetrans(n2,rw);
% [yp,yn]=wconvert(yu,yv,'pn');
% %figure,plot(abs(yp)),hold on,plot(abs(yp2),'r')
% 
% %vindex(yu,yv,ye,yo,yd,yc,yp,yn,300:700,1);
% %vindex(yu2,yv2,ye2,yo2,yd2,yc2,yp2,yn2,300:700,1);
% clear bool
% bool(1)=aresame(yu,yu2,tol);
% bool(2)=aresame(yv,yv2,tol);
% bool(3)=aresame(ye,ye2,tol);
% bool(4)=aresame(yo,yo2,tol);
% bool(5)=aresame(yd,yd2,tol);
% bool(6)=aresame(yc,yc2,tol);
% bool(7)=aresame(yp,yp2,tol);
% bool(8)=aresame(yn,yn2,tol);
% 
% ii=96;
% ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool(1)&bool(2))
% ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool(3)&bool(4))
% ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool(5)&bool(6))
% ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool(7)&bool(8))
%\********************************************************

%/********************************************************
disp('Ellipse Section 6 tests')

%/****************
%Spectral matrix expressions

[we,wo]=transconv(wu,wv,'uv2eo');
[wd,wc]=transconv(wu,wv,'uv2dc');

[we2,wo2]=transconv(wu2,wv2,'uv2eo');
[wd2,wc2]=transconv(wu2,wv2,'uv2dc');

[meo,neo]=mandn('eo');
[mdc,ndc]=mandn('dc');

clear bool1 bool2 
for i=1:N
  w1=[wu(i);wv(i)];
  w2=[wu2(i);wv2(i)];
  S1=w1*(w1')+w2*(w2');
  C1=w1*conj(w1')+w2*conj(w2');
  
  w1=[we(i);wo(i)];
  w2=[we2(i);wo2(i)];
  Seo1=w1*(w1')+w2*(w2');
  Ceo1=w1*conj(w1')+w2*conj(w2');
  
  w1=[wd(i);wc(i)];
  w2=[wd2(i);wc2(i)];
  Sdc1=w1*(w1')+w2*(w2');
  Cdc1=w1*conj(w1')+w2*conj(w2');
  
  Seo2=meo*S1*(meo')+neo*conj(S1)*(neo')+meo*C1*(neo')+neo*conj(C1)*(meo');
  Ceo2=meo*C1*conj(meo')+neo*conj(C1)*conj(neo')+meo*S1*conj(neo')+ ...
       neo*conj(S1)*conj(meo');
  
  Sdc2=mdc*S1*(mdc')+ndc*conj(S1)*(ndc')+mdc*C1*(ndc')+ndc*conj(C1)*(mdc');
  Cdc2=mdc*C1*conj(mdc')+ndc*conj(C1)*conj(ndc')+mdc*S1*conj(ndc')+ ...
       ndc*conj(S1)*conj(mdc');
  
 
  bool1(i,1)=aresame(Seo1,Seo2,tol);
  bool2(i,1)=aresame(Ceo1,Ceo2,tol);
  
  bool1(i,2)=aresame(Sdc1,Sdc2,tol);
  bool2(i,2)=aresame(Cdc1,Cdc2,tol);
  
  bool3(i,1)=aresame(real(Sdc1(1,2)),real(S1(1,2)),tol);
  bool3(i,2)=aresame(imag(Seo1(1,2)),imag(S1(1,2)),tol);
end

ii=125;
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool1)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool2)
reporttest(['Ellipse equation # ' num2str(162.5)],bool3)
%\****************


S=randspecmat(N);
[p,alpha,beta,preal]=polparam(S);

bool=aresame(alpha.^2+abs(beta).^2,p.^2,tol);
ii=134;
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool)

th=th(:);
a1=cos(2*th).*alpha-sin(2*th).*real(beta);
b1=sin(2*th).*alpha+cos(2*th).*real(beta) +sqrt(-1)*imag(beta);

S2=matmult(jmat(th),S,jmat(-th));
[p,a2,b2,preal]=polparam(S2);

bool1=aresame(a1,a2,tol);
bool2=aresame(b1,b2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool1)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool1)

inv1=alpha.^2+(real(beta)).^2;
inv2=((S(1,1,:)-S(2,2,:)).^2+(2*real(S(1,2,:))).^2)./((S(1,1,:)+S(2,2,:)).^2);
inv2=inv2(:);
bool=aresame(inv1,inv2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool)

th1=[0:.01:2*pi];th1=permute(th1,[2 3 1]);
S1=randspecmat(1);
S2=matmult(jmat(th1),S1,jmat(-th1));
[p,alpha,beta,preal]=polparam(S2);
bool=aresame(maxmax(abs(alpha)),preal(1),1e-4);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool)

S=randspecmat(N);
[p,alpha,beta,preal]=polparam(S);
bool=aresame(p.^2,preal.^2+(imag(beta)).^2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool)

S=randspecmat(N);
[p,a1,b1,preal]=polparam(S);
m=costh.*imat(N)-sqrt(-1)*sinth.*dmat(N);
S2=matmult(m,S,conj(m));
[p,a2,b2,preal]=polparam(S2);
a3=a1.*cos(2*th(:))-imag(b1).*sin(2*th(:));
b3=imag(b1).*cos(2*th(:))+a1.*sin(2*th(:));
bool1=aresame(a2,a3,tol);
bool2=aresame(imag(b2),b3,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool1)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool2)

S1=randspecmat(1);
[p1,a1,b1,preal,gamma]=polparam(S1);
th1=[0:.01:2*pi];th1=permute(th1,[2 3 1]);
S2=matmult(jmat(th1),S1,jmat(-th1));
[p,alpha,beta,preal,gamma]=polparam(S2);
gammamin2=imag(b1).^2/(1-p1.^2+(imag(b1)).^2);
bool=aresame(minmin(abs(gamma).^2),gammamin2,1e-3);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool)


%/*************
%Testing cross-terms
[we,wo]=transconv(wu,wv,'uv2eo');
[wd,wc]=transconv(wu,wv,'uv2dc');

Suv1=wu.*conj(wv);
Seo1=we.*conj(wo);
Sdc1=wd.*conj(wc);

ue=real(wu);
ve=real(wv);
uo=-imag(wu);
vo=-imag(wv);

Suv2=ue.*ve+uo.*vo-sqrt(-1)*(uo.*ve-vo.*ue);
Seo2=-ue.*uo-ve.*vo-sqrt(-1)*(uo.*ve-vo.*ue);
Sdc2=ue.*ve+uo.*vo+sqrt(-1)*(ve.*vo-ue.*uo);

bool1=aresame(Suv1,Suv2,tol);
bool2=aresame(Seo1,Seo2,tol);
bool3=aresame(Sdc1,Sdc2,tol);
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool1)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool2)
ii=ii+1;reporttest(['Ellipse equation # ' int2str(ii)],bool3)
%\*************
%\********************************************************



if 0
  N=10000;
nu=rand(N,1)*pi/2-pi/4;
theta=randn(N,1)/10+pi/3;
phi=randn(N,1)/10+pi/3;
theta=0+0*theta;
phi=0+0*theta;

[wu,wv]=vectmult(jmat(theta),cos(nu),-sqrt(-1)*sin(nu));
wu=wu.*rot(phi);
wv=wv.*rot(phi);
clear Suv Seo
Suv(1,1,:)=wu.*conj(wu);
Suv(2,2,:)=wv.*conj(wv);
Suv(1,2,:)=wu.*conj(wv);
Suv(2,1,:)=wv.*conj(wu);
[we,wo]=wconvert(wu,wv,'eo');
Seo(1,1,:)=we.*conj(we);
Seo(2,2,:)=wo.*conj(wo);
Seo(1,2,:)=we.*conj(wo);
Seo(2,1,:)=wo.*conj(we);
[wd,wc]=wconvert(wu,wv,'dc');
Sdc(1,1,:)=wd.*conj(wd);
Sdc(2,2,:)=wc.*conj(wc);
Sdc(1,2,:)=wd.*conj(wc);
Sdc(2,1,:)=wc.*conj(wd);




mean(Suv,3)
mean(Seo,3)
mean(Sdc,3)

[p,alpha,beta,preal]=polparam(mean(Suv,3))
[p,alpha,beta,preal]=polparam(mean(Seo,3))
[p,alpha,beta,preal]=polparam(mean(Sdc,3))





[we,wo]=transconv(wu,wv,'uv2eo');

Seo=zeros(2,2,N);
for i=1:N
  w=[we(i);wo(i)];
  Seo(:,:,i)=w*w';
end
end
% 
% %/********************************************************
% phi=randn(N);
% nu=randn(N);
% nu=permute(nu,[2 3 1]);
% [wu,wv]=vectmult(jmat(th),[cos(nu);-sqrt(-1)*sin(nu))];
% [wu,wv]=vectmult(jmat(th),[cos(nu);-sqrt(-1)*sin(nu) ;
% wu=wu.*rot(phi);
% wv=wv.*rot(phi);
%\********************************************************




if 0
%/********************************************************
%This block is for the old definition of dc
clear b

wu0=wu;
wv0=wv;

wd=wu;
wc=wv;

nu=th;
wdp=rot(-nu).*wd;
wcp=rot(nu).*wc;

[wu,wv]=wconvert(wd,wc,'dc-');
[wu1,wv1]=wconvert(wdp,wcp,'dc-');

wu2=cos(nu).*wu+sqrt(-1)*sin(nu).*wv;
wv2=cos(nu).*wv+sqrt(-1)*sin(nu).*wu;
b=aresame(wu1,wu2,tol)&aresame(wv1,wv2,tol);
reporttest('d/c phase shifts',all(b))

[a,b,th,phi,nu,ka,ecc]=normform(wu,wv); 

beta1=frac(1,2).*angle(wdp.*conj(wcp));
num=cos(2.*th).*cos(2.*phi).*cos(2.*nu);
denom=sin(2.*phi).*cos(2.*th)+sin(2.*nu).*cos(2.*phi);
beta2=atan(frac(num,denom));
%figure,plot(beta1),hold on,plot(-beta2)
%linestyle b g 

wu3a=cos(nu).*(cos(th).*a +sqrt(-1).*b.*sin(th));
wu3b=sin(nu).*(cos(th).*b +sqrt(-1).*a.*sin(th));
wu3=rot(phi).*(wu3a+wu3b);

wv3a=cos(nu).*(-sin(th).*a -sqrt(-1).*b.*cos(th));
wv3b=sin(nu).*(-sin(th).*b +sqrt(-1).*a.*cos(th));
wv3=rot(phi).*(wv3a+wv3b);

b=aresame(wu1,wu3,tol)&aresame(wv1,wv3,tol);

reporttest('d/c phase shifts, normal form',all(b))

wdp=rot(nu).*wd;
wcp=rot(nu).*wc;

[wu,wv]=transconv(wd,wc,'dc2uv');
[wu1,wv1]=transconv(wdp,wcp,'dc2uv');

wu2=cos(nu).*wu+sqrt(-1)*sin(nu).*conj(wv);
wv2=cos(nu).*wv-sqrt(-1)*sin(nu).*conj(wu);
b=aresame(wu1,wu2,tol)&aresame(wv1,wv2,tol);
reporttest('d/c phase lags',all(b))
%\******************************************************
end


