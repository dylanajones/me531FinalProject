function state = controller_observer_state( true_state,C,A,L)
state = true_state';
for i = 1:10
    state_update = (A-L*C)*state;
    state = state+state_update;
end


end

