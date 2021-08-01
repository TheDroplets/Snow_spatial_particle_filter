function[mato]=track2grid(x,y,mat,xi,yi,N)
% TRACK2GRID  Interpolate alongtrack satellite data onto a grid.
%
%   ZI=TRACK2GRID(X,Y,Z,XI,YI) interpolate alongtrack satellite 
%   data in matrix Z, taken at east-west position X and north-
%   south position Y, onto a grid specified by XI and YI.
%  
%   Let's say there are a maxiumum of M alongtrack points, N 
%   different tracks, and K cycles.  Then X and Y are matrices   
%   of size M x N, and Z is M x N x K.  XI and YI are both 
%   vectors and the output ZI is LENGTH(YI) x LENGTH(XI) x K.
%  
%   TRACK2GRID interpolates by first linearly interpolates using
%   the ascending and descending tracks separately, and then 
%   averaging the result.  The tracks must be organized such 
%   that all ascending tracks precede all descending tracks, 
%   which is the format used by PF_EXTRACT.
%
%   ZI=TRACK2GRID(..., P) optionally, after gridding, filters the
%   data matrix with a P x P square Gaussian filter.  
% 
%   TRACK2GRID with no post-filtering is the algorithm used by 
%   Lilly et al. 2003.
%
%   Usage:  zi=track2grid(x,y,z,xi,yi);
%           zi=track2grid(x,y,z,xi,yi,P);
%
%   See also: PF_EXTRACT, PF_PARAMS, TRACKFILL
%   ______________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    
	
dl=y(1,:)-y(2,:);%separte ascending from descending
L=min(find(dl>0));

for i=1:size(mat,3)
     mat1=squeeze(mat(:,1:L-1,i));
     mat2=squeeze(mat(:,L:end,i));
     x1=x(:,1:L-1);y1=y(:,1:L-1);
     x2=x(:,L:end);y2=y(:,L:end);
     ii1=find(~isnan(mat1)&~isnan(x1)&~isnan(y1));
     ii2=find(~isnan(mat2)&~isnan(x2)&~isnan(y2));
     x1=x1(ii1);y1=y1(ii1);z1=mat1(ii1);
     x2=x2(ii2);y2=y2(ii2);z2=mat2(ii2);
     zi1=griddata(x1,y1,z1,xi,yi,'linear');
     zi2=griddata(x2,y2,z2,xi,yi,'linear');
     zi=zi2/2+zi1/2;

    if nargin==6
       if N>0
	  zi=vfilt(zi,gausswin(N));
	  zi=vfilt(zi',gausswin(N))';
       end
    end
    mato(:,:,i)=zi;
end
