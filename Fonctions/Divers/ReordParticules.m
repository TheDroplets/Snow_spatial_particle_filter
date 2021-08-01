% Reordonnement des particules
%
% AUTEUR : Jean Odry, UdeS
% CREATION : 2019-10-24
%
% DESCRIPTION
%   Les particules sont reorganisees selon l'ordre croissant de l'EEN
%   Chaque particule reste identique en chaque pixel(4 etats et poid) 
%   mais leur ordre change
%
% ENTREES :
%	etats : etats du modele
%   poids (NbPart, NbPix) : poids des particules
%   sold (NbPart, NbPix) : perturbations qui doit subir le meme
%       rearrangement
%   av (NbPart, NbPix) : perturbations qui doit subir le meme
%       rearrangement
%
% SORTIES
%   etatsSS : etats rearranges
%   soldSS : perturbations rearrangees
%   poidsSS : poids rearranges
%   avSS : av rearranges

function [etatsSS, poidsSS,  avSS] = ReordParticules(etats, poids, av)
    % initialisation des sortie
    etatsSS = etats;
    poidsSS = poids;
    if nargin ==3
        avSS = av;
    end

   
        
    [nbPart, nbPix] = size(poids);
     
     % ordonnement des particules
     EEN = etats.stock_neige; %a un facteur pres, mais on s'en moque on veut juste l'ordre des particules
     [~, ord] = sort(EEN);
     
     % ordonnement de sparticules pixels par pixels
    for iSite = 1:nbPix
        xSorted = etats.chaleur_stock(ord(:, iSite),iSite); % tri des particules dans l'ordre croissant
        etatsSS.chaleur_stock(:,iSite) = xSorted; % reordonnement
        
        xSorted = etats.eau_retenue(ord(:, iSite),iSite);
        etatsSS.eau_retenue(:,iSite) = xSorted;
        
        xSorted = etats.stock_neige(ord(:, iSite),iSite);
        etatsSS.stock_neige(:,iSite) = xSorted;
        
        xSorted = etats.hauteur_neige(ord(:, iSite),iSite);
        etatsSS.hauteur_neige(:,iSite) = xSorted;
        
        xSorted = etats.albedo(ord(:, iSite),iSite);
        etatsSS.albedo(:,iSite) = xSorted;
        
        xSorted = poids(ord(:, iSite),iSite);
        poidsSS(:,iSite) = xSorted;
        
        % shuffle des AV
        if nargin ==3
             xSorted = av(ord(:, iSite),iSite);
             avSS(:,iSite) = xSorted;  
        end
        
       
    end

end
