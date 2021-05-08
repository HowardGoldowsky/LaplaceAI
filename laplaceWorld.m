% Scenario to run a robot agent through a grid world, using the Laplace
% transform as a navigation tool.

% Based on the paper, "A Unified Mathematical Framework for Coding Time,
% Space, and Sequences in the Hippocampal Region." Marc Howard, Christopher
% MacDonald, Zorn Tiganj, Karthik Shankar, Quian Du, Michael Hasselmo, and
% Howard Eichenbaum.

% This code suite applies Figure 2 of the paper. The larger s, the shorter 
% the time scales; the smaller s, the longer the time scales. The time 
% constant of each cell in the intermediate representation is just 1/s. 
% Equation 4 is the solution to the DEQ describing dF/dt. The solution
% is an integration from a past time up until the present. This is the same
% as summing discrete samples from t = t_prime to t = N. t = N is equivalent to
% tau = 0 in the paper, the present moment. Each sample in f(t) has a phase
% equal to t-t_prime and an amplitude, both which "scale" a superposition
% of bases for that sample. 

% Initialize scenario
clear;
[pos,f,idx,display,nSamples] = initScenario();                   

% Initialize Agent
numCellsEC = 100;                                       % number of cells in agent's Entorhinal Cortex (EC), the Laplace domain
k = 4;                                                  % used for calc of inverse Laplace; k = 4 was used in the cited paper
Ck = .072*(1:k);                                        % Initialize Ck for Post 1930 estimate of inverse Laplace transform
robot = Agent(k,Ck,numCellsEC,nSamples);                % construct the virtual robot agent

% Train the robot by leading it from the origin to the landmark.
robot = robot.buildLaplaceRepresentation(pos,f,idx);
[f_tilde,x_star] = robot.estimateInverseLaplace();

% Translate
delta = 0.5; % seconds
robot = robot.translateLaplaceRepresentation(delta);
[f_tilde_tran,~] = robot.estimateInverseLaplace();

% Init and call display functions
display.f_tilde = f_tilde;
display.f_tilde_tran = f_tilde_tran;
display.x = pos.x;
display.x_star = x_star;
displayFunctions(display,robot);