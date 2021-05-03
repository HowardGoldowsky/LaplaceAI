classdef Agent
    
    % Agent object
    
    properties
        s                       % [1 x N], decay rates in agent's entorhinal cortex cell assembly, Laplace representation's independent variable
        k                       % accuracy of inverse Laplace estimation, k = 4 was used in the cited paper
        Ck                      % [1 x k], constants used in inverse Laplace estimate
        basis                   % [N x numSamples], agent's Laplace representation 
    end
    
    methods
        
        function obj = Agent(k,Ck,numDecayRates,nSamples)  % constructor  
            
            obj.s = 1:numDecayRates;                                                    
            obj.k = k;      
            obj.Ck = Ck;
            obj.basis = zeros(numDecayRates,nSamples);    
            
        end
        
        function obj = buildLaplaceRepresentation(obj,t,f,idx_t_prime)   
            
            % Builds a Laplace Transform 
            %
            % INPUT:
            %   t: time vector (independent axis for function, f)
            %   f: function from which to build the Laplace Transform
            %
            % OUTPUT:
            %   basis: This is really the Laplace Transform over time [need
            %   to change this name, because "basis" is not really
            %   representative of what the variable contains.
      
            for idx = idx_t_prime                                                       % superimpose multiple impulse functions, one for each non-zero sample in f   
                for i = 1:length(obj.s) 
                    tmpBasis = zeros(1,length(t));
                    tmpBasis(idx:end) = f(idx)*exp(-t(1:end-idx+1)*obj.s(i));           % generate Laplace basis functions for each non-zero sample in f
                    obj.basis(i,:) = obj.basis(i,:) + tmpBasis;
                end % for i
            end % for idx = idx_t_prime     
            
        end
        
        function [f_tilde,t_star] = estimateInverseLaplace(obj)   
            
            % Employ the Post approximation (1930)
            der = obj.basis(:,end);                                                      
            for iter = 1:obj.k                                                          % take k-th derivative  
                der = obj.Ck(obj.k) * diff(der);
            end
            f_tilde = obj.s(1:numel(der)).^(obj.k+1) .* der';                           % Post approximation           
            t_star = -obj.k * 1./obj.s(1:numel(der));        
            
        end
        
        function obj = translateLaplaceRepresentation(obj,delta)  
            
            [~,nCol] = size(obj.basis);
            obj.basis = obj.basis .* repmat(exp(-obj.s * delta)',1,nCol);  
            
        end
                
    end % methods
    
end % class

