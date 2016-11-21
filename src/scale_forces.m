% Function to scale inputs

function [b1, b2] = scale_forces(b1, b2)
    
    den = 1000; % kg / m^3
    V = pi * .11^2 * 1.5; % m^3
    g = 9.8; % m / s^2
    
    Fmax = den * V * g * 1/2;
    
    B0 = 1.48;
    b1 = b1 + B0;
    b2 = b2 + B0;
    
    if b1 < 0
        b1 = 0;
    end
    
    if b2 < 0
        b2 = 0;
    end
    
    if b1 > Fmax
        b1 = Fmax;
    end
    
    if b2 > Fmax
        b2 = Fmax;
    end

end