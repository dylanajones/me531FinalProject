function  observed_state = get_observed_state( L,desired_state,actual_state )
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
        0,0,0,1];
    
    observed_state = (A-L*C)*(desired_state-actual_state)';
     

end

