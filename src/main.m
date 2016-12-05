% Script to run ODE model

function main(export, skip)
    
    % Default so that we dont skip or export if we dont want to 
    if nargin < 2
		
		skip = [0 0];
		
		if nargin < 1
			
			export = [0 0];
			
		end
		
    end
    
    % Create animation elements, and store them in the frame_info structure
% 	frame_info = uncontrolled_glider_create_elements; %setup function, defined below in file
    
    %%% Section 1: Generating the movie for the uncontrolled glider
    
    % y is the state out, [0, 20] is the time interval, and the final argument
    % is the intial starting state
%     b1 = 0;
%     b2 = 0;
% 
%     time_len = [0:.1:60];
%     % state = [theta, theta_dot, y, y_dot, x, x_dot]
%     init_cond = [-pi/4,0,0,1,0,1];
% 
%     [t,y] = ode45(@(t,y) state_ode_model(t,y,b1,b2),time_len,init_cond);
%     
%     xyt_pos = [y(:,5), -y(:,3), y(:,1)];
%     
%     % Movie: uncontrolled glider moving
%     frame_gen_function = @(frame_info, tau) uncontrolled_glider(xyt_pos, frame_info, tau);
%     
%     % Declare timing
% 	timing.duration = 10; % seconds
% 	timing.fps = 15;     % fps
% 	timing.pacing = @(y) softspace(0,1,y); % Use a soft start and end, using the included softstart function
% 
%     destination = 'uncontrolled_glider';
%     
%     % Animate the movie
% 	[frame_info, endframe]...
% 		= animation(frame_gen_function,frame_info,timing,destination,export(1),skip(1));
    
    %%% Section 2: Generating movie for the controlled glider
    
    num_steps = 10 * 60 * 3; %10 steps in one second
    init_cond = [-pi/4,0,0,1,0,1];
    desired_state = [1, 1, 0, -pi/4];
    est_state = desired_state;
    %est_state = [0, 0, 0, 0];
    state = est_state;
    
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
        0,0,1,0];
    
    B = [0, 0;
         1/m, 1/m;
         -l1/m, l2/m;
         0, 0];
    
    K = get_K();
    L = get_L();
    
    glider_state = zeros(num_steps+1,8);
    glider_state(1,1:6) = init_cond;
    
    err = zeros(num_steps,4);
    
    % Number of steps to simpulate
    for i = 1:num_steps
       
        %display(i)
%         state = [y(end,6), y(end,4), y(end,2), y(end,1)];
%         pred_state = controller_observer_state( state,C,A,L)';
        err(i,:) = state-est_state;        
        [b1, b2] = get_control_forces(est_state, desired_state, K);
        [b1, b2] = scale_forces(b1, b2);
        time_len = [0 .1];
        start_cond = glider_state(i,1:6);
        [t,y] = ode45(@(t,y) state_ode_model(t,y,b1,b2),time_len,start_cond);
        glider_state(i+1,1:6) = y(end,:);
        glider_state(i,7) = b1;
        glider_state(i,8) = b2;
        state = [glider_state(i,6), glider_state(i,4), glider_state(i,2), glider_state(i,1)];
        u = [b1;b2];
        % Do observer Stuff
        est_state = observer_state(est_state,state,L,C,A,B,u);
    end
    
    xyt_pos = [glider_state(:,5), -glider_state(:,3), glider_state(:,1)];
    
    frame_info = controlled_glider_create_elements;
    
    % Movie: controlled glider moving
    frame_gen_function = @(frame_info, tau) controlled_glider(xyt_pos, frame_info, tau);
    
    % Declare timing
	timing.duration = 10; % seconds
	timing.fps = 15;     % fps
	timing.pacing = @(y) softspace(0,1,y); % Use a soft start and end, using the included softstart function

    destination = 'uncontrolled_glider';
    
    % Animate the movie
	[frame_info, endframe]...
		= animation(frame_gen_function,frame_info,timing,destination,export(1),skip(1));
    
    figure()
    plot(err(:,1),'r');
    hold on
    plot(err(:,2),'b');
    plot(err(:,3),'g');
    plot(err(:,4),'m');
    
end

% Create animation elements, and return a vector of their handles
function h = uncontrolled_glider_create_elements

	h.f = figure(17);                            % Designate a figure for this animation
	clf(h.f)                                     % Clear this figure
	set(h.f,'color','w','InvertHardCopy','off')  % Set this figure to have a white background
												 %  and to maintain color
												 %  settings during printing

	h.ax = axes('Parent',h.f);                   % Create axes for the plot
	set(h.ax,'Xlim',[0 40],'Ylim',[-15 3]);   % Set the range of the plot
	set(h.ax,'Xtick',0:4:40,'YTick',-15:4:3);   % Set the tick locations
	set(h.ax,'FontSize',20);                       % Set the axis font size
	xlabel(h.ax, 'x (m)')							 % Label the axes
	ylabel(h.ax, 'y (m)')
	set(h.ax,'Box','on')						 % put box all the way around the axes
    title(h.ax, 'Uncontrolled Glider')


	% Line element to be used to draw the path
	h.line1 = line(0,0,'Color',[235 14 30]/255,'linewidth',5,'Parent',h.ax);
    h.line2 = line(0,0,'Color',[0 0 255]/255,'linewidth',5,'Parent',h.ax);
    

end

% Create animation elements, and return a vector of their handles
function h = controlled_glider_create_elements

	h.f = figure(18);                            % Designate a figure for this animation
	clf(h.f)                                     % Clear this figure
	set(h.f,'color','w','InvertHardCopy','off')  % Set this figure to have a white background
												 %  and to maintain color
												 %  settings during printing

	h.ax = axes('Parent',h.f);                   % Create axes for the plot
	set(h.ax,'Xlim',[0 40],'Ylim',[-37 3]);   % Set the range of the plot
	set(h.ax,'Xtick',0:4:40,'YTick',-37:8:3);   % Set the tick locations
	set(h.ax,'FontSize',20);                       % Set the axis font size
	xlabel(h.ax, 'x (m)')							 % Label the axes
	ylabel(h.ax, 'y (m)')
	set(h.ax,'Box','on')						 % put box all the way around the axes
    title(h.ax, 'Observer / Controller Glider')


	% Line element to be used to draw the path
	h.line3 = line(0,0,'Color',[235 14 30]/255,'linewidth',5,'Parent',h.ax);
%     h.line2 = line(0,0,'Color',[0 0 255]/255,'linewidth',5,'Parent',h.ax);
    h.line1 = line(0,0,'Color',[0 0 0], 'linewidth',4,'Parent',h.ax,'LineStyle','--');

end

function frame_info = uncontrolled_glider(data, frame_info, tau)
    

    
    x = data(1:round(tau*length(data(:,1))),1);
    y = data(1:round(tau*length(data(:,1))),2);
    
    set(frame_info.line1,'XData',x,'YData',y)
    
    
    if ~isempty(x)
        ellipse = get_ellipse(x(end),y(end),data(end,3));
        set(frame_info.line2,'XData',ellipse(:,1),'YData',ellipse(:,2))
    end
    
    frame_info.printmethod = @(dest) print(frame_info.f,'-dpng','-r 150','-painters',dest);
    
end

function frame_info = controlled_glider(data, frame_info, tau)
    
    d_line_x = 0:.1:37;
    d_line_y = -1 * d_line_x;
    
    d_x = d_line_x(1:round(tau*length(d_line_x)));
    d_y = d_line_y(1:round(tau*length(d_line_y)));

    x = data(1:round(tau*length(data(:,1))),1);
    y = data(1:round(tau*length(data(:,1))),2);
    
    set(frame_info.line3,'XData',x,'YData',y)
    set(frame_info.line1,'XData',d_x,'YData',d_y)
    
%     if ~isempty(x)
%         ellipse = get_ellipse(x(end),y(end),data(end,3));
%         set(frame_info.line2,'XData',ellipse(:,1),'YData',ellipse(:,2))
%     end
    
    frame_info.printmethod = @(dest) print(frame_info.f,'-dpng','-r 150','-painters',dest);
    
end