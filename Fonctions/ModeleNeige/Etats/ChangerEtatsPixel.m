% Changer l'etat  d'un pixel
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour changer l'etat d'un pixel par un autre etat
%
% ENTREES :
%   etats (structure) : etat (NbPartXNbPixXNbMilieux)
%	pixel (vecteur de integer) : le pixel que l'on veut changer
%  	etatPixel : etat (NbPartX1XNbMilieux) qui remplace l'etat de pixel
%
% SORTIES
%   etats : la structure ou seule la pixel voulu a été modifié par etatPixel

function etats = ChangerEtatsPixel(etats,pixel,etatPixel)
	etats.albedo(:,pixel ,:)       = etatPixel.albedo;
	etats.chaleur_stock(:,pixel,:) = etatPixel.chaleur_stock;
	etats.eau_retenue(:,pixel,:)   = etatPixel.eau_retenue;
	etats.stock_neige(:,pixel,:)   = etatPixel.stock_neige;
	etats.hauteur_neige(:,pixel,:) = etatPixel.hauteur_neige;
end


