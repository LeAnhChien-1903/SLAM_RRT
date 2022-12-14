function [x, y, theta] = getCurrentPose(sim, clientID, center, original)
[~, position] = sim.simxGetObjectPosition(clientID, center, original, sim.simx_opmode_streaming );
[~, euler] = sim.simxGetObjectOrientation(clientID, center, original, sim.simx_opmode_streaming);
theta = euler(3);
x = position(1);
y = position(2);
end