function[ref,o1,o2,o3,o4,o5,o6,o7,o8,o9]=colbreaks(ref,c1,c2,c3,c4,c5,c6,c7,c8,c9)
%COLBREAKS  Insert NANs into discontinuties in a vector.
%
%   O1=COLBREAKS(I1), where I1 is a column vector, inserts NANs into
%   I1 at its discontinuties (and puts one at the end), for example:
%		
%	  COLBREAKS([2;2;2;3;3])=[2;2;2;NAN;3;3;NAN];
%
%   [O1,O2,O3,...]=COLBREAKS(I1,I2,...), where I1,I2,... are all
%   column vectors of the same length, uses I1 as a reference for the
%   other vectors and inserts NANs into all the vectors at locations
%   where I1 is discontinous.
%	
%   For instance, using station number for I1 will sort a column of
%   CTD data into a NAN-padded matrix.
%
%   MAT2=COLBREAKS(MAT1), where MAT1 and MAT2 are matrices of the same
%   size, also works.  In this case the first column of MAT1 is used
%   as the reference vector.
%
%   COLBREAKS, COL2MAT, and MAT2COL together form a system for moving
%   data with segments of nonuniform length rapidly back and forth
%   between a column format and a padded-matrix format. CTD or float
%   data, for instance, can be stored in the (usually much smaller)
%   column format and converted into the matrix format upon loading.
%  
%   COLBREAKS(C1,C2,...); with no output arguments overwrites the
%   original input variables.  
%
%   See also COL2MAT, MAT2COL
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details


%Look ma, no loops!


bmat=0;
nargs=nargin;
if nargin==1&size(ref,2)>1
	temp=ref;
	ref=temp(:,1);
	for i=1:size(temp,2)-1			
		eval(['c',int2str(i),'=temp(:,',int2str(i+1),');']);
	end
	nargs=size(temp,2);
	clear temp
	bmat=1;
end


ii=0;
index=find(diff(ref)~=0)+1;
bool=zeros(size(ref));
bool(index)=ones(size(index));
index=[1:length(ref)]'+cumsum(bool);

while ii<nargs - 1
        ii=ii+1;
        col=eval(['c',int2str(ii)]);

	colout=nan*ones(max(index),1);
	colout(index)=col;
	colout=[colout;nan];

 	eval(['o',int2str(ii),'=colout;']);


end

refout=nan*ones(max(index),1);
refout(index)=ref;
%if ~isnan(refout(length(refout)))
refout=[refout;nan];
for i=1:nargs-1
	eval(['o(:,',int2str(i+1),')=[o',int2str(i),';nan];'])
end
%end
ref=refout;


if bmat
	for i=1:nargs-1
		eval(['ref(:,',int2str(i+1),')=o',int2str(i),';'])
	end
end
	

if nargout==0
   varargout{1}=ref;
   for i=1:nargs-1
      eval(['varargout{',int2str(i+1),'}=o',int2str(i),';'])
   end  
  eval(to_overwrite(nargs));
end



