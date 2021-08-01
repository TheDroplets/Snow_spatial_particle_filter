% Calcule le CRPS en considerant uen observation normalement distribuee
% 
% AUTEUR : Jean Odry, UdeS
% CRÉATION : 2019-10-08
%
% DESCRIPTION
%   Calcule le CRPS entre un ensemble de particules (et leurs poids) et une
%   observation avec une incertitude decrite par une loi normale
%
% ENTRÉES
%   obs : vecteur des observations (n valeurs)
%   part : matrice decrivant l'ensemble des particules (n*m) avec m nombre
%       de particules
%   poids : poids des particules (n*m)
%   sigma : ecart type associe a l'incertitude des obs (n valeurs)
%   bornesX : valeurs min et max possibles de la variable (on calcule l'air
%       entre les cours sur cet intervalle, ne pas hésiter à prendre plus
%       large)
%   pasX : resolution de la variable (pas de calul des cdf)
%       
% SORTIES
%   CRPS : 
%
%
% MODIFICATIONS
%
function CRPS = CalculeCRPS2(obs, part, poids, sigmaObs, bornesX, pasX)
    [nbObs, ~] = size(part);
     CRPS = nan(nbObs,1);
     
     if length(sigmaObs) == 1
         sigmaObs = repelem(sigmaObs, nbObs);
     end
     
    for i = 1:nbObs
        if ~isnan(obs(i)) && all(~isnan(part(i,:)))
            
            %% definition de l'intervalle
            x = bornesX(1): pasX:bornesX(2);
            
            %% cdf de l'obs sur l'intervalle
            cdfObs = normcdf(x, obs(i), sigmaObs(i))';
            
            %% cdf de l'ensemble sur l'intervalle
            cdfPart = nan(length(x),1);
            
            % cdf de l'ensemble sur l'intervalle defini par les particules
            % poidsCum = f(valSorted)
            [valSorted, ord] = sort(part(i,:));
            poidsCum = cumsum(poids(i,ord));
            
            % la cdf est nulle pour les valeurs inferieurs à la plus petite
            % particule
            plInf = x < min(valSorted);
            cdfPart(plInf) = 0;
            
            %la cdf vaut 1 pour les valeurs supérieures à la particule la
            %plus forte
            plSup = x>max(valSorted);
            cdfPart(plSup) = 1;
            
            % valeurs de la cdf qudn x = valeur d'une ou plusieurs
            % particules
            plEq = find(ismember(x, valSorted));
            if ~isempty(plEq)
               
               for j = plEq
                  pos = find(valSorted == x(j),1,'last'); 
                  cdfPart(j) = poidsCum(pos);
               end
            end
            
            % valeurs de la cdf pour x entre deux particules
            plAutres = find(isnan(cdfPart));
            if ~isempty(plAutres)
                for j = plAutres'
                   posInf = find(valSorted <  x(j),1, 'last'); %position de la particule immediatement inférieur
                   a = (x(j) - valSorted(posInf))/ (valSorted(posInf+1)-valSorted(posInf));
                   cdfPart(j) = a*poidsCum(posInf) + (1-a)*poidsCum(posInf+1);
                end
            end

           
            % intégrale de l'écart au carré entre les courbes
            er = (cdfPart - cdfObs).^2;
            CRPS(i) = trapz(x,er);
%             aire1 = cumtrapz(valSorted, cdfPart); % integrale cumulative de la cdf des particules (ie aire sous la courbe pour chaque pas dEEN)
%             aire2 = cumtrapz(valSorted, cdfObs);
%             CRPS(i) = sum(abs(aire1-aire2));
        end
        
    end
end
   