function[lat,lon,mss,nrec,num]=pf_params(dirname,satname)
%PF_PARAMS  Load satellite parameters from Pathfinder format file.
%
%   [LAT,LON,MSS,NREC,NUM]=PF_PARAMS(DIR,SAT) where DIR is a directory 
%   name and SAT is a satellite name, extracts important information from 
%   Pathfinder format satellite files.  
%
%   The output sizes are described in terms of three numbers,
%     
%        M     Number of data points within each revolution
%        N     Number of orbits per repeat cycle 
%        K     Number of repeat cycles
%
%    and the output variables themselves are
%   
%      LAT    M x N    Track latitude 
%      LON    M x N    Track longitude  360 > LON >= 0
%      MSS    M x N    Mean alongtrack sea surface height in centimeters
%      NREC   M x N    Record number desribing data location in 'ssh.dat'
%      NUM    K x N    Time in DATENUM format at beginning of each orbit.        
%
%   Valid choices for SATNAME are
%
%      'topex' 'geosat' 'gfo' 'ers1c' 'ers1g' 'ers2' .
%
%   The (now defunct) Pathfinder program provided reprocessed alongtrack sea 
%   surface height data in a uniform format for TOPEX / Poseidon, ERS-2, 
%   ERS-1, Geosat, and Geosat follow-on (GFO).  Descriptions of the data may 
%   be found at 
%
%          http://iliad.gsfc.nasa.gov/opf/descriptions.html .
%  
%   The Pathfinder datasets are available at
% 
%         http://podaac-www.jpl.nasa.gov .
%
%   The latest versions of these datasets have the following properties:
%
%   *******************************************************************
%   Name  | Vers | Start date | End date   | Period  | Cycles | Orbits
%         |      |            |            | (days)  |        | /cycle
%   -------------------------------------------------------------------
%   TOPEX   v9.2   Sep 23 1992  Aug 11 2002   9.92     364      254
%   Geosat  v4     Nov 08 1986  Sep 30 1989  17.05      62      244 
%   GFO     v2-A   Jan 01 2000  Mar 03 2003  17.05      79      244
%   ERS-1C  v1-A   Apr 14 1992  Dec 20 1993  35.00      18      501 
%   ERS-1G  v1-A   Mar 24 1995  Jun 02 1996  35.00      13      501 
%   ERS-2   v2-A   Apr 29 1995  Aug 30 2003  35.00      78      501 
%   *******************************************************************
%
%   In the above, "A" means the dataset is available in a version which has
%   been re-adjusted for orbital errors.
%
%   For extracting the actual data (which has another dimension, time), use 
%   PF_EXTRACT.
%
%   Usage: [lat,lon,mss,nrec,num]=pf_params(dirname,satname);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005 J.M. Lilly --- type 'help jlab_license' for details
 

%JML note: start dates for ERS-2G is from  http://iliad.gsfc.nasa.gov/opf/descriptions.html
%          the date at http://podaac-www.jpl.nasa.gov appears to be wrong

%JML note: for later TOPEX and also Jason data, there is another
%          alongtrack format available at the podacc site: #132 and #189

dirname=[dirname '/'];

if strcmp(satname,'ers2')|strcmp(satname,'ers1c')|strcmp(satname,'ers1g')
  N=501;
elseif strcmp(satname,'topex')
  N=127;
elseif strcmp(satname,'geosat')|strcmp(satname,'gfo')
  N=244;
else 
  error('Satellite name not supported.')
end

fid=fopen([dirname 'mss.dat'],'r','ieee-be');
mss=fread(fid,'int16');

fid=fopen([dirname 'directry.dat'],'r','ieee-be');
nrec=fread(fid,'int32');

M=length(mss)/N;
mss=reshape(mss,M,N);
index=find(mss>2e4);
mss(index)=nan;
mss=mss/1000;

%sort out time
fid=fopen([dirname 'time.dat'],'r','ieee-be');
time=fread(fid,[inf],'uint32')';

%some values are way out of range
index=find(time>1.5e9);
time(index)=nan;

if strcmp(satname,'topex')
  time=reshape(time,5,length(time)/5)';
elseif strcmp(satname(1:3),'ers')|strcmp(satname,'gfo')|strcmp(satname,'geosat')
  time=reshape(time,3,length(time)/3)';
end

t1=time(:,1);
num=mjd2num(t1);

sec=time(:,2)/1000/3600/24; %This is seconds from midnight *1000
num=num+sec;

num=reshape(num,length(num)/N,N);

fid=fopen([dirname 'reforb.dat'],'r','ieee-be');
reforb=fread(fid,'int32');

reforb=reforb/1e6;

if length(mss(:))==6800*127   %TOPEX is a little funny
  reforb=reshape(reforb,M/4,length(reforb)/(M/4));
  lat=reforb(:,[1:2:end])/1e6;
  lon=reforb(:,[2:2:end])/1e6;
  lat=reshape(lat,M,length(lat(:))/M);
  lon=reshape(lon,M,length(lon(:))/M); 
  nrec=reshape(nrec,M-50,N);
else
  reforb=reshape(reforb,M,length(reforb)/M);
  lat=reforb(:,[1:2:end])/1e6;
  lon=reforb(:,[2:2:end])/1e6;  
  nrec=reshape(nrec,M,N);
end

lat=lat*1e6;
lon=lon*1e6;

%That was vastly easier than it could otherwise have been

index=find(lon>180);
if ~isempty(index)
    lon(index)=lon(index)-360;
end

