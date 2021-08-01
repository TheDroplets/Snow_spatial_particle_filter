function[ssh,lat,lon,mss,at,num]=pf_extract(region,lat,lon,mss,nrec,num,sshfile,Lcutoff)
%PF_EXTRACT  Extract alongtrack Pathfinder data from specified region.
% 
%   [SSH,LAT,LON,MSS,ATD,NUM]=PF_EXTRACT(REGION,LAT,LON,MSS,NREC,NUM,FILE) 
%   extracts data specified by REGION from the Pathfinder sea surface height 
%   file FILE.  REGION is an array [LAT_S LAT_N LON_E LON_W] specifying the
%   limits of the domain.  All other input variables are exactly as described 
%   in PF_PARAMS.  FILE must specify both the complete filename including
%   the path.
%  
%   The output sizes are described in terms of three numbers,
%     
%        M     Number of data points in longest track in region
%        N     Number of tracks in region
%        K     Number of cycles
%
%    and the output variables themselves are
%   
%      SSH    M x N x K  Alongtrack sea surface height anomaly (centimeters)
%      LON    M x N      Alongtrack latitude
%      LON    M x N      Alongtrack longitude,  180 > LON >= -180
%      MSS    M x N      Mean alongtrack sea surface height in centimeters
%      ATD    M x N      Alongtrack distance (west to east)       
%      NUM    N x K      Time in DATENUM format at beginning of each orbit.     
%
%   The tracks are sorted with  all ascending tracks coming before all 
%   descending tracks, and are sorted within each group in order of 
%   increasing latitude of the easternmost data point in the region.  All 
%   tracks are oriented with longitude increasing.
%
%   Note that the time NUM is the time of the beginning of the orbit along
%   each track, definded as the last ascending equator crossing.
%
%   By default, tracks with a length of less than 20 points are excluded.
%   PF_EXTRACT(..., L) uses alternatively uses L points for the cutoff. 
%
%   Usage:
%
%   [ssh,lat,lon,mss,atd,num]=pf_extract(region,lat,lon,mss,nrec,num,sshfile);
%
%   See also PF_PARAMS.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005 J.M. Lilly --- type 'help jlab_license' for details

if nargin==7
   Lcutoff=20;
end

lata=region(1);
latb=region(2);
lona=region(3);
lonb=region(4);

[M,N]=size(nrec);
vindex(lat,lon,mss,1:M,1);

j=0;
clear nreci index ti
for i=1:N
    if lona>lonb
      ii=find(lat(:,i)>lata&lat(:,i)<latb&(lon(:,i)>lona|lon(:,i)<lonb)); 
    else
      ii=find(lat(:,i)>lata&lat(:,i)<latb&(lon(:,i)>lona&lon(:,i)<lonb)); 
    end	 
	 
    if ~isempty(ii)&length(ii)>0
       j=j+1;
       index{j}=ii;
       ni(j,1)=length(ii);
       ti(j,1)=i;
       nreci{j}=nrec(ii,i);  %record numbers of time series 
    end                      %along jth track inside box
end

clear lati loni mssi numi
for i=1:length(ti)
    lati{i}=[lat(index{i},ti(i));nan];
    loni{i}=[lon(index{i},ti(i));nan];
    mssi{i}=[mss(index{i},ti(i));nan];
end

num=num(:,ti);
vcellcat(lati,loni,mssi);
col2mat(lati,loni,mssi);  

index=find(loni>180);
loni(index)=loni(index)-360;

K=size(num,1);
%now, load all these records
clear sshi
for j=1:length(nreci)	
    %loop over tracks inside box
    disp(['Loading track number ' num2str(j) ' of ' num2str(length(nreci)) '.'])
    if ~isempty(nreci{j})   
       for jj=1:length(nreci{j});%loop over locations along each track
	     if nreci{j}(jj)~=0  
          fid=fopen(sshfile,'r','ieee-be');
	      %pos(j)=[4+K*2]*(nreci{j}(jj)-1);
	      fseek(fid,[4+K*2]*(nreci{j}(jj)-1),-1);
	      ssh=fread(fid,[2+K,1],'int16');  %each time series is K+2
	      fclose(fid);                     %double-bytes long
         else
	      ssh=nan*ones(K+2,1);
         end
	     sshi{j}(:,jj)=ssh(3:end);
       end
    end
end
    
for i=1:length(sshi)
    index=find(sshi{i}==32767);
    sshi{i}(index)=nan;
end
%\*************************************************************** 

%/*************************************************************** 
%reorganize ssh

%check lengths
for i=1:size(lati,2)
    L1(i)=min(find(isnan(lati(:,i))))-1;
    L2(i)=size(sshi{i},2);
end
%so far so good

%find ascending vs descending 
dl=diff(lati(1:2,:));
ai=find(dl>0);
di=find(dl<0);

%now sort vs. location
mlat=vmean(lati(:,ai),1);
[mm,ii]=sort(mlat);
ai=ai(ii);

mlat=vmean(lati(:,di),1);
[mm,ii]=sort(mlat);
di=fliplr(di(ii));

vindex(lati,loni,mssi,num,[ai di],2);
sshi=sshi([ai di]);
%\*************************************************************** 

%/*************************************************************** 
%convert ssh to a 3-d matrix organization
clear L
for i=1:length(sshi)
    L(i)=size(sshi{i},2);
end

%index X track X time
ssh=nan*ones(max(L),length(sshi),size(sshi{1},1));
vzeros(lat,lon,mss,max(L),length(sshi),nan);
for i=1:length(sshi)
    ssh(1:L(i),i,:)=sshi{i}';
end

lat=lati(1:end-1,:);
lon=loni(1:end-1,:);
mss=mssi(1:end-1,:);

vindex(lat,lon,mss,ssh,num,find(L>Lcutoff),2);

clear at
for i=1:size(lat,2)
    at(:,i)=sectdist(lat(:,i)',lon(:,i)')';
end

ssh=ssh/10;