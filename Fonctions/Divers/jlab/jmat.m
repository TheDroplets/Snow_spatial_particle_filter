function[x]=jmat(theta)
%JMAT 2-D rotation matrix through specified angle.
%
%   J=JMAT(TH) creates a rotation matrix 
%
%       J=[COS(TH) -SIN(TH);
%          SIN(TH) COS(TH)]; 
%
%   such that J*X rotates the column-vector X by TH radians
%   counterclockwise.
%
%   If LENGTH(TH)>1, then J will have dimension 2 x 2 x LENGTH(TH).
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        
  
if length(theta)>1;
%  theta=permute(row2col(theta),[3,2,1]);
   theta=theta(:);
end

x=zeros(2,2,length(theta));
x(1,1,:)=cos(theta);
x(1,2,:)=-sin(theta);
x(2,1,:)=sin(theta);
x(2,2,:)=cos(theta);

%x=jmat1(theta);  
%function[x]=jmat1(theta);  
%x=[cos(theta) -sin(theta); sin(theta) cos(theta)];

