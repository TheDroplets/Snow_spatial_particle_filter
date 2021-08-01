%
%JSIGNAL  Signal processing, wavelet and spectral analysis
%
%Multitaper analysis
%   mspec      - Multitaper power spectrum.
%   mtrans     - Multitaper "eigentransform" computation.
%   msvd       - Singular value decomposition for polarization analysis.
%   sleptap    - Calculate Slepian tapers.
%   hermfun    - Orthonormal Hermite functions. [with F. Rekibi]
%   hermeig    - Eigenvalues of orthonormal Hermite functions. [with F. Rekibi]
%   
%Wavelet analysis
%   wavetrans  - Wavelet transform.
%   morsewave  - Generalized Morse wavelets. [See also below]
%   slepwave   - Slepian multi-wavelets.
%   slepenvwave- Slepian-enveloped wavelet.
%   bandnorm   - Applies a bandpass normalization to a wavelet matrix.
%   msvd       - Singular value decomposition for polarization analysis.
%
%Ridges and isolated maxima
%   ridgewalk  - Extract wavelet transform ridges.
%   ridgeinterp- Interpolate transform values onto ridge locations.
%   ridgemap   - Map wavelet ridge properties onto original time series.
%   ridgeprune - Remove all but the largest-amplitude ridges.
%   ridgerecon - Signal reconstruction along wavelet transform ridges.
%   isomax     - Locates isolated maximum of wavelet spectrum.
%   modmax     - Locates the modulus maxima of a wavelet transform.
%   modmaxpeaks- Locates peaks of wavelet transform modulus maxima lines.
%   edgepoints - Exclude edge effect regions from ridge or modmax points.
%
%Assorted other transforms   
%   slidetrans - Sliding-window ('moving-window') Fourier transform.  
%   hiltrans   - Hilbert transform.
%   anatrans   - Analytic part of signal.
%   wigdist    - Wigner distribtion (alias-free).
%
%Plotting tools
%   wavespecplot- Plot of wavelet spectra together with time series.
%   edgeplot   - Draws limits of edge-effect region on wavelet transform.
%   plbl       - Label frequency axis in terms of period.
%   timelabel  - Put month, day, or hour labels on a time axes.
%   ellipseplot- Plot ellipses.
%
%Polarization analysis of spectral matricos
%   specdiag   - Diagonalize a 2 x 2 spectral matrix.
%   transconv  - Convert between widely linear transform pairs.
%   walpha     - Widely linear transform anisotropy parameters.
%   polparam   - Spectral matrix polarization parameters.
%   mandn      - Widely linear transformation matrices M and N.
%
%Ellipse analysis of time series pairs [BETA VERSION]
%   normform   - Convert a omplex-valued vector into "normal form".
%   ecconv     - Convert between eccentricty measures.
%   ellconv    - Converts between time-varying ellipse representations.
%   elldiff    - Ellipse differentiation.
%   ellrad     - Average and instantaneous ellipse radius.
%   ellvel     - Average and instantaneous ellipse velocities.
%   ellipseplot- Plot ellipses.
%
%Generalized Morse wavelets [co-authored with F. Rekibi]
%   morsewave  - Generalized Morse wavelets of Olhede and Walden (2002).
%   morsefreq  - Minimum and maximum frequencies of Morse wavelets.
%   morsearea  - Time-frequency concentration area of Morse wavelets.
%   morsecfun  - Morse wavelet "C"-function.
%   laguerre   - Generalized Laguerre polynomials.
%   hermpoly   - Hermite polynomials. 
%
%Signal processing kernel functions
%   ck         - The "C" kernel (difference of two Dirichlet kernels).
%   dk         - The Dirichlet kernel.
%   fk         - The Fejer kernel.
%   hk         - The "H" kernel (product of two Dirichlet kernels).
%   
%Probability density functions
%   conflimit  - Computes confidence limits for a probability density function.
%   simplepdf  - Gaussian, uniform, and Cauchy probability density functions.
%   pdfprops   - Mean and variance associated with a probability distribution.
%   pdfadd     - Probability distribution from adding two random variables.
%   pdfmult    - Probability distribution from multiplying two random variables
%   pdfdivide  - Probability distribution from dividing two random variables.
%   pdfinv     - Probability distribution of the inverse of a random variable.
%   pdfchain   - The "chain rule" for probabilty density functions.
%   pdfconv    - Convolution of a probability distribution with itself.
% 
%Low-level signal processing code.
%   doublen    - Interpolates a time series to double its length.
%   sinterp    - Spline-interpolates a column vector to a new length.
%   waverot    - Rotates complex-valued wavelets.
%   testseries - Various time series for testing signal processing code.
%
%Low-level ellipse code
%   imat       - 2-D identify matrix.
%   jmat       - 2-D rotation matrix through specified angle.
%   kmat       - 2-D phase shift matrix through specified angle.
%   tmat       - 2-D complex grouping matrix.
%   amat       - Mean-taking matrix.
%   fmat       - Unitary Fourier transform matrix.
%   hmat       - Hilbert transform matrix.
%   randspecmat - Generates random 2x2 spectral matrices for testing.
%   ellipsetest - Run tests on ellipse code.  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details      
