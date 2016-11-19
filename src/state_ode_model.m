% Function to generate model for theta for ODE45
% Note state = [theta, theta_dot, y, y_dot, x, x_dot]
function state_acc = state_ode_model(t,state)

    m = 52; %kg
    a = .75; %m
    b = .11; %m
    r = 0.11; %m
    
    g = 9.8; %m/s^2
    den = 1020; %kg/m^3
    
    B1 = 8;
    B2 = 10;
    B0 = (m+.2)*g;
    
    Cd = 0.2770;
    Cl = 0.5431;
    
    A = pi * r^2; %m^2
    
    l1 = .75; %m
    l2 = .75; %m

    I = m / 5 * (a^2 + b^2);

    state_acc = [state(2); ... 
                 (B1 * l1 * cos(state(1)) - B2 * l2 * cos(state(2))) / I; ...
                 state(4); ...
                 (1/m) * (m*g - .5*den*Cd*r*(r*sin(state(1))+(a)*cos(state(1)))*(state(4)) - .5*den*Cl*A*(state(4)^2+state(6)^2)*cos(state(1)) + B1 + B2 - B0); ...
                 state(6); ...
                 (1/m) *  (.5*den*Cl*A*(state(4)^2+state(6)^2)*sin(state(1)) - .5*den*Cd*r*(r*cos(state(1))+(a)*abs(sin(state(1))))*(state(6)))];
                 

end