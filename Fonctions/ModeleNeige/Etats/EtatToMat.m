%   Transformer un etat en matrice   
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%	Transformer un etat avec etats.albedo de taille NbPartXNbPixX1 en une matrice ][NbPartX5*NbPix]
%
% ENTREES :
%   etat (structure) : etat avec pour chaque champs de taille NbPartX1X1
%
% SORTIES
%   Mat : Matrice (NbPart,5*NbPix)  


function Mat = EtatToMat(etat)
	[NbPart,NbPix,NbMilieux] = size(etat.stock_neige);
	Mat = nan(NbPart,5*NbPix);
	for (ipix = 1:NbPix)
		Mat(:,1 + 5*(ipix-1)) = etat.albedo(:,ipix,:);
		Mat(:,2 + 5*(ipix-1)) = etat.chaleur_stock(:,ipix,:);
		Mat(:,3 + 5*(ipix-1)) = etat.eau_retenue(:,ipix,:);
		Mat(:,4 + 5*(ipix-1)) = etat.stock_neige(:,ipix,:);
		Mat(:,5 + 5*(ipix-1)) = etat.hauteur_neige(:,ipix,:);
	end
end
