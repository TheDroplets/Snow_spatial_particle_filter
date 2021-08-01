% Pour Perturber avec une loi normale  (bruit additif) avec une correlation
% temporelle et spatiale où on indique la variance sur une grosse grille
% (sur une grosse grille la covariance est de trop grande taille donc on
% travaille que sur un tiers des points puis on applique griddata)
%
% AUTEUR : Philippe Cantet, UdeS
% CREATION : 2018-05-17
%
% DESCRIPTION
%   On pertube  avec une loi normale avec une correlation temporelle et spatiale (Evensen1994 ou Clark2008) :
%   A l'instant t, Var' = phi(t) + var avec phi(t) suit N(0,sigma2) et
%   phi(t) depend de phi(t-1) avec une correlation spatiale de type exp(-DIST.^2/L^2)
%   
% ENTREES :
%   Var (NbPart X NbPix X NbPDT) : la variable a pertuber pour NbPart
%   particules sur NbPix pixels et NbPDT pas de temps
%   lon : longitude des NbPix pixels
%   lat : latitude des NbPix pixels
%   sigma2 (NbPart X NbPix X NbPDT) : la variance de la loi
%   normale
%	rho : correlation temporelle: si reel (egale sur toutes les pixels)   
%          ou mettre (lat X lon) pour le faire varier 
%   L : longeur en km de la correlation spatiale
%   ratio : la proportion de pixels que l'on prend pour construire la
%   covoriance et snew (1=toute , 2=une sur 2,3=une sur 3)
%	sold (lat X lon) : la derniere perturbation (mettre NaN si pas de valeurs)
%
% SORTIES
%   Var (NbPart X NbPix X NbPDT): la variable perturbee
%	snew (NbPart X NbPix) : la derniere perturbation (pour faire tourner à la suite)
function [Var,snew] = PerturberSpatialAddSigma(Var,lon,lat,sigma2,rho,L,ratio,sold)
%transformation lat lon en UTM (pour calculer des vraies distance en kilometre
[x,y] = latlon2xy(lat,lon);
[NbPart,NbPix,NbPDT] = size(Var);
% on limite le domaine
indKeep = 1:ratio:NbPix;
Xkeep = x(indKeep); Ykeep = y(indKeep); 
%distance entre les points
DIST = dist([Xkeep  Ykeep]');
% matrice de covariance spatiale 
COV = exp(-DIST.^2/L^2);
mu = zeros(1,numel(indKeep));

for i = 1:NbPDT   
    if isnan(sold) 
        snew1 = mvnrnd(mu,COV,NbPart); 
    else
        bruit = mvnrnd(mu,COV,NbPart);
        sold1 = sold(:,indKeep);
        snew1 = rho .* sold1 + sqrt(1-rho.^2).*bruit;
    end
    % on remet sur le domaine complet
    if ratio ~=1
        snew = nan(NbPart,NbPix);
        for ipart = 1:NbPart
            snew(ipart,:)  = griddata(Xkeep,Ykeep,snew1(ipart,:),x,y,'natural');
        end
    else
        snew=snew1;
    end
    Var(:,:,i) = Var(:,:,i) + snew .* sqrt(sigma2(:,:,i));
    sold=snew;
end