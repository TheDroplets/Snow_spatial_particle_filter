% Tranforme les vecteurs depixels en grille
% 
% AUTEUR : Jean Odry, UdeS
% CRÉATION : 2019-01-17
%
% DESCRIPTION
%   Replaces les valeurs d'un vecteur de pixels sur une grille
%
% ENTRÉES
%   val : (NbPDT, NbPix) valeurs a replacer sur une grille
%   Pix : description des pixels
%   grille : caracteristiques de la grille (lat, lon, masque)
%   
% 
%       
% SORTIES
%   grilleSortie(NbPDT, NbLat, NbLon)
%

function grilleSortie = Vect2Grille(val, Pix, Grille)
    

    [NbPDT, ~] = size(val);
    
    % dimensions de la grille voulue
    NbLat = length(Grille.Lat);
    NbLon = length(Grille.Lon);
    
    % initialisation de la grille finale
    grilleFinale = nan(NbPDT, NbLat, NbLon);
    
    % dans la grille, quels sont les pixels hors masque (i.e. ceux
        % présents dans val)
    Grille.val = 1:Grille.Nb;
    Grille.val(Grille.masque) = [];
    
    
    for ijour = 1:NbPDT
        tmp = nan(Grille.Nb, 1);
        tmp(Grille.val) = val(ijour, Pix.indGrille)'; % les pixels du masque sont laissés a na
        GrilleFinale(ijour,:,:) = reshape(tmp,NbLat,NbLon);
       
    end

  
    
end
 



