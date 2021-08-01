%% Programme qui estime l'EEN sur une grille voulu a partir des releves Nivométriques
%   - on utilise le filtre particulaire spatial (interpolation spatiale des poids un jour par semaine)
%   - on utilise le modele de neige SPH-EEN de la DEH (avec modification de
%   Cantet2018)
%   - les perturbations sont temporellement et spatialement corrélées
%   - les perturbations sur la meteo sont dirigés par la variance du
%   krigeage de la meteo (bruit additif gaussien)
%   - On stocke l'EEN et l'apport vertical : matrice NbJourXpointsSimu.nb (un .mat par année) dans
%   folder.output/Neige_AAAA.mat :
%           - pointsSimu.nb = nombres de sites avec observation + nombre de pixels dans la grille voulue
%           - Dans pointsSimu (structure) il y a : longitude,latitude (l'altitude =
%           latitude)
%           - et les indices des sitesObs d'observation: pointsSimu.indSitesObs dans les matrices
%           - et les indices des points de grille: pointsSimu.indCibles

%% Programme principal du filtre particulaire spatialisé
%   - on utilise le filtre particulaire spatial (interpolation spatiale des poids un jour par semaine)
%   - on utilise le modele de neige SPH-EEN de la DEH (avec modification de Cantet2018)
%   - toutes les options de simulation doivenmt être specifiee avant de
%   lancer ce programme (voir programme master ou master_boucle)
%   - les perturbations sont temporellement et spatialement corrélées
%   - les perturbations sur la meteo sont dirigés par la variance du
%   krigeage de la meteo (bruit additif gaussien)
%   - option de réordonner les particules (Schaake shuffle ou tri
%   croissant) selon Odry2021 (ref ??)



%% %%%%%%%%%%%%%%%% INTERNE AU PROGRAMME %%%%%%%%%%%%%%%
%% Fabrication du calendrier de simulation
date.calendar = datetime(date.debut:caldays(1):date.fin);

%% Chargement des parametres du modele de neige
file.paramnew = [folder.param,'param_',nomModele,'.csv'];
parametres = LireParam(file.paramnew,'objDEHprl');

%% Recuperation des listes de station de calage et de validation

% noms des postes donneurs (donnees qui vont etre assimilees)
if length(postes.D) >=1
    listeCalage = postes.D;
else
    listeCalage =["neant"];
end

% noms des sites receveurs (donnes pas utilisees)
if length(postes.R) >=1
    listeValidation = postes.R;
else
    listeValidation = ["neant"];
end


%% chargement de toutes les observations sur la periode voulue
disp(' *** Extraction donnees de neige **** ' )
[InfoSites,EEN,Haut,Dens] = ExtractNeige(date.calendar,file.obs,folder.obs);
[InfoSitesSR50,EENSR50,HautSR50,DensSR50] = ExtractSR50(date.calendar,file.sitesSR50,file.obsSR50);

InfoSites = [InfoSites; InfoSitesSR50];
EEN = [EEN, EENSR50];
Haut = [Haut, HautSR50];
Dens = [Dens, DensSR50];

clear InfoSitesSR50 EENSR50 HautSR50 DensSR50

% on enleve ceux qui n'ont pas au moins NbObsMin observations (fichier
% vide) et qui ne sont pas dans la grille (sinon enlever tmpKeep)
NbObsMin = 4;
NbObs = sum(~isnan(EEN));
% on limite a plusdeg deg de plus que le domaine
plusdeg = 1;
tmpKeep = (InfoSites.Lon>(min(Grille.Lon)-plusdeg) & InfoSites.Lat>(min(Grille.Lat)-plusdeg) & InfoSites.Lon<(max(Grille.Lon)+plusdeg) & InfoSites.Lat<(max(Grille.Lat)+plusdeg));
tmpOK = find(NbObs>NbObsMin & tmpKeep');

InfoSites= InfoSites(tmpOK,:);
EEN = EEN(:,tmpOK);
Haut = Haut(:,tmpOK);
Dens = Dens(:,tmpOK);

% on cree une structure pour les sites d'observation utilisees pour le
% calage
plCal = ismember(InfoSites.Num, listeCalage);
sitesObs=struct();
sitesObs.Lon = InfoSites.Lon(plCal);
sitesObs.Lat = InfoSites.Lat(plCal);
sitesObs.Alt = InfoSites.Alt(plCal);
sitesObs.Num = InfoSites.Num(plCal);
sitesObs.Nom = InfoSites.Nom(plCal);
sitesObs.Type = InfoSites.Type(plCal);
sitesObs.EEN = EEN(:,plCal);
sitesObs.Dens = Dens(:,plCal);
sitesObs.Haut = Haut(:,plCal);
[nbPdt,sitesObs.nb] = size(sitesObs.EEN);

% probleme site avec les memes coordonnees (on ajoute un peu pour eviter ca)
sitesObs.Lon = sitesObs.Lon + 0.01*randn(sitesObs.nb,1);

sites_interp = false(sitesObs.nb);

clear NbObs* plusdeg

% on cree une structure pour les sites d'observations utilises pour la
% validation (si on utilise pas la grille complete)
if ~creerGrille
    cibles=struct();
    plVal = ismember(InfoSites.Num, listeValidation);
    cibles.Lon = round(InfoSites.Lon(plVal),1); %on fait l'estimation au pointgrille et pas directement au point de mesure
    cibles.Lat = round(InfoSites.Lat(plVal),1);
    cibles.Alt = InfoSites.Alt(plVal);
    cibles.Num = InfoSites.Num(plVal);
    cibles.Nom = InfoSites.Nom(plVal);
    cibles.Type = InfoSites.Type(plVal);
    cibles.EEN = EEN(:,plVal);
    cibles.Dens = Dens(:,plVal);
    cibles.Haut = Haut(:,plVal);
    [~,nbCibles] = size(cibles.EEN);
    % probleme site avec les memes coordonnees (on ajoute un peu pour eviter ca)
    cibles.Lon = cibles.Lon + 0.01*randn(nbCibles,1);
else
    cibles = "grille";
end

clear EEN Dens Haut pl* tmp*

%% concatenation des points de grilles et des sites (structure pointsSimu) et transfo lon/lat -» X/Y
% cas où l'on souhaite crer une grille finale
[tmplon , tmplat] = meshgrid(Grille.Lon,Grille.Lat);
Grille.Long = tmplon(:) ;
Grille.Latg = tmplat(:);
Grille.Altg=Grille.Latg;
Grille.taille = numel(tmplon);
    
if creerGrille
    
    
    % Creation d'un masque sur le sud du domaine : USA, NB, St Pierre et M,
    % glof du st laurent : economie de 37% des pixels
    pl1 = find(Grille.Long > -68 & Grille.Latg < 47.7);
    pl2 = find(Grille.Latg < 44.9);
    pl3 = find( Grille.Long >-69.5 & Grille.Latg < 46.9);
    pl5 = find( Grille.Long <-77 & Grille.Latg < 45.7);
    pl6 = find( Grille.Long >-64 & Grille.Latg < 48.5);
    pl7 = find( Grille.Long >-61.5 & Grille.Latg < Grille.Long/3+70);
    Grille.masque = sort(unique([pl1; pl2; pl3; pl5; pl6 ; pl7]));
    
    % creation des points de simulation : sites obs + points grille
    tmp = Grille.Long;
    tmp(Grille.masque) = [];
    pointsSimu.Lon = [sitesObs.Lon ; tmp];
    Grille.nbPix = length(tmp);
    
    tmp = Grille.Latg;
    tmp(Grille.masque) = [];
    pointsSimu.Lat = [sitesObs.Lat ; tmp];
    pointsSimu.Alt=pointsSimu.Lat;
    pointsSimu.Num = [sitesObs.Num];
    
    [pointsSimu.X,pointsSimu.Y] = latlon2xy(pointsSimu.Lat,pointsSimu.Lon);
    pointsSimu.nb = length(pointsSimu.Lon);
    pointsSimu.indSitesObs = 1:sitesObs.nb;
    pointsSimu.indCibles = (sitesObs.nb+1) : (pointsSimu.nb);
    pointsSimu.Type = [sitesObs.Type; repmat("ptGrille",Grille.nbPix,1)];
    
else % on ne fait pas de grille on simule simplement en certains points cibles
    pointsSimu.Lon = [sitesObs.Lon ; cibles.Lon];
    pointsSimu.Lat = [sitesObs.Lat ; cibles.Lat];
    pointsSimu.Alt = pointsSimu.Lat;
    pointsSimu.Num = [sitesObs.Num ; cibles.Num];
    [pointsSimu.X,pointsSimu.Y] = latlon2xy(pointsSimu.Lat,pointsSimu.Lon);
    pointsSimu.nb = length(pointsSimu.Lon);
    pointsSimu.indSitesObs = 1:sitesObs.nb;
    pointsSimu.indCibles = (sitesObs.nb+1) : (pointsSimu.nb);
    pointsSimu.Type = [sitesObs.Type; cibles.Type];
end
clear tmp* NbObs* pl* Info*
% on plot la cartepour verifier
figure;
quick_plot_quebec();hold on
plot(pointsSimu.Lon(pointsSimu.indCibles),pointsSimu.Lat(pointsSimu.indCibles),'b.');
plot(pointsSimu.Lon(pointsSimu.indSitesObs),pointsSimu.Lat(pointsSimu.indSitesObs),'r.','MarkerSize',20);
hold off


%% calcul de la matrice de covariance et la Choleski associée pour les perturbations
tic
disp('*** calcul Covariance et Choleski  ****')
DIST = dist([pointsSimu.X  pointsSimu.Y]');
COV = exp(-DIST.^1.9/filtre.Dep.Spa^1.9); % 1.9 au lieu de 2 pour que COV soit definie positive (tres faibles impacts sur les resultats)
CHO = chol(COV);
clear COV
toc

%% initialisation
etatsPF = CreerEtats(filtre.NbPart,pointsSimu.nb,1);
poidsPF = ones(filtre.NbPart,pointsSimu.nb)/filtre.NbPart;
etatDet = CreerEtats(1,pointsSimu.nb,1); % etat déterministe pour fonctionnement en mode été ou openloop
% pour dependance
soldPF = struct();
soldPF.pr = nan;
soldPF.tmin = nan;
soldPF.tmax = nan;
soldPF.sn = nan;

% historique
etatsHisto = etatsPF;
soldHisto = soldPF;
f_metaH= [dir_histo '\Meta.mat'];
metaH = load(f_metaH);

% pour l'annee
iJourAn = 1;
date.annee_cur = 0;
%pour meteo
prcur=nan(1,pointsSimu.nb);tmincur=nan(1,pointsSimu.nb);tmaxcur=nan(1,pointsSimu.nb);
varprcur=nan(1,pointsSimu.nb);vartmincur=nan(1,pointsSimu.nb);vartmaxcur=nan(1,pointsSimu.nb);
% pour stocker annuellement
EENmedold = nan(1,pointsSimu.nb);
EENmed = nan(366,pointsSimu.nb);
EENq25 = nan(366,pointsSimu.nb);
EENq75 = nan(366,pointsSimu.nb);
AVmed = nan(366,pointsSimu.nb);

if saveEtats
    albedo_med = nan(366,pointsSimu.nb);
    eau_retenue_med = nan(366,pointsSimu.nb);
    chaleur_stock_med = nan(366,pointsSimu.nb);
    hauteur_neige_med = nan(366,pointsSimu.nb);
end

Date = nan(1,366);
previEEN.med = EENmed;
previEEN.q25 = EENmed;
previEEN.q75 = EENmed;

if saveEnsemble
    EENens = nan(366, pointsSimu.nb, filtre.NbPart);
end

% pour stocker les jours d'assimilation
JourAssim = [];
PoidsChange = 0;
%pour savoir si y a reinitialisation du filtre dans l'annee
reinit = 0; %si pas de reinitialisation, on force a reinitialiser le JourMaxReinit jour de l'annee
JourMaxReinit = 230;

% elements temporaire : pour le calul de la correlation spatiale, pas
% necessaire au fonctionnement du filtre
%%%%%%%%%%%%temporaire%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% id_2 = find(pointsSimu.Lon == -70 & pointsSimu.Lat == 48)
% id_1 = find(pointsSimu.Lon == -70 & pointsSimu.Lat == 47.9)
% variogrammes = [];
% correl = nan(nbPdt,1);


%tempo = repmat(filtre.limTempo, sitesObs.nb,1); %on va stocker l'age de la derniere obs en chaque site

%% decompte des irreg spatiales
% f_ref = "D:\UdeS\filtreParticule\Output\Grilles\openLoop\tauxVaria\taux31-Jan.mat";
% load(f_ref)
% pix = 1:Grille.taille;
% pix(Grille.masque) = [];
%
% [n_couples, ~] = size(res);
% nb_irreg = nan(nbPdt,1);
% intens_irreg = nan(nbPdt,1);

%% sauvegarde
fichsave = strcat(folder.output, "Meta.mat");
save(fichsave,'pointsSimu','Grille', 'cibles', '-v7.3','-nocompression');

%% on simule jour apres jour de date.calendar
if diagnostique
    diagno.CRPS = nan(nbPdt, pointsSimu.nb);
    %diagno.NRR = nan(nbPdt, pointsSimu.nb);
    diagno.variance = nan(nbPdt, pointsSimu.nb);
    diagno.erreur = nan(nbPdt, pointsSimu.nb);
    diagno.Neff = nan(nbPdt, pointsSimu.nb);
    diagno.corrSpa = nan(nbPdt, pointsSimu.nb, pointsSimu.nb);
    diagno.dist = DIST;
    
end


for pdt = 1:nbPdt
%for pdt = 3652:3695
       
    date.cur = date.calendar(pdt);
    %tempo = tempo + ones(size(tempo)); %age de la derniere donnee en chaque poste
    
    %% observation du jour
    obs_cur = nan(1,pointsSimu.nb);
    obs_cur(pointsSimu.indSitesObs) = sitesObs.EEN(pdt,:);
    
    sites_interp(~isnan(sitesObs.EEN(pdt,:))) = true;
    
    % supression des donnees SR50 selon la frequence d'assimilation
    if mod(pdt, filtre.freqAssimSR50)~=0
        pl = find(sitesObs.Type=="SR50");
        
        obs_cur(pl) = nan;
    end
    
    %tempo(~isnan(obs_cur(pointsSimu.indSitesObs))) = 0;
    
    %% chargement des donnees meteo pour l'annee en cours (une seule fois par an) et sauvegarde
    if year(date.cur) ~= date.annee_cur
        %sauvegarde
        if (iJourAn~=1)
            %remise en forme de la grille (on rajoute les pixels du masque)
            if creerGrille
                EENmed = BuildGrilleMasque(Grille, EENmed(:,pointsSimu.indCibles));
                AVmed = BuildGrilleMasque(Grille, AVmed(:,pointsSimu.indCibles));
                EENq25 = BuildGrilleMasque(Grille, EENq25(:,pointsSimu.indCibles));
                EENq75 = BuildGrilleMasque(Grille, EENq75(:,pointsSimu.indCibles));
                previEEN.med = BuildGrilleMasque(Grille, previEEN.med(:,pointsSimu.indCibles));
                previEEN.q25 = BuildGrilleMasque(Grille, previEEN.q25(:,pointsSimu.indCibles));
                previEEN.q75 = BuildGrilleMasque(Grille, previEEN.q75(:,pointsSimu.indCibles));
                
                if saveEtats
                    albedo_med = BuildGrilleMasque(Grille, albedo_med(:,pointsSimu.indCibles));
                    hauteur_neige_med = BuildGrilleMasque(Grille, hauteur_neige_med(:,pointsSimu.indCibles));
                    chaleur_stock_med = BuildGrilleMasque(Grille, hauteur_neige_med(:,pointsSimu.indCibles));
                    eau_retenue_med = BuildGrilleMasque(Grille, eau_retenue_med(:,pointsSimu.indCibles));
                end
            end
            
            %sauvegarde de l'annee
            fichsave = strcat(folder.output, "Neige", num2str(date.annee_cur), ".mat");
            EENmed = EENmed(1:(iJourAn-1),:) ;
            AVmed = AVmed(1:(iJourAn-1),:) ;
            Date=date.calendar(pdtbegin:(pdt-1));
            EENobs = sitesObs.EEN(pdtbegin:(pdt-1),:);
            EENq25 = EENq25(1:(iJourAn-1),:);
            EENq75 = EENq75(1:(iJourAn-1),:);
            previEEN.med = previEEN.med(1:(iJourAn-1),:);
            previEEN.q25 = previEEN.q25(1:(iJourAn-1),:);
            previEEN.q75 = previEEN.q75(1:(iJourAn-1),:);
            %save(fichsave,'EENmed','AVmed','Date','pointsSimu','EENobs','Grille','JourAssim','EENq25','EENq75','-v7.3','-nocompression')
            save(fichsave,'Date','EENmed','AVmed','JourAssim','EENq25','EENq75', '-v7.3','-nocompression')
            
            fichsave = strcat(folder.output, "NeigePrevi", num2str(date.annee_cur), ".mat");
            save(fichsave,'Date', 'previEEN','-v7.3','-nocompression')
            
            if saveEtats
                fichsave = strcat(folder.output, "Etats", num2str(date.annee_cur), ".mat");
                save(fichsave,'Date','EENmed','AVmed','albedo_med','hauteur_neige_med','chaleur_stock_med', 'eau_retenue_med', '-v7.3','-nocompression')
            end
            
            
            if saveEnsemble
                fichsave = strcat(folder.output, "NeigeEns", num2str(date.annee_cur), ".mat");
                save(fichsave, 'Date', 'EENens','-v7.3','-nocompression');
            end
            
            % on réinitialise les variables de stockage
            iJourAn=1;
            JourAssim = [];
            EENmed = nan(366,pointsSimu.nb);
            EENq25 = nan(366,pointsSimu.nb);
            EENq75 = nan(366,pointsSimu.nb);
            AVmed = nan(366,pointsSimu.nb);
            previEEN.med = nan(366,pointsSimu.nb);
            previEEN.q25 = nan(366,pointsSimu.nb);
            previEEN.q75 = nan(366,pointsSimu.nb);
            if saveEnsemble
                EENens = nan(366,pointsSimu.nb, filtre.NbPart);
            end
            
            if saveEtats
                albedo_med = nan(366,pointsSimu.nb);
                eau_retenue_med = nan(366,pointsSimu.nb);
                chaleur_stock_med = nan(366,pointsSimu.nb);
                hauteur_neige_med = nan(366,pointsSimu.nb);
            end
        end
        
        %chargement meteo
        disp(year(date.cur))
        date.annee_cur = year(date.cur);
        pdtbegin = pdt; % pour stocker les dates
        % donnee meteo pour year
        fich = [folder.meteo,'GCQ_v1_2_',num2str(date.annee_cur),'.mat'];
        meteo = load(fich,'-mat');
        date.meteo = datetime(meteo.tv,'ConvertFrom','datenum');
        clear tv;
        % recherche de la pixel correspondante au poste
        [~,ind.lon] = ismember(round(pointsSimu.Lon,1),round(meteo.lon,1));
        [~,ind.lat] = ismember(round(pointsSimu.Lat,1),round(meteo.lat,1));
        % booleen pour pixels sur le domaine meteo
        pixIN = ind.lon .* ind.lat;
        % pour la reinitialisation du filtre qu'on impose au 220e jour de
        % l'annee si pas eu lieu avant
        reinit=0;
        
    end
    
    %% chargement des donnees meteo pour le jour en cours
    % recherche des indices pour la date
    [~,ind.date] = ismember(date.cur,date.meteo);
    % extraction sur chacuns des pixels
    for ipointsSimu = 1:pointsSimu.nb
        if pixIN(ipointsSimu)
            prcur(1,ipointsSimu) = meteo.pr(ind.lat(ipointsSimu),ind.lon(ipointsSimu),ind.date);
            tmincur(1,ipointsSimu) = meteo.tasmin(ind.lat(ipointsSimu),ind.lon(ipointsSimu),ind.date);
            tmaxcur(1,ipointsSimu) = meteo.tasmax(ind.lat(ipointsSimu),ind.lon(ipointsSimu),ind.date);
            varprcur(1,ipointsSimu) = meteo.pr_var(ind.lat(ipointsSimu),ind.lon(ipointsSimu),ind.date);
            vartmincur(1,ipointsSimu) = meteo.tasmin_var(ind.lat(ipointsSimu),ind.lon(ipointsSimu),ind.date);
            vartmaxcur(1,ipointsSimu) = meteo.tasmax_var(ind.lat(ipointsSimu),ind.lon(ipointsSimu),ind.date);
        end
    end
    
    %% dans le cas ou y a pas de neige pour la mediane et pas d'observation, on simule juste une particule (gain de temps pour l'ete)
    if (all(EENmedold==0) && all(isnan(obs_cur)) || all(listeCalage == "neant"))
        sites_interp = false(sitesObs.nb);
        disp("pas de neige");
    %if (all(EENmedold==0) && all(isnan(obs_cur)))
        [etatDet, tmpav ] = SimulerCouvertNival2(prcur,tmincur,tmaxcur,etatDet, parametres, 24,pointsSimu.Alt',pointsSimu.Lat',date.calendar(pdt));
        etatsPF = DupliquerEtats(etatsPF,etatDet);
        etatsHisto = etatsPF;
        
        poidsPF = ones(filtre.NbPart,pointsSimu.nb)/filtre.NbPart;
        poidsPFprevu = poidsPF;
        
        
        EENprevu = 100*etatsPF.stock_neige; % "prevision" de l'EEN du jour en cours si on ne dispose pas encore des obs
        
        % on reinitialise les perturbations
        soldPF.pr = nan;
        soldPF.tmin = nan;
        soldPF.tmax = nan;
        soldPF.sn = nan;
        reinit = 1;
        avPF(:,:) = repmat(tmpav,filtre.NbPart,1);
        
        % variogramme de la particule 1
%         valeurs = etatsPF.stock_neige(1,:)';
%         coord = [pointsSimu.X, pointsSimu.Y];
%         vario = variogram(coord, valeurs*100, 'plotit',false,'nrbins',20, 'maxdist', 300);
%         %plot(vario.distance, vario.val); hold on; % vario sur les nivo
%         variogrammes = horzcat(variogrammes, vario.val);
        
        %% y a de la neige ou une observation alors on  fait tourner le modele normalement
    else
        etatDet = CreerEtats(1,pointsSimu.nb,1); % on réinitialise l'etat deterministe pour le prochain ete
        tmp=struct();
        %% on met la meteo du jour comme il faut
        prPF = repmat( prcur,filtre.NbPart,1);
        tminPF = repmat(tmincur,filtre.NbPart,1);
        tmaxPF = repmat(tmaxcur,filtre.NbPart,1);
        varprPF = repmat( varprcur,filtre.NbPart,1);
        vartminPF = repmat(vartmincur,filtre.NbPart,1);
        vartmaxPF = repmat(vartmaxcur,filtre.NbPart,1);
        latPF = repmat(pointsSimu.Lat',filtre.NbPart,1);
        altPF = repmat(pointsSimu.Alt',filtre.NbPart,1);
        
        %% perturbation de la meteo
        [prPF,~,soldPF.pr] = PerturberSpatialAddSigmaChol(prPF,nan,varprPF,filtre.Dep.Tempo,CHO,soldPF.pr);
        prPF = max(real(prPF),0);
        
        vartPF = 0.5 * (vartminPF + vartmaxPF); %on perturbe de la meme façon les temperatures min et max (pour gain de temps) moyenne des variances
        [tminPF,tmaxPF,soldPF.tmin] = PerturberSpatialAddSigmaChol(tminPF,tmaxPF,vartPF,filtre.Dep.Tempo,CHO,soldPF.tmin);
        
        
        %% prediction
        [etatsPF, avPF ] = SimulerCouvertNival2(prPF,tminPF,tmaxPF, etatsPF, parametres, 24,altPF,latPF,date.cur);
        
        %% perturbation de l'EEN
        [etatsPF,soldPF.sn] = PerturberSpatialEtatMulUnifChol(etatsPF,filtre.pertubSN,filtre.Dep.Tempo,filtre.Dep.Spa,soldPF.sn);
        
        %% extraction de la valeur estimee avant assimilation des donnes du jour
        EENprevu = 100*etatsPF.stock_neige; % "prevision" de l'EEN du jour en cours si on ne dispose pas encore des obs
        poidsPFprevu = poidsPF;
        
        %% historique SS
        if filtre.reord && filtre.reordOpt == "SShisto"
            % on ouvre le fichier historique correspondant au jour
            % calendaire
            dateV = datevec(date.cur);
            mois = dateV(2);
            jour = dateV(3);
            
            all_mois = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            mois = all_mois(mois);
            j = int2str(jour);
            if length(j) ==1
                j = ['0' j];
            end
            date_str = strcat(j, '-', mois);

            
            addpath(dir_histo);
            f = ['histo_'  char(date_str) '.mat'];
            load(f, "-mat");
            
            % on tire 500 elements parmi les disponibles
            [n_histo, ~] = size(historique);
            rand_ind = randsample(n_histo, filtre.NbPart);
            
            % on recuperes les valeurs a chaque point de simu
            for ipt = 1:pointsSimu.nb
                lon = round(pointsSimu.Lon(ipt), 1);
                lat = round(pointsSimu.Lat(ipt), 1);
                pos = find(round(metaH.Grille.Long,1) == lon & round(metaH.Grille.Latg,1) == lat);
                if(length(pos) > 0)
                    
                    etatsHisto.stock_neige(:, ipt) = historique(rand_ind, pos)/100;
                end
            end
            
            % on efface l'historique
            clear historique
            
        end
        
        %% correction des poids aux sites d'observation
        if any(~isnan(obs_cur)) % s'il y a eu au moins une observation sinon ca sert à rien
            a = "correction des poids";
            
            tmp.Sigmaobs = filtre.coefObs.aNivo * obs_cur + filtre.coefObs.bNivo;
            pl = find(sitesObs.Type=="SR50");
            tmp.Sigmaobs(pl) = filtre.coefObs.aSR50 * obs_cur(pl) + filtre.coefObs.bSR50;
            
            poidsPF = CorrigerM0SIR(etatsPF.stock_neige(:, :, 1) * 100,poidsPF,obs_cur,tmp.Sigmaobs);
            PoidsChange = PoidsChange + length(find(~isnan(obs_cur)));%nombre de poste ou y a eu observation (et donc les poids ont change)
            
        end
        
        %% Schaake shuffle
        if filtre.reord & mod(pdt, filtre.freqSS)==0
            
            % realisation du schaake shuffle
            %if mod(pdt, filtre.freqSS)==0
            if filtre.reordOpt == "ordreCroissant"
                [etatsPF, poidsPF, avPF] = ReordParticules(etatsPF, poidsPF, avPF);
            end
            
        end
        
        
        %% spatialisation des poids et reechantillonnage
        if (PoidsChange > 0 && mod(pdt, filtre.freqReech)==0) %conditions de reechantillonnage : si la frequence est fixee à 7jours, le rrechantillonnage a lieu le dimanche
            nb_interp = nb_interp+1;
            % spatialisation des poids pour pour les pixels ind_cible
            JourAssim = [JourAssim iJourAn];
            
            %plTempo = tempo <= filtre.limTempo; %on n'utilise que les sites qui ont des donnees assez recentes
            %pl = pointsSimu.indSitesObs(plTempo);
            %pl = pointsSimu.indSitesObs;
            pl = find(sites_interp);
            
            tmpZcible =  idwMat([pointsSimu.X(pl),pointsSimu.Y(pl)],poidsPF(:,pl)',[pointsSimu.X(pointsSimu.indCibles),pointsSimu.Y(pointsSimu.indCibles)],2);
            poidsPF(:,pointsSimu.indCibles) =  tmpZcible';
            poidsPF = poidsPF./sum(poidsPF); %normalisation des poids
            
            % reechantillonage de la semaine
            %[etatsPF,avPF,poidsPF] =  ReechantillonerEtatsAV(etatsPF,avPF,poidsPF,[1],filtre.methReech,filtre.seuilNeff);
            [etatsPF,avPF, poidsPF] = ReechantillonerEtatsAV(etatsPF,avPF,poidsPF,[1],filtre.methReech,filtre.seuilNeff);
            
            % on reinitialise pour la semaine prochaine
            PoidsChange = 0;
            
            
        end
        
 

        
        %% Diagnostique ensembliste
        if diagnostique
            ens = 100*etatsPF.stock_neige;
            obs = [sitesObs.EEN(pdt,:)'; cibles.EEN(pdt,:)'];
            
            if any (~isnan(obs))
                % CRPS
%                 sigmaobs = filtre.coefObs.aNivo * obs + filtre.coefObs.bNivo;
%                 pl = find(pointsSimu.Type=="SR50");
%                 sigmaobs(pl) = filtre.coefObs.aSR50 * obs_cur(pl) + filtre.coefObs.bSR50;
                diagno.CRPS(pdt,:) = CalculeCRPS2(obs, ens', poidsPF', 0, [0 1000], 0.1);
                diagno.variance(pdt,:) = var(ens); % dispersion des particules
            end
            
            diagno.corrSpa(pdt,:,:) =  corrcoef(ens);% structure spatiale
            
        end
        
        
    end
    
    
    %% reinitialisation du filtre si pas deja fait dans l'annee
    if (reinit==0 && iJourAn>JourMaxReinit)
        disp('*** reinitialisation du filtre ***')
        %tmpetat = EtatsMoyen(etatsPF,1);
        tmpetat = CreerEtats(1,pointsSimu.nb,1);
        [tmpetat, tmpav ] = SimulerCouvertNival2(prcur,tmincur,tmaxcur,tmpetat, parametres, 24,pointsSimu.Alt',pointsSimu.Lat',date.calendar(pdt));
        etatsPF = DupliquerEtats(etatsPF,tmpetat);
        etatsHisto = etatsPF;
        poidsPF = ones(filtre.NbPart,pointsSimu.nb)/filtre.NbPart;
        % on reinitialise les perturbations
        soldPF.pr = nan;
        soldPF.tmin = nan;
        soldPF.tmax = nan;
        soldPF.sn = nan;
        reinit = 1;
        avPF(:,:) = repmat(tmpav,filtre.NbPart,1);
    end
    %% stockage
    if saveEnsemble
        EENens(iJourAn, :,:) = reshape(100*etatsPF.stock_neige',[1, size( etatsPF.stock_neige')]);
    end
    
    EENmedold = percentilesParticules(100*etatsPF.stock_neige, poidsPF, 0.5);
    EENmed(iJourAn,:) = EENmedold;
    EENq25(iJourAn,:) = percentilesParticules(100*etatsPF.stock_neige, poidsPF, 0.25);
    EENq75(iJourAn,:) = percentilesParticules(100*etatsPF.stock_neige, poidsPF, 0.75);
    AVmed(iJourAn,:) = percentilesParticules(avPF, poidsPF, 0.5);
    
    previEEN.med(iJourAn,:) = percentilesParticules(EENprevu, poidsPFprevu, 0.5);
    previEEN.q25(iJourAn,:) = percentilesParticules(EENprevu, poidsPFprevu, 0.75);
    previEEN.q75(iJourAn,:) = percentilesParticules(EENprevu, poidsPFprevu, 0.25);
    
    if saveEtats
        albedo_med(iJourAn,:) = percentilesParticules(100*etatsPF.albedo, poidsPF, 0.5);
        hauteur_neige_med(iJourAn,:) = percentilesParticules(100*etatsPF.hauteur_neige, poidsPF, 0.5);
        chaleur_stock_med(iJourAn,:) = percentilesParticules(100*etatsPF.chaleur_stock, poidsPF, 0.5);
        eau_retenue_med(iJourAn,:) = percentilesParticules(100*etatsPF.eau_retenue, poidsPF, 0.5);
    end
    
    %% Diagnostique deterministe
    if diagnostique
        estim = EENmed(iJourAn,:)';
        obs = [sitesObs.EEN(pdt,:)'; cibles.EEN(pdt,:)'];
        
        if any (~isnan(obs))
            diagno.erreur(pdt,:) = estim - obs; % dispersion des particules
        end
        
        % nb de particules efficaces
        for isite = 1 : pointsSimu.nb
            diagno.Neff(pdt, isite) = 1/sum(poidsPF(:,isite).^2);
        end
    end
    %
    iJourAn = iJourAn+1;
    
    %% sauvegarde
    if (pdt==nbPdt)
        fichsave = strcat(folder.output, "Neige", num2str(date.annee_cur), ".mat");
        EENmed = EENmed(1:(iJourAn-1),:) ;
        AVmed = AVmed(1:(iJourAn-1),:) ;
        Date=date.calendar(pdtbegin:(pdt));
        EENobs = sitesObs.EEN(pdtbegin:(pdt),:);
        EENq25 = EENq25(1:(iJourAn-1),:);
        EENq75 = EENq75(1:(iJourAn-1),:);
        previEEN.med = previEEN.med(1:(iJourAn-1),:);
        previEEN.q25 = previEEN.q25(1:(iJourAn-1),:);
        previEEN.q75 = previEEN.q75(1:(iJourAn-1),:);
        
        %remise en forme de la grille (on rajoute les pixels du masque)
        if creerGrille
            EENmed = BuildGrilleMasque(Grille, EENmed(:,pointsSimu.indCibles));
            AVmed = BuildGrilleMasque(Grille, AVmed(:,pointsSimu.indCibles));
            EENq25 = BuildGrilleMasque(Grille, EENq25(:,pointsSimu.indCibles));
            EENq75 = BuildGrilleMasque(Grille, EENq75(:,pointsSimu.indCibles));
            previEEN.med = BuildGrilleMasque(Grille, previEEN.med(:,pointsSimu.indCibles));
            previEEN.q25 = BuildGrilleMasque(Grille, previEEN.q25(:,pointsSimu.indCibles));
            previEEN.q75 = BuildGrilleMasque(Grille, previEEN.q75(:,pointsSimu.indCibles));
            
            if saveEtats
                albedo_med = BuildGrilleMasque(Grille, albedo_med(:,pointsSimu.indCibles));
                hauteur_neige_med = BuildGrilleMasque(Grille, hauteur_neige_med(:,pointsSimu.indCibles));
                chaleur_stock_med = BuildGrilleMasque(Grille, hauteur_neige_med(:,pointsSimu.indCibles));
                eau_retenue_med = BuildGrilleMasque(Grille, eau_retenue_med(:,pointsSimu.indCibles));
            end

        end
        
        save(fichsave,'Date','EENmed','AVmed','JourAssim','EENq25','EENq75','-v7.3','-nocompression')
        
        fichsave = strcat(folder.output, "NeigePrevi", num2str(date.annee_cur), ".mat");
        save(fichsave,'Date', 'previEEN','-v7.3','-nocompression')
        
        if saveEnsemble
            fichsave = strcat(folder.output, "NeigeEns", num2str(date.annee_cur), ".mat");
            save(fichsave,'Date', 'EENens', '-v7.3','-nocompression');
        end
        
        if saveEtats
            albedo_med = albedo_med(1:(iJourAn-1),:) ;
            hauteur_neige_med = hauteur_neige_med(1:(iJourAn-1),:) ;
            chaleur_stock_med = chaleur_stock_med(1:(iJourAn-1),:) ;
            eau_retenue_med = eau_retenue_med(1:(iJourAn-1),:) ;
            
             fichsave = strcat(folder.output, "Etats", num2str(date.annee_cur), ".mat");
             save(fichsave,'Date','EENmed','AVmed','albedo_med','hauteur_neige_med','chaleur_stock_med', 'eau_retenue_med', '-v7.3','-nocompression')
        end
        
    end
    if (weekday(date.cur)==1)
        date.cur
        toc
        
    elseif (weekday(date.cur)==2)
        tic
    end
    
    
end
%%%%%%%%%%%%%%%%% TEMPORAIRE %%%%%%%%%%%%%%%%%%%%%%%%
% f = strcat(folder.output, "correl.mat");
% save(f,'correl');
% 
if diagnostique
    f =  strcat(folder.output, "diagnostique.mat");
    save(f,'diagno','-v7.3','-nocompression');
end

if calcule_variogrammes
    for ipart = 1:filtre.NbPart
        valeurs = etatsPF.stock_neige(ipart,:)';
        coord = [pointsSimu.X, pointsSimu.Y];
        vario = variogram(coord, valeurs*100, 'plotit',false,'nrbins',20, 'maxdist', 300);
        %plot(vario.distance, vario.val); hold on; % vario sur les nivo
        variogrammes = horzcat(variogrammes, vario.val);
    end
    fichsave = strcat(folder.output, "variogrammes", datestr(date.cur), ".mat");
    variog.val = variogrammes;
    variog.d = vario.distance;
    variog.num = vario.num;
    save(fichsave,'variog');

    fichsave = strcat(folder.output, "stock_neige", datestr(date.cur), ".mat");
    stock = etatsPF.stock_neige;
    save(fichsave,'stock')
end

% for ipart = 1:filtre.NbPart
%     plot(variog.d, variog.val(:,ipart)); hold on; % vario sur les nivo
% end

