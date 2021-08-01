function[evalme]=make(varargin)
%MAKE  Create a structure containing named variables as fields.
%
%   MAKE NAME V1 V2 ... VN where the VI are names of variables, creates
%   a structure NAME with fields
%
%       NAME.V1, NAME.V2, ... NAME.VN
%  
%   The original variables are not deleted.
%
%   MAKE('NAME',V1,V2 ... VN) also works. 
%  
%   This is useful for handling multiple datasets with the same variable 
%   names.  The structures can be then kept in memory and 'mapped' into 
%   variables as needed using USE. 
%
%   See also USE
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2005 J.M. Lilly --- type 'help jlab_license' for details        
  
evalme=[];

name=varargin{1};
nargs=length(varargin);

i=1;
while i<nargs
       	i=i+1;
	if isstr(varargin{i})
	  nameB=varargin{i};
	else 
	  nameB=inputname(i);
        end
	nameA=[name '.' nameB];
	evalme=[evalme,nameA,'=',nameB,';'];
	evalme=[evalme,setstr(10)];
end


if nargout==0
   evalin('caller',evalme)
   clear evalme
end







