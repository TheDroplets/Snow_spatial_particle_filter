function[mat,xmid,ymid]=twodhist(xdata,ydata,xbin,ybin,flag)
%TWODHIST  Two-dimensional histgram.
%
%   MAT=TWODHIST(X,Y,XBIN,YBIN) where X and Y are arrays of the same
%   length, creates a two-dimensional histogram MAT with bin edges
%   specified by XBIN and YBIN. 
%  
%   The (X,Y) data points are sorted according to their X-values,
%   which determine a column within MAT, and their Y-values, which
%   determine a row within MAT.  If XBIN and YBIN are length N and M,
%   respectively, then MAT is of size M-1 x N-1.
%
%   XBIN and YBIN must be monotonically increasing. 
%
%   [MAT,XMID,YMID]=TWODHIST(...) optionally returns the midpoints
%   XMID and YMID of the bins.
%
%   Usage: mat=twodhist(x,y,xbin,ybin);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details    

% 06.09.04 JML fixed counting bug and general improvements
  
if strcmp(xdata,'--t')
   twodhist_test;return
end

if nargin==4
  flag=1;
end

xbin=xbin(:);
ybin=ybin(:);
if any(diff(xbin)<0)
  error('XBIN must be monotonically increasing')
end
if any(diff(ybin)<0)
  error('YBIN must be monotonically increasing')
end

if flag
  mat=twodhist_fast(xdata,ydata,xbin,ybin);
else
  mat=twodhist_slow(xdata,ydata,xbin,ybin);
end

if nargout>1
  xmid=(xbin+vshift(xbin,1,1))./2;
  xmid=xmid(1:end-1);
end
if nargout>2
  ymid=(ybin+vshift(ybin,1,1))./2;
  ymid=ymid(1:end-1);
end

function[mat]=twodhist_fast(xdata,ydata,xbin,ybin)
vcolon(xdata,ydata,xbin,ybin);
index=find(isfinite(xdata)&isfinite(ydata));
vindex(xdata,ydata,index,1);
[xbinb,ybinb]=vshift(xbin,ybin,1,1);

dxa=osum(xdata,-xbin);
dxb=osum(xdata,-xbinb);
boolx=(dxa>0&dxb<=0);
[iix,jjx]=ind2sub(size(boolx),find(boolx));

dya=osum(ydata,-ybin);
dyb=osum(ydata,-ybinb);
booly=(dya>0&dyb<=0);
[iiy,jjy]=ind2sub(size(booly),find(booly));
  
matx=nan*xdata;
maty=nan*ydata;
matx(iix)=jjx;
maty(iiy)=jjy;

vcolon(matx,maty);
index=find(isfinite(matx)&isfinite(maty));
vindex(matx,maty,index,1);

mat=zeros(length(ybin),length(xbin));
index=sub2ind(size(mat),maty,matx);

if ~isempty(index)
    index=sort(index);
    [L,ia]=blocklen(index);
    mat(index(ia))=L(ia);
end

mat=mat(1:end-1,:);
mat=mat(:,1:end-1);

function[mat]=twodhist_slow(xdata,ydata,xbin,ybin)
mat=0*osum(ybin,xbin); 
[xbinb,ybinb]=vshift(xbin,ybin,1,1);
for i=1:length(xbin)
   for j=1:length(ybin)
         mat(j,i)=length(find(xdata>xbin(i)&xdata<=xbinb(i)&...
			      ydata>ybin(j)&ydata<=ybinb(j)));
   end
end
mat=mat(1:end-1,:);
mat=mat(:,1:end-1); 

function[]=twodhist_test
xdata=2*abs(rand(1000,1));
ydata=2*abs(rand(1000,1));
xbin=[0:.1:2];
ybin=[0:.2:2];
mat1=twodhist(xdata,ydata,xbin,ybin,1);
mat2=twodhist(xdata,ydata,xbin,ybin,0);
bool=aresame(mat1,mat2,1e-10);
reporttest('TWODHIST fast vs. slow algorithm',bool)

xdata=-2*abs(rand(1000,1));
ydata=-2*abs(rand(1000,1));
xbin=[-2:.1:0];
ybin=[-2:.2:0];
mat1=twodhist(xdata,ydata,xbin,ybin,1);
mat2=twodhist(xdata,ydata,xbin,ybin,0);
bool=aresame(mat1,mat2,1e-10);
reporttest('TWODHIST fast vs. slow algorithm, negative bins',bool)

