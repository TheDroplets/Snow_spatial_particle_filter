%   Transformer une matrice en un etat  
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-06-26
%
% DESCRIPTION
%	Transformer une matrice de taille (NbPart,5*NbPix) en un etat avec etats.albedo de taille NbPartXNbPixX1
%
% ENTREES :
%   Mat : Matrice (NbPart,5*NbPix)
%
% SORTIES
%   etat (structure) : etat avec pour chaque champs de taille NbPartXNbPixX1  


function etat = MatToEtat(Mat)
	[NbPart,tmp] = size(Mat);
	NbPix=tmp/5;
	etat = CreerEtats(NbPart,NbPix,1);
	for (ipix = 1:NbPix)
		etat.albedo(:,ipix,:)       = Mat(:,1 + 5*(ipix-1)) ;
		etat.chaleur_stock(:,ipix,:)= Mat(:,2 + 5*(ipix-1)) ;
		etat.eau_retenue(:,ipix,:)  = Mat(:,3 + 5*(ipix-1)) ;
		etat.stock_neige(:,ipix,:)	= Mat(:,4 + 5*(ipix-1)) ;
		etat.hauteur_neige(:,ipix,:)= Mat(:,5 + 5*(ipix-1)) ;
	end
end
