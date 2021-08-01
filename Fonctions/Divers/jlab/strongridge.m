function[struct]=ridgeprune(struct)
% RIDGEPRUNE Remove all but the largest-amplitude ridges.
%
%   STRUCTS=RIDGEPRUNE(STRUCT) where STRUCT is a ridge structure as
%   output by RIDGEWALK, returns a new structure STRUCTS containing
%   only the strongest ridges, that is, only those ridges which obtain 
%   the largest magnitude, ABS(WR), at each time.  
%
%   For multiple components data sets, this criterion is applied to 
%   each component separately.
%
%   RIDGEPRUNE connects ridges that are contiguous in time.
% 
%   Usage:  structs=ridgeprune(struct);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2006 J.M. Lilly --- type 'help jlab_license' for details    


use struct

%Sort by start time
if ~isempty(kr)
    
    for k=1:maxmax(kr)
        ki=find(kr(1,:)==k);
        if ~isempty(ki)
           [temp,jj]=sort(ir(1,ki));
           kindex(ki)=ki(jj);
        end
    end
    vindex(wr,fr,ir,jr,kr,kindex,2);

    mat2col(wr,fr,ir,jr,kr);
    vindex(wr,fr,ir,jr,kr,find(islargest(ir,kr,wr)),1);

    dir=vdiff(ir,1);
    dir(1)=1;dir(end)=1;
    dkr=vdiff(kr,1);
    dkr(1)=1;dkr(end)=1;

    nr=cumsum(dir~=1&dkr~=1);

    colbreaks(nr,wr,fr,ir,jr,kr);
    col2mat(nr,wr,fr,ir,jr,kr);

    %That was easy

    if allall(isnan(ir));
        ir=[];jr=[];kr=[];wr=[];fr=[];
    end

    struct.ir=ir;
    struct.jr=jr;
    struct.kr=kr;
    struct.wr=wr;
    struct.fr=fr;

end

%struct.nr=nr;