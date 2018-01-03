function [R, S] = affineSFM(x, y)
% Function: Affine structure from motion algorithm
%
%x=track_x(valid, :);
%y=track_y(valid, :);
%
% Normalize x, y to zero mean
xn=x-mean(x);
yn=y-mean(y);

% Create measurement matrix
D=[xn';yn'];
% Decompose and enforce rank 3

[U, W, V]=svd(D);

U3=U(:,1:3);
W3=W(1:3,1:3);
V3=V(:,1:3);

A=U3*sqrtm(W3);
X=sqrtm(W3)*V3';

% Apply orthographic constraints
%Solving for L using ax=b, where a=3m x 9 constructed from A, x= 9 x 1,
%constructed from L and b = 1,0 etc

A1=A(1:end/2,:);
A2=A(1+end/2:end,:);

b=[];
A_m=[];

for i =1:size(A1,1)
    A_m=[A_m;reshape(A1(i,:)'*A1(i,:),[1,9])];  %aa is 3x9 corresponding to i and i+1 rows of A
    A_m=[A_m;reshape(A2(i,:)'*A2(i,:),[1,9])];
    A_m=[A_m;reshape(A1(i,:)'*A2(i,:),[1,9])];
    
    bb=[1,1,0];
    b=[b;bb'];
end

L=A_m\b;
L=reshape(L,[3,3]);

C=chol(L,'lower');

A=A*C;
X=(inv(C))*X;

R=A;
S=X;