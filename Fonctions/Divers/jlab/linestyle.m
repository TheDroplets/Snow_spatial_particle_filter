function[]=linestyle(varargin)
%LINESTYLE  Sets color, style, and width properties of lines.
%	    	    	    
%   LINESTYLE provides an efficient way to set common properties of
%   large groups of lines, and further allows the user to quickly
%   apply predefined sets of line colors, styles, and widths designed
%   for different purposes.
%
%   'LINESTYLE 1k-- 2.5g- m-.' sets the first line to width 1, color
%   black, and dashed style; the second to width 2.5, color green, and
%   solid style; and the third to width 1, color magenta, and dash-
%   dotted style.
%  
%   In general the format is 
%
%       LINESTYLE STR1 STR2 STR3 ...   
%
%   where each of the STRs may contain a number, specifying the width
%   of the Ith line; a letter, specifying the color; and a style
%   string.  Any two of these are optional, with a unit width solid
%   black line being the default.
%
%   By default, styles are looped if the number of STRs input is less
%   than the number of lines in the current plot. The input
%
%       LINESTYLE  STR1 STR2 ... STRN +++
%
%   causes the last style input, STRN, to be repeated instead.      
%
%   LINESTYLE(H,STR) alternatively sets all lines in the handle array
%   H to have the same style STR.
%  
%   LINESTYLE permits the addition of user-defined colors, such as
%   grayscale (letters A--K in order of increasing darkness). See
%   COLORSETS for more details.
%
%   LINESYTLE LOCK and LINESTYLE UNLOCK lock and unlock all axes in
%   the current figure.  When LOCK is on, calls to LINESTYLE or
%   LINERING are applied to all lines in the current figure.
%
%   LINESTYLE(NAME) or LINESTYLE NAME applies the style set NAME,
%   specified in the file LINESTYLESETS.  This allows one to predefine
%   useful groupings of colors, styles, and widths. Type LINESTYLE
%   with no arguments to see a list of current style sets. 
%
%   See also LINERING, COLORSETS, LINESYTLESETS, FONTSIZE
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
  
linestyles=linestylesets;
bextendlast=0;

num=1;
if isappdata(gca,'lineringpointer');
  num=getappdata(gca,'lineringpointer');   %Remember current linering
end


if nargin==0
   %if no arguments, just display available linestyle sets
   disp(' ');
   disp('Available linestyle sets:');
   disp(' ');
   disp(linestyles)
   disp(' ');
   return
end

bloop=1;
if nargin==1
   temp=varargin{1};
   %Special cases 
   if strcmp(temp,'lock')
        setappdata(gcf,'linestylelock',1)
	return
   elseif strcmp(temp,'unlock')
        setappdata(gcf,'linestylelock',0)
	return
   elseif isfield(linestyles,temp)
        [widthcell,stylecell,colorcell]=linestyleapply(linestyles,temp);
        bloop=0;  %supress loop if name input
   end
end

%/********************************************************
%Block for applying LINESTYLE to input line handle
bhandleinput=0;
if nargin==2
  if ~isstr(varargin{1});
    h=varargin{1};
    sty=varargin{2};
    
    if isfield(linestyles,sty)
       [widthcell,stylecell,colorcell]=linestyleapply(linestyles,sty);
    else
       [widthcelli,stylecelli,colorcelli]=linestyleparse(sty);    
       widthcell{1}=widthcelli;
       stylecell{1}=stylecelli;
       colorcell{1}=colorcelli;
    end
    
    bextendlast=1;
    bhandleinput=1;
    bloop=0;  %supress loop if line handles are input
  end
end
%\********************************************************
    
if bloop
   for i=1:nargin
     temp=varargin{i};
     if strcmp(temp,'+++')  %ending in continuation symbol
         bextendlast=1;
     else
        [widthcelli,stylecelli,colorcelli]=linestyleparse(temp);
	widthcell{i}=widthcelli;
	stylecell{i}=stylecelli;
	colorcell{i}=colorcelli;
     end  
   end
end
     

if ~bhandleinput
  h=flipud(linehandles(gca));
end

N=length(h);
M=length(stylecell);
if bextendlast
  %Extend by looping continuing last
  for j=M+1:N
      colorcell{j}=colorcell{M}; 
      stylecell{j}=stylecell{M}; 
      widthcell{j}=widthcell{M}; 
  end
else
  %Extend by looping whole structure 
  while N>M
      colorcell([1:M]+M)=colorcell;
      stylecell([1:M]+M)=stylecell; 
      widthcell([1:M]+M)=widthcell;  
      M=length(stylecell);
  end
end

%Truncate if too long
colorcell=colorcell(1:N);
stylecell=stylecell(1:N);
widthcell=widthcell(1:N);

if bhandleinput   %If explict handle input, no looping over figures
   set(h,{'linewidth'},widthcell')
   set(h,{'linestyle'},stylecell')
   set(h,{'color'},colorcell')	
else
   locked=0;      %Check to see if current figures axes are locked
   if isappdata(gcf,'linestylelock')
       if getappdata(gcf,'linestylelock')
            locked=1;	
       end
   end
   if ~locked      %Just apply to current axes
      linering(1*sqrt(-1));%Go to first position in linering
      h=flipud(linehandles(gca));
      set(h,{'linewidth'},widthcell')
      set(h,{'linestyle'},stylecell')
      set(h,{'color'},colorcell')	
      linering(num*sqrt(-1));%Return to original
   else
      h1=axeshandles(gcf);	
      for i=1:length(h1)   %Loop over all axes
           linering(1*sqrt(-1));%Go to first position in linering
           h=linehandles(h1(i));
           set(h,{'linewidth'},widthcell')
           set(h,{'linestyle'},stylecell')
           set(h,{'color'},colorcell')	
	   linering(num*sqrt(-1));%Return to original
      end
   end
end


function[widthcell,stylecell,colorcell]=linestyleparse(str);
%Parse the linestyle input string for cell specifications

defaultwidth=1;
defaultcolor='k';
defaultstyle='-';

colors=colorsets;
bool=1+0*str;
     
%/********************************************************
%linewidth
index=find(real(str)>47&real(str)<58); %find str is 0-9
if isempty(index)
   widthcell=defaultwidth;
else
   width=str2num(str(index(1):index(end)));  %encompasss '.'
   if isempty(width)
     error('Problem with linestyle string.')
   else
     widthcell=width;
     
     %remove these entries from string
     bool(index(1):index(end))=0;
     str=str(find(bool));
     bool=1+0*str;
   end
end
%\********************************************************


%/********************************************************
%linecolor
index=find(real(str)>64&real(str)<123); %find str is a-Z
if isempty(index)
   colorcell=defaultcolor;
else
   color=str(index); 
   if length(color)>1
     error('More than one color specified.')
   else
     colorcell=getfield(colors,color);
     
     %remove these entries from string
     bool(index)=0;
     str=str(find(bool));
   end
end
%\********************************************************   

%/********************************************************
%linestyle
if isempty(str)
   stylecell=defaultstyle;
else
   stylecell=str;
end
%\********************************************************   

function[widthcell,stylecell,colorcell]=linestyleapply(linestyles,name)
%Apply contents of LINESTYLESETS definition to cell arrays
  
  
% %account for the fact that LINERING flips the linering
% %to put the first line on the top
% if isappdata(gca,'lineringflipped')
%    if getappdata(gca,'lineringflipped')
% 	h=flipud(h);
%    end
% end
  
colors=colorsets;
h=flipud(linehandles(gca));

colorx=[];
stylex=[];
widthx=[];


if ~isfield(linestyles,name)
  error('That is not a valid linestyle set name.')
else
  colorx=getfield(linestyles,name,{1});
  colorx=colorx{1};
  stylex=getfield(linestyles,name,{2});
  stylex=stylex{1};
  widthx=getfield(linestyles,name,{3});
  widthx=widthx{1};
end

%make the vectors the same length as the handles by cycling
brepeat=0;
N=length(colorx)-3;
if ~isempty(colorx)
   colorx=row2col(colorx);
   if length(colorx)>3
	if strcmp(colorx(end-2:end)','...')
	     colorx(end-2:length(h),:)=colorx(end-3,:);
	     brepeat=1;
	end
   end 		    
   while size(colorx,1)<length(h)
	 colorx=[colorx;colorx];
   end
   colorx=colorx(1:length(h),:);
end

if ~isempty(stylex)
   if size(stylex,1)==1
      stylex=row2col(stylex);
   end
   if length(stylex)==N&brepeat
      stylex(end:length(h),:)=stylex(end,:);
   else
       while size(stylex,1)<length(h)	
           stylex=[stylex;stylex];
       end
   end
   stylex=stylex(1:length(h),:);
end

if ~isempty(widthx)
   widthx=row2col(widthx);
   if length(widthx)==N&brepeat
      widthx(end:length(h),:)=widthx(end,:);
   else
       while size(widthx,1)<length(h)	
           widthx=[widthx;widthx];
       end
   end
   widthx=widthx(1:length(h),:);
end

%convert color into numeric values
temp=colorx;
clear colorx
colorx=[];
for i=1:length(temp)
    colorx(i,:)=getfield(colors,temp(i));
end


%now put into cell arrays, because that's what matlab understands
colorcell=[];
stylecell=[];
widthcell=[];

for i=1:length(h)
    if ~isempty(colorx)
	colorcell{i}=colorx(i,:);
    end    
    if ~isempty(stylex)
	stylecell{i}=stylex(i,:);
    end
    if ~isempty(widthx)
	widthcell{i}=widthx(i);
    end
end

%kludge
%h=flipud(h);

if ~isempty(widthcell),set(h,{'linewidth'},widthcell'),end
if ~isempty(stylecell),set(h,{'linestyle'},stylecell'),end
if ~isempty(colorcell),set(h,{'color'},colorcell'),end



