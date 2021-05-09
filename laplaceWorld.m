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

for k=2:2:16
% Initialize scenario
[indAxis,f,display,nSamples,dimWidth,telem] = initScenario();  

% Initialize Agent
numCellsEC = 100;                                       % number of cells in agent's Entorhinal Cortex (EC), the Laplace domain
%k = 10;                                                 % used for calc of inverse Laplace; k = 4 was used in the cited paper
Ck = .072*(1:k);                                        % Initialize Ck for Post 1930 estimate of inverse Laplace transform
robot = Agent(k,Ck,numCellsEC,nSamples);                % construct the virtual robot agent

% Place the initial landmark in continuous space and calculate its index in
% discrete space.
trainingPoint = [0.25, 0.50];                                                   % position of the landmark from origin (meters)
telem.truth = [telem.truth; trainingPoint];                                % build telemetry log
landmarkIDX.x = getIndexToLandmark(trainingPoint(1),nSamples.x,dimWidth.x);     % index to landmark x dimension
landmarkIDX.y = getIndexToLandmark(trainingPoint(2),nSamples.y,dimWidth.y);     % index to landmark y dimension

% Place a delta function at the landmark's location in allocentric space.
f.x(landmarkIDX.x) = 1;                                                     
f.y(landmarkIDX.y) = 1;    

% Train the robot by leading it from the origin to the landmark. Build a
% working memory representation for both x and y coordinates.
robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'x','currentPos');
[f_current_x,x_star_current] = robot.estimateInverseLaplace('x','currentPos');
robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'y','currentPos');
[f_current_y,y_star_current] = robot.estimateInverseLaplace('y','currentPos');

% Take argmax of inverse representation and subtract that from the distance
% to the maze wall boundary to compute the robot's estimated location.
estTrainPosX = dimWidth.x - x_star_current(max(f_current_x)==f_current_x);      % distance from maze wall boundary in x-direction
estTrainPosY = dimWidth.y - y_star_current(max(f_current_y)==f_current_y);      % distance from maze wall boundary in y-direction
telem.robot = [telem.robot; [estTrainPosX,estTrainPosY]];

%telem.agent = [telem.truth;trainingPoints];                                    % build telemetry log

% Inform the robot of a via point, a random point uniformly distributed 
% between [0,2] for each dimension within the [2 x 2] grid world.
%viaPoint = 2*rand(1,2);
viaPoint = [1.75, 0.75];
telem.truth = [telem.truth; viaPoint];  

% Calculate velocity vector estimate to via point: (x,y)-(u,v). To do this
% we need to first form a representation for the via point within the robot's
% working memory. 
landmarkIDX.x = getIndexToLandmark(viaPoint(1),nSamples.x,dimWidth.x);          % index to landmark x dimension
landmarkIDX.y = getIndexToLandmark(viaPoint(2),nSamples.y,dimWidth.y);          % index to landmark x dimension
f.x = zeros(nSamples.x,1);                                                      % init external driving function; see Equation 2
f.y = zeros(nSamples.y,1);                                                      % init external driving function; see Equation 2
f.x(landmarkIDX.x) = 1;                                                     
f.y(landmarkIDX.y) = 1;    

% Next build the via point Laplace representation.
robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'x','futurePos');
[f_future_x,x_star_future] = robot.estimateInverseLaplace('x','futurePos');
robot = robot.buildLaplaceRepresentation(indAxis,f,landmarkIDX,'y','futurePos');
[f_future_y,y_star_future] = robot.estimateInverseLaplace('y','futurePos');

% Calculate velocity vector to via point by performing a cross-correlation
% in the Laplace domain between the robot's current position and future
% imagined position.
G = robot.futurePos.laplaceRep.x;
robot = robot.crossCorrLaplaceRepresentation('x','currentPos',G);
[f_via_x,x_star_via] = robot.estimateInverseLaplace('x','currentPos');
H = robot.futurePos.laplaceRep.y;
robot = robot.crossCorrLaplaceRepresentation('y','currentPos',H);
[f_via_y,y_star_via] = robot.estimateInverseLaplace('y','currentPos');

estDistToU = x_star_via(max(f_via_x)==f_via_x);
estDistToV = y_star_via(max(f_via_y)==f_via_y);

estViaPosX = estTrainPosX + estDistToU;
estViaPosY = estTrainPosY + estDistToV;
telem.robot = [telem.robot; [estViaPosX,estViaPosY]];

% Change the current position by using the translation operator.
% delta = 0.5; % seconds
% robot = robot.translateLaplaceRepresentation(delta,'x','currentPos');
% [f_current_tran_x,~] = robot.estimateInverseLaplace('x','currentPos');

% Init display params and call display functions
% display.indAxis = indAxis.x;                            % Laplace representation display 
% 
% display.f_tilde = f_via_x;                          % Inverse Laplace representation display
% display.estIndAxis = x_star_via;

display.telem = telem;
displayFunctions(display,robot,'x','currentPos');       % call display function

end % for k
           