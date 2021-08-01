% Simuler le couvert nival, version 2 
%
% AUTEUR : Thomas-Charles Fortier Filion, DEH
%
%
% DESCRIPTION
%   Simuler la production d’apports verticaux selon l’évolution du couvert
%   nival avec les conditions météorologiques reçues et les états de départ.
%   Ce traitement est le cœur du modèle de neige.
%	CORRECTION DE LA TEMPERATURE + DensiteMax depend de lq 
%
% ENTRÉES
%   precipitation : matrice des précipitations (lon x lat)
%   temperatureMinimale : matrice des températures min (lon x lat)
%   temperatureMaximale : matrice des températures max (lon x lat)
%   etats : matrice des états du modèle (lon x lat x milieu)
%   parametres : grille des parametres (parametre x milieu)
%   PDT : date/heure du pas de temps courant
%   alt : matrice des altitudes (lon x lat) pour corriger la temperature
%   lat : matrice des latitudes (lon x lat) pour imposer la densite maximale
%	jour : le jour en mode datetime 
%
% SORTIES
%   aucune
%
% MODIFICATIONS
%   2016-10-24 : Exécution avec des données matricielles (KG)
%   2017-10-31 P. CANTET : (AJOUT) 
%		- CORRECTION DE LA TEMPERATURE  : parametres.CorrTemp (commun a tous les milieux)
%		- DensiteMax = 10*(-0.853*lat + 80) si parametres.DensiteMaximale(iMilieu)==0
%		- calcul de tempMoy depend de la latitude et du jour
%       - correction de la precipitation

function [etats, av] = SimulerCouvertNival2(precip, tempMin, tempMax, etats, parametres, PDT,alt,lat,jour)

indice_radiation = 1;

% Constantes "universelles"
chaleur_eau = 4184;             % [joules/(kg*°C)]
chaleur_fonte = 335000;         % [joules/kg]
chaleur_neige = 2093.4;         % [joules/(kg*°C)]
densit_eau = 1000;              % [kg/m^3]

% La proportion de terrain devra éventuellement entrer en argument de la fonction.
proportion_terrain = ones(size(tempMin));           % []


% AJOUT densiteMAX depend de la latitude si parametres.DensiteMaximale(iMilieu) == 0
densiteMaxLat = 10*(80 - 0.853*lat);

% AJOUT le calcul tempMoy depend de la latitude et du jour
prop_jour =  CalculerDureeJour(jour,lat)/24;
prop_nuit = 1 - prop_jour;


[nbLon, nbLat] = size(tempMin);
nbMilieux = size(etats.stock_neige, 3);

av = nan(nbLon, nbLat, nbMilieux);
% utile si plusieurs milieux, sinon sert à rien...
precip0 = precip;
tempMin0 = tempMin;
tempMax0 = tempMax;
for iMilieu = 1 : nbMilieux
    
    % Initialiser les grilles de paramètres (répéter les valeurs sur une
    % grille.        
    tauxSolFonte = parametres.TauxFonteSol(iMilieu) * ones(nbLon, nbLat);
    coeffFonte = parametres.CoefficientFonte(iMilieu) * ones(nbLon, nbLat);
    temperatureDeFonte = parametres.TemperatureFonte(iMilieu) * ones(nbLon, nbLat) ;
	densiteMax = parametres.DensiteMaximale(iMilieu) * ones(nbLon, nbLat) ;
	CorrTemp = parametres.CorrTemp(iMilieu);
    CorrPr = parametres.CorrPr(iMilieu);
    constTassement = parametres.ConstanteTassement(iMilieu) * ones(nbLon, nbLat);
    temperaturePassagePluieNeige = parametres.TemperaturePluieNeige(iMilieu) * ones(nbLon, nbLat); 
	% AJOUT cas densiteMAX depend de la latitude	
	if parametres.DensiteMaximale(iMilieu) == 0
		densiteMax = densiteMaxLat;
	end   
    % AJOUT correction de la temperature
	tempMin = tempMin0 - CorrTemp * alt;
	tempMax = tempMax0 - CorrTemp * alt;
    % AJOUT correction precipitation
    precip = CorrPr .* precip0;
	% Calcul de la température moyenne du pas de temps à partir des températures maximale et minimale.    
	%tempMoy = (tempMin + tempMax) / 2;  
	tempMoy = (prop_nuit.* tempMin + prop_jour.* tempMax);

    albedo = etats.albedo(:, :, iMilieu);
    chaleur_stock = etats.chaleur_stock(:, :, iMilieu);
    eau_retenue = etats.eau_retenue(:, :, iMilieu);
    stock_neige = etats.stock_neige(:, :, iMilieu);
    hauteur_neige = etats.hauteur_neige(:, :, iMilieu);

    % Initialiser toutes les matrices qui sont utilisées dans la fonction.
    drel = zeros(size(tempMin));
    dennei = zeros(size(tempMin));
    tneige = zeros(size(tempMin));
    hneige = zeros(size(tempMin));
    alpha = zeros(size(tempMin));
    liquide = zeros(size(tempMin));
    alb_t_plus_1 = zeros(size(tempMin));
    beta2 = zeros(size(tempMin));
    fonte = zeros(size(tempMin));
    compaction = zeros(size(tempMin));
    densto = zeros(size(tempMin));
    rmax = zeros(size(tempMin));
    v_erf = zeros(size(tempMin));
    st_neige = zeros(size(tempMin));
    eq_neige = zeros(size(tempMin));
    apport = zeros(size(tempMin));                 
    
    % Séparation des précipitations en neige et en pluie. La fonction precip_separe est définie après cette fonction.
    % Le résultat de cette fonction donne les précipitations (pluie-neige) en m d'eau.    
    [neige, pluie] = precip_separe(precip/1000, tempMin, tempMax, temperaturePassagePluieNeige); % [les precipitations sont en mm]
    
    % Calcul du pas de temps en secondes.    
    pdts = PDT * 60 * 60;          % [sec]
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Vérification si il y a de la neige en jeu à ce pas de temps
    %  cond1 est vrai lorsqu'il y a de la neige
    cond1 =  ((stock_neige > 0 | neige > 0));
    cond1_1 = (~((stock_neige > 0 | neige > 0)));
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Calcul de la densité relative de la neige fraiche (drel []) et de l'épaisseur de la
    %   nouvelle couche de neige.
    %   L'équation utilisée pour calculer la densité de la neige fraiche est :
    %               rho_nf = 151 + 10.63*Tm + 0.2767*Tm^2      [kg/m^3]
    %
    drel(cond1) = (151 + 10.63 * tempMoy(cond1) + 0.2767 * tempMoy(cond1).^2) / densit_eau ;    %   [kg/m^3]/[kg/m^3] = []
    neige(cond1) = neige(cond1) ./ drel(cond1) ;                             %   [m]/[]=[m]
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Ajout de la nouvelle neige au couvert déjà au sol
    %
    stock_neige(cond1) = stock_neige(cond1) + (neige(cond1) .* drel(cond1)) ;          % Équivalent en eau
    hauteur_neige(cond1) = hauteur_neige(cond1) + neige(cond1);                         % Hauteur du couvert
    chaleur_stock(cond1) = chaleur_stock(cond1) + densit_eau*chaleur_neige*(neige(cond1) .* ...
        drel(cond1) .* tempMoy(cond1));   % Déficit calorifique du couvert
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Calcul de la densité relative (rho_couvert/rho_eau) du couvert avec la nouvelle neige stockée
    %
    dennei(cond1) = stock_neige(cond1) ./ hauteur_neige(cond1); % [m/m] = [], sans dimensions
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Pertes de chaleur par convection
    %
    %   Les pertes sont considérées possible si la température moyenne de l'air est inférieure
    %   à la température de fonte (variable à caler).
    
    tneige(cond1) = chaleur_stock(cond1) ./ (stock_neige(cond1) * chaleur_neige * densit_eau);
    
    % Si la température moyenne de l'air est inférieure à la
    % température de fonte il y a perte par convection et cond2 est
    % vrai.
    cond2 = (tempMoy < temperatureDeFonte) & cond1;    
    tneige(cond2) = chaleur_stock(cond2) ./ (stock_neige(cond2) * chaleur_neige * densit_eau);    
    cond3 = (tneige > temperatureDeFonte) & cond2; % Problème possible
    tneige(cond3) = tneige(cond3);
        
    % Les pertes sont différentes selon la profondeur.
    cond4 = ((hauteur_neige < 0.4) & cond2); %
    cond5 = ((hauteur_neige >= 0.4) & cond2); %
    hneige(cond4) = 0.5 * hauteur_neige(cond4);
    hneige(cond5) = 0.2 + 0.25 * (hauteur_neige(cond5) - 0.4);
    
    alpha(cond2) = conductivite_neige(dennei(cond2) * densit_eau);
    alpha(cond2) = alpha(cond2) ./ (dennei(cond2) * densit_eau * chaleur_neige);
    v_erf(cond2) = erf(hneige(cond2)./(2 * sqrt(alpha(cond2) * pdts)));
    tneige(cond2) = tempMoy(cond2) + (tneige(cond2) - tempMoy(cond2)) .* v_erf(cond2);
    chaleur_stock(cond2) = tneige(cond2) .* stock_neige(cond2) * densit_eau * chaleur_neige;
    
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Ajustement du bilan calorifique en fonction de l'eau retenue au pas précédent
    %
    chaleur_stock(cond1) = chaleur_stock(cond1) + (densit_eau * eau_retenue(cond1) * chaleur_fonte);
    
    %   Ajout de la pluie
    stock_neige(cond1) = stock_neige(cond1) + pluie(cond1);
    
    % SLC : Insérer un coefficient pour la fraction d'énergie perdue par la
    % pluie.
    chaleur_stock(cond1) = chaleur_stock(cond1) + densit_eau * pluie(cond1).* ...
        (chaleur_fonte + chaleur_eau * tempMoy(cond1));
    
    %   Ajout de la chaleur due au gradient thermique
    chaleur_stock(cond1) = chaleur_stock(cond1) + ((tauxSolFonte(cond1) * (PDT / 24))) * ...
        densit_eau * chaleur_fonte;
    %
    %
    %   Calcul de l'albédo
    %   Les équations supposent :
    %
    %   albédo représentatif sol et végétation  : 0.15
    %   albédo max de la neige                  : 0.80
    %   albédo min de la neige                  : 0.50
    %   valeur de beta1                         : 0.5
    %
    %   Le stock de neige du pas précédent est aussi utilisé pour ce calcul.
    %   Les valeurs doivent etre en [mm] pour le calcul de l'albédo
    %
    eq_neige(cond1) = neige(cond1).* drel(cond1) * 1000;
    st_neige(cond1) = (stock_neige(cond1) - neige(cond1).* drel(cond1)) * 1000;
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    liquide((pluie > 0 | tneige >= 0) & cond1)=1;  % Lorsque le couvert est humide, l'albédo diminue plus rapidement.
    
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    cond6 = (st_neige > 0) & cond1;   % Il y a de la neige au sol au début du pas de temps.
    cond6_1 = (~(st_neige > 0)) & cond1;
    alb_t_plus_1(cond6) = (1 - exp(-0.5 * eq_neige(cond6))) * 0.8 + ( 1 - ( 1 - exp(-0.5 * eq_neige(cond6)))) .* ...
        (0.5 + (albedo(cond6) - 0.5) .* exp(-0.2 * (PDT / 24) * (1 + liquide(cond6))));
    
    cond7 = (albedo < 0.5) & cond6;
    cond8 = (~(albedo < 0.5)) & cond6;
    beta2(cond7) = 0.2;
    beta2(cond8) = 0.2 + (albedo(cond8)-0.5);
            
    albedo(cond6) = (1 - exp(-beta2(cond6) .* st_neige(cond6))) .* alb_t_plus_1(cond6) + ...
        (1 - (1 - exp(-beta2(cond6) .* st_neige(cond6)))) *0.15;
    
    % Il n'y avait pas de neige au sol au début du pas de temps.   
    albedo(cond6_1) = (1 - exp(-0.5 * eq_neige(cond6_1))) * 0.8 + (1 - (1 - exp(-0.5 * eq_neige(cond6_1))))*0.15;
    
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Ajout de la chaleur de fonte par rayonnement
    %
    cond9 = (tempMoy > temperatureDeFonte) & cond1;
    cond9_1 = (~(tempMoy > temperatureDeFonte)) & cond1;
    fonte(cond9) = indice_radiation * (coeffFonte(cond9) .* (tempMoy(cond9) - ...
        temperatureDeFonte(cond9)).* (1 - albedo(cond9)));
    fonte(cond9_1) = 0 ;
        
    fonte(cond1) = fonte(cond1) * (PDT / 24);
    
    chaleur_stock(cond1) = chaleur_stock(cond1) + ...
        (fonte(cond1) * densit_eau * chaleur_fonte);
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Calcul de la hauteur du stock et de sa densité après compaction et ajout de la pluie
    
    compaction(cond1) = (PDT / 24) * hauteur_neige(cond1).* constTassement(cond1) .* ...
        (1 - dennei(cond1) ./ densiteMax(cond1) * 1000);
    
    compaction((compaction < 0) & cond1)=0;
    
    hauteur_neige(cond1) = hauteur_neige(cond1) - compaction(cond1);
    densto(cond1) = stock_neige(cond1)./ hauteur_neige(cond1);
    
    cond10=(densto*densit_eau > densiteMax) & cond1;
    
    densto(cond10) = densiteMax(cond10) / densit_eau;
    hauteur_neige(cond10) = stock_neige(cond10)./ densto(cond10);
    
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Calcul du surplus calorifique et de la fonte    
    
    cond11=(chaleur_stock > 0) & cond1;
    cond11_1=(~(chaleur_stock > 0)) & cond1;
    fonte(cond11) = chaleur_stock(cond11) / chaleur_fonte / densit_eau; 
    
    fonte((fonte > stock_neige) & cond11) = stock_neige((fonte > stock_neige) & cond11);
    
    stock_neige(cond11) = stock_neige(cond11) - fonte(cond11);
    
    cond12 = ((fonte - pluie) > 0) & cond11;
    hauteur_neige(cond12)= hauteur_neige(cond12) - ((fonte(cond12) - pluie(cond12)) ./ densto(cond12));
    
    cond13=(hauteur_neige <= 0) & cond11;
    hauteur_neige(cond13) = stock_neige(cond13) ./ densto(cond13);
       
    chaleur_stock(cond11) = chaleur_stock(cond11) - (fonte(cond11) * densit_eau * chaleur_fonte);
    
    fonte(cond11_1) = 0;    

    %   Réinitialisation des stocks lorsque l'équivalent en eau est nul   
    cond14 = (stock_neige < 0.000001) & cond1;
    stock_neige(cond14) = 0;
    hauteur_neige(cond14) = 0;
    chaleur_stock(cond14) = 0;
    eau_retenue(cond14) = 0;        
    
    %   Calcul de l'eau retenue dans le stock de neige    
    rmax(cond1) = (0.1 * dennei(cond1)) .* stock_neige(cond1);
    
    cond15 = (rmax > fonte) & cond1 ;
    cond15_1 = (~(rmax > fonte)) & cond1 ;
    stock_neige(cond15) = stock_neige(cond15) + fonte(cond15);
    eau_retenue(cond15) = fonte(cond15);
    fonte(cond15) = 0;
    
    stock_neige(cond15_1) = stock_neige(cond15_1) + rmax(cond15_1);
    eau_retenue(cond15_1) = rmax(cond15_1);
    fonte(cond15_1) = fonte(cond15_1) - rmax(cond15_1);
    
    apport(cond1) = proportion_terrain(cond1).*fonte(cond1);
        
    apport(cond1_1) = proportion_terrain(cond1_1).* pluie(cond1_1);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Fin de la fonction fonte_hydrotel.m
    etats.chaleur_stock(:, :, iMilieu) = chaleur_stock;
    etats.albedo(:, :, iMilieu) = albedo;
    etats.hauteur_neige(:, :, iMilieu) = hauteur_neige;
    etats.stock_neige(:, :, iMilieu) = stock_neige;
    etats.eau_retenue(:, :, iMilieu) = eau_retenue;
    
    av(:, :, iMilieu) = apport;    
end


% NESTED FUNCTION :

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   La fonction precip_separe sert à séparer les précipitations en pluie et en
%   neige en fonction des températures minimales et maximales du pas de temps.
%   Lorsque la température minimum est au dessus de la température seuil,
%   la totalité des précipitations est de la pluie. Au contraire, lorsque la
%   température maximum est sous la température seuil, la totalité des
%   précipitations est de la neige. Lorsque ces températures sont de part et
%   d'autre de la température seuil, les précipitations sont séparées en
%   proportions équivalentes à l'écart du minimum et du maximum à la température
%   seuil.

    function [N,P] = precip_separe(p, tmin, tmax, temperature_passage_pluie_en_neige)
        
        tseuil = temperature_passage_pluie_en_neige;
        
        f=ones(size(p));
        cond1=(tmax <= tseuil);
        cond2=(tmin > tseuil);
        cond3=~(cond1 | cond2);
        f(cond1) = 0;
        f(cond2) = 1;
        f(cond3) = min((tmax(cond3)-tseuil(cond3))./(tmax(cond3)-tmin(cond3)), f(cond3));
        
        
        N=-(f-1).*p;
        P=f.*p;
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Cette fonction calcule la conductivité thermique de la neige.
%   d : densité du couvert nival [kg/m^3]

    function [cneige] = conductivite_neige(d)
        
        d0=0.36969;
        d1=1.58688e-3;
        d2=3.02462e-6;
        d3=5.19756e-9;
        d4=1.56984e-11;
        
        p0=ones(size(d));
        p1=(d-329.6);
        p2=((d-260.378).*p1)-(21166.4*p0);
        p3=((d-320.69).*p2)-(24555.8*p1);
        p4=((d-263.363).*p3)-(11739.3*p2);
        
        cneige = d0*p0 + d1*p1 + d2*p2 + d3*p3 + d4*p4;
        
    end

end
