function offsprings=ReechantillonerResidu(weights)
%----------------------------------------------------------------------------
% RESIDUAL RESAMPLING PROCEDURE for particle filter algorithms
% INPUT   weights : probability measure
%         (it is not checked that the sum of the weights is one)
% OUTPUT  offsprings : drawn offsprings
%
% offsprings(k)=j 
%
% means that the point k is resampled j times resampling according
% to the probability measure weights(k) k=1:np with
% np=length(weights)  
%  1) one calculates the integer parts of np*weights
%  2) one draws the residual particles according to the "law from
%     the remainders" : weights(k)-floor(weights(k)*np)/np   k=1:np 
%----------------------------------------------------------------------------
% cf. J.S. Liu, R. Chen. Sequential Monte Carlo methods for dynamic
% systems, Journal of the American Statistical Association, 93
% (443) 1032-1044, 1998. 
%----------------------------------------------------------------------------
% Fabien Campillo INRIA 
% created   November 15 2002 
% modified  July     25 2003
%----------------------------------------------------------------------------

np = length(weights);

% --- one calculates the np first points

offsprings = floor(np*weights);
weights    = weights - (1/np)*offsprings;

% ---- there remains np-sum(offsprings) particles to be drawned

nnp        = np - sum(offsprings);
weights    = weights/sum(weights);
weights    = cumsum(weights);

for k=1:nnp
  threshold = rand;
  i = 1;
  while weights(i)<threshold, i = i+1; end
  offsprings(i) = offsprings(i)+1;
end
% =========================================================================
% Author: Fabien Campillo Fabien.Campillo@inria.fr 
% This source code is freely distributed for educational, research and 
% non-profit purposes. Permission to use it in commercial products may 
% be obtained from the author.
% =========================================================================


