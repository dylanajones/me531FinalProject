% Function to produce an ellipse at the point where the vehicle is
% Size of the ellipse is predefined based upon how big the vehicle is

function [ellipse] = get_ellipse(centerX, centerY, orientation)
    
    xAxis = .75;
    yAxis = .11;
    
    theta = linspace(0, 2*pi, 150);
    
    xx = (xAxis) * sin(theta) + centerX;
    yy = (yAxis) * cos(theta) + centerY;
    
    xx2 = (xx-centerX)*cos(orientation) - (yy-centerY)*sin(orientation) + centerX;
    yy2 = (xx-centerX)*sin(orientation) + (yy-centerY)*cos(orientation) + centerY;
    
    ellipse = [xx2',yy2'];

end