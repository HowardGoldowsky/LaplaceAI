% Scenario to run a robot agent through a grid world, using the Laplace
% transform as a navigation tool.

% Based on the paper, "A Unified Mathematical Framework for Coding Time,
% Space, and Sequences in the Hippocampal Region." Marc Howard, Christopher
% MacDonald, Zorn Tiganj, Karthik Shankar, Quian Du, Michael Hasselmo, and
% Howard Eichenbaum.

% This script is an effort to reproduce Figure 2 of the paper. The larger 
% s, the shorter the time scales; the smaller s, the longer the time 
% scales. The time constant of each cell in the intermediate representation is just
% 1/s. Equation 4 is the solution to the DEQ describing dF/dt. The solution
% is an integration from a past time up until the present. This is the same
% as summing discrete samples from t = t_prime to t = N. t = N is equivalent to
% tau = 0 in the paper, the present moment. Each sample in f(t) has a phase
% equal to t-t_prime and an amplitude, both which "scale" a superposition
% of bases for that sample. 

% Display flags
SHOWBASIS = 1;
SHOWESTIMATE = 1;

% Initialize scenario
durationSeconds = 2;                                                    % duration of driving function, f(t) (seconds)
%impulseMoment = [0.1, 1.5];                                             % seconds
impulseMoment = [1.5];     
t = 0:0.001:durationSeconds;                                            % time vector (seconds, 1 ms resolution)
nSamples = length(t);
f = zeros(nSamples,1);                                                  % init external driving function; see Equation 2
idx_t_prime = floor(impulseMoment*nSamples/durationSeconds);            % index to impulse moment
%f(idx_t_prime) = [1, .003];                                                % delta function at impulse moments
f(idx_t_prime) = [1];                                                

% Initialize Agent
numCellsEntorhinalCortex = 100;                                         % number of cells in agent's Entorhinal Cortex (EC), the Laplace domain
k = 4;                                                                  % used for calc of inverse Laplace; k = 4 was used in the cited paper
Ck = .072*(1:k);                                                        % Initialize Ck for Post 1930 estimate of inverse Laplace transform
robot = Agent(k,Ck,numCellsEntorhinalCortex,nSamples);                  % construct the virtual robot agent

% Run the virtual scenario
robot = robot.buildLaplaceRepresentation(t,f,idx_t_prime);
[f_tilde,t_star] = robot.estimateInverseLaplace();

% Translate
delta = 0.5; % seconds
robot = robot.translateLaplaceRepresentation(delta);
[f_tilde_tran,~] = robot.estimateInverseLaplace();

% Show what the Laplace transform looks like over time.
if (SHOWBASIS)
    figure;
    for i = 1:9  
        plot(t,robot.basis(i,:),'LineWidth',2); hold on;
    end
    title({'Laplace Transform, F(s),','9 Slowest Time Constants'},'FontSize',14)
    xlabel('Time (s)','FontSize',14)
    ylabel('Firing Rate','FontSize',14)
end

if (SHOWESTIMATE)
    figure;
    plot(t_star,f_tilde,'x-');hold on;plot(t_star,f_tilde_tran,'x-')
    legend('f\_tilde','f_tilde_tran','FontSize',14);
    title({'Inverse Laplace Transform','Remembered Signal'},'FontSize',14)
    xlabel('Past Time','FontSize',14)
end