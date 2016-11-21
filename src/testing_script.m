% Script for testing ...

clear
close all
clc

num_steps = 10 * 60 * 100; %10 steps in one second
init_cond = [-pi/4,0,0,1,0,1];
desired_state = [1, 1, 0, -pi/4];
y = init_cond;

K = get_K();

glider_state = zeros(num_steps+1,8);
glider_state(1,1:6) = init_cond;

% Number of steps to simpulate
for i = 1:num_steps
    %TODO - Add in observer loop here
    display(i)
    state = [y(end,6), y(end,4), y(end,2), y(end,1)];
    [b1, b2] = get_control_forces(state, desired_state, K);
    [b1, b2] = scale_forces(b1, b2);
    time_len = [0 .1];
    start_cond = glider_state(i,1:6);
    [t,y] = ode45(@(t,y) state_ode_model(t,y,b1,b2),time_len,start_cond);
    glider_state(i+1,1:6) = y(end,:);
    glider_state(i,7) = b1;
    glider_state(i,8) = b2;
end

plot(glider_state(:,4))
figure()
plot(glider_state(:,6))