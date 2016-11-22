
Cl = .5; %.4
Cd = .5; %.4
m = 52; %kg 
l1 = .75; %meters
l2 = .75; %meters

A = [(Cl/2 - Cd)/m, Cl/(2*m), 0, Cl/m;
     -Cl/(2*m), -(Cl/2 + Cd)/m, 0, Cl/m;
     0, 0, 0, 0;
     0, 0, 1, 0];
 
B = [0, 0;
     1/m, 1/m;
     -l1/m, l2/m;
     0, 0]; 
 
P = [B, A*B, A*A*B, A*A*A*B];
P = unique(P', 'rows', 'stable')';

M = [P(:,1),P(:,4),P(:,2),P(:,3)];

mu = 2;

Minv = inv(M);

T = [Minv(1,:); ...
     Minv(2,:)*A; ...
     Minv(3,:); ...
     Minv(4,:) ];
 
Tinv = inv(T);

Abar = T*A*Tinv;


p = [-1 -2 -3 -4];
K = place(A,B,p);






% 
% 
% 
% P = [B, A*B];
% P_inv = inv(P);
% p = P_inv(2,:);
% 
% M_inv = [p; p*A];
% M = inv(M_inv);
% 
% disp(M_inv*A*M)