classdef Agent
    
    % Agent object
    
    properties
        currentPos  WorkingMemory       % [N x numSamples] per dimension, agent's current position as a Laplace representation within working memory
        futurePos   WorkingMemory       % [N x numSamples] per dimension, agent's future position as a Laplace representation withing working memory  
    end
    
    methods
        
        function obj = Agent(k,Ck,numDecayRates,nSamples)  % Constructor           
            obj.currentPos = WorkingMemory(k,Ck,numDecayRates,nSamples);
            obj.futurePos  = WorkingMemory(k,Ck,numDecayRates,nSamples);           
        end
        
        function obj = buildLaplaceRepresentation(obj,indAxis,f,landmarkIDX,dim,cellAssembly)   
            
            % Builds a Laplace Transform 
            %
            % INPUT:
            %   pos:        independent axis for the function f
            %   f:          function from which to build the Laplace Transform
            %   landmarkIDX:index of landmark in discrete units 
            %   dim:        dimension on which to operate
            %
            % OUTPUT:
            %   laplaceRep: This is really the Laplace Transform over time [need
            %   to change this name, because "laplaceRep" is not really
            %   representative of what the variable contains.
            
            for idx = landmarkIDX.(dim)                                                                     % superimpose multiple impulse functions, one for each non-zero landmark in f   
                for i = 1:length(obj.currentPos.s)                                                          % for each decay rate
                    tmpBasis = zeros(1,length(indAxis.(dim)));                                              % initialize the i-th basis function
                    tmpBasis(idx:end) = f.(dim)(idx)*exp(-indAxis.(dim)(1:end-idx+1)*obj.currentPos.s(i));  % build the i-th basis function 
                    obj.currentPos.laplaceRep.(dim)(i,:) = obj.currentPos.laplaceRep.(dim)(i,:) + tmpBasis; % generate Laplace representation by superimposing the i-th basis
                end     % for i
            end         % for idx = idx_t_prime     
            
        end
        
        function [f_tilde,x_star] = estimateInverseLaplace(obj,dim,cellAssembly)   
            
            % Computes an inverse Laplace Transform by employing the Post 
            % approximation (1930).
            %
            % INPUT:
            % Agent class
            %   laplaceRep: F(s), the Laplace representation 
            %   Ck:         scaling constant
            %   dim:        dimension on which to operate
            %
            % OUTPUT:
            %   f_tilde:    estimate of landmark position
            %   x_star:     log-scale independent axis on which f_tilde exists
            
            der = obj.currentPos.laplaceRep.(dim)(:,end);                                                      
            for iter = 1:obj.currentPos.k                                                                   % take k-th derivative  
                der = obj.currentPos.Ck(obj.currentPos.k) * diff(der);
            end
            f_tilde = obj.currentPos.s(1:numel(der)).^(obj.currentPos.k+1) .* der';                         % Post approximation           
            x_star = -obj.currentPos.k * 1./obj.currentPos.s(1:numel(der));        
            
        end
        
        function obj = translateLaplaceRepresentation(obj,delta,dim,cellAssembly)  
            
            % Apply the unitary Laplace translation operator, multiplication in the
            % Laplace domain by an exponential function of s. We do this
            % here for every time in which the Laplace represention exists.
            %
            % INPUT
            %   delta:  amount to translate
            %   dim:    dimension on which to operate
            %
            % OUTPUT:
            %   translated F(s)
            
            [~,nCol] = size(obj.currentPos.laplaceRep.(dim));
            obj.(cellAssembly).laplaceRep.(dim) = obj.(cellAssembly).laplaceRep.(dim) .* repmat(exp(-obj.(cellAssembly).s * delta)',1,nCol);  
            
        end
        
        function obj = convolutionLaplaceRepresentation(obj,varargin)  
            
            % Apply the binary convolution operator in the Laplace domain.
            % This is pointwise multiplication of two Laplace representations.
            % Computes L(f(x)*g(x)) = L(F(s)G(s)), with the inverse becoming 
            % [f+g](x).
            %
            % INPUT
            %   F(s):   Laplace representation internal to agent's working memory
            %   G(s):   Laplace representation internal to agent's working
            %           memory or brought into working memory from long-term memory
            %   dim:    dimension on which to operate
            %
            % OUTPUT:
            %   F(s)G(s)
            
        end
        
        function obj = crossCorrLaplaceRepresentation(obj,varargin)  
            
            % Apply the binary cross-correlation operator in the Laplace domain.
            % This is pointwise multiplication of two Laplace representations, one flipped.
            % Computes L(f(x)#g(x)) = L(F(s)G(-s)), with the inverse becoming
            % [f-g](x).
            %
            % INPUT
            %   F(s):   Laplace representation internal to agent's working memory
            %   G(s):   Laplace representation internal to agent's working
            %           memory or brought into working memory from long-term memory
            %   dim:    dimension on which to operate
            %
            % OUTPUT:
            %   F(s)G(-s)
            
        end
                
    end % methods
    
end % class

