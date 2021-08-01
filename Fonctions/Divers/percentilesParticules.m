% Calcule les percentiles d'un ensemble en fonction des poids de chaque
% mmbre
% 
% AUTEUR : Jean Odry, UdeS
% CRÉATION : 2019-09-23
%
% DESCRIPTION
%   Calcule les percentiles d'un ensemble en fonction des poids de chaque
% mmbre
%
% ENTRÉES
%   val (nbPart, nbSites): valeur des membres
%   poids (nbPart, nbSites): poids des membres
%   perc : percentiles a calculer, par defaut 0.5 (mediane)
%       
% SORTIES
%   MAE : mean absolute error
%
%
% MODIFICATIONS
%
function percent = percentilesParticules(val, poids, perc)
    
    if nargin < 3
        perc = 0.5;
    end
    
    [nbPart, nbSites] = size(val);
    
    percent = nan(nbSites,1);
    
    for iSite = 1:nbSites
       [valS, ord] = sort(val(:,iSite));
       poidsS = poids(ord,iSite);
       poidsScum = cumsum(poidsS);
       
       if perc == 1
           percent(iSite) = max(valS);
       else
           plage = find(round(poidsScum,6) >= 1-perc);
           pos = plage(1);
           percent(iSite) = valS(pos);
       end
    end

    
    
end

