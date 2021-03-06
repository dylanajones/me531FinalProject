% Function to calculate the K matrix

function K = get_K()
    
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
     
    p = [-0.1 -0.2 -5 -3]; % Desired pole placement
    K = place(A,B,p); % using MATLAB place function to get K

end