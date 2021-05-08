function [pos,f,idx,display,nSamples] = initScenario()

    % User chosen params
    % x and y positions are analog distances. idx is the index into the
    % array of length nSamples, which represents this analog distance in
    % discrete elements.
    
    dimWidth.x = 2;                                                     % x-dimensional width of the maze (meters)
    dimWidth.y = 2;                                                     % y-dimensional width of the maze (meters)
    landmarkPos.x = 1.5;                                                % x-position of the landmark from origin (meters)
    landmarkPos.y = 1.5;                                                % y-position of the landmark from origin (meters)
    pos.x = 0:0.001:dimWidth.x;                                         % x-position vector (meters, 1 mm resolution)
    pos.y = 0:0.001:dimWidth.y;                                         % y-position vector (meters, 1 mm resolution)
    nSamples.x = length(pos.x);
    nSamples.y = length(pos.y);
    
    % Derived params
    f.x = zeros(nSamples.x,1);                                          % init external driving function; see Equation 2
    f.y = zeros(nSamples.y,1);                                          % init external driving function; see Equation 2
    idx.x = getIndexToLandmark(landmarkPos.x,nSamples.x,dimWidth.x);    % index to landmark x dimension
    idx.y = getIndexToLandmark(landmarkPos.y,nSamples.y,dimWidth.y);    % index to landmark y dimension
    f.x(idx.x) = 1;                                                     % delta function at impulse moments to represent landmark
    f.y(idx.y) = 1;                                                     % delta function at impulse moments to represent landmark
    
    % Display flags
    display.SHOWBASIS = 1;
    display.SHOWESTIMATE = 1;

end

