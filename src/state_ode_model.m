% Function to generate model for theta for ODE45
% Note state = [theta, theta_dot, y, y_dot, x, x_dot]
function state_acc = state_ode_model(t,state)

    m = 5;
    a = 3;
    b = 2;
    r = 0.5;
    
    g = 9.8;
    den = 1000;
    
    B1 = 0;
    B2 = 0;
    
    Cd = 0.277;
    Cl = .5431;
    
    A = 10;
    
    l1 = 5;
    l2 = 5;

    I = m / 5 * (a^2 + b^2);

    state_acc = [state(2); ... 
                 (B1 * l1 * cos(state(1)) - B2 * l2 * cos(state(2))) / I; ...
                 state(4); ...
                 (1/m) * (m*g + .5*den*Cd*r*(2*r+(a+b)*abs(cos(state(1))))*state(4) - .5*den*Cl*A*(state(4)^2+state(6)^2)*cos(state(1)) - B1 - B2); ...
                 state(6); ...
                 (1/m) *  (.5*den*Cl*A*(state(4)^2+state(6)^2)*sin(state(1)) - .5*den*Cd*r*(2*r+(a+b)*abs(sin(state(1))))*state(6))];
                 

end