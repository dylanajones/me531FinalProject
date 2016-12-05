% Function to get the newly estimated state

function [est_state] = observer_state(est_state,actual_state,L,C,A,B,u)
    
    time_step = 0.1;

    state_dot = A*est_state' + B*u + L*C*(actual_state - est_state)';
    
    state_dot = state_dot * time_step;
    
    est_state = est_state + state_dot';

end