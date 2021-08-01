% Changer l'etat de toutes les particules 
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour changer l'etat de toutes les particules par un autre etat
%
% ENTREES :
%   etats (structure) : etat (NbPartXNbPixXNbMilieux)
%  	etatParticule : etat (1XNbNivoXNbMilieux) qui remplace l'etat de toutes les particules
%
% SORTIES
%   etats : la structure ou seule la particule voulu a été modifié par etatParticule

function etats = DupliquerEtats(etats,etatParticule)
	[NbPart,NbPix,NbMilieux] = size(etats.albedo);
	etats.albedo(: ,:,:)       = repmat(etatParticule.albedo,NbPart,1);
	etats.chaleur_stock(:,:,:) = repmat(etatParticule.chaleur_stock,NbPart,1);
	etats.eau_retenue(:,:,:)   = repmat(etatParticule.eau_retenue,NbPart,1);
	etats.stock_neige(:,:,:)   = repmat(etatParticule.stock_neige,NbPart,1);
	etats.hauteur_neige(:,:,:) = repmat(etatParticule.hauteur_neige,NbPart,1);
end


