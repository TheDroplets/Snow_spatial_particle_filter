function[index]=indexor(varargin)
%INDEXOR  Finds the union of multiple indices.
%
%   INDEX = INDEXOR(INDEX1,INDEX2...), where the INDEX1, INDEX2,... are   
%   indices into a matrix (such as INDEX1 = FIND(DATA > 2) ), returns an  
%   index containing the matrix locations which are members of any of the 
%   input indices.                                                        
%                                                                         
%   In other words, if each input index INDEXi (i=1:N) references a set   
%   of matrix components for which a given statement is true, the output  
%   of INDEXOR references the matrix components for which any of the N    
%   statements are true.                                                  
%                                                                         
%   INDEXOR(CA), where CA is a cell array such that CA{1}=INDEX1,         
%   CA{2}=INDEX2,... also works.                                          
%                                                                         
%   See also INDEXAND                                         
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


for i=1:length(varargin)
	eval(['i' int2str(i) '=varargin{i};']);
	if iscell(i1)
		index=i1{i};
	else
		index=eval(['i',int2str(i)]);
        end
	if ~bempty(i)
  	  maxin(i)=max(index);
	else 
	  maxin(i)=0;
	end
end
n=max(maxin);
bool1=zeros(n,1);
for i=1:nargin
	if ~bempty(i)
	  if iscell(i1)
		index=i1{i};
	  else
		index=eval(['i',int2str(i)]);
	  end
	  index=row2col(index);
	  bool1(index)=ones(size(index));
	end
end
index=find(bool1);


 
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
