function [indAxis,f,display,nSamples,dimWidth,telem] = initScenario()

    % User chosen params
    % x and y positions are analog distances. idx is the index into the
    % array of length nSamples, which represents this analog distance in
    % discrete elements.
    
    dimWidth.x = 2;                     % x-dimensional width of the maze (meters)
    dimWidth.y = 2;                     % y-dimensional length of the maze (meters)
    indAxis.x = 0:0.001:dimWidth.x;     % continuous x-position vector for independent axis (meters, 1 mm resolution)
    indAxis.y = 0:0.001:dimWidth.y;     % continuous y-position vector for independent axis (meters, 1 mm resolution)
    nSamples.x = length(indAxis.x);
    nSamples.y = length(indAxis.y);
    
    f.x = zeros(nSamples.x,1);          % init external driving function; see Equation 2
    f.y = zeros(nSamples.y,1);          % init external driving function; see Equation 2
    
    telem.truth = [0,0];                % recorded positions for calculating error performance 
    telem.robot = [0,0]; 
    
    % Display flags
    display.SHOWBASIS = 1;
    display.SHOWESTIMATE = 1;
    display.SHOWPATH = 1;

end

