% Pour Perturber avec une loi uniforme  (bruit additif) avec une correlation temporelle et spatiale
%
% AUTEUR : Philippe Cantet, UdeS
% CREATION : 2017-11-15
%
% DESCRIPTION
%   On pertube  avec une loi uniforme avec une correlation temporelle et spatiale (Evensen1994 ou Clark2008) :
%   A l'instant t, Var' = phi(t) + var avec phi(t) suit U[-gamma,+gamma] et
%   phi(t) depend de phi(t-1) avec une correlation spatiale de type exp(-DIST.^2/L^2)
%   
% ENTREES :
%   Var (NbPart X NbPix X NbPDT) : la variable a pertuber pour NbPart
%   particules sur NbPix pixels et NbPDT pas de temps
%   lon : longitude des NbPix pixels
%   lat : latitude des NbPix pixels
%   gamma  : si reel (egale sur toutes les pixels) phi(t) suit U[1-gamma,1+gamma]  
%          ou mettre (lat X lon) pour le faire varier  
%	rho : correlation temporelle: si reel (egale sur toutes les pixels)   
%          ou mettre (lat X lon) pour le faire varier 
%   L : longeur en km de la correlation spatiale
%	sold (lat X lon) : la derniere perturbation (mettre NaN si pas de valeurs)
%
% SORTIES
%   Var (NbPart X NbPix X NbPDT): la variable perturbee
%	snew (NbPart X NbPix) : la derniere perturbation (pour faire tourner à la suite)
function [Var,snew] = PerturberSpatialTempAdditif(Var,lon,lat,gamma,rho,L,sold)
%transformation lat lon en UTM (pour calculer des vraies distance en metre
[x,y] = latlon2xy(lat,lon);
%distance entre les points
DIST = dist([x  y]');
% matrice de covariance spatiale 
COV = exp(-DIST.^2/L^2);
mu = zeros(1,numel(lon(:)));
[NbPart,NbPix,NbPDT] = size(Var);

for i = 1:NbPDT   
    if isnan(sold) 
        snew = mvnrnd(mu,COV,NbPart); 
    else
        bruit = mvnrnd(mu,COV,NbPart);
        snew = rho .* sold + sqrt(1-rho.^2).*bruit;
    end
    w = 0.5 * erfc(snew/sqrt(2));
    Var(:,:,i) = Var(:,:,i) + gamma .* (1 - 2.*w);
    sold=snew;
end