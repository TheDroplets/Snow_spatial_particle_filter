function[struct]=ridgeinterp(struct)
% RIDGEINTERP  Interpolate quantity values onto ridge locations.
%
%   STRUCTI=RIDGEINTERP(STRUCT) where STRUCT is a ridge structure as
%   output by RIDGEWALK, returns a new structure STRUCTI in which 
%   WR and FR are linearly interpolated between frequencies. 
%
%   While the transform W is specifed only at discrete frequencies,
%   RIDGEINTERP linearly interpolates transform values between discrete 
%   frequencies to find a more precise value of the transform along 
%   the ridges than simply looking up the values of W at rows IR and 
%   columns JR.  
%
%   RIDGEINTERP uses the transform frequency of the ridge structure,
%   STRUCT.F, as the basis for the interpolation.
%
%   See also RIDGEWALK, RIDGEMAP.
%
%   Usage:  struct=ridgeinterp(struct);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    


use struct

wr_new=nan*wr;
fr_new=nan*fr;

f=2*pi*dt*f;
f2=transfreq(dt,w);

for k=minmin(kr):maxmax(kr)
  index=find(kr==k|isnan(kr));
  if ~isempty(index)
     args{1}=w(:,:,k);
     args{2}=f2(:,:,k);
     outargs=ridgeinterp1(ir(index),jr(index),fs,w(:,:,k),f(:,:,k),args);
     wr_new(index)=outargs{1};
     fr_new(index)=outargs{2};
  end
end

struct.wr=wr_new;
struct.fr=fr_new;

function[outargs]=ridgeinterp1(ir,jr,fs,x,xd,args)

indexr=sub2ind(size(x),ir,jr);
indexrp=sub2ind(size(x),ir,jr+1);
indexrn=sub2ind(size(x),ir,jr-1);

%Rate of change of phase along the transform
dphi=xd-osum(zeros(size(xd(:,1))),2*pi*fs(:));

%Rate of change of phase along the ridges, and at one scale up and down
index=find(~isnan(ir));
dr=0*ir;dr(index)=dphi(nonnan(indexr));
drp=0*ir;drp(index)=dphi(nonnan(indexrp));
drn=0*ir;drn(index)=dphi(nonnan(indexrn));

%Indices into location of point bracketing exact ridge---
%   do we look one scale up or one scale down?
indexp=find((dr>0&drp<0&drn>=0)|(dr<0&drn<0&drp>=0));
indexn=find((dr>0&drn<0&drp>=0)|(dr<0&drp<0&drn>=0));

%Note that this excludes the few points which are at extrema of the local frequency 
%    i.e.:    index=find(drp<0&drn<0); 

%Find the distance between the true ridge and the approximate ridge
rb=0*ir;
rb(indexp)=drp(indexp);
rb(indexn)=drn(indexn);
dy=abs(frac(dr,dr-rb));

%Extrema points should have dy=0 but start out with dy=1
dy=vswap(dy,1,0); 

%xr=applyridgeinterp1(x,ir,index,indexp,indexn,indexr,indexrp,indexrn,dy); 
%fr=abs(vdiff(unwrap(angle(xr)))/2/pi);
%fr=ridgeinterp_despike(jr,fr);

for i=1:length(args)
   outargs{i}=applyridgeinterp1(args{i},ir,index,indexp,indexn,indexr,indexrp,indexrn,dy);
end
  
function[x]=ridgeinterp_despike(jr,x);
%Frequency tends to spike when jr is discontinuous 
index=find(isnan(x));
indexjumps=find(vdiff(jr)~=0);
indexjumps=find(vdiff(jr)~=0|vshift(vdiff(jr),1,1)~=0);
if ~isempty(indexjumps)
    x(indexjumps)=nan;
    x=fillbad(x,nan);
end  
vswap(x,nan,inf);
index=find(isnan(jr));
if ~isempty(index)
    x(index)=nan;
end 


function[xr]=applyridgeinterp1(x,ir,index,indexp,indexn,indexr,indexrp,indexrn,dy)
%Transform values along the three parallel sets of curves
xro=0*ir;xro(index)=x(nonnan(indexr));
xrp=0*ir;xrp(index)=x(nonnan(indexrp));
xrn=0*ir;xrn(index)=x(nonnan(indexrn));
%plot(abs(xro)),hold on,plot(abs(xrp),'g'),plot(abs(xrn),'r')

%The value for the bracketing curve we call "b" 
b=0*ir;
b(indexp)=xrp(indexp);
b(indexn)=xrn(indexn);

%Linearly interpolate between the approximate ridge and the bracketing curve 
xr=xro.*(1-dy)+b.*dy;
%figure,plot(dy)

% [ir,jr]=ind2sub(size(x),indexr);
% for i=1:length(jr)
%   xr(i)=interp1([1:size(x,2)]',conj(x(i,:))',jr(i),'spline');
% end
