function[]=jgraph_quirks
%JGRAPH_QUIRKS  Solutions to some common Matlab graphics quirks.
%
%  How do I make tick-marks disappear after a call to CONTOURF or PCOLOR?  
%     Matlab strangely places the plot on top of the axes.  Use AXESTOP.
%
%  How do I set tick labels to uniform precision, e.g. "[-0.01 0.00 0.01]"? 
%     Use FIXLABELS.
%
%  How do I make contours disappear after a call to CONTOURF?
%     Use NOCONTOURS.
%
%  How do I plot of the value each element of a matrix?  
%     Matlab's PCOLOR of an N x N matrix only has (N-1) x (N-1) tiles.
%     To plot the values of the elements themselves, use JIMAGE.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details    
