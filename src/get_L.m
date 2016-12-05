%Function to calculate the L matrix

function L = get_L()
    Cl = .5; %.4
    Cd = .5; %.4
    m = 52; %kg 
    l1 = .75; %meters
    l2 = .75; %meters

    A = [(Cl/2 - Cd)/m, Cl/(2*m), 0, Cl/m;
         -Cl/(2*m), -(Cl/2 + Cd)/m, 0, Cl/m;
         0, 0, 0, 0;
         0, 0, 1, 0];

    C = [1,0,0,0;
        0,1,0,0;
        0,0,1,0];

    p = [-1 -2 -10 -11]; % Desired pole placement
    L = place(A',C',p)'; % using MATLAB place function to get L
  
end

