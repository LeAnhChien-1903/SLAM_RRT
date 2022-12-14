function pose = initPose(sim, clientID, motorLeft, motorRight, center, original)
for i = 1:2
    sim.simxSetJointTargetVelocity(clientID, motorLeft, 0.1, sim.simx_opmode_blocking);
    sim.simxSetJointTargetVelocity(clientID, motorRight, 0.1, sim.simx_opmode_blocking);
    pose = getCurrentPose(sim, clientID, center, original);
    pause(0.01);
end
sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
end