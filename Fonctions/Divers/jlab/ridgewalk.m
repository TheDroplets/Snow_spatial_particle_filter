function[struct]=ridgewalk(varargin)
% RIDGEWALK  Extract wavelet transform ridges.
%  
%   STRUCT=RIDGEWALK(W,FS,CHI) where W is a wavelet transform matrix at
%   *cyclic* frequecies FS, returns the wavelet transform ridges having 
%   amplitudes |W|>CHI, organized as a ridge structure STURCT.  Note W 
%   must be a complex-valued wavelet transform, not a transform modulus.
%   The frequency array FS assumes a unit sample rate.
%
%   The columns of W correspond to different frequencies, specified by
%   the array F, at which the wavelet transform was performed.  The
%   frequencies F are considered to be always positive.  The third 
%   dimension of WR, if it has greater than unit length, corresponds to
%   the different elements of a multi-component time series.  
% 
%   STRUCT has the following format:
%
%       STRUCT.W      Original transform array
%       STRUCT.F      *Cyclic* wavelet transform frequency array
%       STRUCT.FS     Array of *cyclic* frequencies at transform scales
%       STRUCT.DT     Sample rate (default=1, see below)
%       STRUCT.IR     Ridge indices into rows of W (time) 
%       STRUCT.JR     Ridge indices into columns of W (scale)
%       STRUCT.KR     Ridge indices into pages of W (time series number)
%       STRUCT.WR     Transform values along ridges
%       STRUCT.FR     *Cyclic* transform frequency values along ridges
%  
%   The five ridge variables IR, JR, KR, WR, and FR are matrices of the 
%   same size, and contain one column per ridge.  Since the lengths of 
%   the ridges varies, missing values are filled with NANs.  
%
%   See TRANSFREQ for the computation of the F, the transform frequency
%   array.  The "ridge frequencies" FR are the values of F evaluated
%   along the ridges.
%
%   RIDGEWALK uses a phase derivative definition to find the ridges.
%   ___________________________________________________________________
%
%   Sample rate
%
%   STRUCT=RIDGEWALK(DT,...) uses timestep DT to compute the transform
%   frequency array F and the ridge frequencies FR.  The default value of 
%   DT is unity.  
%
%   Note that the scale frequecies FS always assume a unit sample rate.
%   ___________________________________________________________________
%
%   Pruning
%
%   STRUCT=RIDGEWALK(W,FS,CHI,N) removes all ridges of less than N
%   points in total length.  The default value of N is one. N may be a
%   scalar or an array of length FS.
%   ___________________________________________________________________
%
%   See also WAVETRANS, TRANSFREQ, RIDGEINTERP, RIDGEMAP.
%
%   Usage: struct=ridgewalk(w,fs,chi);
%          struct=ridgewalk(w,fs,chi,n);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        

%   Depricated requirement:
%   If W  an anti-analytic wavelet transform, i.e. supported on only
%   negative frequencies, then FS must be negative.
   
%   Depricated feature:
%
%   A unique identification number is assigned to each ridge.  The
%   ridge number of each ridge point is containing in the array NR.
%  
%   [...]=RIDGEWALK(W,FS,CHI,N,NS) removes all groups of ridge points
%   fewer spanning fewer than NS ridge points at a fixed scale.  This
%   is useful for removing rapidly chirping or noisy features.  The
%   default value of NS is 1.
%          [ir,jr,yr,nr]=ridgewalk(y,fs,chi,n,ns);

  
%/********************************************************
%Sorting out input arguments

dt=1;
if length(varargin{1})==1
    dt=varargin{1};
    varargin=varargin(2:end);
end

w=varargin{1};
fs=varargin{2};
a=varargin{3};
varargin=varargin(4:end);
 
N=1; 
if length(varargin)>=1
    if isscal(varargin{1})|length(varargin{1}(:))==size(w,2)
      N=varargin{1};
      varargin=varargin(2:end);
    end
end
%\********************************************************

fw=2*pi*transfreq(w);

%/***********************************************************
if size(w,3)==1
   [ii,jj,wr,id,err]=ridgewalk1(w,fw,fs,a,N);
    kk=1+0*ii;
else
   lastid=0; 
   for k=1:size(w,3)
%     size(w),  size(fs),  size(N),  size(a)
      disp(['RIDGEWALK for transform #' int2str(k)]) 
      [iik,jjk,wrk,idk,errk]=ridgewalk1(w(:,:,k),fw(:,:,k),fs,a,N);

      kkk=k+0*iik;
      if ~isempty(idk),
	  idk=idk+lastid;	
         lastid=maxmax(idk);
      end
  
      ii{k}=iik;jj{k}=jjk;wr{k}=wrk;id{k}=idk;err{k}=errk;kk{k}=kkk;
   end
   vcellcat(ii,jj,kk,wr,id,err); 
end
%\********************************************************


%/***********************************************************
%Frequency again
fw=fw/2/pi/dt;
fr=0*ii;
index=sub2ind(size(w),nonnan(ii),nonnan(jj),nonnan(kk));
fr(find(~isnan(ii)))=fw(index);
%\***********************************************************

[id,ii,jj,kk,wr,fr,err]=colbreaks(id,ii,jj,kk,wr,fr,err);
[id,ii,jj,kk,wr,fr,err]=col2mat(id,ii,jj,kk,wr,fr,err);

if allall(isnan(ii));
    id=[];ii=[];jj=[];kk=[];wr=[];fr=[];err=[];
end


struct.w=w;
struct.f=fw;
struct.fs=fs;
struct.dt=dt;
struct.ir=ii;
struct.jr=jj;
struct.kr=kk;
struct.wr=wr;
struct.fr=fr;
%struct.err=err;

function[ii,jj,xr,id,err]=ridgewalk1(x,xd,fs,a,N)

fs=fs(:);
err=abs(xd-osum(zeros(size(xd(:,1))),2*pi*fs(:)));

% tic 
% fsmat=osum(zeros(size(xd(:,1))),fs);
% bool1=xd>=2*pi*fsmat;
% bool2=xd<2*pi*fsmat;
% %bool=(vshift(bool1,1,2).*vshift(bool2,-1,2))|(vshift(bool1,-1,2).*vshift(bool2,1,2));
% bool=(vshift(bool1,1,2).*vshift(bool2,-1,2));  %Ascending ridges
% %boold=(vshift(bool1,-1,2).*vshift(bool2,1,2));  %Descending ridges
% bool(:,[1 end])=0;
% toc
% [iid,jjd]=find(boold);[iia,jja]=find(boola);
% figure,plot(iid,jjd,'b.'),hold on,plot(iia,jja,'r.')
% This algorithm is the same as the next one, but is about 10x slower

%Ascending ridges only
bool=zeros(size(x));
for i=2:size(x,2)-1
    index=find((xd(:,i-1)<2*pi*fs(i-1)&(xd(:,i+1)>=2*pi*fs(i+1))));
    if ~isempty(index)
      bool(index,i)=1;
    end
end

%Remove NANs
index=find(isnan(x));
if ~isempty(index)
  bool(index)=0;
end

if length(find(bool))==0
  error('No phase points found.')
end

%Remove those less than cutoff amplitude
index=find(abs(x)<a);
if ~isempty(index)
  bool(index)=0;
end

if length(find(bool))==0
  error('No phase points found.')
end

%Remove those which are not local minima
bool2=(err<vshift(err,1,2))&(err<=vshift(err,-1,2));
bool2(:,[1 end])=0;
bool=bool.*bool2;

%[ii,jj]=find(bool);
%figure,plot(ii,jj,'g.')


%Remove those in short segments at each scale
%[ii,jj,indexridge,id]=purge_short_segments(bool,1);
[ii,jj,indexridge,id]=purge_short_segments(bool,0);
xr=x(indexridge);

[ii,jj,indexridge,id]=form_ridge_chains(ii,jj,indexridge,id,xr);
if ~isempty(ii)
   [id,ii,jj,indexridge]=longridges(N,id,ii,jj,indexridge);
end
if ~isempty(indexridge)
  xr=x(indexridge);
  err=err(indexridge);
else
  xr=[];
  err=[];
end
 
%/********************************************************
function[ii,jj,indexridge,id]=purge_short_segments(bool,N);
%Remove groups of less than N in a row at a certain scale

indexridge=find(bool);
[ii,jj]=ind2sub(size(bool),indexridge);

id=blocknum(ii,1);  %Unique ID of a chain at each frequency
len=blocklen(id);   %Length of each block

%figure,plot(jj,id)
%figure,plot(ii,jj)
index=find(len>=N);
vindex(indexridge,ii,jj,index,1);
%END purge_short_segments
%\********************************************************

%/********************************************************
function[ii,jj,indexridge,id]=form_ridge_chains(ii,jj,indexridge,id,xr)
%Connect ridges into chains

[id,a,b]=blocknum(id);
%[id(a(1:end-1)) id(b(1:end-1)+1)]
%plot(ii,id),hold on,plot(ii,id,'.')
Nmax=5000;
if length(a)>Nmax
  error('Too many independent chains; try increasing NS or CHI.')
end

%Difference between start times and end times
ta=ii(a);
tb=ii(b);
dt=osum(-tb,ta);

%Difference between scales
jja=jj(a);
jjb=jj(b);
djj=osum(-jjb,jja);

bool1=(dt==1);       %True for contiguous in time
%bool2=(abs(djj)<1); %True for small frequency jumps
bool2=(abs(djj)<=2); %True for small frequency jumps
bool=(bool1&bool2);

%figure,plot(bool),size(bool)
%figure,plot(diag(bool),'r*')

%/********************************************************
%Only associate one head to one tail
%If two have same small freqeuncy jump, associate whichever has closer amplitude

%Difference between amplitudes
xra=abs(xr(a));
xrb=abs(xr(b));
dxr=abs(osum(-xrb,xra));
dxr(find(~bool))=inf;

index=find(sum(bool,1)>=1);
if ~isempty(index);
   for i=1:length(index)
       [temp,m]=min(dxr(:,index(i)));
       bool(:,index(i))=0;
       bool(m,index(i))=1;
   end
end
index=find(sum(bool,2)>=1);
if ~isempty(index);
   for i=1:length(index)
       [temp,m]=min(dxr(index(i),:));
       bool(index(i),:)=0;
       bool(index(i),m)=1;
   end
end
indexedge=find(bool);
[iiedge,jjedge]=ind2sub(size(bool),indexedge);

%figure,plot(sum(bool,2))
%figure,plot(sum(bool,1))
%figure,spy(bool)
%\********************************************************

for i=1:length(indexedge)
    indexa=find(id==id(b(iiedge(i))));
    if ~isempty(indexa)
       id(indexa)=id(a(jjedge(i)));
    end
end

%sort by time
[ii,sorter]=sort(ii);
vindex(jj,id,indexridge,sorter,1);

%sort by id
[id,sorter]=sort(id);
vindex(ii,jj,indexridge,sorter,1);
id=blocknum(id);
%figure,plot(ii,id),hold,plot(ii,id,'.')
%figure,plot(jj,id,'.')
%figure,plot(ii,id,'.')

% END form_ridge_chains
%\********************************************************


%/********************************************************
function[id,ii,jj,indexridge]=longridges(N,id,ii,jj,indexridge)
%LONGRIDGES  Removes ridge lines of length than a specified length
  
if length(N)==1
   N=N+0*[1:max(jj)];
end
N=N(:);

%Remove lines of less than a certain length
bdone=0;
while ~bdone
%  length(id)
  len=blocklen(id);

  index=find(len>=N(jj));
  if length(index)==length(id)
    bdone=1;
  else
    vindex(id,ii,jj,indexridge,index,1);
    if ~isempty(id)
       id=blocknum(ii,1);
    else
      bdone=1;
    end 
  end
end

%END longridges

