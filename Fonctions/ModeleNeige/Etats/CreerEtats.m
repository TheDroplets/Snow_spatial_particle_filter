% Créer la structure pour faire tourner le modele de neige sur NbPartXNbPix pixels et NbMilieux milieux
% les valeurs initiales sont toutes fixées à 0 sauf pour l'albedo = 0.15
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Création de la structure utile pour faire tourner le modèle de neige sur NbPartXNbPix pixels et et NbMilieux milieux
%
% ENTREES :
%   NbPart : Nombre de Particules  
%	NbPix : Nombre de Pixels
%	NbMilieux : Nombre de milieux
%   
%
% SORTIES
%   etat0 : la structure pour faire tourner le modele de neige initialisé à 0 partout sauf albedo à 0.15 sur NbPartXNbPix pixels et NbMilieux milieux

function etats0 = CreerEtats(NbPart,NbPix,NbMilieux)
	etats0.albedo = 0.15 * ones(NbPart,NbPix,NbMilieux);
	etats0.chaleur_stock = zeros(NbPart,NbPix,NbMilieux);
	etats0.eau_retenue= zeros(NbPart,NbPix,NbMilieux);
	etats0.stock_neige= zeros(NbPart,NbPix,NbMilieux);
	etats0.hauteur_neige= zeros(NbPart,NbPix,NbMilieux);
end
