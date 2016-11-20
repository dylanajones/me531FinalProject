% Function to calculate what the control forces should be

function [b1, b2] = get_control_forces(state, desired, K)
    
    xOff = desired - state;
    
    F = K * xOff;

    b1 = 0;
    b2 = 0;
end