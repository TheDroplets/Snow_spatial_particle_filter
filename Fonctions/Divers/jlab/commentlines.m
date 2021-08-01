function[str]=commentlines(dirname)
%COMMENTLINES  Returns the comment lines from m-files. 
%
%   COMMENTLINES is used to facilitate making 'Contents.m' files.
%
%   COMMENTLINES returns a string matrix which contains all the comment
%   lines, i.e the first line beginning with '%', from all m-files in
%   the current directory.  
%  
%   COMMENTLINES DIRNAME applies to directory DIRNAME.  The full 
%   pathname of the directory must be given. 
%   
%   COMMENTLINES with no input argumnet appies itself to the current
%   working directory.  
%   
%   COMMENTLINES FILENAME applies to just m-file FILENAME; note here the
%   suffix ".m" must be included in the filename.
%  
%   Examples:  commentlines plot.m
%              commentlines /usr/home/jollod/jlab
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002--2005 J.M. Lilly --- type 'help jlab_license' for details

bmname=0;
if nargin~=0
  if ~ismname(dirname)
     olddir=pwd;
     evalin('base',['cd ' dirname])
  else
     bmname=1;
     x=dirname;
  end
else
  dirname=pwd;
end

%/********************************************************
%Make a list of all m-file names
if ~bmname
  x=dir;
  for i=1:length(x)
    y{i}=x(i).name;
  end
  x=y;
  
  %remove elements which are not .m 
  index=ismname(x);
  if ~isempty(x)
    x=x(find(index));
    if ~isempty(x)
      x=strs2mat(x);
    end
  else
    x=[];
    str=[]; 
  end
end
%\********************************************************


if isempty(x)
  disp(['No m-files found in directory ' dirname '.'])
else
  for i=1:size(x,1)
    fid=fopen(deblank(x(i,:)));
    firstline=fgetl(fid);
    secondline=fgetl(fid);
    if length(firstline)>=8
       bfunction=strcmp(firstline(1:8),'function');
    else
       bfunction=0;
    end
    
    if ~isempty(secondline)
       if secondline==-1|~bfunction
           secondline=firstline;       
       end
    else
        secondline=firstline;
    end
    
  
    if ~isempty(secondline)
      %remove both leading and trailing blanks
      a=min(find(real(secondline)~=real('%')&~isblank(secondline)));
      temp=deblank(secondline(a:end));
      str{i}=temp;
    else 
      str{i}=[];
    end
    
    fclose(fid);
  end
  
  str=packstrs(str);
  
  for i=1:length(str)
    
      str1=str{i};
      a=findfirst(real(str1)~=real('%'));
      b=findfirst(isblank(str1)|istab(str1))-1;
      
      name=lower(safeindex(a,b,str1));
      str1=safeindex(b+1,length(str1),str1);
       
      if ~isempty(str1)
         a=findfirst(~isblank(str1)&~istab(str1)&real(str1)~=real('%'));
         str1=safeindex(a,length(str1),str1);
      end
      
      if ~isempty(name)
        nfl=length(name);
        if nfl<10
            str1=['%   ' name blanks(10-nfl) ' - ' str1];
        else
            str1=['%   ' name ' - ' str1];
        end
        str{i}=str1;
      else 
        str{i}=[];
      end  
  end
  
  str=packstrs(str);
  str=strs2mat(str);
  
  
  firstcol=real(str(:,1));
  [firstcol,index]=sort(firstcol);
  str=str(index,:);
end %m-files found

%Upcase initial word
% for i=1:size(str,1)
%    index=findstr(str(i,:),' ');
%    index=index(find(index>4));
%    if ~isempty(index);
%       str(i,1:index-1)=upper(str(i,1:index-1));
%    end
% end

if nargin~=0&~bmname
   evalin('base',['cd ' olddir])
end


function[y]=safeindex(a,b,x)
% SAFEINDEX   Indexes an array; returns empty if index is empty
%
%   Y=SAFEINDEX(INDEX,X) <==>  Y=X(INDEX), or [] if empty INDEX
%   Y=SAFEINDEX(A,B,X) <==>  Y=X(A:B) if B>=A, [] otherwise
 
y=[];
 
if nargin==2
  index=a;
  x=b;
  if ~isempty(a)
    y=x(index);
  end
elseif b-a>=0
   index=a:b;
   y=x(index);
end
