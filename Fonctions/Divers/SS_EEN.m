% Schaake shuffle sur les particules du filtre
%
% AUTEUR : Jean Odry, UdeS
% CREATION : 2019-01-16
%
% DESCRIPTION
%   Les particules sont reorganisees selon l'historiaue d'EEN
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
%   histoEEN (NbPart, NbPix) : historique d'EEN
%
% SORTIES
%   etatsSS : etats rearranges
%   soldSS : perturbations rearrangees
%   poidsSS : poids rearranges
%   avSS : av rearranges
% NOTES :  cf. Clark et al. 2004, The Schaake Shuffle: A Method for Reconstructing Space–Time Variability in Forecasted Precipitation and Temperature Fields
function [etatsSS, poidsSS,  avSS, soldSS] = SS_EEN(etats, poids,  histoEEN, av, sold)
    
    
    
    % initialisation des sortie
    etatsSS = etats;
    poidsSS = poids;
    if nargin >=4
        avSS = av;
    end
    if nargin ==5
        soldSS = sold;
    end
    
%     [etatsSS.albedo, B] = SchaakeShuffle(etats.albedo, histoEEN);
%     [etatsSS.chaleur_stock, ~] = SchaakeShuffle(etats.chaleur_stock, histoEEN);
%     [etatsSS.eau_retenue, ~] = SchaakeShuffle(etats.eau_retenue, histoEEN);
%     [etatsSS.stock_neige, B1] = SchaakeShuffle(etats.stock_neige, histoEEN);
%     [etatsSS.hauteur_neige, ~] = SchaakeShuffle(etats.hauteur_neige, histoEEN);
%     
%     [poidsSS, B2] = SchaakeShuffle(poids, histoEEN);
%     
%      [soldSS.pr, ~] = SchaakeShuffle(sold.pr, histoEEN);
%      [soldSS.tmin, ~] = SchaakeShuffle(sold.tmin, histoEEN);
%     [soldSS.sn, B3] = SchaakeShuffle(sold.sn, histoEEN);
%     
  
        
    [nbPart, nbPix] = size(poids);
     % vecteur du schaake schuffle
     [~, B] = sort(histoEEN);
     
     % ordonnement des particules
     EEN = etats.stock_neige; %a un facteur pres, mais on s'en moque on veut juste l'ordre des particules
     [~, ord] = sort(EEN);
     
     % ordonnement de sparticules pixels par pixels
    for iSite = 1:nbPix
        xSorted = etats.chaleur_stock(ord(:, iSite),iSite); % tri des particules dans l'ordre croissant
        etatsSS.chaleur_stock(B(:,iSite),iSite) = xSorted; % reordonnement SS
        
        xSorted = etats.eau_retenue(ord(:, iSite),iSite);
        etatsSS.eau_retenue(B(:,iSite),iSite) = xSorted;
        
        xSorted = etats.stock_neige(ord(:, iSite),iSite);
        etatsSS.stock_neige(B(:,iSite),iSite) = xSorted;
        
        xSorted = etats.hauteur_neige(ord(:, iSite),iSite);
        etatsSS.hauteur_neige(B(:,iSite),iSite) = xSorted;
        
        xSorted = etats.albedo(ord(:, iSite),iSite);
        etatsSS.albedo(B(:,iSite),iSite) = xSorted;
        
        xSorted = poids(ord(:, iSite),iSite);
        poidsSS(B(:,iSite),iSite) = xSorted;
        
        % shuffle des AV
        if nargin >=4
             xSorted = av(ord(:, iSite),iSite);
             avSS(B(:,iSite),iSite) = xSorted;  
        end
        
        % shuffle des sold
        if nargin >=5
             xSorted = sold.pr(ord(:, iSite),iSite);
             soldSS.pr(B(:,iSite),iSite) = xSorted;
             
             xSorted = sold.tmin(ord(:, iSite),iSite);
             soldSS.tmin(B(:,iSite),iSite) = xSorted;
             if ~isnan(sold.tmax)
                 xSorted = sold.tmax(ord(:, iSite),iSite);
                 soldSS.tmax(B(:,iSite),iSite) = xSorted;
             end
             
             xSorted = sold.sn(ord(:, iSite),iSite);
             soldSS.sn(B(:,iSite),iSite) = xSorted;
        end
    end

end
