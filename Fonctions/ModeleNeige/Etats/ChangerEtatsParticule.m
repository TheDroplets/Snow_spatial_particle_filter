% Changer l'etat  d'une particule
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour changer l'etat d'un particule par un autre etat
%
% ENTREES :
%   etats (structure) : etat (NbPartXNbPixXNbMilieux)
%	particule (vecteur de integer) : le particule que l'on veut changer
%  	etatParticule : etat (NbPartX1XNbMilieux) qui remplace l'etat de particule
%
% SORTIES
%   etats : la structure ou seule la particule voulu a été modifié par etatParticule

function etats = ChangerEtatsParticule(etats,particule,etatParticule)
	etats.albedo(particule ,:,:)       = etatParticule.albedo;
	etats.chaleur_stock(particule,:,:) = etatParticule.chaleur_stock;
	etats.eau_retenue(particule,:,:)   = etatParticule.eau_retenue;
	etats.stock_neige(particule,:,:)   = etatParticule.stock_neige;
	etats.hauteur_neige(particule,:,:) = etatParticule.hauteur_neige;
end


