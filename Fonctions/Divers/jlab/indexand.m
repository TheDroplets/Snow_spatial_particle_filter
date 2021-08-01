function[index]=indexand(varargin)
%INDEXAND  Finds the intersection of multiple indices.
%
%   INDEX = INDEXAND(INDEX1,INDEX2...), where the INDEX1, INDEX2,... are  
%   indices into a matrix (such as INDEX1 = FIND(DATA > 2) ), returns an  
%   index containing the matrix locations which are members of all the    
%   input indices.                                                        
%                                                                         
%   In other words, if each input index INDEXi (i=1:N) references a set   
%   of matrix components for which a given statement is true, the output  
%   of INDEXAND references the matrix components for which all the N      
%   statements are true.                                                  
%                                                                         
%   INDEXAND(CA), where CA is a cell array such that C{1}=INDEX1,         
%   CA{2}=INDEX2,... also works.                                          
%
%   See also INDEXOR, VINDEX
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details  
bempty=zeros(length(varargin),1);
for i=1:length(varargin)
    if isempty(varargin{i})
      bempty(i)=1;
    end
end

index=[];

if ~bempty

for i=1:nargin
  	eval(['i' int2str(i) '=varargin{i};']);
	if iscell(i1)
		index=i1{i};
	else
		index=eval(['i',int2str(i)]);
        end
	maxin(i)=max(index);
end
n=max(maxin);
bool1=ones(n,1);
for i=1:nargin
  	eval(['i' int2str(i) '=varargin{i};']);
        if iscell(i1)
		index=i1{i};
	else
		index=eval(['i',int2str(i)]);
        end
	index=row2col(index);
        bool2=0*bool1;
	bool2(index)=ones(size(index));
	bool1=bool1.*bool2;
end
index=find(bool1);

end




function[col]=row2col(row)
%ROW2COL  Given any vector, returns it as a column vector.
 
if size(row,2)>size(row,1)
        if ~isstr(row)
                col=conj(row');
        else
                col=row';
        end
else
        col=row;
end

