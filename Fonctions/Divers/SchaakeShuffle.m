% Schaake shuffle : rearrangement de l'ordre des membres d'un sensemble
%
% AUTEUR : Jean Odry, UdeS
% CREATION : 2019-01-16
%
% DESCRIPTION
%   Les membres de l'ensemble X sont reorganises selon l'historique Y
%
% ENTREES :
%	X (NbMembres, NbSites) : membres a reorganiser
%   Y (NbMembres, NbSites) : historique de valeurs 
%
% SORTIES
%   Xss (NbMembres, NbSites) : membres rearranges
%   B (NbMembres, NbSites) : vecteur de rearrangement
% NOTES :  cf. Clark et al. 2004, The Schaake Shuffle: A Method for Reconstructing Space–Time Variability in Forecasted Precipitation and Temperature Fields
function [Xss, B] = SchaakeShuffle(X, Y)
    [nbMembres, nbSites] = size(X);
    Xss =   nan(nbMembres,nbSites);  
    
    Xsorted = sort(X);
    [~, B] = sort(Y);
    
    for iSite = 1:nbSites
        Xss(B(:,iSite),iSite) = Xsorted(:,iSite);
    end

end

