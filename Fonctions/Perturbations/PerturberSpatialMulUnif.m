% on perturbe les etats de NbPart particules sur NbPix pixels avec une loi uniforme avec une correlation temporelle et spatiale
%
% AUTEUR : Philippe Cantet, UdeS
% CREATION : 2017-11-15
%
% DESCRIPTION
%   etape de mutation du filtre particulaire sur les etats de NbPart particules sur NbPix pixels, on applique une mutation de la forme etat_new = phi(t) * etat_old avec phi(t) suit U[1-gamma,1+gamma] et phi(t) depend de phi(t-1) avec une correlation spatiale de type exp(-DIST.^2/L^2), phi(t) est le meme pour tous les etats
%
% ENTREES :
%   etat (structure): etats des NbPart sur NbPix pixels : 5 variables d'etats de taille (NbPartXNbPixX3)
%   lon : longitude des NbPix pixels
%   lat : latitude des NbPix pixels
%   gamma  : si reel (egale sur toutes les pixels) phi(t) suit U[1-gamma,1+gamma]  
%          ou mettre (NbPartXNbPix) pour le faire varier  
%	rho : correlation temporelle: si reel (egale sur toutes les pixels)   
%          ou mettre (NbPartXNbPix) pour le faire varier 
%   L : longeur en km de la correlation spatiale
%	sold : la derniere perturbation (NbPartXNbPix) (mettre NaN si pas de valeurs)
%   
%
% SORTIES
%   etat (structure): etats mutes des NbPart sur NbPix pixels
%	snew (NbPart X NbPix) : la derniere perturbation (pour faire tourner à la suite)

function [etat,snew] = PerturberSpatialMulUnif(etat,lon,lat,gamma,rho,L,ratio,sold)
%transformation lat lon en UTM (pour calculer des vraies distance en kilometre
[x,y] = latlon2xy(lat,lon);
[NbPart,NbPix,NbMilieux] = size(etat.albedo);
% on limite le domaine
indKeep = 1:ratio:NbPix;
Xkeep = x(indKeep); Ykeep = y(indKeep); 
%distance entre les points
DIST = dist([Xkeep  Ykeep]');
% matrice de covariance spatiale 
COV = exp(-DIST.^2/L^2);
mu = zeros(1,numel(indKeep));

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
w = 0.5 * erfc(snew/sqrt(2));
pertub = ((1-gamma) + 2 * gamma .* w);

for iMilieu = 1:NbMilieux
	etat.albedo(:,:,iMilieu) = min(etat.albedo(:,:,iMilieu) .* pertub,1);
	etat.chaleur_stock(:,:,iMilieu) = etat.chaleur_stock(:,:,iMilieu) .* pertub;
	etat.eau_retenue(:,:,iMilieu) = etat.eau_retenue(:,:,iMilieu) .* pertub;
	etat.stock_neige(:,:,iMilieu) = max(etat.stock_neige(:,:,iMilieu).* pertub,0);
	etat.hauteur_neige(:,:,iMilieu) = max(etat.hauteur_neige(:,:,iMilieu).* pertub,0);
end
end 

