function[L,ia,ib]=blocklen(x,delta)
%BLOCKLEN Counts the lengths of 'blocks' in an array.
%
%   Suppose X is a column vector which contains blocks of identical
%   values, e.g. X=[0 0 0 1 1 3 2 2 2]';
%
%   L=BLOCKLEN(X) counts the lengths of contiguous blocks containing
%   identical values of X, and returns an array L of size SIZE(X).
%   Each elements of L specifies the length of the block to which the
%   corresponding element of X belongs.
%
%   In the above example, L=[3 3 3 2 2 1 3 3 3]';
%
%   [L,IA,IB]=BLOCKLEN(X) optionally returns indices IA and IB into
%   the first and last elements, respectively, of each block.
%
%   [...]=BLOCKLEN(X,D) defines the junction between two blocks as
%   locations where ABS(DIFF(X))>D.  Thus D=1 is a 'rate of change'
%   definition, and X=[1 2 3 5 6 10 16 17 18]'; will yield the same 
%   result for L as in the previous example.
%
%   Usage: [L,ia,ib]=blocklen(x);  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details
  
  
% 06.09.04 JML fixed incorrect IA, IB output length

if strcmp(x,'--t')
  blocklentest;return;
end

if nargin==1
  delta=0;
end

ii=[1:length(x)]';

index=find(diff(x)~=delta);
ia=[1;index+1];
ib=[index;length(ii)];

L=zeros(size(ii));
L(ia)=ib-ia+1;
L=cumsum(L);

L0=zeros(size(ii));
ib2=ib(1:end-1);
ia2=ia(1:end-1);
L0(ib2+1)=ib2-ia2+1;
L0=cumsum(L0);
L=L-L0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[]=blocklentest
x= [0 0 0 1 1 3 2 2 2]';
y= [3 3 3 2 2 1 3 3 3]';

reporttest('BLOCKLEN with D==0',all(y==blocklen(x)))

x=[1 2 3 5 6 10 16 17 18]';
reporttest('BLOCKLEN with D==1',all(y==blocklen(x,1)))


