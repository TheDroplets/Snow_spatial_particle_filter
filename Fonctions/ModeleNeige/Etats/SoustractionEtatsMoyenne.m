% Faire la soustraction sur tous les champs de la structure etat avec sa moyenne, on a le choix sur quel sens on calcule la moyenne (milieu,particules ou pixels) (milieu,particules ou pixels)
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%   Pour faire  etat - moyenne (sur un sens) sur tous les champs de etat
% ENTREES :
%   etat (structure) : etat avec pour chaque champs les NbPartXNbPixXNbMilieux 
%	sens (integer) : pour dire si la moyenne est calculer sur les particules (1), sur les pixels (2), sur les milieux (3)
%
% SORTIES
%   etat : la structure etat - moyenne 

function etat = SoustractionEtatsMoyenne(etat,sens)
	tmp = size(etat.stock_neige);
	NN = tmp(sens);
	etatMoy = EtatsMoyen(etat,sens);
	etat.albedo = etat.albedo - repelem(etatMoy.albedo,NN,sens);
	etat.chaleur_stock = etat.chaleur_stock - repelem(etatMoy.chaleur_stock,NN,sens);
	etat.eau_retenue = etat.eau_retenue - repelem(etatMoy.eau_retenue,NN,sens);
	etat.stock_neige = etat.stock_neige - repelem(etatMoy.stock_neige,NN,sens);
	etat.hauteur_neige = etat.hauteur_neige - repelem(etatMoy.hauteur_neige,NN,sens);
end
