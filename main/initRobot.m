function [motorLeft, motorRight, center, original] = initRobot(sim, clientID)
[~, motorLeft] = sim.simxGetObjectHandle(clientID,'/leftMotor',sim.simx_opmode_blocking );
[~, motorRight] = sim.simxGetObjectHandle(clientID,'/rightMotor',sim.simx_opmode_blocking);
[~, center] = sim.simxGetObjectHandle(clientID,'/center',sim.simx_opmode_blocking);
[~, original] = sim.simxGetObjectHandle(clientID,'/original',sim.simx_opmode_blocking);
end