% Extraire la valeur etat (celle du modele de Neige) sur un seul milieu 
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour créer un état ou il y a seulement un milieu que l'on choisit
%
% ENTREES :
%   etats (structure) : etat avec les NbMilieux milieux
%	milieu (integer) : le milieu voulu
%
% SORTIES
%   etats : la structure uniquement sur le milieu voulu 

function etats = ExtraireEtatsMilieu(etats,milieu)
	etats.albedo = etats.albedo(:, :, milieu);
	etats.chaleur_stock = etats.chaleur_stock(:, :,milieu);
	etats.eau_retenue= etats.eau_retenue(:, :,milieu );
	etats.stock_neige= etats.stock_neige(:, :, milieu);
	etats.hauteur_neige= etats.hauteur_neige(:, :, milieu);
end


