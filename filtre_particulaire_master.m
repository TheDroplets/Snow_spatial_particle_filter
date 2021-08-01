%% ENTETE
clearvars
dirSource = 'D:\UdeS\filtreParticule\';
addpath(genpath([dirSource, 'Programmes_article\Fonctions']))
datetime.setDefaultFormats('default','yyyy-MM-dd hh:mm:ss');

%% NOM ET LOCALISATION DES OUTPUT
dossier = strcat(dirSource, "Output\Grilles\");
nomOut = "nivoSR50_SS4";
erase = true ; %si vrai le fichier de configuration est ecrase

%% PERIODE DE SIMULATION (au debut toutes les variables du modele de neige = 0)
date.debut = datetime(1962,09,01);
date.fin = datetime(1963,12,31);

%% GRILLE VOULUE (43 : 0.1 : 53.4 latitude ; -81.5 : 0.1 :-57.1 longitude
%Grille.Lon =  -72.5:0.1:-70.5;%-73:0.1:-72;%
%Grille.Lat = 45:0.1:46;% 47:0.1:48;%
Grille.Lon =  -81.5:0.1:-57.1;%-73:0.1:-72;%
Grille.Lat = 43:0.1:53.4;% 47:0.1:48;%

%% VARIABLES SAUVEGARDEES
calcule_variogrammes = false;
creerGrille = true; % si vrai : on recupere la grille complete sur le domaine
                   % si faux : on recupere les simu aux sites de calage et
                                % sur les points grille des sites d evalidation.
diagnostique = false; % chronique du nombre de particules efficaces
saveEnsemble = false ; % si vrai on sauvegarde l'ensemble des particules pour tous les points de simu
saveEtats = true ; % si vrai on sauvegarde les 5 etats dans un fichier additionnel

diagnostique = diagnostique & ~creerGrille; %pas de diagno si on travail sur la grille complete (objet trop lourd)
%% LISTES DE POSTES A UTILISER

%"nivoInstitution" ; "nivo90" ; "nivo10"  ; "nivoTot" "nivoPartenaires" "nivo1kmSR50" "nivo1kmSR50Compl" "nivo1kmSR50Compl" "nivo5kmSR50" "nivo5kmSR50Compl";
% "SR50tot"
file.liste = strcat(dirSource, "input_article\listes_postes.mat");
load(file.liste);

postes.D = [liste.nivoTot; liste.SR50tot];

postes.R = [];

clear liste
%% POUR MODELE DE NEIGE
nomModele = 'objDEHprl';
folder.param = [dirSource, 'input_article\PARAM_HSM\'];

nb_interp = 0;

%% HYPER PARAMETRES DU FILTRE
% perturbation uniforme  du stock de neige (EEN)
filtre.pertubSN = 2/100;
% dépendance des perturbations
filtre.Dep.Tempo = 0.95; % dependance temporelle
filtre.Dep.Spa = 300; % dependance spatiale en km
% interne au filtre particulaire
filtre.NbPart = 500;  % nombre de particules
filtre.seuilNeff = 0.8; %seuil de reechantillonage
filtre.methReech = 'SIR'; % methode de reechantillonnage ('RES','SIR','WRR')
filtre.freqAssimSR50 = 7; % frequence d'assimilation des donnes SR50 en jour
filtre.freqReech = 7; % frequence de reechantillonnage en jour
filtre.freqSS = 1; % frequence du schaake shuffle
% loi a priori des EEN : sigma = coefObs.a * EEN + coefObs.b)
filtre.coefObs.aNivo = 0.3;
filtre.coefObs.bNivo = 3;%pour eviter des sigma=0 pour Kalman
filtre.coefObs.aSR50 = 1;
filtre.coefObs.bSR50 = 10;%pour eviter des sigma=0 pour Kalman
% Option du schaake shuffle
filtre.reord = true ; % pour utiliser ou non le SS
filtre.reordOpt = "SShisto"; % methode de creation de l'histo  "SShisto", "ordreCroissant"
% Limitation de spostes a utiliser pour l'interpolation spatiale
%filtre.limTempo = 99999999999; % les postes dont la donnee la plus recente date de plus de limTempo (en jours) ne participent pas à l'interpolation

dir_histo =[dirSource 'input_article\historique']; % historique de simulation open loop pour Schaake Shuffle

%% CHEMINS DES DOSSIERS OU FICHIERS UTILES

folder.meteo = [dirSource, 'input_article\MeteoGrille_DEH\'];
folder.obs = [dirSource, 'input_article\neige\NivoMELCC\'];
folder.output = strcat(dossier, nomOut, "\")';
file.obs = strcat(dirSource, "input_article\neige\Stations_Nivo_MELCC.csv");
file.sitesSR50 = strcat(dirSource, "input_article\neige\tableSR50.mat");
file.obsSR50 = strcat(dirSource, "input_article\neige\relevesSR50RN.mat");
mkdir(folder.output)


%% GESTION DU FICHIER DE CONFIG
file.config = strcat(folder.output, "config.mat");
if ~erase
    load (file.config)
end

save(file.config, 'nomOut', 'date', 'Grille', 'postes', 'nomModele', 'filtre');


run("filtre_particulaire_core.m")

