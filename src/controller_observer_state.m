function state = controller_observer_state( true_state,C,A,L)
state = true_state';
for i = 1:10
    state_update = (A-L*C)*state;
    state = state_update;
end
    
%     obs = C*true_state';
%     
%     update = (A*est_state' + B*control_inputs)*0.1 + L*(obs - C*est_state');
%     
%     state = est_state' + update;


end

