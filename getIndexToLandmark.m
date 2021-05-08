function idx = getIndexToLandmark(landmarkPos,nSamples,dimWidth)

    % Function accepts a landmark position in continuous space and returns an
    % index to that position in the robot's discrete units.

    idx = floor(landmarkPos * nSamples / dimWidth);     % index to landmark 
    
end

