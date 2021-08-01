% Extraire la valeur etat (celle du modele de Neige) sur une seule pixel 
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour créer un état ou il y a seulement une que l'on choisit
%
% ENTREES :
%   etats (structure) : etat avec les champs de taille NbPartXNbPixXNbMilieux
%	pixel (integer) : la pixel voulue
%
% SORTIES
%   etats : la structure uniquement sur la pixel voulu 

function etats = ExtraireEtatsPixel(etats,pixel)
	etats.albedo = etats.albedo(:, pixel, :);
	etats.chaleur_stock = etats.chaleur_stock(:, pixel,:);
	etats.eau_retenue= etats.eau_retenue(:, pixel,: );
	etats.stock_neige= etats.stock_neige(:, pixel,:);
	etats.hauteur_neige= etats.hauteur_neige(:, pixel, :);
end
