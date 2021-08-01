% Supprime une particule du filtre
% AUTEUR : Jean Odry UdeS
% CREATION : 2018-12-21
%
% DESCRIPTION
%   Suppression d'une particule predeterminee du filtre
%
% ENTREES :
%   etats : etats du filtre 
%	poids : poidss associes aux particules
%	numPart : numero de la particule a supprimer
%   
%
% SORTIES
%   newEtats
%   newPoids
%   nbPart

function [newEtats, newPoids, newSold, nbPart] = SupprimerParticule(etats,poids,sold,numPart)
 	[nbPart, nbPix, nbMilieux] = size(etats.albedo);
    
    pl = 1:nbPart;
    pl(numPart) = [];
    
    newEtats.albedo = etats.albedo(pl,:);
	newEtats.chaleur_stock = etats.chaleur_stock(pl,:);
	newEtats.eau_retenue= etats.eau_retenue(pl,:);
	newEtats.stock_neige= etats.stock_neige(pl,:);
	newEtats.hauteur_neige= etats.hauteur_neige(pl,:);
    
    newSold = sold;
    if(~isnan(sold.pr))
        newSold.pr = sold.pr(pl,:);
    end
        
    if(~isnan(sold.tmin))
        newSold.tmin = sold.tmin(pl,:);
    end
    
    if(~isnan(sold.tmax))
        newSold.tmax = sold.tmax(pl,:);
    end
    
    if(~isnan(sold.sn))
        newSold.sn = sold.sn(pl,:);
    end
    
    nbPart = nbPart-1;
    
    newPoids = poids(pl,:);
    newPoids = newPoids./sum(newPoids);
end
