% Reechantilloner les poids de NbPart particules selon la methode Weighted Random Resampling de Leisenring2011 page 7
%
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-07-26
%
% DESCRIPTION
%   etape de reechantillonage du Filtre WRR sur les poids des NbPart particules
%
% ENTREES :
%	poids (NbPartX1) : poids des NbPart particules 
%
% SORTIES
%   offsprings (NbPartX1) : offsprings(i,1) indique le nombre de fois que la particule i est choisi par reechantillonage pour la pixel j
% NOTES :  normalise les poids -ie- sum(poids) == 1

function offsprings = ReechantillonerWRR(poids)

NbPart = length(poids);
offsprings = zeros(NbPart,1);
C = cumsum(poids);
for j = 1:NbPart
	threshold = rand;
  	i = 1;
  	while C(i)<threshold, i = i+1; end
  	offsprings(i) = offsprings(i)+1;
end





