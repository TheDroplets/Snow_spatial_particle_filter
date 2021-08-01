%   pour charger les donnees Site (observations et info sur sites)
% ENTREES :
%   - caldate : NbPDT dates en format date où on veut les observations
%   - file_sites : fichier .csv où il y a les sites (entete Num;Nom;Lat;Lon;Alt + NbSites lignes)
%   - file_obs : fichier contenant toutes les obs SR50 converties (.mat) Date;NS000F;CS1;NSD000F;CS2;NSQ000F;CS3)
%
% SORTIES
%   - InfoSite (strucuture avec Num,Nom,Lon,Lat,Alt des NbSites) (on enleve
%   ceux qui n'ont pas d'obs)
%   - EEN (NbPDT,NbSites) : EEN sur les NbPDT pas de temps sur les NbSites
%   - Haut (NbPDT,NbSites) : Hauteurs sur les NbPDT pas de temps sur les NbSites
%   - Dens (NbPDT,NbSites) : Densites sur les NbPDT pas de temps sur les NbSites

function [InfoSites,EEN,Haut,Dens] = ExtractNeige(caldate,file_sites,file_obs)

%% liste des stations
load(file_sites);
InfoSites = tableSR50;
InfoSites = InfoSites(:,1:6); 
InfoSites.Properties.VariableNames = {'Num', 'Nom', 'Lat', 'Lon', 'Alt', 'Type'};
[NbSites,~] = size(InfoSites);



%% liste des releves
load(file_obs); %relevesSR50RN

%% initialisation
NbPdt= length(caldate);
Dens = NaN(NbPdt,NbSites);
Haut = NaN(NbPdt,NbSites);
EEN = NaN(NbPdt,NbSites);

for (iSite = 1:NbSites)
        pl = relevesSR50RN.NO_STATION_CLIMATO == InfoSites.Num(iSite);
        Site = relevesSR50RN(pl,:);
        if (~isempty(Site))
            date.Site = datetime(Site.Date);
                       
            % on remplit quand les dates sont communes a caldate
            [~,ind.tmp] = ismember(caldate,date.Site);
            ind.date = ind.tmp(find(ind.tmp));
            [~,ind.tmp] = ismember(date.Site,caldate);
            ind.date2 = ind.tmp(find(ind.tmp));
            
            % on remplit quand les dates sont communes a caldate
            Dens(ind.date2,iSite) = Site.Densite(ind.date);
            Haut(ind.date2,iSite) = Site.Hauteur(ind.date);
            EEN(ind.date2,iSite) = Site.EEN(ind.date);
            clear ind Site
        end
end







