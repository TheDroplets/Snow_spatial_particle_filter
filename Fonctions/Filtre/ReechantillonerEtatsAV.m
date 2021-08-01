% Reechantilloner les etats des NbPart particules 
%
% AUTEUR : Philippe Cantet, Udes
% CREATION : 2018-05-18
%
% DESCRIPTION
%   etape de reechantillonage du Filtre particulaire sur les etats des NbPart particules 
%
% ENTREES :
%   -etat (structure): etats des NbPart sur NbPix pixels : 5 variables d'etats de taille (NbPartXNbPixXNbMilieux)
%   -av  (NbPartXNbPixXNbMilieux): matrice qui subit le meme
%   reechantillonnage que les etats par exemple apport vertical (mettre
%   nan si pas besoin)
%	-poids (NbPartXNbPix) : poids des NbPart sur NbPix pixels  
%   -milieux (vecteur) : avec les mileux que l'on veut reechantilloner = 1:3 pour faire les 3 
%   -methode (caracteres) : nom de la methode de reechantillonage ('RES','SIR','WRR') (si ajout renseigner choix_methodes)
%	-seuilNeff (double) : seuil pour declancher le reechantillonage 
%
% SORTIES
%   etat (structure): etats reechantillonnes des NbPart sur NbPix pixels
%   poids (NbPartXNbPix) : poids reechantillonnes des NbPart sur NbPix pixels
% NOTES :  normalise les poids -ie- sum(poids) == 1
%          si ajout renseigner choix_methodes

function [etat,av,poids] = ReechantillonerEtatsAV(etat,av,poids,milieux,methode,seuilNeff)

[NbPart,NbPix] = size(poids);
% normalisation des poids 
%poids = poids ./ repelem(sum(poids,1),NbPart,1);
poids = poids./sum(poids);
choix_methodes = {'RES','WRR','SIR'};
% on regarde si methode fait partie des methodes implementees 
methodeOK = sum(strcmp(methode,choix_methodes));

if (methodeOK ==1)
	if strcmp(methode,'RES') TmpReechantilloner = @ReechantillonerResidu; end
	if strcmp(methode,'WRR') TmpReechantilloner = @ReechantillonerWRR; end
	if strcmp(methode,'SIR') TmpReechantilloner = @ReechantillonerSIR; end
	for imilieu = milieux
		for ipix = 1:NbPix 
			Neff = 1/sum(poids(:,ipix).^2);
		    if Neff/NbPart < seuilNeff %% test sur le nombre efficace de particules
				% particules qui se multiplient ou disparaissent selon l'algorithme de reechantillonage
				offsprings = TmpReechantilloner(poids(:,ipix));
				ind_tofill = find(offsprings==0);
				ind_tomut = find(offsprings>0);
				reech = nan(NbPart ,1);
				reech(ind_tomut) = ind_tomut;
				for i = 1:length(ind_tomut)
					ii = ind_tomut(i);
					nb_mut = offsprings(ii)-1;
					offsprings(ind_tofill(1:nb_mut)) = 1;
					reech(ind_tofill(1:nb_mut)) = repelem(ii,nb_mut,1);
					ind_tofill = find(offsprings==0); 
				end
				% on change l'etat pour les variables 
				etat.albedo(:, ipix, imilieu) = etat.albedo(reech, ipix, imilieu);
				etat.chaleur_stock(:, ipix, imilieu) = etat.chaleur_stock(reech, ipix, imilieu);
				etat.eau_retenue(:, ipix, imilieu) = etat.eau_retenue(reech, ipix, imilieu);
				etat.stock_neige(:, ipix, imilieu) = etat.stock_neige(reech, ipix, imilieu);
				etat.hauteur_neige(:, ipix, imilieu) = etat.hauteur_neige(reech, ipix,imilieu);
                if (~isnan(av))
                    av(:,ipix, imilieu) = av(reech, ipix,imilieu);
                end
				poids(:,ipix) = 1./NbPart .* ones(NbPart,1);
		    end
		end 
	end
	%poids = 1/NbPart .* ones(NbPart,NbPix);
else
	warning('methode de reechantillonage n existe pas')
end
end



