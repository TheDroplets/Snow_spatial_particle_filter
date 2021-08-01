% Reechantilloner les poids de NbPart particules selon la methode SIR de Moradkani2005 page 7
%
% AUTEUR : Philippe Cantet, UQAC
% CREATION : 2017-07-26
%
% DESCRIPTION
%   etape de reechantillonage du Filtre SIR sur les poids des NbPart particules
%
% ENTREES :
%	poids (NbPartX1) : poids des NbPart particules 
%
% SORTIES
%   offsprings (NbPartX1) : offsprings(i,1) indique le nombre de fois que la particule i est choisi par reechantillonage pour la pixel j
% NOTES :  normalise les poids -ie- sum(poids) == 1

function offsprings = ReechantillonerSIR(poids)

NbPart = length(poids);
offsprings = zeros(NbPart,1);
C = cumsum(poids);
u1 = 0 + (1/NbPart - 0) * rand;
U = repmat(u1,NbPart,1) + repmat(1/NbPart * ((1:NbPart)-1),1,1)';
i=1;
for j = 1:NbPart
	while C(i)<U(j) 
		i=i+1;
	end
	offsprings(i) = offsprings(i) + 1; 
end





