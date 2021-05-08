classdef Environment
    
    % Class environment for the robot agent. Contains parameters for the
    % environment.
    
    properties
        
        grid                % grid world maze environment, [500 x 500] 
       
    end
    
    methods
        
        function obj = Environment(letter)          % Constructor
            obj = buildAgentEnv(letter);
        end
        
        function obj = buildAgentEnv(obj, letter)
            % INPUT: 
            %   A grayscale PNG file of a maze Boolean [N x N] array
            %   that acts as an environment for the agent.
            %
            % OUTPUT: 
            %   Boolean [N x N] array that acts as an environment for the agent.

            raw = imread(letter);
            tmpImage = raw(:,:,1) > 0;     
            obj.grid = imagesc(tmpImage);
        end
        
    end % methods
    
end % class

