function[]=runtests_jlab(name)
%RUNTESTS_JLAB  Run test suite for JLAB package.
%
%   RUNTESTS_JLAB NAME where NAME is a jlab module, e.g. 'jdata',
%   runs all tests associated with that module.
%
%   NAME='all' runs all tests.
%
%   RUNTESTS_JLAB with no arguments is equivalent to NAME='all'.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2002--2006 J.M. Lilly --- type 'help jlab_license' for details      


str.jarray={'aresame','iscompat','islargest','iswavegrid','k2sub',...
	    'lookup','matmult','nd','numslabs','quadform','rot','smartsmooth','sub2k','subset','twodhist','vectmult'};
str.jdata={'blocklen','blocknum','vectmult', 'vadd', 'vcellcat',...
     'vcolon','vdiff','vempty','vindex','vindexinto','vinterp','vmean','vmoment', ...
     'vmult','vnan','vnd','vpower','vrep','vshift','vsize','vsqueeze','vstd','vsum', ...
     'vswap','vtrans','vzeros'};
str.joceans={'elaz2xy','xy2elaz','mjd2num','num2yf','xy2latlon','spheredist','sphereproj'};
str.jsignal={'ecconv','ellconv','elldiff','doublen','hermpoly','morlwave','morsecfun','morsewave','mspec','msvd','normform','pdfconv',...
	    'pdfinv','pdfprops','randspecmat','ridgerecon','slepenvwave','slidetrans','specdiag',...
	    'waverecon','wavetrans','wigdist'};
str.jtriads={'triadres','msgn','dmasym','dmstd','dmspec','rescoeff',...
	    'gfun','hfun','kfun','psi2b','skewkern','qofl'};

str.all=[str.jarray,str.jdata,str.joceans,str.jsignal];

if nargin==0
  name='all';
end

eval(['str=str.' name ';'])

for i=1:length(str)
   try 
     eval([str{i} ' --t'])
   end
end
	
%'ridgerecon' this is a very slow test
% Tests not current working for randspecmat, wavegrid 
