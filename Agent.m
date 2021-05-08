classdef Agent
    
    % Agent object
    
    properties
        s                       % [1 x N], decay rates in agent's entorhinal cortex cell assembly, Laplace representation's independent variable
        k                       % accuracy of inverse Laplace estimation, k = 4 was used in the cited paper
        Ck                      % [1 x k], constants used in inverse Laplace estimate
        laplaceRep              % [N x numSamples], agent's Laplace representation, X dimension
    end
    
    methods
        
        function obj = Agent(k,Ck,numDecayRates,nSamples)  % constructor  
            
            obj.s = 1:numDecayRates;                                                    
            obj.k = k;      
            obj.Ck = Ck;
            obj.laplaceRep.x = zeros(numDecayRates,nSamples.x);  
            obj.laplaceRep.y = zeros(numDecayRates,nSamples.y);  
            
        end
        
        function obj = buildLaplaceRepresentation(obj,pos,f,idx_x_prime)   
            
            % Builds a Laplace Transform 
            %
            % INPUT:
            %   t: time vector (independent axis for function, f)
            %   f: function from which to build the Laplace Transform
            %
            % OUTPUT:
            %   laplaceRep: This is really the Laplace Transform over time [need
            %   to change this name, because "laplaceRep" is not really
            %   representative of what the variable contains.
      
            for idx = idx_x_prime.x                                                         % superimpose multiple impulse functions, one for each non-zero sample in f   
                for i = 1:length(obj.s)                                                     % for each decay rate
                    tmpBasis = zeros(1,length(pos.x));                                      % initialize the i-th basis function
                    tmpBasis(idx:end) = f.x(idx)*exp(-pos.x(1:end-idx+1)*obj.s(i));         % build the i-th basis function 
                    obj.laplaceRep.x(i,:) = obj.laplaceRep.x(i,:) + tmpBasis;               % generate Laplace representation by superimposing the i-th basis
                end     % for i
            end         % for idx = idx_t_prime     
            
        end
        
        function [f_tilde,x_star] = estimateInverseLaplace(obj)   
            
            % Computes an inverse Laplace Transform by employing the Post 
            % approximation (1930).
            %
            % INPUT:
            %   Agent class
            %   laplaceRep: F(s), the Laplace representation 
            %   Ck: scaling constant
            %
            % OUTPUT:
            %   f_tilde: estimate of landmark position
            %   x_star: independent axis on which f_tilde exists
            
            der = obj.laplaceRep.x(:,end);                                                      
            for iter = 1:obj.k                                                          % take k-th derivative  
                der = obj.Ck(obj.k) * diff(der);
            end
            f_tilde = obj.s(1:numel(der)).^(obj.k+1) .* der';                           % Post approximation           
            x_star = -obj.k * 1./obj.s(1:numel(der));        
            
        end
        
        function obj = translateLaplaceRepresentation(obj,delta)  
            
            % Apply the Laplace translation operator, multiplication in the
            % Laplace domain by an exponential function of s. We do this
            % here for every time in which the Laplace represention exists.
            
            [~,nCol] = size(obj.laplaceRep.x);
            obj.laplaceRep.x = obj.laplaceRep.x .* repmat(exp(-obj.s * delta)',1,nCol);  
            
        end
                
    end % methods
    
end % class

