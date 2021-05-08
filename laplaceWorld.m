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
[indAxis,f,display,nSamples,dimWidth] = initScenario();  

% Initialize Agent
numCellsEC = 100;                                       % number of cells in agent's Entorhinal Cortex (EC), the Laplace domain
k = 4;                                                  % used for calc of inverse Laplace; k = 4 was used in the cited paper
Ck = .072*(1:k);                                        % Initialize Ck for Post 1930 estimate of inverse Laplace transform
robot = Agent(k,Ck,numCellsEC,nSamples);                % construct the virtual robot agent

% Place the initial landmark in continuous space and calculate its index in
% discrete space.
landmarkPos.x = 1.5;                                                        % x-position of the landmark from origin (meters)
landmarkPos.y = 1.5;                                                        % y-position of the landmark from origin (meters)
landmarkIDX.x = getIndexToLandmark(landmarkPos.x,nSamples.x,dimWidth.x);    % index to landmark x dimension
landmarkIDX.y = getIndexToLandmark(landmarkPos.y,nSamples.y,dimWidth.y);    % index to landmark y dimension

% Place a delta function at the landmark's location in allocentric space.
f.x(landmarkIDX.x) = 1;                                                     
f.y(landmarkIDX.y) = 1;    

% Train the robot by leading it from the origin to the landmark. Build a
% working memory representation for both x and y coordinates.
robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'x');
[f_tilde_x,x_star] = robot.estimateInverseLaplace('x');
robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'y');
[f_tilde_y,y_star] = robot.estimateInverseLaplace('y');

% Inform the robot of a via point, a random point uniformly distributed 
% between [0,2] for each dimension within the [2 x 2] grid world.
%viaPoint = 2*rand(1,2);
viaPoint = [1.72, 0.20];

% Calculate velocity vector estimate to via point: (x,y)-(u,v). To do this
% we need to form a representation for the via point within the robot's
% working memory. 

% landmarkIDX.x = getIndexToLandmark(viaPoint(1),nSamples.x,dimWidth.x);    % index to landmark x dimension
% landmarkIDX.y = getIndexToLandmark(viaPoint(2),nSamples.y,dimWidth.y);    % index to landmark x dimension
% f.x(landmarkIDX.x) = 1;                                                     
% f.y(landmarkIDX.y) = 1;    

% robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'x');
% [f_tilde_x,x_star] = robot.estimateInverseLaplace('x');

% Move to the via point

% Calculate velocity vector estimate back to origin

% Move back to origin

% Translate
delta = 0.5; % seconds
robot = robot.translateLaplaceRepresentation(delta,'x','currentPos');
[f_tilde_tran_x,~] = robot.estimateInverseLaplace('x');

% Init and call display functions
display.f_tilde = f_tilde_x;
display.f_tilde_tran = f_tilde_tran_x;
display.indAxis = indAxis.x;
display.estIndAxis = x_star;
displayFunctions(display,robot,'x');