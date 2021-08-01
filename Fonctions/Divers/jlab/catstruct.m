function[z]=catstruct(x,y)
%CATSTRUCT  Concatenates the (matrix) elements of two structures.
%
%   Let X and Y be data structures having identical field names, the
%   fields themselves being matrices, for example
%
%      X.A=M1;   Y.A=M2;   
%      X.B=M3;   Y.B=M4;   
%
%   Z=CATSTRUCT(X,Y) returns a structure Z 
%
%      Z.A=M5;   Z.B=M6;
%
%   whose fields result from concatenating the X-matrices row-by-row
%   with the Y-matrices.  In this example, Z.A is a matrix having
%   MAX(SIZE(X.A,1),SIZE(Y.A,1)) rows and SIZE(X.A,2)+SIZE(Y.A,2)
%   columns.
%
%   Matrices are padded with NANs for real-balued data and with 
%   NAN+SQRT(-1)*NAN for complex data.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2003--2005 J.M. Lilly --- type 'help jlab_license' for details

  
fx=fields(x);
fy=fields(y);

for k=1:length(fx)
  if ~aresame(fx{k},fy{k})
    error('X and Y must have identical fields')
  end
end

z=[];
for i=1:length(fx);
   vx=getfield(x,fx{i});
   vy=getfield(y,fx{i});
   N=max(size(vx,1),size(vy,1));
 
   if all(isreal(vx))  
      vz=nan*zeros(N,size(vx,2)+size(vy,2));
   else
      vz=(nan+sqrt(-1)*nan)*zeros(N,size(vx,2)+size(vy,2));
   end
   vz(1:size(vx,1),1:size(vx,2))=vx;
   vz(1:size(vy,1),[1:size(vy,2)]+size(vx,2))=vy;
   z=setfield(z,fx{i},vz);
end

     
