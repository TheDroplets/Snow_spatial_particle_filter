% Pour Perturber avec une loi normale  (bruit additif) où on indique la variance sigma2 avec une correlation
% temporelle et spatiale qui est definie par la matrice de Choleski
% 
%
% AUTEUR : Philippe Cantet, UdeS
% CREATION : 2018-05-17
%
% DESCRIPTION
%   On pertube  avec une loi normale avec une correlation temporelle et spatiale (Evensen1994 ou Clark2008) :
%   A l'instant t, Var' = phi(t) + var avec phi(t) suit N(0,sigma2) et
%   phi(t) depend de phi(t-1) avec une correlation spatiale definie par la
%   matrice Choleski (cho = chol(COV))
%   
% ENTREES :
%   Var (NbPart X NbPix X NbPDT) : la variable a pertuber pour NbPart
%   Var2 (NbPart X NbPix X NbPDT) : une variable qui est perturbee comme Var
%   exactement comme
%   particules sur NbPix pixels et NbPDT pas de temps
%   sigma2 (NbPart X NbPix X NbPDT) : la variance de la loi
%   normale
%	rho : correlation temporelle: si reel (egale sur toutes les pixels)   
%          ou mettre (lat X lon) pour le faire varier 
%   cho : matrice de Choleski estimé à partir de la matrice de covariance (qui doit être definie positive) cho = chol(COV)
%	sold (lat X lon) : la derniere perturbation (mettre NaN si pas de valeurs)
%
% SORTIES
%   Var (NbPart X NbPix X NbPDT): la variable perturbee
%	snew (NbPart X NbPix) : la derniere perturbation (pour faire tourner à la suite)
function [Var,Var2,snew] = PerturberSpatialAddSigmaChol(Var,Var2,sigma2,rho,cho,sold)
[NbPart,NbPix,NbPDT] = size(Var);
for i = 1:NbPDT   % on parcourt les particules
    if isnan(sold) % pas d'etat precedent
        snew = randn(NbPart,NbPix)*cho; %buit normal avec dependance spatiale
    else
        bruit = randn(NbPart,NbPix)*cho;
        snew = rho .* sold + sqrt(1-rho.^2).*bruit;
    end
    ADD = snew .* sqrt(sigma2(:,:,i));
    Var(:,:,i) = Var(:,:,i) + ADD;
    if (~isnan(Var2))
        Var2(:,:,i) = Var2(:,:,i) + ADD;
    end
    sold=snew;
end