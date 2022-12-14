function [wL, wR] = velocityFeedback(sim, clientID, motorLeft, motorRight)
[~, wL] = sim.simxGetObjectFloatParameter(clientID, motorLeft, sim.sim_jointfloatparam_velocity, sim.simx_opmode_streaming);
[~, wR] = sim.simxGetObjectFloatParameter(clientID, motorRight, sim.sim_jointfloatparam_velocity, sim.simx_opmode_streaming);
end