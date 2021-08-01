%   pour charger les donnees Site (observations et info sur sites)
% ENTREES :
%   - caldate : NbPDT dates en format date où on veut les observations
%   - file_sites : fichier .csv où il y a les sites (entete Num;Nom;Lat;Lon;Alt + NbSites lignes)
%   - folder_obs : dossier ou il y a les observations, un fichier Num.csv par
%   site  avec entete Date;NS000F;CS1;NSD000F;CS2;NSQ000F;CS3)
%
% SORTIES
%   - InfoSite (strucuture avec Num,Nom,Lon,Lat,Alt des NbSites) (on enleve
%   ceux qui n'ont pas d'obs)
%   - EEN (NbPDT,NbSites) : EEN sur les NbPDT pas de temps sur les NbSites
%   - Haut (NbPDT,NbSites) : Hauteurs sur les NbPDT pas de temps sur les NbSites
%   - Dens (NbPDT,NbSites) : Densites sur les NbPDT pas de temps sur les NbSites

function [InfoSites,EEN,Haut,Dens] = ExtractNeige(caldate,file_sites,folder_obs)

InfoSites = readtable(file_sites,'Format','%s%s%f%f%f');
[NbSites,~] = size(InfoSites);
InfoSites.Type = repmat("nivo", NbSites,1);

NbPdt= length(caldate);

Dens = NaN(NbPdt,NbSites);
Haut = NaN(NbPdt,NbSites);
EEN = NaN(NbPdt,NbSites);

for (iSite = 1:NbSites)
        fich = [folder_obs,char(InfoSites.Num(iSite)),'.csv'];
        Site = readtable(fich,'TreatAsEmpty','NA');
        if (~isempty(Site))
            date.Site = datetime(Site.Date);
            %on met a NaN les valeurs avec STATUT d'approbation ~=1
            ind.appr = Site.CS1 ~= 1;
            Site.NS000F(ind.appr) = NaN ; Site.NSQ000F(ind.appr) = NaN ; Site.NSD000F(ind.appr) = NaN;
            % les obs des Site sont Ã  8h alors que calendar sont Ã  minuit donc on change
            % l'heure
            date.Site.Hour = unique(caldate.Hour);
            % on remplit quand les dates sont communes a caldate
            [~,ind.tmp] = ismember(caldate,date.Site);
            ind.date = ind.tmp(find(ind.tmp));
            [~,ind.tmp] = ismember(date.Site,caldate);
            ind.date2 = ind.tmp(find(ind.tmp));
            % on remplit quand les dates sont communes a caldate
            Dens(ind.date2,iSite) = Site.NSD000F(ind.date);
            Haut(ind.date2,iSite) = Site.NS000F(ind.date);
            EEN(ind.date2,iSite) = Site.NSQ000F(ind.date);
            clear ind fich Site
        end
end







