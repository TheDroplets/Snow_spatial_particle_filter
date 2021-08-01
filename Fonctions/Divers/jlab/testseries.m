function[o1,o2,o3,o4,o5,o6,o7,o8,o9]=testseries(i)
%TESTSERIES Various time series for testing signal processing code.
%
%   [X,T,XO]=TESTSERIES(I) returns a test series X, the time axis T,
%   and a smooth version XO based on the series number I, according to
%   the list below.  T and XO are only returned for some series, as
%   specified in the list.  X (and XO) may be complex. Most of the
%   synthetic time series are of the same length, 4096 points.
%   
%      1: Chirp signal with square wave [x,t,xo] 
%              (Lilly and Park 1994, Fig. 5) 
%      2: Two square waves [x,t,xo] {complex}
%              (Lilly 2002, Fig. 3.8)
%      3: Rankine vortex slice [x,t] {complex}
%              (Lilly et al. 2003, Fig. 12)
%      4: Model eddy pair slice [x,t] {complex}
%              (Lilly 2002, Fig. 3.11)
%      5: Bravo mooring 1996 [x,t,xo] {complex} **Not currently supported**
%              (Lilly 2002, Fig. 3.12)
%      6: Bravo mooring 1994 [x,t,xo] {complex}
%              (Lilly et al. 2003, Fig. 13)
%      7: Monopole SSH slice [x,t]             **Not currently supported**
%              (Lilly et al. 2003, Fig. 25a)
%      8: Dipole SSH slice [x,t]               **Not currently supported**
%              (Lilly et al. 2003, Fig. 25a)
%      9: Sample TOPEX line                    **Not currently supported**
%              (Lilly et al. 2003, Fig. 27)  
%     10: Circular chirp signal [x,t,xo,phi,om] {complex} 
%              (Lilly and Park 1994, Fig. 5) 
%
%   Usage:  x=testseries(n);  
%           [x,t]=testseries(n); 
%           [x,t,xo]=testseries(n);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        

  
switch i
  case 1
    [o1,o2,o3]=testseries_lillypark;
  case 2
    [o1,o2,o3]=testseries_twosquarewaves;
  case 3
    [o1,o2]=testseries_rankineslice;
  case 4
    [o1,o2]=testseries_eddypairslice;    
  case 5
    [o1,o2,o3]=testseries_bravoninetysix;
  case 6
    [o1,o2,o3]=testseries_bravoninetyfour;
  case 7
    [o1,o2]=testseries_monopoleslice;
  case 8
    [o1,o2]=testseries_dipoleslice;
  case 9
    [o1,o2]=testseries_topexline;
  case 10
    [o1,o2,o3,o4,o5]=testseries_lillypark_complex;
end


function[x,t,xo]=testseries_lillypark
t=[1:4096]';
om=zeros(size(t));
x2=0*om;
index=1000:3000;
om(index)=(t(index))*2/100000 - .019999;
x=sin(om.*t);
x2(index)=-sin((t(index)-1600)*2*pi*1/2800);
x=x.*x2;
x(3500:3515)=-1;
x(3516:3530)=1;
t=linspace(-100,100,length(x))';
xo=x2;

function[x,t,xo,phi,om]=testseries_lillypark_complex
t=linspace(1,256,4096)';

om=zeros(size(t));

%Envelope
xo=0*om;
index=1000:3000;
alpha=2*pi*1/2800*16;

xo(index)=-sin(alpha*(t(index)-t(1600)));

%Carrier wave
om(index)=2*pi*(2/100000/2/pi*16*16)*(t(index)-t(1001));
phi=om.*t;

%Adjust phase and envelope to make envelope positive
index=find(xo<0);
phi(index)=phi(index)+pi;
xo=abs(xo);
x=xo.*rot(phi);

%New time variable
t=t-mean(t);

%Adjust omega
om([1:1001 3001:end])=nan;

function[x,t,xo]=testseries_twosquarewaves
n=2^12;
up1=5*(exp(sqrt(-1)*[1:n]'*2*pi/24));
up=0*[1:n]';
up(2048-250:2048+250)=30;
up(800-25:800+50)=15+sqrt(-1)*10;
xo=up;
x=up+up1;
t=[1:length(x)]';t=t/24;
t=t-4096/4;t=t+940;
%set(gca,'xlim',[-1010 -900]+940)

function[x,t]=testseries_rankineslice
%eddy advected by 5cms mean flow, sliced midway between center and edge
r0=0+sqrt(-1)*0;
R=10*1000;
a=-10/100;
n=2^12;
dt=3600;
U0=5/100;
up=0*[1:n]';
r=eddyfieldmodel(r0,R,a,dt,n,1,U0+up);
rM=real(mean(r))+5*sqrt(-1)*1000;
u=eddyfieldmooring(r,R,a,rM,U0+up);
x=u*100-U0*100;
t=[1:length(x)]';t=t/97*10*cos(2*pi*45/360)*2;t=t-t(2050);

function[x,t]=testseries_eddypairslice
dt=3600;
a=[-10 -10]'/100;
R=[10 10]'*1000;
r0=[-20 20]'*1000;
n=2^12;
U1=5/100;
r1=eddyfieldmodel(r0,R,a,dt,n,round(n/2),U1);
Rm1=[3:4:18]*sqrt(-1)*1000+10*1000;
Rm1=fliplr(Rm1);
[cv,count,n1]=eddyfieldmooring(r1,R,a,Rm1,U1);
x=cv(:,2)*100;
t=[1:length(cv)]';
t=t/24;
t=t-mean(t);
%axis([ax -17 17]),

function[x,t,xo]=testseries_bravoninetysix
l_lsi
lsi=inst2meas(lsi);
x=lsi.cv{3}(:,2);
xo=vfilt(x,24,1);
num=yf2num(lsi.yearf{3});
t=num-yf2num(floor(lsi.yearf{3}(1)));
%This is at 1263 m -- thesis has both depths wrong on this fig.

function[x,t,xo]=testseries_bravoninetyfour
load bravo94
use bravo
x=bravo.rcm.cv(:,3);
xo=vfilt(x,24,1);
num=yf2num(bravo.rcm.yearf);
t=num-yf2num(floor(bravo.rcm.yearf(1)));
%t(2000) is end 


function[x,t]=testseries_monopoleslice
%1.5 layer monopole solution for maximum projection at lx=40
R=10*1000;
F1=1./(20*1000).^2;
F2=0;
r=[0:0.5:1600]*1000;
[v,psi,v2,psi2]=f_eddypsiuv1(r,R,F1,F2);
psi=[flipud(psi');psi'];
psi=-psi./max(abs(psi));

index=find(isnan(psi));
psi(index)=0;
x=10*psi./max(abs(psi));
t=([1:length(x)]-length(x)/2)/2;
to=round(length(t)/2);
index=to-4096/2:to+4096/2-1;
t=t(index);
x=x(index);


function[x,t]=testseries_dipoleslice
x=0;
y=flipud([-400:.06666:400]');
xg=[1+0*y]*x;
yg=y*[1+0*x];
cr=xg+sqrt(-1)*yg;

r=abs(cr);
ang=angle(cr);

a=40/7.5;
ci=[.01 .1 1 10 100];

fact=(7.5*1000).^3*(1.2*10^(-11));
x=fflierleddy(r,ang,a,25.8)*fact*100*sw_f(58.5)./9.81;%units of cm
t=[-r(1:6001);r(6002:end)]*7.5;
to=round(length(t)/2);
index=to-4096/2:to+4096/2-1;
t=t(index);
x=x(index);
