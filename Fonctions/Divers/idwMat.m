function Fint = idwMat(X0,F0,Xint,p,rad,L)
% function Fint = idw(X0,F0,Xint,p,rad,L)
%
% Inverse distance weight function to interpolate values based on
% sampled points.
%
% Fint = idw(X0,F0,Xint) uses input coordinates X0 and input values F0
% where X0 is a N by M input matrix of N samples and M number of variables.
% F0 is vector of N responses. Xint is a Q by M matrix of coordinates to be
% interpolated. Fint is the vector of Q interpolated values.
%
% Fint = idw(X0,F0,Xint,p,rad) uses the power p (default p = 2) and radius
% rad (default rad = inf).
%
% Fint = idw(X0,F0,Xint,p,rad,L) uses L-distance. By defaults L=2
% (Euclidean norm).
%
% 
% Contact info:
%
% Andres Tovar
% tovara@iupui.edu
% Indiana University-Purdue University Indianapolis
%
% Code developed for the course Design of Complex Mechanical Systems (ME
% 597) offered for the first time in Spring 2014

% MODIF P. CANTET , on peut mettre F0 en matrice NbPointsXNbVar, NbVar a
% spatialiser

% Default input parameters
if nargin < 6
    L = 2;
    if nargin < 5
        rad = inf;
        if nargin < 4
            p = 2;
        end
    end
end

% Basic dimensions
N = size(X0,1); % Number of samples
M = size(X0,2); % Number of variables
Q = size(Xint,1); % Number of interpolation points
NbVar = size(F0,2);% nombre de variable a spatialiser

% Inverse distance weight output
Fint = zeros(Q,NbVar);
for ipos = 1:Q    
    % Distance matrix
    DeltaX = X0 - repmat(Xint(ipos,:),N,1);
    DabsL = zeros(size(DeltaX,1),1);
    for ncol = 1:M
        DabsL = DabsL + abs(DeltaX(:,ncol)).^L;
    end
    Dmat = DabsL.^(1/L);
    Dmat(Dmat==0) = eps;
    Dmat(Dmat>rad) = inf;
    
    % Weights
    W = 1./(Dmat.^p);
    
    % Interpolation
    for iVar = 1:NbVar
        Fint(ipos,iVar) = sum(W.*F0(:,iVar))/sum(W);
    end
end

end