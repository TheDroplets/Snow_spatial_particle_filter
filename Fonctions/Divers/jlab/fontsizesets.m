function[fonts]=fontsizesets
%FONTSIZESETS  User-specified fontsize sets for use with FONTSIZE
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details  

fonts.FORMAT= '[TITLE LABELS AXES TEXT]';
fonts.default=[14 12 12 12];
fonts.poster=[20 16 16 16];
fonts.transparency=[24 20 20 20];
fonts.jpofigure=[9 9 9 9];

if 0
fonts.default.labels=12;
fonts.default.axes=12;
fonts.default.text=12;

fonts.transparency.title=24;
fonts.transparency.labels=20;
fonts.transparency.axes=20;
fonts.transparency.text=20;

fonts.jpofigure.title=9;
fonts.jpofigure.labels=9;
fonts.jpofigure.axes=9;
fonts.jpofigure.text=9;
end

