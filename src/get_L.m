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
     
     B = [0, 0;
         1/m, 1/m;
         -l1/m, l2/m;
         0, 0];

    C = [1,0,0,0;
        0,1,0,0;
        0,0,1,0];

    Q = [C;C*A];
    rank(Q);
    
    p = [-2+2i -2-2i -10+10i -10-10i]; % Desired pole placement
    L = place(A',C',p)' % using MATLAB place function to get L
    eig(A-L*C)
   
     
    p = [-0.1 -0.2 -5 -3]; % Desired pole placement
    K = place(A,B,p); % using MATLAB place function to get K
    eig(A-B*K)
  
   
    
    

end

