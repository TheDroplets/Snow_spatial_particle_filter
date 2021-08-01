% Reconstruit une grille complete e
% 
% AUTEUR : Jean Odry, UdeS
% CRÉATION : 2019-08-06
%
% DESCRIPTION
%   Reconstruit une grille complete a partir d'un vecteur de valeurs et d'un
% masque
%
% ENTRÉES
%   Grille : caracteristiaues de la grille
%   val : valeurs a replacer dans la grille
%       
% SORTIES
%   grille_complete : grille contenant des na a la position du masque
%
%
% MODIFICATIONS
%
function  grille_complete = BuildGrilleMasque(Grille, val)
   
   [nbPdt, ~] = size(val); %nombre de pas de temps
   grille_complete = zeros(nbPdt, Grille.taille); %initialisation de la grille finale
   grille_complete(:, Grille.masque) = nan(1,1); %on place des na sur le masque
   pl = find(~isnan(grille_complete(1,:))) ; %position des pixels utiles
   grille_complete(:,pl) = val; %on place les valeurs sur les pixels utils
    
    
end

