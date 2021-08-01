% on perturbe les etats de NbPart particules sur NbPix pixels avec une loi uniforme (bruit multiplicatif) avec une correlation temporelle et spatiale qui est definie par la matrice de Choleski
% 
%
% AUTEUR : Philippe Cantet, UdeS
% CREATION : 2018-05-17
%
% DESCRIPTION
%   Perturbation  sur les etats de NbPart particules sur NbPix pixels,
%   on applique une mutation de la forme etat_new = phi(t) * etat_old avec phi(t) suit U[1-gamma,1+gamma] 
%   phi(t) depend de phi(t-1) avec une correlation spatiale  definie par la matrice Choleski (cho = chol(COV)), 
%   phi(t) est le meme pour tous les etats une correlation spatiale definie par la
%   
% ENTREES :
%   etat (structure): etats des NbPart sur NbPix pixels : 5 variables d'etats de taille (NbPartXNbPixX3)
%   gamma  : si reel (egale sur toutes les pixels) phi(t) suit U[1-gamma,1+gamma]  
%          ou mettre (NbPartXNbPix) pour le faire varier  
%	rho : correlation temporelle: si reel (egale sur toutes les pixels)   
%          ou mettre (NbPartXNbPix) pour le faire varier 
%   L : longeur en km de la correlation spatiale
%   cho : matrice de Choleski estimé à partir de la matrice de covariance (qui doit être definie positive) cho = chol(COV)
%	sold (NbPart X NbPix) : la derniere perturbation (mettre NaN si pas de valeurs
%
% SORTIES
%   etat (structure): etats mutes des NbPart sur NbPix pixels
%	snew (NbPart X NbPix) : la derniere perturbation (pour faire tourner Ã  la suite)
function [etat,snew] = PerturberSpatialEtatMulUnifChol(etat,gamma,rho,cho,sold)
[NbPart,NbPix,NbMilieux] = size(etat.albedo);

if isnan(sold) 
    snew = randn(NbPart,NbPix)*cho; 
else
    bruit = randn(NbPart,NbPix)*cho;
    snew = rho .* sold + sqrt(1-rho.^2).*bruit;
end
w = 0.5 * erfc(snew/sqrt(2)); % normcdf(snew)
pertub = ((1-gamma) + 2 * gamma .* w);

for iMilieu = 1:NbMilieux
	etat.albedo(:,:,iMilieu) = min(etat.albedo(:,:,iMilieu) .* pertub,1);
	etat.chaleur_stock(:,:,iMilieu) = etat.chaleur_stock(:,:,iMilieu) .* pertub;
	etat.eau_retenue(:,:,iMilieu) = etat.eau_retenue(:,:,iMilieu) .* pertub;
	etat.stock_neige(:,:,iMilieu) = max(etat.stock_neige(:,:,iMilieu).* pertub,0);
	etat.hauteur_neige(:,:,iMilieu) = max(etat.hauteur_neige(:,:,iMilieu).* pertub,0);
end
