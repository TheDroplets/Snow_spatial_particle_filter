function[linestyles]=linestylesets
%LINESTYLESETS  User-specified line style sets for use with LINESTYLE.
%
%   The input to LINESTYLE is a cell array or the form {S,C,W}.  
%	
%   Here C is a string describing the colors (ex: 'kbgrcmy'). 
%   S is a string matrix desribing the line styles, for example: 
%
%            '-'		  all solid
%	     '-:'		  alternate solid, dotted
%	    ['- ';'--';': ']	  solid, dashed, dotted    
%
%   and W is a numeric array of the line widths (ex: [0.5 1 2]).  
%
%   Line handles will be cycled through the available styles,
%   colors, and widths, so that S, C, and W need not have the 
%   same length as the number of line handles nor as each other.
%
%   An ellipsis may be used (for C only) to indicate a repeated
%   last color, thus 'kbgr...' is equivalent to 'krbrrrrrrr...'.
%		
%   See also LINESTYLE, COLORSETS
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        


%linestyles.FORMAT={'COLOR','STYLE','WIDTH'};
linestyles.default={'bgrcmyk','-',1};
linestyles.black={'k','-',1};
linestyles.just1={'bDDDDDD...','-',[2 1 1 1 1 1 1]};
linestyles.just2={'bgDDDDD...','-',[2 2 1 1 1 1 1]};
linestyles.just3={'bgrDDDD...','-',[2 2 2 1 1 1 1]};
linestyles.just4={'bgrcDDD...','-',[2 2 2 2 1 1 1]};
linestyles.just5={'bgrcmDD...','-',[2 2 2 2 2 1 1]};
linestyles.just6={'bgrcmyD...','-',[2 2 2 2 2 2 1]};
linestyles.groups4={'kkkkbbbbggggrrrr','-',1};
linestyles.groups5={'kkkkkbbbbbgggggrrrrr','-',1};
linestyles.groups6={'kkkkkkbbbbbbggggggrrrrrr','-',1};
linestyles.groups7={'kkkkkkkbbbbbbbgggggggrrrrrrr','-',1};
linestyles.groups8={'kkkkkkkkbbbbbbbbggggggggrrrrrrrr','-',1};
linestyles.groups9={'kkkkkkkkkbbbbbbbbbgggggggggrrrrrrrrr','-',1};
linestyles.groups10={'kkkkkkkkkkbbbbbbbbbbggggggggggrrrrrrrrrr','-',1};
linestyles.thick={'bgrcmyk','-',2};
linestyles.two={'Ek',['- ';'--'],[2 1]};
linestyles.three={'kEk',['--';'- ';'- '],[2 2 1]};
linestyles.four={'EkEk',['--';'--';'- ';'- '],[2 1 2 1]};
linestyles.just2bw={'kkkkkkk...','-',[2.5 2.5 1 1 1 1 1]};
linestyles.triplets={'bbbgggrrr',['- ';'--';'- '],[1 2 2]};
linestyles.redgreenblue={'rgb',['-';'-';'-'],[1 1 1]};






