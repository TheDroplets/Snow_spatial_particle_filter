function[y]=ndrep(n,x,dim);
%NDREP  Replicates an array along a specified dimension.
%
%   Y=NDREP(N,X,DIM) replicates the array X N times along dimension
%   DIM. For instance:
%
%	    NDREP(3,[1:4]',2)=[ [1:4]' [1:4]' [1:4]' ]
%
%   This is often useful in array algebra.
%		
%   See also NDINDEX, DIM.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2001, 2004 J.M. Lilly --- type 'help jlab_license' for details        

%You would think Matlab would provide a simpler way to do this.

str=['y=repmat(x,['];
ndx=ndims(x);
for i=1:max(ndx,dim)
    if i~=dim
        str=[str '1,'];
    else
	str=[str 'n,'];
    end
end
str=[str(1:end-1) ']);'];
eval(str);
