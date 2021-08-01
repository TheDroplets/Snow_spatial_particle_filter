function[ii,jj,num,Tx,Cx,Sx]=modmax(i1,i2,i3,i4,i5)
%MODMAX  Locates the modulus maxima of a wavelet transform.  
%
%   [IM,JM,NM,YM]=MODMAX(Y,YCUTOFF,LCUTOFF), where Y is a matrix of a
%   wavelet transform modulus, locates the "modulus maxima lines" of Y
%   having a peak value of at least YCUTOFF and a length across scales
%   of at least LCUTOFF.  The rows of Y should correspond to time and
%   the columns to scale, with the smallest scale in the first column.
%
%   All output variables have as many rows as there are columns in Y
%   and as many columns as there are discrete ridges.  The ridges are
%   located at (IM,JM),the modulus maxima number (ordered in time) is
%   NM, and the magnitude of Y along the ridge is YM.
%
%   Other functions along the ridges can be pulled out using
%   [IM,JM,NM,YM,CM,SM]=MODMAX(Y,C,S,YCUTOFF,LCUTOFF).
%
%   This uses code from the WaveLab package for the basic ridge
%   finding computation. 
%  
%   'modmax --f' generates a sample figure, which is eseensitally an
%   expanded view of Figure 3.12a,d of Lilly (2002) [PhD thesis].
%
%   See also MODMAXPEAKS.
%  
%   Usage:  [im,jm,nm,ym]=modmax(y,ycutoff,lcutoff);
%           [im,jm,nm,ym,cm,sm]=modmax(y,c,s,ycutoff,lcutoff);  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1999, 2004 J.M. Lilly --- type 'help jlab_license' for details        

  
if strcmp(i1,'--f')
  modmax_fig; return
end

T=[];S=[];C=[];

Lcutoff=0;
Tcutoff=0;
na=nargin;

nmats=0;
for i=1:nargin
    if length(i1)>1
       if isempty(T)
	  T=i1;
       elseif isempty(C)
	  C=i1;
       elseif isempty(S)
	  S=i1;
       end
       nmats=nmats+1;
    else
       if Tcutoff==0
	  Tcutoff=i1; 
       elseif Lcutoff==0
	  Lcutoff=i1; 
       end
    end
    eval(iadvance(na))
end
       
T=fliplr(T);
maxmap=WTMM(T);  %size(T) binary matrix, yes/no for modulus maximum
[skellist,skelptr,skellen] = BuildSkelMapFast(maxmap);

%get amplitudes etc along ridges
ii=[];jj=[];num=[];
for i=1:length(skellen)
    ii=[ii skellist(skelptr(i)+1:2:skelptr(i)+2*skellen(i)-1)];
    jj=[jj skellist(skelptr(i):2:skelptr(i)+2*skellen(i)-2)];
    num=[num i+zeros(1,skellen(i))];
end
ii=ii';jj=jj';num=num';

%Prevent long stretches from WaveLab algorithm
index=find(diff(ii)>size(T,1)/2);
for i=1:length(index)
  if index(i)+1<length(num)
     num(index(i)+1:end)=num(index(i)+1:end)+1;
  end
end


%unflip
jj=size(T,2)-jj+1;
ii=flipud(ii);num=flipud(num);jj=flipud(jj);
T=fliplr(T);

index=sub2ind(size(T),ii,jj);

%put the list of locations into matrices
Tx=T(index);
[num,ii,jj,Tx]=colbreaks(num,ii,jj,Tx);
[num,ii,jj,Tx]=col2mat(num,ii,jj,Tx);
[xx,is]=sort(ii(1,:));
[ii,jj,Tx]=vindex(ii,jj,Tx,is,2);


%do a little rearranging
num=vadd(0*ii,[1:size(ii,2)],1);

if nargin>nmats
   for i=1:size(Tx,2)
       maxT(i)=max(Tx(:,i));
       maxL(i)=length(find(~isnan(Tx(:,i))));
   end
   index=find(maxL>Lcutoff&maxT>Tcutoff);
   if ~isempty(index)
      [ii,jj]=vindex(ii,jj,index,2);
      num=vadd(0*ii,[1:size(ii,1)]',2);
      Tx=vindex(Tx,index,2);
   else
      ii=[];jj=[];num=[];
   end
end

index=find(isfinite(ii));

if nmats>=2
   Cx=0*Tx;
   Cx(index)=C(sub2ind(size(C),ii(index),jj(index)));
end
if nmats==3
   Sx=0*Tx;
   Sx(index)=S(sub2ind(size(S),ii(index),jj(index)));
end



function[evalme]=iadvance(na,n)

if nargin==1
        n=2;
end
evalme=[];
for j=n:na
        evalme=[evalme 'i',int2str(j-1),'=i',int2str(j),';'];
end
evalme=[evalme,'na=na-1;'];

function[]=modmax_fig

[x,t]=testseries(5);
[w,lambda,wf,lw]=slepwave(1.5,2,1,30,.005/6,.05); 
w=bandnorm(w,wf);

u=real(x);
v=imag(x);

fu=vfilt(u,24,1);
fv=vfilt(v,24,1);

U=wavetrans(u,w);
V=wavetrans(v,w);
su=abs(U).^2;
sv=abs(V).^2;
sa=su+sv;

p=1./wf'; 
[ii,jj,num,tr]=modmax(su+sv,1,1);

figure
h=wavespecplot(t,fu+sqrt(-1)*fv,p,su+sv,1/4);
axes(h(2))
hold on

tii=ii;
pjj=jj;
index=find(~isnan(ii));
tii(index)=t(ii(index));
pjj(index)=p(jj(index));

plot(tii,pjj,'.')
