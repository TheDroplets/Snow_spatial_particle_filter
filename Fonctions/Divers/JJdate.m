function [JJ] = JJdate (date)

% Petite fonction qui calcule le jour julien a partir d'une date en numero
% de serie. Il faut que date soit un scalaire (pas un vecteur). Donc une
% seule date à la fois.

date_separe = datevec(date);
A = date_separe(:,1);
M = date_separe(:,2);

J = date_separe(:,3);

test = and(mod(A,4)==0,or(mod(A,100)~=0,mod(A,400)==0));
x = test+0;
JJ = floor(275*M/9)-(2-x).*floor((M+9)/12)+J-30;
end