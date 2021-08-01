function h=hermfun(t,j)
%HERMFUN  Orthonormal Hermite functions.
%
%   H=HERMFUN(T,N) returns the N lowest-order orthonormal Hermite 
%   functions at times specified by the column vector T. 
%
%   HERMFUN uses the expression of Simons et al. 2003.
%  
%   Note that H(:,1) is the 'zeroth' order Hermite function, etc.
%  
%   See also HERMEIG and HERMPOLY.
%
%   'hermfun --f' generates a sample figure; compare with Figure 2 of
%   Simons, van der Hilst, and Zuber (2003), JGR 108 B5.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2004 F. Rekibi and J. M. Lilly
%                         --- type 'help jlab_license' for details

if strcmp(t,'--f')
  hermfun_fig;return
end



if size(t,1)==1
    t=t';
end

H=hermpoly(t,j);

E=exp(-t.^2/2)*ones(1,j);
HE=H.*E;

h=zeros(length(t),j);
for k=1:j
	h(:,k)=HE(:,k)/(pi^(1/4)*sqrt((2^(k-1))*(factorial(k-1))));
end


% Normalisation

for i=1:size(h,2)
	h(:,i)=h(:,i)/max(abs(h(:,i)));
end


function[]=hermfun_fig

t=[-5:0.1:5.1];
R=[2:4];

tnorm=(t-t(1))/(t(length(t))-t(1));

% Trace des 5 premieres fonctions de Hermite ortho

subplot 211
j=5;
h=hermfun(t,j);
plot(tnorm,h);  
linestyle r b g m-- y--
legend('j=0','j=1','j=2','j=3','j=4',-1);
xlabel('Normalized window length')
ylabel('Normalized value')

% Trace des valeurs propres de la fonction de Hermite

j=15;
l = hermeig(R,j);

subplot 223
T=[0:j-1];
plot(T,l)
legend('R=2','R=3','R=4',0);
xlabel('Number');
ylabel('lambda R(j)')

% Trace de l'energie

subplot 224

U=zeros(length(t),length(R));
for i=1:length(R)
  htemp=hermfun(t,R(i).^2).^2;
  eigtemp=hermeig(R(i),R(i).^2);
  U(:,i)=frac(1,R(i).^2).*(htemp*eigtemp);
end
plot(tnorm,U);  
linestyle r b g m-- y--
xlabel('Normalized window length')
ylabel('Energy');

% subplot 325
% j=6;
% plot(h(:,size(h,2)));
% axis tight
% title('6 eme fct de Hermite');
% 
% subplot 326
% j=7;
% h=hermfun(t,j);
% W = WignerDist(h(:,end));

