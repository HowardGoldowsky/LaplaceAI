function env = buildAgentEnv(letter)

    % INPUT: 
    %   A grayscale PNG file of a maze Boolean [N x N] array
    %   that acts as an environment for the agent.
    %
    % OUTPUT: 
    %   Boolean [N x N] array that acts as an environment for the agent.
    
    raw = imread(letter);
    env = raw(:,:,1) > 0;     
    %imagesc(env);
    
end