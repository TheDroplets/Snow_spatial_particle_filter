function[ssh]=trackfill(ssh,cutoff,nfill,niter)
% TRACKFILL  Despiking and filling for alongtrack satellite data.
%
%   X=TRACKFILL(X,CUTOFF,NFILL) where X is alongtrack satellite data,
%   removes point whose alongtrack second central difference magnitude
%   exceeds CUTOFF times the standard deviation of that quantity, and
%   then fills all bad data points by taking the average over NFILL 
%   points on either side.  
%
%   In taking the average, other bad points are not counted.  At least
%   one data point on each side is required for the point to be filled.
%
%   X is a three-dimensional matrix organized as
%
%       [alongtrack points] x [tracks] x [time]
%
%   and is assumed to have missing or bad data points flagged as NANs.
%
%   TRACKFILL(...,N) optionally iterates the filling algorithm N times.
%   Two times is recommeded.  N defaults to one.  
%
%   TRACKFILL(X,3,5,2) is the algorithm used by Lilly et al. 2003.
%
%   Usage:  x=trackfill(x,cutoff);
%           x=trackfill(x,cutoff,n);
%
%   See also: PF_EXTRACT, PF_PARAMS, TRACK2GRID
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005 J.M. Lilly --- type 'help jlab_license' for details


%/*************************************************
disp('Looking for spikes of three-point difference ...')
xx=ssh-vshift(ssh,1,1)/2;
xx=xx-vshift(ssh,-1,1)/2;
xx=abs(xx);
sig=std(nonnan(xx(:)));
ii=find(xx>cutoff*sig);
clear xx

disp(['Found ' int2str(length(ii)) ' spiky points out of ' int2str(length(ssh(:))) '.']) 
ssh(ii)=nan;

disp('Removing isolated good points (in between two nans) ...')
index=find(isnan(ssh));
index=index(1:end-1);

sizessh=size(ssh);
bool1=zeros(sizessh);
bool2=zeros(sizessh);
bool1(index+1)=1;
bool2(index-1)=1;
bool1=bool1.*bool2;  %true if both next and previous data points are bad
bool2=1+0*bool2;     %good data=1
bool2(index)=0;      %bad data =0
bool1=bool1.*bool2;  %true if this data point is good but flanking are bad

clear bool2
index2=find(bool1);
ssh(index2)=nan;
disp(['Found ' int2str(length(index2)) ' isolated good points out of ' int2str(length(ssh(:))) '.']) 
%\*************************************************

disp(['Filling with boxcar mean over at most ' int2str(2*nfill+1) ' points ...'])

for i=1:niter
sshold=ssh;
disp(['Iteration number ' int2str(i) ' ...'])

%/*************************************************
vswap(ssh,nan,0);
[nssh1,nssh2]=vzeros(size(ssh));
 
h=ones(nfill*2+1,1);
h(nfill+1,1)=0; %Do not count the current point              

h1=h;
h1(1:nfill)=0;
 
h2=h;
h2(nfill+2:end)=0;      

for k=1:size(ssh,3)
    temp=squeeze(ssh(:,:,k));
    ssh(:,:,k)=vfilt(temp,h,1)*sum(h); %VFILT now normalizes
 
    index=find(temp~=0);
    if ~isempty(index)
       temp(index)=1;
    end
    nssh1(:,:,k)=vfilt(temp,h1,1)*sum(h1);
    nssh2(:,:,k)=vfilt(temp,h2,1)*sum(h2);
end
warning off
ssh=ssh./(nssh1+nssh2); %wow this is clever
warning on 

index=find(nssh1<=1|nssh2<=1);	%need at least two data points, one one each side
ssh(index)=0;
vswap(ssh,0,nan);
index=find(isnan(sshold)&~isnan(ssh));
sshold(index)=ssh(index);
ssh=sshold;

disp(['Filled ' int2str(length(index)) ' points.'])

%\*************************************************
end
