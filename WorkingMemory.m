classdef WorkingMemory
    
    % WorkingMemory object
    % This class models the working memory of an agent as a Laplace
    % transform representation
    
    properties
        s               % [1 x N], decay rates in agent's entorhinal cortex cell assembly, the Laplace representation's independent variable
        k               % accuracy of inverse Laplace estimation; k = 4 was used in the cited paper
        Ck              % [1 x k], constants used in inverse Laplace estimate
        laplaceRep      % [N x numSamples], agent's Laplace representation of landmark, x dimension
    end
    
    methods
        function obj = WorkingMemory(k,Ck,numDecayRates,nSamples) % Constructor
            obj.s = 1:numDecayRates;                                                    
            obj.k = k;      
            obj.Ck = Ck;
            obj.laplaceRep.x = zeros(numDecayRates,nSamples.x); 
            obj.laplaceRep.y = zeros(numDecayRates,nSamples.y); 
        end  
        
    end
end

