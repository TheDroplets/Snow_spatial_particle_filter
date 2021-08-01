%
% JLAB_CHANGES   Changes to JLAB in each release
%
% Changes new in version 0.83 (current release)
% -----------------------------------------------------------------------
% New function: RIDGEMAP
% New function: ISLARGEST
% New functions: IMLOG, RELOG, UNWRANGLE
% New function: RIDGEPRUNE
% MAKELLIPSE depricated
% ECCONV bugfix for zero eccentricity signals
% RIDGEINTERP output argument changes
% CIRC2ELL absorbed into ELLIPSEPLOT
% PF_PARAMS changed to output |LON|<180
% VDIFF timestep functionality added
% RIDGEWALK, RIDGEINTERP, RIDGEMAP modified to work with ridge structures 
% ISMAT bugfix
% TWODHIST bugfix for negative data
% HILTRANS changed to support matrix input
% VSUM bugfix for no NaNs 
% STRCAPTURE depricated
% PACKROWS rewrite
% RIDGEWALK modified to return "ascending" ridges only
%
% Changes new in version 0.82 
% -----------------------------------------------------------------------
% JLAB_LICENSE slightly altered
% Minor change to test report convention
% Missing tests added
% New functions: PF_PARAMS and PF_EXTRACT
% New functions: TRACKFILL and TRACK2GRID
% New function: SLIDETRANS
% New function: QUADFORM
% New functions: EL2DIST and EL2INC
% New functions: SPHEREDIST and SPHEREPROJ 
% New function: RADEARTH
% New functions: ELAZ2XY and XY2ELAZ
% ELLCONV modified to match new notation, added tests
% MORSEWAVE changed to specify frequency exactly
% MORLWAVE changed to exact zero-mean formulation
% MORSEWAVE and MORLWAVE output argument change 
% RIDGEWALK output argument change 
% RIDGEINTERP input and output argument change
% VINTERPINTO bugfix and testing, led to VSHIFT bugfix 
% ISSCALAR renamed to ISSCAL to avoid naming conflict
% COL2MAT bugfix for length of key output matrix
% VFILT setting filter to unit energy feature depricated
%
% Changes new in version 0.81
% -----------------------------------------------------------------------
% RIDGEINTERP bugfix to have NANs same in frequency
% LATLON2XY and LATLON2UV have complex NANs for one output argument
% CATSTRUCT modified to use complex NANs for missing complex data
% MSPEC functionality split between MSPEC and new function MTRANS
% STICKVECT bugfix
% Missing functions included: TIDEFREQ and SPECDIAG
%
% Changes new in version 0.8 
% -----------------------------------------------------------------------
% New functions: XY2LATLON, SPECDIAG, RIDGEINTERP, TIDEFREQ
% New functions: ECCONV, ELLCONV, ELLDIFF, ELLVEL, ELLRAD, MAKELLIPSE
% WAVETRANS bugfix for multiple wavelets 
% VDIFF modified for multiple input arguments
% MAKE additional input format added 
% VSHIFT added selection functionality 
% ELLIPSEPLOT bugfix
% CIRC2ELL input argument change 
% WAVESPECPLOT chaged to allow complex-valued trasnform matrices
% WCONVERT renamed TRANSCONV and syntax changed 
% COMMENTLINES bugfix for directory arguments
% RIDGEWALK and RIDGEINTERP modified to detect negative rotary transform
% LATLON2XY bugfix for larger than 180 degree jumps; test code
% RUNTESTS_JLAB modified to test modules separately
% NUMSLABS moved to JARRAY
% ROT changed to handle special cases of n*pi/2 exactly; test added
% FILLBAD rewrite, also changed to handle complex-valued data
% VDIFF changed to differentiate a specified dimension
% MORSEWAVE changed to have phase definition of frequency
% VZEROS changed to support NAN output
% XOFFSET and YOFFSET changed to offset groups of lines
% UVPLOT streamlined, hold off by default
% RIDGEWALK argument convention change
% RIDGEWALK nasty bugfix to form_ridge_chains
% VFILT bugfix for filter of zeros and ones
% MAKEFIGS all modified to print to current directory
% PACKROWS and PACKCOLS changing labels feature depricated
% ELLIPSEPLOT major axis drawing added
% LATLON2UV bug fixed for vector day input
% POLPARAM modified for more general input formats
% MATMULT acceleration and test
% POLPARAM bugfix for noise causing imaginary determinant 
% VSUM and VSWAP modified to support possible NAN+i*NAN
% SLEPWAVE bugfix for 'complex' flag
% MSPEC rewrite, bugfix for odd length clockwise, test suite
%
% Changes new in version 0.72
% -----------------------------------------------------------------------
% New functions: VEMTPY, VCELLCAT, EDGEPOINTS
% New function:  MODMAXPEAKS
% New function:  NONNAN
% BLOCKLEN fixed incorrect output length  
% ELLIPSEPLOT bug fixed
% FLUSHLEFT and FLUSHRIGHT re-written
% LATLON2CART and LATLON2CV renamed LATLON2XY and  LATLON2UV
%      Argument handling improvements to both
% LATLON2XY swapped order of output arguments
% MODMAX modified to prevent long traverses 
% MORSECFUN and MORSEAREA modified for mixed matrix / scalar arguments
% MORSEWAVE modified to ensure centering of wavelet
% NORMFORM bug for infinite theta fixed
% PDFPROPS modified to output skewness and kurtosis
% RIDGEWALK modified to handle possible absence of ridges
% RIDGEWALK output argument improvements
% RIDGEWALK input argument NS depricated
% RIDGEWALK modified to output matrices
% RIDGERECON modified to handle multivariate datasets
% RIDGERECON modified to handle ridges of a complex-valued time series
% SLEPTAP fixed non-unit energy for interpolated tapers
% TWODHIST fixed counting bug and general improvements
% WAVETRANS modified for better centering
%
