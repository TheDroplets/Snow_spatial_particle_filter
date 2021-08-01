% Changer l'etat  d'un milieu
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour changer l'etat d'un milieu par un autre etat
%
% ENTREES :
%   etats (structure) : etat (NbPartXNbPixXNbMilieux) de depart
%	milieu (integer) : le milieu de etats que l'on veut changer
%  	etatMilieu : etat (NbPartXNbPixX1) qui remplacwe le milieu de etats
%
% SORTIES
%   etats : la structure ou seule le milieu voulu a été modifié par etatMilieu

function etats = ChangerEtatsMilieu(etats,milieu,etatMilieu)
	etats.albedo(:, :, milieu) = etatMilieu.albedo;
	etats.chaleur_stock(:, :,milieu) = etatMilieu.chaleur_stock;
	etats.eau_retenue(:, :,milieu)= etatMilieu.eau_retenue;
	etats.stock_neige(:, :, milieu)= etatMilieu.stock_neige;
	etats.hauteur_neige(:, :,milieu)= etatMilieu.hauteur_neige;
end


