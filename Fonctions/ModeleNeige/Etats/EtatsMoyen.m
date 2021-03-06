% Calculer la moyenne d'un etat, on a le choix sur quel sens on calcule la moyenne (milieu,particules ou pixels)
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour créer un état ou il y a seulement les moyennes sur une direction 
%
% ENTREES :
%   etats (structure) : etat avec pour chaque champs les NbPartXNbPixXNbMilieux milieux
%	sens (integer) : pour dire si la moyenne est calculer sur les particules (1), sur les pixels (2), sur les milieux (3)
%
% SORTIES
%   etats : la structure uniquement sur le milieu voulu 

function etats = EtatsMoyen(etats,sens)
	etats.albedo = mean(etats.albedo(:, :, :),sens);
	etats.chaleur_stock = mean(etats.chaleur_stock(:, :,:),sens);
	etats.eau_retenue= mean(etats.eau_retenue(:, :,:),sens);
	etats.stock_neige= mean(etats.stock_neige(:, :, :),sens);
	etats.hauteur_neige= mean(etats.hauteur_neige(:, :,:),sens);
end
