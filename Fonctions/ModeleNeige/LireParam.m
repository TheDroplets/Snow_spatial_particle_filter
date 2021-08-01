%   Lire les parametres du modele de neige de la DEH a partir d'un fichier
%   csv (1 ligne par parametres
%
% ENTREES :
%   - file :  fichier des parametres
%   - version : chaine de caracteres qui donne la version des parametres 
%
% SORTIES
%   - parametres : les parametres du modele sous la bonne forme

function parametres = LireParam(file,version)
    x = importdata(file);
   	parametres.TauxFonteSol = 0;
	parametres.CoefficientFonte = 0;
	parametres.TemperatureFonte = 0;
	parametres.DensiteMaximale = 0;
	parametres.ConstanteTassement = 0;
	parametres.TemperaturePluieNeige = 0;
	parametres.CorrTemp = 0;
	parametres.CorrTempFonte = 0;
	parametres.CorrTempNeige = 0;
	parametres.CorrPr = 1;

    if strcmp(version, 'objDEHall') || strcmp(version, 'objDEH0') || strcmp(version, 'DEH')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(2);
        parametres.TemperatureFonte = x(3);
        parametres.DensiteMaximale = x(4);
        parametres.ConstanteTassement = x(5);
        parametres.TemperaturePluieNeige = x(6);
    end
    if strcmp(version, 'objDEHpr')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(2);
        parametres.TemperatureFonte = x(3);
        parametres.DensiteMaximale = x(4);
        parametres.ConstanteTassement = x(5);
        parametres.TemperaturePluieNeige = x(6);
		parametres.CorrPr = x(7);
    end
    if strcmp(version, 'objDEHprl')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(2);
        parametres.TemperatureFonte = x(3);
        parametres.ConstanteTassement = x(4);
        parametres.TemperaturePluieNeige = x(5);
		parametres.CorrPr = x(6);
    end
    if strcmp(version, 'Old') || strcmp(version, 'objDEH')  ||strcmp(version, 'objDEHInsDir')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(1);
        parametres.TemperatureFonte = x(2);
        parametres.DensiteMaximale = x(3);
        parametres.ConstanteTassement = x(4);
        parametres.TemperaturePluieNeige = x(5);
    end

    if strcmp(version, 'objDEHalt')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(1);
        parametres.TemperatureFonte = x(2);
        parametres.DensiteMaximale = x(3);
        parametres.ConstanteTassement = x(4);
        parametres.TemperaturePluieNeige = x(5);
        parametres.CorrTemp = x(6);
        parametres.CorrTempFonte = x(6);
        parametres.CorrTempNeige = x(6);
    end
    if strcmp(version, 'objDEHalt2')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(1);
        parametres.TemperatureFonte = x(2);
        parametres.DensiteMaximale = x(3);
        parametres.ConstanteTassement = x(4);
        parametres.TemperaturePluieNeige = x(5);
        parametres.CorrTempFonte = x(6);
        parametres.CorrTempNeige = x(7);
    end

    if  strcmp(version, 'objDEHlat') || strcmp(version, 'objDEHaltlat')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(1);
        parametres.TemperatureFonte = x(2);
        parametres.ConstanteTassement = x(3);
        parametres.TemperaturePluieNeige = x(4);
        parametres.CorrTemp = x(5);

    end
    if  strcmp(version, 'objDEHlatpr')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(2);
        parametres.TemperatureFonte = x(3);
        parametres.ConstanteTassement = x(4);
        parametres.TemperaturePluieNeige = x(5);
        parametres.CorrTemp = x(6);
		parametres.CorrPr = x(7);
    end
    if  strcmp(version, 'objDEHlat0')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(1);
        parametres.TemperatureFonte = x(2);
        parametres.ConstanteTassement = x(3);
        parametres.TemperaturePluieNeige = x(4);
    end
    
    if  strcmp(version, 'objDEHlat2') || strcmp(version, 'objDEHaltlat2')
        parametres.TauxFonteSol = x(1);
        parametres.CoefficientFonte = x(1);
        parametres.TemperatureFonte = x(2);
        parametres.ConstanteTassement = x(3);
        parametres.TemperaturePluieNeige = x(4);
        parametres.CorrTempFonte = x(5);
        parametres.CorrTempNeige = x(6);
    end
end
