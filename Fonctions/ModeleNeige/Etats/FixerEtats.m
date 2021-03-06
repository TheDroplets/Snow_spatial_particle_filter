% Fixer la valeur des 5 variables de la structure etat qui sert à faire tourner le modele de neige sur NbPartXNbPix pixels et NbMilieux milieux
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour fixer les 5 variables  de la structure etat utile  sur NbPartXNbPix pixels et et NbMilieux milieux
%
% ENTREES :
%   albedo (NbPartXNbPixXNbMilieux)
%	chaleur_stock (NbPartXNbPixXNbMilieux)
%	eau_retenue (NbPartXNbPixXNbMilieux)
%	stock_neige (NbPartXNbPixXNbMilieux)
%	hauteur_neige(NbPartXNbPixXNbMilieux)
%
% SORTIES
%   etats : la structure où la valeur est fixée sur les NbPartXNbPix pixels et NbMilieux milieux

function etats = FixerEtats(albedo,chaleur_stock,eau_retenue,stock_neige,hauteur_neige)
	[NbPart,NbPix,NbMilieux] = size(albedo);
	etats = CreerEtats(NbPart,NbPix,NbMilieux);
	etats.albedo = albedo;
	etats.chaleur_stock = chaleur_stock;
	etats.eau_retenue= eau_retenue;
	etats.stock_neige= stock_neige;
	etats.hauteur_neige= hauteur_neige;
end
