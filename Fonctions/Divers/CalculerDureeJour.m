% Calculer la duree de jour en heure 
%
% AUTEUR : Philippe Cantet, UdeS
%
%
% DESCRIPTION
%   Calculer la duree de jour en heure en fonction de la latitude et du jour. 
%   On fait l'hypothese que l'equinoxe de printemps a lieu le 20 mars toutes les années.  
%
% ENTRÉES
%   lat : latitude en degres
%   dates : date en format date 
% SORTIES 
%   duree_jour : duree de jour de des dates en heure

function duree_jour = CalculerDureeJour(dates,lat)
% jour de l'equinoxe
jour_equinoxe = datetime(year(dates),03,20);
% jour apres l'equinoxe
jour_after = juliandate(dates) - juliandate(jour_equinoxe);
% on met en radian
lat = degtorad(lat); tmpjour = degtorad(72*jour_after/73) ; Cste = degtorad(23.44); 
A = sin(Cste) * sin(tmpjour);
B = asin(A);
C = tan(lat) .* tan(B);
duree_jour = 24 - 2/15 * radtodeg(acos(C));