function[]=use(x)
%USE  Copies structure fields into named variables in workspace.
%
%   USE STRUCT, where STRUCT is a structure, copies all fields of the
%   form STRUCT.X into variables named X.
%  
%   This is useful for handling multiple datasets with the same
%   variable names.  The structures can be then kept in memory and
%   'mapped' into variables as needed.
%
%   See also MAKE
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details    

%'if ~exist (' x ')==1, load 'x'  

 evalme=['if ~isempty(' x '),' setstr(10) ...
	'  ZZFNAMES=fieldnames(' x ');' setstr(10) ...
	'  for ZZi=1:length(ZZFNAMES),' setstr(10) ...
	' 	  eval([ZZFNAMES{ZZi}, ''=getfield(' x ',ZZFNAMES{ZZi});'']);' setstr(10) ...
	'  end;' setstr(10) ...
	'else;' setstr(10) ...
	'  disp([''Contains no data.'']);' setstr(10) ... 
	'end;' setstr(10) ...
	'clear ZZi ZZFNAMES' setstr(10)];
evalin('caller',evalme)
%evalme
