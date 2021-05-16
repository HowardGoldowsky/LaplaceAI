README for LaplaceAI repository

All code is heavily commented.

To run the code and get output, place all of the below files into your MATLAB path and type "laplaceWorld" at the command line. The code is currently set up to run k=10. To run a loop over different values of k, uncomment lines 19, 20, and 106. The code will output for all values of k from 4:2:26. The main script contains parameters for the Laplace inverse transform estimate like Ck, k, and s. The script initScenario.m contains initializations that should not be touched, other than the display flags for what gets plotted when the main script ends. 

The files for this project include the following:

initScenario.m: initializes the environment's parameters and display flags.

laplaceWorld.m: The main program script. It will run out of the box.

Agent.m: The agent class. Contains all methods for the agent to compute its navigation.

displayFunctions.m: Displays various output, based on the flags set in initScenario.

getIndexToLandmark.m: Converts the analog distance within the room to a discrete sample number for the discrete representation of distance.

WorkingMemory.m: Class that contains a property called laplaceRep, which is the robot's memory. Property of the Agent class. 

