function[m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13]=col2mat(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13)
%COL2MAT  Expands 'column-appended' data into a matrix.
%
%   M=COL2MAT(C), where C is a column vector of data segments
%   separated by NANs, expands the data into a matrix such that each
%   segment has its own column.  For instance, the intervals may
%   represent CTD casts of various depths, and the NANs mark
%   transitions between casts.
%
%   M will have enough rows to fit the longest data segment. Segments
%   are read into columns of M from the top down, leaving empty spaces
%   at the bottom which are filled in with NANs.
%
%   [M1,M2,....]=COL2MAT(C1,C2,...), where C1,C2,... are input column
%   vectors, also works, as does [M1,M2,....]=COL2MAT(MAT), where MAT
%   is a matrix of column vectors.  In both cases the first column is
%   used as the reference for the others, so that only the locations
%   of NANs in the first column matters.
%
%   COL2MAT, MAT2COL, and COLBREAKS together form a system for moving
%   data with segments of nonuniform length rapidly back and forth
%   between a column format and a padded-matrix format.  CTD or float
%   data, for instance, can be stored in the (usually much smaller)
%   column format and converted into the matrix format upon loading.
%
%   COL2MAT(C1,C2,...); with no output arguments overwrites the
%   original input variables.
%
%   See also MAT2COL, COLBREAKS
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details
  
%no loops!


if nargin>1
	for i=1:nargin
        	eval(['data(:,' int2str(i) ')=c' int2str(i) ';'])
	end
else 
	data=c1;
end


for ii=1:size(data,2)
	col=data(:,ii);
	if ii==1;
		%use index into NANs and index derivative
		%to determine size of new matix
		nani=find(isnan(col));
		dnani=diff([0;nani]);
		nrows=max(dnani);
		ncols=length(nani);

		%determine index into top of each column ==a
		%and index into first NAN in each column ==b
		a=1+nrows*[0:ncols-1]';
		b=dnani+a;
		index=zeros(nrows*ncols,1);
		
		b=b(find(b<length(index)));
		%mark all the numbers between each a and each b
		index(a)=1;	
		index(b)=index(b)-1;%this matters (a may equal b)		
		index=find(cumsum(index));
		if length(index)>length(col)
		   index=index(1:length(col));
		end
	end
	mat=nan*ones(nrows,ncols);
	mat(index)=col;
	eval(['m' int2str(ii) '=mat;']);
end



if nargout>nargin
	eval(['m' int2str(size(data,2)+1) '=index;']);
end


if nargout==0
   for i=1:nargin
      eval(['varargout{',int2str(i),'}=m',int2str(i),';'])
   end  
  eval(to_overwrite(nargin));
end


