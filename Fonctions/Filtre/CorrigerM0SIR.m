% Faire l'etape de correction du filtre SIR sur NbPix pixels
% on suppose que la fonction observation est h(x) = x 
%
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   etape de correction du filtre SIR a l'aide d'observations sur NbPix pixels
%
% ENTREES :
%   etat (NbPartXNbPix): etats de la variables d etats des NbPart
%               particules sur les NbPix      
%   poids (NbPartXNbPix): poids des NbPart particules sur les NbPix
%   obs (1XNbPix) : observation de la varialbe d'etats sur les NbPix (si nan on ne fait pas de correction sur la pixel)
%   sigmaOBS (1XNbPix): l'ecart type du bruit gaussien des observations sur les NbPix
%   
%
% SORTIES
%   poids (NbPartXNbPix) : poids des NbPart particules apres assimilation pour les NbPix pixels

function poids = CorrigerM0SIR(etat,poids,obs,sigmaOBS)
[NbPart,NbPix] = size(etat);
tmp.sigmaOBS = repelem(sigmaOBS,NbPart,1);
pix_obs = find(~isnan(obs)); %% pixels ou il y a une observation
poids(:,pix_obs) =  poids(:,pix_obs).* exp(-1./(tmp.sigmaOBS(:,pix_obs)).^2 .* (etat(:,pix_obs) - repmat(obs(1,pix_obs),NbPart,1)).^2);
%poids =  poids.* exp(-1./(tmp.sigmaOBS).^2 .* (etat - repmat(obs,NbPart,1)).^2);
poids = poids./sum(poids);
end 


